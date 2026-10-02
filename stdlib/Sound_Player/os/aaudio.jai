// Independently normalized ABI contract. No reference procedure bodies or binaries.
#scope_module
OUTPUT_SAMPLING_RATE :: 44100 ;
FILL_BUFFER_SIZE_IN_FRAMES :: OUTPUT_SAMPLING_RATE / 2 ;
STREAM_FORMAT :: AAUDIO_FORMAT . PCM_I16 ;
backend_init :: ( config : Sound_Player_Config ) -> ( Backend_Properties ) {
    result: Backend_Properties;
    if stream return result;
    builder: *AAudioStreamBuilder;
    if cast(s32) AAudio_createStreamBuilder(*builder) < 0 return result;
    defer AAudioStreamBuilder_delete(builder);
    AAudioStreamBuilder_setDirection(builder, .OUTPUT);
    AAudioStreamBuilder_setFormat(builder, STREAM_FORMAT);
    AAudioStreamBuilder_setSampleRate(builder, OUTPUT_SAMPLING_RATE);
    AAudioStreamBuilder_setChannelCount(builder, 2);
    error := AAudioStreamBuilder_openStream(builder, *stream);
    if cast(s32) error < 0 { log_aaudio_error(error, "open"); stream = null; return result; }
    num_channels = AAudioStream_getChannelCount(stream);
    if num_channels != 2 || AAudioStream_getFormat(stream) != STREAM_FORMAT { backend_shutdown(); return result; }
    frames_per_burst = AAudioStream_getFramesPerBurst(stream);
    buffer_capacity_in_frames = AAudioStream_getBufferCapacityInFrames(stream);
    requested := max(frames_per_burst*2, cast(s32) (max(config.seconds_to_fill_ahead,0.01)*AAudioStream_getSampleRate(stream)));
    buffer_size_in_frames = AAudioStream_setBufferSizeInFrames(stream, min(requested, buffer_capacity_in_frames));
    if buffer_size_in_frames < 0 { backend_shutdown(); return result; }
    sample_buffer_num_frames = FILL_BUFFER_SIZE_IN_FRAMES;
    sample_buffer = alloc_string(sample_buffer_num_frames*num_channels*BYTES_PER_SAMPLE);
    if !sample_buffer.data { backend_shutdown(); return result; }
    array_add(*channel_names, "Front Left", "Front Right");
    do_async = config.update_from_a_thread;
    result.initted = true; result.num_channels = num_channels;
    result.output_sampling_rate = AAudioStream_getSampleRate(stream); result.channel_names = channel_names;
    return result;
}
backend_play :: ( ) {
    if stream log_aaudio_error(AAudioStream_requestStart(stream), "start");
}
backend_needs_async_update_from_main_thread :: ( ) -> bool {
    // This backend uses writes, without a data callback or UI-thread affinity.
    return false;
}
backend_count_buffered_bytes :: ( ) -> ( currently_buffered : s64 , minimum_prebuffered_bytes : s64 ) {
    if !stream return 0, 0;
    frames := max(0, AAudioStream_getFramesWritten(stream)-AAudioStream_getFramesRead(stream));
    return frames*num_channels*BYTES_PER_SAMPLE, cast(s64) max(frames_per_burst*2,buffer_size_in_frames)*num_channels*BYTES_PER_SAMPLE;
}
backend_lock_fill_regions :: ( bytes_to_lock : s64 ) -> ( Fill_Region_Result , bool ) {
    result: Fill_Region_Result;
    if !stream || bytes_to_lock <= 0 || !sample_buffer.data return result, false;
    frames := min(bytes_to_lock/(num_channels*BYTES_PER_SAMPLE), sample_buffer_num_frames);
    if frames <= 0 return result, false;
    result.buffer0 = to_string(sample_buffer.data, frames*num_channels*BYTES_PER_SAMPLE);
    return result, true;
}
backend_release_fill_regions :: ( result : Fill_Region_Result ) {
    if !stream return;
    total := result.buffer0.count/(num_channels*BYTES_PER_SAMPLE);
    written: s64 = 0;
    while written < total {
        count := AAudioStream_write(stream, result.buffer0.data+written*num_channels*BYTES_PER_SAMPLE,
            cast(s32) (total-written), 10000000);
        if count < 0 { log_aaudio_error(cast(AAUDIO) count, "write"); break; }
        if count == 0 break;
        written += count;
    }
}
backend_shutdown :: ( ) {
    if stream { AAudioStream_requestStop(stream); AAudioStream_close(stream); stream = null; }
    free(sample_buffer); sample_buffer = "";
    array_free(channel_names); channel_names = .{};
    num_channels = 0; sample_buffer_num_frames = 0; do_async = false;
}
backend_get_devices :: ( ) -> [ ] Output_Device {
    if android_audio_output_devices.count > 0 return android_audio_output_devices;
    if !context.android_app || !context.android_app.activity return android_audio_output_devices;
    activity := context.android_app.activity;
    if activity.sdkVersion < 23 || !activity.vm || !activity.clazz return android_audio_output_devices;
    vm := activity.vm;
    env: *JNI_Audio.JNIEnv;
    state := vm.*.GetEnv(vm, cast(**void) *env, JNI_Audio.JNI_VERSION_1_6);
    attached := false;
    if state == JNI_Audio.JNI_EDETACHED {
        if vm.*.AttachCurrentThread(vm, *env, null) != JNI_Audio.JNI_OK return android_audio_output_devices;
        attached = true;
    } else if state != JNI_Audio.JNI_OK return android_audio_output_devices;
    defer { if attached vm.*.DetachCurrentThread(vm); }
    if env.*.ExceptionCheck(env) != 0 return android_audio_output_devices;
    if env.*.PushLocalFrame(env, 32) != JNI_Audio.JNI_OK { Native_JNI_Audio_Error(env); return android_audio_output_devices; }
    defer env.*.PopLocalFrame(env, null);
    service_name := env.*.NewStringUTF(env, "audio");
    if Native_JNI_Audio_Error(env) || !service_name return android_audio_output_devices;
    encoding := env.*.NewStringUTF(env, "UTF-8");
    if Native_JNI_Audio_Error(env) || !encoding return android_audio_output_devices;
    method := Native_JNI_Audio_Method(env, activity.clazz, "getSystemService", "(Ljava/lang/String;)Ljava/lang/Object;");
    if !method return android_audio_output_devices;
    args: [1]JNI_Audio.jvalue;
    args[0].l = service_name;
    manager := env.*.CallObjectMethodA(env, activity.clazz, method, args.data);
    if Native_JNI_Audio_Error(env) || !manager return android_audio_output_devices;
    method = Native_JNI_Audio_Method(env, manager, "getDevices", "(I)[Landroid/media/AudioDeviceInfo;");
    if !method return android_audio_output_devices;
    args[0].i = 2;
    devices := env.*.CallObjectMethodA(env, manager, method, args.data);
    if Native_JNI_Audio_Error(env) || !devices return android_audio_output_devices;
    count := env.*.GetArrayLength(env, devices);
    if Native_JNI_Audio_Error(env) return android_audio_output_devices;
    for index: 0..count-1 {
        native_device := env.*.GetObjectArrayElement(env, devices, index);
        if Native_JNI_Audio_Error(env) || !native_device continue;
        id_method := Native_JNI_Audio_Method(env, native_device, "getId", "()I");
        name_method := Native_JNI_Audio_Method(env, native_device, "getProductName", "()Ljava/lang/CharSequence;");
        if !id_method || !name_method { env.*.DeleteLocalRef(env, native_device); continue; }
        identifier := env.*.CallIntMethodA(env, native_device, id_method, null);
        if Native_JNI_Audio_Error(env) { env.*.DeleteLocalRef(env, native_device); continue; }
        product := env.*.CallObjectMethodA(env, native_device, name_method, null);
        if Native_JNI_Audio_Error(env) || !product { env.*.DeleteLocalRef(env, native_device); continue; }
        device: Output_Device;
        device.device_index = identifier;
        device.name = Native_JNI_Audio_Name(env, product, encoding);
        env.*.DeleteLocalRef(env, product);
        env.*.DeleteLocalRef(env, native_device);
        array_add(*android_audio_output_devices, device);
    }
    return android_audio_output_devices;
}
#scope_file
;
Get_Devices_Flags :: enum s32 {
    NONE :: 0 ;
    INPUTS :: 1 ;
    OUTPUTS :: 2 ;
    ALL :: 3 ;
}
;
AudioDeviceInfo_Type :: enum s32 {
    UNKNOWN :: 0 ;
    BUILTIN_EARPIECE :: 1 ;
    BUILTIN_SPEAKER :: 2 ;
    WIRED_HEADSET :: 3 ;
    WIRED_HEADPHONES :: 4 ;
    LINE_ANALOG :: 5 ;
    LINE_DIGITAL :: 6 ;
    BLUETOOTH_SCO :: 7 ;
    BLUETOOTH_A2DP :: 8 ;
    HDMI :: 9 ;
    HDMI_ARC :: 10 ;
    USB_DEVICE :: 11 ;
    USB_ACCESSORY :: 12 ;
    DOCK :: 13 ;
    FM :: 14 ;
    BUILTIN_MIC :: 15 ;
    FM_TUNER :: 16 ;
    TV_TUNER :: 17 ;
    TELEPHONY :: 18 ;
    AUX_LINE :: 19 ;
    IP :: 20 ;
    BUS :: 21 ;
    USB_HEADSET :: 22 ;
    HEARING_AID :: 23 ;
    BUILTIN_SPEAKER_SAFE :: 24 ;
    REMOTE_SUBMIX :: 25 ;
    BLE_HEADSET :: 26 ;
    BLE_SPEAKER :: 27 ;
    ECHO_REFERENCE :: 28 ;
    HDMI_EARC :: 29 ;
}
log_aaudio_error :: ( error_code : AAUDIO , proc_name : string , fatal := false ) {
    if cast(s32) error_code >= 0 return;
    print("AAudio % failed with code %\n", proc_name, cast(s32) error_code);
    if fatal assert(false);
}
do_async := false ;
num_channels : s32 ;
channel_names : [ .. ] string ;
sample_buffer : string ;
sample_buffer_num_frames : s64 ;
buffer_size_in_frames : s32 ;
buffer_capacity_in_frames : s32 ;
stream : * AAudioStream ;
frames_per_burst : s32 ;
#import "Android/AAudio" ;


#scope_file
Android_Audio :: #import "Android";
JNI_Audio :: #import "Android/Jni";
android_audio_output_devices: [..]Output_Device;
Native_JNI_Audio_Error :: (env: *JNI_Audio.JNIEnv) -> bool {
    if env.*.ExceptionCheck(env) == 0 return false;
    env.*.ExceptionClear(env);
    return true;
}
Native_JNI_Audio_Method :: (env: *JNI_Audio.JNIEnv, object: JNI_Audio.jobject, name: *u8, signature: *u8) -> JNI_Audio.jmethodID {
    kind := env.*.GetObjectClass(env, object);
    if Native_JNI_Audio_Error(env) || !kind return null;
    method := env.*.GetMethodID(env, kind, name, signature);
    env.*.DeleteLocalRef(env, kind);
    if Native_JNI_Audio_Error(env) return null;
    return method;
}
Native_JNI_Audio_Name :: (env: *JNI_Audio.JNIEnv, sequence: JNI_Audio.jobject, encoding: JNI_Audio.jstring) -> string {
    method := Native_JNI_Audio_Method(env, sequence, "toString", "()Ljava/lang/String;");
    if !method return "";
    text := env.*.CallObjectMethodA(env, sequence, method, null);
    if Native_JNI_Audio_Error(env) || !text return "";
    defer env.*.DeleteLocalRef(env, text);
    method = Native_JNI_Audio_Method(env, text, "getBytes", "(Ljava/lang/String;)[B");
    if !method return "";
    args: [1]JNI_Audio.jvalue;
    args[0].l = encoding;
    bytes := env.*.CallObjectMethodA(env, text, method, args.data);
    if Native_JNI_Audio_Error(env) || !bytes return "";
    defer env.*.DeleteLocalRef(env, bytes);
    length := env.*.GetArrayLength(env, bytes);
    if Native_JNI_Audio_Error(env) || length < 0 return "";
    result := alloc_string(length);
    if length > 0 && !result.data return "";
    if length > 0 {
        env.*.GetByteArrayRegion(env, bytes, 0, length, cast(*JNI_Audio.jbyte) result.data);
        if Native_JNI_Audio_Error(env) { free(result); return ""; }
    }
    return result;
}
