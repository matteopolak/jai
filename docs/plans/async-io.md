# Async IO, HTTP and JSON plan

Status: agreed design, nothing built yet.

## Where we are

- `File_Async` is not async IO in the io_uring sense. It is a queue plus a worker thread that makes ordinary blocking `read`/`write` calls, with an API shaped like the official module's. It does only files.
- `Socket` wraps the BSD/Winsock calls. There is no event loop, no fiber or coroutine support, and no JSON module in `stdlib/`.
- What we have to build on:
  - `syscall` through libc, with numbers 425-427 for io_uring already in `POSIX/bindings/linux/syscall.jai`;
  - `mmap`, threads and `#asm`;
  - `Atomics`, now with ordered loads, stores, exchanges and fetch operations ([atomics](../specs/stdlib/README.md));
  - the interpreter's cooperative thread scheduler, which already switches between separate stacks.

## Decisions so far

- **Modules:** `Extensions/Io`, `Extensions/Io_Uring`, `Extensions/Http` and `Extensions/Json`.
- **One way to do things:** user code waits with **fibers** and ordinary-looking blocking calls. There is no callback API and no public completion-queue API alongside it. The engine underneath is internal.
  - `Io_Uring`, like `POSIX`, stays a public OS binding. It is not a second IO API.
- **Platforms:** code written against `Io` runs unchanged on every platform and kernel. Backend choice and feature fallbacks are internal, and nobody writes per-platform or per-version code.
- **io_uring floor: Linux 6.1.** Everything v1 uses exists by 6.1, and newer features are probed at startup. Below 6.1, or where io_uring is disabled (RHEL 9 by default, many containers), the loop uses epoll.
- **Windows:** completion ports for sockets. The Windows 11 `IoRing` API is used for files where it exists (22H2+), with completion ports as the fallback.
- **HTTP:** a server, plus a client that is also used to test the server. Both are HTTP/1.0, 1.1 and 2.
- **JSON:** typed and generated at compile time from struct types, with serde-style attributes as notes, built in to the server and client.
- **Routing:** path templates are parsed at compile time, and handlers take generic extractors (`Path("id", int)`, `Json(T)`, `Query(T)`, …) that are checked against the template.
- **TLS:** deferred, but planned.

## Layers

```
Http   (server + client: routing, extractors, JSON, errors; sans-IO codecs underneath)
Json   (typed, compile-time generated; usable on its own)
Io     (public: fibers, scheduler, tcp/udp/files/timers/channels; internal: the completion engine)
 |- io_uring          Linux >= 6.1
 |- epoll             older Linux, io_uring disabled
 |- kqueue            macOS, BSD
 |- IOCP + IoRing     Windows (IoRing for files on 11 22H2+)
 '- thread pool       files where the OS has no async file IO (macOS, epoll hosts)
Io_Uring, plus private Epoll/Kqueue/Iocp bindings
```

## Fibers

A fiber is a lightweight thread that the program switches itself. Each one has its own small stack.

When a fiber calls `read`, the scheduler queues the IO on the thread's ring, saves the fiber's registers and runs another fiber. When the completion arrives, it switches back. To the user, `read` just returns.

```jai
#import "Io";

handle :: (conn: Tcp_Stream) {
    defer close(conn);
    buffer: [4096] u8;

    while true {
        n, err := read(conn, buffer);
        if err || n == 0 return;

        write(conn, .{ n, buffer.data });
    }
}

main :: () {
    io_run(() {                          // starts the scheduler on this thread (and workers)
        listener := tcp_listen(":8080");

        while true {
            conn := accept(listener);
            spawn(handle, conn);
        }
    });
}
```

Design:

- **Switching:** one `fiber_switch(from, to)` primitive. It saves and restores callee-saved registers and the stack pointer:
  - x64 SysV;
  - Win64, which also needs xmm6-15 and the TIB stack bounds;
  - arm64 (AAPCS64 and Windows).

  It is a jaic intrinsic rather than a library `#asm` block, so the interpreter can implement it with the stack machinery it already uses for threads. That keeps `jaic run` fully working.
- **Stacks:** each fiber gets an `mmap`/`VirtualAlloc` stack with a guard page.
  - 256 KiB of address space by default, committed lazily by the OS, so 10k fibers cost little real memory.
  - Stacks are pooled.
  - Overflowing hits the guard page and crashes with a "fiber stack overflow" message instead of corrupting memory.
- **`context`:** each fiber gets its own copy of the spawning context, including its own temporary storage that is reset when the fiber ends. Stack traces and allocators behave as on a thread.
- **Scheduler:** one per OS thread, each with its own ring.
  - `io_run` starts N threads (default: the core count, or 1 under `jaic run`).
  - Listeners use `SO_REUSEPORT` so each thread accepts its own connections.
  - Fibers stay on the thread they started on in v1 (no work stealing). This avoids most cross-thread bugs, and work stealing can be added later without API changes.
- **Coordination:** fiber-aware `Channel(T)`, `Wait_Group`, `Fiber_Mutex`, `sleep`, `yield` and `spawn`.
  - Ordinary `Thread` mutexes still work but block the whole OS thread, which the docs will say.
- **Cancellation and timeouts:**
  - `cancel(fiber)` makes its current and future IO return `.CANCELED`;
  - `with_deadline(ms) { ... }` applies a timeout to every IO call in the block.

  Both map to io_uring cancel and linked timeouts, and are emulated elsewhere.
- **Blocking calls inside fibers:** `read_entire_file` from `File` would block the whole thread. `Io` provides fiber versions (`read_file`, `write_file`, `stat`, …). Plain `File` stays as it is.
- **wasm:** wasm can't switch stacks yet, and WASI preview 1 has no sockets. `Io` fails at compile time on wasm with a clear message. Later options are an Asyncify-style transform in our wasm backend, or the wasm stack-switching proposal once it ships.

## The internal engine

The completion engine stays internal to `Io`. These rules make sure new io_uring features never need API changes:

1. **Mirror the kernel in `Io_Uring`.** Structs and constants are generated from a pinned `linux/io_uring.h`, with layout asserts (SQE 64/128, CQE 16/32). Updating the header only adds things.
2. **Capabilities, not versions.** Each backend probes at startup (`IORING_REGISTER_PROBE`, `params.features`) and fills a capability set. Operations degrade transparently, for example multishot recv becomes a re-armed recv. A missing feature is never an error.
3. **Completions are already general:** a result, a portable error plus the raw platform code, a `more` flag (multishot), a buffer id (provided buffers) and notification flags (zero-copy send).
4. **Handles are opaque:** an fd, SOCKET, HANDLE or io_uring direct-descriptor index, plus a kind tag.
5. **Buffers belong to the operation until its completion arrives,** even after cancel. Provided-buffer rings are used where present, and a freelist elsewhere.
6. **Ring setup:** one ring per thread, with `SINGLE_ISSUER | DEFER_TASKRUN | COOP_TASKRUN`. Cross-thread wakeups use `MSG_RING`, eventfd, `EVFILT_USER` or `PostQueuedCompletionStatus`.
7. **Fallback:** `JAI_IO_BACKEND=epoll|kqueue|iocp|threads` forces a backend for tests. If io_uring setup fails, the engine falls back to epoll and records why.
8. **Errors:** `Io_Error` is a portable enum with an `OTHER` member, plus `platform_code`, so new kernel errors never break callers.

Users only ever see fibers and the blocking-style calls, so all of this can change freely.

## JSON (`Extensions/Json`)

Encoders and decoders are generated at compile time from `Type_Info`, so there is no runtime reflection walk on the hot path. Attributes follow serde's, written as Jai notes. A note ends at the first whitespace and goes after the member's `;`, so options are comma-separated with no spaces.

```jai
User :: struct @json(rename_all=camelCase) {
    id: int;
    display_name: string;                   // "displayName"
    email: string;          @json(skip_serializing_if=empty)
    password_hash: string;  @json(skip)
    created_at: string;     @json(rename=created,alias=createdAt)
    role := Role.MEMBER;    @json(default)  // missing -> keeps the default
    address: Address;       @json(flatten)  // its fields are inlined into User's object
    tags: [..] string;
    spent: Money;           @json(with=money_json)  // custom encode/decode procedures
}

Signup :: struct @json(deny_unknown_fields) { name: string; email: string; }

text := to_json(user);                              // uses `context.allocator`; to_json(user, pretty = true)
user, err := from_json(User, text);                 // Json_Error { message, line, column, path = "tags[2]" }
value, err := parse_json(text);                     // untyped Json_Value when the shape is unknown
```

First set of attributes (serde's most used ones; more can be added later without breaking anything):

| Attribute | On | Meaning |
|---|---|---|
| `rename=x` | field | the JSON key is `x` |
| `rename_all=camelCase` (or `snake_case`, `kebab-case`, `PascalCase`, `SCREAMING_SNAKE_CASE`, `lowercase`) | struct | rule for every field without its own `rename` |
| `alias=x` | field | also accept `x` when decoding |
| `skip` / `skip_serializing` / `skip_deserializing` | field | leave it out in both directions, or in one |
| `skip_serializing_if=empty` (or `=zero`, `=null`) | field | omit it when it has that value |
| `default` | field | a missing key keeps the member's initializer (otherwise a missing key is an error that names it) |
| `default` | struct | every field is optional |
| `deny_unknown_fields` | struct | unknown keys are an error (by default they are ignored) |
| `flatten` | struct field | its fields are inlined into the parent object |
| `with=proc_prefix` | field | `proc_prefix_encode` / `proc_prefix_decode` do this field |
| `transparent` | struct with one field | encodes as that field alone (newtypes) |

- **Types:**
  - all integer and float types, with exact integers and shortest round-trip floats;
  - bool and string;
  - enums by member name, or by value with `@json(as_number)` on the field;
  - structs, plus fixed, view and dynamic arrays;
  - `Hash_Table(string, T)` as an object;
  - pointers (`null` for none) and `Json_Value`.
- **Later:** serde-style tagged unions (external, internal, adjacent and untagged) over `Tagged_Union`.
- **A limitation:** enum types carry no notes in `Type_Info`, so enum renaming is configured on the field that uses it (`@json(rename_all=lowercase)` there), not on the enum.
- **Strictness:** strict RFC 8259 parsing, with surrogate pairs checked, no trailing commas, and depth and size limits.
- **Tests:** JSONTestSuite (nst, MIT), all the `y_`, `n_` and `i_` cases, plus round-trip fuzzing.

## HTTP (`Extensions/Http`)

### Server

The path template is parsed at compile time. Handlers say what they want with generic extractor types, and the router checks every extractor against the template when the route is registered. Asking for something the template doesn't have is a compile error.

```jai
#import "Http";

User :: struct { id: int; name: string; }
New_User :: struct { name: string; }
Search :: struct @json(default) { q: string; limit := 20; }
Post_Key :: struct { user: int; post: string; }

get_user :: (id: Path("id", int)) -> User, Http_Error {
    user, found := find_user(id.value);
    if !found return .{}, not_found("No user with id %", id.value);

    return user, .{};
}

create_user :: (body: Json(New_User)) -> User, Http_Error {
    if !body.name return .{}, bad_request("name is required");   // Json(T) has `using value: T`

    return insert_user(body.name), .{};
}

get_post :: (key: Params(Post_Key), search: Query(Search), request: *Request) -> [] Post, Http_Error { ... }

main :: () {
    app: App;
    get(*app, "/users/{id}", get_user);
    post(*app, "/users", create_user);
    get(*app, "/users/{user}/posts/{post}", get_post);

    admin := group(*app, "/admin", require_token);   // middleware on a group
    delete(admin, "/users/{id}", delete_user);

    serve(*app);                                      // :8080, every core, sensible limits, Ctrl-C drains connections
}
```

**Extractors** are polymorphic structs. Each has a `value`, and struct values are `using`-ed so their fields can be reached directly:

| Extractor | From | Notes |
|---|---|---|
| `Path("id", int)` | one `{id}` segment | any type with a text parser: integers, floats, `string`, enums by name |
| `Params(T)` | several segments | every field of `T` must name a segment (a separate name, because one polymorphic struct can't take both parameter lists) |
| `Rest("path")` | a `{path...}` tail segment | the rest of the path as a `string` |
| `Query(T)` | the query string | decoded into `T` with the same rules and notes as JSON (`default`, `rename`, …) |
| `Json(T)` | the body | `Content-Type: application/json` is required (415 otherwise) |
| `Header("x-request-id", T)` | one header | missing is a 400 unless `T` is a pointer or the extractor is `Header_Optional` |
| `Form(T)` | an urlencoded body | |
| `Bytes` / `Text` | the raw body | |
| `*Request` | everything | method, headers, peer address |
| `*State(T)` | shared app state | set with `app.state = *my_state` |

- **Compile-time checks.** `get :: (app: *App, $template: string, handler: $H)` parses `template` with `#run` into segments. It then walks `H`'s parameters with `type_info`:
  - a `Path("name", T)` whose name is not a `{name}` in the template is a compile error that points at the route;
  - so is a `Params(T)` whose field isn't in the template, and a handler with two body extractors;
  - so is a template with malformed braces or a duplicate `{name}`.

  The extraction code is generated with `#insert`, so nothing is looked up by name at run time.
- **At run time:**
  - a value that doesn't parse, such as `/users/abc` for `Path("id", int)`, is a 400 naming the parameter;
  - a missing or invalid body or query is a 400 (or 415) naming the field (`body.tags[2]: expected a string`).
- **Routing:**
  - a radix-tree router built when the server starts, where static segments win over `{params}`, which win over `{rest...}`;
  - two routes that conflict are reported at startup, with both templates;
  - method mismatches return 405 with `Allow`, and `HEAD`/`OPTIONS` are handled automatically.
- **Responses come from the return value:**
  - `T` is sent as JSON (200, or 201 for POST);
  - `string` as `text/plain`;
  - `[] u8` as `application/octet-stream`;
  - `Response` as-is (built with `json(value, status = 202)`, `text(...)`, `redirect(...)`);
  - nothing as 204.
- **Errors:**
  - Handlers return `Http_Error`, built with `bad_request`, `not_found`, `unauthorized`, `conflict` and so on, or `http_error(status, ...)`. It becomes an RFC 9457 `application/problem+json` response.
  - One `app.on_error` hook can override the format.
  - A panicking handler can't be caught in Jai. Each request runs on its own fiber and the docs say so.
- **Defaults:**
  - limits on header size, body size, requests per connection and idle/header/body timeouts;
  - `Date`/`Server` headers and keep-alive;
  - h2c upgrade and prior knowledge for HTTP/2;
  - graceful shutdown on SIGINT/SIGTERM;
  - access logging off unless enabled.
- **Middleware:** a procedure `(request: *Request, next: Next) -> Response`, for logging, CORS, compression and authentication.

### Client

```jai
user, err := get_json(User, "http://localhost:8080/users/1");
created, err := post_json(User, "http://localhost:8080/users", New_User.{ name = "Ada" });

response, err := send(.{ method = .PUT, url = url, headers = .[ .{ "X-Id", "7" } ], body = bytes });
```

- **Connections:**
  - a per-thread connection pool with keep-alive;
  - HTTP/1.1 and h2c, where h2c is chosen per origin;
  - redirects (limited), timeouts and decompression.
- **Errors:**
  - transport errors, such as connection refused or timeout, are kept separate from non-2xx statuses;
  - `get_json` returns an `Http_Error` that carries the status and body when the response is not 2xx.
- **HTTPS:** deferred. It needs a TLS module, which we'll add later: our own TLS 1.3 (+1.2) if the size is reasonable, or a wrapper over the system libraries (SChannel, Security.framework, OpenSSL). The HTTP layer takes any byte stream, so TLS slots in underneath without API changes.

### Underneath

These are sans-IO codecs, meaning pure state machines over bytes in the style of hyper, httparse and h2. They are tested on their own:

- **HTTP/1:**
  - an incremental parser with zero-copy header slices;
  - strict RFC 9112 framing (CL/TE conflicts, obs-fold and bare CR rejected), which protects against request smuggling;
  - chunked encoding, trailers, pipelining and `100-continue`.
- **HTTP/2:** the frame codec, HPACK, stream states, flow control, and SETTINGS/PING/GOAWAY.
- **Conformance:**
  - llhttp's markdown fixtures (MIT) and http-garden smuggling cases for HTTP/1;
  - h2spec (MIT) for HTTP/2;
  - the `hpack-test-case` corpus;
  - JSONTestSuite for JSON.

  `tools/http_conformance.py` runs them, and a workflow triggers on `stdlib/Extensions/{Http,Json,Io}/**` plus manual dispatch. They don't run on every push.

The client is what drives the server's integration tests. It runs in-process on other fibers, with no external tools needed except for h2spec.

## Prerequisites in jaic and the stdlib

- **Atomics:** acquire loads and release stores. Done: [atomics](../specs/stdlib/README.md).
- **Fibers:** the `fiber_switch` intrinsic in all backends (LLVM native, interpreter), plus Win64 TIB handling.
- **Bindings:** the generated `io_uring.h` (done: [Io_Uring](../specs/stdlib/README.md)), IoRing (`ioringapi.h`) and kqueue bindings.
- **Polymorphism:** compile-time handler inspection needs polymorphic procedures over procedure types, and `#insert` of generated extractors. Both exist, but the routing case will stress them.

## Milestones

1. Atomics ordering and the `Io_Uring` bindings, with a raw nop/read/write test. **Done** ([atomics](../specs/stdlib/README.md), [Io_Uring](../specs/stdlib/README.md)).
2. **Fibers:** the switch intrinsic (x64, arm64, Win64, interpreter), stacks and the scheduler, proven under `jaic run` first. This is the biggest risk, so it comes early.
3. The `Io` engine on io_uring and epoll, with fiber TCP, timers, files and channels. The same test suite runs on every backend through `JAI_IO_BACKEND`.
4. `Json`, plus JSONTestSuite. This is independent and can run alongside 1-3.
5. The HTTP/1 codec, plus conformance. Also independent.
6. The HTTP server (routing, extractors, JSON, errors) and the client, with integration tests.
7. kqueue, IOCP + IoRing, and the thread-pool backend.
8. HPACK, HTTP/2 and h2spec.
9. Rebuild `File_Async` on `Io`, keeping its API.

## Later

- **TLS:** a separate module after HTTP works over plain TCP. Our own TLS 1.3 (+1.2), or the system libraries, decided then.
- **JSON tagged-union representations** and more serde attributes as needed.
- **HTTP/3.**
