// Newer public configuration schema. libclang execution is deliberately absent.
GENERATOR_DEFAULT_SYSTEM_INCLUDE_PATH :: "/usr/include";

Binding_Generator_Strip_Flags :: enum_flags {
    INLINED_FUNCTIONS;
}

Generate_Bindings_Options :: struct {
    libpaths: [..] string;
    libnames: [..] string;
    include_paths: [..] string;
    source_files: [..] string;
    system_include_paths: [..] string;
    extra_clang_arguments: [..] string;
    strip_flags: Binding_Generator_Strip_Flags;
    header: string;
}
