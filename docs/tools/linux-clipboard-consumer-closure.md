# Linux clipboard provider in general CI consumers

The ae6 Linux ARM stdlib job reported native links missing `portable_clipboard`. The dedicated clipboard package job built the helper, but the general workspace, stdlib runtime, application and sanitizer jobs did not. Installed X11 headers alone cannot supply our independent implementation.

All four normal POSIX consumer jobs now invoke `tools/build_portable_clipboard.py --output target/clipboard-native` on Linux, after the complete third-party SDK is available. They add the real output directory to the normal `JAIC_NATIVE_LIBS` search alongside that SDK. Workspace/application preparation explicitly builds the full SDK before setting this variable: setting only a clipboard directory would suppress the runner's existing SDK preparation and create another closure defect. Runtime/sanitizer preparation preserves its previously composed audio, window and ABI8 paths. Mac jobs do not invoke the Linux builder.

The builder retains its real static/shared output, X11/pthread linkage, source hashes and package receipt. No fake provider, foreign-host native claim, feature disable, fixture selection, assertion, timeout or failure gate changed. The dedicated Xvfb/package runtime remains required.

Validation: the new four-job provisioning guard failed in all four job subcases before wiring and passes after it. Both existing developer-provider configuration tests pass; scoped Ruff and `actionlint .github/workflows/ci.yml` pass. Actual Linux builds and runtime replays remain CI-required. This CI-only companion leaves product source `d9f32f30` and its matching tool/native receipt unchanged; its running Mac catalogue uses that exact product snapshot.
