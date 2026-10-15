# X11 and Android remaining helper status

Historical checkpoint before the 14:54 UTC review. The ten helper questions
below are now resolved and all ten names have implementations; see
[current implementation and evidence](x11-android-helpers.md).

After `0488c78`, the complete synchronized X11 and Android reviewed pages and
the worker inbox were rechecked. The supplied pages resolve clipboard cleanup,
but still do not specify the remaining ten helpers' behavioral policies. The
per-procedure filtered request is in
[native-binding questions](../specs/stdlib/native-bindings-questions.md).
There are no new public implementations in this checkpoint: X11 three and
Android seven remain missing. Enabled telemetry fourteen remains blocked by
the confirmed unavailable matching commercial SDK ABI. No alternative ABI,
guessed compact-glue association, or success stub was introduced.

The focused verification driver now supports `--existing-stdlib`: it copies an
existing independent local baseline, refreshes only owned bindings, and never
discovers peer checkouts. `--foundation` and this option are mutually exclusive.
The report records the baseline path and hashes all staged Jai sources. This
permits repeatable checks under the latest stricter producer isolation rule.

A real test-selection bug was corrected: the private-unit fallback overwrote
the X11 clipboard and D3D byte-copy owners with DXC. Module-filtered runs could
therefore omit those native tests. Selection now derives the owning module from
the registered private placement. No assertions were removed. The old broad
combined run included these tests because it had no module filter; its existing
green evidence is not evidence that the ten missing APIs are implemented.

Current evidence:

- `.work/x11-android-current.json` preserves the initial focused failures.
- `.work/x11-android-current-retry.json`: 14 source passes, **two real X11
  public-export failures**, ten unsupported desktop imports, ten privacy passes,
  twenty unsupported privacy checks; host clipboard build and execution pass.
  The public-name checks fail on missing `enable_drag_and_drop` on both Linux
  CPUs. They stop at that diagnostic and do not establish the other missing
  names. The coverage ledger still lists all three.
- `.work/x11-clipboard-cpus-current.json`: actual x64 and ARM64 Mac clipboard
  ownership/canary/idempotence builds and executions pass. These are private
  allocator tests; native Linux/X server execution is still required.
- The current source-built compiler rejects `-os android` with exit 2 and
  `unknown OS android`. Android Jai source/ABI/device runtime remains unverified;
  desktop unsupported imports are not Android passes.
- All 71 Python regressions pass, including staging isolation and private test
  ownership. Owned X11/Android Jai formatting checks pass; strict production
  Linux-target X11 lint and complete generation `--check` pass. No Jai source
  changed in this checkpoint. Android-target lint cannot be claimed while that
  target is unavailable.

Reproduce the focused check (its two missing-export failures are expected
remaining defects, not waived gates):

```sh
python3 tools/native_bindings/verify.py \
  --compiler .work/target-producer-refresh/debug/jaic \
  --existing-stdlib .work/runs/bindings-mac-combined-current-4908/stdlib \
  --module X11 --module Android --runtime \
  --report .work/x11-android-current-retry.json
python3 -m unittest discover -s tests/native-bindings -p 'test_*.py'
```

No rpmalloc profile expansion, performance benchmark, native source patch,
public facade change, or Extensions change was made. The next implementation
step requires the specific public helper contracts requested through the
filtered question ledger; SDK definitions alone cannot determine these Jai
convenience policies.
