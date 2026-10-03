// Normalized API contracts; reference procedure bodies were discarded.
init_objective_c_gamecontroller :: () {
    _sel.allowsRotation = cast(Selector) sel_registerName(cast(*u8) "allowsRotation\0");
    _sel.attitude = cast(Selector) sel_registerName(cast(*u8) "attitude\0");
    _sel.buttonA = cast(Selector) sel_registerName(cast(*u8) "buttonA\0");
    _sel.buttonB = cast(Selector) sel_registerName(cast(*u8) "buttonB\0");
    _sel.buttonX = cast(Selector) sel_registerName(cast(*u8) "buttonX\0");
    _sel.buttonY = cast(Selector) sel_registerName(cast(*u8) "buttonY\0");
    _sel.collection = cast(Selector) sel_registerName(cast(*u8) "collection\0");
    _sel.controller = cast(Selector) sel_registerName(cast(*u8) "controller\0");
    _sel.controllerPausedHandler = cast(Selector) sel_registerName(cast(*u8) "controllerPausedHandler\0");
    _sel.controllerUserInteractionEnabled = cast(Selector) sel_registerName(cast(*u8) "controllerUserInteractionEnabled\0");
    _sel.controllers = cast(Selector) sel_registerName(cast(*u8) "controllers\0");
    _sel.down = cast(Selector) sel_registerName(cast(*u8) "down\0");
    _sel.dpad = cast(Selector) sel_registerName(cast(*u8) "dpad\0");
    _sel.extendedGamepad = cast(Selector) sel_registerName(cast(*u8) "extendedGamepad\0");
    _sel.gamepad = cast(Selector) sel_registerName(cast(*u8) "gamepad\0");
    _sel.gravity = cast(Selector) sel_registerName(cast(*u8) "gravity\0");
    _sel.handlerQueue = cast(Selector) sel_registerName(cast(*u8) "handlerQueue\0");
    _sel.hasAttitudeAndRotationRate = cast(Selector) sel_registerName(cast(*u8) "hasAttitudeAndRotationRate\0");
    _sel.initWithController_snapshotData_ = cast(Selector) sel_registerName(cast(*u8) "initWithController:snapshotData:\0");
    _sel.initWithSnapshotData_ = cast(Selector) sel_registerName(cast(*u8) "initWithSnapshotData:\0");
    _sel.isAnalog = cast(Selector) sel_registerName(cast(*u8) "isAnalog\0");
    _sel.isAttachedToDevice = cast(Selector) sel_registerName(cast(*u8) "isAttachedToDevice\0");
    _sel.isPressed = cast(Selector) sel_registerName(cast(*u8) "isPressed\0");
    _sel.left = cast(Selector) sel_registerName(cast(*u8) "left\0");
    _sel.leftShoulder = cast(Selector) sel_registerName(cast(*u8) "leftShoulder\0");
    _sel.leftThumbstick = cast(Selector) sel_registerName(cast(*u8) "leftThumbstick\0");
    _sel.leftThumbstickButton = cast(Selector) sel_registerName(cast(*u8) "leftThumbstickButton\0");
    _sel.leftTrigger = cast(Selector) sel_registerName(cast(*u8) "leftTrigger\0");
    _sel.microGamepad = cast(Selector) sel_registerName(cast(*u8) "microGamepad\0");
    _sel.motion = cast(Selector) sel_registerName(cast(*u8) "motion\0");
    _sel.playerIndex = cast(Selector) sel_registerName(cast(*u8) "playerIndex\0");
    _sel.pressedChangedHandler = cast(Selector) sel_registerName(cast(*u8) "pressedChangedHandler\0");
    _sel.reportsAbsoluteDpadValues = cast(Selector) sel_registerName(cast(*u8) "reportsAbsoluteDpadValues\0");
    _sel.right = cast(Selector) sel_registerName(cast(*u8) "right\0");
    _sel.rightShoulder = cast(Selector) sel_registerName(cast(*u8) "rightShoulder\0");
    _sel.rightThumbstick = cast(Selector) sel_registerName(cast(*u8) "rightThumbstick\0");
    _sel.rightThumbstickButton = cast(Selector) sel_registerName(cast(*u8) "rightThumbstickButton\0");
    _sel.rightTrigger = cast(Selector) sel_registerName(cast(*u8) "rightTrigger\0");
    _sel.rotationRate = cast(Selector) sel_registerName(cast(*u8) "rotationRate\0");
    _sel.saveSnapshot = cast(Selector) sel_registerName(cast(*u8) "saveSnapshot\0");
    _sel.setAllowsRotation_ = cast(Selector) sel_registerName(cast(*u8) "setAllowsRotation:\0");
    _sel.setControllerPausedHandler_ = cast(Selector) sel_registerName(cast(*u8) "setControllerPausedHandler:\0");
    _sel.setControllerUserInteractionEnabled_ = cast(Selector) sel_registerName(cast(*u8) "setControllerUserInteractionEnabled:\0");
    _sel.setHandlerQueue_ = cast(Selector) sel_registerName(cast(*u8) "setHandlerQueue:\0");
    _sel.setPlayerIndex_ = cast(Selector) sel_registerName(cast(*u8) "setPlayerIndex:\0");
    _sel.setPressedChangedHandler_ = cast(Selector) sel_registerName(cast(*u8) "setPressedChangedHandler:\0");
    _sel.setReportsAbsoluteDpadValues_ = cast(Selector) sel_registerName(cast(*u8) "setReportsAbsoluteDpadValues:\0");
    _sel.setSnapshotData_ = cast(Selector) sel_registerName(cast(*u8) "setSnapshotData:\0");
    _sel.setValueChangedHandler_ = cast(Selector) sel_registerName(cast(*u8) "setValueChangedHandler:\0");
    _sel.snapshotData = cast(Selector) sel_registerName(cast(*u8) "snapshotData\0");
    _sel.startWirelessControllerDiscoveryWithCompletionHandler_ = cast(Selector) sel_registerName(cast(*u8) "startWirelessControllerDiscoveryWithCompletionHandler:\0");
    _sel.stopWirelessControllerDiscovery = cast(Selector) sel_registerName(cast(*u8) "stopWirelessControllerDiscovery\0");
    _sel.up = cast(Selector) sel_registerName(cast(*u8) "up\0");
    _sel.userAcceleration = cast(Selector) sel_registerName(cast(*u8) "userAcceleration\0");
    _sel.value = cast(Selector) sel_registerName(cast(*u8) "value\0");
    _sel.valueChangedHandler = cast(Selector) sel_registerName(cast(*u8) "valueChangedHandler\0");
    _sel.vendorName = cast(Selector) sel_registerName(cast(*u8) "vendorName\0");
    _sel.xAxis = cast(Selector) sel_registerName(cast(*u8) "xAxis\0");
    _sel.yAxis = cast(Selector) sel_registerName(cast(*u8) "yAxis\0");
}
GCControllerElement :: struct {
    using nsobject: NSObject;
    collection :: (self: *GCControllerElement) -> *GCControllerElement {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *GCControllerElement #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "collection\0"));
    }
    isAnalog :: (self: *GCControllerElement) -> BOOL {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> BOOL #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "isAnalog\0"));
    }
}
GCControllerAxisInput :: struct {
    using gccontrollerelement: GCControllerElement;
    valueChangedHandler :: (self: *GCControllerAxisInput) -> GCControllerAxisValueChangedHandler {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> GCControllerAxisValueChangedHandler #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "valueChangedHandler\0"));
    }
    setValueChangedHandler :: (self: *GCControllerAxisInput, valueChangedHandler: GCControllerAxisValueChangedHandler) -> () {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, valueChangedHandler: GCControllerAxisValueChangedHandler) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(cast(*void) self, sel_registerName(cast(*u8) "setValueChangedHandler:\0"), valueChangedHandler);
    }
    value :: (self: *GCControllerAxisInput) -> float32 {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> float32 #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "value\0"));
    }
}
GCControllerAxisValueChangedHandler :: *void;
GCControllerButtonInput :: struct {
    using gccontrollerelement: GCControllerElement;
    valueChangedHandler :: (self: *GCControllerButtonInput) -> GCControllerButtonValueChangedHandler {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> GCControllerButtonValueChangedHandler #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "valueChangedHandler\0"));
    }
    setValueChangedHandler :: (self: *GCControllerButtonInput, valueChangedHandler: GCControllerButtonValueChangedHandler) -> () {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, valueChangedHandler: GCControllerButtonValueChangedHandler) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(cast(*void) self, sel_registerName(cast(*u8) "setValueChangedHandler:\0"), valueChangedHandler);
    }
    pressedChangedHandler :: (self: *GCControllerButtonInput) -> GCControllerButtonValueChangedHandler {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> GCControllerButtonValueChangedHandler #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "pressedChangedHandler\0"));
    }
    setPressedChangedHandler :: (self: *GCControllerButtonInput, pressedChangedHandler: GCControllerButtonValueChangedHandler) -> () {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, pressedChangedHandler: GCControllerButtonValueChangedHandler) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(cast(*void) self, sel_registerName(cast(*u8) "setPressedChangedHandler:\0"), pressedChangedHandler);
    }
    value :: (self: *GCControllerButtonInput) -> float32 {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> float32 #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "value\0"));
    }
    isPressed :: (self: *GCControllerButtonInput) -> BOOL {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> BOOL #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "isPressed\0"));
    }
}
GCControllerButtonValueChangedHandler :: *void;
GCControllerDirectionPad :: struct {
    using gccontrollerelement: GCControllerElement;
    valueChangedHandler :: (self: *GCControllerDirectionPad) -> GCControllerDirectionPadValueChangedHandler {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> GCControllerDirectionPadValueChangedHandler #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "valueChangedHandler\0"));
    }
    setValueChangedHandler :: (self: *GCControllerDirectionPad, valueChangedHandler: GCControllerDirectionPadValueChangedHandler) -> () {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, valueChangedHandler: GCControllerDirectionPadValueChangedHandler) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(cast(*void) self, sel_registerName(cast(*u8) "setValueChangedHandler:\0"), valueChangedHandler);
    }
    xAxis :: (self: *GCControllerDirectionPad) -> *GCControllerAxisInput {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *GCControllerAxisInput #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "xAxis\0"));
    }
    yAxis :: (self: *GCControllerDirectionPad) -> *GCControllerAxisInput {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *GCControllerAxisInput #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "yAxis\0"));
    }
    up :: (self: *GCControllerDirectionPad) -> *GCControllerButtonInput {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *GCControllerButtonInput #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "up\0"));
    }
    down :: (self: *GCControllerDirectionPad) -> *GCControllerButtonInput {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *GCControllerButtonInput #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "down\0"));
    }
    left :: (self: *GCControllerDirectionPad) -> *GCControllerButtonInput {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *GCControllerButtonInput #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "left\0"));
    }
    right :: (self: *GCControllerDirectionPad) -> *GCControllerButtonInput {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *GCControllerButtonInput #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "right\0"));
    }
}
GCControllerDirectionPadValueChangedHandler :: *void;
GCAcceleration :: struct {
    x: float64;
    y: float64;
    z: float64;
}
GCRotationRate :: struct {
    x: float64;
    y: float64;
    z: float64;
}
GCEulerAngles :: struct {
    pitch: float64;
    yaw: float64;
    roll: float64;
}
GCQuaternion :: struct {
    x: float64;
    y: float64;
    z: float64;
    w: float64;
}
GCMotion :: struct {
    using nsobject: NSObject;
    controller :: (self: *GCMotion) -> *GCController {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *GCController #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "controller\0"));
    }
    valueChangedHandler :: (self: *GCMotion) -> GCMotionValueChangedHandler {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> GCMotionValueChangedHandler #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "valueChangedHandler\0"));
    }
    setValueChangedHandler :: (self: *GCMotion, valueChangedHandler: GCMotionValueChangedHandler) -> () {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, valueChangedHandler: GCMotionValueChangedHandler) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(cast(*void) self, sel_registerName(cast(*u8) "setValueChangedHandler:\0"), valueChangedHandler);
    }
    gravity :: (self: *GCMotion) -> GCAcceleration {
        #if CPU == .X64 {
            result: GCAcceleration;
            invoke: (output: *GCAcceleration, sdk_receiver: *void, sdk_selector: SEL) -> void #c_call;
            invoke = cast(type_of(invoke)) objc_msgSend_stret;
            invoke(*result, cast(*void) self, sel_registerName(cast(*u8) "gravity\0"));
            return result;
        } else {
            invoke: (sdk_receiver: *void, sdk_selector: SEL) -> GCAcceleration #c_call;
            invoke = cast(type_of(invoke)) objc_msgSend;
            return invoke(cast(*void) self, sel_registerName(cast(*u8) "gravity\0"));
        }
    }
    userAcceleration :: (self: *GCMotion) -> GCAcceleration {
        #if CPU == .X64 {
            result: GCAcceleration;
            invoke: (output: *GCAcceleration, sdk_receiver: *void, sdk_selector: SEL) -> void #c_call;
            invoke = cast(type_of(invoke)) objc_msgSend_stret;
            invoke(*result, cast(*void) self, sel_registerName(cast(*u8) "userAcceleration\0"));
            return result;
        } else {
            invoke: (sdk_receiver: *void, sdk_selector: SEL) -> GCAcceleration #c_call;
            invoke = cast(type_of(invoke)) objc_msgSend;
            return invoke(cast(*void) self, sel_registerName(cast(*u8) "userAcceleration\0"));
        }
    }
    hasAttitudeAndRotationRate :: (self: *GCMotion) -> BOOL {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> BOOL #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "hasAttitudeAndRotationRate\0"));
    }
    attitude :: (self: *GCMotion) -> GCQuaternion {
        #if CPU == .X64 {
            result: GCQuaternion;
            invoke: (output: *GCQuaternion, sdk_receiver: *void, sdk_selector: SEL) -> void #c_call;
            invoke = cast(type_of(invoke)) objc_msgSend_stret;
            invoke(*result, cast(*void) self, sel_registerName(cast(*u8) "attitude\0"));
            return result;
        } else {
            invoke: (sdk_receiver: *void, sdk_selector: SEL) -> GCQuaternion #c_call;
            invoke = cast(type_of(invoke)) objc_msgSend;
            return invoke(cast(*void) self, sel_registerName(cast(*u8) "attitude\0"));
        }
    }
    rotationRate :: (self: *GCMotion) -> GCRotationRate {
        #if CPU == .X64 {
            result: GCRotationRate;
            invoke: (output: *GCRotationRate, sdk_receiver: *void, sdk_selector: SEL) -> void #c_call;
            invoke = cast(type_of(invoke)) objc_msgSend_stret;
            invoke(*result, cast(*void) self, sel_registerName(cast(*u8) "rotationRate\0"));
            return result;
        } else {
            invoke: (sdk_receiver: *void, sdk_selector: SEL) -> GCRotationRate #c_call;
            invoke = cast(type_of(invoke)) objc_msgSend;
            return invoke(cast(*void) self, sel_registerName(cast(*u8) "rotationRate\0"));
        }
    }
}
GCMotionValueChangedHandler :: *void;
GCGamepad :: struct {
    using nsobject: NSObject;
    saveSnapshot :: (self: *GCGamepad) -> *GCGamepadSnapshot {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *GCGamepadSnapshot #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "saveSnapshot\0"));
    }
    controller :: (self: *GCGamepad) -> *GCController {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *GCController #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "controller\0"));
    }
    valueChangedHandler :: (self: *GCGamepad) -> GCGamepadValueChangedHandler {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> GCGamepadValueChangedHandler #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "valueChangedHandler\0"));
    }
    setValueChangedHandler :: (self: *GCGamepad, valueChangedHandler: GCGamepadValueChangedHandler) -> () {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, valueChangedHandler: GCGamepadValueChangedHandler) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(cast(*void) self, sel_registerName(cast(*u8) "setValueChangedHandler:\0"), valueChangedHandler);
    }
    dpad :: (self: *GCGamepad) -> *GCControllerDirectionPad {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *GCControllerDirectionPad #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "dpad\0"));
    }
    buttonA :: (self: *GCGamepad) -> *GCControllerButtonInput {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *GCControllerButtonInput #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "buttonA\0"));
    }
    buttonB :: (self: *GCGamepad) -> *GCControllerButtonInput {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *GCControllerButtonInput #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "buttonB\0"));
    }
    buttonX :: (self: *GCGamepad) -> *GCControllerButtonInput {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *GCControllerButtonInput #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "buttonX\0"));
    }
    buttonY :: (self: *GCGamepad) -> *GCControllerButtonInput {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *GCControllerButtonInput #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "buttonY\0"));
    }
    leftShoulder :: (self: *GCGamepad) -> *GCControllerButtonInput {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *GCControllerButtonInput #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "leftShoulder\0"));
    }
    rightShoulder :: (self: *GCGamepad) -> *GCControllerButtonInput {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *GCControllerButtonInput #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "rightShoulder\0"));
    }
}
GCGamepadValueChangedHandler :: *void;
GCGamepadSnapshot :: struct {
    using gcgamepad: GCGamepad;
    initWithSnapshotData :: (self: *GCGamepadSnapshot, data: *NSData) -> *GCGamepadSnapshot {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, data: *NSData) -> *GCGamepadSnapshot #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "initWithSnapshotData:\0"), data);
    }
    initWithController_snapshotData :: (self: *GCGamepadSnapshot, controller: *GCController, data: *NSData) -> *GCGamepadSnapshot {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, controller: *GCController, data: *NSData) -> *GCGamepadSnapshot #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "initWithController:snapshotData:\0"), controller, data);
    }
    snapshotData :: (self: *GCGamepadSnapshot) -> *NSData {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *NSData #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "snapshotData\0"));
    }
    setSnapshotData :: (self: *GCGamepadSnapshot, snapshotData: *NSData) -> () {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, snapshotData: *NSData) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(cast(*void) self, sel_registerName(cast(*u8) "setSnapshotData:\0"), snapshotData);
    }
}
GCGamepadSnapShotDataV100 :: struct {
    version: u16;
    size: u16;
    dpadX: float32;
    dpadY: float32;
    buttonA: float32;
    buttonB: float32;
    buttonX: float32;
    buttonY: float32;
    leftShoulder: float32;
    rightShoulder: float32;
}
GCGamepadSnapShotDataV100FromNSData :: (snapshotData: *GCGamepadSnapShotDataV100, data: *NSData) -> BOOL #foreign GameController_Framework;
NSDataFromGCGamepadSnapShotDataV100 :: (snapshotData: *GCGamepadSnapShotDataV100) -> *NSData #foreign GameController_Framework;
GCExtendedGamepad :: struct {
    using nsobject: NSObject;
    saveSnapshot :: (self: *GCExtendedGamepad) -> *GCExtendedGamepadSnapshot {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *GCExtendedGamepadSnapshot #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "saveSnapshot\0"));
    }
    controller :: (self: *GCExtendedGamepad) -> *GCController {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *GCController #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "controller\0"));
    }
    valueChangedHandler :: (self: *GCExtendedGamepad) -> GCExtendedGamepadValueChangedHandler {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> GCExtendedGamepadValueChangedHandler #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "valueChangedHandler\0"));
    }
    setValueChangedHandler :: (self: *GCExtendedGamepad, valueChangedHandler: GCExtendedGamepadValueChangedHandler) -> () {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, valueChangedHandler: GCExtendedGamepadValueChangedHandler) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(cast(*void) self, sel_registerName(cast(*u8) "setValueChangedHandler:\0"), valueChangedHandler);
    }
    dpad :: (self: *GCExtendedGamepad) -> *GCControllerDirectionPad {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *GCControllerDirectionPad #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "dpad\0"));
    }
    buttonA :: (self: *GCExtendedGamepad) -> *GCControllerButtonInput {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *GCControllerButtonInput #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "buttonA\0"));
    }
    buttonB :: (self: *GCExtendedGamepad) -> *GCControllerButtonInput {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *GCControllerButtonInput #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "buttonB\0"));
    }
    buttonX :: (self: *GCExtendedGamepad) -> *GCControllerButtonInput {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *GCControllerButtonInput #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "buttonX\0"));
    }
    buttonY :: (self: *GCExtendedGamepad) -> *GCControllerButtonInput {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *GCControllerButtonInput #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "buttonY\0"));
    }
    leftThumbstick :: (self: *GCExtendedGamepad) -> *GCControllerDirectionPad {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *GCControllerDirectionPad #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "leftThumbstick\0"));
    }
    rightThumbstick :: (self: *GCExtendedGamepad) -> *GCControllerDirectionPad {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *GCControllerDirectionPad #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "rightThumbstick\0"));
    }
    leftShoulder :: (self: *GCExtendedGamepad) -> *GCControllerButtonInput {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *GCControllerButtonInput #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "leftShoulder\0"));
    }
    rightShoulder :: (self: *GCExtendedGamepad) -> *GCControllerButtonInput {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *GCControllerButtonInput #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "rightShoulder\0"));
    }
    leftTrigger :: (self: *GCExtendedGamepad) -> *GCControllerButtonInput {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *GCControllerButtonInput #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "leftTrigger\0"));
    }
    rightTrigger :: (self: *GCExtendedGamepad) -> *GCControllerButtonInput {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *GCControllerButtonInput #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "rightTrigger\0"));
    }
    leftThumbstickButton :: (self: *GCExtendedGamepad) -> *GCControllerButtonInput {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *GCControllerButtonInput #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "leftThumbstickButton\0"));
    }
    rightThumbstickButton :: (self: *GCExtendedGamepad) -> *GCControllerButtonInput {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *GCControllerButtonInput #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "rightThumbstickButton\0"));
    }
}
GCExtendedGamepadValueChangedHandler :: *void;
GCExtendedGamepadSnapshot :: struct {
    using gcextendedgamepad: GCExtendedGamepad;
    initWithSnapshotData :: (self: *GCExtendedGamepadSnapshot, data: *NSData) -> *GCExtendedGamepadSnapshot {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, data: *NSData) -> *GCExtendedGamepadSnapshot #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "initWithSnapshotData:\0"), data);
    }
    initWithController_snapshotData :: (self: *GCExtendedGamepadSnapshot, controller: *GCController, data: *NSData) -> *GCExtendedGamepadSnapshot {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, controller: *GCController, data: *NSData) -> *GCExtendedGamepadSnapshot #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "initWithController:snapshotData:\0"), controller, data);
    }
    snapshotData :: (self: *GCExtendedGamepadSnapshot) -> *NSData {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *NSData #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "snapshotData\0"));
    }
    setSnapshotData :: (self: *GCExtendedGamepadSnapshot, snapshotData: *NSData) -> () {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, snapshotData: *NSData) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(cast(*void) self, sel_registerName(cast(*u8) "setSnapshotData:\0"), snapshotData);
    }
}
GCExtendedGamepadSnapShotDataV100 :: struct {
    version: u16;
    size: u16;
    dpadX: float32;
    dpadY: float32;
    buttonA: float32;
    buttonB: float32;
    buttonX: float32;
    buttonY: float32;
    leftShoulder: float32;
    rightShoulder: float32;
    leftThumbstickX: float32;
    leftThumbstickY: float32;
    rightThumbstickX: float32;
    rightThumbstickY: float32;
    leftTrigger: float32;
    rightTrigger: float32;
}
GCExtendedGamepadSnapShotDataV100FromNSData :: (snapshotData: *GCExtendedGamepadSnapShotDataV100, data: *NSData) -> BOOL #foreign GameController_Framework;
NSDataFromGCExtendedGamepadSnapShotDataV100 :: (snapshotData: *GCExtendedGamepadSnapShotDataV100) -> *NSData #foreign GameController_Framework;
GCMicroGamepad :: struct {
    using nsobject: NSObject;
    saveSnapshot :: (self: *GCMicroGamepad) -> *GCMicroGamepadSnapshot {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *GCMicroGamepadSnapshot #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "saveSnapshot\0"));
    }
    controller :: (self: *GCMicroGamepad) -> *GCController {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *GCController #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "controller\0"));
    }
    valueChangedHandler :: (self: *GCMicroGamepad) -> GCMicroGamepadValueChangedHandler {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> GCMicroGamepadValueChangedHandler #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "valueChangedHandler\0"));
    }
    setValueChangedHandler :: (self: *GCMicroGamepad, valueChangedHandler: GCMicroGamepadValueChangedHandler) -> () {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, valueChangedHandler: GCMicroGamepadValueChangedHandler) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(cast(*void) self, sel_registerName(cast(*u8) "setValueChangedHandler:\0"), valueChangedHandler);
    }
    dpad :: (self: *GCMicroGamepad) -> *GCControllerDirectionPad {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *GCControllerDirectionPad #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "dpad\0"));
    }
    buttonA :: (self: *GCMicroGamepad) -> *GCControllerButtonInput {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *GCControllerButtonInput #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "buttonA\0"));
    }
    buttonX :: (self: *GCMicroGamepad) -> *GCControllerButtonInput {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *GCControllerButtonInput #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "buttonX\0"));
    }
    reportsAbsoluteDpadValues :: (self: *GCMicroGamepad) -> BOOL {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> BOOL #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "reportsAbsoluteDpadValues\0"));
    }
    setReportsAbsoluteDpadValues :: (self: *GCMicroGamepad, reportsAbsoluteDpadValues: BOOL) -> () {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, reportsAbsoluteDpadValues: BOOL) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(cast(*void) self, sel_registerName(cast(*u8) "setReportsAbsoluteDpadValues:\0"), reportsAbsoluteDpadValues);
    }
    allowsRotation :: (self: *GCMicroGamepad) -> BOOL {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> BOOL #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "allowsRotation\0"));
    }
    setAllowsRotation :: (self: *GCMicroGamepad, allowsRotation: BOOL) -> () {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, allowsRotation: BOOL) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(cast(*void) self, sel_registerName(cast(*u8) "setAllowsRotation:\0"), allowsRotation);
    }
}
GCMicroGamepadValueChangedHandler :: *void;
GCMicroGamepadSnapshot :: struct {
    using gcmicrogamepad: GCMicroGamepad;
    initWithSnapshotData :: (self: *GCMicroGamepadSnapshot, data: *NSData) -> *GCMicroGamepadSnapshot {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, data: *NSData) -> *GCMicroGamepadSnapshot #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "initWithSnapshotData:\0"), data);
    }
    initWithController_snapshotData :: (self: *GCMicroGamepadSnapshot, controller: *GCController, data: *NSData) -> *GCMicroGamepadSnapshot {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, controller: *GCController, data: *NSData) -> *GCMicroGamepadSnapshot #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "initWithController:snapshotData:\0"), controller, data);
    }
    snapshotData :: (self: *GCMicroGamepadSnapshot) -> *NSData {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *NSData #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "snapshotData\0"));
    }
    setSnapshotData :: (self: *GCMicroGamepadSnapshot, snapshotData: *NSData) -> () {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, snapshotData: *NSData) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(cast(*void) self, sel_registerName(cast(*u8) "setSnapshotData:\0"), snapshotData);
    }
}
anon_struct_5 :: struct {
    version: u16;
    size: u16;
    dpadX: float32;
    dpadY: float32;
    buttonA: float32;
    buttonX: float32;
}
GCMicroGamepadSnapShotDataV100 :: anon_struct_5;
GCMicroGamepadSnapShotDataV100FromNSData :: (snapshotData: *GCMicroGamepadSnapShotDataV100, data: *NSData) -> BOOL #foreign GameController_Framework;
NSDataFromGCMicroGamepadSnapShotDataV100 :: (snapshotData: *GCMicroGamepadSnapShotDataV100) -> *NSData #foreign GameController_Framework;
GCEventViewController :: struct {
    using #as viewController: NSViewController;
    controllerUserInteractionEnabled :: (self: *GCEventViewController) -> BOOL {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> BOOL #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "controllerUserInteractionEnabled\0"));
    }
    setControllerUserInteractionEnabled :: (self: *GCEventViewController, controllerUserInteractionEnabled: BOOL) -> () {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, controllerUserInteractionEnabled: BOOL) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(cast(*void) self, sel_registerName(cast(*u8) "setControllerUserInteractionEnabled:\0"), controllerUserInteractionEnabled);
    }
}
using GCControllerPlayerIndex :: enum s64 {
    GCControllerPlayerIndexUnset :: -1;
    GCControllerPlayerIndex1 :: 0;
    GCControllerPlayerIndex2 :: 1;
    GCControllerPlayerIndex3 :: 2;
    GCControllerPlayerIndex4 :: 3;
}
GCController_controllers :: () -> *NSArray(*GCController) {
    invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *NSArray(*GCController) #c_call;
    invoke = cast(type_of(invoke)) objc_msgSend;
    return invoke(cast(*void) objc_getClass(cast(*u8) "GCController\0"), sel_registerName(cast(*u8) "controllers\0"));
}
GCController :: struct {
    using #as super: NSObject;
    startWirelessControllerDiscoveryWithCompletionHandler :: (completionHandler: *void) -> () {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, completionHandler: *void) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(cast(*void) objc_getClass(cast(*u8) "GCController\0"), sel_registerName(cast(*u8) "startWirelessControllerDiscoveryWithCompletionHandler:\0"), completionHandler);
    }
    stopWirelessControllerDiscovery :: () -> () {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(cast(*void) objc_getClass(cast(*u8) "GCController\0"), sel_registerName(cast(*u8) "stopWirelessControllerDiscovery\0"));
    }
    controllerPausedHandler :: (self: *GCController) -> *void {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *void #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "controllerPausedHandler\0"));
    }
    setControllerPausedHandler :: (self: *GCController, controllerPausedHandler: *void) -> () {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, controllerPausedHandler: *void) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(cast(*void) self, sel_registerName(cast(*u8) "setControllerPausedHandler:\0"), controllerPausedHandler);
    }
    handlerQueue :: (self: *GCController) -> dispatch_queue_t {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> dispatch_queue_t #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "handlerQueue\0"));
    }
    setHandlerQueue :: (self: *GCController, handlerQueue: dispatch_queue_t) -> () {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, handlerQueue: dispatch_queue_t) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(cast(*void) self, sel_registerName(cast(*u8) "setHandlerQueue:\0"), handlerQueue);
    }
    vendorName :: (self: *GCController) -> *NSString {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *NSString #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "vendorName\0"));
    }
    isAttachedToDevice :: (self: *GCController) -> BOOL {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> BOOL #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "isAttachedToDevice\0"));
    }
    playerIndex :: (self: *GCController) -> GCControllerPlayerIndex {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> GCControllerPlayerIndex #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "playerIndex\0"));
    }
    setPlayerIndex :: (self: *GCController, playerIndex: GCControllerPlayerIndex) -> () {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, playerIndex: GCControllerPlayerIndex) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(cast(*void) self, sel_registerName(cast(*u8) "setPlayerIndex:\0"), playerIndex);
    }
    gamepad :: (self: *GCController) -> *GCGamepad {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *GCGamepad #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "gamepad\0"));
    }
    microGamepad :: (self: *GCController) -> *GCMicroGamepad {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *GCMicroGamepad #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "microGamepad\0"));
    }
    extendedGamepad :: (self: *GCController) -> *GCExtendedGamepad {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *GCExtendedGamepad #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "extendedGamepad\0"));
    }
    motion :: (self: *GCController) -> *GCMotion {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *GCMotion #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "motion\0"));
    }
}
GCControllerDidConnectNotification: *NSString #elsewhere;
GCControllerDidDisconnectNotification: *NSString #elsewhere;
#scope_file
_sel: struct {
    collection: Selector;
    isAnalog: Selector;
    valueChangedHandler: Selector;
    setValueChangedHandler_: Selector;
    value: Selector;
    pressedChangedHandler: Selector;
    setPressedChangedHandler_: Selector;
    isPressed: Selector;
    xAxis: Selector;
    yAxis: Selector;
    up: Selector;
    down: Selector;
    left: Selector;
    right: Selector;
    controller: Selector;
    gravity: Selector;
    userAcceleration: Selector;
    hasAttitudeAndRotationRate: Selector;
    attitude: Selector;
    rotationRate: Selector;
    saveSnapshot: Selector;
    dpad: Selector;
    buttonA: Selector;
    buttonB: Selector;
    buttonX: Selector;
    buttonY: Selector;
    leftShoulder: Selector;
    rightShoulder: Selector;
    initWithSnapshotData_: Selector;
    initWithController_snapshotData_: Selector;
    snapshotData: Selector;
    setSnapshotData_: Selector;
    leftThumbstick: Selector;
    rightThumbstick: Selector;
    leftTrigger: Selector;
    rightTrigger: Selector;
    leftThumbstickButton: Selector;
    rightThumbstickButton: Selector;
    reportsAbsoluteDpadValues: Selector;
    setReportsAbsoluteDpadValues_: Selector;
    allowsRotation: Selector;
    setAllowsRotation_: Selector;
    controllerUserInteractionEnabled: Selector;
    setControllerUserInteractionEnabled_: Selector;
    controllers: Selector;
    startWirelessControllerDiscoveryWithCompletionHandler_: Selector;
    stopWirelessControllerDiscovery: Selector;
    controllerPausedHandler: Selector;
    setControllerPausedHandler_: Selector;
    handlerQueue: Selector;
    setHandlerQueue_: Selector;
    vendorName: Selector;
    isAttachedToDevice: Selector;
    playerIndex: Selector;
    setPlayerIndex_: Selector;
    gamepad: Selector;
    microGamepad: Selector;
    extendedGamepad: Selector;
    motion: Selector;
}
GameController_Framework :: #system_library "GameController";
#import "Objective_C";
#import "Objective_C/AppKit";
