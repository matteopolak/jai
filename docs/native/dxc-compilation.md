# DXC native compilation route

`DXC_Compile` now delegates to an independently authored native SDK route with
real compiler/utility/include-handler creation, native Compile/GetStatus,
diagnostic retrieval, result-blob retrieval and an owned Jai byte-array copy.
Every HRESULT and required output pointer is checked. Each COM reference is
released on success or failure; returned bytes remain valid independently of
the released SDK objects. Failed compilation returns an empty array with real
SDK diagnostics; logging failures abort rather than being ignored.

The pure argument builder preserves argument boundaries, Unicode and spaces.
It requests HLSL 2021; maps all eight shader stages; adds individual defines;
supports optimization/debug/warnings/validation controls; requests the supplied
SPIR-V environment and the vendor's documented nonsemantic debug option; and
appends extra arguments last. Version strings are concatenated verbatim into
native profiles. Empty source/entry names leave native defaults selected.
DXIL debug output is explicitly embedded with Qembed_debug; SPIR-V uses its own
debug options. Exact empty-name or embedding behavior beyond the reviewed
contract remains a review question, not a byte-for-byte reference claim.

UTF-16 argument conversion reuses the NEW platform-io strict encoding backend,
with a two-byte owned empty-string case appropriate to argv. Invalid UTF-8,
embedded NUL, negative/oversized lengths and native conversion failures are
rejected with an explicit diagnostic. Both input strings and wide arguments
have clear Jai allocator ownership. Each invocation creates independent SDK
objects and copies arguments before conversion; this intentionally costs
allocations and factory calls to avoid shared mutable compiler/context state.
Consider per-thread reuse only after native thread-safety/performance review.

The native compile implementation has no D3D12 reflection dependency. It loads
our single complete generated DXC declaration schema, whose unused D3D12 import
was removed; the public facade retains its necessary canonical D3D12 reflection
type/import and still reports that compiler failure. No public record, alias,
field order, overload or type identity was changed. Private SDK objects never
escape as public objects; the compile route returns only owned bytes. This
shares declaration source instead of inventing reduced SDK interfaces or
altering a compiler to bypass unsupported overlay semantics.

Evidence: both Windows CPUs source-check the complete private compile route
and strict wide-argument unit, including active buffer/interface-size assertions.
The pure private argument serialization unit builds/runs on the host and passes
strict production lint. Its scope is explicitly private algorithm verification,
not public DXC runtime evidence. Complete official SDK C++ header layout probes
pass both host CPU compilations. SDK option documentation and native option
definitions are pinned with the headers in dependencies.json.

Full public DXC source/reflection tests now pass both Windows CPU checks after
safe producer forward-overlay support and corrected canonical D3D imports.
Windows native compilation, invalid-HLSL diagnostics, reflection and SPIR-V
executions remain required. All real executable tests are registered, including
an independent private SDK-route program and the public facade program. Private
units are copied byte-for-byte into their legitimate staged library context;
no import-privacy guard, platform assertion or original corpus source is changed.
Target-aware strict lint remains blocked by the linter's current CLI/context
limitations; no complete Windows lint/native pass is claimed.
