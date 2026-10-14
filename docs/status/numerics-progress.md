# Numerics current progress

Implementation checkpoint ee5c32a integrated canonical Simp/default/contextual
types, explicit numerical precision, real font metrics and Texture storage.
The current follow-up removes superseded fixtures/tool repairs, fixes UI decimal
rounding/format precision and ignored capacity failures, adds real alternate
Type_Indicator coverage, handles canonical signed/fractional wheel events once
per eligible region/frame, and expands the independent oracle to 3,572 assertions.
These changes are reviewed and locally verified; the cleanup commit is pending.

Latest actual evidence:
- Canonical suite 126/143: all twenty programs pass interpreter/native O0/O2;
  numeric/oracle/public-contract/overflow cases run in actual WASM.
- Native corrective 25/25 without fixture imports. Includes native cursor lifecycle
  and explicit diagnostics; the generic reproducer remains a blocker.
- Full source-built jaifmt --check on 62 owned files: zero changes/errors/ignored.
- Scoped jailint -D warnings: zero findings; rejected augmented call not fully linted.
- Generators byte-idempotent; owned staged production bytes identical.
- Manifest artifacts/canonical-numeric-final-manifest.json uses independent producers
  and empty repairs. Old failed/fixture/tool evidence retained, never completion.

Current failures: thirteen UI-containing WASM program builds plus WASM target
check need a reviewed native Window_Type/Input contract; Windows full-target
(default/x64) reaches the Simp filename-font/File gate; macOS x64 misses
POSIX.itimerval. Direct float32 intrinsic interpreter semantics and generic
using-base restriction are original compiler reproducers. No peer writes or
public shape changes bypass them.

Resolved by refreshed owners during this pass: AppKit Window_Type import,
scalar hashing/canonical Input, and WASM formatting/parsing host imports. Actual
core WASM now imports standard WASI only. Production UI delegates Clipboard to
the canonical owner; isolated pasteboard tests never modify the user clipboard.

Commands/results/current limitations are in numerics.md, numerics-deviations.md
and numerics-dependency-handoff.md. Next coordinator step: integrate the local
checkpoint, inspect deviations, apply producer-owned target/compiler fixes and
run native window/input/GPU acceptance plus full corpus/CI externally. Issue1
event-pump work is explicitly not owned here. No quarantined integration data,
vendored library bodies, reference sources/binaries, auth, subagents or publication
were used.
