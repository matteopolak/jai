// Independently normalized ABI contract. No reference procedure bodies or binaries.
#scope_file
#import "macos" ;
log_error :: ( err : OSStatus ) -> bool {
    if err == 0 return false;
    print("Core Audio failed with OSStatus %\n", err);
    return true;
}
render_proc :: ( inRefCon : * void , ioActionFlags : * AudioUnitRenderActionFlags , inTimeStamp : * AudioTimeStamp , inBusNumber : u32 , inNumberFrames : u32 , ioData : * AudioBufferList ) -> OSStatus #c_call {
    if !ioData || !inRefCon return -50;
    rb := cast(*Ring_Buffer) inRefCon;
    buffers := *ioData.mBuffers[0];
    if ioData.mNumberBuffers != 1 || buffers.mNumberChannels != 2 || !buffers.mData return -50;
    requested := min(cast(s64) inNumberFrames*BYTES_PER_FRAME, cast(s64) buffers.mDataByteSize);
    read := atomic_read(*rb.read_cursor);
    write := atomic_read(*rb.write_cursor);
    occupied := write-read;
    if occupied < 0 occupied += rb.data.count;
    copied := min(requested, occupied);
    copied -= copied%BYTES_PER_FRAME;
    destination := cast(*u8) buffers.mData;
    first := min(copied, rb.data.count-read);
    if first > 0 memcpy(destination, rb.data.data+read, first);
    if copied > first memcpy(destination+first, rb.data.data, copied-first);
    for byte: copied..requested-1 destination[byte] = 0;
    atomic_write(*rb.read_cursor, (read+copied)%rb.data.count);
    if copied == 0 && ioActionFlags ioActionFlags.* |= .kAudioUnitRenderAction_OutputIsSilence;
    return 0;
}
BYTES_PER_FRAME :: 4 ;
Ring_Buffer :: struct {
    mutex : Mutex ;
    data : string ;
    write_cursor : s64 ;
    read_cursor : s64 ;
}
available_bytes :: ( using rb : Ring_Buffer ) -> s64 {
    return rb.data.count - used_bytes(rb) - 2;
}
used_bytes :: ( using rb : Ring_Buffer ) -> s64 {
    occupied := rb.write_cursor - rb.read_cursor;
    if occupied < 0 occupied += rb.data.count;
    return occupied;
}
is_full :: ( using rb : Ring_Buffer ) -> bool {
    return used_bytes(rb) >= rb.data.count - 2;
}
is_empty :: ( using rb : Ring_Buffer ) -> bool {
    return rb.read_cursor == rb.write_cursor;
}
create_ring_buffer :: ( size_in_bytes : s32 ) -> Ring_Buffer {
    result: Ring_Buffer;
    if size_in_bytes < BYTES_PER_FRAME*2 return result;
    size := size_in_bytes-size_in_bytes%BYTES_PER_FRAME;
    result.data = alloc_string(size);
    if !result.data.data return result;
    // A pthread mutex must be initialized after this returned record reaches its final address.
    return result;
}
get_writable_regions :: ( using rb : Ring_Buffer , requested_num_bytes : s64 ) -> region0 : string , region1 : string {
    count := min(max(0, requested_num_bytes), max(0, available_bytes(rb)));
    count -= count%BYTES_PER_FRAME;
    first := min(count, rb.data.count-rb.write_cursor);
    return to_string(rb.data.data+rb.write_cursor, first), to_string(rb.data.data, count-first);
}
get_readable_regions :: ( using rb : Ring_Buffer , requested_num_bytes : s64 ) -> region0 : string , region1 : string {
    count := min(max(0, requested_num_bytes), used_bytes(rb));
    count -= count%BYTES_PER_FRAME;
    first := min(count, rb.data.count-rb.read_cursor);
    return to_string(rb.data.data+rb.read_cursor, first), to_string(rb.data.data, count-first);
}
advance_write_cursor_bytes :: ( using rb : * Ring_Buffer , num_bytes : s64 ) {
    assert(num_bytes >= 0 && num_bytes <= available_bytes(rb.*));
    rb.write_cursor = (rb.write_cursor + num_bytes) % rb.data.count;
}
#scope_export
OUTPUT_SAMPLING_RATE :: 44100 ;
FILL_BUFFER_SIZE_IN_SAMPLES :: 24000 ;
backend_init :: ( config : Sound_Player_Config ) -> Backend_Properties {
    result: Backend_Properties;
    if output_unit return result;
    description: AudioComponentDescription;
    description.componentType = kAudioUnitType_Output;
    description.componentSubType = kAudioUnitSubType_DefaultOutput;
    description.componentManufacturer = kAudioUnitManufacturer_Apple;
    component := AudioComponentFindNext(null, *description);
    if !component return result;
    if log_error(AudioComponentInstanceNew(component, *output_unit)) return result;
    num_channels = 2;
    ring_buffer = create_ring_buffer(FILL_BUFFER_SIZE_IN_SAMPLES*BYTES_PER_FRAME);
    if !ring_buffer.data.data || !init(*ring_buffer.mutex, "audio ring writer") { backend_shutdown(); return result; }
    format: AudioStreamBasicDescription;
    format.mSampleRate = OUTPUT_SAMPLING_RATE;
    format.mFormatID = kAudioFormatLinearPCM;
    format.mFormatFlags = .kAudioFormatFlagIsSignedInteger | .kAudioFormatFlagIsPacked;
    format.mBytesPerPacket = BYTES_PER_FRAME;
    format.mFramesPerPacket = 1;
    format.mBytesPerFrame = BYTES_PER_FRAME;
    format.mChannelsPerFrame = 2;
    format.mBitsPerChannel = 16;
    if log_error(AudioUnitSetProperty(output_unit, .kAudioUnitProperty_StreamFormat, .kAudioUnitScope_Input,
        0, *format, size_of(AudioStreamBasicDescription))) { backend_shutdown(); return result; }
    callback: AURenderCallbackStruct = .{inputProc=render_proc,inputProcRefCon=*ring_buffer};
    if log_error(AudioUnitSetProperty(output_unit, .kAudioUnitProperty_SetRenderCallback, .kAudioUnitScope_Input,
        0, *callback, size_of(AURenderCallbackStruct))) { backend_shutdown(); return result; }
    if log_error(AudioUnitInitialize(output_unit)) { backend_shutdown(); return result; }
    minimum_prebuffered_bytes = cast(s64) (OUTPUT_SAMPLING_RATE*max(config.seconds_to_fill_ahead, 0.01))*BYTES_PER_FRAME;
    array_add(*channel_names, "Front Left", "Front Right");
    result.initted = true; result.num_channels = num_channels;
    result.output_sampling_rate = OUTPUT_SAMPLING_RATE; result.channel_names = channel_names;
    return result;
}
backend_shutdown :: ( ) {
    if output_unit {
        AudioOutputUnitStop(output_unit); AudioUnitUninitialize(output_unit);
        AudioComponentInstanceDispose(output_unit); output_unit = null;
    }
    if ring_buffer.mutex.initialized destroy(*ring_buffer.mutex);
    free(ring_buffer.data); ring_buffer = .{};
    array_free(channel_names); channel_names = .{};
    num_channels = 0; minimum_prebuffered_bytes = 0;
}
backend_needs_async_update_from_main_thread :: ( ) -> bool {
    // AudioUnit consumes the ring buffer through its own render callback.
    return false;
}
backend_play :: ( ) {
    if output_unit log_error(AudioOutputUnitStart(output_unit));
}
get_bytes_between :: ( front : $ T , rear : T , buffer_len : T ) -> T {
    difference := front - rear;
    if difference < 0 difference += buffer_len;
    return difference;
}
backend_count_buffered_bytes :: ( ) -> ( currently_buffered : s64 , minimum_prebuffered_bytes : s64 ) {
    if !output_unit return 0, 0;
    read := atomic_read(*ring_buffer.read_cursor);
    write := atomic_read(*ring_buffer.write_cursor);
    occupied := write-read;
    if occupied < 0 occupied += ring_buffer.data.count;
    return occupied, minimum_prebuffered_bytes;
}
backend_lock_fill_regions :: ( bytes_to_lock : s64 ) -> Fill_Region_Result , bool {
    result: Fill_Region_Result;
    if !output_unit || bytes_to_lock <= 0 return result, false;
    lock(*ring_buffer.mutex);
    snapshot: Ring_Buffer;
    snapshot.data = ring_buffer.data;
    snapshot.read_cursor = atomic_read(*ring_buffer.read_cursor);
    snapshot.write_cursor = atomic_read(*ring_buffer.write_cursor);
    result.buffer0, result.buffer1 = get_writable_regions(snapshot, bytes_to_lock);
    if result.buffer0.count+result.buffer1.count == 0 { unlock(*ring_buffer.mutex); return result, false; }
    return result, true;
}
backend_release_fill_regions :: ( result : Fill_Region_Result ) {
    count := result.buffer0.count+result.buffer1.count;
    atomic_write(*ring_buffer.write_cursor, (atomic_read(*ring_buffer.write_cursor)+count)%ring_buffer.data.count);
    unlock(*ring_buffer.mutex);
}
backend_get_devices :: ( ) -> [ ] Output_Device {
    if core_audio_output_devices.count > 0 return core_audio_output_devices;
    address: Native_AudioObjectPropertyAddress = .{selector=0x64657623,scope=0x676c6f62,element=0};
    byte_count: u32;
    if Native_AudioObjectGetPropertyDataSize(1, *address, 0, null, *byte_count) != 0 return core_audio_output_devices;
    if byte_count == 0 || byte_count%size_of(u32) != 0 || byte_count > 1048576 return core_audio_output_devices;
    identifiers := cast(*u32) alloc(byte_count);
    if !identifiers return core_audio_output_devices;
    defer Audio_Backend_Basic.free(identifiers);
    if Native_AudioObjectGetPropertyData(1, *address, 0, null, *byte_count, identifiers) != 0 return core_audio_output_devices;
    for index: 0..byte_count/size_of(u32)-1 {
        identifier := identifiers[index];
        streams_address: Native_AudioObjectPropertyAddress = .{selector=0x736c6179,scope=0x6f757470,element=0};
        streams_size: u32;
        if Native_AudioObjectGetPropertyDataSize(identifier, *streams_address, 0, null, *streams_size) != 0 continue;
        if streams_size < size_of(AudioBufferList) || streams_size > 1048576 continue;
        streams := cast(*AudioBufferList) alloc(streams_size);
        if !streams continue;
        code := Native_AudioObjectGetPropertyData(identifier, *streams_address, 0, null, *streams_size, streams);
        outputs: u32 = 0;
        if code == 0 && streams.mNumberBuffers <= (streams_size-8)/size_of(AudioBuffer) {
            buffers := *streams.mBuffers[0];
            for buffer: 0..streams.mNumberBuffers-1 outputs += buffers[buffer].mNumberChannels;
        }
        Audio_Backend_Basic.free(streams);
        if outputs == 0 continue;
        name_address: Native_AudioObjectPropertyAddress = .{selector=0x6c6e616d,scope=0x676c6f62,element=0};
        name: CFStringRef;
        name_size: u32 = size_of(CFStringRef);
        if Native_AudioObjectGetPropertyData(identifier, *name_address, 0, null, *name_size, *name) != 0 || !name continue;
        device: Output_Device;
        device.name = to_string(name);
        CFRelease(name);
        device.device_index = identifier;
        array_add(*core_audio_output_devices, device);
    }
    return core_audio_output_devices;
}
#scope_file
AudioFormatID :: u32 ;
AudioFilePropertyID :: u32 ;
AudioFileTypeID :: u32 ;
AudioStreamBasicDescription :: struct {
    mSampleRate : float64 ;
    mFormatID : AudioFormatID ;
    mFormatFlags : AudioFormatFlags ;
    mBytesPerPacket : u32 ;
    mFramesPerPacket : u32 ;
    mBytesPerFrame : u32 ;
    mChannelsPerFrame : u32 ;
    mBitsPerChannel : u32 ;
    mReserved : u32 ;
}
using AudioFormatFlags :: enum u32 {
    kAudioFormatFlagIsFloat :: ( 1 << 0 ) ;
    kAudioFormatFlagIsBigEndian :: ( 1 << 1 ) ;
    kAudioFormatFlagIsSignedInteger :: ( 1 << 2 ) ;
    kAudioFormatFlagIsPacked :: ( 1 << 3 ) ;
    kAudioFormatFlagIsAlignedHigh :: ( 1 << 4 ) ;
    kAudioFormatFlagIsNonInterleaved :: ( 1 << 5 ) ;
    kAudioFormatFlagIsNonMixable :: ( 1 << 6 ) ;
    kAudioFormatFlagsAreAllClear :: 0x80000000 ;
    kLinearPCMFormatFlagIsFloat :: kAudioFormatFlagIsFloat ;
    kLinearPCMFormatFlagIsBigEndian :: kAudioFormatFlagIsBigEndian ;
    kLinearPCMFormatFlagIsSignedInteger :: kAudioFormatFlagIsSignedInteger ;
    kLinearPCMFormatFlagIsPacked :: kAudioFormatFlagIsPacked ;
    kLinearPCMFormatFlagIsAlignedHigh :: kAudioFormatFlagIsAlignedHigh ;
    kLinearPCMFormatFlagIsNonInterleaved :: kAudioFormatFlagIsNonInterleaved ;
    kLinearPCMFormatFlagIsNonMixable :: kAudioFormatFlagIsNonMixable ;
    kLinearPCMFormatFlagsSampleFractionShift :: 7 ;
    kLinearPCMFormatFlagsSampleFractionMask :: ( 0x3F << kLinearPCMFormatFlagsSampleFractionShift ) ;
    kLinearPCMFormatFlagsAreAllClear :: kAudioFormatFlagsAreAllClear ;
    kAppleLosslessFormatFlag_16BitSourceData :: 1 ;
    kAppleLosslessFormatFlag_20BitSourceData :: 2 ;
    kAppleLosslessFormatFlag_24BitSourceData :: 3 ;
    kAppleLosslessFormatFlag_32BitSourceData :: 4 ;
}
kAudioFormatLinearPCM : AudioFormatID : 0x6c70636d ;
kAudioFormatAC3 : AudioFormatID : 0x61632d33 ;
kAudioFormat60958AC3 : AudioFormatID : 0x63616333 ;
kAudioFormatAppleIMA4 : AudioFormatID : 0x696d6134 ;
kAudioFormatMPEG4AAC : AudioFormatID : 0x61616320 ;
kAudioFormatMPEG4CELP : AudioFormatID : 0x63656c70 ;
kAudioFormatMPEG4HVXC : AudioFormatID : 0x68767863 ;
kAudioFormatMPEG4TwinVQ : AudioFormatID : 0x74777671 ;
kAudioFormatMACE3 : AudioFormatID : 0x4d414333 ;
kAudioFormatMACE6 : AudioFormatID : 0x4d414336 ;
kAudioFormatULaw : AudioFormatID : 0x756c6177 ;
kAudioFormatALaw : AudioFormatID : 0x616c6177 ;
kAudioFormatQDesign : AudioFormatID : 0x51444d43 ;
kAudioFormatQDesign2 : AudioFormatID : 0x51444d32 ;
kAudioFormatQUALCOMM : AudioFormatID : 0x51636c70 ;
kAudioFormatMPEGLayer1 : AudioFormatID : 0x2e6d7031 ;
kAudioFormatMPEGLayer2 : AudioFormatID : 0x2e6d7032 ;
kAudioFormatMPEGLayer3 : AudioFormatID : 0x2e6d7033 ;
kAudioFormatTimeCode : AudioFormatID : 0x74696d65 ;
kAudioFormatMIDIStream : AudioFormatID : 0x6d696469 ;
kAudioFormatParameterValueStream : AudioFormatID : 0x61707673 ;
kAudioFormatAppleLossless : AudioFormatID : 0x616c6163 ;
kAudioFormatMPEG4AAC_HE : AudioFormatID : 0x61616368 ;
kAudioFormatMPEG4AAC_LD : AudioFormatID : 0x6161636c ;
kAudioFormatMPEG4AAC_ELD : AudioFormatID : 0x61616365 ;
kAudioFormatMPEG4AAC_ELD_SBR : AudioFormatID : 0x61616366 ;
kAudioFormatMPEG4AAC_ELD_V2 : AudioFormatID : 0x61616367 ;
kAudioFormatMPEG4AAC_HE_V2 : AudioFormatID : 0x61616370 ;
kAudioFormatMPEG4AAC_Spatial : AudioFormatID : 0x61616373 ;
kAudioFormatAMR : AudioFormatID : 0x73616d72 ;
kAudioFormatAMR_WB : AudioFormatID : 0x73617762 ;
kAudioFormatAudible : AudioFormatID : 0x41554442 ;
kAudioFormatiLBC : AudioFormatID : 0x696c6263 ;
kAudioFormatDVIIntelIMA : AudioFormatID : 0x6D730011 ;
kAudioFormatMicrosoftGSM : AudioFormatID : 0x6D730031 ;
kAudioFormatAES3 : AudioFormatID : 0x61657333 ;
kAudioFormatEnhancedAC3 : AudioFormatID : 0x65632d33 ;
kAudioFormatFLAC : AudioFormatID : 0x666c6163 ;
kAudioFormatOpus : AudioFormatID : 0x6f707573 ;
OpaqueAudioFileID :: struct {
}
AudioFileID :: * OpaqueAudioFileID ;
using AudioFilePermissions :: enum s8 {
    kAudioFileReadPermission :: 0x01 ;
    kAudioFileWritePermission :: 0x02 ;
    kAudioFileReadWritePermission :: 0x03 ;
}
AudioFileGetPropertyInfo :: ( inAudioFile : AudioFileID , inPropertyID : AudioFilePropertyID , outDataSize : * u32 , isWritable : * u32 ) -> OSStatus #foreign CoreAudio ;
AudioFileGetProperty :: ( inAudioFile : AudioFileID , inPropertyID : AudioFilePropertyID , ioDataSize : * u32 , outPropertyData : * void ) -> OSStatus #foreign CoreAudio ;
AUNode :: s32 ;
OpaqueAUGraph :: struct {
}
AUGraph :: * OpaqueAUGraph ;
using AudioBytePacketTranslationFlags :: enum_flags u32 {
    kBytePacketTranslationFlag_IsEstimate :: 1 ;
}
AudioFramePacketTranslation :: struct {
    mFrame : s64 ;
    mPacket : s64 ;
    mFrameOffsetInPacket : u32 ;
}
AudioBytePacketTranslation :: struct {
    mByte : s64 ;
    mPacket : s64 ;
    mByteOffsetInPacket : u32 ;
    mFlags : AudioBytePacketTranslationFlags ;
}
AudioFilePacketTableInfo :: struct {
    mNumberValidFrames : s64 ;
    mPrimingFrames : s32 ;
    mRemainderFrames : s32 ;
}
AudioComponentDescription :: struct {
    componentType : OSType ;
    componentSubType : OSType ;
    componentManufacturer : OSType ;
    componentFlags : u32 ;
    componentFlagsMask : u32 ;
}
OpaqueAudioComponent :: struct {
}
AudioComponent :: * OpaqueAudioComponent ;
ComponentInstanceRecord :: struct {
}
AudioComponentInstance :: * ComponentInstanceRecord ;
AudioUnit :: AudioComponentInstance ;
kAudioUnitType_Output :: 0x61756f75 ;
kAudioUnitManufacturer_Apple :: 0x6170706c ;
kAudioUnitSubType_DefaultOutput :: 0x64656620 ;
AudioFileOpenURL :: ( inFileRef : CFURLRef , inPermissions : AudioFilePermissions , inFileTypeHint : AudioFileTypeID , outAudioFile : * AudioFileID ) -> OSStatus #foreign AudioToolbox ;
AudioFileClose :: ( inAudioFile : AudioFileID ) -> OSStatus #foreign AudioToolbox ;
using SMPTETimeType :: enum u32 {
    kSMPTETimeType24 :: 0 ;
    kSMPTETimeType25 :: 1 ;
    kSMPTETimeType30Drop :: 2 ;
    kSMPTETimeType30 :: 3 ;
    kSMPTETimeType2997 :: 4 ;
    kSMPTETimeType2997Drop :: 5 ;
    kSMPTETimeType60 :: 6 ;
    kSMPTETimeType5994 :: 7 ;
    kSMPTETimeType60Drop :: 8 ;
    kSMPTETimeType5994Drop :: 9 ;
    kSMPTETimeType50 :: 10 ;
    kSMPTETimeType2398 :: 11 ;
}
using SMPTETimeFlags :: enum u32 {
    kSMPTETimeUnknown :: 0 ;
    kSMPTETimeValid :: ( 1 << 0 ) ;
    kSMPTETimeRunning :: ( 1 << 1 ) ;
}
SMPTETime :: struct {
    mSubframes : s16 ;
    mSubframeDivisor : s16 ;
    mCounter : u32 ;
    mType : SMPTETimeType ;
    mFlags : SMPTETimeFlags ;
    mHours : s16 ;
    mMinutes : s16 ;
    mSeconds : s16 ;
    mFrames : s16 ;
}
using AudioTimeStampFlags :: enum_flags u32 {
    kAudioTimeStampNothingValid :: 0 ;
    kAudioTimeStampSampleTimeValid :: ( 1 << 0 ) ;
    kAudioTimeStampHostTimeValid :: ( 1 << 1 ) ;
    kAudioTimeStampRateScalarValid :: ( 1 << 2 ) ;
    kAudioTimeStampWordClockTimeValid :: ( 1 << 3 ) ;
    kAudioTimeStampSMPTETimeValid :: ( 1 << 4 ) ;
    kAudioTimeStampSampleHostTimeValid :: ( kAudioTimeStampSampleTimeValid | kAudioTimeStampHostTimeValid ) ;
}
using AudioUnitRenderActionFlags :: enum_flags u32 {
    kAudioUnitRenderAction_PreRender :: ( 1 << 2 ) ;
    kAudioUnitRenderAction_PostRender :: ( 1 << 3 ) ;
    kAudioUnitRenderAction_OutputIsSilence :: ( 1 << 4 ) ;
    kAudioOfflineUnitRenderAction_Preflight :: ( 1 << 5 ) ;
    kAudioOfflineUnitRenderAction_Render :: ( 1 << 6 ) ;
    kAudioOfflineUnitRenderAction_Complete :: ( 1 << 7 ) ;
    kAudioUnitRenderAction_PostRenderError :: ( 1 << 8 ) ;
    kAudioUnitRenderAction_DoNotCheckRenderArgs :: ( 1 << 9 ) ;
}
AudioTimeStamp :: struct {
    mSampleTime : float64 ;
    mHostTime : u64 ;
    mRateScalar : float64 ;
    mWordClockTime : u64 ;
    mSMPTETime : SMPTETime ;
    mFlags : AudioTimeStampFlags ;
    mReserved : u32 ;
}
;
AURenderCallback :: #type ( inRefCon : * void , ioActionFlags : * AudioUnitRenderActionFlags , inTimeStamp : * AudioTimeStamp , inBusNumber : u32 , inNumberFrames : u32 , ioData : * AudioBufferList ) -> OSStatus #c_call ;
AURenderCallbackStruct :: struct {
    inputProc : AURenderCallback ;
    inputProcRefCon : * void ;
}
AudioBuffer :: struct {
    mNumberChannels : u32 ;
    mDataByteSize : u32 ;
    mData : * void ;
}
AudioBufferList :: struct {
    mNumberBuffers : u32 ;
    mBuffers : [ 1 ] AudioBuffer ;
}
using AudioUnitPropertyID :: enum u32 {
    kAudioUnitProperty_ClassInfo :: 0 ;
    kAudioUnitProperty_MakeConnection :: 1 ;
    kAudioUnitProperty_SampleRate :: 2 ;
    kAudioUnitProperty_ParameterList :: 3 ;
    kAudioUnitProperty_ParameterInfo :: 4 ;
    kAudioUnitProperty_CPULoad :: 6 ;
    kAudioUnitProperty_StreamFormat :: 8 ;
    kAudioUnitProperty_ElementCount :: 11 ;
    kAudioUnitProperty_Latency :: 12 ;
    kAudioUnitProperty_SupportedNumChannels :: 13 ;
    kAudioUnitProperty_MaximumFramesPerSlice :: 14 ;
    kAudioUnitProperty_ParameterValueStrings :: 16 ;
    kAudioUnitProperty_AudioChannelLayout :: 19 ;
    kAudioUnitProperty_TailTime :: 20 ;
    kAudioUnitProperty_BypassEffect :: 21 ;
    kAudioUnitProperty_LastRenderError :: 22 ;
    kAudioUnitProperty_SetRenderCallback :: 23 ;
    kAudioUnitProperty_FactoryPresets :: 24 ;
    kAudioUnitProperty_RenderQuality :: 26 ;
    kAudioUnitProperty_HostCallbacks :: 27 ;
    kAudioUnitProperty_InPlaceProcessing :: 29 ;
    kAudioUnitProperty_ElementName :: 30 ;
    kAudioUnitProperty_SupportedChannelLayoutTags :: 32 ;
    kAudioUnitProperty_PresentPreset :: 36 ;
    kAudioUnitProperty_DependentParameters :: 45 ;
    kAudioUnitProperty_InputSamplesInOutput :: 49 ;
    kAudioUnitProperty_ShouldAllocateBuffer :: 51 ;
    kAudioUnitProperty_FrequencyResponse :: 52 ;
    kAudioUnitProperty_ParameterHistoryInfo :: 53 ;
    kAudioUnitProperty_NickName :: 54 ;
    kAudioUnitProperty_OfflineRender :: 37 ;
    kAudioUnitProperty_ParameterIDName :: 34 ;
    kAudioUnitProperty_ParameterStringFromValue :: 33 ;
    kAudioUnitProperty_ParameterClumpName :: 35 ;
    kAudioUnitProperty_ParameterValueFromString :: 38 ;
    kAudioUnitProperty_ContextName :: 25 ;
    kAudioUnitProperty_PresentationLatency :: 40 ;
    kAudioUnitProperty_ClassInfoFromDocument :: 50 ;
    kAudioUnitProperty_RequestViewController :: 56 ;
    kAudioUnitProperty_ParametersForOverview :: 57 ;
    kAudioUnitProperty_SupportsMPE :: 58 ;
    kAudioUnitProperty_FastDispatch :: 5 ;
    kAudioUnitProperty_SetExternalBuffer :: 15 ;
    kAudioUnitProperty_GetUIComponentList :: 18 ;
    kAudioUnitProperty_CocoaUI :: 31 ;
    kAudioUnitProperty_IconLocation :: 39 ;
    kAudioUnitProperty_AUHostIdentifier :: 46 ;
    kAudioUnitProperty_MIDIOutputCallbackInfo :: 47 ;
    kAudioUnitProperty_MIDIOutputCallback :: 48 ;
}
using AudioUnitScope :: enum u32 {
    kAudioUnitScope_Global :: 0 ;
    kAudioUnitScope_Input :: 1 ;
    kAudioUnitScope_Output :: 2 ;
    kAudioUnitScope_Group :: 3 ;
    kAudioUnitScope_Part :: 4 ;
    kAudioUnitScope_Note :: 5 ;
    kAudioUnitScope_Layer :: 6 ;
    kAudioUnitScope_LayerItem :: 7 ;
}
AudioUnitElement :: u32 ;
AudioOutputUnitStop :: ( ci : AudioUnit ) -> OSStatus #foreign AudioToolbox ;
AudioOutputUnitStart :: ( ci : AudioUnit ) -> OSStatus #foreign AudioToolbox ;
AudioUnitUninitialize :: ( inUnit : AudioUnit ) -> OSStatus #foreign AudioToolbox ;
AudioUnitInitialize :: ( inUnit : AudioUnit ) -> OSStatus #foreign AudioToolbox ;
AudioUnitSetProperty :: ( inUnit : AudioUnit , inID : AudioUnitPropertyID , inScope : AudioUnitScope , inElement : AudioUnitElement , inData : * void , inDataSize : u32 ) -> OSStatus #foreign AudioToolbox ;
AudioComponentInstanceDispose :: ( inInstance : AudioComponentInstance ) -> OSStatus #foreign AudioToolbox ;
AudioComponentInstanceNew :: ( inComponent : AudioComponent , outInstance : * AudioComponentInstance ) -> OSStatus #foreign AudioToolbox ;
AudioComponentFindNext :: ( inComponent : AudioComponent , inDesc : * AudioComponentDescription ) -> AudioComponent #foreign AudioToolbox ;
AUGraphStart :: ( inGraph : AUGraph ) -> OSStatus #foreign AudioToolbox #deprecated ;
NewAUGraph :: ( outGraph : * AUGraph ) -> OSStatus #foreign AudioToolbox #deprecated ;
AUGraphAddNode :: ( inGraph : AUGraph , inDescription : * AudioComponentDescription , outNode : * AUNode ) -> OSStatus #foreign AudioToolbox #deprecated ;
AUGraphNodeInfo :: ( inGraph : AUGraph , inNode : AUNode , outDescription : * AudioComponentDescription , outAudioUnit : * AudioUnit ) -> OSStatus #foreign AudioToolbox #deprecated ;
AUGraphOpen :: ( inGraph : AUGraph ) -> OSStatus #foreign AudioToolbox #deprecated ;
AUGraphConnectNodeInput :: ( inGraph : AUGraph , inSourceNode : AUNode , inSourceOutputNumber : u32 , inDestNode : AUNode , inDestInputNumber : u32 ) -> OSStatus #foreign AudioToolbox #deprecated ;
AUGraphInitialize :: ( inGraph : AUGraph ) -> OSStatus #foreign AudioToolbox #deprecated ;
AudioToolbox :: #system_library "AudioToolbox" ;
CoreAudio :: #system_library "CoreAudio" ;
_AudioUnit :: #system_library "AudioUnit" ;
#scope_file
;
output_unit : AudioUnit ;
ring_buffer : Ring_Buffer ;
minimum_prebuffered_bytes : s64 ;
num_channels : s32 ;
channel_names : [ .. ] string ;


#scope_file
Native_AudioObjectPropertyAddress :: struct { selector: u32; scope: u32; element: u32; }
Native_AudioObjectGetPropertyDataSize :: (object: u32, address: *Native_AudioObjectPropertyAddress,
    qualifier_size: u32, qualifier: *void, size: *u32) -> OSStatus #foreign CoreAudio "AudioObjectGetPropertyDataSize";
Native_AudioObjectGetPropertyData :: (object: u32, address: *Native_AudioObjectPropertyAddress,
    qualifier_size: u32, qualifier: *void, size: *u32, data: *void) -> OSStatus #foreign CoreAudio "AudioObjectGetPropertyData";
core_audio_output_devices: [..]Output_Device;

#scope_file
Audio_Backend_Basic :: #import "Basic";
