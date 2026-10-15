# Portable producer verification

This worker's new tests live in `tests/portable-stdlib`. They test reviewed public
declarations and independently constructed behavior, native ABI, or general
compiler regressions. They do not derive requirements from inherited stdlib
tests. The separate `tests/stdlib-contract` fixtures used by the runner are new
reviewed-spec tests. Full corpus and production integration remain coordinator
gates. Audio and developer tooling are excluded from new implementation work.

Prepare the NEW dependency composition and execute host interpreter/native tests:

```
python3 -B tools/check_portable_stdlib.py --posix-root ../bindings/stdlib/POSIX --hash-root ../foundations/stdlib/Hash --native --check-target linux/x64 --check-target windows/x64
python3 -B tools/check_portable_time_foundation.py
python3 -B tools/check_portable_meow_integration.py
python3 -B tools/check_portable_windows_utf8.py
python3 -B tools/format_portable_stdlib.py --check
python3 -B tools/format_portable_stdlib.py --lint
```

All compositions write only this checkout's `target/`. Current portable MD5/Meow
sources replace the shared Hash snapshot copies in that composition. Lint maps
owned stdlib paths to byte-identical files inside the configured library root;
private-import restrictions remain enabled. The parameterized Basic fixture
requires the NEW foundations composition and is checked separately there.
Generated facade/load-list changes normalize with jaifmt and regenerate twice.

The latest host suite passes 99 positives in interpreter/native, 23 expected
runtime faults in both modes, eight original compile-negative checks, SMTP,
interprocess channels, parent cleanup, native startup options and selected target
checks (`target/time-checkpoint-suite.log`). Two additional MPEG constant-write
probes now reject with the current compiler (`target/mpeg-promoted-negative.log`)
and are promoted unchanged into the required negative list, bringing it to ten.
The full runner result predates that promotion; it is not a ten-negative rerun.
NEW-foundation time tests pass interpreter/native O0/O2 and Windows CPU body
checks; the configured facade/private root/fixture pass strict lint separately.
Both NEW Meow tests pass interpreter/native x64, including the 317 C-produced
vectors. Windows_Utf8 checks both CPU bodies; Windows runtime remains unexecuted.

All 306 owned Jai files pass formatting/check. Full **strict lint fails** with
the rebuilt current source compiler/linter. Evidence is retained in
`target/time-checkpoint-strict.log`; no incomplete-compilation allowance or rule
suppression was added. These are distinct unresolved categories:

- Random module/private standalone roots: eager checking reports Context layout
  before `#add_context`; actual public behavior tests execute successfully.
- Socket module/private roots and loopback: eager checking rejects array-field
  element type reflection; actual loopback execution passes. Standalone native
  declarations also report an enum forward member `ADDRCONFIG` unresolved.
  These need general compiler/linter investigation, not facade special cases.
  Original field-array-element-type and enum-forward-member probes now reproduce
  both errors in ordinary -check and interpreter setup too; these semantic gaps
  are not confined to eager checking.
- Autorun/BuildCpp compile-time tool fixtures: linter compilation aborts, while
  the configured execution runner succeeds; exact linter phase/configuration
  support needs investigation.
- IPC reader/writer and startup build fixtures require runner-provided
  `CHANNEL_NAME`/`OUTPUT_PATH`; standalone lint does not supply those settings.
- Compile-negative fixtures intentionally fail semantic checking. Their checked
  rejection tests remain mandatory, and they remain formatted. The lint runner
  currently includes them and reports incomplete compilation rather than calling
  them lint-clean. A principled negative-fixture policy still needs integration.
- The pending workspace-hook reproducer still fails compile-time execution and
  remains evidence of unsupported compiler behavior.

This investigation found and fixed real source defects separately: a Unicode
mask literal had the wrong array element type, and Basic/Adpcm facades exposed
aggregate fields as nonexistent module globals. Reviewed nested fields remain
available; no compatibility export was invented. New public assertions preserve
mask shape/value and absence of the five invalid Adpcm exports. Unused locals
were renamed narrowly; no operational errors were discarded to satisfy lint.

`check_portable_meow_integration.py` now uses only NEW `meow.jai` and
`meow-vectors.jai`; its obsolete inherited-test invocation was retired. The
integration owner handles the repository-wide legacy test migration.

Machine_X64 is checked separately with a source-built x64 jailint host because
the reviewed module is x64-only. Its compile-time fixture actually executes
CPUID/masks in that interpreter; native C comparisons execute O0/O2 under the
focused machine runner. The lint driver attempts the ordinary, configured-time
and x64 groups even when one fails, and still fails the total gate. There is no
architecture fallback or suppression. On this ARM64 macOS host build the x64
linter with --locked -p jailint --target x86_64-apple-darwin into target/compiler.
