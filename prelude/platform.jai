// Stable numeric target identifiers used in source-library conditionals.
CPU_Tag :: enum u32 {
    UNINITIALIZED :: 0;
    KRAMPU :: 1;
    CUSTOM :: 2;
    X64 :: 3;
    ARM64 :: 4;
}

Operating_System_Tag :: enum u32 {
    NONE :: 0;
    KRAMPOS :: 1;
    WINDOWS :: 2;
    LINUX :: 3;
    ANDROID :: 4;
    IOS :: 5;
    MACOS :: 6;
    NN_SWITCH :: 7;
    PS4 :: 8;
    PS5 :: 9;
    XBOX :: 10;
    WASM :: 11;
}

// Workspace handles are compiler values.
Workspace :: s64;
