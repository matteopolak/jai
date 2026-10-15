#import <AppKit/AppKit.h>
#include <spawn.h>
#include <sys/wait.h>
#include <stdio.h>
#include <errno.h>

extern char **environ;

// Preserve every eagerly materialized item/type, including images, without
// printing clipboard data. Child failure (including abort) still restores it.
int main(int argc, char **argv) {
    if (argc < 2) return 2;
    @autoreleasepool {
        NSPasteboard *board = [NSPasteboard generalPasteboard];
        NSMutableArray<NSPasteboardItem *> *saved = [NSMutableArray array];
        for (NSPasteboardItem *item in board.pasteboardItems) {
            NSPasteboardItem *copy = [[NSPasteboardItem alloc] init];
            for (NSPasteboardType type in item.types) {
                NSData *data = [item dataForType:type];
                if (!data || ![copy setData:data forType:type]) {
                    fprintf(stderr, "clipboard snapshot unavailable; child not started\n");
                    return 3;
                }
            }
            [saved addObject:copy];
        }
        pid_t pid;
        int error = posix_spawn(&pid, argv[1], NULL, NULL, argv + 1, environ);
        if (error) return 4;
        int status = 0;
        int wait_error = 0;
        while (waitpid(pid, &status, 0) < 0) {
            if (errno != EINTR) {
                wait_error = 5;
                break;
            }
        }
        [board clearContents];
        if (saved.count && ![board writeObjects:saved]) return 6;
        NSArray<NSPasteboardItem *> *restored = board.pasteboardItems;
        if (restored.count != saved.count) return 7;
        for (NSUInteger i = 0; i < saved.count; ++i) {
            for (NSPasteboardType type in saved[i].types) {
                if (![[restored[i] dataForType:type] isEqualToData:[saved[i] dataForType:type]]) return 8;
            }
        }
        if (wait_error) return wait_error;
        return WIFEXITED(status) ? WEXITSTATUS(status) : 128 + WTERMSIG(status);
    }
}
