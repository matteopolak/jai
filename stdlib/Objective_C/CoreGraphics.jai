// CoreGraphics publishes window levels only through CGWindowLevelForKey, so the kCG*WindowLevel
// globals below start at zero; call this once (on macOS) before reading them.
init_core_graphics_runtime_constants :: () {
    // One global per CGWindowLevelKey, listed in key order, so slot i is filled from key i. The
    // declared length makes a missing or extra entry a compile error.
    by_key: [KEY_COUNT] *CGWindowLevel = .[
        *kCGBaseWindowLevel, *kCGMinimumWindowLevel, *kCGDesktopWindowLevel, *kCGBackstopMenuLevel,
        *kCGNormalWindowLevel, *kCGFloatingWindowLevel, *kCGTornOffMenuWindowLevel, *kCGDockWindowLevel,
        *kCGMainMenuWindowLevel, *kCGStatusWindowLevel, *kCGModalPanelWindowLevel, *kCGPopUpMenuWindowLevel,
        *kCGDraggingWindowLevel, *kCGScreenSaverWindowLevel, *kCGMaximumWindowLevel, *kCGOverlayWindowLevel,
        *kCGHelpWindowLevel, *kCGUtilityWindowLevel, *kCGDesktopIconWindowLevel, *kCGCursorWindowLevel,
        *kCGAssistiveTechHighWindowLevel,
    ];
    for by_key it.* = CGWindowLevelForKey(cast(CGWindowLevelKey) it_index);
}

#scope_file
KEY_COUNT :: cast(s64) CGWindowLevelKey.kCGNumberOfWindowLevelKeys;

#scope_export
using CGWindowLevelKey :: enum s32 {
    kCGBaseWindowLevelKey :: 0;
    kCGMinimumWindowLevelKey;
    kCGDesktopWindowLevelKey;
    kCGBackstopMenuLevelKey;
    kCGNormalWindowLevelKey;
    kCGFloatingWindowLevelKey;
    kCGTornOffMenuWindowLevelKey;
    kCGDockWindowLevelKey;
    kCGMainMenuWindowLevelKey;
    kCGStatusWindowLevelKey;
    kCGModalPanelWindowLevelKey;
    kCGPopUpMenuWindowLevelKey;
    kCGDraggingWindowLevelKey;
    kCGScreenSaverWindowLevelKey;
    kCGMaximumWindowLevelKey;
    kCGOverlayWindowLevelKey;
    kCGHelpWindowLevelKey;
    kCGUtilityWindowLevelKey;
    kCGDesktopIconWindowLevelKey;
    kCGCursorWindowLevelKey;
    kCGAssistiveTechHighWindowLevelKey;
    kCGNumberOfWindowLevelKeys;
}

CGWindowLevelForKey :: (key: CGWindowLevelKey) -> CGWindowLevel #foreign CoreGraphics;
CGWindowLevel :: s32;
kCGBaseWindowLevel: CGWindowLevel;
kCGMinimumWindowLevel: CGWindowLevel;
kCGDesktopWindowLevel: CGWindowLevel;
kCGDesktopIconWindowLevel: CGWindowLevel;
kCGBackstopMenuLevel: CGWindowLevel;
kCGNormalWindowLevel: CGWindowLevel;
kCGFloatingWindowLevel: CGWindowLevel;
kCGTornOffMenuWindowLevel: CGWindowLevel;
kCGDockWindowLevel: CGWindowLevel;
kCGMainMenuWindowLevel: CGWindowLevel;
kCGStatusWindowLevel: CGWindowLevel;
kCGModalPanelWindowLevel: CGWindowLevel;
kCGPopUpMenuWindowLevel: CGWindowLevel;
kCGDraggingWindowLevel: CGWindowLevel;
kCGScreenSaverWindowLevel: CGWindowLevel;
kCGCursorWindowLevel: CGWindowLevel;
kCGOverlayWindowLevel: CGWindowLevel;
kCGHelpWindowLevel: CGWindowLevel;
kCGUtilityWindowLevel: CGWindowLevel;
kCGAssistiveTechHighWindowLevel: CGWindowLevel;
kCGMaximumWindowLevel: CGWindowLevel;
#scope_module
CoreGraphics :: #system_library "CoreGraphics";
