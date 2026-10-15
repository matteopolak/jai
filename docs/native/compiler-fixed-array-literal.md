# Windows render integration: fixed-array type literal

The ordinary current source-built producer compiler rejects this independent
example under `-check -no_dce`:

```jai
mask :: [3] u8.[1, 2, 3];
main :: () {}
```

Diagnostic: `type mismatch: expected [3] u8, found s64` at the first element.
Scalar-inferred forms such as `u8.[1, 2, 3]` and variable initializers such as
`mask: [3] u8 = .[1, 2, 3]` are distinct forms; changing producer Unicode code
locally would hide the general issue and is outside bindings ownership.

The actual NEW window worker's
`tests/window-render/windows-render-events.jai` reaches the corresponding
six-element literal in producer `internal/unicode/module.jai:13`, on both
Windows x64 and ARM64. This follows adding the NEW platform-io File facade,
its three File backend files and windows-text dependency to staging. No peer
source was edited. WGL's own native executable regression passes Windows CPU
source checks separately; the complete render/event program remains blocked.

Required semantic review: recognize a fixed-array type before typed array
literal syntax, and validate literal elements against its element type and
length. Confirm with the minimal example plus actual Unicode and Windows
render tests. A source-producer syntax correction is also possible if that form
is intentionally unsupported, but must be made/reviewed by its owner; no
compiler path/module/symbol special cases or fixture-only replacements.
