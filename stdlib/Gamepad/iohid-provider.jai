#scope_file
HID :: #import "Gamepad/IOHID";
iohid_manager: HID.IOHIDManagerRef;
iohid_loop: HID.CFRunLoopRef;
iohid_layout: IOHID_Gamepad_Layout;
#scope_export
// USB HID usage assignments are device profiles, supplied explicitly by the caller.
IOHID_Gamepad_Layout :: struct {
    button_usages: [32] u32;
    left_x: u32 = 0x30;
    left_y: u32 = 0x31;
    right_x: u32 = 0x33;
    right_y: u32 = 0x34;
    left_trigger: u32 = 0x32;
    right_trigger: u32 = 0x35;
    invert_left_y := true;
    invert_right_y := true;
}
use_iohid_gamepad :: (layout: IOHID_Gamepad_Layout) -> bool {
    close_iohid_gamepad();
    iohid_manager = HID.IOHIDManagerCreate(null, 0);
    if !iohid_manager return false;
    HID.IOHIDManagerSetDeviceMatching(iohid_manager, null);
    iohid_loop = HID.CFRunLoopGetCurrent();
    HID.IOHIDManagerScheduleWithRunLoop(iohid_manager, iohid_loop, HID.kCFRunLoopDefaultMode);
    if HID.IOHIDManagerOpen(iohid_manager, 0) != 0 {
        close_iohid_gamepad();
        return false;
    }
    iohid_layout = layout;
    gamepad_sample_source = sample_iohid_gamepad;
    return true;
}
close_iohid_gamepad :: () {
    if !iohid_manager return;
    HID.IOHIDManagerUnscheduleFromRunLoop(iohid_manager, iohid_loop, HID.kCFRunLoopDefaultMode);
    HID.IOHIDManagerClose(iohid_manager, 0);
    HID.CFRelease(iohid_manager);
    iohid_manager = null;
    iohid_loop = null;
}
sample_iohid_gamepad :: (sample: *Gamepad_Sample) -> bool {
    sample.* = .{};
    if !iohid_manager return false;
    HID.CFRunLoopRunInMode(HID.kCFRunLoopDefaultMode, 0, 1);
    devices := HID.IOHIDManagerCopyDevices(iohid_manager);
    if !devices return false;
    defer HID.CFRelease(devices);
    count := HID.CFSetGetCount(devices);
    if count <= 0 || count > 4096 return false;
    values := cast(**void) alloc(count * size_of(*void));
    if !values return false;
    defer free(values);
    HID.CFSetGetValues(devices, values);
    for index: 0..count - 1 {
        device := cast(HID.IOHIDDeviceRef) values[index];
        if HID.IOHIDDeviceConformsTo(device, 1, 4) == 0 && HID.IOHIDDeviceConformsTo(device, 1, 5) == 0 continue;
        elements := HID.IOHIDDeviceCopyMatchingElements(device, null, 0);
        if !elements continue;
        local: Gamepad_Sample;
        successful := false;
        element_count := HID.CFArrayGetCount(elements);
        for element_index: 0..element_count - 1 {
            element := cast(HID.IOHIDElementRef) HID.CFArrayGetValueAtIndex(elements, element_index);
            kind := HID.IOHIDElementGetType(element);
            if kind < 1 || kind > 3 continue;
            value: HID.IOHIDValueRef;
            if HID.IOHIDDeviceGetValue(device, element, *value) != 0 || !value continue;
            successful = true;
            raw := HID.IOHIDValueGetIntegerValue(value);
            page := HID.IOHIDElementGetUsagePage(element);
            usage := HID.IOHIDElementGetUsage(element);
            if page == 9 {
                for wanted, button_index: iohid_layout.button_usages if wanted != 0 && wanted == usage && raw != 0 local.buttons |= (cast(u32) 1) << button_index;
            } else if page == 1 {
                if usage == 0x39 {
                    minimum := HID.IOHIDElementGetLogicalMin(element);
                    maximum := HID.IOHIDElementGetLogicalMax(element);
                    // Eight-way HID hat values; outside the logical range is neutral.
                    if maximum - minimum == 7 && raw >= minimum && raw <= maximum {
                        direction := raw - minimum;
                        if direction == 0 || direction == 1 || direction == 7 local.buttons |= (cast(u32) 1) << cast(s64) Gamepad_Code.DPAD_UP;
                        if direction == 1 || direction == 2 || direction == 3 local.buttons |= (cast(u32) 1) << cast(s64) Gamepad_Code.DPAD_RIGHT;
                        if direction == 3 || direction == 4 || direction == 5 local.buttons |= (cast(u32) 1) << cast(s64) Gamepad_Code.DPAD_DOWN;
                        if direction == 5 || direction == 6 || direction == 7 local.buttons |= (cast(u32) 1) << cast(s64) Gamepad_Code.DPAD_LEFT;
                    }
                    continue;
                }
                unit := iohid_axis(element, raw);
                if usage == iohid_layout.left_x local.left_stick.x = unit * 2 - 1;
                if usage == iohid_layout.left_y {
                    local.left_stick.y = unit * 2 - 1;
                    if iohid_layout.invert_left_y local.left_stick.y = -local.left_stick.y;
                }
                if usage == iohid_layout.right_x local.right_stick.x = unit * 2 - 1;
                if usage == iohid_layout.right_y {
                    local.right_stick.y = unit * 2 - 1;
                    if iohid_layout.invert_right_y local.right_stick.y = -local.right_stick.y;
                }
                if usage == iohid_layout.left_trigger local.left_trigger = unit;
                if usage == iohid_layout.right_trigger local.right_trigger = unit;
            }
        }
        HID.CFRelease(elements);
        if successful {
            sample.* = local;
            return true;
        }
    }
    return false;
}
#scope_file
iohid_axis :: (element: HID.IOHIDElementRef, raw: s64) -> float {
    minimum := HID.IOHIDElementGetLogicalMin(element);
    maximum := HID.IOHIDElementGetLogicalMax(element);
    if maximum <= minimum return 0.5;
    return clamp(cast(float) (raw - minimum) / cast(float) (maximum - minimum), 0.0, 1.0);
}
