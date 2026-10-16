# C numeric conversion in the WASI runtime

The shared WASI runtime import closure used by command-line and workspace
builds also imports `Wasi_Numeric_Runtime`. Its public facade loads
`internal/wasi-numeric`; `Extensions/Wasi_Runtime` remains unchanged.
The private module exports C ABI `strtod`, `strtof`, `atof`, and
`setlocale` symbols. Node supplies only WASI preview1 imports, not JavaScript
numeric conversion shims.

Conversion uses the existing independent Basic parser at the destination
precision. A fresh context is installed for each C entry requiring Basic;
no caller Jai context is assumed. Binary32 conversion does not pass through
binary64. Decimal and hexadecimal subjects, signs, C whitespace, infinity,
NaN and valid NaN payload syntax are accepted. The end pointer marks the
consumed prefix; failed conversion leaves it at the original input. NaNs
are canonical quiet NaNs; payload interpretation is implementation-defined.

The sandbox interpreter handles the same C boundary independently: decimal
conversion uses Rust's direct binary32/binary64 parser, while hexadecimal
conversion rounds retained significand bits with guard and sticky bits.
It never forwards sandbox locale changes to the host.

Both providers implement the C locale with round-to-nearest, ties-to-even.
Overflow and nonzero subjects rounded to zero set `ERANGE` (34). Subnormal
results preserve errno, as do successful ordinary conversions and failed
conversions. C11 permits an implementation-defined underflow errno policy.
`setlocale` queries and requests for C/POSIX/empty implementation-default
names return the installed C locale. Other names or invalid categories
return null. Non-C locales and other floating rounding modes are unsupported.

These policies follow the [public C11 draft, 7.22.1.3 and 7.11.1.1](https://www.open-std.org/jtc1/sc22/wg14/www/docs/n1570.pdf).
The [public strtod manual](https://man7.org/linux/man-pages/man3/strtod.3.html)
also describes the numeric subject and end-pointer boundary.

## Focused controls

`tests/compiler-semantics/wasm-c-numeric.jai` is a **WASM-target-only**
valid-pointer C ABI test: execute with `jaic -interp -os wasm`, and compile
with `-os wasm -O0` / `-O2` for `node tools/wasi_run.mjs`.
It checks destination precision, ties, subnormals, signed zero, hexadecimal
subjects, incomplete exponents, special values, no conversion, optional
end pointers, errno preservation/range errors and locale rejection.

Eight Rust `c_numeric` unit tests cover the sandbox boundary, including
4087 generated exact IEEE hexadecimal subjects from 4,096 bit patterns. Their source-only command is
`cargo test -p jaic --lib c_numeric`.

`tests/producer-requests/json-numeric-boundary/main.jai` independently checks
four extreme-value Json/Basic round trips with phase markers.
`phases.jai` imports the unchanged owned Json numbers test and calls its
original procedures with their original counts/assertions, adding only
progress output. The first phase run passed in 142.38 seconds: the shortest
comparison sweep consumed 133.67 seconds, and all remaining phases 8.71.
This establishes a finite exact-formatting workload in this source-built
debug tool. It does not establish the cause of the earlier live833 180-second
timeout; the exact CI source/tool/profile/argv remains requested.
The unchanged Json numbers test also passes directly in the host interpreter
in 148.29 seconds (unchanged 180-second bound), and in Node at O0/O2 in
3.60/0.91 seconds.

The independent `workspace.jai` control emits the same C ABI fixture through
the public Compiler child-workspace API and passes in Node at O2. Invoke
`jaic tests/producer-requests/json-numeric-boundary/workspace.jai - <scratch-dir>`.
Without an output-directory argument it performs source checking only. The
first control incorrectly assumed the main CLI output-path override was visible
in the public build-options record; that NO_OUTPUT/ENOENT receipt is retained,
and the corrected control uses the reviewed compile-time argument protocol.
No compiler option semantics were changed.

## Artifact qualification

In this worker's T7 output directory, completed linker output files later
became entirely zero while keeping their lengths. The cause is unresolved.
A diagnostic-only `JAIC_WASM_LD` wrapper invokes the actual installed LLD
with unchanged arguments, validates and hashes its output, and writes/fsyncs
a separate byte copy before compiler cleanup. Node checks use those exact
SDK-produced copies. Both the invalid original artifacts and capture receipts
are retained. This workaround establishes runtime behavior, not normal CLI
output durability; no production linker or runner change is included.
Final combined tools and live CI replay remain integration-owned.
