// Normalized API contracts; reference procedure bodies were discarded.
AMOTION_EVENT_ACTION_POINTER_INDEX_SHIFT :: 8;
AAssetManager :: struct {}
AAssetDir :: struct {}
AAsset :: struct {}
AASSET_MODE :: enum u32 {
    UNKNOWN :: 0;
    RANDOM :: 1;
    STREAMING :: 2;
    BUFFER :: 3;
}
AAssetManager_openDir :: (mgr: *AAssetManager, dirName: *u8) -> *AAssetDir #foreign libandroid;
AAssetManager_open :: (mgr: *AAssetManager, filename: *u8, mode: AASSET_MODE) -> *AAsset #foreign libandroid;
AAssetDir_getNextFileName :: (assetDir: *AAssetDir) -> *u8 #foreign libandroid;
AAssetDir_rewind :: (assetDir: *AAssetDir) -> void #foreign libandroid;
AAssetDir_close :: (assetDir: *AAssetDir) -> void #foreign libandroid;
AAsset_read :: (asset: *AAsset, buf: *void, count: u64) -> s32 #foreign libandroid;
AAsset_seek :: (asset: *AAsset, offset: s64, whence: s32) -> s64 #foreign libandroid;
AAsset_seek64 :: (asset: *AAsset, offset: s64, whence: s32) -> s64 #foreign libandroid;
AAsset_close :: (asset: *AAsset) -> void #foreign libandroid;
AAsset_getBuffer :: (asset: *AAsset) -> *void #foreign libandroid;
AAsset_getLength :: (asset: *AAsset) -> s64 #foreign libandroid;
AAsset_getLength64 :: (asset: *AAsset) -> s64 #foreign libandroid;
AAsset_getRemainingLength :: (asset: *AAsset) -> s64 #foreign libandroid;
AAsset_getRemainingLength64 :: (asset: *AAsset) -> s64 #foreign libandroid;
AAsset_openFileDescriptor :: (asset: *AAsset, outStart: *s64, outLength: *s64) -> s32 #foreign libandroid;
AAsset_openFileDescriptor64 :: (asset: *AAsset, outStart: *s64, outLength: *s64) -> s32 #foreign libandroid;
AAsset_isAllocated :: (asset: *AAsset) -> s32 #foreign libandroid;
AConfiguration :: struct {}
ACONFIGURATION :: enum u32 {
    ORIENTATION_ANY :: 0;
    ORIENTATION_PORT :: 1;
    ORIENTATION_LAND :: 2;
    ORIENTATION_SQUARE :: 3;
    TOUCHSCREEN_ANY :: 0;
    TOUCHSCREEN_NOTOUCH :: 1;
    TOUCHSCREEN_STYLUS :: 2;
    TOUCHSCREEN_FINGER :: 3;
    DENSITY_DEFAULT :: 0;
    DENSITY_LOW :: 120;
    DENSITY_MEDIUM :: 160;
    DENSITY_TV :: 213;
    DENSITY_HIGH :: 240;
    DENSITY_XHIGH :: 320;
    DENSITY_XXHIGH :: 480;
    DENSITY_XXXHIGH :: 640;
    DENSITY_ANY :: 65534;
    DENSITY_NONE :: 65535;
    KEYBOARD_ANY :: 0;
    KEYBOARD_NOKEYS :: 1;
    KEYBOARD_QWERTY :: 2;
    KEYBOARD_12KEY :: 3;
    NAVIGATION_ANY :: 0;
    NAVIGATION_NONAV :: 1;
    NAVIGATION_DPAD :: 2;
    NAVIGATION_TRACKBALL :: 3;
    NAVIGATION_WHEEL :: 4;
    KEYSHIDDEN_ANY :: 0;
    KEYSHIDDEN_NO :: 1;
    KEYSHIDDEN_YES :: 2;
    KEYSHIDDEN_SOFT :: 3;
    NAVHIDDEN_ANY :: 0;
    NAVHIDDEN_NO :: 1;
    NAVHIDDEN_YES :: 2;
    SCREENSIZE_ANY :: 0;
    SCREENSIZE_SMALL :: 1;
    SCREENSIZE_NORMAL :: 2;
    SCREENSIZE_LARGE :: 3;
    SCREENSIZE_XLARGE :: 4;
    SCREENLONG_ANY :: 0;
    SCREENLONG_NO :: 1;
    SCREENLONG_YES :: 2;
    SCREENROUND_ANY :: 0;
    SCREENROUND_NO :: 1;
    SCREENROUND_YES :: 2;
    WIDE_COLOR_GAMUT_ANY :: 0;
    WIDE_COLOR_GAMUT_NO :: 1;
    WIDE_COLOR_GAMUT_YES :: 2;
    HDR_ANY :: 0;
    HDR_NO :: 1;
    HDR_YES :: 2;
    UI_MODE_TYPE_ANY :: 0;
    UI_MODE_TYPE_NORMAL :: 1;
    UI_MODE_TYPE_DESK :: 2;
    UI_MODE_TYPE_CAR :: 3;
    UI_MODE_TYPE_TELEVISION :: 4;
    UI_MODE_TYPE_APPLIANCE :: 5;
    UI_MODE_TYPE_WATCH :: 6;
    UI_MODE_TYPE_VR_HEADSET :: 7;
    UI_MODE_NIGHT_ANY :: 0;
    UI_MODE_NIGHT_NO :: 1;
    UI_MODE_NIGHT_YES :: 2;
    SCREEN_WIDTH_DP_ANY :: 0;
    SCREEN_HEIGHT_DP_ANY :: 0;
    SMALLEST_SCREEN_WIDTH_DP_ANY :: 0;
    LAYOUTDIR_ANY :: 0;
    LAYOUTDIR_LTR :: 1;
    LAYOUTDIR_RTL :: 2;
    MCC :: 1;
    MNC :: 2;
    LOCALE :: 4;
    TOUCHSCREEN :: 8;
    KEYBOARD :: 16;
    KEYBOARD_HIDDEN :: 32;
    NAVIGATION :: 64;
    ORIENTATION :: 128;
    DENSITY :: 256;
    SCREEN_SIZE :: 512;
    VERSION :: 1024;
    SCREEN_LAYOUT :: 2048;
    UI_MODE :: 4096;
    SMALLEST_SCREEN_SIZE :: 8192;
    LAYOUTDIR :: 16384;
    SCREEN_ROUND :: 32768;
    COLOR_MODE :: 65536;
    MNC_ZERO :: 65535;
}
AConfiguration_new :: (__args: ..Any) -> *AConfiguration #foreign libandroid;
AConfiguration_delete :: (config: *AConfiguration) -> void #foreign libandroid;
AConfiguration_fromAssetManager :: (out: *AConfiguration, am: *AAssetManager) -> void #foreign libandroid;
AConfiguration_copy :: (dest: *AConfiguration, src: *AConfiguration) -> void #foreign libandroid;
AConfiguration_getMcc :: (config: *AConfiguration) -> s32 #foreign libandroid;
AConfiguration_setMcc :: (config: *AConfiguration, mcc: s32) -> void #foreign libandroid;
AConfiguration_getMnc :: (config: *AConfiguration) -> s32 #foreign libandroid;
AConfiguration_setMnc :: (config: *AConfiguration, mnc: s32) -> void #foreign libandroid;
AConfiguration_getLanguage :: (config: *AConfiguration, outLanguage: *u8) -> void #foreign libandroid;
AConfiguration_setLanguage :: (config: *AConfiguration, language: *u8) -> void #foreign libandroid;
AConfiguration_getCountry :: (config: *AConfiguration, outCountry: *u8) -> void #foreign libandroid;
AConfiguration_setCountry :: (config: *AConfiguration, country: *u8) -> void #foreign libandroid;
AConfiguration_getOrientation :: (config: *AConfiguration) -> s32 #foreign libandroid;
AConfiguration_setOrientation :: (config: *AConfiguration, orientation: s32) -> void #foreign libandroid;
AConfiguration_getTouchscreen :: (config: *AConfiguration) -> s32 #foreign libandroid;
AConfiguration_setTouchscreen :: (config: *AConfiguration, touchscreen: s32) -> void #foreign libandroid;
AConfiguration_getDensity :: (config: *AConfiguration) -> s32 #foreign libandroid;
AConfiguration_setDensity :: (config: *AConfiguration, density: s32) -> void #foreign libandroid;
AConfiguration_getKeyboard :: (config: *AConfiguration) -> s32 #foreign libandroid;
AConfiguration_setKeyboard :: (config: *AConfiguration, keyboard: s32) -> void #foreign libandroid;
AConfiguration_getNavigation :: (config: *AConfiguration) -> s32 #foreign libandroid;
AConfiguration_setNavigation :: (config: *AConfiguration, navigation: s32) -> void #foreign libandroid;
AConfiguration_getKeysHidden :: (config: *AConfiguration) -> s32 #foreign libandroid;
AConfiguration_setKeysHidden :: (config: *AConfiguration, keysHidden: s32) -> void #foreign libandroid;
AConfiguration_getNavHidden :: (config: *AConfiguration) -> s32 #foreign libandroid;
AConfiguration_setNavHidden :: (config: *AConfiguration, navHidden: s32) -> void #foreign libandroid;
AConfiguration_getSdkVersion :: (config: *AConfiguration) -> s32 #foreign libandroid;
AConfiguration_setSdkVersion :: (config: *AConfiguration, sdkVersion: s32) -> void #foreign libandroid;
AConfiguration_getScreenSize :: (config: *AConfiguration) -> s32 #foreign libandroid;
AConfiguration_setScreenSize :: (config: *AConfiguration, screenSize: s32) -> void #foreign libandroid;
AConfiguration_getScreenLong :: (config: *AConfiguration) -> s32 #foreign libandroid;
AConfiguration_setScreenLong :: (config: *AConfiguration, screenLong: s32) -> void #foreign libandroid;
AConfiguration_getScreenRound :: (config: *AConfiguration) -> s32 #foreign libandroid;
AConfiguration_getUiModeType :: (config: *AConfiguration) -> s32 #foreign libandroid;
AConfiguration_setUiModeType :: (config: *AConfiguration, uiModeType: s32) -> void #foreign libandroid;
AConfiguration_getUiModeNight :: (config: *AConfiguration) -> s32 #foreign libandroid;
AConfiguration_setUiModeNight :: (config: *AConfiguration, uiModeNight: s32) -> void #foreign libandroid;
AConfiguration_getScreenWidthDp :: (config: *AConfiguration) -> s32 #foreign libandroid;
AConfiguration_setScreenWidthDp :: (config: *AConfiguration, value: s32) -> void #foreign libandroid;
AConfiguration_getScreenHeightDp :: (config: *AConfiguration) -> s32 #foreign libandroid;
AConfiguration_setScreenHeightDp :: (config: *AConfiguration, value: s32) -> void #foreign libandroid;
AConfiguration_getSmallestScreenWidthDp :: (config: *AConfiguration) -> s32 #foreign libandroid;
AConfiguration_setSmallestScreenWidthDp :: (config: *AConfiguration, value: s32) -> void #foreign libandroid;
AConfiguration_getLayoutDirection :: (config: *AConfiguration) -> s32 #foreign libandroid;
AConfiguration_setLayoutDirection :: (config: *AConfiguration, value: s32) -> void #foreign libandroid;
AConfiguration_diff :: (config1: *AConfiguration, config2: *AConfiguration) -> s32 #foreign libandroid;
AConfiguration_match :: (base: *AConfiguration, requested: *AConfiguration) -> s32 #foreign libandroid;
AConfiguration_isBetterThan :: (base: *AConfiguration, test: *AConfiguration, requested: *AConfiguration) -> s32 #foreign libandroid;
ALooper :: struct {}
ALooper_forThread :: (__args: ..Any) -> *ALooper #foreign libandroid;
anon_enum :: enum u32 {
    ALOOPER_PREPARE_ALLOW_NON_CALLBACKS :: 1;
}
ALooper_prepare :: (opts: s32) -> *ALooper #foreign libandroid;
ALOOPER_POLL :: enum s32 {
    WAKE :: -1;
    CALLBACK :: -2;
    TIMEOUT :: -3;
    ERROR :: -4;
}
ALooper_acquire :: (looper: *ALooper) -> void #foreign libandroid;
ALooper_release :: (looper: *ALooper) -> void #foreign libandroid;
ALOOPER_EVENT :: enum u32 {
    INPUT :: 1;
    OUTPUT :: 2;
    ERROR :: 4;
    HANGUP :: 8;
    INVALID :: 16;
}
ALooper_callbackFunc :: #type (fd: s32, events: s32, data: *void) -> s32 #c_call;
ALooper_pollOnce :: (timeoutMillis: s32, outFd: *s32, outEvents: *s32, outData: **void) -> s32 #foreign libandroid;
ALooper_pollAll :: (timeoutMillis: s32, outFd: *s32, outEvents: *s32, outData: **void) -> s32 #foreign libandroid;
ALooper_wake :: (looper: *ALooper) -> void #foreign libandroid;
ALooper_addFd :: (looper: *ALooper, fd: s32, ident: s32, events: s32, callback: ALooper_callbackFunc, data: *void) -> s32 #foreign libandroid;
ALooper_removeFd :: (looper: *ALooper, fd: s32) -> s32 #foreign libandroid;
AKEY_STATE :: enum s32 {
    UNKNOWN :: -1;
    UP :: 0;
    DOWN :: 1;
    VIRTUAL :: 2;
}
AMETA :: enum u32 {
    NONE :: 0;
    ALT_ON :: 2;
    ALT_LEFT_ON :: 16;
    ALT_RIGHT_ON :: 32;
    SHIFT_ON :: 1;
    SHIFT_LEFT_ON :: 64;
    SHIFT_RIGHT_ON :: 128;
    SYM_ON :: 4;
    FUNCTION_ON :: 8;
    CTRL_ON :: 4096;
    CTRL_LEFT_ON :: 8192;
    CTRL_RIGHT_ON :: 16384;
    META_ON :: 65536;
    META_LEFT_ON :: 131072;
    META_RIGHT_ON :: 262144;
    CAPS_LOCK_ON :: 1048576;
    NUM_LOCK_ON :: 2097152;
    SCROLL_LOCK_ON :: 4194304;
}
AInputEvent :: struct {}
AINPUT_EVENT_TYPE :: enum u32 {
    KEY :: 1;
    MOTION :: 2;
    FOCUS :: 3;
    CAPTURE :: 4;
    DRAG :: 5;
    TOUCH_MODE :: 6;
}
AKEY_EVENT_ACTION :: enum u32 {
    DOWN :: 0;
    UP :: 1;
    MULTIPLE :: 2;
}
AKEY_EVENT_FLAG :: enum u32 {
    WOKE_HERE :: 1;
    SOFT_KEYBOARD :: 2;
    KEEP_TOUCH_MODE :: 4;
    FROM_SYSTEM :: 8;
    EDITOR_ACTION :: 16;
    CANCELED :: 32;
    VIRTUAL_HARD_KEY :: 64;
    LONG_PRESS :: 128;
    CANCELED_LONG_PRESS :: 256;
    TRACKING :: 512;
    FALLBACK :: 1024;
}
AMOTION_EVENT_ACTION :: enum u32 {
    MASK :: 255;
    POINTER_INDEX_MASK :: 65280;
    DOWN :: 0;
    UP :: 1;
    MOVE :: 2;
    CANCEL :: 3;
    OUTSIDE :: 4;
    POINTER_DOWN :: 5;
    POINTER_UP :: 6;
    HOVER_MOVE :: 7;
    SCROLL :: 8;
    HOVER_ENTER :: 9;
    HOVER_EXIT :: 10;
    BUTTON_PRESS :: 11;
    BUTTON_RELEASE :: 12;
}
anon_enum_1 :: enum u32 {
    AMOTION_EVENT_FLAG_WINDOW_IS_OBSCURED :: 1;
}
AMOTION_EVENT_EDGE_FLAG :: enum u32 {
    NONE :: 0;
    TOP :: 1;
    BOTTOM :: 2;
    LEFT :: 4;
    RIGHT :: 8;
}
AMOTION_EVENT_AXIS :: enum u32 {
    X :: 0;
    Y :: 1;
    PRESSURE :: 2;
    SIZE :: 3;
    TOUCH_MAJOR :: 4;
    TOUCH_MINOR :: 5;
    TOOL_MAJOR :: 6;
    TOOL_MINOR :: 7;
    ORIENTATION :: 8;
    VSCROLL :: 9;
    HSCROLL :: 10;
    Z :: 11;
    RX :: 12;
    RY :: 13;
    RZ :: 14;
    HAT_X :: 15;
    HAT_Y :: 16;
    LTRIGGER :: 17;
    RTRIGGER :: 18;
    THROTTLE :: 19;
    RUDDER :: 20;
    WHEEL :: 21;
    GAS :: 22;
    BRAKE :: 23;
    DISTANCE :: 24;
    TILT :: 25;
    SCROLL :: 26;
    RELATIVE_X :: 27;
    RELATIVE_Y :: 28;
    GENERIC_1 :: 32;
    GENERIC_2 :: 33;
    GENERIC_3 :: 34;
    GENERIC_4 :: 35;
    GENERIC_5 :: 36;
    GENERIC_6 :: 37;
    GENERIC_7 :: 38;
    GENERIC_8 :: 39;
    GENERIC_9 :: 40;
    GENERIC_10 :: 41;
    GENERIC_11 :: 42;
    GENERIC_12 :: 43;
    GENERIC_13 :: 44;
    GENERIC_14 :: 45;
    GENERIC_15 :: 46;
    GENERIC_16 :: 47;
}
AMOTION_EVENT_BUTTON :: enum u32 {
    PRIMARY :: 1;
    SECONDARY :: 2;
    TERTIARY :: 4;
    BACK :: 8;
    FORWARD :: 16;
    STYLUS_PRIMARY :: 32;
    STYLUS_SECONDARY :: 64;
}
AMOTION_EVENT_TOOL_TYPE :: enum u32 {
    UNKNOWN :: 0;
    FINGER :: 1;
    STYLUS :: 2;
    MOUSE :: 3;
    ERASER :: 4;
    PALM :: 5;
}
AMotionClassification :: enum u32 {
    NONE :: 0;
    AMBIGUOUS_GESTURE :: 1;
    DEEP_PRESS :: 2;
}
AINPUT_SOURCE_CLASS :: enum u32 {
    MASK :: 255;
    NONE :: 0;
    BUTTON :: 1;
    POINTER :: 2;
    NAVIGATION :: 4;
    POSITION :: 8;
    JOYSTICK :: 16;
}
AINPUT_SOURCE :: enum u32 {
    UNKNOWN :: 0;
    KEYBOARD :: 257;
    DPAD :: 513;
    GAMEPAD :: 1025;
    TOUCHSCREEN :: 4098;
    MOUSE :: 8194;
    STYLUS :: 16386;
    BLUETOOTH_STYLUS :: 49154;
    TRACKBALL :: 65540;
    MOUSE_RELATIVE :: 131076;
    TOUCHPAD :: 1048584;
    TOUCH_NAVIGATION :: 2097152;
    JOYSTICK :: 16777232;
    HDMI :: 33554433;
    SENSOR :: 67108864;
    ROTARY_ENCODER :: 4194304;
    ANY :: 4294967040;
}
AINPUT_KEYBOARD_TYPE :: enum u32 {
    NONE :: 0;
    NON_ALPHABETIC :: 1;
    ALPHABETIC :: 2;
}
AINPUT_MOTION_RANGE :: enum u32 {
    X :: 0;
    Y :: 1;
    PRESSURE :: 2;
    SIZE :: 3;
    TOUCH_MAJOR :: 4;
    TOUCH_MINOR :: 5;
    TOOL_MAJOR :: 6;
    TOOL_MINOR :: 7;
    ORIENTATION :: 8;
}
AInputEvent_getType :: (event: *AInputEvent) -> AINPUT_EVENT_TYPE #foreign libandroid;
AInputEvent_getDeviceId :: (event: *AInputEvent) -> s32 #foreign libandroid;
AInputEvent_getSource :: (event: *AInputEvent) -> s32 #foreign libandroid;
AInputEvent_release :: (event: *AInputEvent) -> void #foreign libandroid;
AKeyEvent_getAction :: (key_event: *AInputEvent) -> s32 #foreign libandroid;
AKeyEvent_getFlags :: (key_event: *AInputEvent) -> s32 #foreign libandroid;
AKeyEvent_getKeyCode :: (key_event: *AInputEvent) -> s32 #foreign libandroid;
AKeyEvent_getScanCode :: (key_event: *AInputEvent) -> s32 #foreign libandroid;
AKeyEvent_getMetaState :: (key_event: *AInputEvent) -> s32 #foreign libandroid;
AKeyEvent_getRepeatCount :: (key_event: *AInputEvent) -> s32 #foreign libandroid;
AKeyEvent_getDownTime :: (key_event: *AInputEvent) -> s64 #foreign libandroid;
AKeyEvent_getEventTime :: (key_event: *AInputEvent) -> s64 #foreign libandroid;
AKeyEvent_fromJava :: (env: *JNIEnv, keyEvent: jobject) -> *AInputEvent #foreign libandroid;
AMotionEvent_getAction :: (motion_event: *AInputEvent) -> s32 #foreign libandroid;
AMotionEvent_getFlags :: (motion_event: *AInputEvent) -> s32 #foreign libandroid;
AMotionEvent_getMetaState :: (motion_event: *AInputEvent) -> s32 #foreign libandroid;
AMotionEvent_getButtonState :: (motion_event: *AInputEvent) -> s32 #foreign libandroid;
AMotionEvent_getEdgeFlags :: (motion_event: *AInputEvent) -> s32 #foreign libandroid;
AMotionEvent_getDownTime :: (motion_event: *AInputEvent) -> s64 #foreign libandroid;
AMotionEvent_getEventTime :: (motion_event: *AInputEvent) -> s64 #foreign libandroid;
AMotionEvent_getXOffset :: (motion_event: *AInputEvent) -> float #foreign libandroid;
AMotionEvent_getYOffset :: (motion_event: *AInputEvent) -> float #foreign libandroid;
AMotionEvent_getXPrecision :: (motion_event: *AInputEvent) -> float #foreign libandroid;
AMotionEvent_getYPrecision :: (motion_event: *AInputEvent) -> float #foreign libandroid;
AMotionEvent_getPointerCount :: (motion_event: *AInputEvent) -> u64 #foreign libandroid;
AMotionEvent_getPointerId :: (motion_event: *AInputEvent, pointer_index: u64) -> s32 #foreign libandroid;
AMotionEvent_getToolType :: (motion_event: *AInputEvent, pointer_index: u64) -> s32 #foreign libandroid;
AMotionEvent_getRawX :: (motion_event: *AInputEvent, pointer_index: u64) -> float #foreign libandroid;
AMotionEvent_getRawY :: (motion_event: *AInputEvent, pointer_index: u64) -> float #foreign libandroid;
AMotionEvent_getX :: (motion_event: *AInputEvent, pointer_index: u64) -> float #foreign libandroid;
AMotionEvent_getY :: (motion_event: *AInputEvent, pointer_index: u64) -> float #foreign libandroid;
AMotionEvent_getPressure :: (motion_event: *AInputEvent, pointer_index: u64) -> float #foreign libandroid;
AMotionEvent_getSize :: (motion_event: *AInputEvent, pointer_index: u64) -> float #foreign libandroid;
AMotionEvent_getTouchMajor :: (motion_event: *AInputEvent, pointer_index: u64) -> float #foreign libandroid;
AMotionEvent_getTouchMinor :: (motion_event: *AInputEvent, pointer_index: u64) -> float #foreign libandroid;
AMotionEvent_getToolMajor :: (motion_event: *AInputEvent, pointer_index: u64) -> float #foreign libandroid;
AMotionEvent_getToolMinor :: (motion_event: *AInputEvent, pointer_index: u64) -> float #foreign libandroid;
AMotionEvent_getOrientation :: (motion_event: *AInputEvent, pointer_index: u64) -> float #foreign libandroid;
AMotionEvent_getAxisValue :: (motion_event: *AInputEvent, axis: s32, pointer_index: u64) -> float #foreign libandroid;
AMotionEvent_getHistorySize :: (motion_event: *AInputEvent) -> u64 #foreign libandroid;
AMotionEvent_getHistoricalEventTime :: (motion_event: *AInputEvent, history_index: u64) -> s64 #foreign libandroid;
AMotionEvent_getHistoricalRawX :: (motion_event: *AInputEvent, pointer_index: u64, history_index: u64) -> float #foreign libandroid;
AMotionEvent_getHistoricalRawY :: (motion_event: *AInputEvent, pointer_index: u64, history_index: u64) -> float #foreign libandroid;
AMotionEvent_getHistoricalX :: (motion_event: *AInputEvent, pointer_index: u64, history_index: u64) -> float #foreign libandroid;
AMotionEvent_getHistoricalY :: (motion_event: *AInputEvent, pointer_index: u64, history_index: u64) -> float #foreign libandroid;
AMotionEvent_getHistoricalPressure :: (motion_event: *AInputEvent, pointer_index: u64, history_index: u64) -> float #foreign libandroid;
AMotionEvent_getHistoricalSize :: (motion_event: *AInputEvent, pointer_index: u64, history_index: u64) -> float #foreign libandroid;
AMotionEvent_getHistoricalTouchMajor :: (motion_event: *AInputEvent, pointer_index: u64, history_index: u64) -> float #foreign libandroid;
AMotionEvent_getHistoricalTouchMinor :: (motion_event: *AInputEvent, pointer_index: u64, history_index: u64) -> float #foreign libandroid;
AMotionEvent_getHistoricalToolMajor :: (motion_event: *AInputEvent, pointer_index: u64, history_index: u64) -> float #foreign libandroid;
AMotionEvent_getHistoricalToolMinor :: (motion_event: *AInputEvent, pointer_index: u64, history_index: u64) -> float #foreign libandroid;
AMotionEvent_getHistoricalOrientation :: (motion_event: *AInputEvent, pointer_index: u64, history_index: u64) -> float #foreign libandroid;
AMotionEvent_getHistoricalAxisValue :: (motion_event: *AInputEvent, axis: s32, pointer_index: u64, history_index: u64) -> float #foreign libandroid;
AMotionEvent_getActionButton :: (motion_event: *AInputEvent) -> s32 #foreign libandroid;
AMotionEvent_getClassification :: (motion_event: *AInputEvent) -> s32 #foreign libandroid;
AMotionEvent_fromJava :: (env: *JNIEnv, motionEvent: jobject) -> *AInputEvent #foreign libandroid;
AInputQueue :: struct {}
AInputQueue_attachLooper :: (queue: *AInputQueue, looper: *ALooper, ident: s32, callback: ALooper_callbackFunc, data: *void) -> void #foreign libandroid;
AInputQueue_detachLooper :: (queue: *AInputQueue) -> void #foreign libandroid;
AInputQueue_hasEvents :: (queue: *AInputQueue) -> s32 #foreign libandroid;
AInputQueue_getEvent :: (queue: *AInputQueue, outEvent: **AInputEvent) -> s32 #foreign libandroid;
AInputQueue_preDispatchEvent :: (queue: *AInputQueue, event: *AInputEvent) -> s32 #foreign libandroid;
AInputQueue_finishEvent :: (queue: *AInputQueue, event: *AInputEvent, handled: s32) -> void #foreign libandroid;
AInputQueue_fromJava :: (env: *JNIEnv, inputQueue: jobject) -> *AInputQueue #foreign libandroid;
ARect :: struct {
    left: s32;
    top: s32;
    right: s32;
    bottom: s32;
}
ANativeWindow_LegacyFormat :: enum u32 {
    RGBA_8888 :: 1;
    RGBX_8888 :: 2;
    RGB_565 :: 4;
}
ANativeWindowTransform :: enum u32 {
    IDENTITY :: 0;
    MIRROR_HORIZONTAL :: 1;
    MIRROR_VERTICAL :: 2;
    ROTATE_90 :: 4;
    ROTATE_180 :: 3;
    ROTATE_270 :: 7;
}
ANativeWindow :: struct {}
ANativeWindow_Buffer :: struct {
    width: s32;
    height: s32;
    stride: s32;
    format: s32;
    bits: *void;
    reserved: [6] u32;
}
ANativeWindow_acquire :: (window: *ANativeWindow) -> void #foreign libandroid;
ANativeWindow_release :: (window: *ANativeWindow) -> void #foreign libandroid;
ANativeWindow_getWidth :: (window: *ANativeWindow) -> s32 #foreign libandroid;
ANativeWindow_getHeight :: (window: *ANativeWindow) -> s32 #foreign libandroid;
ANativeWindow_getFormat :: (window: *ANativeWindow) -> s32 #foreign libandroid;
ANativeWindow_setBuffersGeometry :: (window: *ANativeWindow, width: s32, height: s32, format: s32) -> s32 #foreign libandroid;
ANativeWindow_lock :: (window: *ANativeWindow, outBuffer: *ANativeWindow_Buffer, inOutDirtyBounds: *ARect) -> s32 #foreign libandroid;
ANativeWindow_unlockAndPost :: (window: *ANativeWindow) -> s32 #foreign libandroid;
ANativeWindow_FrameRateCompatibility :: enum u32 {
    DEFAULT :: 0;
    FIXED_SOURCE :: 1;
}
ANativeWindow_ChangeFrameRateStrategy :: enum u32 {
    ONLY_IF_SEAMLESS :: 0;
    ALWAYS :: 1;
}
ANativeActivity :: struct {
    callbacks: *ANativeActivityCallbacks;
    vm: *JavaVM;
    env: *JNIEnv;
    clazz: jobject;
    internalDataPath: *u8;
    externalDataPath: *u8;
    sdkVersion: s32;
    instance: *void;
    assetManager: *AAssetManager;
    obbPath: *u8;
}
ANativeActivityCallbacks :: struct {
    onStart: #type (activity: *ANativeActivity) -> void #c_call;
    onResume: #type (activity: *ANativeActivity) -> void #c_call;
    onSaveInstanceState: #type (activity: *ANativeActivity, outSize: *u64) -> *void #c_call;
    onPause: #type (activity: *ANativeActivity) -> void #c_call;
    onStop: #type (activity: *ANativeActivity) -> void #c_call;
    onDestroy: #type (activity: *ANativeActivity) -> void #c_call;
    onWindowFocusChanged: #type (activity: *ANativeActivity, hasFocus: s32) -> void #c_call;
    onNativeWindowCreated: #type (activity: *ANativeActivity, window: *ANativeWindow) -> void #c_call;
    onNativeWindowResized: #type (activity: *ANativeActivity, window: *ANativeWindow) -> void #c_call;
    onNativeWindowRedrawNeeded: #type (activity: *ANativeActivity, window: *ANativeWindow) -> void #c_call;
    onNativeWindowDestroyed: #type (activity: *ANativeActivity, window: *ANativeWindow) -> void #c_call;
    onInputQueueCreated: #type (activity: *ANativeActivity, queue: *AInputQueue) -> void #c_call;
    onInputQueueDestroyed: #type (activity: *ANativeActivity, queue: *AInputQueue) -> void #c_call;
    onContentRectChanged: #type (activity: *ANativeActivity, rect: *ARect) -> void #c_call;
    onConfigurationChanged: #type (activity: *ANativeActivity) -> void #c_call;
    onLowMemory: #type (activity: *ANativeActivity) -> void #c_call;
}
ANativeActivity_createFunc :: #type (activity: *ANativeActivity, savedState: *void, savedStateSize: u64) -> void #c_call;
ANativeActivity_finish :: (activity: *ANativeActivity) -> void #foreign libandroid;
ANativeActivity_setWindowFormat :: (activity: *ANativeActivity, format: s32) -> void #foreign libandroid;
ANativeActivity_setWindowFlags :: (activity: *ANativeActivity, addFlags: u32, removeFlags: u32) -> void #foreign libandroid;
ANATIVEACTIVITY_SHOW_SOFT_INPUT :: enum u32 {
    IMPLICIT :: 1;
    FORCED :: 2;
}
ANativeActivity_showSoftInput :: (activity: *ANativeActivity, flags: u32) -> void #foreign libandroid;
ANATIVEACTIVITY_HIDE_SOFT_INPUT :: enum u32 {
    IMPLICIT_ONLY :: 1;
    NOT_ALWAYS :: 2;
}
ANativeActivity_hideSoftInput :: (activity: *ANativeActivity, flags: u32) -> void #foreign libandroid;
AWINDOW_FLAG :: enum u32 {
    ALLOW_LOCK_WHILE_SCREEN_ON :: 1;
    DIM_BEHIND :: 2;
    BLUR_BEHIND :: 4;
    NOT_FOCUSABLE :: 8;
    NOT_TOUCHABLE :: 16;
    NOT_TOUCH_MODAL :: 32;
    TOUCHABLE_WHEN_WAKING :: 64;
    KEEP_SCREEN_ON :: 128;
    LAYOUT_IN_SCREEN :: 256;
    LAYOUT_NO_LIMITS :: 512;
    FULLSCREEN :: 1024;
    FORCE_NOT_FULLSCREEN :: 2048;
    DITHER :: 4096;
    SECURE :: 8192;
    SCALED :: 16384;
    IGNORE_CHEEK_PRESSES :: 32768;
    LAYOUT_INSET_DECOR :: 65536;
    ALT_FOCUSABLE_IM :: 131072;
    WATCH_OUTSIDE_TOUCH :: 262144;
    SHOW_WHEN_LOCKED :: 524288;
    SHOW_WALLPAPER :: 1048576;
    TURN_SCREEN_ON :: 2097152;
    DISMISS_KEYGUARD :: 4194304;
}
#scope_file
libandroid :: #system_library "libandroid";
