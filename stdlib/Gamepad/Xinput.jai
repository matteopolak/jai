// Authored Windows SDK ABI declarations.
XINPUT_GAMEPAD :: struct {
    wButtons: u16;
    bLeftTrigger: u8;
    bRightTrigger: u8;
    sThumbLX: s16;
    sThumbLY: s16;
    sThumbRX: s16;
    sThumbRY: s16;
}
XINPUT_STATE :: struct {
    dwPacketNumber: u32;
    Gamepad: XINPUT_GAMEPAD;
}
XINPUT_VIBRATION :: struct {
    wLeftMotorSpeed: u16;
    wRightMotorSpeed: u16;
}
XInputGetState :: (dwUserIndex: u32, pState: *XINPUT_STATE) -> u32 #foreign xinput;
XInputSetState :: (dwUserIndex: u32, pVibration: *XINPUT_VIBRATION) -> u32 #foreign xinput;
#scope_file
xinput :: #system_library "xinput1_4";
