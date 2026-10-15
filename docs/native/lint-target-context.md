# Native binding lint target and root context

Refreshing the safe compiler producer also refreshed jailint's incomplete-root
handling. It now fails instead of silently counting bodies that could not be
compiled. Earlier production lint passes remain historical evidence for that
tool build; they do not establish full coverage with the stricter tool.

The first refreshed run omitted `JAIC_STDLIB` and failed to locate bootstrap;
the retry supplies the actual staged NEW stdlib. Both reports are retained:
`.work/checkpoint-5-production-tools.json` and
`.work/checkpoint-5-production-tools-retry.json`. The retry has actual complete
host module passes, plus failures from unavailable target/root contexts and
existing declaration gaps. No lint rules, target guards, assertions, private
import restrictions, or tests were disabled to conceal those failures.

A minimal independently authored reproducer is:

```jai
#assert OS == .WINDOWS, "requires Windows";
main :: () {}
```

The normal compiler can source-check this with `-os windows -cpu x64`. The
current jailint CLI exposes no OS/CPU target argument; on macOS it rejects the
assertion and reports the program was not fully linted. Directory lint also
treats private `internal/.../module.jai` files as independent program roots,
which rejects valid public-to-private import boundaries. The staged private
iOS host unit must be placed in its legitimate module, as already documented,
not granted a new public import path merely for a lint invocation.

Required general tool work: accept target configuration through the same
compiler target mechanism; select public/module roots and traverse their
private loaded sources with the original visibility context; report exactly
which bodies were visited. Mobile targets still additionally need compiler
support. Remaining rpmalloc/D3D compile failures require implementation/general
semantic fixes and cannot be reclassified as only tooling gaps. No bindings
worker patch to the compiler/linter or alternate fake OS constant was applied.
