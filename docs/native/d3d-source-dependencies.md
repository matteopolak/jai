# Direct3D source dependencies and compiler regressions

The safe refreshed producer compiler now accepts independently authored
`tests/native-bindings/forward-overlay.jai`: a pointer overlay precedes its
storage anchor, both offsets are zero, the discriminator follows at offset 8,
and writing either pointer updates the same storage. Source checking and real
host execution pass. No compiler or public record was patched in this workspace.

That general fix exposed incorrect binding imports. `d3d_compiler` owns the
reviewed canonical `ID3D10Blob` (`ID3DBlob` alias), its complete vtable, and
`ID3D11ModuleInstance`/vtable. Its declarations need Windows, not D3D11. D3D11
and D3D12 depend privately on those canonical compiler interfaces. D3D12 also
does not need D3D11: its shared-spelling enum declarations and members are
complete in its own reviewed page. The generator now emits this acyclic graph:

- Windows and DXGI provide platform/format definitions.
- `d3d_compiler` imports Windows only.
- D3D11 and D3D12 privately import Windows, DXGI and `d3d_compiler`.

No duplicate opaque interfaces, additional facade exports or reflected-name
changes were introduced. `d3d-interface-identity.jai` type-checks forwarding of
canonical compiler interface output pointers through D3D11/12 calls and asserts
blob/topology alias identity and reflected names. Privacy probes require those
contextual compiler interfaces to remain absent as D3D11/12 root exports.

Removing the unnecessary D3D11 dependency also avoids an independently reproduced
general compiler bug: an unqualified alias in a module can bind an imported
same-spelling enum instead of the module's local enum. The original three-file
reproducer is `tests/native-bindings/alias-local-shadow.jai` plus modules
`Alias_Dependency`/`Alias_Facade`. It has active failing type-identity assertions,
without SDK/module-specific logic or reference inputs. Run with the own compiler
using `-check -no_dce`. This requires a general local-declaration lookup fix by
the compiler owner; the binding dependency cleanup is valid independently of
that fix. Do not substitute a private duplicate or weaken alias identity checks.

Evidence: `.work/d3d-forward-overlay-producer-refresh.json` retains the initial
missing dependency failures; `.work/d3d-dependencies-current.json` retains the
alias mismatch. `.work/d3d-dependencies-final.json` checks final source/public
names and privacy on both Windows CPUs, including the complete public DXC
compile/reflection test. Its remaining public-name failures are the unresolved
`dxc_get_version_string`. Four debug configuration failures are now resolved;
`.work/configurations-after-d3d-refresh.json` retains the other 36 failures.

These are source/type/privacy checks, not Windows native execution or proof
that every public D3D aggregate matches C. Existing public/native aggregate
mismatches, SDK-dependent execution, the two D3D convenience overloads and DXC
version-helper contract remain required work. Public-name presence alone cannot
prove all same-name overloads; the per-declaration ledger still marks those two
convenience overloads unresolved.

The actual NEW Windows render/event test passes ordinary DCE-enabled source
checking, but `-no_dce` on both CPUs still reaches the independent fixed-array
literal bug in producer Unicode. Both outcomes are distinct; no strict full-file
source pass is claimed. Repro output and refreshed compiler identity are in
`.work/d3d-compiler-and-window-repros.json`. Compiler staging used only NEW
`../compiler/crates` and its manifest/lock/toolchain, without peer edits.
