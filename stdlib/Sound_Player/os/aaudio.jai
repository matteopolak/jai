// Android output through an AAudio stream in blocking-write mode, used without blocking: writes
// pass a zero timeout and the queue depth is computed from the stream's frame counters.

#scope_module

output_open :: (config: Sound_Player_Config) -> channels: s32, rate: s32, ok: bool {
    if stream return 0, 0, false;
    builder: *AAudioStreamBuilder;
    if cast(s32) AAudio_createStreamBuilder(*builder) < 0 return 0, 0, false;
    AAudioStreamBuilder_setDirection(builder, .OUTPUT);
    AAudioStreamBuilder_setFormat(builder, .PCM_I16);
    AAudioStreamBuilder_setSampleRate(builder, PREFERRED_RATE);
    AAudioStreamBuilder_setChannelCount(builder, AA_CHANNELS);
    status := AAudioStreamBuilder_openStream(builder, *stream);
    AAudioStreamBuilder_delete(builder);
    if cast(s32) status < 0 {
        log_error("Sound_Player: AAudio could not open an output stream (%).\n", cast(s32) status);
        stream = null;
        return 0, 0, false;
    }
    // The device may not honour the requested shape; only the format and channel count matter.
    if AAudioStream_getChannelCount(stream) != AA_CHANNELS || AAudioStream_getFormat(stream) != .PCM_I16 {
        output_close();
        return 0, 0, false;
    }
    rate := AAudioStream_getSampleRate(stream);
    burst := AAudioStream_getFramesPerBurst(stream);
    wanted := max(2 * burst, cast(s32) (max(config.seconds_to_fill_ahead, 0.01) * rate));
    device_buffer_frames = AAudioStream_setBufferSizeInFrames(stream, wanted);
    return AA_CHANNELS, rate, true;
}

output_start :: () {
    if stream AAudioStream_requestStart(stream);
}

output_close :: () {
    if !stream return;
    AAudioStream_requestStop(stream);
    AAudioStream_close(stream);
    stream = null;
}

output_frames_queued :: () -> queued: s64, at_least: s64 {
    if !stream return S64_MAX, 0;
    pending := AAudioStream_getFramesWritten(stream) - AAudioStream_getFramesRead(stream);
    return max(pending, 0), max(device_buffer_frames, 0);
}

output_write :: (frames: s64) {
    if !stream return;
    remaining := frames;
    while remaining > 0 {
        count := min(remaining, STAGING_FRAMES);
        chunk: [] s16;
        chunk.data = staging.data;
        chunk.count = count * AA_CHANNELS;
        mix_into(chunk);
        // A zero timeout writes what fits now; anything that did not fit is dropped, which only
        // happens if the device queue is smaller than seconds_to_fill_ahead.
        accepted := AAudioStream_write(stream, staging.data, cast(s32) count, 0);
        if accepted < count return;
        remaining -= count;
    }
}

output_devices :: () -> [] Output_Device {
    if listed_devices.count return listed_devices;
    app := context.android_app;
    if !app || !app.activity return listed_devices;
    activity := app.activity;
    // AudioManager.getDevices appeared in API level 23.
    if activity.sdkVersion < 23 || !activity.vm || !activity.clazz return listed_devices;

    vm := activity.vm;
    env: *Jni.JNIEnv;
    attached := false;
    state := vm.*.GetEnv(vm, cast(**void) *env, Jni.JNI_VERSION_1_6);
    if state == Jni.JNI_EDETACHED {
        if vm.*.AttachCurrentThread(vm, *env, null) != Jni.JNI_OK return listed_devices;
        attached = true;
    } else if state != Jni.JNI_OK {
        return listed_devices;
    }
    defer if attached vm.*.DetachCurrentThread(vm);

    if env.*.PushLocalFrame(env, 32) != Jni.JNI_OK {
        jni_failed(env);
        return listed_devices;
    }
    defer env.*.PopLocalFrame(env, null);
    collect_devices(env, activity.clazz);
    return listed_devices;
}

#scope_file
#import "Android/AAudio";
Android :: #import "Android";
Jni :: #import "Android/Jni";

PREFERRED_RATE :: 48000;
AA_CHANNELS :: 2;
STAGING_FRAMES :: 2048;

stream: *AAudioStream;
device_buffer_frames: s32;
staging: [STAGING_FRAMES * AA_CHANNELS] s16;
listed_devices: [..] Output_Device = .{ allocator = SOUND_HEAP };

// activity.getSystemService("audio").getDevices(GET_DEVICES_OUTPUTS), keeping id and product name.
collect_devices :: (env: *Jni.JNIEnv, activity: Jni.jobject) {
    GET_DEVICES_OUTPUTS :: 2;
    service := env.*.NewStringUTF(env, "audio");
    utf8 := env.*.NewStringUTF(env, "UTF-8");
    if jni_failed(env) || !service || !utf8 return;

    get_service := jni_method(env, activity, "getSystemService", "(Ljava/lang/String;)Ljava/lang/Object;");
    if !get_service return;
    argument: [1] Jni.jvalue;
    argument[0].l = service;
    manager := env.*.CallObjectMethodA(env, activity, get_service, argument.data);
    if jni_failed(env) || !manager return;

    get_devices := jni_method(env, manager, "getDevices", "(I)[Landroid/media/AudioDeviceInfo;");
    if !get_devices return;
    argument[0].i = GET_DEVICES_OUTPUTS;
    array := env.*.CallObjectMethodA(env, manager, get_devices, argument.data);
    if jni_failed(env) || !array return;
    count := env.*.GetArrayLength(env, array);
    if jni_failed(env) return;

    for index: 0..count - 1 {
        info := env.*.GetObjectArrayElement(env, array, index);
        if jni_failed(env) || !info continue;
        defer env.*.DeleteLocalRef(env, info);
        get_id := jni_method(env, info, "getId", "()I");
        get_name := jni_method(env, info, "getProductName", "()Ljava/lang/CharSequence;");
        if !get_id || !get_name continue;
        id := env.*.CallIntMethodA(env, info, get_id, null);
        if jni_failed(env) continue;
        name := env.*.CallObjectMethodA(env, info, get_name, null);
        if jni_failed(env) || !name continue;
        device: Output_Device;
        device.device_index = id;
        device.name = jni_text(env, name, utf8);
        env.*.DeleteLocalRef(env, name);
        array_add(*listed_devices, device);
    }
}

// Clears a pending Java exception; true if there was one.
jni_failed :: (env: *Jni.JNIEnv) -> bool {
    if env.*.ExceptionCheck(env) == 0 return false;
    env.*.ExceptionClear(env);
    return true;
}

jni_method :: (env: *Jni.JNIEnv, object: Jni.jobject, name: *u8, signature: *u8) -> Jni.jmethodID {
    class := env.*.GetObjectClass(env, object);
    if jni_failed(env) || !class return null;
    method := env.*.GetMethodID(env, class, name, signature);
    env.*.DeleteLocalRef(env, class);
    if jni_failed(env) return null;
    return method;
}

// String(sequence.toString()).getBytes(encoding), copied into a Jai string.
jni_text :: (env: *Jni.JNIEnv, sequence: Jni.jobject, encoding: Jni.jstring) -> string {
    to_text := jni_method(env, sequence, "toString", "()Ljava/lang/String;");
    if !to_text return "";
    text := env.*.CallObjectMethodA(env, sequence, to_text, null);
    if jni_failed(env) || !text return "";
    defer env.*.DeleteLocalRef(env, text);
    get_bytes := jni_method(env, text, "getBytes", "(Ljava/lang/String;)[B");
    if !get_bytes return "";
    argument: [1] Jni.jvalue;
    argument[0].l = encoding;
    bytes := env.*.CallObjectMethodA(env, text, get_bytes, argument.data);
    if jni_failed(env) || !bytes return "";
    defer env.*.DeleteLocalRef(env, bytes);
    length := env.*.GetArrayLength(env, bytes);
    if jni_failed(env) || length <= 0 return "";
    result := alloc_string(length);
    env.*.GetByteArrayRegion(env, bytes, 0, length, cast(*Jni.jbyte) result.data);
    if jni_failed(env) {
        free(result);
        return "";
    }
    return result;
}
