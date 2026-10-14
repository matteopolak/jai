#import <AppKit/AppKit.h>
#include <stdio.h>

// Independent native SDK observation of the Jai backend's PNG clipboard payload.
int window_clipboard_probe(void) {
    @autoreleasepool {
        NSData *data = [[NSPasteboard generalPasteboard] dataForType:NSPasteboardTypePNG];
        if (!data) return 1;
        NSBitmapImageRep *image = [[NSBitmapImageRep alloc] initWithData:data];
        if (!image || image.pixelsWide != 2 || image.pixelsHigh != 2) return 2;
        // Inspect encoded channel samples directly. NSColor conversion to the device
        // profile changes numeric RGB values and would test color management instead.
        if (image.bitsPerSample != 8 || image.samplesPerPixel != 4) return 3;
        NSUInteger first[4], last[4];
        [image getPixel:first atX:0 y:0];
        [image getPixel:last atX:1 y:1];
        if (first[0] != 0 || first[1] != 0 || first[2] != 255 || first[3] != 255) {
            fprintf(stderr, "first native PNG pixel: %lu %lu %lu %lu\n", first[0], first[1], first[2], first[3]);
            return 4;
        }
        if (last[0] != 0 || last[1] != 255 || last[2] != 0 || last[3] != 255) return 5;
        return 0;
    }
}
