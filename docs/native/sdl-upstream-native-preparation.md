# Third-party native dependency preparation

The reviewed NEW2d93 helper patch31fb7dcd is integrated around the current runner's dispositions and reports. Normal source-built crash and audio libraries are prepared before consumers; receipts validate target, source and artifact hashes. Windows uses normal PATH in addition to existing app-local Mesa deployment. POSIX crash static/shared libraries come from one target-validated C object, with existing install-name/SONAME retained.

XML acceptance now parses exactly one complete Passed and Failed summary row, retaining six tests/100 percent passed and zero/0 percent failed. Whitespace alone may differ; missing, duplicate, malformed, changed-count/percentage rows remain failures.

Fourteen helper/configuration tests and scoped Ruff checks pass. Windows workflow actionlint is now clean after repairing six inherited shell findings. Both Linux-host Windows cross jobs install the shared full SDL dependency set, preserving enabled display/audio backends. No application fetch or opaque corpus body was accessed here.

The helper builds audio with its explicit default runtime=False and never passes --test-runtime; it does not execute SDK/device/fault programs. Actual required audio/application/native CI gates remain separate and unchanged. A configuration pass is not native acceptance. The previous sealed2a29 tool/asset receipt remains unchanged; this new crash build recipe must use freshly built paired crash artifacts on its next capture.
