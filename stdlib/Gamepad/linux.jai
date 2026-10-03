#scope_file
Evdev :: #import "Gamepad/evdev";
Unix :: #import "POSIX";
Linux :: #import "Linux";
evdev_device: *Evdev.libevdev;
evdev_fd: s32=-1;
#scope_export
// Discovery is read-only and does not grab the device. Caller can choose a path.
gamepad_evdev_scan_limit:s32=64;
open_evdev_gamepad :: (path:string) -> bool {
    name:=to_c_string(path);
    if !name return false;
    defer free(name);
    fd:=Unix.open(name,Unix.O_RDONLY|Unix.O_NONBLOCK|Unix.O_CLOEXEC);
    if fd<0 return false;
    device:*Evdev.libevdev;
    status:=Evdev.libevdev_new_from_fd(fd,*device);
    if status<0 { Unix.close(fd); return false; }
    suitable:=Evdev.libevdev_has_event_code(device,3,0)!=0 && Evdev.libevdev_has_event_code(device,3,1)!=0 &&
        Evdev.libevdev_has_event_code(device,1,0x130)!=0;
    if !suitable { Evdev.libevdev_free(device); Unix.close(fd); return false; }
    close_evdev_gamepad(); evdev_device=device; evdev_fd=fd;
    return true;
}
close_evdev_gamepad :: () {
    if evdev_device { Evdev.libevdev_free(evdev_device); evdev_device=null; }
    if evdev_fd>=0 { Unix.close(evdev_fd); evdev_fd=-1; }
}
sample_evdev :: (sample:*Gamepad_Sample) -> bool {
    sample.*=.{};
    if !evdev_device {
        for index: 0..gamepad_evdev_scan_limit-1 {
            path:=sprint("/dev/input/event%",index);
            opened:=open_evdev_gamepad(path); free(path);
            if opened break;
        }
        if !evdev_device return false;
    }
    sync:=false;
    for budget: 0..4095 {
        native:Linux.input_event;
        flags:=Evdev.LIBEVDEV_READ_FLAG_NORMAL;
        if sync flags=Evdev.LIBEVDEV_READ_FLAG_SYNC;
        result:=Evdev.libevdev_next_event(evdev_device,flags,*native);
        if result==1 { sync=true; continue; }
        if result==-11 {
            if sync { sync=false; continue; }
            break;
        }
        if result==-4 continue;
        if result<0 { close_evdev_gamepad(); return false; }
    }
    // Read libevdev's synchronized state, including initial held buttons.
    keys:[14]u32=.[0x220,0x221,0x222,0x223,0x13b,0x13a,0x136,0x137,0x130,0x131,0x133,0x134,0x13d,0x13e];
    codes:[14]Gamepad_Code=.[.DPAD_UP,.DPAD_DOWN,.DPAD_LEFT,.DPAD_RIGHT,.START,.BACK,.LEFT_SHOULDER,.RIGHT_SHOULDER,.A,.B,.X,.Y,.LEFT_STICK_CLICK,.RIGHT_STICK_CLICK];
    for key,index:keys if Evdev.libevdev_get_event_value(evdev_device,1,key)!=0 sample.buttons |= cast(u32) 1 << cast(s64) codes[index];
    hat_x:=Evdev.libevdev_get_event_value(evdev_device,3,0x10);
    hat_y:=Evdev.libevdev_get_event_value(evdev_device,3,0x11);
    if hat_x<0 sample.buttons |= cast(u32) 1 << cast(s64) Gamepad_Code.DPAD_LEFT;
    if hat_x>0 sample.buttons |= cast(u32) 1 << cast(s64) Gamepad_Code.DPAD_RIGHT;
    if hat_y<0 sample.buttons |= cast(u32) 1 << cast(s64) Gamepad_Code.DPAD_UP;
    if hat_y>0 sample.buttons |= cast(u32) 1 << cast(s64) Gamepad_Code.DPAD_DOWN;
    sample.left_stick=.{evdev_axis(0,false),-evdev_axis(1,false)};
    sample.right_stick=.{evdev_axis(3,false),-evdev_axis(4,false)};
    sample.left_trigger=evdev_axis(2,true); sample.right_trigger=evdev_axis(5,true);
    return true;
}
#scope_file
evdev_axis :: (code:u32, trigger:bool) -> float {
    range:=Evdev.libevdev_get_abs_info(evdev_device,code);
    if !range || range.maximum<=range.minimum return 0;
    value:=Evdev.libevdev_get_event_value(evdev_device,3,code);
    unit:=cast(float) (cast(s64) value-range.minimum)/cast(float) (cast(s64) range.maximum-range.minimum);
    unit=clamp(unit,0.0,1.0);
    if trigger return unit;
    return unit*2-1;
}
