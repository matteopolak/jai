# APK file views and iteration

The reviewed Android/Toolchain loader/entry/ownership contract is implemented in
internal/archive/android-apk.jai. Canonical Android_Apk/Android_Apk_Entry layouts
retain borrowed filepath and directory filenames, a complete owned file buffer,
separate owned Zip_Directory storage and section views into the file. Deinit frees
both ownership groups and zeroes every byte, including default-true loaded flag;
repeated deinit is safe. No API or cryptographic validity is inferred from legacy
tests. Signing-block magic is the reviewed immutable string constant.

The loader consumes actual ZIP32 files through the public directory/File APIs.
It finds EOCD including a final comment, validates section arithmetic/signatures,
and partitions optional signing marker/adjacent sizes with checked bounds. The
is_signed flag means the marker exists; an empty marker-only block is deliberately
accepted without claiming signature validity. Invalid files diagnose/assert;
this is not a recoverable parser result API. Unsafe unchecked input accesses from
the reviewed behavior are replaced by explicit bounds diagnostics.

The public for_expansion yields entry values/index, supports reverse iteration
and rejects pointer iteration at compile time. Payload offsets include local
filename/extra lengths; method and sizes come from the local header, filenames
borrow the separate directory buffer. The iterator checks complete-file state,
local signature and payload bounds. Section reporting uses independently written
labels and real byte lengths; no fabricated signature/verification result.

`python3 -B tools/check_portable_apk.py` creates independent Python ZIP fixtures,
adjusts local-only alignment and adds a marker-only block; Python ZIP/CRC reads
validate both before Jai consumes them. Six interpreter/native Mac O0/O2 runs
verify ownership/views, three entries including compressed/empty/aligned data,
payload offsets, forward/reverse iteration, section reporting and zeroing cleanup.
Nine genuine malformed-size/missing-file runs assert, and POINTER compilation
rejects. Scoped jailint -D warnings and repository jaifmt/--check pass.
Evidence: target/apk-load-red.log and target/apk-workflow.log. Native other-OS
execution, actual SDK/device APK generation and APK cryptographic signing/verify
remain incomplete. This checkpoint has no combined Mac baseline rerun.
