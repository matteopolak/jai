#import <AppKit/AppKit.h>
#include <stdio.h>

int main(void) {
    @autoreleasepool {
        if (!NSApplicationLoad()) return 1;
        NSApplication *app = [NSApplication sharedApplication];
        printf("policy before: %ld\n", (long)[app activationPolicy]);
        BOOL changed = [app setActivationPolicy:NSApplicationActivationPolicyRegular];
        printf("set regular: %d, policy after: %ld\n", changed, (long)[app activationPolicy]);
        [app finishLaunching];
        NSWindow *window = [[NSWindow alloc]
            initWithContentRect:NSMakeRect(40, 60, 320, 200)
            styleMask:NSWindowStyleMaskTitled | NSWindowStyleMaskClosable | NSWindowStyleMaskMiniaturizable | NSWindowStyleMaskResizable
            backing:NSBackingStoreBuffered defer:NO];
        if (!window) return 2;
        [window setReleasedWhenClosed:NO];
        [window makeKeyAndOrderFront:nil];
        NSRect rect = [window contentRectForFrameRect:[window frame]];
        printf("native content: %.0f %.0f %.0f %.0f\n", rect.origin.x, rect.origin.y,
               rect.size.width, rect.size.height);
        [window close];
        [window release];
        return 0;
    }
}
