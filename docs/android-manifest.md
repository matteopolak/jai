# Android binary manifests

The public `Android/Toolchain` facade loads `manifest-types.jai` and
`manifest-api.jai` after the canonical project configuration. Three independent
private helpers implement the wire reader, writer, and system-zlib raw DEFLATE
adapter. No duplicate ZIP/APK parser or configuration record is introduced.

The writer emits Android binary XML with a UTF-8 string pool, resource map,
Android namespace, package/version/SDK metadata, permissions, features,
application label/theme, application metadata, and an exported native activity
with library metadata and launcher intent. Orientation uses the reviewed public
enum mapping. VR and passthrough settings add the corresponding Oculus metadata
and VR activity category. Attribute resource IDs and the ABI records follow
[Android's official ResourceTypes.h](https://android.googlesource.com/platform/frameworks/base/+/refs/heads/main/libs/androidfw/include/androidfw/ResourceTypes.h).

The reader supports UTF-8 and UTF-16 string pools, namespaces, resource IDs,
start/end elements, typed attributes, and CDATA chunks. It checks chunk bounds,
string lengths, UTF encoding, string references, attribute sizes, matching
element/namespace stacks, and one document root. Styled string pools and unknown
chunks are rejected. CDATA is validated but has no representation in the
reviewed public element model. Namespace declarations other than Android are
validated but only Android's namespace is retained in the public record.

Memory reads borrow `raw_data`; decoded strings and attributes are owned by the
result and released by `deinit`. File/APK reads own their raw data too. Failed
reads release partial allocations and return an empty result. Memory writes
return owned serialized bytes; builder writes append. For independently
unspecified override behavior, a nonempty `android_manifest` passed to the binary
writer must already be valid binary XML. Plain textual overrides remain handled
by project generation. UTF-8 writer strings must fit the format's 15-bit length.

APK reads reuse canonical `apk_load` and iteration. Stored and DEFLATE entries
are supported and CRC checked. Raw DEFLATE calls the system zlib documented by
the platform SDK `zlib.h`; this requires `libz` on Mac/Linux and `zlib1` on
Windows. Windows runtime dependency availability has not been verified. There
are no compiler exceptions, fake-success paths, suppressed warnings, or stubs.

`tools/android_manifest_fixtures.py` creates an original independent UTF-16 AXML
fixture and stored/deflated ZIP containers with Python's standard `zipfile`.
`tools/verify_android_manifest.py` runs the complete fixture in interpreter and
Mac arm64 native O0/O2, format checks, and warnings-denied source/lint checks for
Mac arm64/x64, Linux x64, Windows x64/arm64. All 16 checks pass. Truncation checks
exercise every byte cut with original and adjusted document-size headers.
Non-host targets are source-only. Android SDK/aapt2 and device execution are
unavailable, so SDK acceptance/device installation are not claimed.
