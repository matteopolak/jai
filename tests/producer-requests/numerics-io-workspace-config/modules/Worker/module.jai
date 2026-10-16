#import "Basic";

disabled :: () -> bool {
    return !#exists(String_Builder.Buffer.ensured_count);
}
