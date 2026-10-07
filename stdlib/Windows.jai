// Normalized API contracts; reference procedure bodies were discarded.
#assert(OS == .WINDOWS);
DWORD :: u32;
WORD :: u16;

BOOL :: enum s32 {
    FALSE :: 0;
    TRUE :: 1;
}

BOOLEAN :: enum u8 {
    FALSE :: 0;
    TRUE :: 1;
}

SIZE_T :: u64;
size_t :: u64;
LPSTR :: *u8;
LPCSTR :: *u8;
LPCWSTR :: *u16;
WPARAM :: u64;
LPARAM :: s64;
LRESULT :: s64;
HANDLE :: *void;
HKEY :: HANDLE;
HMETAFILE :: HANDLE;
HINSTANCE :: HANDLE;
HMODULE :: HINSTANCE;
HWND :: HANDLE;
HDC :: HANDLE;
HMONITOR :: HANDLE;
HBRUSH :: HANDLE;
HMENU :: HANDLE;
HICON :: HANDLE;
HCURSOR :: HANDLE;
HRAWINPUT :: HANDLE;
HBITMAP :: HANDLE;
HGDIOBJ :: HANDLE;
HLOCAL :: HANDLE;
HFILE :: s32;
HRESULT :: s32;
INFINITE: u32 : 0xffff_ffff;

LARGE_INTEGER :: union {
    struct {
        LowPart: u32;
        HighPart: s32;
    }
    QuadPart: s64;
}

ULARGE_INTEGER :: union {
    struct {
        LowPart: u32;
        HighPart: u32;
    }
    QuadPart: u64;
}

RECT :: struct {
    left, top, right, bottom: s32;
}

SMALL_RECT :: struct {
    left, top, right, bottom: s16;
}

COORD :: struct {
    x, y: s16;
}

POINT :: struct {
    x, y: s32;
}

GUID :: struct {
    Data1: u32;
    Data2: u16;
    Data3: u16;
    Data4: [8] u8;
}

UUID :: GUID;

LUID :: struct {
    LowPart: u32;
    HighPart: s32;
}

SIZE :: struct {
    cx: s32;
    cy: s32;
}

MEMORY_BASIC_INFORMATION :: struct {
    BaseAddress: *void;
    AllocationBase: *void;
    AllocationProtect: DWORD;
    PartitionId: WORD;
    RegionSize: SIZE_T;
    State: DWORD;
    Protect: DWORD;
    Type: DWORD;
}

#assert(size_of(GUID) == 16);

operator == :: (a: GUID, b: GUID) -> bool {
    return memcmp(*a, *b, size_of(GUID)) == 0;
}

REFGUID :: *GUID;
IID :: GUID;
REFIID :: *IID;
S_OK: HRESULT : 0x00000000;
E_FAIL: HRESULT : 0x80000008;
E_NOTIMPL: HRESULT : 0x80004001;
E_NOINTERFACE: HRESULT : 0x80004002;
E_POINTER: HRESULT : 0x80004003;
E_ABORT: HRESULT : 0x80004004;
E_ACCESSDENIED: HRESULT : 0x80070005;
E_HANDLE: HRESULT : 0x80070006;
E_OUTOFMEMORY: HRESULT : 0x8007000E;
E_INVALIDARG: HRESULT : 0x80070057;
E_UNEXPECTED: HRESULT : 0x8000FFFF;
WM_NULL :: 0x0000;
WM_CREATE :: 0x0001;
WM_DESTROY :: 0x0002;
WM_MOVE :: 0x0003;
WM_SIZE :: 0x0005;
WM_SETFOCUS :: 0x0007;
WM_KILLFOCUS :: 0x0008;
WM_ENABLE :: 0x000A;
WM_SETREDRAW :: 0x000B;
WM_SETTEXT :: 0x000C;
WM_GETTEXT :: 0x000D;
WM_GETTEXTLENGTH :: 0x000E;
WM_PAINT :: 0x000F;
WM_CLOSE :: 0x0010;
WM_QUERYENDSESSION :: 0x0011;
WM_QUERYOPEN :: 0x0013;
WM_ENDSESSION :: 0x0016;
WM_QUIT :: 0x0012;
WM_ERASEBKGND :: 0x0014;
WM_SYSCOLORCHANGE :: 0x0015;
WM_SHOWWINDOW :: 0x0018;
WM_WININICHANGE :: 0x001A;
WM_SETTINGCHANGE :: WM_WININICHANGE;
WM_DEVMODECHANGE :: 0x001B;
WM_ACTIVATEAPP :: 0x001C;
WM_FONTCHANGE :: 0x001D;
WM_TIMECHANGE :: 0x001E;
WM_CANCELMODE :: 0x001F;
WM_SETCURSOR :: 0x0020;
WM_MOUSEACTIVATE :: 0x0021;
WM_CHILDACTIVATE :: 0x0022;
WM_QUEUESYNC :: 0x0023;
WM_GETMINMAXINFO :: 0x0024;
WM_NOTIFY :: 0x004E;
WM_INPUTLANGCHANGEREQUEST :: 0x0050;
WM_INPUTLANGCHANGE :: 0x0051;
WM_TCARD :: 0x0052;
WM_HELP :: 0x0053;
WM_USERCHANGED :: 0x0054;
WM_NOTIFYFORMAT :: 0x0055;
WM_CONTEXTMENU :: 0x007B;
WM_STYLECHANGING :: 0x007C;
WM_STYLECHANGED :: 0x007D;
WM_DISPLAYCHANGE :: 0x007E;
WM_GETICON :: 0x007F;
WM_SETICON :: 0x0080;
WM_NCCREATE :: 0x0081;
WM_NCDESTROY :: 0x0082;
WM_NCCALCSIZE :: 0x0083;
WM_NCHITTEST :: 0x0084;
WM_NCPAINT :: 0x0085;
WM_NCACTIVATE :: 0x0086;
WM_GETDLGCODE :: 0x0087;
WM_SYNCPAINT :: 0x0088;
WM_NCMOUSEMOVE :: 0x00A0;
WM_NCLBUTTONDOWN :: 0x00A1;
WM_NCLBUTTONUP :: 0x00A2;
WM_NCLBUTTONDBLCLK :: 0x00A3;
WM_NCRBUTTONDOWN :: 0x00A4;
WM_NCRBUTTONUP :: 0x00A5;
WM_NCRBUTTONDBLCLK :: 0x00A6;
WM_NCMBUTTONDOWN :: 0x00A7;
WM_NCMBUTTONUP :: 0x00A8;
WM_NCMBUTTONDBLCLK :: 0x00A9;
WM_NCXBUTTONDOWN :: 0x00AB;
WM_NCXBUTTONUP :: 0x00AC;
WM_NCXBUTTONDBLCLK :: 0x00AD;
WM_INPUT_DEVICE_CHANGE :: 0x00FE;
WM_INPUT :: 0x00FF;
WM_KEYFIRST :: 0x0100;
WM_KEYDOWN :: 0x0100;
WM_KEYUP :: 0x0101;
WM_CHAR :: 0x0102;
WM_DEADCHAR :: 0x0103;
WM_SYSKEYDOWN :: 0x0104;
WM_SYSKEYUP :: 0x0105;
WM_SYSCHAR :: 0x0106;
WM_SYSDEADCHAR :: 0x0107;
WM_UNICHAR :: 0x0109;
WM_KEYLAST :: 0x0109;
UNICODE_NOCHAR :: 0xFFFF;
WM_IME_STARTCOMPOSITION :: 0x010D;
WM_IME_ENDCOMPOSITION :: 0x010E;
WM_IME_COMPOSITION :: 0x010F;
WM_IME_KEYLAST :: 0x010F;
WM_INITDIALOG :: 0x0110;
WM_COMMAND :: 0x0111;
WM_SYSCOMMAND :: 0x0112;
WM_TIMER :: 0x0113;
WM_HSCROLL :: 0x0114;
WM_VSCROLL :: 0x0115;
WM_INITMENU :: 0x0116;
WM_INITMENUPOPUP :: 0x0117;
WM_GESTURE :: 0x0119;
WM_GESTURENOTIFY :: 0x011A;
WM_MENUSELECT :: 0x011F;
WM_MENUCHAR :: 0x0120;
WM_ENTERIDLE :: 0x0121;
WM_MENURBUTTONUP :: 0x0122;
WM_MENUDRAG :: 0x0123;
WM_MENUGETOBJECT :: 0x0124;
WM_UNINITMENUPOPUP :: 0x0125;
WM_MENUCOMMAND :: 0x0126;
WM_CHANGEUISTATE :: 0x0127;
WM_UPDATEUISTATE :: 0x0128;
WM_QUERYUISTATE :: 0x0129;
WM_CTLCOLORMSGBOX :: 0x0132;
WM_CTLCOLOREDIT :: 0x0133;
WM_CTLCOLORLISTBOX :: 0x0134;
WM_CTLCOLORBTN :: 0x0135;
WM_CTLCOLORDLG :: 0x0136;
WM_CTLCOLORSCROLLBAR :: 0x0137;
WM_CTLCOLORSTATIC :: 0x0138;
MN_GETHMENU :: 0x01E1;
WM_MOUSEFIRST :: 0x0200;
WM_MOUSEMOVE :: 0x0200;
WM_LBUTTONDOWN :: 0x0201;
WM_LBUTTONUP :: 0x0202;
WM_LBUTTONDBLCLK :: 0x0203;
WM_RBUTTONDOWN :: 0x0204;
WM_RBUTTONUP :: 0x0205;
WM_RBUTTONDBLCLK :: 0x0206;
WM_MBUTTONDOWN :: 0x0207;
WM_MBUTTONUP :: 0x0208;
WM_MBUTTONDBLCLK :: 0x0209;
WM_MOUSEWHEEL :: 0x020A;
WM_XBUTTONDOWN :: 0x020B;
WM_XBUTTONUP :: 0x020C;
WM_XBUTTONDBLCLK :: 0x020D;
WM_MOUSEHWHEEL :: 0x020E;
WM_MOUSELAST :: 0x020E;
WM_SIZING :: 0x0214;
WM_EXITSIZEMOVE :: 0x0232;
WM_DROPFILES :: 0x0233;
WM_DPICHANGED :: 0x02E0;
SC_KEYMENU :: 0xF100;
HWND_TOP: HWND : null;
HWND_BOTTOM :: cast(HWND) 1;
HWND_TOPMOST :: cast(HWND) -1;
HWND_NOTOPMOST :: cast(HWND) -2;
WHITE_BRUSH :: 0;
LTGRAY_BRUSH :: 1;
GRAY_BRUSH :: 2;
DKGRAY_BRUSH :: 3;
BLACK_BRUSH :: 4;
NULL_BRUSH :: 5;
HOLLOW_BRUSH :: NULL_BRUSH;
WHITE_PEN :: 6;
BLACK_PEN :: 7;
NULL_PEN :: 8;
OEM_FIXED_FONT :: 10;
ANSI_FIXED_FONT :: 11;
ANSI_VAR_FONT :: 12;
SYSTEM_FONT :: 13;
DEVICE_DEFAULT_FONT :: 14;
DEFAULT_PALETTE :: 15;
SYSTEM_FIXED_FONT :: 16;
VK_LBUTTON :: 0x01;
VK_RBUTTON :: 0x02;
VK_CANCEL :: 0x03;
VK_MBUTTON :: 0x04;
VK_XBUTTON1 :: 0x05;
VK_XBUTTON2 :: 0x06;
VK_BACK :: 0x08;
VK_TAB :: 0x09;
VK_CLEAR :: 0x0C;
VK_RETURN :: 0x0D;
VK_SHIFT :: 0x10;
VK_CONTROL :: 0x11;
VK_MENU :: 0x12;
VK_PAUSE :: 0x13;
VK_CAPITAL :: 0x14;
VK_KANA :: 0x15;
VK_HANGUL :: 0x15;
VK_JUNJA :: 0x17;
VK_FINAL :: 0x18;
VK_HANJA :: 0x19;
VK_KANJI :: 0x19;
VK_ESCAPE :: 0x1B;
VK_CONVERT :: 0x1C;
VK_NONCONVERT :: 0x1D;
VK_ACCEPT :: 0x1E;
VK_MODECHANGE :: 0x1F;
VK_SPACE :: 0x20;
VK_PRIOR :: 0x21;
VK_NEXT :: 0x22;
VK_END :: 0x23;
VK_HOME :: 0x24;
VK_LEFT :: 0x25;
VK_UP :: 0x26;
VK_RIGHT :: 0x27;
VK_DOWN :: 0x28;
VK_SELECT :: 0x29;
VK_PRINT :: 0x2A;
VK_EXECUTE :: 0x2B;
VK_SNAPSHOT :: 0x2C;
VK_INSERT :: 0x2D;
VK_DELETE :: 0x2E;
VK_HELP :: 0x2F;
VK_LWIN :: 0x5B;
VK_RWIN :: 0x5C;
VK_APPS :: 0x5D;
VK_SLEEP :: 0x5F;
VK_NUMPAD0 :: 0x60;
VK_NUMPAD1 :: 0x61;
VK_NUMPAD2 :: 0x62;
VK_NUMPAD3 :: 0x63;
VK_NUMPAD4 :: 0x64;
VK_NUMPAD5 :: 0x65;
VK_NUMPAD6 :: 0x66;
VK_NUMPAD7 :: 0x67;
VK_NUMPAD8 :: 0x68;
VK_NUMPAD9 :: 0x69;
VK_MULTIPLY :: 0x6A;
VK_ADD :: 0x6B;
VK_SEPARATOR :: 0x6C;
VK_SUBTRACT :: 0x6D;
VK_DECIMAL :: 0x6E;
VK_DIVIDE :: 0x6F;
VK_F1 :: 0x70;
VK_F2 :: 0x71;
VK_F3 :: 0x72;
VK_F4 :: 0x73;
VK_F5 :: 0x74;
VK_F6 :: 0x75;
VK_F7 :: 0x76;
VK_F8 :: 0x77;
VK_F9 :: 0x78;
VK_F10 :: 0x79;
VK_F11 :: 0x7A;
VK_F12 :: 0x7B;
VK_F13 :: 0x7C;
VK_F14 :: 0x7D;
VK_F15 :: 0x7E;
VK_F16 :: 0x7F;
VK_F17 :: 0x80;
VK_F18 :: 0x81;
VK_F19 :: 0x82;
VK_F20 :: 0x83;
VK_F21 :: 0x84;
VK_F22 :: 0x85;
VK_F23 :: 0x86;
VK_F24 :: 0x87;
VK_NUMLOCK :: 0x90;
VK_SCROLL :: 0x91;
VK_OEM_NEC_EQUAL :: 0x92;
VK_OEM_FJ_JISHO :: 0x92;
VK_OEM_FJ_MASSHOU :: 0x93;
VK_OEM_FJ_TOUROKU :: 0x94;
VK_OEM_FJ_LOYA :: 0x95;
VK_OEM_FJ_ROYA :: 0x96;
VK_LSHIFT :: 0xA0;
VK_RSHIFT :: 0xA1;
VK_LCONTROL :: 0xA2;
VK_RCONTROL :: 0xA3;
VK_LMENU :: 0xA4;
VK_RMENU :: 0xA5;
VK_BROWSER_BACK :: 0xA6;
VK_BROWSER_FORWARD :: 0xA7;
VK_BROWSER_REFRESH :: 0xA8;
VK_BROWSER_STOP :: 0xA9;
VK_BROWSER_SEARCH :: 0xAA;
VK_BROWSER_FAVORITES :: 0xAB;
VK_BROWSER_HOME :: 0xAC;
VK_VOLUME_MUTE :: 0xAD;
VK_VOLUME_DOWN :: 0xAE;
VK_VOLUME_UP :: 0xAF;
VK_MEDIA_NEXT_TRACK :: 0xB0;
VK_MEDIA_PREV_TRACK :: 0xB1;
VK_MEDIA_STOP :: 0xB2;
VK_MEDIA_PLAY_PAUSE :: 0xB3;
VK_LAUNCH_MAIL :: 0xB4;
VK_LAUNCH_MEDIA_SELECT :: 0xB5;
VK_LAUNCH_APP1 :: 0xB6;
VK_LAUNCH_APP2 :: 0xB7;
VK_OEM_1 :: 0xBA;
VK_OEM_PLUS :: 0xBB;
VK_OEM_COMMA :: 0xBC;
VK_OEM_MINUS :: 0xBD;
VK_OEM_PERIOD :: 0xBE;
VK_OEM_2 :: 0xBF;
VK_OEM_3 :: 0xC0;
VK_OEM_4 :: 0xDB;
VK_OEM_5 :: 0xDC;
VK_OEM_6 :: 0xDD;
VK_OEM_7 :: 0xDE;
VK_OEM_8 :: 0xDF;
VK_OEM_AX :: 0xE1;
VK_OEM_102 :: 0xE2;
VK_ICO_HELP :: 0xE3;
VK_ICO_00 :: 0xE4;
VK_PROCESSKEY :: 0xE5;
VK_ICO_CLEAR :: 0xE6;
VK_PACKET :: 0xE7;
SIZE_RESTORED :: 0;
SIZE_MINIMIZED :: 1;
SIZE_MAXIMIZED :: 2;
SIZE_MAXSHOW :: 3;
SIZE_MAXHIDE :: 4;
SWP_NOSIZE :: 0x0001;
SWP_NOMOVE :: 0x0002;
SWP_NOZORDER :: 0x0004;
SWP_NOREDRAW :: 0x0008;
SWP_NOACTIVATE :: 0x0010;
SWP_FRAMECHANGED :: 0x0020;
SWP_SHOWWINDOW :: 0x0040;
SWP_HIDEWINDOW :: 0x0080;
SWP_NOCOPYBITS :: 0x0100;
SWP_NOOWNERZORDER :: 0x0200;
SWP_NOSENDCHANGING :: 0x0400;
SWP_DRAWFRAME :: SWP_FRAMECHANGED;
SWP_NOREPOSITION :: SWP_NOOWNERZORDER;
SWP_DEFERERASE :: 0x2000;
SWP_ASYNCWINDOWPOS :: 0x4000;
SW_HIDE :: 0;
SW_SHOWNORMAL :: 1;
SW_NORMAL :: 1;
SW_SHOWMINIMIZED :: 2;
SW_SHOWMAXIMIZED :: 3;
SW_MAXIMIZE :: 3;
SW_SHOWNOACTIVATE :: 4;
SW_SHOW :: 5;
SW_MINIMIZE :: 6;
SW_SHOWMINNOACTIVE :: 7;
SW_SHOWNA :: 8;
SW_RESTORE :: 9;
SW_SHOWDEFAULT :: 10;
SW_FORCEMINIMIZE :: 11;
SW_MAX :: 11;
CW_USEDEFAULT :: 0x80000000;
AdjustWindowRect :: (lpRect: *RECT, dwStyle: u32, bMenu: BOOL) -> BOOL #foreign user32;
AdjustWindowRectEx :: (lpRect: *RECT, dwStyle: u32, bMenu: BOOL, dwExStyle: s32) -> BOOL #foreign user32;
CreateWindowExA :: (dwExStyle: s32, lpClassName: *u8, lpWindowName: *u8, dwStyle: u32, x: s32, y: s32, nWidth: s32, nHeight: s32, hwndParent: HWND, hMenu: HMENU, hInstance: HINSTANCE, lpParam: *void) -> HWND #foreign user32;
CreateWindowExW :: (dwExStyle: s32, lpClassName: *u16, lpWindowName: *u16, dwStyle: u32, x: s32, y: s32, nWidth: s32, nHeight: s32, hwndParent: HWND, hMenu: HMENU, hInstance: HINSTANCE, lpParam: *void) -> HWND #foreign user32;
CreateSolidBrush :: (color: u32) -> HBRUSH #foreign gdi;
DestroyWindow :: (hWnd: HWND) -> BOOL #foreign user32;
GetClientRect :: (hwnd: HWND, rect: *RECT) -> s32 #foreign user32;
GetDesktopWindow :: () -> HWND #foreign user32;
GetForegroundWindow :: () -> HWND #foreign user32;
GetWindowRect :: (hwnd: HWND, rect: *RECT) -> s32 #foreign user32;
SetProcessDPIAware :: () -> s32 #foreign user32;
SetWindowPos :: (hwnd: HWND, hWndInsertAfter: HWND, X: s32, Y: s32, cx: s32, cy: s32, uFlags: u32) -> BOOL #foreign user32;
SetWindowTextA :: (hWnd: HWND, lpString: *u8) -> BOOL #foreign user32;
SetWindowTextW :: (hWnd: HWND, lpString: *u16) -> BOOL #foreign user32;
ShowWindow :: (hwnd: HWND, nCmdShow: s32) -> s32 #foreign user32;
WindowFromPoint :: (Point: POINT) -> HWND #foreign user32;
WNDCLASSEXA :: struct {};

WNDCLASSEXW :: struct {
    cbSize: u32;
    style: u32;
    lpfnWndProc: *void;
    cbClsExtra: s32;
    cbWndExtra: s32;
    hInstance: HINSTANCE;
    hIcon: HICON;
    hCursor: HCURSOR;
    hbrBackground: HBRUSH;
    lpszMenuName: *u16;
    lpszClassName: *u16;
    hIconSm: HICON;
}

CS_VREDRAW :: 0x0001;
CS_HREDRAW :: 0x0002;
CS_OWNDC :: 0x0020;
WS_OVERLAPPED :: 0x00000000;
WS_POPUP :: 0x80000000;
WS_CHILD :: 0x40000000;
WS_MINIMIZE :: 0x20000000;
WS_VISIBLE :: 0x10000000;
WS_DISABLED :: 0x08000000;
WS_CLIPSIBLINGS :: 0x04000000;
WS_CLIPCHILDREN :: 0x02000000;
WS_MAXIMIZE :: 0x01000000;
WS_CAPTION :: 0x00C00000;
WS_BORDER :: 0x00800000;
WS_DLGFRAME :: 0x00400000;
WS_VSCROLL :: 0x00200000;
WS_HSCROLL :: 0x00100000;
WS_SYSMENU :: 0x00080000;
WS_THICKFRAME :: 0x00040000;
WS_GROUP :: 0x00020000;
WS_TABSTOP :: 0x00010000;
WS_MINIMIZEBOX :: 0x00020000;
WS_MAXIMIZEBOX :: 0x00010000;
WS_SIZEBOX :: WS_THICKFRAME;
WS_OVERLAPPEDWINDOW :: WS_OVERLAPPED | WS_CAPTION | WS_SYSMENU | WS_THICKFRAME | WS_MINIMIZEBOX | WS_MAXIMIZEBOX;
WS_EX_DLGMODALFRAME :: 0x00000001;
WS_EX_NOPARENTNOTIFY :: 0x00000004;
WS_EX_TOPMOST :: 0x00000008;
WS_EX_ACCEPTFILES :: 0x00000010;
WS_EX_TRANSPARENT :: 0x00000020;
WS_EX_MDICHILD :: 0x00000040;
WS_EX_TOOLWINDOW :: 0x00000080;
WS_EX_WINDOWEDGE :: 0x00000100;
WS_EX_CLIENTEDGE :: 0x00000200;
WS_EX_CONTEXTHELP :: 0x00000400;
WS_EX_RIGHT :: 0x00001000;
WS_EX_LEFT :: 0x00000000;
WS_EX_RTLREADING :: 0x00002000;
WS_EX_LTRREADING :: 0x00000000;
WS_EX_LEFTSCROLLBAR :: 0x00004000;
WS_EX_RIGHTSCROLLBAR :: 0x00000000;
WS_EX_CONTROLPARENT :: 0x00010000;
WS_EX_STATICEDGE :: 0x00020000;
WS_EX_APPWINDOW :: 0x00040000;
WS_EX_OVERLAPPEDWINDOW :: (WS_EX_WINDOWEDGE | WS_EX_CLIENTEDGE);
WS_EX_PALETTEWINDOW :: (WS_EX_WINDOWEDGE | WS_EX_TOOLWINDOW | WS_EX_TOPMOST);
WS_EX_LAYERED :: 0x00080000;
WS_EX_NOINHERITLAYOUT :: 0x00100000;
WS_EX_NOREDIRECTIONBITMAP :: 0x00200000;
WS_EX_LAYOUTRTL :: 0x00400000;
WS_EX_COMPOSITED :: 0x02000000;
WS_EX_NOACTIVATE :: 0x08000000;
GWL_WNDPROC :: -4;
GWL_HINSTANCE :: -6;
GWL_HWNDPARENT :: -8;
GWL_STYLE :: -16;
GWL_EXSTYLE :: -20;
GWL_USERDATA :: -21;
GWL_ID :: -12;
GetWindowLongA :: (hwnd: HWND, nIndex: s32) -> s32 #foreign user32;
GetWindowLongW :: (hwnd: HWND, nIndex: s32) -> s32 #foreign user32;
RegisterClassExA :: (lpwcx: *WNDCLASSEXA) -> s16 #foreign user32;
RegisterClassExW :: (lpwcx: *WNDCLASSEXW) -> s16 #foreign user32;
SetWindowLongA :: (hwnd: HWND, nIndex: s32, dwNewLong: s32) -> s32 #foreign user32;
SetWindowLongW :: (hwnd: HWND, nIndex: s32, dwNewLong: s32) -> s32 #foreign user32;
SetWindowLongPtrW :: (hwnd: HWND, nIndex: s32, dwNewLong: s64) -> s64 #foreign user32;
UnregisterClassA :: (lpClassName: LPCSTR, hInstance: HINSTANCE) -> BOOL #foreign user32;
UnregisterClassW :: (lpClassName: LPCWSTR, hInstance: HINSTANCE) -> BOOL #foreign user32;
ClientToScreen :: (hwnd: HWND, lpPoint: *POINT) -> s32 #foreign user32;
ScreenToClient :: (hwnd: HWND, p: *POINT) -> s32 #foreign user32;
GetWindowDC :: (hwnd: HWND) -> HDC #foreign user32;
UpdateWindow :: (hwnd: HWND) -> s32 #foreign user32;
ValidateRect :: (hwnd: HWND, lpRect: *RECT) -> BOOL #foreign user32;
CreateCompatibleDC :: (hdc: HDC) -> HDC #foreign gdi;
DeleteDC :: (hdc: HDC) -> BOOL #foreign gdi;
DeleteObject :: (ho: HGDIOBJ) -> BOOL #foreign gdi;
GetDC :: (hwnd: HWND) -> HDC #foreign user32;
PW_CLIENTONLY :: 0x1;
PW_RENDERFULLCONTENT :: 0x2;
PrintWindow :: (hwnd: HWND, hdcBlt: HDC, nFlags: u32) -> BOOL #foreign user32;
DRIVERVERSION :: 0;
TECHNOLOGY :: 2;
HORZSIZE :: 4;
VERTSIZE :: 6;
HORZRES :: 8;
VERTRES :: 10;
BITSPIXEL :: 12;
PLANES :: 14;
NUMBRUSHES :: 16;
NUMPENS :: 18;
NUMMARKERS :: 20;
NUMFONTS :: 22;
NUMCOLORS :: 24;
PDEVICESIZE :: 26;
CURVECAPS :: 28;
LINECAPS :: 30;
POLYGONALCAPS :: 32;
TEXTCAPS :: 34;
CLIPCAPS :: 36;
RASTERCAPS :: 38;
ASPECTX :: 40;
ASPECTY :: 42;
ASPECTXY :: 44;
LOGPIXELSX :: 88;
LOGPIXELSY :: 90;
SIZEPALETTE :: 104;
NUMRESERVED :: 106;
COLORRES :: 108;
PHYSICALWIDTH :: 110;
PHYSICALHEIGHT :: 111;
PHYSICALOFFSETX :: 112;
PHYSICALOFFSETY :: 113;
SCALINGFACTORX :: 114;
SCALINGFACTORY :: 115;
VREFRESH :: 116;
DESKTOPVERTRES :: 117;
DESKTOPHORZRES :: 118;
BLTALIGNMENT :: 119;
SHADEBLENDCAPS :: 120;
COLORMGMTCAPS :: 121;
GetDeviceCaps :: (hdc: HDC, index: s32) -> s32 #foreign gdi;
GetObjectA :: (h: HANDLE, c: s32, pv: *void) -> s32 #foreign gdi;
GetObjectW :: (h: HANDLE, c: s32, pv: *void) -> s32 #foreign gdi;
GetStockObject :: (fnObject: s32) -> HANDLE #foreign gdi;
ReleaseDC :: (hwnd: HWND, hdc: HDC) -> s32 #foreign user32;
SelectObject :: (hdc: HDC, h: HGDIOBJ) -> HGDIOBJ #foreign gdi;
WindowFromDC :: (dc: HDC) -> HWND #foreign user32;

ICONINFO :: struct {
    fIcon: BOOL;
    xHotspot: u32;
    yHotspot: u32;
    hbmMask: HBITMAP;
    hbmColor: HBITMAP;
}

ICONINFOEXW :: struct {
    cbSize: u32;
    fIcon: BOOL;
    xHotspot: u32;
    yHotspot: u32;
    hbmMask: HBITMAP;
    hbmColor: HBITMAP;
    wResID: u16;
    szModName: [MAX_PATH] u16;
    szResName: [MAX_PATH] u16;
}

BITMAP :: struct {
    bmType: u32;
    bmWidth: u32;
    bmHeight: u32;
    bmWidthBytes: u32;
    bmPlanes: u16;
    bmBitsPixel: u16;
    bmBits: *void;
}

RGBQUAD :: struct {
    rgbBlue: u8;
    rgbGreen: u8;
    rgbRed: u8;
    rgbReserved: u8;
}

BITMAPINFO :: struct {
    bmiHeader: BITMAPINFOHEADER;
    bmiColors: [1] RGBQUAD;
}

BITMAPFILEHEADER :: struct {
    bfType: u16;
    bfSize: u32;
    bfReserved1: u16;
    bfReserved2: u16;
    bfOffBits: u32;
}

ExtractIconA :: (hInst: HINSTANCE, lpszExeFileName: *u8, nIconIndex: u32) -> HICON #foreign shell32;
ExtractIconW :: (hInst: HINSTANCE, lpszExeFileName: *u16, nIconIndex: u32) -> HICON #foreign shell32;
GetIconInfo :: (hIcon: HICON, piconinfo: *ICONINFO) -> BOOL #foreign user32;
GetIconInfoExA :: (hIcon: HICON, piconinfo: *void) -> BOOL #foreign user32;
GetIconInfoExW :: (hIcon: HICON, piconinfo: *ICONINFOEXW) -> BOOL #foreign user32;
LoadIconA :: (hInstance: HINSTANCE, lpIconName: *u8) -> HICON #foreign user32;
LoadIconW :: (hInstance: HINSTANCE, lpIconName: *u16) -> HICON #foreign user32;
IDC_APPSTARTING :: cast(*void) 32650;
IDC_ARROW :: cast(*void) 32512;
IDC_CROSS :: cast(*void) 32515;
IDC_HAND :: cast(*void) 32649;
IDC_HELP :: cast(*void) 32651;
IDC_IBEAM :: cast(*void) 32513;
IDC_ICON :: cast(*void) 32641;
IDC_NO :: cast(*void) 32648;
IDC_SIZE :: cast(*void) 32640;
IDC_SIZEALL :: cast(*void) 32646;
IDC_SIZENESW :: cast(*void) 32643;
IDC_SIZENS :: cast(*void) 32645;
IDC_SIZENWSE :: cast(*void) 32642;
IDC_SIZEWE :: cast(*void) 32644;
IDC_UPARROW :: cast(*void) 32516;
IDC_WAIT :: cast(*void) 32514;
ClipCursor :: (lpRect: *RECT) -> s32 #foreign user32;
GetCursorPos :: (p: *POINT) -> s32 #foreign user32;
LoadCursorA :: (hInstance: HINSTANCE, lpCursorName: *u8) -> HCURSOR #foreign user32;
LoadCursorW :: (hInstance: HINSTANCE, lpCursorName: *s16) -> HCURSOR #foreign user32;
SetCursor :: (cursor: HCURSOR) -> HCURSOR #foreign user32;
ShowCursor :: (bShow: s32) -> s32 #foreign user32;

MSG :: struct {
    hwnd: HWND;
    message: u32;
    wParam: WPARAM;
    lParam: LPARAM;
    time: s32;
    pt: POINT;
    lPrivate: s32;
}

PM_NOREMOVE :: 0x0000;
PM_REMOVE :: 0x0001;
PM_NOYIELD :: 0x0002;
DispatchMessageA :: (msg: *MSG) -> s32 #foreign user32;
DispatchMessageW :: (msg: *MSG) -> s32 #foreign user32;
GetMessageExtraInfo :: () -> LPARAM #foreign user32;
PeekMessageA :: (msg: *MSG, hwnd: HWND, wMsgFilterMin: u32, wMsgFilterMax: u32, wRemoveMsg: u32) -> s32 #foreign user32;
PeekMessageW :: (msg: *MSG, hwnd: HWND, wMsgFilterMin: u32, wMsgFilterMax: u32, wRemoveMsg: u32) -> s32 #foreign user32;
PostQuitMessage :: (index: s32) -> void #foreign user32;
TranslateMessage :: (msg: *MSG) -> s32 #foreign user32;
DefWindowProcA :: (hWnd: HWND, Msg: u32, wParam: WPARAM, lParam: LPARAM) -> s64 #foreign user32;
DefWindowProcW :: (hWnd: HWND, Msg: u32, wParam: WPARAM, lParam: LPARAM) -> s64 #foreign user32;
MONITOR_DEFAULTTONULL :: 0x00000000;
MONITOR_DEFAULTTOPRIMARY :: 0x00000001;
MONITOR_DEFAULTTONEAREST :: 0x00000002;

MONITORINFO :: struct {
    cbSize: s32;
    rcMonitor: RECT;
    rcWork: RECT;
    dwFlags: s32;
}

EnumDisplayMonitors :: (hdc: HDC, lprcClip: *RECT, lpfnEnum: MONITORENUMPROC, dwData: LPARAM) -> BOOL #foreign user32;
GetMonitorInfoA :: (hMonitor: HMONITOR, lpmi: *MONITORINFO) -> BOOL #foreign user32;
GetMonitorInfoW :: (hMonitor: HMONITOR, lpmi: *MONITORINFO) -> BOOL #foreign user32;
MONITORENUMPROC :: #type (hMonitor: HMONITOR, hdcMonitor: HDC, lprcMonitor: *RECT, dwData: LPARAM) -> BOOL #c_call;
MonitorFromPoint :: (pt: POINT, dwFlags: u32) -> HMONITOR #foreign user32;
MonitorFromRect :: (lprc: *RECT, dwFlags: u32) -> HMONITOR #foreign user32;
MonitorFromWindow :: (hwnd: HWND, dwFlags: u32) -> HMONITOR #foreign user32;
GetActiveWindow :: () -> HWND #foreign user32;
GetAsyncKeyState :: (nVirtKey: s32) -> s16 #foreign user32;
GetFocus :: () -> HWND #foreign user32;
GetKeyState :: (nVirtKey: s32) -> s16 #foreign user32;
SetActiveWindow :: (hwnd: HWND) -> HWND #foreign user32;
ReleaseCapture :: () -> BOOL #foreign user32;
SetCapture :: (hwnd: HWND) -> HWND #foreign user32;

RAWINPUTHEADER :: struct {
    dwType: u32;
    dwSize: u32;
    hDevice: HANDLE;
    wParam: WPARAM;
}

RAWINPUT :: struct {
    header: RAWINPUTHEADER;
    data: union {
        mouse: RAWMOUSE;
        keyboard: RAWKEYBOARD;
        hid: RAWHID;
    };
}

RAWMOUSE :: struct {
    usFlags: u16;
    union {
        ulButtons: u32;
        struct {
            usButtonFlags: u16;
            usButtonData: u16;
        }
    }
    ulRawButtons: u32;
    lLastX: s32;
    lLastY: s32;
    ulExtraInformation: u32;
}

RAWHID :: struct {
    dwSizeHid: u32;
    dwCount: u32;
    bRawData: [1] u8;
}

RAWKEYBOARD :: struct {
    MakeCode: u16;
    Flags: u16;
    Reserved: u16;
    VKey: u16;
    Message: u32;
    ExtraInformation: u32;
}

RAWINPUTDEVICE :: struct {
    usUsagePage: u16;
    usUsage: u16;
    dwFlags: s32;
    hwndTarget: HWND;
}

RID_INPUT :: 0x10000003;
RID_HEADER :: 0x10000005;
RIM_INPUT :: 0x00000000;
RIM_INPUTSINK :: 0x00000001;
RIM_TYPEMOUSE :: 0x00000000;
RIM_TYPEKEYBOARD :: 0x00000001;
RIM_TYPEHID :: 0x00000002;
MOUSE_MOVE_RELATIVE :: 0x00;
MOUSE_MOVE_ABSOLUTE :: 0x01;
MOUSE_VIRTUAL_DESKTOP :: 0x02;
MOUSE_ATTRIBUTES_CHANGED :: 0x04;
MOUSE_MOVE_NOCOALESCE :: 0x08;
RI_MOUSE_LEFT_BUTTON_DOWN :: 0x0001;
RI_MOUSE_LEFT_BUTTON_UP :: 0x0002;
RI_MOUSE_RIGHT_BUTTON_DOWN :: 0x0004;
RI_MOUSE_RIGHT_BUTTON_UP :: 0x0008;
RI_MOUSE_MIDDLE_BUTTON_DOWN :: 0x0010;
RI_MOUSE_MIDDLE_BUTTON_UP :: 0x0020;
RI_MOUSE_BUTTON_1_DOWN :: RI_MOUSE_LEFT_BUTTON_DOWN;
RI_MOUSE_BUTTON_1_UP :: RI_MOUSE_LEFT_BUTTON_UP;
RI_MOUSE_BUTTON_2_DOWN :: RI_MOUSE_RIGHT_BUTTON_DOWN;
RI_MOUSE_BUTTON_2_UP :: RI_MOUSE_RIGHT_BUTTON_UP;
RI_MOUSE_BUTTON_3_DOWN :: RI_MOUSE_MIDDLE_BUTTON_DOWN;
RI_MOUSE_BUTTON_3_UP :: RI_MOUSE_MIDDLE_BUTTON_UP;
RI_MOUSE_BUTTON_4_DOWN :: 0x0040;
RI_MOUSE_BUTTON_4_UP :: 0x0080;
RI_MOUSE_BUTTON_5_DOWN :: 0x0100;
RI_MOUSE_BUTTON_5_UP :: 0x0200;
RI_MOUSE_WHEEL :: 0x0400;
RI_KEY_MAKE :: 0;
RI_KEY_BREAK :: 1;
RI_KEY_E0 :: 2;
RI_KEY_E1 :: 4;
GetRawInputData :: (hRawInput: HRAWINPUT, uiCommand: u32, pData: *void, pcbSize: *u32, cbSizeHeader: u32) -> u32 #foreign user32;
GetRawInputDeviceInfoA :: (hDevice: HANDLE, uiCommand: u32, pData: *void, pcbSize: *u32) -> u32 #foreign user32;
RegisterRawInputDevices :: (pRawInputDevices: *void, uiNumDevices: u32, cbSize: u32) -> s32 #foreign user32;

PIXELFORMATDESCRIPTOR :: struct {
    nSize: s16;
    nVersion: s16;
    dwFlags: s32;
    iPixelType: u8;
    cColorBits: u8;
    cRedBits: u8;
    cRedShift: u8;
    cGreenBits: u8;
    cGreenShift: u8;
    cBlueBits: u8;
    cBlueShift: u8;
    cAlphaBits: u8;
    cAlphaShift: u8;
    cAccumBits: u8;
    cAccumRedBits: u8;
    cAccumGreenBits: u8;
    cAccumBlueBits: u8;
    cAccumAlphaBits: u8;
    cDepthBits: u8;
    cStencilBits: u8;
    cAuxBuffers: u8;
    iLayerType: u8;
    bReserved: u8;
    dwLayerMask: s32;
    dwVisibleMask: s32;
    dwDamageMask: s32;
}

PFD_DOUBLEBUFFER :: 0x00000001;
PFD_STEREO :: 0x00000002;
PFD_DRAW_TO_WINDOW :: 0x00000004;
PFD_DRAW_TO_BITMAP :: 0x00000008;
PFD_SUPPORT_GDI :: 0x00000010;
PFD_SUPPORT_OPENGL :: 0x00000020;
PFD_GENERIC_FORMAT :: 0x00000040;
PFD_NEED_PALETTE :: 0x00000080;
PFD_NEED_SYSTEM_PALETTE :: 0x00000100;
PFD_SWAP_EXCHANGE :: 0x00000200;
PFD_SWAP_COPY :: 0x00000400;
PFD_SWAP_LAYER_BUFFERS :: 0x00000800;
PFD_GENERIC_ACCELERATED :: 0x00001000;
PFD_SUPPORT_DIRECTDRAW :: 0x00002000;
PFD_DIRECT3D_ACCELERATED :: 0x00004000;
PFD_SUPPORT_COMPOSITION :: 0x00008000;
PFD_TYPE_RGBA :: 0;
PFD_TYPE_COLORINDEX :: 1;
PFD_MAIN_PLANE :: 0;
PFD_OVERLAY_PLANE :: 1;
PFD_UNDERLAY_PLANE :: -1;
WGL_FONT_LINES :: 0;
WGL_FONT_POLYGONS :: 1;
WGL_SWAP_MAIN_PLANE :: 0x00000001;
WGL_SWAP_OVERLAY1 :: 0x00000002;
WGL_SWAP_OVERLAY2 :: 0x00000004;
WGL_SWAP_OVERLAY3 :: 0x00000008;
WGL_SWAP_OVERLAY4 :: 0x00000010;
WGL_SWAP_OVERLAY5 :: 0x00000020;
WGL_SWAP_OVERLAY6 :: 0x00000040;
WGL_SWAP_OVERLAY7 :: 0x00000080;
WGL_SWAP_OVERLAY8 :: 0x00000100;
WGL_SWAP_OVERLAY9 :: 0x00000200;
WGL_SWAP_OVERLAY10 :: 0x00000400;
WGL_SWAP_OVERLAY11 :: 0x00000800;
WGL_SWAP_OVERLAY12 :: 0x00001000;
WGL_SWAP_OVERLAY13 :: 0x00002000;
WGL_SWAP_OVERLAY14 :: 0x00004000;
WGL_SWAP_OVERLAY15 :: 0x00008000;
WGL_SWAP_UNDERLAY1 :: 0x00010000;
WGL_SWAP_UNDERLAY2 :: 0x00020000;
WGL_SWAP_UNDERLAY3 :: 0x00040000;
WGL_SWAP_UNDERLAY4 :: 0x00080000;
WGL_SWAP_UNDERLAY5 :: 0x00100000;
WGL_SWAP_UNDERLAY6 :: 0x00200000;
WGL_SWAP_UNDERLAY7 :: 0x00400000;
WGL_SWAP_UNDERLAY8 :: 0x00800000;
WGL_SWAP_UNDERLAY9 :: 0x01000000;
WGL_SWAP_UNDERLAY10 :: 0x02000000;
WGL_SWAP_UNDERLAY11 :: 0x04000000;
WGL_SWAP_UNDERLAY12 :: 0x08000000;
WGL_SWAP_UNDERLAY13 :: 0x10000000;
WGL_SWAP_UNDERLAY14 :: 0x20000000;
WGL_SWAP_UNDERLAY15 :: 0x40000000;
HGLRC :: HANDLE;
ChoosePixelFormat :: (hdc: HDC, ppfd: *PIXELFORMATDESCRIPTOR) -> s32 #foreign gdi;
DescribePixelFormat :: (hdc: HDC, iPixelFormat: s32, nBytes: u32, ppfd: *PIXELFORMATDESCRIPTOR) -> s32 #foreign gdi;
GetPixelFormat :: (hdc: HDC) -> s32 #foreign gdi;
SetPixelFormat :: (hdc: HDC, iPixelFormat: s32, ppfd: *PIXELFORMATDESCRIPTOR) -> BOOL #foreign gdi;
SwapBuffers :: (hdc: HDC) -> BOOL #foreign gdi;
wglCopyContext :: (hglrcSrc: HGLRC, hglrcDst: HGLRC, mask: u32) -> BOOL #foreign gl;
wglCreateContext :: (hdc: HDC) -> HGLRC #foreign gl;
wglCreateLayerContext :: (hdc: HDC, level: s32) -> HGLRC #foreign gl;
wglDeleteContext :: (oldContext: HGLRC) -> BOOL #foreign gl;
wglGetCurrentContext :: () -> HGLRC #foreign gl;
wglGetCurrentDC :: () -> HDC #foreign gl;
wglGetProcAddress :: (lpszProc: *u8) -> *void #foreign gl;
wglMakeCurrent :: (hdc: HDC, newContext: HGLRC) -> BOOL #foreign gl;
wglRealizeLayerPalette :: (hdc: HDC, iLayerPlane: s32, bRealize: BOOL) -> BOOL #foreign gl;
wglShareLists :: (hrcSrvShare: HGLRC, hrcSrvSource: HGLRC) -> BOOL #foreign gl;
wglSwapLayerBuffers :: (hdc: HDC, fuFlags: u32) -> BOOL #foreign gl;
wglUseFontBitmapsA :: (hDC: HDC, first: u32, count: u32, listBase: u32) -> BOOL #foreign gl;
wglUseFontBitmapsW :: (hDC: HDC, first: u32, count: u32, listBase: u32) -> BOOL #foreign gl;

using PROCESS_DPI_AWARENESS :: enum s32 {
    PROCESS_DPI_UNAWARE :: 0;
    PROCESS_SYSTEM_DPI_AWARE :: 1;
    PROCESS_PER_MONITOR_DPI_AWARE :: 2;
}

using MONITOR_DPI_TYPE :: enum s32 {
    MDT_EFFECTIVE_DPI;
    MDT_ANGULAR_DPI;
    MDT_RAW_DPI;
    MDT_DEFAULT;
}

using DPI_AWARENESS :: enum s32 {
    DPI_AWARENESS_INVALID :: -1;
    DPI_AWARENESS_UNAWARE :: 0;
    DPI_AWARENESS_SYSTEM_AWARE :: 1;
    DPI_AWARENESS_PER_MONITOR_AWARE :: 2;
}

DPI_AWARENESS_CONTEXT :: #type *struct {};
DPI_AWARENESS_CONTEXT_UNAWARE :: cast(DPI_AWARENESS_CONTEXT) -1;
DPI_AWARENESS_CONTEXT_SYSTEM_AWARE :: cast(DPI_AWARENESS_CONTEXT) -2;
DPI_AWARENESS_CONTEXT_PER_MONITOR_AWARE :: cast(DPI_AWARENESS_CONTEXT) -3;
DPI_AWARENESS_CONTEXT_PER_MONITOR_AWARE_V2 :: cast(DPI_AWARENESS_CONTEXT) -4;
DPI_AWARENESS_CONTEXT_UNAWARE_GDISCALED :: cast(DPI_AWARENESS_CONTEXT) -5;

GetLogicalProcessorInformationEx :: (
RelationshipType: LOGICAL_PROCESSOR_RELATIONSHIP,
Buffer: *SYSTEM_LOGICAL_PROCESSOR_INFORMATION_EX,
ReturnedLength: *u32
) -> BOOL #foreign kernel32;

OSVERSIONINFOA :: struct {
    dwOSVersionInfoSize: u32;
    dwMajorVersion: u32;
    dwMinorVersion: u32;
    dwBuildNumber: u32;
    dwPlatformId: u32;
    szCSDVersion: [128] u8;
}

OSVERSIONINFOW :: struct {
    dwOSVersionInfoSize: u32;
    dwMajorVersion: u32;
    dwMinorVersion: u32;
    dwBuildNumber: u32;
    dwPlatformId: u32;
    szCSDVersion: [128] u16;
}

OSVERSIONINFOEXA :: struct {
    #as using osversioninfo: OSVERSIONINFOA;
    wServicePackMajor: u16;
    wServicePackMinor: u16;
    wSuiteMask: u16;
    wProductType: u8;
    wReserved: u8;
}

OSVERSIONINFOEXW :: struct {
    #as using osversioninfo: OSVERSIONINFOW;
    wServicePackMajor: u16;
    wServicePackMinor: u16;
    wSuiteMask: u16;
    wProductType: u8;
    wReserved: u8;
}

SYSTEM_INFO :: struct {
    wProcessorArchitecture: u16;
    wReserved: u16;
    dwPageSize: u32;
    lpMinimumApplicationAddress: *void;
    lpMaximumApplicationAddress: *void;
    dwActiveProcessorMask: u64;
    dwNumberOfProcessors: u32;
    dwProcessorType: u32;
    dwAllocationGranularity: u32;
    wProcessorLevel: u16;
    wProcessorRevision: u16;
}

MAX_COMPUTERNAME_LENGTH :: 31;

using LOGICAL_PROCESSOR_RELATIONSHIP :: enum s32 {
    RelationProcessorCore;
    RelationNumaNode;
    RelationCache;
    RelationProcessorPackage;
    RelationGroup;
    RelationProcessorDie;
    RelationNumaNodeEx;
    RelationProcessorModule;
    RelationAll :: 0xffff;
}

SYSTEM_LOGICAL_PROCESSOR_INFORMATION_EX :: struct {
    Relationship: LOGICAL_PROCESSOR_RELATIONSHIP;
    Size: u32;
    union {
        Processor: PROCESSOR_RELATIONSHIP;
        NumaNode: NUMA_NODE_RELATIONSHIP;
        Cache: CACHE_RELATIONSHIP;
        Group: GROUP_RELATIONSHIP;
    }
}

PROCESSOR_RELATIONSHIP :: struct {
    Flags: u8;
    EfficiencyClass: u8;
    Reserved: [20] u8;
    GroupCount: u16;
    GroupMask: GROUP_AFFINITY;
}

NUMA_NODE_RELATIONSHIP :: struct {
    NodeNumber: u32;
    Reserved: [18] u8;
    GroupCount: u16;
    GroupMask: GROUP_AFFINITY;
}

CACHE_RELATIONSHIP :: struct {
    Level: u8;
    Associativity: u8;
    LineSize: u16;
    CacheSize: u32;
    Type: PROCESSOR_CACHE_TYPE;
    Reserved: [18] u8;
    GroupCount: u16;
    GroupMask: GROUP_AFFINITY;
}

using PROCESSOR_CACHE_TYPE :: enum {
    CacheUnified;
    CacheInstruction;
    CacheData;
    CacheTrace;
}

GROUP_RELATIONSHIP :: struct {
    MaximumGroupCount: u16;
    ActiveGroupCount: u16;
    Reserved: [20] u8;
    GroupInfo: PROCESSOR_GROUP_INFO;
}

PROCESSOR_GROUP_INFO :: struct {
    MaximumProcessorCount: u8;
    ActiveProcessorCount: u8;
    Reserved: [38] u8;
    ActiveProcessorMask: u64;
}

GROUP_AFFINITY :: struct {
    Mask: u64;
    Group: u16;
    Reserved: [3] u16;
}

SYSTEM_CPU_SET_INFORMATION :: struct {
    Size: u32;
    Type: enum u32 {
        CpuSetInformation;
    };
    union {
        CpuSet: struct {
            Id: u32;
            Group: u16;
            LogicalProcessorIndex: u8;
            CoreIndex: u8;
            LastLevelCacheIndex: u8;
            NumaNodeIndex: u8;
            EfficiencyClass: u8;
            union {
                using AllFlags: enum_flags u8 {
                    Parked :: 0x1;
                    Allocated :: 0x2;
                    AllocatedToTargetProcess :: 0x4;
                    RealTime :: 0x8;
                    ReservedFlags :: 0xF0;
                }
            }
            union {
                Reserved: u32;
                SchedulingClass: u8;
            }
            AllocationTag: u64;
        }
    }
}

GetComputerNameA :: (lpBuffer: *u8, nSize: *u32) -> BOOL #foreign kernel32;
GetComputerNameW :: (lpBuffer: *u16, nSize: *u32) -> BOOL #foreign kernel32;
GetSystemDirectoryA :: (lpBuffer: *u8, uSize: u32) -> u32 #foreign kernel32;
GetSystemDirectoryW :: (lpBuffer: *u16, uSize: u32) -> u32 #foreign kernel32;
GetSystemInfo :: (lpSystemInfo: *SYSTEM_INFO) -> void #foreign kernel32;
GetNativeSystemInfo :: (lpSystemInfo: *SYSTEM_INFO) -> void #foreign kernel32;
GetUserNameA :: (lpBuffer: *u8, lpnSize: *u32) -> BOOL #foreign Advapi32;
GetUserNameW :: (lpBuffer: *u16, lpnSize: *u32) -> BOOL #foreign Advapi32;
GetVersion :: () -> u32 #foreign kernel32;
GetVersionExA :: (lpVersionInfo: *OSVERSIONINFOA) -> BOOL #foreign kernel32;
GetVersionExW :: (lpVersionInfo: *OSVERSIONINFOW) -> BOOL #foreign kernel32;
QueryPerformanceFrequency :: (result: *s64) -> s32 #foreign kernel32;
QueryPerformanceCounter :: (result: *s64) -> s32 #foreign kernel32;
VER_NT_WORKSTATION :: 0x0000001;
VER_NT_DOMAIN_CONTROLLER :: 0x0000002;
VER_NT_SERVER :: 0x0000003;
RtlGetVersion :: (lpVersionInfo: *OSVERSIONINFOW) -> void #foreign ntdll;

SECURITY_ATTRIBUTES :: struct {
    nLength: u32;
    lpSecurityDescriptor: *void;
    bInheritHandle: BOOL;
}

LIST_ENTRY :: struct {
    Flink: *LIST_ENTRY;
    Blink: *LIST_ENTRY;
}

RTL_CRITICAL_SECTION_DEBUG :: struct {
    Type: u16;
    CreatorBackTraceIndex: u16;
    CriticalSection: *RTL_CRITICAL_SECTION;
    ProcessLocksList: LIST_ENTRY;
    EntryCount: u32;
    ContentionCount: u32;
    Flags: u32;
    CreatorBackTraceIndexHigh: u16;
    SpareWORD: u16;
}

RTL_CRITICAL_SECTION :: struct {
    DebugInfo: *RTL_CRITICAL_SECTION_DEBUG;
    LockCount: u32;
    RecursionCount: u32;
    OwningThread: HANDLE;
    LockSemaphore: HANDLE;
    SpinCount: u64;
}

CRITICAL_SECTION :: RTL_CRITICAL_SECTION;

OVERLAPPED :: struct {
    union {
        Internal: u64;
        Status: u64;
    }
    union {
        InternalHigh: u64;
        NumberOfBytesTransferred: u64;
    }
    union {
        struct {
            Offset: u32;
            OffsetHigh: u32;
        }
        Offset64: u64;
        Pointer: *void;
    }
    hEvent: HANDLE;
}

STATUS_PENDING: u32 : 0x00000103;
PIPE_WAIT: u32 : 0x00000000;
PIPE_NOWAIT: u32 : 0x00000001;
PIPE_ACCESS_INBOUND: u32 : 0x00000001;
PIPE_ACCESS_OUTBOUND: u32 : 0x00000002;
PIPE_ACCESS_DUPLEX: u32 : 0x00000003;
PIPE_TYPE_BYTE: u32 : 0x00000000;
PIPE_READMODE_BYTE: u32 : 0x00000000;
PIPE_ACCEPT_REMOTE_CLIENTS: u32 : 0x00000000;
PIPE_REJECT_REMOTE_CLIENTS: u32 : 0x00000008;
FILE_FLAG_FIRST_PIPE_INSTANCE: u32 : 0x00080000;
GENERIC_ALL: u32 : 0x10000000;
GENERIC_EXECUTE: u32 : 0x20000000;
GENERIC_WRITE: u32 : 0x40000000;
GENERIC_READ: u32 : 0x80000000;
PIPE_UNLIMITED_INSTANCES: u32 : 255;
CreatePipe :: (hReadPipe: *HANDLE, hWritePipe: *HANDLE, lpPipeAttributes: *SECURITY_ATTRIBUTES, nSize: DWORD) -> BOOL #foreign kernel32;
SetNamedPipeHandleState :: (hNamedPipe: HANDLE, lpMode: *DWORD, lpMaxConnectionCount: *DWORD, lpCollectDataTimeout: *DWORD) -> BOOL #foreign kernel32;
PeekNamedPipe :: (hNamedPipe: HANDLE, lpBuffer: *void, nBufferSize: DWORD, lpByesRead: *DWORD, lpTotalBytesAvail: *DWORD, lpBytesLeftThisMessage: *u32) -> BOOL #foreign kernel32;
CreateNamedPipeW :: (lpName: *u16, dwOpenMode: u32, dwPipeMode: u32, nMaxInstances: u32, nOutBufferSize: u32, nInBufferSize: u32, nDefaultTimeOut: u32, lpSecurityAttributes: *SECURITY_ATTRIBUTES) -> HANDLE #foreign kernel32;
ConnectNamedPipe :: (hNamedPipe: HANDLE, lpOverlapped: *OVERLAPPED) -> BOOL #foreign kernel32;
CreateEventA :: (lpEventAttributes: *SECURITY_ATTRIBUTES, bManualReset: s32, bInitialState: s32, lpName: *u8) -> HANDLE #foreign kernel32;
CreateEventW :: (lpEventAttributes: *SECURITY_ATTRIBUTES, bManualReset: s32, bInitialState: s32, lpName: *u16) -> HANDLE #foreign kernel32;
CreateSemaphoreA :: (lpSemaphoreAttributes: *SECURITY_ATTRIBUTES, lInitialCount: s32, lMaximumCount: s32, lpName: *u16) -> HANDLE #foreign kernel32;
CreateSemaphoreW :: (lpSemaphoreAttributes: *SECURITY_ATTRIBUTES, lInitialCount: s32, lMaximumCount: s32, lpName: *u16) -> HANDLE #foreign kernel32;
CreateWaitableTimerW :: (lpTimerAttributes: *SECURITY_ATTRIBUTES, bManualReset: BOOL, lpTimerName: *u16) -> HANDLE #foreign kernel32;
DeleteCriticalSection :: (lpCriticalSection: *CRITICAL_SECTION) #foreign kernel32;
EnterCriticalSection :: (lpCriticalSection: *CRITICAL_SECTION) #foreign kernel32;
GetOverlappedResult :: (hFile: HANDLE, lpOverlapped: *OVERLAPPED, lpNumberOfBytesTransferred: *s32, bWait: s32) -> s32 #foreign kernel32;
InitializeCriticalSection :: (lpCriticalSection: *CRITICAL_SECTION) #foreign kernel32;
LeaveCriticalSection :: (lpCriticalSection: *CRITICAL_SECTION) #foreign kernel32;
PulseEvent :: (handle: HANDLE) -> s32 #foreign kernel32;
ReleaseSemaphore :: (hSemaphore: HANDLE, lReleaseCount: s32, lpPreviousCount: *s32) -> BOOL #foreign kernel32;
SetWaitableTimer :: (hTimer: HANDLE, lpDueTime: *LARGE_INTEGER, lPeriod: s32, pfnCompletionRoutine: *void, lpArgToCompeltionRoutine: *void, fResume: BOOL) -> BOOL #foreign kernel32;
WaitForMultipleObjects :: (nCount: DWORD, lpHandles: *HANDLE, bWaitAll: BOOL, dwMilliseconds: DWORD) -> DWORD #foreign kernel32;
WaitForSingleObject :: (handle: HANDLE, milliseconds: DWORD) -> DWORD #foreign kernel32;

CONDITION_VARIABLE :: struct {
    Ptr: *void;
}

InitializeConditionVariable :: (ConditionVariable: *CONDITION_VARIABLE) #foreign kernel32;
WakeConditionVariable :: (ConditionVariable: *CONDITION_VARIABLE) #foreign kernel32;
WakeAllConditionVariable :: (ConditionVariable: *CONDITION_VARIABLE) #foreign kernel32;
SleepConditionVariableCS :: (ConditionVariable: *CONDITION_VARIABLE, CriticalSection: *CRITICAL_SECTION, dwMilliseconds: DWORD) -> BOOL #foreign kernel32;
SleepConditionVariableSRW :: (ConditionVariable: *CONDITION_VARIABLE, SRWLock: *void, dwMilliseconds: DWORD, Flags: u32) -> BOOL #foreign kernel32;
HGLOBAL :: HANDLE;
HDROP :: HANDLE;
GMEM_FIXED :: 0x0000;
GMEM_MOVEABLE :: 0x0002;
GMEM_NOCOMPACT :: 0x0010;
GMEM_NODISCARD :: 0x0020;
GMEM_ZEROINIT :: 0x0040;
GMEM_MODIFY :: 0x0080;
GMEM_DISCARDABLE :: 0x0100;
GMEM_NOT_BANKED :: 0x1000;
GMEM_SHARE :: 0x2000;
GMEM_DDESHARE :: 0x2000;
GMEM_NOTIFY :: 0x4000;
GMEM_LOWER :: GMEM_NOT_BANKED;
GMEM_VALID_FLAGS :: 0x7F72;
GMEM_INVALID_HANDLE :: 0x8000;
GHND :: (GMEM_MOVEABLE | GMEM_ZEROINIT);
GPTR :: (GMEM_FIXED | GMEM_ZEROINIT);

MEMORYSTATUSEX :: struct {
    dwLength: u32;
    dwMemoryLoad: u32;
    ullTotalPhys: u64;
    ullAvailPhys: u64;
    ullTotalPageFile: u64;
    ullAvailPageFile: u64;
    ullTotalVirtual: u64;
    ullAvailVirtual: u64;
    ullAvailExtendedVirtual: u64;
}

PAGE_NOACCESS :: 0x01;
PAGE_READONLY :: 0x02;
PAGE_READWRITE :: 0x04;
PAGE_WRITECOPY :: 0x08;
PAGE_EXECUTE :: 0x10;
PAGE_EXECUTE_READ :: 0x20;
PAGE_EXECUTE_READWRITE :: 0x40;
PAGE_EXECUTE_WRITECOPY :: 0x80;
PAGE_GUARD :: 0x100;
PAGE_NOCACHE :: 0x200;
PAGE_WRITECOMBINE :: 0x400;
PAGE_REVERT_TO_FILE_MAP :: 0x80000000;
PAGE_ENCLAVE_THREAD_CONTROL :: 0x80000000;
PAGE_TARGETS_NO_UPDATE :: 0x40000000;
PAGE_TARGETS_INVALID :: 0x40000000;
PAGE_ENCLAVE_UNVALIDATED :: 0x20000000;
MEM_COMMIT :: 0x00001000;
MEM_RESERVE :: 0x00002000;
MEM_DECOMMIT :: 0x00004000;
MEM_RELEASE :: 0x00008000;
MEM_FREE :: 0x00010000;
MEM_PRIVATE :: 0x00020000;
MEM_MAPPED :: 0x00040000;
MEM_RESET :: 0x00080000;
MEM_TOP_DOWN :: 0x00100000;
MEM_WRITE_WATCH :: 0x00200000;
MEM_PHYSICAL :: 0x00400000;
MEM_ROTATE :: 0x00800000;
MEM_DIFFERENT_IMAGE_BASE_OK :: 0x00800000;
MEM_RESET_UNDO :: 0x01000000;
MEM_LARGE_PAGES :: 0x20000000;
MEM_4MB_PAGES :: 0x80000000;
MEM_64K_PAGES :: MEM_LARGE_PAGES | MEM_PHYSICAL;
PSECURE_MEMORY_CACHE_CALLBACK :: #type (Addr: *void, Range: SIZE_T) -> BOOLEAN #c_call;
AddSecureMemoryCacheCallback :: (pfnCallBack: PSECURE_MEMORY_CACHE_CALLBACK) -> BOOL #foreign kernel32;

CreateFileMappingA :: (hFile: HANDLE,
lpFileMappingAttributes: *SECURITY_ATTRIBUTES,
flProtect: DWORD,
dwMaximumSizeHigh: DWORD,
dwMaximumSizeLow: DWORD,
lpName: LPCSTR) -> HANDLE #foreign kernel32;

CreateFileMappingW :: (hFile: HANDLE,
lpFileMappingAttributes: *SECURITY_ATTRIBUTES,
flProtect: DWORD,
dwMaximumSizeHigh: DWORD,
dwMaximumSizeLow: DWORD,
lpName: *u16) -> HANDLE #foreign kernel32;

GlobalAlloc :: (uFlags: u32, dwBytes: SIZE_T) -> HGLOBAL #foreign kernel32;
GlobalLock :: (hMem: HGLOBAL) -> *void #foreign kernel32;
GlobalMemoryStatusEx :: (lpBuffer: *MEMORYSTATUSEX) -> BOOL #foreign kernel32;
GlobalUnlock :: (hMem: HGLOBAL) -> BOOL #foreign kernel32;
LocalFree :: (hMem: HLOCAL) -> HLOCAL #foreign kernel32;

MapViewOfFile :: (hFileMappingObject: HANDLE,
dwDesiredAccess: DWORD,
dwFileOffsetHigh: DWORD,
dwFileOffsetLow: DWORD,
dwNumberOfBytesToMap: SIZE_T) -> *void #foreign kernel32;

OpenFileMappingA :: (dwDesiredAccess: DWORD,
bInheritHandle: BOOL,
lpName: LPCSTR) -> HANDLE #foreign kernel32;

OpenFileMappingW :: (dwDesiredAccess: DWORD,
bInheritHandle: BOOL,
lpName: *u16) -> HANDLE #foreign kernel32;

UnmapViewOfFile :: (address: *void) -> BOOL #foreign kernel32;
VirtualAlloc :: (lpAddress: *void, dwSize: u64, flAllocationType: u32, flProtect: u32) -> *void #foreign kernel32;
VirtualFree :: (lpAddress: *void, dwSize: u64, dwFreeType: u32) -> BOOL #foreign kernel32;
VirtualLock :: (lpAddress: *void, dwSize: u64) -> BOOL #foreign kernel32;
VirtualProtect :: (lpAddress: *void, dwSize: u64, flNewProtect: u32, lpflOldProtect: *u32) -> BOOL #foreign kernel32;
VirtualQuery :: (lpAddress: *void, lpBuffer: *MEMORY_BASIC_INFORMATION, dwLength: SIZE_T) -> SIZE_T #foreign kernel32;
CloseHandle :: (handle: HANDLE) -> s32 #foreign kernel32;
SetHandleInformation :: (hObject: HANDLE, dwMask: DWORD, dwFlags: DWORD) -> BOOL #foreign kernel32;
FreeLibrary :: (module: HMODULE) -> BOOL #foreign kernel32;
GetModuleFileNameA :: (module: HANDLE, result: *u8, size: s32) -> s32 #foreign kernel32;
GetModuleFileNameW :: (module: HANDLE, result: *u16, size: s32) -> s32 #foreign kernel32;
GetModuleHandleA :: (module_name: *u8) -> HANDLE #foreign kernel32;
GetModuleHandleW :: (module_name: *u16) -> HANDLE #foreign kernel32;
GetProcAddress :: (module: HMODULE, proc_name: *u8) -> *void #foreign kernel32;
LoadLibraryA :: (filename: *u8) -> HMODULE #foreign kernel32;
LoadLibraryW :: (filename: *u16) -> HMODULE #foreign kernel32;
LoadLibraryExA :: (filename: *u8, file: HANDLE, flags: DWORD) -> HMODULE #foreign kernel32;
LoadLibraryExW :: (filename: *u16, file: HANDLE, flags: DWORD) -> HMODULE #foreign kernel32;
DONT_RESOLVE_DLL_REFERENCES :: 0x00000001;
LOAD_IGNORE_CODE_AUTHZ_LEVEL :: 0x00000010;
LOAD_LIBRARY_AS_DATAFILE :: 0x00000002;
LOAD_LIBRARY_AS_DATAFILE_EXCLUSIVE :: 0x00000040;
LOAD_LIBRARY_AS_IMAGE_RESOURCE :: 0x00000020;
LOAD_LIBRARY_SEARCH_APPLICATION_DIR :: 0x00000200;
LOAD_LIBRARY_SEARCH_DEFAULT_DIRS :: 0x00001000;
LOAD_LIBRARY_SEARCH_DLL_LOAD_DIR :: 0x00000100;
LOAD_LIBRARY_SEARCH_SYSTEM32 :: 0x00000800;
LOAD_LIBRARY_SEARCH_USER_DIRS :: 0x00000400;
LOAD_WITH_ALTERED_SEARCH_PATH :: 0x00000008;
DLL_PROCESS_ATTACH :: 1;
DLL_THREAD_ATTACH :: 2;
DLL_THREAD_DETACH :: 3;
DLL_PROCESS_DETACH :: 0;

FILE_NOTIFY_INFORMATION :: struct {
    NextEntryOffset: s32;
    Action: s32;
    FileNameLength: s32;
    FileName: [1] s16;
}

FILE_NOTIFY_CHANGE_FILE_NAME :: 0x00000001;
FILE_NOTIFY_CHANGE_DIR_NAME :: 0x00000002;
FILE_NOTIFY_CHANGE_ATTRIBUTES :: 0x00000004;
FILE_NOTIFY_CHANGE_SIZE :: 0x00000008;
FILE_NOTIFY_CHANGE_LAST_WRITE :: 0x00000010;
FILE_NOTIFY_CHANGE_LAST_ACCESS :: 0x00000020;
FILE_NOTIFY_CHANGE_CREATION :: 0x00000040;
FILE_NOTIFY_CHANGE_EA :: 0x00000080;
FILE_NOTIFY_CHANGE_SECURITY :: 0x00000100;
FILE_NOTIFY_CHANGE_STREAM_NAME :: 0x00000200;
FILE_NOTIFY_CHANGE_STREAM_SIZE :: 0x00000400;
FILE_NOTIFY_CHANGE_STREAM_WRITE :: 0x00000800;
FILE_ACTION_ADDED :: 1;
FILE_ACTION_REMOVED :: 2;
FILE_ACTION_MODIFIED :: 3;
FILE_ACTION_RENAMED_OLD_NAME :: 4;
FILE_ACTION_RENAMED_NEW_NAME :: 5;
FILE_ACTION_ADDED_STREAM :: 6;
FILE_ACTION_REMOVED_STREAM :: 7;
FILE_ACTION_MODIFIED_STREAM :: 8;
CreateDirectoryA :: (lpPathName: *u8, lpSecurityAttributes: *SECURITY_ATTRIBUTES) -> s32 #foreign kernel32;
CreateDirectoryW :: (lpPathName: *u16, lpSecurityAttributes: *SECURITY_ATTRIBUTES) -> s32 #foreign kernel32;
GetCurrentDirectoryA :: (nBufferLength: DWORD, lpBuffer: *u8) -> DWORD #foreign kernel32;
GetCurrentDirectoryW :: (nBufferLength: DWORD, lpBuffer: *u16) -> DWORD #foreign kernel32;
ReadDirectoryChangesW :: (hDirectory: HANDLE, lpBuffer: *void, nBufferLength: s32, bWatchSubtree: s32, dwNotifyFilter: s32, lpBytesReturned: *s32, lpOverlapped: *OVERLAPPED, lpCompletionRoutine: *void) -> BOOL #foreign kernel32;
RemoveDirectoryA :: (lpPathName: *u8) -> BOOL #foreign kernel32;
RemoveDirectoryW :: (lpPathName: *u16) -> BOOL #foreign kernel32;
SetCurrentDirectoryW :: (name: *u16) -> BOOL #foreign kernel32;

CONSOLE_SCREEN_BUFFER_INFO :: struct {
    dwSize, dwCursorPosition: COORD;
    wAttributes: u16;
    srWindow: SMALL_RECT;
    dwMaximumWindowSize: COORD;
}

GetStdHandle :: (handle: s32) -> HANDLE #foreign kernel32;
GetConsoleScreenBufferInfo :: (hConsoleOutput: HANDLE, lpConsoleScreenBufferInfo: *CONSOLE_SCREEN_BUFFER_INFO) -> BOOL #foreign kernel32;
SetConsoleTextAttribute :: (hConsoleOutput: HANDLE, wAttributes: u16) -> BOOL #foreign kernel32;
GetConsoleMode :: (hConsoleHandle: HANDLE, lpMode: *DWORD) -> BOOL #foreign kernel32;
SetConsoleMode :: (hConsoleHandle: HANDLE, lpMode: DWORD) -> BOOL #foreign kernel32;
SetConsoleCP :: (wCodePageID: u32) -> BOOL #foreign kernel32;
SetConsoleOutputCP :: (wCodePageID: u32) -> BOOL #foreign kernel32;
ENABLE_VIRTUAL_TERMINAL_PROCESSING :: 0x4;
LCID :: s32;
GetUserDefaultLCID :: () -> LCID #foreign kernel32;
CF_TEXT :: 1;
CF_BITMAP :: 2;
CF_METAFILEPICT :: 3;
CF_SYLK :: 4;
CF_DIF :: 5;
CF_TIFF :: 6;
CF_OEMTEXT :: 7;
CF_DIB :: 8;
CF_PALETTE :: 9;
CF_PENDATA :: 10;
CF_RIFF :: 11;
CF_WAVE :: 12;
CF_UNICODETEXT :: 13;
CF_ENHMETAFILE :: 14;
CF_HDROP :: 15;
CF_LOCALE :: 16;
CF_DIBV5 :: 17;
CF_MAX :: 18;
CF_OWNERDISPLAY :: 0x0080;
CF_DSPTEXT :: 0x0081;
CF_DSPBITMAP :: 0x0082;
CF_DSPMETAFILEPICT :: 0x0083;
CF_DSPENHMETAFILE :: 0x008E;
CloseClipboard :: () -> BOOL #foreign user32;
EmptyClipboard :: () -> BOOL #foreign user32;
GetClipboardData :: (uFormat: u32) -> HANDLE #foreign user32;
OpenClipboard :: (hwnd: HWND) -> BOOL #foreign user32;
SetClipboardData :: (uFormat: u32, hMem: HANDLE) -> HANDLE #foreign user32;

STARTUPINFOA :: struct {
    cb: s32;
    lpReserved: *u8;
    lpDesktop: *u8;
    lpTitle: *u8;
    dwX: s32;
    dwY: s32;
    dwXSize: s32;
    dwYSize: s32;
    dwXCountChars: s32;
    dwYCountChars: s32;
    dwFillAttribute: s32;
    dwFlags: s32;
    wShowWindow: s16;
    cbReserved2: s16;
    lpReserved2: *u8;
    hStdInput: HANDLE;
    hStdOutput: HANDLE;
    hStdError: HANDLE;
}

STARTUPINFOW :: struct {
    cb: s32;
    lpReserved: *u16;
    lpDesktop: *u16;
    lpTitle: *u16;
    dwX: s32;
    dwY: s32;
    dwXSize: s32;
    dwYSize: s32;
    dwXCountChars: s32;
    dwYCountChars: s32;
    dwFillAttribute: s32;
    dwFlags: s32;
    wShowWindow: s16;
    cbReserved2: s16;
    lpReserved2: *u8;
    hStdInput: HANDLE;
    hStdOutput: HANDLE;
    hStdError: HANDLE;
}

STARTF_USESTDHANDLES :: 0x00000100;

PROCESS_INFORMATION :: struct {
    hProcess: HANDLE;
    hThread: HANDLE;
    dwProcessId: u32;
    dwThreadId: u32;
}

using Creation_Flags :: enum_flags u32 {
    DEBUG_PROCESS :: 0x00000001;
    DEBUG_ONLY_THIS_PROCESS :: 0x00000002;
    CREATE_SUSPENDED :: 0x00000004;
    DETACHED_PROCESS :: 0x00000008;
    CREATE_NEW_CONSOLE :: 0x00000010;
    NORMAL_PRIORITY_CLASS :: 0x00000020;
    IDLE_PRIORITY_CLASS :: 0x00000040;
    HIGH_PRIORITY_CLASS :: 0x00000080;
    REALTIME_PRIORITY_CLASS :: 0x00000100;
    CREATE_NEW_PROCESS_GROUP :: 0x00000200;
    CREATE_UNICODE_ENVIRONMENT :: 0x00000400;
    CREATE_SEPARATE_WOW_VDM :: 0x00000800;
    CREATE_SHARED_WOW_VDM :: 0x00001000;
    CREATE_FORCEDOS :: 0x00002000;
    BELOW_NORMAL_PRIORITY_CLASS :: 0x00004000;
    ABOVE_NORMAL_PRIORITY_CLASS :: 0x00008000;
    INHERIT_PARENT_AFFINITY :: 0x00010000;
    INHERIT_CALLER_PRIORITY :: 0x00020000;
    CREATE_PROTECTED_PROCESS :: 0x00040000;
    EXTENDED_STARTUPINFO_PRESENT :: 0x00080000;
    PROCESS_MODE_BACKGROUND_BEGIN :: 0x00100000;
    PROCESS_MODE_BACKGROUND_END :: 0x00200000;
    CREATE_SECURE_PROCESS :: 0x00400000;
    CREATE_BREAKAWAY_FROM_JOB :: 0x01000000;
    CREATE_PRESERVE_CODE_AUTHZ_LEVEL :: 0x02000000;
    CREATE_DEFAULT_ERROR_MODE :: 0x04000000;
    CREATE_NO_WINDOW :: 0x08000000;
    PROFILE_USER :: 0x10000000;
    PROFILE_KERNEL :: 0x20000000;
    PROFILE_SERVER :: 0x40000000;
    CREATE_IGNORE_SYSTEM_DEFAULT :: 0x80000000;
}

WAIT_FAILED :: 0xFFFFFFFF;
WIN_TIMEOUT_INFINITE :: 0xFFFFFFFF;
THREAD_PRIORITY_NORMAL :: 0;
THREAD_PRIORITY_ABOVE_NORMAL :: 1;
THREAD_PRIORITY_HIGHEST :: 2;

JOBOBJECTINFOCLASS :: enum {
    BasicAccountingInformation :: 1;
    BasicLimitInformation;
    BasicProcessIdList;
    BasicUIRestrictions;
    SecurityLimitInformation;
    EndOfJobTimeInformation;
    AssociateCompletionPortInformation;
    BasicAndIoAccountingInformation;
    ExtendedLimitInformation;
    JobSetInformation;
    GroupInformation;
    NotificationLimitInformation;
    LimitViolationInformation;
    GroupInformationEx;
    CpuRateControlInformation;
    CompletionFilter;
    CompletionCounter;
    Reserved1Information :: 18;
    Reserved2Information;
    Reserved3Information;
    Reserved4Information;
    Reserved5Information;
    Reserved6Information;
    Reserved7Information;
    Reserved8Information;
    Reserved9Information;
    Reserved10Information;
    Reserved11Information;
    Reserved12Information;
    Reserved13Information;
    Reserved14Information :: 31;
    NetRateControlInformation;
    NotificationLimitInformation2;
    LimitViolationInformation2;
    CreateSilo;
    SiloBasicInformation;
    Reserved15Information :: 37;
    Reserved16Information :: 38;
    Reserved17Information :: 39;
    Reserved18Information :: 40;
    Reserved19Information :: 41;
    Reserved20Information :: 42;
    Reserved21Information :: 43;
    Reserved22Information :: 44;
    Reserved23Information :: 45;
    Reserved24Information :: 46;
    Reserved25Information :: 47;
    MaxJobObjectInfoClass;
}

using Job_Object_Limit :: enum u32 {
    JOB_OBJECT_LIMIT_WORKINGSET :: 0x00000001;
    JOB_OBJECT_LIMIT_PROCESS_TIME :: 0x00000002;
    JOB_OBJECT_LIMIT_JOB_TIME :: 0x00000004;
    JOB_OBJECT_LIMIT_ACTIVE_PROCESS :: 0x00000008;
    JOB_OBJECT_LIMIT_AFFINITY :: 0x00000010;
    JOB_OBJECT_LIMIT_PRIORITY_CLASS :: 0x00000020;
    JOB_OBJECT_LIMIT_PRESERVE_JOB_TIME :: 0x00000040;
    JOB_OBJECT_LIMIT_SCHEDULING_CLASS :: 0x00000080;
    JOB_OBJECT_LIMIT_PROCESS_MEMORY :: 0x00000100;
    JOB_OBJECT_LIMIT_JOB_MEMORY :: 0x00000200;
    JOB_OBJECT_LIMIT_JOB_MEMORY_HIGH :: JOB_OBJECT_LIMIT_JOB_MEMORY;
    JOB_OBJECT_LIMIT_DIE_ON_UNHANDLED_EXCEPTION :: 0x00000400;
    JOB_OBJECT_LIMIT_BREAKAWAY_OK :: 0x00000800;
    JOB_OBJECT_LIMIT_SILENT_BREAKAWAY_OK :: 0x00001000;
    JOB_OBJECT_LIMIT_KILL_ON_JOB_CLOSE :: 0x00002000;
    JOB_OBJECT_LIMIT_SUBSET_AFFINITY :: 0x00004000;
    JOB_OBJECT_LIMIT_JOB_MEMORY_LOW :: 0x00008000;
    JOB_OBJECT_LIMIT_JOB_READ_BYTES :: 0x00010000;
    JOB_OBJECT_LIMIT_JOB_WRITE_BYTES :: 0x00020000;
    JOB_OBJECT_LIMIT_RATE_CONTROL :: 0x00040000;
    JOB_OBJECT_LIMIT_CPU_RATE_CONTROL :: JOB_OBJECT_LIMIT_RATE_CONTROL;
    JOB_OBJECT_LIMIT_IO_RATE_CONTROL :: 0x00080000;
    JOB_OBJECT_LIMIT_NET_RATE_CONTROL :: 0x00100000;
}

JOBOBJECT_BASIC_LIMIT_INFORMATION :: struct {
    PerProcessUserTimeLimit: u64;
    PerJobUserTimeLimit: u64;
    LimitFlags: Job_Object_Limit;
    MinimumWorkingSetSize: SIZE_T;
    MaximumWorkingSetSize: SIZE_T;
    ActiveProcessLimit: u32;
    Affinity: *u32;
    PriorityClass: u32;
    SchedulingClass: u32;
}

IO_COUNTERS :: struct {
    ReadOperationCount: u64;
    WriteOperationCount: u64;
    OtherOperationCount: u64;
    ReadTransferCount: u64;
    WriteTransferCount: u64;
    OtherTransferCount: u64;
}

JOBOBJECT_EXTENDED_LIMIT_INFORMATION :: struct {
    BasicLimitInformation: JOBOBJECT_BASIC_LIMIT_INFORMATION;
    IoInfo: IO_COUNTERS;
    ProcessMemoryLimit: SIZE_T;
    JobMemoryLimit: SIZE_T;
    PeakProcessMemoryUsed: SIZE_T;
    PeakJobMemoryUsed: SIZE_T;
}

AssignProcessToJobObject :: (hJob: HANDLE, hProcess: HANDLE) -> BOOL #foreign kernel32;
CreateJobObjectA :: (lpSecurityAttributes: *SECURITY_ATTRIBUTES, name: *u8) -> HANDLE #foreign kernel32;

CreateProcessA :: (lpApplicationName: *u8, lpCommandLine: *u8,
lpSecurityAttributes: *SECURITY_ATTRIBUTES, lpThreadAttributes: *SECURITY_ATTRIBUTES,
bInheritHandles: BOOL, dwCreationFlags: Creation_Flags, lpEnvironment: *void,
lpCurrentDirectory: *u8,
lpStartupInfo: *STARTUPINFOA, lpProcessInformation: *PROCESS_INFORMATION) -> BOOL #foreign kernel32;

CreateProcessW :: (lpApplicationName: *u16, lpCommandLine: *u16,
lpSecurityAttributes: *SECURITY_ATTRIBUTES, lpThreadAttributes: *SECURITY_ATTRIBUTES,
bInheritHandles: BOOL, dwCreationFlags: Creation_Flags, lpEnvironment: *void,
lpCurrentDirectory: *u16,
lpStartupInfo: *STARTUPINFOW, lpProcessInformation: *PROCESS_INFORMATION) -> BOOL #foreign kernel32;

GetExitCodeProcess :: (hProcess: HANDLE, lpExitCode: *u32) -> s32 #foreign kernel32;
CreateThread :: (threadAttributes: *void, stackSize: s64, startAddress: *void, parameter: *void, creation_flags: Creation_Flags, threadIdReturn: *s32) -> HANDLE #foreign kernel32;
ExitProcess :: (exit_code: u32) -> void #foreign kernel32;
GetCurrentProcess :: () -> HANDLE #foreign kernel32;
GetCurrentProcessId :: () -> u32 #foreign kernel32;
GetCurrentThread :: () -> HANDLE #foreign kernel32;
GetCurrentThreadId :: () -> DWORD #foreign kernel32;
GetProcessId :: (Process: HANDLE) -> DWORD #foreign kernel32;
GetProcessWorkingSetSize :: (hProcess: HANDLE, lpMinimumWorkingSetSize: *SIZE_T, lpMaximumWorkingSetSize: *SIZE_T) -> BOOL #foreign kernel32;
GetThreadId :: (Thread: HANDLE) -> DWORD #foreign kernel32;
OpenThread :: (dwDesiredAccess: u32, bInheritHandle: BOOL, dwThreadId: u32) -> HANDLE #foreign kernel32;
ResumeThread :: (thread: HANDLE) -> s32 #foreign kernel32;
SetInformationJobObject :: (hJob: HANDLE, JobOjectInformationClass: JOBOBJECTINFOCLASS, lpJobObjectInformation: *void, cbJobObjectInformationLength: u32) -> BOOL #foreign kernel32;
SetThreadPriority :: (thread: HANDLE, priority: s32) -> s32 #foreign kernel32;
Sleep :: (milliseconds: s32) -> void #foreign kernel32;
SuspendThread :: (hThread: HANDLE) -> BOOL #foreign kernel32;
TerminateProcess :: (hProcess: HANDLE, uExitCode: u32) -> BOOL #foreign kernel32;
DebugActiveProcess :: (dwProcessId: u32) -> BOOL #foreign kernel32;
DebugBreak :: () #foreign kernel32;
GetThreadContext :: (hThread: HANDLE, lpContext: *CONTEXT) -> BOOL #foreign kernel32;
IsDebuggerPresent :: () -> BOOL #foreign kernel32;
OutputDebugStringA :: (s: *u8) -> void #foreign kernel32;
OutputDebugStringW :: (s: *u16) -> void #foreign kernel32;
MMSYSERR_BASE :: 0;
WAVERR_BASE :: 32;
MIDIERR_BASE :: 64;
TIMERR_BASE :: 96;
JOYERR_BASE :: 160;
MCIERR_BASE :: 256;
MIXERR_BASE :: 1024;
TIMERR_NOERROR :: 0;
TIMERR_NOCANDO :: TIMERR_BASE + 1;
TIMERR_STRUCT :: TIMERR_BASE + 33;
MMSYSERR_NOERROR :: 0;
MMSYSERR_ERROR :: MMSYSERR_BASE + 1;

TIMECAPS :: struct {
    wPeriodMin: u32;
    wPeriodMax: u32;
}

MMTIME :: struct {
    wType: u32;
    u: union {
        ms: u32;
        sample: u32;
        cb: u32;
        ticks: u32;
        smpte: struct {
            hour: u8;
            min: u8;
            sec: u8;
            frame: u8;
            fps: u8;
            dummy: u8;
            pad: [2] u8;
        };
        midi: struct {
            songptrpos: u32;
        };
    };
}

timeGetDevCaps :: (ptc: *TIMECAPS, cbtc: u32) -> u32 #foreign winmm;
timeBeginPeriod :: (period: u32) -> u32 #foreign winmm;
timeEndPeriod :: (period: u32) -> u32 #foreign winmm;
timeGetTime :: () -> u32 #foreign winmm;
timeGetSystemTime :: (pmmt: *MMTIME, cbmmt: u32) -> u32 #foreign winmm;
MB_OK :: 0x00000000;
MB_OKCANCEL :: 0x00000001;
MB_ABORTRETRYIGNORE :: 0x00000002;
MB_YESNOCANCEL :: 0x00000003;
MB_YESNO :: 0x00000004;
MB_RETRYCANCEL :: 0x00000005;
MB_CANCELTRYCONTINUE :: 0x00000006;
MB_ICONHAND :: 0x00000010;
MB_ICONQUESTION :: 0x00000020;
MB_ICONEXCLAMATION :: 0x00000030;
MB_ICONASTERISK :: 0x00000040;
MB_USERICON :: 0x00000080;
MB_ICONWARNING :: MB_ICONEXCLAMATION;
MB_ICONERROR :: MB_ICONHAND;
MB_ICONINFORMATION :: MB_ICONASTERISK;
MB_ICONSTOP :: MB_ICONHAND;
MB_DEFBUTTON1 :: 0x00000000;
MB_DEFBUTTON2 :: 0x00000100;
MB_DEFBUTTON3 :: 0x00000200;
MB_DEFBUTTON4 :: 0x00000300;
MB_APPLMODAL :: 0x00000000;
MB_SYSTEMMODAL :: 0x00001000;
MB_TASKMODAL :: 0x00002000;
MB_HELP :: 0x00004000;
MB_NOFOCUS :: 0x00008000;
MB_SETFOREGROUND :: 0x00010000;
MB_DEFAULT_DESKTOP_ONLY :: 0x00020000;
MB_TOPMOST :: 0x00040000;
MB_RIGHT :: 0x00080000;
MB_RTLREADING :: 0x00100000;
MB_SERVICE_NOTIFICATION :: 0x00200000;
MB_TYPEMASK :: 0x0000000F;
MB_ICONMASK :: 0x000000F0;
MB_DEFMASK :: 0x00000F00;
MB_MODEMASK :: 0x00003000;
MB_MISCMASK :: 0x0000C000;
IDOK :: 1;
IDCANCEL :: 2;
IDABORT :: 3;
IDRETRY :: 4;
IDIGNORE :: 5;
IDYES :: 6;
IDNO :: 7;
IDCLOSE :: 8;
IDHELP :: 9;
IDTRYAGAIN :: 10;
IDCONTINUE :: 11;
MessageBoxA :: (hWnd: HWND, lpText: *u8, lpCaption: *u8, uType: u32) -> s32 #foreign user32;
MessageBoxW :: (hWnd: HWND, lpText: *u16, lpCaption: *u16, uType: u32) -> s32 #foreign user32;
LARGE_INTEGER_S64 :: s64;
INVALID_FILE_ATTRIBUTES: u32 : 0xffff_ffff;

WIN32_FIND_DATAW :: struct {
    dwFileAttributes: s32;
    ftCreationTime: FILETIME;
    ftLastAccessTime: FILETIME;
    ftLastWriteTime: FILETIME;
    nFileSizeHigh: DWORD;
    nFileSizeLow: DWORD;
    dwReserved0: DWORD;
    dwReserved1: DWORD;
    cFileName: [MAX_PATH] u16;
    cAlternateFileName: [14] u16;
}

FILE_GENERIC_ALL :: 0x10000000;
FILE_GENERIC_READ :: 0x80000000;
FILE_GENERIC_WRITE :: 0x40000000;
FILE_GENERIC_EXECUTE :: 0x20000000;
FILE_LIST_DIRECTORY :: 0x1;
FILE_EXECUTE :: 0x20;
FILE_READ_ATTRIBUTES :: 0x80;
FILE_READ_DATA :: 0x1;
FILE_TRAVERSE :: 0x20;

using SetFilePointer_MoveMethod :: enum u32 {
    FILE_BEGIN :: 0;
    FILE_CURRENT :: 1;
    FILE_END :: 2;
}

using FINDEX_INFO_LEVELS :: enum {
    FindExInfoStandard;
    FindExInfoBasic;
    FindExInfoMaxInfoLevel;
}

using FINDEX_SEARCH_OPS :: enum {
    FindExSearchNameMatch;
    FindExSearchLimitToDirectories;
    FindExSearchLimitToDevices;
    FindExSearchMaxSearchOp;
}

FIND_FIRST_EX_CASE_SENSITIVE :: 0x1;
FIND_FIRST_EX_LARGE_FETCH :: 0x2;
FIND_FIRST_EX_ON_DISK_ENTRIES_ONLY :: 0x4;
CancelIo :: (hFile: HANDLE) -> BOOL #foreign kernel32;
CopyFileW :: (lpFileName: *u16, lpNewFileName: *u16, bFailIfExists: BOOL) -> BOOL #foreign kernel32;
CopyFileA :: (lpFileName: *u8, lpNewFileName: *u8, bFailIfExists: BOOL) -> BOOL #foreign kernel32;
CreateFileA :: (filename: *u8, desired_access: u32, share_mode: u32 = FILE_SHARE_READ, security: *void = null, creation: u32 = OPEN_EXISTING, flags_and_attributes: u32 = 0, hTemplateFile: HANDLE = null) -> HANDLE #foreign kernel32;
CreateFileW :: (filename: *u16, desired_access: u32, share_mode: u32 = FILE_SHARE_READ, security: *void = null, creation: u32 = OPEN_EXISTING, flags_and_attributes: u32 = 0, hTemplateFile: HANDLE = null) -> HANDLE #foreign kernel32;
CreateHardLinkA :: (lpFileName: *u8, lpExistingFileName: *u8, lpSecurityAttributes: *SECURITY_ATTRIBUTES) -> BOOL #foreign kernel32;
CreateHardLinkW :: (lpFileName: *u16, lpExistingFileName: *u16, lpSecurityAttributes: *SECURITY_ATTRIBUTES) -> BOOL #foreign kernel32;
CreateIoCompletionPort :: (FileHandle: HANDLE, ExistingCompletionPort: HANDLE, CompletionKey: u64, NumberOfConcurrentThreads: u32) -> HANDLE #foreign kernel32;
DeleteFileA :: (filename: *u8) -> BOOL #foreign kernel32;
DeleteFileW :: (filename: *u16) -> BOOL #foreign kernel32;
FindClose :: (file: HANDLE) -> BOOL #foreign kernel32;
FindFirstFileA :: (lpFileName: *u8, lpFindFileData: *void) -> HANDLE #foreign kernel32;
FindFirstFileW :: (lpFileName: *u16, lpFindFileData: *WIN32_FIND_DATAW) -> HANDLE #foreign kernel32;
FindFirstFileExA :: (lpFileName: *u8, fInfoLevelId: FINDEX_INFO_LEVELS, lpFindFileData: *void, fSearchOp: FINDEX_SEARCH_OPS, lpSearchFilter: *void, dwAdditionalFlags: DWORD) -> HANDLE #foreign kernel32;
FindFirstFileExW :: (lpFileName: *u16, fInfoLevelId: FINDEX_INFO_LEVELS, lpFindFileData: *void, fSearchOp: FINDEX_SEARCH_OPS, lpSearchFilter: *void, dwAdditionalFlags: DWORD) -> HANDLE #foreign kernel32;
FindNextFileA :: (hFile: HANDLE, lpFindFileData: *void) -> BOOL #foreign kernel32;
FindNextFileW :: (hFile: HANDLE, lpFindFileData: *WIN32_FIND_DATAW) -> BOOL #foreign kernel32;
FlushFileBuffers :: (hFile: HANDLE) -> BOOL #foreign kernel32;
GetFileAttributesA :: (lpFileName: *u8) -> u32 #foreign kernel32;
GetFileAttributesW :: (lpFileName: *u16) -> u32 #foreign kernel32;
GetFileInformationByHandleEx :: (hFile: HANDLE, FileInformationClass: FILE_INFO_BY_HANDLE_CLASS, lpFileInformation: *void, dwBufferSize: u32) -> BOOL #foreign kernel32;
GetFileSize :: (file: HANDLE, FileSizeHigh: *u32) -> u32 #foreign kernel32;
GetFileSizeEx :: (file: HANDLE, size: *LARGE_INTEGER) -> s32 #foreign kernel32;
GetFullPathNameA :: (filename: *u8, buffer_length: DWORD, buffer: *u8, file_part: **u8) -> DWORD #foreign kernel32;
GetFullPathNameW :: (filename: *u16, buffer_length: DWORD, buffer: *u16, file_part: **u16) -> DWORD #foreign kernel32;
GetQueuedCompletionStatus :: (CompletionPort: HANDLE, NumberOfBytesTransferred: *u32, CompletionKey: *u64, Overlapped: **OVERLAPPED, Milliseconds: u32) -> BOOL #foreign kernel32;
LockFile :: (file: HANDLE, dwFileOffsetLow: DWORD, dwFileOffsetHigh: DWORD, nNumberOfBytesToLockLow: DWORD, nNumberOfBytesToLockHigh: DWORD) -> BOOL #foreign kernel32;
LockFileEx :: (file: HANDLE, dwFlags: DWORD, dwReserved: DWORD, nNumberOfBytesToLockLow: DWORD, nNumberOfBytesToLockHigh: DWORD, lpOverlapped: *OVERLAPPED) -> BOOL #foreign kernel32;
MoveFileA :: (filename: *u8, new_filename: *u8) -> BOOL #foreign kernel32;
MoveFileW :: (filename: *u16, new_filename: *u16) -> BOOL #foreign kernel32;
MoveFileExW :: (filename: *u16, new_filename: *u16, flags: DWORD) -> BOOL #foreign kernel32;
ReadFile :: (file: HANDLE, buffer: *void, to_read: DWORD, did_read: *DWORD, overlapped: *void = null) -> BOOL #foreign kernel32;
ReplaceFileW :: (lpReplacedFileName: LPCWSTR, lpReplacementFileName: LPCWSTR, lpBackupFileName: LPCWSTR, dwReplaceFlags: DWORD, lpExclude: *void, lpReserved: *void) -> BOOL #foreign kernel32;

using FILE_INFO_BY_HANDLE_CLASS :: enum {
    FileBasicInfo;
    FileStandardInfo;
    FileNameInfo;
    FileRenameInfo;
    FileDispositionInfo;
    FileAllocationInfo;
    FileEndOfFileInfo;
    FileStreamInfo;
    FileCompressionInfo;
    FileAttributeTagInfo;
    FileIdBothDirectoryInfo;
    FileIdBothDirectoryRestartInfo;
    FileIoPriorityHintInfo;
    FileRemoteProtocolInfo;
    FileFullDirectoryInfo;
    FileFullDirectoryRestartInfo;
    FileStorageInfo;
    FileAlignmentInfo;
    FileIdInfo;
    FileIdExtdDirectoryInfo;
    FileIdExtdDirectoryRestartInfo;
    FileDispositionInfoEx;
    FileRenameInfoEx;
    FileCaseSensitiveInfo;
    FileNormalizedNameInfo;
    MaximumFileInfoByHandleClass;
}

FILE_STANDARD_INFO :: struct {
    AllocationSize: LARGE_INTEGER;
    EndOfFile: LARGE_INTEGER;
    NumberOfLinks: u32;
    DeletePending: BOOLEAN;
    Directory: BOOLEAN;
}

FILE_END_OF_FILE_INFO :: struct {
    EndOfFile: LARGE_INTEGER;
}

FILE_FULL_DIR_INFO :: struct {
    NextEntryOffset: u32;
    FileIndex: u32;
    CreationTime: LARGE_INTEGER;
    LastAccessTime: LARGE_INTEGER;
    LastWriteTime: LARGE_INTEGER;
    ChangeTime: LARGE_INTEGER;
    EndOfFile: LARGE_INTEGER;
    AllocationSize: LARGE_INTEGER;
    FileAttributes: u32;
    FileNameLength: u32;
    EaSize: u32;
    FileName: [1] u16;
}

SetFileInformationByHandle :: (File: HANDLE, FileInformationClass: FILE_INFO_BY_HANDLE_CLASS, FileInformation: *void, BufferSize: u32) -> BOOL #foreign kernel32;
SetFilePointer :: (hFile: HANDLE, liDistanceToMove: s32, lpNewFilePointer: *s32, dwMoveMethod: SetFilePointer_MoveMethod) -> u32 #foreign kernel32;
SetFilePointerEx :: (hFile: HANDLE, liDistanceToMove: LARGE_INTEGER_S64, lpNewFilePointer: *LARGE_INTEGER_S64, dwMoveMethod: SetFilePointer_MoveMethod) -> BOOL #foreign kernel32;
WriteFile :: (handle: HANDLE, buffer: *void, buffer_length: DWORD, written_result: *DWORD, overlapped: *void) -> BOOL #foreign kernel32;
DwmIsCompositionEnabled :: (pfEnabled: *BOOL) -> HRESULT #foreign Dwmapi;

IMAGE_FILE_MACHINE :: enum u32 {
    I386 :: 0x014c;
    IA64 :: 0x0200;
    AMD64 :: 0x8664;
}

ADDRESS_MODE :: enum s32 {
    AddrMode1616 :: 0;
    AddrMode1632 :: 1;
    AddrModeReal :: 2;
    AddrModeFlat :: 3;
}

ADDRESS64 :: struct {
    Offset: u64;
    Segment: u16;
    Mode: ADDRESS_MODE;
}

KDHELP64 :: struct {
    Thread: u64;
    ThCallbackStack: u32;
    ThCallbackBStore: u32;
    NextCallback: u32;
    FramePointer: u32;
    KiCallUserMode: u64;
    KeUserCallbackDispatcher: u64;
    SystemRangeStart: u64;
    KiUserExceptionDispatcher: u64;
    StackBase: u64;
    StackLimit: u64;
    Reserved: [5] u64;
}

STACKFRAME64 :: struct {
    AddrPC: ADDRESS64;
    AddrReturn: ADDRESS64;
    AddrFrame: ADDRESS64;
    AddrStack: ADDRESS64;
    AddrBStore: ADDRESS64;
    FuncTableEntry: *void;
    Params: [4] u64;
    Far: BOOL;
    Virtual: BOOL;
    Reserved: [3] u64;
    KdHelp: KDHELP64;
}

// The SDK aligns 128-bit register images (and so XSAVE_FORMAT and CONTEXT) to 16 bytes;
// GetThreadContext rejects a CONTEXT that is not.
M128A :: struct {
    Low: u64 #align 16;
    High: s64;
}

XSAVE_FORMAT :: struct {
    ControlWord: u16;
    StatusWord: u16;
    TagWord: u8;
    Reserved1: u8;
    ErrorOpcode: u16;
    ErrorOffset: u32;
    ErrorSelector: u16;
    Reserved2: u16;
    DataOffset: u32;
    DataSelector: u16;
    Reserved3: u16;
    MxCsr: u32;
    MxCsr_Mask: u32;
    FloatRegisters: [8] M128A;
    #if 1 {
        XmmRegisters: [16] M128A;
        Reserved4: [96] u8;
    } else {
        XmmRegisters: [8] M128A;
        Reserved4: [224] u8;
    }
}

// Thread contexts are per CPU; there is no default for another one.
#if CPU == .X64 {
    CONTEXT_i386 :: 0x00010000;
    CONTEXT_AMD64 :: 0x00100000;
    CONTEXT_CONTROL :: (CONTEXT_AMD64 | 0x00000001);
    CONTEXT_INTEGER :: (CONTEXT_AMD64 | 0x00000002);
    CONTEXT_SEGMENTS :: (CONTEXT_AMD64 | 0x00000004);
    CONTEXT_FLOATING_POINT :: (CONTEXT_AMD64 | 0x00000008);
    CONTEXT_DEBUG_REGISTERS :: (CONTEXT_AMD64 | 0x00000010);
    CONTEXT_FULL :: (CONTEXT_CONTROL | CONTEXT_INTEGER | CONTEXT_FLOATING_POINT);

    CONTEXT :: struct #type_info_none {
        P1Home: u64;
        P2Home: u64;
        P3Home: u64;
        P4Home: u64;
        P5Home: u64;
        P6Home: u64;
        ContextFlags: u32;
        MxCsr: u32;
        SegCs: u16;
        SegDs: u16;
        SegEs: u16;
        SegFs: u16;
        SegGs: u16;
        SegSs: u16;
        EFlags: u32;
        Dr0: u64;
        Dr1: u64;
        Dr2: u64;
        Dr3: u64;
        Dr6: u64;
        Dr7: u64;
        Rax: u64;
        Rcx: u64;
        Rdx: u64;
        Rbx: u64;
        Rsp: u64;
        Rbp: u64;
        Rsi: u64;
        Rdi: u64;
        R8: u64;
        R9: u64;
        R10: u64;
        R11: u64;
        R12: u64;
        R13: u64;
        R14: u64;
        R15: u64;
        Rip: u64;
        union {
            FltSave: XSAVE_FORMAT;
            struct {
                Header: [2] M128A;
                Legacy: [8] M128A;
                Xmm0: M128A;
                Xmm1: M128A;
                Xmm2: M128A;
                Xmm3: M128A;
                Xmm4: M128A;
                Xmm5: M128A;
                Xmm6: M128A;
                Xmm7: M128A;
                Xmm8: M128A;
                Xmm9: M128A;
                Xmm10: M128A;
                Xmm11: M128A;
                Xmm12: M128A;
                Xmm13: M128A;
                Xmm14: M128A;
                Xmm15: M128A;
            }
        }
        VectorRegister: [26] M128A;
        VectorControl: u64;
        DebugControl: u64;
        LastBranchToRip: u64;
        LastBranchFromRip: u64;
        LastExceptionToRip: u64;
        LastExceptionFromRip: u64;
    }

    #assert(size_of(CONTEXT) == 1232);
} else #if CPU == .ARM64 {
    // The arm64 register snapshot (winnt.h's ARM64_NT_CONTEXT): what GetThreadContext,
    // RtlCaptureContext and an exception's ContextRecord hold on Windows on Arm.
    CONTEXT_ARM64 :: 0x00400000;
    CONTEXT_CONTROL :: CONTEXT_ARM64 | 0x1;
    CONTEXT_INTEGER :: CONTEXT_ARM64 | 0x2;
    CONTEXT_FLOATING_POINT :: CONTEXT_ARM64 | 0x4;
    CONTEXT_DEBUG_REGISTERS :: CONTEXT_ARM64 | 0x8;
    CONTEXT_FULL :: CONTEXT_CONTROL | CONTEXT_INTEGER | CONTEXT_FLOATING_POINT;

    CONTEXT :: struct #type_info_none {
        ContextFlags: u32;
        Cpsr: u32;
        // x0-x28, then the frame pointer (x29) and link register (x30).
        X: [29] u64;
        Fp: u64;
        Lr: u64;
        Sp: u64;
        Pc: u64;
        V: [32] M128A #align 16;
        Fpcr: u32;
        Fpsr: u32;
        Bcr: [8] u32;
        Bvr: [8] u64;
        Wcr: [2] u32;
        Wvr: [2] u64;
    }

    #assert(size_of(CONTEXT) == 912);
} else {
    #assert false "Windows CONTEXT is declared for X64 and ARM64 only";
}

IMAGEHLP_SYMBOL64 :: struct {
    SizeOfStruct: u32;
    Address: u64;
    Size: u32;
    Flags: u32;
    MaxNameLength: u32;
    Name: [1] u8;
}

IMAGEHLP_LINE64 :: struct {
    SizeOfStruct: u32;
    Key: *void;
    LineNumber: u32;
    FileName: *u8;
    Address: u64;
}

IMAGEHLP_LINEW64 :: struct {
    SizeOfStruct: u32;
    Key: *void;
    LineNumber: u32;
    FileName: *u16;
    Address: u64;
}

SYMBOL_INFO :: struct {
    SizeOfStruct: u32;
    TypeIndex: u32;
    Reserved: [2] u64;
    Index: u32;
    Size: u32;
    ModBase: u64;
    Flags: u32;
    Value: u64;
    Address: u64;
    Register: u32;
    Scope: u32;
    Tag: u32;
    NameLen: u32;
    MaxNameLen: u32;
    Name: [1] u8;
}

SYMOPT :: enum_flags u32 {
    CASE_INSENSITIVE :: 0x00000001;
    UNDNAME :: 0x00000002;
    DEFERRED_LOADS :: 0x00000004;
    NO_CPP :: 0x00000008;
    LOAD_LINES :: 0x00000010;
    OMAP_FIND_NEAREST :: 0x00000020;
    LOAD_ANYTHING :: 0x00000040;
    IGNORE_CVREC :: 0x00000080;
    NO_UNQUALIFIED_LOADS :: 0x00000100;
    FAIL_CRITICAL_ERRORS :: 0x00000200;
    EXACT_SYMBOLS :: 0x00000400;
    ALLOW_ABSOLUTE_SYMBOLS :: 0x00000800;
    IGNORE_NT_SYMPATH :: 0x00001000;
    INCLUDE_32BIT_MODULES :: 0x00002000;
    PUBLICS_ONLY :: 0x00004000;
    NO_PUBLICS :: 0x00008000;
    AUTO_PUBLICS :: 0x00010000;
    NO_IMAGE_SEARCH :: 0x00020000;
    SECURE :: 0x00040000;
    NO_PROMPTS :: 0x00080000;
    OVERWRITE :: 0x00100000;
    IGNORE_IMAGEDIR :: 0x00200000;
    FLAT_DIRECTORY :: 0x00400000;
    FAVOR_COMPRESSED :: 0x00800000;
    ALLOW_ZERO_ADDRESS :: 0x01000000;
    DISABLE_SYMSRV_AUTODETECT :: 0x02000000;
    READONLY_CACHE :: 0x04000000;
    SYMPATH_LAST :: 0x08000000;
    DISABLE_FAST_SYMBOLS :: 0x10000000;
    DISABLE_SYMSRV_TIMEOUT :: 0x20000000;
    DISABLE_SRVSTAR_ON_STARTUP :: 0x40000000;
    DEBUG :: 0x80000000;
}

STATUS_ACCESS_VIOLATION :: 0x80000005;
EXCEPTION_WRITE_FAULT :: 1;

MINIDUMP_TYPE :: enum_flags u32 {
    MiniDumpNormal :: 0x00000000;
    MiniDumpWithDataSegs :: 0x00000001;
    MiniDumpWithFullMemory :: 0x00000002;
    MiniDumpWithHandleData :: 0x00000004;
    MiniDumpFilterMemory :: 0x00000008;
    MiniDumpScanMemory :: 0x00000010;
    MiniDumpWithUnloadedModules :: 0x00000020;
    MiniDumpWithIndirectlyReferencedMemory :: 0x00000040;
    MiniDumpFilterModulePaths :: 0x00000080;
    MiniDumpWithProcessThreadData :: 0x00000100;
    MiniDumpWithPrivateReadWriteMemory :: 0x00000200;
    MiniDumpWithoutOptionalData :: 0x00000400;
    MiniDumpWithFullMemoryInfo :: 0x00000800;
    MiniDumpWithThreadInfo :: 0x00001000;
    MiniDumpWithCodeSegs :: 0x00002000;
    MiniDumpWithoutAuxiliaryState :: 0x00004000;
    MiniDumpWithFullAuxiliaryState :: 0x00008000;
    MiniDumpWithPrivateWriteCopyMemory :: 0x00010000;
    MiniDumpIgnoreInaccessibleMemory :: 0x00020000;
    MiniDumpWithTokenInformation :: 0x00040000;
    MiniDumpWithModuleHeaders :: 0x00080000;
    MiniDumpFilterTriage :: 0x00100000;
    MiniDumpWithAvxXStateContext :: 0x00200000;
    MiniDumpWithIptTrace :: 0x00400000;
    MiniDumpScanInaccessiblePartialPages :: 0x00800000;
    MiniDumpFilterWriteCombinedMemory :: 0x01000000;
    MiniDumpValidTypeFlags :: 0x01ffffff;
}

MINIDUMP_CALLBACK_TYPE :: enum u32 {
    ModuleCallback;
    ThreadCallback;
    ThreadExCallback;
    IncludeThreadCallback;
    IncludeModuleCallback;
    MemoryCallback;
    CancelCallback;
    WriteKernelMinidumpCallback;
    KernelMinidumpStatusCallback;
    RemoveMemoryCallback;
    IncludeVmRegionCallback;
    IoStartCallback;
    IoWriteAllCallback;
    IoFinishCallback;
    ReadMemoryFailureCallback;
    SecondaryFlagsCallback;
    IsProcessSnapshotCallback;
    VmStartCallback;
    VmQueryCallback;
    VmPreReadCallback;
    VmPostReadCallback;
}

MINIDUMP_EXCEPTION_INFORMATION :: struct {
    ThreadId: DWORD #align 4;
    ExceptionPointers: *EXCEPTION_POINTERS #align 4;
    ClientPointers: BOOL #align 4;
} #no_padding
MINIDUMP_EXCEPTION_INFORMATION64 :: struct {
    ThreadId: DWORD #align 4;
    ExceptionRecord: u64 #align 4;
    ContextRecord: u64 #align 4;
    ClientPointers: BOOL #align 4;
} #no_padding
MINIDUMP_USER_STREAM :: struct {
    Type: u32 #align 4;
    BufferSize: u32 #align 4;
    Buffer: *void #align 4;
} #no_padding
MINIDUMP_USER_STREAM_INFORMATION :: struct {
    UserStreamCount: u32 #align 4;
    UserStreamArray: *MINIDUMP_USER_STREAM #align 4;
} #no_padding
MINIDUMP_CALLBACK_INPUT :: struct {
    ProcessId: u32 #align 4;
    ProcessHandle: HANDLE #align 4;
    CallbackType: MINIDUMP_CALLBACK_TYPE #align 4;
    union {
        Status: HRESULT;
        SecondaryFlags: u32;
    }
} #no_padding
MINIDUMP_MEMORY_INFO :: struct {
    BaseAddress: u64 #align 4;
    AllocationBase: u64 #align 4;
    AllocationProtect: u32 #align 4;
    __alignment1: u32 #align 4;
    RegionSize: u64 #align 4;
    State: u32 #align 4;
    Protect: u32 #align 4;
    Type: u32 #align 4;
    __alignment2: u32 #align 4;
} #no_padding
MINIDUMP_CALLBACK_OUTPUT :: struct {
    union {
        ModuleWriteFlags: u32 #align 4;
        ThreadWriteFlags: u32 #align 4;
        SecondaryFlags: u32 #align 4;
        struct {
            MemoryBase: u64 #align 4;
            MemorySize: u32 #align 4;
        }
        struct {
            CheckCancel: BOOL #align 4;
            Cancel: BOOL #align 4;
        }
        Handle: HANDLE #align 4;
        struct {
            VmRegion: MINIDUMP_MEMORY_INFO #align 4;
            Continue: BOOL #align 4;
        }
        struct {
            VmQueryStatus: HRESULT #align 4;
            VmQueryResult: MINIDUMP_MEMORY_INFO #align 4;
        }
        struct {
            VmReadStatus: HRESULT #align 4;
            VmReadBytesCompleted: u32 #align 4;
        }
        Status: HRESULT #align 4;
    }
} #no_padding
MINIDUMP_CALLBACK_ROUTINE :: #type (CallbackParam: *void, CallbackInput: *MINIDUMP_CALLBACK_INPUT, CallbackOutput: *MINIDUMP_CALLBACK_OUTPUT) -> BOOL #c_call;

MINIDUMP_CALLBACK_INFORMATION :: struct {
    CallbackRoutine: MINIDUMP_CALLBACK_ROUTINE #align 4;
    CallbackParam: *void #align 4;
} #no_padding
ReadProcessMemoryProc64 :: #type (hProcess: HANDLE, lpBaseAddress: u64, lpBuffer: *void, nSize: u32, lpNumberOfBytesRead: *u32) -> BOOL #c_call;

FunctionTableAccessProc64 :: #type (hProcess: HANDLE, AddrBase: u64) -> *void #c_call;
GetModuleBaseProc64 :: #type (hProcess: HANDLE, dwAddr: u64) -> u64 #c_call;
TranslateAddressProc64 :: #type (hProcess: HANDLE, hThread: HANDLE, lpaddr: *ADDRESS64) -> u64 #c_call;

MiniDumpWriteDump :: (hProcess: HANDLE, ProcessId: DWORD, hFile: HANDLE, DumpType: MINIDUMP_TYPE,
ExceptionParam: *MINIDUMP_EXCEPTION_INFORMATION, UserStreamParam: *MINIDUMP_USER_STREAM_INFORMATION,
CallbackParam: *MINIDUMP_CALLBACK_INFORMATION) -> BOOL #foreign DbgHelp;

StackWalk64 :: (MachineType: IMAGE_FILE_MACHINE, hProcess: HANDLE, hThread: HANDLE, StackFrame: *STACKFRAME64, ContextRecord: *void,
ReadMemoryRoutine: ReadProcessMemoryProc64, FunctionTableAccessRoutine: FunctionTableAccessProc64,
GetModuleBaseRoutine: GetModuleBaseProc64, TranslateAddres: TranslateAddressProc64) -> BOOL #foreign DbgHelp;

SymCleanup :: (hProcess: HANDLE) -> BOOL #foreign DbgHelp;
SymFromAddr :: (hProcess: HANDLE, Address: u64, Displacement: *u64, Symbol: *SYMBOL_INFO) -> BOOL #foreign DbgHelp;
SymFunctionTableAccess64 :: (hProcess: HANDLE, AddrBase: u64) -> *void #foreign DbgHelp;
SymGetLineFromAddr64 :: (hProcess: HANDLE, dwAddr: u64, pdwDisplacement: *u32, Line: *IMAGEHLP_LINE64) -> BOOL #foreign DbgHelp;
SymGetModuleBase64 :: (hProcess: HANDLE, dwAddr: u64) -> u64 #foreign DbgHelp;
SymGetSymFromAddr64 :: (hProcess: HANDLE, Address: u64, Displacement: *u64, Symbol: *IMAGEHLP_SYMBOL64) -> BOOL #foreign DbgHelp;
SymInitialize :: (hProcess: HANDLE, UserSearchPath: *u8, fInvadeProcess: BOOL) -> BOOL #foreign DbgHelp;
SymSetOptions :: (SymOptions: SYMOPT) -> SYMOPT #foreign DbgHelp;
EXCEPTION_MAXIMUM_PARAMETERS :: 15;

EXCEPTION_RECORD :: struct {
    ExceptionCode: u32;
    ExceptionFlags: u32;
    ExceptionRecord: *EXCEPTION_RECORD;
    ExceptionAddress: *void;
    NumberParameters: u32;
    ExceptionInformation: [EXCEPTION_MAXIMUM_PARAMETERS] u64;
}

EXCEPTION_POINTERS :: struct {
    ExceptionRecord: *EXCEPTION_RECORD;
    ContextRecord: *CONTEXT;
}

LPTOP_LEVEL_EXCEPTION_FILTER :: #type (ExceptionInfo: *EXCEPTION_POINTERS) -> s32 #c_call;
EXCEPTION_EXECUTE_HANDLER :: 1;
EXCEPTION_CONTINUE_SEARCH :: 0;
EXCEPTION_CONTINUE_EXECUTION :: -1;
RtlCaptureContext :: (ContextRecord: *CONTEXT) #foreign kernel32;
SetUnhandledExceptionFilter :: (lpTopLevelExceptionFilter: LPTOP_LEVEL_EXCEPTION_FILTER) -> LPTOP_LEVEL_EXCEPTION_FILTER #foreign kernel32;

using SEM :: enum_flags u32 {
    SEM_FAILCRITICALERRORS :: 0x0001;
    SEM_NOALIGNMENTFAULTEXCEPT :: 0x0004;
    SEM_NOGPFAULTERRORBOX :: 0x0002;
    SEM_NOOPENFILEERRORBOX :: 0x8000;
}

FORMAT_MESSAGE_ALLOCATE_BUFFER :: 0x00000100;
FORMAT_MESSAGE_IGNORE_INSERTS :: 0x00000200;
FORMAT_MESSAGE_FROM_SYSTEM :: 0x00001000;

using FLASHW :: enum_flags u32 {
    FLASHW_STOP :: 0;
    FLASHW_CAPTION :: 0x00000001;
    FLASHW_TRAY :: 0x00000002;
    FLASHW_ALL :: 0x00000003;
    FLASHW_TIMER :: 0x00000004;
    FLASHW_TIMERNOFG :: 0x0000000C;
}

FLASHWINFO :: struct {
    cbSize: u32;
    hwnd: HWND;
    dwFlags: FLASHW;
    uCount: u32;
    dwTimeout: u32;
}

OS_Error_Code :: #type,isa u32;
FlashWindow :: (hWnd: HWND, bInvert: BOOL) -> BOOL #foreign user32;
FlashWindowEx :: (pfwi: *FLASHWINFO) -> BOOL #foreign user32;
FormatMessageA :: (dwFlags: u32, lpSource: *void, dwMessageId: u32, dwLanguageId: u32, lpBuffer: **u8, nSize: u32, Arguments: *void) -> s32 #foreign kernel32;
FormatMessageW :: (dwFlags: u32, lpSource: *void, dwMessageId: u32, dwLanguageId: u32, lpBuffer: **u16, nSize: u32, Arguments: *void) -> s32 #foreign kernel32;
GetErrorMode :: () -> SEM #foreign kernel32;
GetLastError :: () -> OS_Error_Code #foreign kernel32;
NTSTATUS :: DWORD;
RtlGetLastNtStatus :: () -> NTSTATUS #foreign ntdll;
SetErrorMode :: (uMode: SEM) -> SEM #foreign kernel32;

SYSTEMTIME :: struct {
    wYear: u16;
    wMonth: u16;
    wDayOfWeek: u16;
    wDay: u16;
    wHour: u16;
    wMinute: u16;
    wSecond: u16;
    wMilliseconds: u16;
}

FILETIME :: struct {
    union {
        struct {
            dwLowDateTime: u32;
            dwHighDateTime: u32;
        }
        QuadPart: u64 #align 4 = ---;
    }
}

TIME_ZONE_INFORMATION :: struct {
    Bias: s32;
    StandardName: [32] u16;
    StandardDate: SYSTEMTIME;
    StandardBias: s32;
    DaylightName: [32] u16;
    DaylightDate: SYSTEMTIME;
    DaylightBias: s32;
}

FileTimeToLocalFileTime :: (lpFileTime: *FILETIME, lpLocalFileTime: *FILETIME) -> BOOL #foreign kernel32;
LocalFileTimeToFileTime :: (lpLocalFileTime: *FILETIME, lpFileTime: *FILETIME) -> BOOL #foreign kernel32;
FileTimeToSystemTime :: (lpFileTime: *FILETIME, lpSystemTime: *SYSTEMTIME) -> BOOL #foreign kernel32;
GetFileTime :: (file: HANDLE, lpCreationTime: *FILETIME, lpLastAccessTime: *FILETIME, lpLastWriteTime: *FILETIME) -> s32 #foreign kernel32;
GetLocalTime :: (time: *SYSTEMTIME) -> void #foreign kernel32;
GetSystemTime :: (time: *SYSTEMTIME) -> void #foreign kernel32;
GetSystemTimeAsFileTime :: (lpSystemTimeAsFileTime: *FILETIME) #foreign kernel32;
GetSystemTimePreciseAsFileTime :: (lpSystemTimeAsFileTime: *FILETIME) #foreign kernel32;
SystemTimeToFileTime :: (lpSystemTime: *SYSTEMTIME, lpFileTime: *FILETIME) -> BOOL #foreign kernel32;
SystemTimeToTzSpecificLocalTime :: (lpTimeZone: *TIME_ZONE_INFORMATION, lpUniversalTime: *SYSTEMTIME, lpLocalTime: *SYSTEMTIME) -> BOOL #foreign kernel32;
PathFileExistsW :: (pszPath: *u16) -> s32 #foreign Shlwapi;

STICKYKEYS :: struct {
    cbSize: u32 = 8;
    dwFlags: STICKYKEY_FLAGS;
}

TOGGLEKEYS :: struct {
    cbSize: u32 = 8;
    dwFlags: TOGGLEKEY_FLAGS;
}

FILTERKEYS :: struct {
    cbSize: u32 = 24;
    dwFlags: FILTERKEY_FLAGS;
    iWaitMSec: u32;
    iDelayMSec: u32;
    iRepeatMSec: u32;
    iBounceMSec: u32;
}

SM_CXSCREEN :: 0;
SM_CYSCREEN :: 1;
SM_CXVSCROLL :: 2;
SM_CYHSCROLL :: 3;
SM_CYCAPTION :: 4;
SM_CXBORDER :: 5;
SM_CYBORDER :: 6;
SM_CXDLGFRAME :: 7;
SM_CYDLGFRAME :: 8;
SM_CYVTHUMB :: 9;
SM_CXHTHUMB :: 10;
SM_CXICON :: 11;
SM_CYICON :: 12;
SM_CXCURSOR :: 13;
SM_CYCURSOR :: 14;
SM_CYMENU :: 15;
SM_CXFULLSCREEN :: 16;
SM_CYFULLSCREEN :: 17;
SM_CYKANJIWINDOW :: 18;
SM_MOUSEPRESENT :: 19;
SM_CYVSCROLL :: 20;
SM_CXHSCROLL :: 21;
SM_DEBUG :: 22;
SM_SWAPBUTTON :: 23;
SM_RESERVED1 :: 24;
SM_RESERVED2 :: 25;
SM_RESERVED3 :: 26;
SM_RESERVED4 :: 27;
SM_CXMIN :: 28;
SM_CYMIN :: 29;
SM_CXSIZE :: 30;
SM_CYSIZE :: 31;
SM_CXFRAME :: 32;
SM_CYFRAME :: 33;
SM_CXMINTRACK :: 34;
SM_CYMINTRACK :: 35;
SM_CXDOUBLECLK :: 36;
SM_CYDOUBLECLK :: 37;
SM_CXICONSPACING :: 38;
SM_CYICONSPACING :: 39;
SM_MENUDROPALIGNMENT :: 40;
SM_PENWINDOWS :: 41;
SM_DBCSENABLED :: 42;
SM_CMOUSEBUTTONS :: 43;
SM_CXFIXEDFRAME :: SM_CXDLGFRAME;
SM_CYFIXEDFRAME :: SM_CYDLGFRAME;
SM_CXSIZEFRAME :: SM_CXFRAME;
SM_CYSIZEFRAME :: SM_CYFRAME;
SM_SECURE :: 44;
SM_CXEDGE :: 45;
SM_CYEDGE :: 46;
SM_CXMINSPACING :: 47;
SM_CYMINSPACING :: 48;
SM_CXSMICON :: 49;
SM_CYSMICON :: 50;
SM_CYSMCAPTION :: 51;
SM_CXSMSIZE :: 52;
SM_CYSMSIZE :: 53;
SM_CXMENUSIZE :: 54;
SM_CYMENUSIZE :: 55;
SM_ARRANGE :: 56;
SM_CXMINIMIZED :: 57;
SM_CYMINIMIZED :: 58;
SM_CXMAXTRACK :: 59;
SM_CYMAXTRACK :: 60;
SM_CXMAXIMIZED :: 61;
SM_CYMAXIMIZED :: 62;
SM_NETWORK :: 63;
SM_CLEANBOOT :: 67;
SM_CXDRAG :: 68;
SM_CYDRAG :: 69;
SM_SHOWSOUNDS :: 70;
SM_CXMENUCHECK :: 71;
SM_CYMENUCHECK :: 72;
SM_SLOWMACHINE :: 73;
SM_MIDEASTENABLED :: 74;
SM_MOUSEWHEELPRESENT :: 75;
SM_XVIRTUALSCREEN :: 76;
SM_YVIRTUALSCREEN :: 77;
SM_CXVIRTUALSCREEN :: 78;
SM_CYVIRTUALSCREEN :: 79;
SM_CMONITORS :: 80;
SM_SAMEDISPLAYFORMAT :: 81;
SM_IMMENABLED :: 82;
SM_CXFOCUSBORDER :: 83;
SM_CYFOCUSBORDER :: 84;
SM_TABLETPC :: 86;
SM_MEDIACENTER :: 87;
SM_STARTER :: 88;
SM_SERVERR2 :: 89;
SM_MOUSEHORIZONTALWHEELPRESENT :: 91;
SM_CXPADDEDBORDER :: 92;
SM_DIGITIZER :: 94;
SM_MAXIMUMTOUCHES :: 95;
SM_CMETRICS :: 97;
SM_REMOTESESSION :: 0x1000;
SM_SHUTTINGDOWN :: 0x2000;
SM_REMOTECONTROL :: 0x2001;
SM_CARETBLINKINGENABLED :: 0x2002;
SM_CONVERTIBLESLATEMODE :: 0x2003;
SM_SYSTEMDOCKED :: 0x2004;
SPI_GETWORKAREA :: 0x0030;
SPI_GETFILTERKEYS :: 0x0032;
SPI_SETFILTERKEYS :: 0x0033;
SPI_GETTOGGLEKEYS :: 0x0034;
SPI_SETTOGGLEKEYS :: 0x0035;
SPI_GETSTICKYKEYS :: 0x003A;
SPI_SETSTICKYKEYS :: 0x003B;

using STICKYKEY_FLAGS :: enum_flags u32 {
    SKF_STICKYKEYSON :: 0x00000001;
    SKF_AVAILABLE :: 0x00000002;
    SKF_HOTKEYACTIVE :: 0x00000004;
    SKF_CONFIRMHOTKEY :: 0x00000008;
    SKF_HOTKEYSOUND :: 0x00000010;
    SKF_INDICATOR :: 0x00000020;
    SKF_AUDIBLEFEEDBACK :: 0x00000040;
    SKF_TRISTATE :: 0x00000080;
    SKF_TWOKEYSOFF :: 0x00000100;
};

using TOGGLEKEY_FLAGS :: enum_flags u32 {
    TKF_TOGGLEKEYSON :: 0x00000001;
    TKF_AVAILABLE :: 0x00000002;
    TKF_HOTKEYACTIVE :: 0x00000004;
    TKF_CONFIRMHOTKEY :: 0x00000008;
    TKF_HOTKEYSOUND :: 0x00000010;
    TKF_INDICATOR :: 0x00000020;
};

using FILTERKEY_FLAGS :: enum_flags u32 {
    FKF_FILTERKEYSON :: 0x00000001;
    FKF_AVAILABLE :: 0x00000002;
    FKF_HOTKEYACTIVE :: 0x00000004;
    FKF_CONFIRMHOTKEY :: 0x00000008;
    FKF_HOTKEYSOUND :: 0x00000010;
    FKF_INDICATOR :: 0x00000020;
    FKF_CLICKON :: 0x00000040;
};

GetSystemMetrics :: (nIndex: s32) -> s32 #foreign user32;
SystemParametersInfoA :: (uiAction: u32, uiParam: u32, pvParam: *void, fWinIni: u32) -> BOOL #foreign user32;
SystemParametersInfoW :: (uiAction: u32, uiParam: u32, pvParam: *void, fWinIni: u32) -> BOOL #foreign user32;

BITMAPINFOHEADER :: struct {
    biSize: u32;
    biWidth: s32;
    biHeight: s32;
    biPlanes: u16;
    biBitCount: u16;
    biCompression: u32;
    biSizeImage: u32;
    biXPelsPerMeter: s32;
    biYPelsPerMeter: s32;
    biClrUsed: u32;
    biClrImportant: u32;
}

BI_RGB :: 0;
BI_RLE8 :: 1;
BI_RLE4 :: 2;
BI_BITFIELDS :: 3;
BI_JPEG :: 4;
BI_PNG :: 5;

ROP :: enum u32 {
    SRCCOPY :: 0x00CC0020;
}

BitBlt :: (hdc: HDC, x: s32, y: s32, cx: s32, cy: s32, hdcSrc: HDC, x1: s32, y1: s32, rop: ROP) -> BOOL #foreign gdi;
CreateCompatibleBitmap :: (hdc: HDC, cx: s32, cy: s32) -> HBITMAP #foreign gdi;
DIB_RGB_COLORS :: 0;
GetDIBits :: (hdc: HDC, hbm: HBITMAP, start: u32, cLines: u32, lpvBits: *void, lpbmi: *BITMAPINFO, usage: u32) -> s32 #foreign gdi;

BLTMODE :: enum u32 {
    BLACKONWHITE :: 0x0001;
    WHITEONBLACK :: 0x0002;
    COLORONCOLOR :: 0x0003;
    HALFTONE :: 0x0004;
}

SetStretchBltMode :: (hdc: HDC, mode: BLTMODE) -> s32 #foreign gdi;
StretchBlt :: (hdcDest: HDC, xDest: s32, yDest: s32, wDest: s32, hDest: s32, hdcSrc: HDC, xSrc: s32, ySrc: s32, wSrc: s32, hSrc: s32, rop: ROP) -> BOOL #foreign gdi;
OFN_NOCHANGEDIR :: 0x00000008;

OPENFILENAME :: struct(T: Type) {
    lStructSize: u32;
    hwndOwner: HWND;
    hInstance: HINSTANCE;
    lpstrFilter: *T;
    lpstrCustomFilter: *T;
    nMaxCustFilter: u32;
    nFilterIndex: u32;
    lpstrFile: *T;
    nMaxFile: u32;
    lpstrFileTitle: *T;
    nMaxFileTitle: u32;
    lpstrInitialDir: *T;
    lpstrTitle: *T;
    Flags: u32;
    nFileOffset: u16;
    nFileExtension: u16;
    lpstrDefExt: *T;
    lCustData: LPARAM;
    lpfnHook: *void;
    lpTemplateName: *T;
    pvReserved: *void;
    dwReserved: u32;
    FlagsEx: u32;
}

OPENFILENAMEA :: OPENFILENAME(T = u8);
OPENFILENAMEW :: OPENFILENAME(T = u16);
CommDlgExtendedError :: () -> u32 #foreign comdlg32;
GetOpenFileNameA :: (arg: *OPENFILENAMEA) -> BOOL #foreign comdlg32;
GetOpenFileNameW :: (arg: *OPENFILENAMEW) -> BOOL #foreign comdlg32;
GetSaveFileNameA :: (arg: *OPENFILENAMEA) -> BOOL #foreign comdlg32;
GetSaveFileNameW :: (arg: *OPENFILENAMEW) -> BOOL #foreign comdlg32;

using FILEOP_FLAGS :: enum_flags u16 {
    FOF_MULTIDESTFILES :: 0x0001;
    FOF_CONFIRMMOUSE :: 0x0002;
    FOF_SILENT :: 0x0004;
    FOF_RENAMEONCOLLISION :: 0x0008;
    FOF_NOCONFIRMATION :: 0x0010;
    FOF_WANTMAPPINGHANDLE :: 0x0020;
    FOF_ALLOWUNDO :: 0x0040;
    FOF_FILESONLY :: 0x0080;
    FOF_SIMPLEPROGRESS :: 0x0100;
    FOF_NOCONFIRMMKDIR :: 0x0200;
    FOF_NOERRORUI :: 0x0400;
    FOF_NOCOPYSECURITYATTRIBS :: 0x0800;
    FOF_NORECURSION :: 0x1000;
    FOF_NO_CONNECTED_ELEMENTS :: 0x2000;
    FOF_WANTNUKEWARNING :: 0x4000;
    FOF_NORECURSEREPARSE :: 0x8000;
    FOF_NO_UI :: FOF_SILENT | FOF_NOCONFIRMATION | FOF_NOERRORUI | FOF_NOCONFIRMMKDIR;
}

FO_MOVE :: 1;
FO_COPY :: 2;
FO_DELETE :: 3;
FO_RENAME :: 4;

SHFILEOPSTRUCTA :: struct {
    hwnd: HWND;
    wFunc: u32;
    pFrom: *u8;
    pTo: *u8;
    fFlags: FILEOP_FLAGS;
    fAnyOperationsAborted: BOOL;
    hNameMappings: *void;
    lpszProgressTitle: *u8;
}

SHFILEOPSTRUCTW :: struct {
    hwnd: HWND;
    wFunc: u32;
    pFrom: *u16;
    pTo: *u16;
    fFlags: FILEOP_FLAGS;
    fAnyOperationsAborted: BOOL;
    hNameMappings: *void;
    lpszProgressTitle: *u16;
}

DragAcceptFiles :: (hWnd: HWND, fAccept: BOOL) #foreign shell32;
DragFinish :: (hDrop: HDROP) #foreign shell32;
DragQueryFileW :: (hDrop: HDROP, iFile: u32, lpszFile: *u16, cch: u32) -> u32 #foreign shell32;
SHFileOperationA :: (FileOp: *SHFILEOPSTRUCTA) -> s32 #foreign shell32;
SHFileOperationW :: (FileOp: *SHFILEOPSTRUCTW) -> s32 #foreign shell32;
_CRT_WARN :: 0;
_CRT_ERROR :: 1;
_CRT_ASSERT :: 2;
_CRT_ERRCNT :: 3;
_CRTDBG_MODE_FILE :: 0x1;
_CRTDBG_MODE_DEBUG :: 0x2;
_CRTDBG_MODE_WNDW :: 0x4;
_CRTDBG_REPORT_MODE :: -1;
_beginthreadex :: (_Security: *void, _StackSize: u32, _StartAddress: *void, _ArgList: *void, _InitFlag: Creation_Flags, _ThrdAddr: *s32) -> *u32 #foreign Crt;
_endthreadex :: (return_code: u32) #foreign Crt;
getenv :: (var: *u8) -> *u8 #foreign Crt;
_wgetenv :: (var: *s16) -> *s16 #foreign Crt;
STD_INPUT_HANDLE :: -10;
STD_OUTPUT_HANDLE :: -11;
STD_ERROR_HANDLE :: -12;
FILE_SHARE_READ :: 0x1;
FILE_SHARE_WRITE :: 0x2;
FILE_SHARE_DELETE :: 0x4;
CREATE_NEW :: 1;
CREATE_ALWAYS :: 2;
OPEN_EXISTING :: 3;
OPEN_ALWAYS :: 4;
TRUNCATE_EXISTING :: 5;
FILE_ATTRIBUTE_READONLY :: 0x01;
FILE_ATTRIBUTE_HIDDEN :: 0x02;
FILE_ATTRIBUTE_SYSTEM :: 0x04;
FILE_ATTRIBUTE_DIRECTORY :: 0x10;
FILE_ATTRIBUTE_NORMAL :: 0x80;
FILE_ATTRIBUTE_REPARSE_POINT :: 0x400;
IO_REPARSE_TAG_SYMLINK :: 0xA000000C;
FILE_FLAG_BACKUP_SEMANTICS :: 0x02000000;
FILE_FLAG_OVERLAPPED :: 0x40000000;
INVALID_HANDLE_VALUE :: cast(HANDLE) -1;
HANDLE_FLAG_INHERIT :: 1;
HANDLE_FLAG_PROTECT_FROM_CLOSE :: 2;
LANG_NEUTRAL :: 0;
LANG_ENGLISH :: 0x09;
SUBLANG_DEFAULT :: 0x1;

WideCharToMultiByte :: (CodePage: u32, dwFlags: u32, lpWideCharStr: *u16, cchWideChar: s32, lpMultiByteStr: *u8,
cbMultiByte: s32, lpDefaultChar: *u8, lpUsedDefaultChar: *s32) -> s32 #foreign kernel32;

MultiByteToWideChar :: (CodePage: u32, dwFlags: u32, lpMultiByteStr: *u8, cbMultiByte: s32,
lpWideCharStr: *u16, cchWideChar: s32) -> s32 #foreign kernel32;

CP_ACP :: 0;
CP_UTF8 :: 65001;
WC_NO_BEST_FIT_CHARS :: 0x0000_0400;
WC_COMPOSITECHECK :: 0x0000_0200;

IUnknown_VTable :: struct {
    QueryInterface: (this: *IUnknown, riid: *IID, ppvObject: **void) -> HRESULT #cpp_method;
    AddRef: (this: *IUnknown) -> u32 #cpp_method;
    Release: (this: *IUnknown) -> u32 #cpp_method;
}

IUnknown_UUID :: "00000000-0000-0000-C000-000000000046";

IUnknown :: struct {
    vtable: *IUnknown_VTable;
}

string_to_guid :: uid;
FILE_MAP_ALL_ACCESS :: 0xf001f;
FILE_MAP_READ :: 4;
FILE_MAP_WRITE :: 2;
FILE_MAP_COPY :: 1;
ERROR_FILE_NOT_FOUND :: 0x002;
ERROR_ACCESS_DENIED :: 0x005;
ERROR_BROKEN_PIPE :: 0x06D;
ERROR_ALREADY_EXISTS :: 0x0B7;
ERROR_PIPE_BUSY :: 0x0E7;
ERROR_NO_DATA :: 0x0E8;
ERROR_MORE_DATA :: 0x0EA;
WAIT_OBJECT_0 :: 0x000;
WAIT_TIMEOUT :: 0x102;
ERROR_PIPE_CONNECTED :: 0x217;
ERROR_IO_PENDING :: 0x3E5;
REG_NONE :: 0;
REG_SZ :: 1;
REG_DWORD :: 4;
MAX_PATH :: 260;

Msvc_Destructor_Flags :: enum_flags u32 {
    NONE :: 0;
    FREE_MEMORY :: 1;
    ARRAY_DESTRUCTOR :: 2;
}

#scope_file
ntdll :: #system_library "Ntdll";
kernel32 :: #system_library "kernel32";
winmm :: #system_library "winmm";
user32 :: #system_library "user32";
shell32 :: #system_library "shell32";
Crt :: #system_library "msvcrt";
gdi :: #system_library "Gdi32";
gl :: #system_library "opengl32";
Dwmapi :: #system_library "Dwmapi";
DbgHelp :: #system_library "DbgHelp";
Advapi32 :: #system_library "Advapi32";
Shlwapi :: #system_library "shlwapi";
comdlg32 :: #system_library "comdlg32";

#scope_export
#load "Windows/support.jai";
