// The client: requests over plain HTTP/1.1 on fibers, with a connection pool per scheduler.
//
//     api: Client;
//     api.base_url = "http://localhost:8080";
//
//     user, error := get_json(*api, User, "/users/1");
//     if error.kind != .NONE print("%\n", error_text(error));
//
//     created, error := post_json(*api, User, "/users", New_User.{ name = "Ada" });
//
//     response, error := send(*api, .{ method = .PUT, url = "/users/1", body = bytes });
//
// Every call takes the `Client` it goes through. A zeroed `Client` is a working one (no base URL,
// TCP, 30 seconds), so `api: Client;` is all a one-off script needs. A call made outside `Io.io_run` runs a scheduler of its own for
// that one call, so a script needs no setup; inside a scheduler it runs on the calling fiber and
// only that fiber waits. Idle connections are kept for the next request to the same host, so
// repeated calls on one scheduler reuse a TCP connection. `https://` is not supported yet and
// says so.
//
// A client's `transport` decides how it reaches a server. The default opens TCP connections;
// `test_client` (testing.jai) connects to an `App` in memory, so the same calls drive an
// application without a socket.

// A request. Only `url` is needed; `.{ url = "http://..." }` is a GET.
Client_Request :: struct {
    method := Method.GET;

    // `http://host[:port]/path?query`, or `/path?query` relative to the client's `base_url`.
    url: string;
    headers: [] Header_Field; // `Host`, `Content-Length` and `User-Agent` are added when missing
    body: [] u8;

    // Milliseconds for the whole exchange, redirects included (0: no limit, -1: the client's
    // `timeout`).
    timeout := -1;

    // Follow 301, 302, 303, 307 and 308 up to this many times (more is an error), or not at all
    // when 0: the 3xx response is returned. -1 is the client's `max_redirects`. 301, 302 and 303
    // turn a POST into a GET without a body; 307 and 308 repeat the request. `Authorization`
    // and `Cookie` are not sent to another host.
    max_redirects := -1;

    // The largest response body accepted, in bytes.
    max_response_size := 64 * 1024 * 1024;
}

// A response, with everything it holds in one allocation. `free_response` releases it.
//
// A call that got no response at all (the connection failed, a timeout) still returns one beside
// its error: `status` is 0 and `reason` says what went wrong, so code that only keeps the
// response can still name the request. Free it like any other.
Client_Response :: struct {
    status: int;
    reason: string;
    headers: [] Header_Field;
    body: [] u8;

    // The request this answers, as it was given: the method, the URL (possibly relative) and the
    // first bytes of its body (`request_body_size` is the full size).
    method: Method;
    url: string;
    request_body: string;
    request_body_size: int;

    storage: *void;
}

// How a client reaches a server. Both procedures run on a fiber of the running scheduler.
Transport :: struct {
    // Passed to both procedures; connections made through one transport are only reused by it.
    data: *void;

    // Where a relative URL points (`"http://localhost:8080"`); null: the client needs a
    // `base_url` for relative URLs.
    base: #type (data: *void) -> string;

    // A new connection for `url` (its scheme, host and port); null: a TCP connection to the host.
    open: #type (data: *void, url: Url) -> Stream, Io.Io_Error;
}

// What requests have in common.
Client :: struct {
    // Relative request URLs (`/users/1`) are joined to this: `"http://localhost:8080"`.
    base_url: string;

    // Sent with every request that does not set the header itself (an `Authorization` token).
    headers: [..] Header_Field;

    // Milliseconds for a request that does not set its own `timeout`.
    timeout := 30_000;

    // Redirects followed for a request that does not set its own `max_redirects` (0: none).
    max_redirects := 10;

    transport: Transport;
}

// Pool settings, for the whole program. Idle connections are closed when they have waited
// `idle_timeout` milliseconds or when more than `max_idle_per_host` pile up for one host.
Client_Settings :: struct {
    max_idle_per_host := 8;
    idle_timeout := 30_000;
    user_agent := "jaic-http";
}

client_settings: Client_Settings;

// A header sent with every request of `client` that does not set it: `set_header(*api,
// "Authorization", "Bearer abc")`. Setting a name again replaces the value.
set_header :: (client: *Client, name: string, value: string) {
    for client.headers {
        if equal_nocase(it.name, name) {
            free(it.value.data);

            client.headers[it_index].value = copy_string(value);

            return;
        }
    }

    header: Header_Field;

    header.name = copy_string(name);
    header.value = copy_string(value);
    header.id = lookup_header_name(name);

    array_add(*client.headers, header);
}

// Takes a default header off again.
remove_header :: (client: *Client, name: string) {
    for client.headers {
        if equal_nocase(it.name, name) {
            free(it.name.data);
            free(it.value.data);

            array_ordered_remove_by_index(*client.headers, it_index);

            return;
        }
    }
}

// The value of the first header called `name` (any case).
header :: (response: *Client_Response, name: string) -> string, bool {
    return find_header(response.headers, name);
}

// The body as text (a view of the same bytes).
body_text :: (response: *Client_Response) -> string {
    return string.{ response.body.count, response.body.data };
}

// The bytes of `text` (the same memory), for a request's `body`.
bytes_of :: (text: string) -> [] u8 {
    return .{ text.count, text.data };
}

free_response :: (response: *Client_Response) {
    if response.storage free(response.storage);

    response.* = .{};
}

// Releases the strings an error from the client holds (`detail`, `body`).
free_error :: (error: *Http_Error) {
    if error.owned {
        if error.title.count free(error.title.data);
        if error.detail.count free(error.detail.data);
        if error.body.count free(error.body.data);
    }

    error.* = .{};
}

// Sends `request` and returns the response, whatever its status: a 404 is a response, not an
// error. Errors are only about not getting one: the URL, the connection, a timeout, a reply that
// is not HTTP, too many redirects.
send :: (client: *Client, request: Client_Request) -> Client_Response, Http_Error {
    if Io.in_scheduler() return send_on_fiber(client, request);

    // No scheduler yet: run one for this call.
    call: Outside_Call;

    call.client = client;
    call.request = request;

    Io.io_run(run_outside_call, *call);

    return call.response, call.error;
}

// `GET` with no body; the response whatever its status.
get :: (client: *Client, url: string, headers: [] Header_Field = .[]) -> Client_Response, Http_Error {
    return send(client, .{ method = .GET, url = url, headers = headers });
}

head :: (client: *Client, url: string, headers: [] Header_Field = .[]) -> Client_Response, Http_Error {
    return send(client, .{ method = .HEAD, url = url, headers = headers });
}

options :: (client: *Client, url: string, headers: [] Header_Field = .[]) -> Client_Response, Http_Error {
    return send(client, .{ method = .OPTIONS, url = url, headers = headers });
}

delete :: (client: *Client, url: string, headers: [] Header_Field = .[]) -> Client_Response, Http_Error {
    return send(client, .{ method = .DELETE, url = url, headers = headers });
}

// `POST` with `value` as a JSON body (`Content-Type: application/json`); the response whatever
// its status. `post(client, url)` sends no body.
post :: (client: *Client, url: string, value: $V, headers: [] Header_Field = .[]) -> Client_Response, Http_Error {
    return send_with_json(client, .POST, url, value, headers);
}

post :: (client: *Client, url: string, headers: [] Header_Field = .[]) -> Client_Response, Http_Error {
    return send(client, .{ method = .POST, url = url, headers = headers });
}

put :: (client: *Client, url: string, value: $V, headers: [] Header_Field = .[]) -> Client_Response, Http_Error {
    return send_with_json(client, .PUT, url, value, headers);
}

patch :: (client: *Client, url: string, value: $V, headers: [] Header_Field = .[]) -> Client_Response, Http_Error {
    return send_with_json(client, .PATCH, url, value, headers);
}

// `GET url` and the body decoded as a `T`. A status other than 2xx is a `.STATUS` error that
// carries `status`, `title`/`detail` (from a problem+json body when there is one) and `body`.
get_json :: (client: *Client, $T: Type, url: string, headers: [] Header_Field = .[]) -> T, Http_Error {
    request: Client_Request;

    request.url = url;
    request.headers = with_json_headers(headers, false);

    return json_exchange(client, T, request);
}

// `POST` of `value` as JSON; the response body is decoded as a `T`.
post_json :: (client: *Client, $T: Type, url: string, value: $V, headers: [] Header_Field = .[]) -> T, Http_Error {
    return json_with_body(client, T, .POST, url, value, headers);
}

put_json :: (client: *Client, $T: Type, url: string, value: $V, headers: [] Header_Field = .[]) -> T, Http_Error {
    return json_with_body(client, T, .PUT, url, value, headers);
}

patch_json :: (client: *Client, $T: Type, url: string, value: $V, headers: [] Header_Field = .[]) -> T, Http_Error {
    return json_with_body(client, T, .PATCH, url, value, headers);
}

// A request whose response body is not wanted: only whether it worked.
post_json :: (client: *Client, url: string, value: $V, headers: [] Header_Field = .[]) -> Http_Error {
    response, error := send_with_json(client, .POST, url, value, headers);

    defer free_response(*response);

    if error.kind != .NONE return error;

    if response.status < 200 || response.status >= 300 return status_error(*response);

    return .{};
}

delete_request :: (client: *Client, url: string, headers: [] Header_Field = .[]) -> Http_Error {
    response, error := send(client, .{ method = .DELETE, url = url, headers = headers });

    defer free_response(*response);

    if error.kind != .NONE return error;

    if response.status < 200 || response.status >= 300 return status_error(*response);

    return .{};
}

// `GET url` as text.
get_text :: (client: *Client, url: string, headers: [] Header_Field = .[]) -> string, Http_Error {
    response, error := send(client, .{ url = url, headers = headers });

    defer free_response(*response);

    if error.kind != .NONE return "", error;

    if response.status < 200 || response.status >= 300 return "", status_error(*response);

    return copy_string(body_text(*response)), .{};
}

// Closes every idle connection of the running scheduler (they are also closed when it ends).
close_idle_connections :: () {
    pool := client_pool();

    for pool.idle stream_close(it.stream);

    pool.idle.count = 0;
}

// How many idle connections the running scheduler keeps, for tests.
idle_connection_count :: () -> int {
    return client_pool().idle.count;
}

// How many connections the running scheduler has opened, for tests.
connections_opened :: () -> int {
    return client_pool().opened;
}

#scope_module

with_json_headers :: (headers: [] Header_Field, has_body: bool) -> [] Header_Field {
    list: [..] Header_Field;

    for headers array_add(*list, it,, temp);

    accept: Header_Field;

    accept.name = "Accept";
    accept.value = "application/json";
    accept.id = .ACCEPT;

    array_add(*list, accept,, temp);

    if has_body {
        content: Header_Field;

        content.name = "Content-Type";
        content.value = "application/json";
        content.id = .CONTENT_TYPE;

        array_add(*list, content,, temp);
    }

    return list;
}

json_with_body :: (client: *Client, $T: Type, method: Method, url: string, value: $V, headers: [] Header_Field) -> T, Http_Error {
    request: Client_Request;

    request.method = method;
    request.url = url;
    request.headers = with_json_headers(headers, true);

    body := to_json(value,, temp);

    request.body = .{ body.count, body.data };

    return json_exchange(client, T, request);
}

send_with_json :: (client: *Client, method: Method, url: string, value: $V, headers: [] Header_Field) -> Client_Response, Http_Error {
    request: Client_Request;

    request.method = method;
    request.url = url;
    request.headers = with_json_headers(headers, true);

    body := to_json(value,, temp);

    request.body = .{ body.count, body.data };

    return send(client, request);
}

json_exchange :: (client: *Client, $T: Type, request: Client_Request) -> T, Http_Error {
    response, error := send(client, request);

    defer free_response(*response);

    if error.kind != .NONE return .{}, error;

    if response.status < 200 || response.status >= 300 return .{}, status_error(*response);

    value, failure := from_json(T, body_text(*response));

    if failure.kind != .NONE {
        failed := Http_Error.{ kind = .DECODE, status = response.status, owned = true };

        failed.title = copy_string("the response is not the JSON expected");
        failed.detail = copy_string(json_error_text(failure));

        free_json_error(*failure);

        return .{}, failed;
    }

    return value, .{};
}

Problem_Body :: struct @json(default) {
    title: string;
    detail: string;
}

// A non-2xx response as an error: its status, a problem+json `title` and `detail` when it has
// them, and the body.
status_error :: (response: *Client_Response) -> Http_Error {
    error: Http_Error;

    error.kind = .STATUS;
    error.owned = true;
    error.status = response.status;
    error.body = copy_string(body_text(response));
    error.title = copy_string(status_reason(response.status));

    content_type, found := header(response, "Content-Type");

    if found && (media_type_is(content_type, "application/problem+json") || media_type_is(content_type, "application/json")) {
        problem, failure := from_json(Problem_Body, error.body);

        if failure.kind == .NONE {
            if problem.detail.count error.detail = copy_string(problem.detail);

            if problem.title.count {
                free(error.title.data);

                error.title = copy_string(problem.title);
            }

            free_json(*problem);
        } else {
            free_json_error(*failure);
        }
    }

    if error.detail.count == 0 error.detail = copy_string(tprint("the server answered % %", response.status, status_reason(response.status)));

    return error;
}

transport_error :: (kind: Http_Error_Kind, io: Io.Io_Error, what: string) -> Http_Error {
    error: Http_Error;

    error.kind = kind;
    error.owned = true;
    error.transport = io;
    error.detail = copy_string(what);

    return error;
}

// What a call was asked to do, kept for the response that answers it.
Request_Note :: struct {
    method: Method;
    url: string;
    body: [] u8;
}

// A call made with no scheduler running: `send` runs one for it.
Outside_Call :: struct {
    client: *Client;
    request: Client_Request;
    response: Client_Response;
    error: Http_Error;
}

run_outside_call :: (call: *Outside_Call) {
    call.response, call.error = send_on_fiber(call.client, call.request);
}

send_on_fiber :: (client: *Client, request: Client_Request) -> Client_Response, Http_Error {
    note: Request_Note;

    note.method = request.method;
    note.url = request.url;
    note.body = request.body;

    timeout := ifx request.timeout < 0 then client.timeout else request.timeout;

    response: Client_Response;
    error: Http_Error;

    if timeout > 0 {
        previous := Io.set_deadline(timeout);

        response, error = send_following(client, request, note);

        Io.restore_deadline(previous);
    } else {
        response, error = send_following(client, request, note);
    }

    if error.kind != .NONE return build_response(0, error_text(error), .[], .[], note), error;

    return response, .{};
}

// One exchange plus the redirects it leads to.
send_following :: (client: *Client, request: Client_Request, note: Request_Note) -> Client_Response, Http_Error {
    url_text, problem := absolute_url(client, request.url);

    if problem.kind != .NONE return .{}, problem;

    method := request.method;
    body := request.body;
    headers := with_default_headers(client, request.headers);
    redirects := 0;
    limit := ifx request.max_redirects < 0 then client.max_redirects else request.max_redirects;

    while true {
        response, error := exchange(client, method, url_text, headers, body, request.max_response_size, note);

        if error.kind != .NONE return .{}, error;

        redirect := limit > 0 && (response.status == 301 || response.status == 302 || response.status == 303 || response.status == 307 || response.status == 308);

        location, has_location := header(*response, "Location");

        if !redirect || !has_location return response, .{};

        if redirects >= limit {
            free_response(*response);

            return .{}, transport_error(.REDIRECTS, .NONE, tprint("more than % redirects, the last to %", limit, location));
        }

        redirects += 1;

        next := resolve_location(url_text, location);

        if response.status == 303 || ((response.status == 301 || response.status == 302) && method == .POST) {
            if method != .HEAD method = .GET;

            body = .{};
        }

        if !same_origin(url_text, next) headers = without_credentials(headers);

        free_response(*response);

        url_text = next;
    }

    return .{}, .{};
}

// `text` as an absolute URL: a relative one is joined to the client's base URL.
absolute_url :: (client: *Client, text: string) -> string, Http_Error {
    if find_index_from_left(text, "://") > 0 return text, .{};

    base := client.base_url;

    if base.count == 0 && client.transport.base base = client.transport.base(client.transport.data);

    if base.count == 0 {
        return "", transport_error(.INVALID_URL, .NONE, tprint("`%`: it is not an absolute URL such as http://host/path, and the client has no base_url to join it to", text));
    }

    while base.count > 0 && base[base.count - 1] == #char "/" base.count -= 1;

    if text.count == 0 || text[0] == #char "/" return tprint("%%", base, text), .{};

    return tprint("%/%", base, text), .{};
}

// The request's headers and, for every name it does not set, the client's default.
with_default_headers :: (client: *Client, headers: [] Header_Field) -> [] Header_Field {
    if client.headers.count == 0 return headers;

    list: [..] Header_Field;

    for headers array_add(*list, it,, temp);

    for client.headers {
        _, found := find_header(headers, it.name);

        if !found array_add(*list, it,, temp);
    }

    return list;
}

same_origin :: (a: string, b: string) -> bool {
    first, problem_a := parse_url(a);
    second, problem_b := parse_url(b);

    if problem_a != .NONE || problem_b != .NONE return false;

    return equal_nocase(first.host, second.host) && first.port == second.port;
}

without_credentials :: (headers: [] Header_Field) -> [] Header_Field {
    list: [..] Header_Field;

    for headers {
        if equal_nocase(it.name, "Authorization") || equal_nocase(it.name, "Cookie") continue;

        array_add(*list, it,, temp);
    }

    return list;
}

// The URL a `Location` header means, relative to the URL it came with.
resolve_location :: (base: string, location: string) -> string {
    if find_index_from_left(location, "://") > 0 return copy_string(location,, temp);

    url, problem := parse_url(base);

    if problem != .NONE return copy_string(location,, temp);

    origin := tprint("http://%", host_with_port(url));

    if begins_with(location, "//") return tprint("http:%", location);
    if begins_with(location, "/") return tprint("%%", origin, location);

    slash := find_index_from_right(url.path, #char "/");
    directory := slice(url.path, 0, slash + 1);

    return tprint("%%%", origin, directory, location);
}

host_with_port :: (url: Url) -> string {
    host := ifx url.ipv6 then tprint("[%]", url.host) else url.host;

    if url.port == 80 return host;

    return tprint("%:%", host, url.port);
}

// One request on one connection (a pooled one when there is one), and its response.
exchange :: (client: *Client, method: Method, url_text: string, extra: [] Header_Field, body: [] u8, max_response_size: int, note: Request_Note) -> Client_Response, Http_Error {
    url, problem := parse_url(url_text);

    if problem != .NONE {
        if problem == .UNSUPPORTED_SCHEME {
            if equal_nocase(url.scheme, "https") {
                return .{}, transport_error(.UNSUPPORTED, .NONE, tprint("`%`: https is not supported yet, the client speaks plain http (TLS is planned)", url_text));
            }

            return .{}, transport_error(.INVALID_URL, .NONE, tprint("`%`: the scheme `%` is not supported, use http", url_text, url.scheme));
        }

        what := ifx problem == .NOT_A_URL then "it is not an absolute URL such as http://host/path"
                else ifx problem == .NO_HOST then "it names no host"
                else ifx problem == .BAD_PORT then "the port is not a number up to 65535"
                else "the host is not valid";

        return .{}, transport_error(.INVALID_URL, .NONE, tprint("`%`: %", url_text, what));
    }

    headers: [..] Header_Field;

    host_given := false;
    agent_given := false;

    for extra {
        if it.id == .HOST host_given = true;
        if it.id == .USER_AGENT agent_given = true;

        array_add(*headers, it,, temp);
    }

    if !host_given {
        host: Header_Field;

        host.name = "Host";
        host.value = host_with_port(url);
        host.id = .HOST;

        array_add(*headers, host,, temp);
    }

    if !agent_given {
        agent: Header_Field;

        agent.name = "User-Agent";
        agent.value = client_settings.user_agent;
        agent.id = .USER_AGENT;

        array_add(*headers, agent,, temp);
    }

    method_text := method_name(method);

    idempotent := method == .GET || method == .HEAD || method == .PUT || method == .DELETE || method == .OPTIONS;

    attempt := 0;

    while true {
        stream, reused, error := checkout(client, url);

        if error.kind != .NONE return .{}, error;

        response, reply_started, failure := converse(client, stream, method, method_text, url, headers, body, max_response_size, note);

        if failure.kind == .NONE return response, .{};

        stream_close(stream);

        // A pooled connection the server closed while it sat idle fails before any answer came:
        // that is not the request's fault, so try once more on a fresh connection.
        if reused && !reply_started && idempotent && attempt == 0 && failure.kind == .TRANSPORT {
            attempt += 1;

            continue;
        }

        return .{}, failure;
    }

    return .{}, .{};
}

// Writes the request and reads the response on `stream`. The stream goes back to the pool when
// it can carry another request. `reply_started` says whether any byte of an answer arrived.
converse :: (client: *Client, stream: Stream, method: Method, method_text: string, url: Url, headers: [] Header_Field, body: [] u8, max_response_size: int, note: Request_Note) -> Client_Response, reply_started: bool, Http_Error {
    out: [..] u8;

    defer array_reset(*out);

    _, ok := write_request_head(*out, method_text, url.target, headers, body.count);

    if !ok {
        return .{}, false, transport_error(.INVALID_URL, .NONE, "a request header is not valid (a bad name or value, or one that sets the framing itself)");
    }

    append_bytes(*out, body.data, body.count);

    _, write_error := stream_write(stream, out);

    if write_error != .NONE return .{}, false, io_failure(write_error, "sending the request");

    parser: Parser;

    limits: Limits;

    limits.max_body_size = max_response_size;

    parser_init(*parser, .RESPONSE, limits);

    parser.response_to = method;

    defer parser_free(*parser);

    buffer := NewArray(16 * 1024, u8);

    defer free(buffer.data);

    collected: [..] u8;

    defer array_reset(*collected);

    status := 0;
    reason: string;
    headers_list: [..] Header_Field;
    keep_alive := false;
    started := false;
    finished := false;

    defer array_reset(*headers_list);

    while !finished {
        count, read_error := stream_read(stream, buffer);

        if read_error != .NONE return .{}, started, io_failure(read_error, "reading the response");

        if count == 0 {
            event := parse_eof(*parser);

            if event.kind == .END {
                finished = true;

                break;
            }

            return .{}, started, transport_error(.TRANSPORT, .END_OF_FILE, "the server closed the connection before the response was complete");
        }

        started = true;

        data: [] u8 = .{ count, buffer.data };

        while !finished {
            used, event := parse(*parser, data);

            data = advance(data, used);

            if event.kind == .NEED_MORE break;

            if event.kind == .HEAD {
                if parser.head.informational continue;

                status = parser.head.status;
                keep_alive = parser.head.keep_alive;
                reason = parser.head.reason;

                // The head's strings die with the parser's next message: keep copies.
                headers_list.count = 0;

                for parser.head.headers array_add(*headers_list, it);

                continue;
            }

            if event.kind == .BODY {
                append_bytes(*collected, event.data.data, event.data.count);

                continue;
            }

            if event.kind == .END {
                if status == 0 continue;

                finished = true;

                break;
            }

            if event.kind == .ERROR {
                return .{}, started, transport_error(.TRANSPORT, .INVALID, tprint("the response is not valid HTTP: %", parser.error.message));
            }

            if event.kind == .SWITCHED {
                return .{}, started, transport_error(.TRANSPORT, .INVALID, "the server switched protocols, which the client does not do");
            }
        }
    }

    response := build_response(status, reason, headers_list, collected, note);

    if keep_alive && parser.head.body != .UNTIL_CLOSE {
        checkin(client, url, stream);
    } else {
        stream_close(stream);
    }

    return response, true, .{};
}

io_failure :: (error: Io.Io_Error, what: string) -> Http_Error {
    if error == .TIMED_OUT || error == .CANCELED {
        return transport_error(.TIMEOUT, error, tprint("timed out while %", what));
    }

    return transport_error(.TRANSPORT, error, tprint("%: %", what, error));
}

REQUEST_BODY_KEPT :: 256;

// One allocation for the headers, their text, the reason, the body and the request's summary.
build_response :: (status: int, reason: string, headers: [] Header_Field, body: [] u8, note: Request_Note) -> Client_Response {
    kept := min(note.body.count, REQUEST_BODY_KEPT);
    size := headers.count * size_of(Header_Field) + reason.count + body.count + note.url.count + kept + 16;

    for headers size += it.name.count + it.value.count;

    memory := cast(*u8) alloc(size);

    response: Client_Response;

    response.status = status;
    response.storage = memory;

    cursor := memory;

    list := cast(*Header_Field) cursor;

    cursor += headers.count * size_of(Header_Field);

    take :: (text: string, cursor: **u8) -> string #expand {
        result: string;

        result.data = cursor.*;
        result.count = text.count;

        memcpy(cursor.*, text.data, text.count);

        cursor.* += text.count;

        return result;
    }

    for headers {
        list[it_index].name = take(it.name, *cursor);
        list[it_index].value = take(it.value, *cursor);
        list[it_index].id = it.id;
    }

    response.headers = .{ headers.count, list };
    response.reason = take(reason, *cursor);
    response.method = note.method;
    response.url = take(note.url, *cursor);
    response.request_body = take(string.{ kept, note.body.data }, *cursor);
    response.request_body_size = note.body.count;

    response.body.data = cursor;
    response.body.count = body.count;

    memcpy(cursor, body.data, body.count);

    return response;
}

// ---------------------------------------------------------------------------------------------
// The connection pool

Pool_Entry :: struct {
    host: string;
    port: u16;
    owner: *void; // the transport's data: a connection is only reused by the transport that made it
    stream: Stream;
    since: s64;
}

Client_Pool :: struct {
    idle: [..] Pool_Entry;
    opened: int;
}

pool_key: s32;

client_pool :: () -> *Client_Pool {
    pool := cast(*Client_Pool) Io.scheduler_local(*pool_key);

    if pool return pool;

    pool = New(Client_Pool);

    Io.set_scheduler_local(*pool_key, pool, drop_pool);

    return pool;
}

drop_pool :: (value: *void) {
    pool := cast(*Client_Pool) value;

    for pool.idle {
        stream_close_now(it.stream);
        free(it.host.data);
    }

    array_reset(*pool.idle);
    free(pool);
}

// A connection to the URL's host: an idle one from the pool, or a new one.
checkout :: (client: *Client, url: Url) -> Stream, reused: bool, Http_Error {
    pool := client_pool();
    now := now_ms();
    owner := client.transport.data;

    // Newest first; connections that waited too long are closed on the way.
    index := pool.idle.count - 1;

    while index >= 0 {
        entry := pool.idle[index];

        if now - entry.since > client_settings.idle_timeout {
            drop_entry(pool, index);
        } else if entry.owner == owner && entry.port == url.port && entry.host == url.host {
            stream := entry.stream;

            free(entry.host.data);
            array_ordered_remove_by_index(*pool.idle, index);

            return stream, true, .{};
        }

        index -= 1;
    }

    stream: Stream;
    error: Io.Io_Error;

    if client.transport.open {
        stream, error = client.transport.open(owner, url);
    } else {
        tcp: Io.Tcp_Stream;

        tcp, error = Io.connect(url.host, url.port);

        stream = tcp_stream(tcp);
    }

    if error != .NONE {
        return .{}, false, io_failure(error, tprint("connecting to %:%", url.host, url.port));
    }

    pool.opened += 1;

    return stream, false, .{};
}

drop_entry :: (pool: *Client_Pool, index: int) {
    entry := pool.idle[index];

    stream_close(entry.stream);
    free(entry.host.data);
    array_ordered_remove_by_index(*pool.idle, index);
}

checkin :: (client: *Client, url: Url, stream: Stream) {
    pool := client_pool();
    owner := client.transport.data;

    count := 0;

    for pool.idle {
        if it.owner == owner && it.port == url.port && it.host == url.host count += 1;
    }

    // Too many for this host: the oldest one goes.
    while count >= client_settings.max_idle_per_host {
        for pool.idle {
            if it.owner == owner && it.port == url.port && it.host == url.host {
                drop_entry(pool, it_index);
                count -= 1;

                break;
            }
        }
    }

    if client_settings.max_idle_per_host <= 0 {
        stream_close(stream);

        return;
    }

    entry: Pool_Entry;

    entry.host = copy_string(url.host);
    entry.port = url.port;
    entry.owner = owner;
    entry.stream = stream;
    entry.since = now_ms();

    array_add(*pool.idle, entry);
}
