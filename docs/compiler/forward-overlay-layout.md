# Forward overlay declarations, types and storage layout

Overlay storage dependencies are independent of reflected declaration order.
The compiler now collects selected declarations first, resolves field types on
demand, and computes offsets with a dependency graph. Field vectors and initializer
vectors retain source order. Direct, chained and promoted forward anchors share
real storage without moving the target declaration or changing public names.

The offset graph separates field offsets from sequential cursor offsets. Normal
fields consume cursor space; overlays depend on their anchor and leave the cursor
unchanged. Place directives select a cursor dependency. Aggregate alignment includes
all field alignments; extent includes the farthest alias, with checked arithmetic
and the existing MAX_SIZE bound. Packed layouts and explicit field alignment keep
their existing rules. This also repairs the earlier zero-sized-anchor edge where
an overlay incorrectly advanced the next ordinary field.

An iterative dependency walk visits each node once and detects self/chained/place
cycles, without recursive host-stack growth. Direct-name lookup and target caching
avoid repeated scans of wide records. A 5,000-link original chain passes. This is
regression evidence, not a throughput benchmark: promoted targets still search
using paths and can cost more than direct anchors. Profiling can justify a shared
promoted-name index if large independent bindings expose a material cost.

Field type queries have their own per-scope cache and pending set. Direct and
qualified forward field types, selected conditional/inserted declarations, named
and anonymous using members and computed name maps resolve without demanding the
containing record’s offsets. Computed filters are cached per declaration/instance
so a type query does not invoke the mapper again during layout. Real by-value
recursion remains an error; type dependency cycles and storage dependency cycles
have distinct diagnostics. Dynamic pointer paths cannot serve as inline anchors.
Loaded declaration file scopes and module privacy remain intact.

IDE navigation records forward anchor/type references. Hover padding ignores
overlay aliases, whose extents must not erase the padding before a real field.
Reflection keeps canonical field types, source order, offsets and OVERLAY flags.
Source-order overlapping default initialization is retained and tested in execution.
No module/path/name exception, reordered public record or invented API is used.

## Executed verification

Original regressions are in cleanroom_layout, cleanroom_modules and
cleanroom_reflection. The first forward test failed before the repair; after the
initial storage repair it exposed a false containing-struct cycle in forward
`type_of`, then a separate promoted-type failure. All are retained in
`target/forward-overlay-{before,layout,types,promoted-type-before}.log`.
The final layout cases include type/storage/place cycles, pointer-target rejection,
filters, mapper single execution, anonymous members, packed/zero-size layouts,
extent overflow, a long chain, loaded-file privacy, IDE definition/padding and
reflected order/flags. No assertions were weakened.

```sh
LLVM_SYS_231_PREFIX=/opt/homebrew/opt/llvm CARGO_TARGET_DIR=target RUSTC_WRAPPER= cargo test --locked -p jaic -p jaic-llvm --test cleanroom_layout --test cleanroom_overlays --test cleanroom_modules --test cleanroom_reflection
```

The LLVM test actually executes original aliases/defaults and reflection on native
and WASM64 O0/O2. Broader core/backend library and focused atomic/context/variadic/
interface/module/literal/register/namespace/host-target/runtime/Windows-thread/
unwind regressions pass; optimized true-leaf behavior remains unchanged.
CLI runtime allocation and plugin/older-runtime checks pass. LSP passes all 25
library and 16 auto-import cases after stable-library verification. An earlier
parallel run rebuilt the shared runtime candidate while LSP scanned it and two
module-discovery cases failed; the failure is retained, and the stable rerun passes
without changing code/assertions. Future candidate mutations and consumers must
run sequentially or use separate snapshots.

Scoped rustfmt/item spacing, core/backend/CLI/LSP all-target clippy with warnings
denied, Windows x64/ARM64 core clippy and wasm32 browser clippy pass. Source-built
jaifmt check and rebuilt strict verbose jailint pass on the owned Jai fixture.
An initial stale jailint executable still rejected forward anchors; that failure
is retained and was repaired by rebuilding the actual tool, not suppressing checks.
Logs are `target/forward-overlay-*.log`.

## Native SDK and producer boundary

Read only NEW bindings native-bindings-questions.md, its generated D3D declarations
and the synchronized reviewed D3D11/D3D12 spec pages. The two reported declarations
indeed put aliases before their anchors. Own library-free tests reproduce that
language pattern. Producer sources were staged only into our own
`target/forward-overlay-bindings/stdlib` before checking; no peer artifacts changed.

Public native SDK headers compile the original forward-overlay-sdk.c static
assertions with MinGW x64 and warnings denied. The SDK root parameter is size 32,
alignment 8, discriminator offset 0, payload offset 8 and visibility offset 24.
The owned generic SDK-shaped Jai record matches those values. The reviewed/generated
D3D12 record instead puts payload first, so its source-order layout is size 24,
discriminator offset 16 and visibility offset 20. D3D11’s discriminator is likewise
after its payload in the reviewed shape but first in the SDK. Supporting forward
overlays cannot legitimately repair that ABI discrepancy by silently moving fields.
Bindings/spec ownership must resolve it; no full native D3D conformance is claimed.

```sh
x86_64-w64-mingw32-gcc -std=c11 -Wall -Wextra -Werror -c tests/compiler-semantics/forward-overlay-sdk.c -o target/forward-overlay-bindings/sdk-layout.obj
```

After including the NEW private Windows text helper in the own staging candidate,
combined D3D11/D3D12/DXC public checking and full no-DCE checking stop at missing
`ID3D11ModuleInstance` in d3d11/declarations.jai:6610. The diagnostic points to
its declaration in d3d_compiler. This independent dependency is preserved rather
than adding a compiler export or weakening private import rules. Initial missing
helper staging and final dependency failures remain in forward-overlay-bindings
logs. The 40 producer configurations/full native DXC integration are not claimed
passing from this compiler batch; coordinator/bindings must rerun them.

Remaining contract question: a conditional field set whose selection itself needs
the type of a field introduced only by that conditional has no reviewed fixed-point
rule. Only known direct declarations and selected expansions participate; genuine
cycles/unknown names diagnose. General AST/debugger/alternate-backend and portable
runtime-adoption limits remain separate. Mailbox CPUID and tooling identity/typed
result-descriptor reproducers are next compiler work, not completed by this batch.
