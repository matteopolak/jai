// The browser playground. Every wgpu* procedure is a host call the sandbox forwards to
// crates/jai-wasm/js/webgpu_host.mjs, except the two that run callbacks: JavaScript cannot call
// a Jai procedure, so the host queues finished requests and these call them
// (webgpu_dispatch_record in generated_wasm.jai).

wgpuInstanceProcessEvents :: (instance: WGPUInstance) {
    // Give the page a turn so its promises settle, then run what finished.
    jai_webgpu_wait(null, 0, 0);
    webgpu_dispatch(null, 0, false);
}

wgpuInstanceWaitAny :: (instance: WGPUInstance, futureCount: u64, futures: *WGPUFutureWaitInfo, timeoutNS: u64) -> WGPUWaitStatus {
    status := cast(WGPUWaitStatus) jai_webgpu_wait(futures, futureCount, timeoutNS);
    webgpu_dispatch(futures, futureCount, true);
    return status;
}

#scope_module

// Filled by the host; see `callbackRecord` in webgpu_host.mjs.
Webgpu_Callback_Record :: struct {
    kind: u32;      // 1-based index of the callback in webgpu.yml
    mode: u32;
    future: u64;
    callback: *void;
    userdata1: *void;
    userdata2: *void;
    args: [4] u64;
    message_data: *u8;
    message_length: u64;
}

webgpu_dispatch :: (futures: *WGPUFutureWaitInfo, count: u64, wait_any: bool) {
    record: Webgpu_Callback_Record;
    while jai_webgpu_poll(*record, futures, count, xx wait_any) webgpu_dispatch_record(*record);
}

// Host procedures (no library: the sandbox resolves them by name).
// Write the next finished callback into `record`; 0 when none is ready.
jai_webgpu_poll :: (record: *Webgpu_Callback_Record, futures: *WGPUFutureWaitInfo, count: u64, wait_any: u32) -> u32 #foreign;
// Suspend until one of `futures` finished or `timeout_ns` passed (count 0: one turn of the page).
jai_webgpu_wait :: (futures: *WGPUFutureWaitInfo, count: u64, timeout_ns: u64) -> u32 #foreign;
// Suspend until the page's next animation frame.
jai_webgpu_next_frame :: () #foreign;
// The canvas size in pixels.
jai_canvas_size :: (width: *u32, height: *u32) #foreign;
