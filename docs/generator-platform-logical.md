# Canonical provider logical library spelling

The reviewed `Library_Info.full_path` contract describes generated Jai loader
spelling, independently of the physical filename used for native inspection.
The canonical provider previously copied its successful physical candidate into
that field, leaking platform suffixes into generated library declarations.

`generator-platform.jai` now separates those values at the provider boundary.
Native `dlopen`/LoadLibrary receives the physical candidate unchanged. Static
symbol inspection likewise receives the physical archive filename. The returned
canonical Library_Info retains the native handle or owned static symbol view;
later symbol queries use those directly and never reopen `full_path`. Ordinary
logical spelling preserves the selected directory prefix and strips the supported
filename suffix/version. System spelling contains only the stripped basename.
An empty identifier derives from that basename using lowercase and the reviewed
dash/dot byte repair. No public fields, provider clone, Session fields, public
record layouts, driver workaround or compiler exception were introduced.

Supported spelling rules strip the configured static/shared suffix. Numeric
Darwin versions precede `.dylib`; numeric ELF versions follow `.so`. Version
segments must be decimal digits separated by dots; unrelated dotted text is not
interpreted as a numeric version. Explicit custom suffixes remain supported.
Malformed identifier/path/suffix descriptors and search-list bounds diagnose
before native calls or iteration. Caller-owned standalone Library_Info lifetime
and existing canonical Session activation remain unchanged.

## Independent controls and verification

The fixture uses the approved relative logical form `#library
"./liboriginal_resolved"`, with an SDK-built dylib next to the consumer and its
working directory set to that directory. An independently authored C SDK consumer
links and calls the same actual image. Neither consumer strips a provider path or
uses explicit suffixed/absolute Jai library literals. No reference binary/source
was used. The initial fast failure receipts are retained, including a harness
correction: placing the direct-consumer control image in the provider working
directory allowed direct native search to select it ahead of configured roots.
Provider and direct-consumer controls now have independent working directories;
the provider's selected directory is asserted without changing search behavior.

The public provider fixture verifies ordinary/system spelling, derived identifiers,
static symbols, custom suffixes and numeric version names. Two different physical
images share one logical system spelling, yet native calls through their retained
handles return 37 and 73 respectively. A static-only symbol is present only in the
archive view. Renamed `.so.3.4` images in this host test are **Mach-O images**;
this verifies the name policy on Mac, not native Linux loading.

The generated-output fixture consumes the canonical init/run/provider/driver path,
checking ordinary prefix application, system prefix exclusion, shared omission
of availability modifiers, and static `,no_dll`. Its generated Jai consumer makes
a real native call. These checks consume tooling-owner driver fixes; this worker
does not edit or duplicate that driver.

Current shared source-built immutable receipt:
`artifacts/local-verification-generator-platform/logical-immutable-cj40h45_/verification.json`:
**43 pass / 0 fail**, including 12 actual Jai interpreter/Mac native O0/O2
executions, two SDK-linked native control executions, eight Jai native builds,
six desktop source checks, source-built formatter and strict full-context lint.
All 1,780 captured inputs remain unchanged. The captured compiler SHA-256 is
`a8daa981604883e8ac570d116bc92fec38b94dfba0516873f58f700533e0e65c`.
The live provider matches captured SHA-256
`e8174f1b94d027bb24dd9250895ee6d7149caf1d27f6b2af657d8490e0cc97ae`.
Post-verification native identities are retained beside the receipt.

Run `python3 tools/check_generator_platform_logical.py --fast` for the current
shared source/typecheck/interpreter loop, or omit `--fast` for immutable source
capture, local current Rust build, native O0/O2, format/lint and source checks.
Build/output storage is exclusively
`artifacts/local-verification-generator-platform`; no T7 target is used.
`DEVELOPER_TOOLS_LLVM_PREFIX` selects the official LLVM SDK (this host defaults to
`/opt/homebrew/opt/llvm`). The current canonical native shim is source-built into
each receipt's own native directory; installed shared runtime assets are untouched.

## Limits and handoff

Native execution evidence is Mac ARM64 only. Linux/Windows results are source
checks. Apple `.tbd` text-stub loading is not implemented by this provider.
Arbitrary working-directory/source relocation,
absolute logical Jai literals, absolute suffixed Jai literals, nonnumeric version
grammars and other native platforms are not established by this receipt. This
repair adds no successful placeholder for those domains. Existing loader
limitations remain explicit rather than being converted into empty symbol views.

This receipt does not certify Session-driven native-library retirement. Standalone
fixtures explicitly release caller-owned handles/views. Existing run/lifecycle
code appends provider records to its owned pointer array without a visible
Library_Info-handle retirement step; that separate ownership observation was
routed to the model/run owners rather than adding a duplicate resource registry.

Integration alone owns Git/index/checkpoint actions. Exact ready-file hashes and
dependencies are in `status/generator-platform-logical.json`. Preserve the tools
owner's directive/prefix changes and the model/run owners' canonical Session
architecture. No old checkout bodies, provider history or quarantined inputs were
overlaid on the current shared implementation. Release remains held.
