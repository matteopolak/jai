# Portable standard library implementation

The reviewed public specifications in `docs/specs/stdlib/modules` are the API
oracle. All work is inline in this checkout. No reference implementation or
binary is an input. Extensions and the public corpus remain unchanged.

Use one dependency-light `stdlib/prelude/module.jai` containing the specified
bootstrap records. Public module folders contain canonical records and exact
public aliases; private algorithms live under `stdlib/internal` by subsystem.
Mutable public state stays in its facade unless a true entity reexport is
verified. Never replace an unsupported operation with a successful stub.

Sequence:

- [ ] Bootstrap metadata and Runtime_Support output, allocation, context and startup.
- [ ] Basic arrays/allocation, Memory overlap, String and Reflection foundations.
- [ ] Allocator families and temporary storage lifetime.
- [ ] Collections, hashing, sort, random and codecs.
- [ ] Files, paths, processes, threads and sockets.
- [ ] Toolchains, build, graphics, input, audio, fonts, resources and helpers.
- [ ] Review every owned module against its spec, including conditional exports.

For each increment, add spec-derived caller tests before implementation, run
them against a compiler built from the authorized Rust sources, review the diff,
update the module ledger and questions, and commit. Interpreter/native and
target checking are separate evidence; do not infer one from the other.

The module ledger lists every spec page, including reserved ownership and
unimplemented scope. The coordinator owns full integration/corpus/release checks.

Wav_File increment: use byte reads rather than casting potentially unaligned input.
Keep packed public metadata in internal/audio/wav.jai and explicit facade aliases.
Check RIFF/WAVE, bound parsing by both input and RIFF length, advance chunks with
even-byte padding, borrow the first data chunk, and accept PCM/IMA metadata only.
Test PCM, ADPCM extensions/fact, odd unknown chunks, clamped data, and malformed
headers before implementation; then run interpreter/native/target checks and lint.

Remap_Context increment: cache immutable copy plans keyed by foreign metadata
pointer, under a CAS lock. Flatten the leading base aggregate and match stored
field names/sizes, skipping constants and overlay aliases. Copy only validated
extents into a default own context and restore its context_info. The expansion
requires caller-scope push_context,defer_pop, currently blocked by the compiler
reproducer pending/macro-push-context.jai and withheld. Cache storage uses the default own
allocator, so foreign allocator fields cannot interfere with building a plan.
Verify default preservation, shallow pointers, reused plans and lexical restore.

System increment: implement Unix account lookup through reentrant POSIX calls,
copy exposed text into temporary storage, preserve errno's actual entity alias,
and read machine/executable paths through native APIs. Mac processor queries use
documented sysctl selectors; Linux initially falls back to online logical count
where detailed topology/performance selection is unavailable. Withhold CPU
counter and Windows APIs until their real backend is supplied. Tests exercise
real OS results, lookup failure and the selected target declarations.

Text_File_Handler increment: share a byte-line reader across memory/file handlers
and list/table helpers. Keep source remainder separate from owned file bytes;
restart releases only owned bytes and preserves the sticky failure flag. Parse
decimal bracketed version lines when enabled, strip one-byte comments, and track
physical lines. Return independently allocated helper strings so handler teardown
cannot dangle them. Record unresolved ownership/version whitespace contracts.
