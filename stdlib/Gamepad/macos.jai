#scope_file
GC :: #import "Objective_C/GameController";
Foundation :: #import "Objective_C"; // Foundation.jai is part of Objective_C, not a module of its own.
ObjC :: #import "Objective_C";
#scope_export
sample_gamecontroller :: (sample:*Gamepad_Sample) -> bool {
    sample.*=.{};
    pool:=ObjC.objc_init(ObjC.objc_alloc(Foundation.NSAutoreleasePool));
    defer Foundation.NSAutoreleasePool.drain(pool);
    controllers:=GC.GCController_controllers();
    if !controllers return false;
    count:=Foundation.NSArray(*GC.GCController).count(controllers);
    for index:0..cast(s64) count-1 {
        controller:=Foundation.NSArray(*GC.GCController).objectAtIndex(controllers,cast(Foundation.NSUInteger) index);
        if !controller continue;
        profile:=GC.GCController.extendedGamepad(controller);
        if !profile continue;
        left:=GC.GCExtendedGamepad.leftThumbstick(profile);
        right:=GC.GCExtendedGamepad.rightThumbstick(profile);
        if left sample.left_stick=.{GC.GCControllerAxisInput.value(GC.GCControllerDirectionPad.xAxis(left)),GC.GCControllerAxisInput.value(GC.GCControllerDirectionPad.yAxis(left))};
        if right sample.right_stick=.{GC.GCControllerAxisInput.value(GC.GCControllerDirectionPad.xAxis(right)),GC.GCControllerAxisInput.value(GC.GCControllerDirectionPad.yAxis(right))};
        lt:=GC.GCExtendedGamepad.leftTrigger(profile); rt:=GC.GCExtendedGamepad.rightTrigger(profile);
        if lt sample.left_trigger=GC.GCControllerButtonInput.value(lt);
        if rt sample.right_trigger=GC.GCControllerButtonInput.value(rt);
        dpad:=GC.GCExtendedGamepad.dpad(profile);
        if dpad {
            gc_button(sample,GC.GCControllerDirectionPad.up(dpad),.DPAD_UP);
            gc_button(sample,GC.GCControllerDirectionPad.down(dpad),.DPAD_DOWN);
            gc_button(sample,GC.GCControllerDirectionPad.left(dpad),.DPAD_LEFT);
            gc_button(sample,GC.GCControllerDirectionPad.right(dpad),.DPAD_RIGHT);
        }
        gc_button(sample,GC.GCExtendedGamepad.buttonA(profile),.A);
        gc_button(sample,GC.GCExtendedGamepad.buttonB(profile),.B);
        gc_button(sample,GC.GCExtendedGamepad.buttonX(profile),.X);
        gc_button(sample,GC.GCExtendedGamepad.buttonY(profile),.Y);
        gc_button(sample,GC.GCExtendedGamepad.leftShoulder(profile),.LEFT_SHOULDER);
        gc_button(sample,GC.GCExtendedGamepad.rightShoulder(profile),.RIGHT_SHOULDER);
        gc_button(sample,gc_optional_button(profile,"leftThumbstickButton\0"),.LEFT_STICK_CLICK);
        gc_button(sample,gc_optional_button(profile,"rightThumbstickButton\0"),.RIGHT_STICK_CLICK);
        gc_button(sample,gc_optional_button(profile,"buttonMenu\0"),.START);
        gc_button(sample,gc_optional_button(profile,"buttonOptions\0"),.BACK);
        return true;
    }
    return false;
}
#scope_file
gc_button :: (sample:*Gamepad_Sample, button:*GC.GCControllerButtonInput, code:Gamepad_Code) {
    if button && GC.GCControllerButtonInput.isPressed(button)!=0 sample.buttons |= cast(u32) 1 << cast(s64) code;
}
gc_optional_button :: (profile:*GC.GCExtendedGamepad, name:*u8) -> *GC.GCControllerButtonInput {
    selector:=ObjC.sel_registerName(name);
    responds:(receiver:*void,selector:ObjC.SEL,method:ObjC.SEL)->ObjC.BOOL #c_call;
    responds=cast(type_of(responds)) ObjC.objc_msgSend;
    if responds(profile,ObjC.sel_registerName("respondsToSelector:\0"),selector)==0 return null;
    get:(receiver:*void,selector:ObjC.SEL)->*GC.GCControllerButtonInput #c_call;
    get=cast(type_of(get)) ObjC.objc_msgSend;
    return get(profile,selector);
}
