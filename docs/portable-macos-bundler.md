# Bundle and property-list helpers

`MacOS_Bundler` now exports every reviewed procedure. Independently authored
internals separate portable XML property lists from native bundle/tool operations.
All public builder parameters use the canonical Basic String_Builder entity.

The XML helpers emit a plist dictionary, escape five XML punctuation characters
and preserve carriage returns through character references. Strict UTF-8/XML 1.0
validation rejects illegal characters. Key/value writing supports strings,
booleans and 1/2/4/8-byte integers. Finite floating-point values use delegated
Basic `formatFloat`/`print_float` in shortest mode when those new foundations are
integrated. Our baseline lacks these exports and returns false for float input;
it does not fabricate output or invoke an unsupported formatter. Unsupported
value kinds, invalid text and nonfinite numbers return false before appending.
Void key/string helpers assert on invalid text. Allocation failure diagnoses
through an assertion rather than silently truncating output. The Any writer
does not invent array/dictionary/data/date conversion policies.

On macOS, bundle creation makes `Contents/MacOS` and `Contents/Resources`, copies
the executable preserving mode, copies resources and optionally writes Info.plist.
The executable keeps its basename. `.app` is appended when absent. A true contents
option copies the directory's children, including hidden files; false includes the
source directory itself. Existing destinations may be overwritten by native copy
semantics. Results are allocated paths owned by the caller. The subdirectory
helper treats its argument as the complete bundle path. Failure logs diagnostics
and returns empty paths; already-created filesystem contents are retained. No
transactional rollback, signing or notarization is claimed.

Icons with an `.icns` suffix are copied to `Icon.icns`; other images are converted
using the host's sips/iconutil. Conversion creates the five native sizes and their
retina counterparts (16 through 1024 actual pixels), uses a unique staging
directory beside the output, then checks cleanup. Failed cleanup returns failure
even if output exists. Invalid images and missing tools propagate actual failure;
there are no successful dummy icons. Host tools and supported input formats are
runtime dependencies. Non-macOS filesystem/icon calls diagnose explicitly;
portable XML helpers remain usable there.

Exact XML whitespace, supported Any kinds, plist key selection, names/extensions,
copy/symlink/overwrite policies and ownership details need compatibility review.
The emitted bundle plist currently supplies CFBundleExecutable, CFBundleName,
CFBundlePackageType and the optional CFBundleIconFile; completeness for a specific
app remains the caller's responsibility. Relative bundle names beginning with
option-like text have not been verified with the native directory utility.

Format facts follow Apple's official
[Info.plist documentation](https://developer.apple.com/library/archive/documentation/General/Reference/InfoPlistKeyReference/Articles/AboutInformationPropertyListFiles.html)
and native tool interfaces. No Jai library implementation was consulted.
`check_portable_plist_integration.py` stages NEW foundations in our own target
directory and validates actual interpreter/native XML through Python plistlib and
macOS plutil, including finite reals and rejection of nonfinite values. A newly
added foundations basic-context dependency initially failed staging; both plist
and Meow overlay tools now include it, and both checks pass again.

`check_portable_bundle_integration.py` generates an original PNG and script source,
runs the copied executable, validates both resource modes and hidden files, checks
optional plist omission and icon-copy equality, round-trips every ICNS image size,
and checks invalid-image/missing-executable diagnostics plus staging cleanup in
both modes. It only deletes its known original fixture directory. These focused
staged checks do not replace coordinator production/corpus verification.
