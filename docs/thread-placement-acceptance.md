# Thread placement acceptance

## What it is

`crates/jai-codegen/tests/thread_placement_source.rs` checks independently authored record shapes derived from Thread's worker cache-line layout. It tests genuine overlapping storage in the checked VM and freshly generated native executables; it does not establish complete Thread module acceptance.

## How it works

The worker case places a 64-byte padding field at the start of an earlier `using` record field. The following slice must begin at offset 64, giving the whole record size 80 and alignment 8 on the supported 64-bit hosts. An aggregate copy retains padding bytes and the slice; a pointer cast through the padding mutates the same physical bytes seen through the promoted information fields.

A second case rewinds to a 79-byte array, adds a shorter overlapping array, then a scalar at offset 16. The full record must retain its earlier extent and round up to 80 bytes for alignment. Copying preserves bytes beyond the new layout cursor and the scalar in the overlaid region. Both cases use explicit uninitialized storage and write every observed value, avoiding an assumption about overlapping default initializer order.

Each case requires VM completion with result 42, verifies exact LLVM physical offsets, and runs freshly emitted `O0` and `O2` objects linked by installed Clang. Executables have a five-second deadline. The tests are prepared while the source `#place` implementation is being integrated; native and VM acceptance remains pending until those gates complete.

## How to change it

Keep placement as a cursor change anchored to a genuine earlier field. Record extent remains the maximum occupied end, with final alignment rounding. Extend the source tests when changing record copy, projected access, or placement layout; never replace overlapping fields with independent storage merely to obtain the expected result.

The complete supplied Thread source additionally depends on imports, allocator initialization, atomics, context, and synchronization. Its independent module gate must remain separate from these authored field-layout cases.

## Configuration

The cases are enabled on 64-bit hosts and use `JAI_RS_CLANG` when supplied, otherwise installed `clang`. The repository's LLVM configuration is required for the codegen test build:

```sh
RUSTC_WRAPPER= LLVM_SYS_221_PREFIX=/opt/homebrew/opt/llvm cargo test --offline -j1 -p jai-codegen --test thread_placement_source
```

## Dependencies

The source parser and graph, semantic record layout, checked VM byte memory, LLVM type and projection lowering, and installed LLVM/Clang. No original source or supplied native assets are required by these tests.
