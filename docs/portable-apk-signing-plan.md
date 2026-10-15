# APK signing implementation plan

The approved assignment is implemented inline, with no peer checkout reads or
subagents. Public records follow the reviewed Android/Toolchain contract exactly.
The existing archive/android-apk partitioner remains the only APK/ZIP parser.

1. Create independent Python-standard-library framing and chunk-digest fixtures.
   Test byte order, nested lengths, section boundaries, 1 MiB boundaries, EOCD
   normalization, malformed prefixes, trailing data and borrowed-view lifetimes.
2. Add apk-signing-model.jai with canonical records and documented v2 ID.
3. Add apk-signing-framing.jai with checked internal container and payload readers.
   Parse transactionally; release allocated arrays on failure. Public cursor
   adapter awaits the coordinator's exact framing/consumption clarification.
4. Add apk-signing-digest.jai using canonical sha256 and existing EOCD helpers.
   Hash each section separately, restore the original EOCD offset with defer,
   and reject SHA512 through the assertion contract.
5. Add independent signing-block serialization and APK assembly. Reuse caller
   signature/certificate/SPKI bytes; do not introduce a second crypto provider.
6. After exact clean compiler/provider handoffs, source-build into assigned T7
   storage; run interpreter, native Mac O0/O2, strict lint and formatting. Resolve
   actual failures without compiler workarounds; publish minimal reproducers.
7. Complete public reader and sign/verify orchestration only against reviewed
   cursor/mismatch semantics and named committed provider APIs. Validate actual
   native crypto and independent SDK vectors; record absent SDK/device coverage.
8. Commit owned files with Conventional Commits and publish load/export handoff
   plus scoped missing/partial/verified inventory. Shared facade stays owner-owned.

Compiler requirement 89560db9 is satisfied by authorized source archive 934a6918.
The matching complete production base and canonical provider47bf26e/d16943e were
supplied as named clean archives. Existing staging tools read unassigned peer
checkouts and were not used. New checks stage only named local dependencies plus
assigned current production source. Owned implementation and host validation are
complete; shared facade/native packaging and Android SDK/device/other-native
platform verification remain separately owned gaps.

Public wire reference: [Android APK v2 format](https://source.android.com/docs/security/features/apksigning/v2).
The independent fixtures use little-endian lengths, one signer and SHA256 chunks.
These fixtures demonstrate wire/digest behavior, not Android device acceptance.
