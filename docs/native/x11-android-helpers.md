# Reviewed X11 and Android helpers

The 2026-10-15 14:54 UTC reviewed contracts resolve the earlier ten helper
questions. All three X11 names and all seven Android names now have authored
implementations. The exhaustive ledger has zero unresolved declarations in
these modules; the fourteen unresolved enabled telemetry declarations still
require the unavailable matching commercial SDK ABI. This is source/API
implementation progress, not a claim of Android device or Linux X server
execution. Objective_C's seven and rpmalloc's eighty existing partial entries
remain unchanged.

X11 initialization opens the default connection once, populates WM, selection,
XDND, `JXSelectionWindowProperty` and BMP atoms, attempts input-method/context
setup, creates the invisible cursor and resets drag state. PNG/JPEG atoms are
left untouched. Connection/thread/cursor creation failure stops the process
rather than calling Xlib through a null handle; the reviewed signature has no
failure result or teardown. Repeated initialization preserves the connection.

DND replaces the window's atom list and `drop_info.user_typelist`, publishes
protocol version 5 on the target and every ancestor through the root, and frees
each native query's children with XFree. It retains the allocator used for the
module's list so a later replacement frees it in the correct domain. That
allocator and its data must remain alive while the module owns the list.
Selection filtering tests exactly the event type and pointed-to requestor;
selection/target are deliberately not additional filters. Public layouts and
global storage identities are unchanged; allocation metadata is file-private.

Android generation now associates the full native-port record with the Jai
command bodies and the compact compatibility view with external glue. The
private command core consumes one pipe byte, returns -1 on a failed read,
releases prior saved state, and applies synchronized window/activity/save-state
transitions around caller processing. The facade handles actual NDK input-queue
detach/attach and configuration updates. A C-ABI compact pre-command delegate
also records receipt of the first window for finish behavior. Compact pointers
must be borrowed from the external runtime's actual native allocation; a
standalone compact stack record is not SDK storage. No public pointer is
reinterpreted as an independently allocated larger record.

Asset helpers use the initialized activity's asset manager, close every opened
asset/directory, strip exactly one leading `./` from file names, and distinguish
file existence from nonempty directory iteration. Missing app/activity state
asserts and cannot continue through null handles if an assertion handler returns.
Finish requests activity destruction and processes looper sources before exit
when no initial window was received; after an initial window it exits with zero.
The native-port and compact pre-command paths both retain that history.

Logging uses the reviewed flag precedence and section-name/`Jai` tag, ignores
`data`, creates terminated copies of length-delimited strings, calls the
canonical Runtime write-buffer flush with `force=true`, then invokes the actual
NDK log function. The reviewed surfaces expose no separate discard operation;
the question ledger asks whether a Runtime-owned discard hook is needed for
literal discard semantics. This integration substitution is documented in the
deviations report, not hidden as a new public API.

The command semantics were independently implemented using the reviewed page
and complete official public native C glue sources pinned in
[android-glue-sdk-inputs.json](android-glue-sdk-inputs.json). Files are fetched
from `<repository>/+/<revision>/<path>/<filename>?format=TEXT`, base64-decoded,
and checked against the recorded SHA-256. They reside in the owned
`.work/vendor/android-native-glue` cache. No SDK source patch or proprietary
implementation was used.

Verification is deliberately separated:

- `.work/x11-android-reviewed-final.json` runs Linux x64/ARM64 public-name,
  initialization/DND/predicate and existing X11 source regressions, private
  command source tests on supported POSIX desktops, privacy checks and host
  native tests. Android desktop imports remain unsupported.
- `.work/android-core-native-final.json` records real x64/ARM64 Mac execution
  plus host address/undefined sanitizer execution of the command/policy core:
  native pipes, EOF/EBADF, pthread operations, saved-state frees, window/state
  ordering, canaries, exact one-prefix removal, log priority precedence and tags.
  No fake Android SDK success is used. Explicit-target sanitizer builds were
  rejected by the compiler; the successful sanitizer run uses its actual host
  mode. Those earlier rejection results remain preserved.
- `.work/android-posix-helpers-current.json` passes both pinned Bionic C-header
  ABI checks. It does not establish the complete Android app-record ABI.
- `.work/android-core-lint-final.json` records strict production lint of both
  private modules and their real enclosing test, with every requested source
  visited. Linux X11 facade/test strict lint, owned Jai format checks,
  regeneration checks and 73 Python tests pass.
- Full Android facade/test lint and Jai type checking cannot run: the current
  source-built tools reject the Android target. `android-helpers.jai` supplies
  real public device assertions and both configuration signatures for later
  Android CI; it is not counted as executed or type-checked here. Native Android
  app/NDK ABI, logging, assets and finish/process behavior remain required gates.
- `.work/bindings-mac-helpers-current.json` has zero failures: 148 source,
  100 native build/run and 116 privacy passes; 26 source, one native and forty
  privacy cases are unavailable. It reuses the existing independent local
  foundation baseline and refreshes only owned bindings. It is worker combined
  Mac evidence, not a fresh peer-source integration or coordinator corpus run.

The [earlier contract-status report](x11-android-contract-status.md) preserves
the original missing-export failures. They are resolved by this implementation;
they were not waived or removed. Native Linux/X server and Windows verification
remain later required gates. No optional rpmalloc matrix or benchmark ran.
