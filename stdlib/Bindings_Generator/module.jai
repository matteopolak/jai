// Bindings_Generator: turns C (and a little C++) headers into Jai declarations.
//
// The public surface follows the reference module: fill in a
// `Generate_Bindings_Options`, optionally install a `visitor`, then call
// `generate_bindings`. Headers are parsed with the host libclang through the
// bridge in clang.jai. See docs/stdlib/bindings-generator.md.

#import "Basic";
#import "String";
#import "File";
#import "Hash_Table";
#import "Process";

#load "clang.jai";
#load "types.jai";
#load "convert.jai";
#load "print.jai";
#load "generate.jai";
