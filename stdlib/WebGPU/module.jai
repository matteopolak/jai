// WebGPU through the standard C API (webgpu.h). generated.jai holds every type and procedure,
// generated from webgpu-headers' webgpu.yml by tools/webgpu_gen.py. Natively the procedures call
// wgpu-native (tools/fetch_wgpu_native.py); in the browser playground the sandbox forwards them to
// the page's WebGPU (crates/jai-wasm/js/webgpu_host.mjs). This file adds what webgpu.h leaves to
// the platform: a surface for a window, waiting for asynchronous requests, and frame pacing.

#import "Basic";
#import "Window_Type";

#load "generated.jai";

#if OS == .WASM {
    #load "wasm.jai";
    #load "generated_wasm.jai";
} else #if OS == .MACOS {
    #load "macos.jai";
}

// wgpu-native, from artifacts/native-libs (see docs/stdlib/webgpu.md). Unused in the browser.
libwgpu :: #library "libwgpu_native";

// --- Strings ----------------------------------------------------------------------------------

to_string_view :: (s: string) -> WGPUStringView {
    return .{data = s.data, length = cast(u64) s.count};
}

// A view the implementation wrote (an adapter's name, an error message), as a Jai string that
// borrows its bytes.
to_string :: (view: WGPUStringView) -> string {
    if view.data == null return "";
    if view.length != WGPU_STRLEN return string.{cast(s64) view.length, view.data};
    count := 0;
    while view.data[count] count += 1;
    return string.{count, view.data};
}

// --- Waiting for requests -----------------------------------------------------------------------

// Request an adapter and wait for it; null when there is none. The callback fires inside
// wgpuInstanceProcessEvents, which the browser host turns into a wait for the page's promise.
webgpu_request_adapter :: (instance: WGPUInstance, options: *WGPURequestAdapterOptions = null) -> WGPUAdapter {
    state: Request_State;
    info: WGPURequestAdapterCallbackInfo;
    info.mode = .AllowProcessEvents;
    info.callback = (status: WGPURequestAdapterStatus, adapter: WGPUAdapter, message: WGPUStringView, userdata1: *void, userdata2: *void) #c_call {
        state := cast(*Request_State) userdata1;
        state.done = true;
        state.result = adapter;
        if status != .Success state.message = message;
    };
    info.userdata1 = *state;
    wgpuInstanceRequestAdapter(instance, options, info);
    while !state.done wgpuInstanceProcessEvents(instance);
    if !state.result log_error("WebGPU: no adapter: %", to_string(state.message));
    return cast(WGPUAdapter) state.result;
}

// Request a device and wait for it; null on failure. Uncaptured errors are printed unless the
// descriptor sets its own callback.
webgpu_request_device :: (instance: WGPUInstance, adapter: WGPUAdapter, descriptor: *WGPUDeviceDescriptor = null) -> WGPUDevice {
    desc: WGPUDeviceDescriptor;
    if descriptor desc = descriptor.*;
    if !desc.uncapturedErrorCallbackInfo.callback {
        desc.uncapturedErrorCallbackInfo.callback = (device: *WGPUDevice, type: WGPUErrorType, message: WGPUStringView, userdata1: *void, userdata2: *void) #c_call {
            push_context,defer_pop webgpu_callback_context;
            log_error("WebGPU % error: %", type, to_string(message));
        };
    }
    state: Request_State;
    info: WGPURequestDeviceCallbackInfo;
    info.mode = .AllowProcessEvents;
    info.callback = (status: WGPURequestDeviceStatus, device: WGPUDevice, message: WGPUStringView, userdata1: *void, userdata2: *void) #c_call {
        state := cast(*Request_State) userdata1;
        state.done = true;
        state.result = device;
        if status != .Success state.message = message;
    };
    info.userdata1 = *state;
    webgpu_callback_context = context;
    wgpuAdapterRequestDevice(adapter, *desc, info);
    while !state.done wgpuInstanceProcessEvents(instance);
    if !state.result log_error("WebGPU: no device: %", to_string(state.message));
    return cast(WGPUDevice) state.result;
}

// --- Surfaces and frames ------------------------------------------------------------------------

// A surface that draws into `window` (a Window_Creation window). In the browser the window is
// the page's canvas and `window` is ignored.
webgpu_create_surface :: (instance: WGPUInstance, window: Window_Type) -> WGPUSurface {
    desc: WGPUSurfaceDescriptor;
    #if OS == .MACOS {
        source: WGPUSurfaceSourceMetalLayer;
        source.layer = webgpu_metal_layer(window);
        if !source.layer return null;
        desc.nextInChain = *source.chain;
    } else #if OS == .WINDOWS {
        Win :: #import "Windows";
        source: WGPUSurfaceSourceWindowsHWND;
        source.hinstance = Win.GetModuleHandleW(null);
        source.hwnd = window;
        desc.nextInChain = *source.chain;
    } else #if OS == .LINUX {
        X11 :: #import "X11";
        source: WGPUSurfaceSourceXlibWindow;
        source.display = X11.x_global_display;
        source.window = cast(u64) window;
        desc.nextInChain = *source.chain;
    }
    return wgpuInstanceCreateSurface(instance, *desc);
}

// The size of the surface `window` shows, in pixels (the canvas in the browser).
webgpu_window_size :: (window: Window_Type) -> width: s32, height: s32 {
    #if OS == .WASM {
        w, h: u32;
        jai_canvas_size(*w, *h);
        return cast(s32) w, cast(s32) h;
    } else #if OS == .MACOS {
        return webgpu_macos_drawable_size(window);
    } else {
        WC :: #import "Window_Creation";
        x, y, w, h, ok := WC.get_dimensions(window, false);
        return cast(s32) w, cast(s32) h;
    }
}

// Show the frame drawn into the surface's current texture and wait until the next one is due.
// Natively that is wgpuSurfacePresent (a FIFO surface blocks for vsync). The browser presents on
// its own; there this suspends the program until the page's next animation frame.
webgpu_present :: (surface: WGPUSurface) {
    #if OS == .WASM {
        jai_webgpu_next_frame();
    } else {
        wgpuSurfacePresent(surface);
    }
}

#scope_module

Request_State :: struct {
    done: bool;
    result: *void;
    message: WGPUStringView;
}

webgpu_callback_context: #Context;
