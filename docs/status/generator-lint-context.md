# General module-mode lint finalization repair

Original reduction: a user module containing only `#add_context original_counter: int;` and a procedure reading that field compiled as a normal program, but failed module-mode lint with Context already laid out. The failing regression is `crates/jailint/tests/generator_context_roots.rs`.

The linter driver fully finalized its synthetic empty main before importing the requested module. It now begins and settles the bootstrap source, adds the real module, then uses its existing final finish_program step. This retains configured bootstrap identity while allowing Context additions to be discovered before final layout. There is no library-name, field-name or file-path exception.

The original reduction failed before the change and passed after it. A separate original minimal bootstrap fixture checks that a lazily imported required-parameter dependency still reuses its configured instance. Both regressions and all 11 jailint library tests pass. The actual owned generator facades, internals and fixtures now pass warnings-denied module/program lint; interpreter/native Mac tests remain in the generator runner evidence.
