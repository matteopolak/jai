# Android POSIX header delegates

The reviewed inventory declares iovec, pollfd, sched_param and timeval on both
Android CPUs, but the shape listing associates their existing definitions with
other platforms. The complete official Bionic C headers now provide explicit
Android declarations; no other OS shape is guessed or copied as a fallback.
Only inventoried target names are supplied, and a reviewed target shape always
takes precedence, including an intentionally different public layout.

Inputs are the complete `aosp-mirror/platform_bionic` native C source archive
at public tag `android-16.0.0_r1`, SHA-256
`460f484a244bdf3bfd5a683e6ee8dbde1c15b0489dbb65608969b6ece7c9751d`.
This official native SDK input contains no Jai implementation. The dependency
manifest pins the archive. The generator verifies every used Bionic header
against its archive bytes and records transitive hashes. It prohibits host
libc fallback: Clang uses only the Bionic tree and its own builtin headers.

`vendor_posix_android.py` parses complete headers for
`aarch64-linux-android35` and `x86_64-linux-android35`. It preserves C field order,
uses desugared primitive widths, rejects unsupported/incomplete/anonymous
records rather than flattening or omitting them, and asserts all field sizes,
offsets and complete sizes/alignments with Clang. The top-level declarations
are independently sorted. Generated metadata and each public ledger entry
carry the exact source/target/layout provenance.

These are successful C header/ABI source checks. The Jai compiler still rejects
Android targets; neither Jai target type checking nor device runtime is claimed.
The eight emitted record declarations resolve source omissions, not the mobile
verification failures. Real Android ABI/runtime tests remain required.

```sh
python3 tools/native_bindings/vendor_posix_android.py
python3 tools/native_bindings/vendor_posix_android.py --check
python3 tools/native_bindings/generate.py --formatter .work/jaifmt-production
```

Native compilation used LLVM Clang 23.1.2. Reports include compiler-resource
header hashes and actual commands. The complete Bionic archive is fetched by
the existing pinned native-dependency builder; no Android runtime is built by
this header generator.
