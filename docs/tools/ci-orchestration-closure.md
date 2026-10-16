# Normal CI orchestration closure

Integration owns ci.yml dependency provisioning and shared runner platform/input wiring; platform-io owns the Windows cross runner, SDL3 owns the third-party runner. Root owns remote logs/auth/push and the full-workspace native lease. No local native/GUI/fault, package installation or benchmark execution is authorized during that lease.

The first companion adopts the exact Clipboard three-file/manifest checkpoint. Nine configuration tests, Actionlint and Ruff pass. Rust component setup is isolated and explicitly pinned; actual Linux provisioning and real X11/runtime/package outcomes require normal CI.

Linux compiler/native, stdlib-runtime, third-party and sanitizer jobs now all call tools/install_ci_native_linux.sh. Its package list is the union of existing normal-CI inputs and the complete reviewed SDL3 workflow list, including XTEST, X11/Wayland, ALSA/Pulse/PipeWire, DRM/GBM and libdecor development inputs. SDL feature defaults remain enabled. Six configuration tests pass without apt or native execution. The initial regression caught the single-line sanitizer install omission; that red log is retained and the same test passes after adding the shared installer.

Full ci.yml Actionlint remains RED with the same inherited fetch_upstreams SC2046 warning (one before/after, no introduced diagnostic). It is not suppressed or labelled green; the SDL3 owner coordinates that runner invocation. No source/backend failures are waived. Initial producer0/9 and native sanitizer failures remain historical actual failures; subsequent runner repairs will be documented separately, never relabelled as already passed.

Pending: bindings unsupported --stdlib/--native-libs invocation and genuine production source/provider wiring; Mac-only tooling evidence selection; empty coverage record construction; sanitizer canonical platform/fixture inputs, actual GL_PROBE and caller font setup, real rpmalloc ABI8 native closure. Missing runtime/native evidence remains required, not passed. Sanitized source defects go to root, not source workarounds in runners.
