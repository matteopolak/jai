#import "Basic";
Strings :: #import "String";
Curl :: #import "Curl";
Files :: #import "File";
Base64 :: #import "Base64";

Mail_Server :: struct {
    host: string;
    port: string;
    enable_ssl: bool;
    username: string;
    password: string;
}

Mail_Message :: struct {
    from: string;
    to: [..] string;
    subject: string;
    body: string;
    html: bool;
    reply_to: string;
    cc: [] string;
    bcc: [] string;
    attachments: [] string;
}

mail_send :: (smtp: Mail_Server, msg: Mail_Message) -> bool {
    server := smtp;
    message := msg;
    if !valid_header(server.host) || !server.host || !valid_header(message.subject) || message.to.count + message.cc.count + message.bcc.count == 0 return false;
    for c: server.host if c == #char "/" || c == #char ":" || c == #char "@" return false;
    port, port_ok, remainder := string_to_int(server.port);
    if !port_ok || remainder || port <= 0 || port > 65535 return false;
    from, from_ok := get_c_email(message.from);
    if !from_ok return false;
    transfer := Curl.curl_easy_init();
    if !transfer return false;
    defer Curl.curl_easy_cleanup(transfer);
    recipients: *Curl.curl_slist;
    defer if recipients Curl.curl_slist_free_all(recipients);
    for address: message.to if !add_recipient(*recipients, address) return false;
    for address: message.cc if !add_recipient(*recipients, address) return false;
    for address: message.bcc if !add_recipient(*recipients, address) return false;
    payload, built := build_message(message);
    if !built return false;
    source: Upload_Context = .{ payload, 0 };
    url := tprint("smtp://%:%", server.host, port);
    if Curl.curl_easy_setopt(transfer, .URL, temp_c_string(url)) != .OK return false;
    if Curl.curl_easy_setopt(transfer, .USERNAME, temp_c_string(server.username)) != .OK return false;
    if Curl.curl_easy_setopt(transfer, .PASSWORD, temp_c_string(server.password)) != .OK return false;
    if server.enable_ssl && Curl.curl_easy_setopt(transfer, .USE_SSL, cast(s64) 3) != .OK return false;
    if Curl.curl_easy_setopt(transfer, .MAIL_FROM, from) != .OK return false;
    if Curl.curl_easy_setopt(transfer, .MAIL_RCPT, recipients) != .OK return false;
    if Curl.curl_easy_setopt(transfer, .READFUNCTION, payload_source) != .OK return false;
    if Curl.curl_easy_setopt(transfer, .READDATA, *source) != .OK return false;
    if Curl.curl_easy_setopt(transfer, .UPLOAD, cast(s64) 1) != .OK return false;
    if Curl.curl_easy_setopt(transfer, .INFILESIZE_LARGE, cast(s64) payload.count) != .OK return false;
    return Curl.curl_easy_perform(transfer) == .OK;
}

get_c_email :: (address: string) -> *u8, bool {
    if !valid_header(address) return null, false;
    candidate := Strings.trim(address);
    left := Strings.find_index_from_left(candidate, #char "<");
    if left >= 0 {
        right := Strings.find_index_from_left(candidate, #char ">");
        if right <= left || right != candidate.count - 1 return null, false;
        candidate = Strings.slice(candidate, left + 1, right - left - 1);
    }
    if !candidate || Strings.find_index_from_left(candidate, #char "@") <= 0 return null, false;
    for byte: candidate if byte <= 32 || byte == #char "<" || byte == #char ">" return null, false;
    return temp_c_string(candidate), true;
}

#scope_file
Upload_Context :: struct {
    data: string;
    cursor: s64;
}

payload_source :: (ptr: *u8, size: u64, nmemb: u64, userp: *void) -> u64 #c_call {
    if size == 0 || nmemb == 0 || nmemb > 0xffff_ffff_ffff_ffff / size return 0;
    source := cast(*Upload_Context) userp;
    capacity := size * nmemb;
    remaining := cast(u64) (source.data.count - source.cursor);
    if remaining < capacity capacity = remaining;
    if capacity > 0 memcpy(ptr, source.data.data + source.cursor, xx capacity);
    source.cursor += cast(s64) capacity;
    return capacity;
}

valid_header :: (value: string) -> bool {
    for byte: value if byte == 0 || byte == 10 || byte == 13 return false;
    return true;
}

add_recipient :: (list: **Curl.curl_slist, address: string) -> bool {
    email, valid := get_c_email(address);
    if !valid return false;
    next := Curl.curl_slist_append(list.*, email);
    if !next return false;
    list.* = next;
    return true;
}

append_addresses :: (builder: *String_Builder, header: string, addresses: [] string) -> bool {
    if addresses.count == 0 return true;
    append(builder, header);
    for address, index: addresses {
        email, valid := get_c_email(address);
        if !valid return false;
        if index > 0 append(builder, ", ");
        append(builder, to_string(email));
    }
    append(builder, "\r\n");
    return true;
}

append_base64_lines :: (builder: *String_Builder, bytes: string) {
    encoded := Base64.base64_encode(bytes);
    defer free(encoded);
    index: int;
    while index < encoded.count {
        count := min(76, encoded.count - index);
        append(builder, Strings.slice(encoded, index, count));
        append(builder, "\r\n");
        index += count;
    }
}

build_message :: (message: Mail_Message) -> string, bool {
    builder: String_Builder;
    init_string_builder(*builder);
    defer free_buffers(*builder);
    from, valid := get_c_email(message.from);
    if !valid return "", false;
    append(*builder, "From: ");
    append(*builder, to_string(from));
    append(*builder, "\r\n");
    if !append_addresses(*builder, "To: ", message.to) || !append_addresses(*builder, "Cc: ", message.cc) return "", false;
    if message.reply_to {
        reply, valid := get_c_email(message.reply_to);
        if !valid return "", false;
        append(*builder, "Reply-To: ");
        append(*builder, to_string(reply));
        append(*builder, "\r\n");
    }
    subject := Base64.base64_encode(message.subject);
    defer free(subject);
    append(*builder, "Subject: =?UTF-8?B?");
    append(*builder, subject);
    append(*builder, "?=\r\nMIME-Version: 1.0\r\n");
    boundary :: "jai-mail-boundary-2026";
    multipart := message.attachments.count > 0;
    if multipart append(*builder, "Content-Type: multipart/mixed; boundary=\"jai-mail-boundary-2026\"\r\n\r\n--jai-mail-boundary-2026\r\n");
    if message.html append(*builder, "Content-Type: text/html; charset=UTF-8\r\n");
    else append(*builder, "Content-Type: text/plain; charset=UTF-8\r\n");
    append(*builder, "Content-Transfer-Encoding: base64\r\n\r\n");
    append_base64_lines(*builder, message.body);
    for path, index: message.attachments {
        if !valid_header(path) return "", false;
        data, success := Files.read_entire_file(path);
        if !success return "", false;
        append(*builder, "\r\n--jai-mail-boundary-2026\r\nContent-Type: application/octet-stream\r\nContent-Disposition: attachment; filename=\"attachment-");
        append(*builder, tprint("%", index + 1));
        append(*builder, "\"\r\nContent-Transfer-Encoding: base64\r\n\r\n");
        append_base64_lines(*builder, data);
        free(data);
    }
    if multipart append(*builder, "\r\n--jai-mail-boundary-2026--\r\n");
    return builder_to_string(*builder), true;
}
