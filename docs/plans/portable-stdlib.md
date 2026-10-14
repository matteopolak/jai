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
