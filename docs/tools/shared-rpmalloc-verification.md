# Shared rpmalloc diagnostic checkpoint

The production allocator now carries `ENABLE_ASSERTS` and
`ENABLE_VALIDATE_ARGS` through the SDK, callback, ownership and checked-call
boundaries. Each selection uses its own real C SDK domain. Initialization checks
the SDK's actual post-preprocessing option bits before changing ownership, so
stale native libraries cannot silently serve a different import instance.

Integration independently ran:

```
python3 -B tools/native_bindings/verify_rpmalloc_diagnostics.py \
  --compiler <integration-target>/debug/jaic \
  --jailint <integration-target>/debug/jailint \
  --formatter artifacts/shared-integration/jaifmt \
  --vendor <integration>/native-inputs/rpmalloc-original \
  --output-root <integration>/rpmalloc-required \
  --native-compiler /opt/homebrew/opt/llvm/bin/clang
```

All 25 checks passed on an immutable production capture: interpreter execution,
Mac ARM64 native O0/O2 builds and execution, actual C SDK plus Jai ASan/UBSan
instrumentation, six desktop source checks, seven invalid-configuration
diagnostics, strict context lint, format check and source/SDK identity checks.
Four diagnostic combinations were tested; generated domain counts are not
execution counts. The fixture checks real aligned allocation, resize/data
retention, import storage isolation, failure rollback and caller callback context.
It also checks the reviewed CAPS name `rpmalloc 1.4.4`.

The local receipt is
`/Volumes/T7/codex-builds/jai-cleanroom-01a137eb/integration/rpmalloc-required/rpmalloc-diagnostics-k38yn_xb/verification.json`.
The compact durable result is [shared-rpmalloc-verification.json](../status/shared-rpmalloc-verification.json).
The source capture and current rpmalloc files matched after verification.

The independent read-only SDK generation check also passed: 35 functions,
40 field probes and six native C header targets. Its first invocation against
the diagnostic capture failed because that capture omits generated test files;
the missing `rpmalloc_sdk_probe.c` was a test-construction omission. The same
check against the actual unchanged shared outputs passed. No generated fixture
or production declaration was repaired for the check.

Cache-disabled profiles are generated but were not exercised in this run.
Adaptive cache, huge pages, unmap/unlimited options, page advice and nondefault
numeric build settings retain their explicit implementation restrictions.
Windows/Linux checks compile source only; native execution remains unverified.
This result does not replace the failed complete workspace/catalogue measurement.
The correct native builder is `tools/native_bindings/build_rpmalloc.py`; legacy
native-cache libraries lack the mandatory option identity symbols. Matching LLVM
23 native compilation is required for the sanitizer runtime; an earlier producer
link failure is retained, rather than suppressed.
