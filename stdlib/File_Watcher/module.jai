#import "Basic";
Files :: #import "File_Utilities";
Watch_File :: #import "File";
Pools :: #import "Pool";
Tables :: #import "Hash_Table";

File_Change :: struct { full_path: string; events: File_Change_Event; time_of_last_change := 0.0; }
File_Change_Event :: enum_flags {
    ADDED; MODIFIED; MOVED; MOVED_FROM; MOVED_TO; ATTRIBUTES_CHANGED; REMOVED; SCAN_CHILDREN;
    ALL_EVENTS :: ADDED | MODIFIED | MOVED | ATTRIBUTES_CHANGED | REMOVED;
}
DEFAULT_BUFFER_SIZE :: 8000;

File_Watcher :: struct(User_Data: Type = void) {
    File_Watcher_Callback :: #type (watcher: *File_Watcher(User_Data), change: *File_Change, user_data: *User_Data);
    callback: File_Watcher_Callback;
    user_data: *User_Data;
    events_to_watch: File_Change_Event;
    merge_window_seconds: float;
    watch_recursively: bool;
    verbose: bool;
    buffer_size: s32;
    pool: *Pools.Pool;
    changes: [..] File_Change;
    #if OS == .WINDOWS { directories: [..] *Directory_Info; }
    else #if OS == .LINUX {
        inotify_instance: s32 = -1;
        inotify_data: *void;
        inotify_bytes_read: s64;
        inotify_cursor: s32;
        path_pool: *Pools.Pool;
        watch_paths: Tables.Table(s32, string);
    } else #if OS == .MACOS { event_streams: [..] *void; }
    roots: [..] string;
    snapshot: [..] Snapshot_Entry;
    allocator: Allocator;
    initialized: bool;
    scan_failed: bool;
}

init :: (watcher: *$T/File_Watcher, callback: T.File_Watcher_Callback, user_data: *T.User_Data = null, events_to_watch: File_Change_Event = .ALL_EVENTS, merge_window_seconds: float = 0.1, watch_recursively := true, verbose := false, event_buffer_size: s32 = DEFAULT_BUFFER_SIZE) -> success: bool {
    if !watcher || !callback || watcher.initialized || event_buffer_size <= 0 || merge_window_seconds < 0 return false;
    // Every list the watcher grows later lives in the allocator that was current at init.
    owner := context.allocator;
    watcher.allocator = owner;
    watcher.changes.allocator, watcher.snapshot.allocator, watcher.roots.allocator = owner, owner, owner;

    watcher.callback, watcher.user_data = callback, user_data;
    watcher.events_to_watch      = events_to_watch;
    watcher.watch_recursively    = watch_recursively;
    watcher.merge_window_seconds = merge_window_seconds;
    watcher.buffer_size          = event_buffer_size;
    watcher.verbose              = verbose;

    watcher.initialized = true;
    return true;
}

add_directories :: (using watcher: *$T/File_Watcher, dir_paths: ..string) -> bool {
    if !initialized return false;
    for path: dir_paths {
        absolute, success := Watch_File.get_absolute_path(path);
        if !success return false;
        seen := false;
        for root: roots if root == absolute { seen = true; break; }
        if seen continue;
        entries: [..] Snapshot_Entry;
        entries.allocator = allocator;
        if !scan_directory(absolute, watch_recursively, *entries) { release_snapshot(*entries, allocator); return false; }
        array_add(*roots, owned_path(absolute, allocator));
        for entry: entries array_add(*snapshot, entry);
        array_free(entries);
    }
    return true;
}

deinit :: (using watcher: $T/File_Watcher) {
    if !initialized return;
    for root: roots free(root, allocator);
    for change: changes free(change.full_path, allocator);
    release_snapshot(*snapshot, allocator);
    array_free(roots); array_free(changes);
}

deinit :: (watcher: *File_Watcher) {
    if !watcher return;
    deinit(watcher.*);
    watcher.* = .{};
}

process_changes :: (using watcher: *File_Watcher) -> changed: bool, needs_wait: bool, wait_seconds: float64 {
    if !initialized return false, false, 0;
    fresh: [..] Snapshot_Entry;
    fresh.allocator = allocator;
    for root: roots {
        if !scan_directory(root, watch_recursively, *fresh) {
            scan_failed = true;
            release_snapshot(*fresh, allocator);
            return false, false, 0;
        }
    }
    scan_failed = false;
    for entry: fresh {
        found := false;
        for old: snapshot {
            if old.path != entry.path continue;
            found = true;
            if old.size != entry.size || old.modtime != entry.modtime add_change(watcher, entry.path, .MODIFIED);
            break;
        }
        if !found add_change(watcher, entry.path, .ADDED);
    }
    for old: snapshot {
        found := false;
        for entry: fresh if old.path == entry.path { found = true; break; }
        if !found add_change(watcher, old.path, .REMOVED);
    }
    release_snapshot(*snapshot, allocator);
    snapshot = fresh;
    return emit_changes(watcher);
}

// Queue the interesting subset of `events` for a path. Repeated events for a path that
// is already queued are OR-ed into that entry and restart its merge-window clock.
add_change :: (watcher: *File_Watcher, full_path: string, events: File_Change_Event) {
    interesting := events & watcher.events_to_watch;
    if interesting == 0 return;

    entry: *File_Change;
    for * watcher.changes  if it.full_path == full_path { entry = it; break; }
    if !entry {
        entry = array_add(*watcher.changes);
        entry.full_path = owned_path(full_path, watcher.allocator);
    }
    entry.events |= interesting;
    entry.time_of_last_change = xx seconds_since_init();
}

emit_changes :: (using watcher: *$T/File_Watcher) -> changed: bool, needs_wait: bool, wait_seconds: float64 {
    now := seconds_since_init();
    emitted := false;
    wait: float64 = 0;
    pending := false;
    index: int;
    while index < changes.count {
        age := now - changes[index].time_of_last_change;
        remaining := cast(float64) merge_window_seconds - age;
        if remaining > 0 {
            if !pending || remaining < wait wait = remaining;
            pending = true;
            index += 1;
            continue;
        }
        change := changes[index];
        changes[index] = changes[changes.count - 1];
        changes.count -= 1;
        callback(watcher, *change, user_data);
        free(change.full_path, allocator);
        emitted = true;
    }
    return emitted, pending, wait;
}

#scope_module
Snapshot_Entry :: struct { path: string; modtime: Apollo_Time; size: s64; }
Directory_Info :: struct { path: string; handle: *void; }
owned_path :: (path: string, allocator: Allocator) -> string {
    bytes := cast(*u8) alloc(path.count, allocator);
    if path.count > 0 memcpy(bytes, path.data, path.count);
    return .{path.count, bytes};
}
release_snapshot :: (entries: *[..] Snapshot_Entry, allocator: Allocator) {
    for entry: entries.* free(entry.path, allocator);
    array_free(entries.*);
    entries.* = .{};
}
scan_directory :: (path: string, recursive: bool, entries: *[..] Snapshot_Entry) -> bool {
    state: Scan_State = .{entries, entries.allocator, false};
    visitor :: (info: *Files.File_Visit_Info, state: *Scan_State) {
        modtime, size, ok := Files.file_modtime_and_size(info.full_name);
        if !ok { state.failed = true; return; }
        entry: Snapshot_Entry = .{owned_path(info.full_name, state.allocator), modtime, size};
        array_add(state.entries, entry);
    }
    ok := Files.visit_files(path, recursive, *state, visitor, true, true, true, false);
    return ok && !state.failed;
}
Scan_State :: struct { entries: *[..] Snapshot_Entry; allocator: Allocator; failed: bool; }
