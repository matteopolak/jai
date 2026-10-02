# Reviewed native linking

## What it is

The native driver can link a narrowly reviewed source-built VMA 3.3 virtual-allocation dependency. Authority exists only during a fresh source rebuild and ABI check; persisted receipts and source library paths cannot supply it.

## How it works

`JAI_RS_NATIVE_VMA_LIBRARY` selects one resolved local library declaration by its exact physical OS path. A relative `#library` filename is anchored to the declaring source's physical directory, so configuring only its basename does not select that declaration. Selection does not read or authorize the named native file. Before executing tools, the driver validates every reachable prototype owned by that declaration: fixed C calling convention without context, exact integer representations, target record sizes, alignments and field offsets. It accepts only `vmaCreateVirtualBlock`, `vmaDestroyVirtualBlock`, `vmaVirtualAllocate`, `vmaVirtualFree`, `vmaGetVirtualAllocationInfo` and `vmaIsVirtualBlockEmpty`.

The reviewed contract covers these functions only. It grants no authority for external data symbols. A reached source `#elsewhere` declaration belonging to the selected library must fail before receipt access or tool execution; an unused declaration does not demand a dependency. Extend that boundary only with a separate, measured data layout and access contract.

The receipt identifies the pinned VMA source and installed SDK/tool inputs. The driver checks helper bytes against those compiled into the driver, executes those embedded source bytes directly without repository bytecode caches, clears inherited interpreter/build search paths, verifies fingerprints, and replays the source build in a fresh private directory. Before executing the oracle, it compares the new compilation's actual transitive source/SDK/tool fingerprints with the reviewed receipt. It never links the receipt's existing archive. The virtual recipe disables static and dynamic Vulkan function imports, so its oracle needs no Vulkan loader or GPU.

An independently authored C++ oracle checks function-pointer signatures and exercises block creation, aligned allocation, information, user-data preservation, freeing and destruction. It measures the three records: sizes 24, 32 and 24 bytes, alignment 8 on the proved 64-bit ABI. Opaque handles are pointers. The driver compares these measurements with its typed contract, snapshots the new archive, verifies the snapshot fingerprint, and retains a private `VerifiedDependency` through linking. Inputs remain OS paths; the installed platform C++ runtime is added explicitly.

This proves the virtual allocator boundary. It does not prove GPU allocation, Vulkan drivers, Slang, ImGui C++ compatibility or full sgpu/Vk-Engine execution.

## How to change it

Add recipes in `tools/native_dependency_proofs.py` with immutable pins, fresh builds and independent ABI/runtime oracles. Add typed signature/layout validation in `crates/jai-cli/src/native_dependencies/abi.rs`. Keep proof construction private and process-local; never deserialize JSON directly into linker authority.

`tools/native_dependencies.py` retains build-only receipts with `link_authority: false`, including ABI audit receipts. A matched, reachable source-library identity under protected `reference`, `vendor`, or `corpus/upstream` paths is rejected before ABI validation or receipt access, including dangling aliases and absent native files. Protected source roots and symlink aliases cannot provide build inputs or outputs. Scratch-directory and snapshot ownership last through linker completion. Adding an SDK requires reviewing its transitive sources, linkage and target ABI, not adding a search path.

`tests/fixtures/vma-virtual-abi.jai` is an independently authored Jai-to-C contract. Python tests cover provenance and protocol failures; CLI checks reject unreviewed symbols and mismatched layouts before executing dependencies.

## Configuration

Start with a verified source-build receipt. Each driver build creates a new archive:

```sh
JAI_RS_NATIVE_VMA_RECEIPT="$PWD/artifacts/native-dependencies/vma-3.3.0-arm64-logged/receipt.json" \
JAI_RS_NATIVE_VMA_LIBRARY="$(pwd -P)/tests/fixtures/reviewed-vma-virtual" \
target/debug/jai-rs build tests/fixtures/vma-virtual-abi.jai /tmp/jai-vma-virtual
/tmp/jai-vma-virtual
```

The fixture returns 42 after successful allocation, information and teardown checks. Both variables are required; the configured path must match exactly one referenced source library. Use the source directory's physical path when it is reached through a symlink. Declarations forbidding static linkage or naming dynamic-library files cannot use the archive recipe. Actual macOS/Linux host targets are supported; cross-target oracles are unavailable.

The native integration test requires an explicit reviewed receipt; it does not silently download dependencies or execute an archived input:

```sh
JAI_RS_TEST_VMA_RECEIPT="$PWD/artifacts/native-dependencies/vma-3.3.0-arm64-logged/receipt.json" \
RUSTC_WRAPPER= CARGO_TARGET_DIR=target LLVM_SYS_221_PREFIX=/opt/homebrew/opt/llvm \
cargo test -p jai-cli --test native_dependency_proofs -j1
python3 -m unittest discover -s tools -p 'test_native_dependenc*.py'
```

For an auditable standalone C++ oracle, run `python3 -I tools/native_dependency_proofs.py rebuild-vma-virtual --receipt <receipt.json> --target arm64-apple-darwin --output "$PWD/artifacts/native-dependencies/fresh-proof"`. Output directories must be fresh. Rebuild the driver after changing its embedded helpers.

## Dependencies

Python standard library; installed C++ compiler, archiver, C++ runtime and Vulkan/C++ SDK headers; `jai-types` canonical conventions/layouts; checked `jai-sema` prototype/library identities; and actual native reachability. No original supplied native compiler, object or library executes or loads.
