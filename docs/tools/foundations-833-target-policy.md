# Foundations 833 target-guard and runtime-policy repair

This batch corrects three reviewed target expectation families and three exact
runtime capability entries. It changes no compiler, binding, native provider,
application or public facade. The prior catalogue128 and WASI output-buffer
handoffs remain separate and unchanged.

## Reviewed target checks

The public facade is named `macOS`, as in the reviewed module specification and
actual directory name. Its guard now diagnoses at macOS/module.jai. Aftermath
likewise rejects unsupported operating systems at its own facade instead of a
downstream Windows import. NVTT's reviewed platform coverage is Windows, Linux
and macOS; the old x64-only return-bridge diagnostic no longer describes the
current implementation.

| Module | Required positive source checks | Required guard rejections |
| --- | --- | --- |
| macOS | Mac x64/ARM64 | Linux x64/ARM64, Windows x64/ARM64, WASM |
| nvidia_aftermath | Windows x64/ARM64 declarations | Linux x64/ARM64, Mac x64/ARM64, WASM |
| nvtt | Linux, Mac and Windows, each x64/ARM64 | WASM |

All 21 imports run with `-check -no_dce`. Ten positive checks include every
formerly rejected NVTT ARM branch. Eleven negative checks require the precise
reviewed facade guard and message. An arbitrary error, timeout, missing library
or unexpectedly successful negative cannot satisfy the check. Only those three
families in tests/stdlib-targets.txt change; all other rows and skip entries are
byte-preserved.

The checks use the frozen previously source-built foundations compiler, whose
hash and source provenance remain recorded. This is current canonical-library
source evidence with an explicitly pinned compiler, not a new moving-HEAD build
or a replay of the cancelled historical matrix. The admitted matrix JSON lists
failed test names, not the full module diagnostics. No historical gate is cleared
from that names-only evidence.

These are declaration/body checks, not proof of native SDK binaries or ABI on
every target. In particular, the Aftermath specification describes its native
Windows x64 surface; a Windows ARM64 source check does not establish an ARM64
vendor library distribution. Actual configured native SDK tests remain required.

## Three remaining capability entries

The overwrite-allocator contract exercises a reviewed public Mutex field and
native Thread API. The Sound_Player pure contract does not open an audio device,
but its imported reviewed public synchronization globals still depend on native
Mutex/Thread types and its platform backends cover native operating systems.
The native HTTP-date contract calls http_date_now, which is loaded only outside
WASM. These exact cases now require native modes and remain required there.

This does not make every audio, allocation or HTTP program native-only. The
unchanged ADPCM constants/saturation, explicit-seconds HTTP date and resource-wire
controls remain selected and source-check successfully on WASM. The distinct
http-date-now-wasm-negative still requires its precise compilation rejection.
No fake Mutex, host clock, provider or application argument is introduced.

## Admitted runtime reconciliation

The exact centrally admitted JSON contains 406 historical failures from source
pin 833e8f22d7418f2823665dbf0b5241cdcef85fab. Every row is retained in the
source-hashed external receipt with its original diagnostics, mode and source
verification qualification. Current catalogue projection gives:

| Historical job/host | Explicit unavailable policy | Required negative | Required positive |
| --- | ---: | ---: | ---: |
| 117201496943 / Mac ARM64 | 84 | 2 | 42 |
| 117201496995 / Linux ARM64 | 84 | 2 | 51 |
| 117201497328 / Linux x64 | 84 | 2 | 55 |

These numbers are selection dispositions, not execution results. Historical
failures remain failures, and projected rows have passed=null. Actual CI
subprocess argv was not recorded. Current source hashes are not represented as
immutable833 hashes; missing historical contract paths are resolved only through
current catalogue metadata with that qualification.

Real native provider, generator, graphics, JSON and compiler failures remain
required. Linux x64 lang-asm reports a SIMD operand constraint in add_regs;
rules-simd-asm reports its asm.25 assertion. Neither is covered by the named
corpus x64/Vulkan human deferrals. The Long_Double formatter failure also stays
required, with its exact accepted-kind/conversion question recorded
[separately](../specs/stdlib/foundations-target-policy-questions.md).

The network owner's proposed HTTP termination metadata and explicit-exit-code
hunks remain separate. LSP/browser consumes the canonical mode projection;
integration owns the common native_verifier API and smoke-provider setup.
No failed diagnostic is promoted to unavailable by this batch.

## Verification and configuration

Run `tools/check_foundations_target_guards.py --compiler <jaic> --output
<new-directory>` for the 21 focused checks. The output directory must be new;
all actual commands, diagnostics and source hashes are retained. Python policy
regressions verify exact negative boundaries and portable/native selection.
The scoped [handoff](../status/foundations-833-target-policy.json) records hashes
and evidence. Integration owns the coherent full matrix/corpus/native/browser
replay; this batch performs no uncoordinated broad gate.
