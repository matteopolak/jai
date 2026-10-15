# Canonical Android signing model handoff

The three reviewed shared types are defined once in
stdlib/internal/android-toolchain/signing-model.jai and loaded directly into the
Android/Toolchain module scope: Android_Signing_Key_Kind,
Android_Signing_Key_Signature_Algorithm and Android_Signing_Key. Project/config
workers should use these exact public types rather than redeclare a signing model.

Enums retain reviewed ordinal order/defaults. The key record retains kind first,
then the union of promoted JKS path/alias/password, direct certificate/key paths
and static certificate/key bytes. All arms share actual storage. Strings are
ordinary views supplied by callers; these declarations open no files, access no
credentials, generate no keys and claim no signing function. The default record
is JKS with empty strings. Reflected public type names are canonical.

`python3 -B tools/check_portable_signing_model.py` passes interpreter/native Mac
O0/O2, exact names/defaults/enum values/promoted fields/union pointer identity,
Linux/Windows both-CPU source checks and strict lint. All new Jai files pass
repository formatting/--check. Evidence: target/android-signing-model-red.log and
android-signing-model-final.log. Initial cross-target staging errors were missing
NEW File backend/Windows-text dependencies, not a model defect; one shared
portable_file_stage.py now composes that real producer closure read-only into
target. No platform guard or test oracle was weakened, no API shim supplied.

Android project/config/manifest/SDK/build/install/helper names are explicitly
transferred to generator-names; exact snapshot is
docs/status/portable-scope-transfers.json. Portable retains these shared signing
types and crypto/JKS, existing ZIP/APK/ASN1/ADB primitive implementation. Facade
load-list integration belongs to coordinator; no peer checkout was modified.
