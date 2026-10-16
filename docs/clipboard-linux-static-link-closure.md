# Linux Clipboard static consumer dependencies

Actual CI 38947592867/job 117130544678 reached native Jai linking and reported
unresolved Xlib calls from the independently authored `x11.c` archive member,
including `XGetWindowProperty`, `XFree`, `XInitThreads`, `XSetErrorHandler`,
`XChangeProperty`, and `XSync`. Earlier real C X11 clients passed at O0/O2 and the
SDK was installed. Those C commands explicitly link X11; they do not establish
the Jai consumer's library closure.

The private Clipboard implementation imported canonical X11 `Window`/XID types,
but did not call a Jai-declared X11 foreign procedure. Its native archive uses
Xlib and pthread internally. The compiler retains libraries referenced by lowered
foreign procedures or marked `link_always`; a type-only import supplies neither
an X11 foreign root nor archive dependency metadata. Consequently the captured
baseline Jai link command selected `libportable_clipboard.a` and omitted X11.

The repair declares private standard `#library,system,link_always "X11"` metadata
and marks the existing pthread declaration `link_always`. Public signatures,
defaults, canonical XID storage and all native implementation bodies are unchanged.
No dummy X11 call/wrapper, fake symbol, workflow shim, compiler special case,
whole-archive option or blanket `--no-as-needed` is involved. The helper build
receipt records `static_consumer_dependencies` alongside its existing required
system libraries. Static archives do not encode a shared object's dependency list;
the consumer must retain these dependencies explicitly.

## Focused configuration proof

`tools/check_clipboard_linux_link_closure.py` uses the actual shared stdlib and
freshly source-built own compiler. It builds a real host-SDK archive from the
current independent helper C sources, then uses the supported `JAIC_LINKER`
setting to capture actual Linux-target linker arguments for the unchanged real
Clipboard roundtrip program. The recorder deliberately exits 73: it never claims
to link a valid executable. On Mac, host C object format differs from Linux; the
archive is used only for actual provider selection and argument ordering, never
as a Linux native compatibility input or executable.

Both Linux CPU targets at O0/O2 now contain the real archive before X11 and pthread
(observed argument indices 6, 8 and 10), with no `--no-as-needed`. Existing general
archive-before-system-library ordering is sufficient; no compiler-driver repair
was needed for this observed omission. Source checks and strict lint also pass.
If normal Linux CI supplies X11 but orders it differently, capture its actual
argv and route that general driver defect to the compiler owner.

The tool queries configured X11 SDK flags through pkg-config, or accepts explicit
`--x11-cflags` for an installed SDK. The worker's Mac lacked the pkg-config executable
but had the public X11 SDK; its first failed configuration receipt is preserved.
The successful run explicitly used that installed SDK's header path, without
installing/fetching anything or adding a silent fallback. The initial `-os linux`
native cross-build attempt was rejected by the CLI; the preserved retry uses the
supported explicit Linux target triple. Neither failure is hidden or called a
native acceptance result.

## Required acceptance

Normal Linux CI must still pass the real Jai interpreter, native O0/O2 roundtrip,
real C clients and relocated-package/missing-helper checks. Their commands,
assertions, expected outputs and package rejection requirements are unchanged.
The prior unresolved-symbol failures remain historical until that actual rerun.
No Linux native execution, X11/display activity, GUI or fault program ran locally.
Source/metadata hashes and exact NEW patch receipt are in
`docs/status/clipboard-linux-static-link-closure.json`. Integration alone stages,
commits, dispatches CI and updates global docs indexing.
