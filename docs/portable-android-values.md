# Android manifest configuration flags

The reviewed Android/Toolchain public surface now implements canonical
Android_Config_Changes (s32 enum_flags) and android_config_changes_from_string(s).
Declaration organization groups display/language and input/network concerns,
with all16 explicit reviewed masks unchanged. No newer SDK fields are invented.
The parser converts SDK pipe-delimited names to an OR mask; duplicates are
idempotent. Empty string means no configuration changes.

Official [activity manifest documentation](https://developer.android.com/guide/topics/manifest/activity-element)
establishes the | separator and exact case-sensitive names. No manifest/SDK/native
Android generation is claimed from this pure host parser.

Unsupported names, empty components and unrecognized separators produce an
explicit error log and assertion. If the assertion handler deliberately continues,
the return is zero, not a partial valid mask. This invalid-input and empty-string
policy is independently designed pending finer public behavior review; reviewed
declarations do not specify error recovery or whitespace normalization. No unknown
flag is silently ignored. Current parser supports exact SDK tokens without trim.
Ask reviewer to confirm empty string, whitespace, duplicates and malformed input
policy before calling those reference equivalence guarantees.

Tests derive expected masks from reviewed explicit values, separately from the
implementation's responsibility-grouped dispatch. All16 individual names, all256
ordered pairs (including duplicates), a normal four-flag activity example and
seven invalid forms pass interpreter/ARM64+x64 native O0/O2. Invalid handlers are
restored before fatal assertions verify complete error counts and no partial
result. Both positive and failure fixtures source-check Linux/Windows x64/ARM64.
Focused strict lint and owned formatting check pass. Run
python3 -B tools/check_portable_android_values.py; evidence in
target/android-config-flags-red.log and android-config-flags-final.log.
No inherited tests corrected; no blanket lint exclusions or fabricated platform
success. Remaining manifest writer/parser/project APIs are genuinely unfinished.
