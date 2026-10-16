# HTTP native setup repair — platform-io

Owned shared files: HTTP conformance workflow; tools/http_native.py,
tools/test_http_native.py, tools/http_conformance.py, tools/io_stress.py;
only archive-root relocation in tools/build_native_libs.py; the linked HTTP
setup report, this status and matching deviations/ready manifest. Integration
alone owns the Git index/commit. No Metal/spec.py/LSP/interpreter/stdlib changes.

Confirmed harness cause: filtered native cases trigger all native libraries when
unconfigured, pulling SDL3 into HTTP CI without its SDKs. Child-only provider
configuration does not reach parent echo-server compilation. The shared HTTP
setup now builds the full pinned mbedTLS contract only, checks both archive and
dynamic adapter plus license, and configures all parent/child commands. The
workflow stages the same provider at job scope. SDL3's profile and independent
passing workflow remain intact; no selected mode/assertion/timeout is weakened.

Real T7 SDK build found an additional per-entry archive move/AppleDouble race.
Original tiny archive reproduces it; whole-root directory relocation fixes it
without skipping metadata/errors. This is the only shared builder hunk; integrator
must reconcile it with other native-build ownership explicitly.

Helper-owned cache reuse checks pinned profile/local C inputs/builder and actual
artifact hashes, with rebuild on drift. Explicit complete external providers
retain the caller-owned CLI trust model rather than being called pin proof.

Twelve policy/transport tests, Ruff strict lint, new-tool format checks and actual
workflow actionlint pass. Source-built macOS ARM64 mbedTLS archive/dylib contain
all 37 declared TLS native function symbols. Input/archive/artifact hashes and
original failures are retained in assigned T7/http-conformance. No GUI/fault or
Jai native/interpreter/full HTTP runtime runs were started during the lease.
Mac/Linux normal CI conformance/stress rerun remains mandatory. Root's failed
38887877528 and independently passing SDL3 38887877535 evidence are preserved.

See [setup repair and limitations](../tools/http-native-setup.md). Exact owned
source hashes are in http-native-setup-ready.json. No staging/commit/remote action
has been performed by this worker; integrate these current shared bytes only.
