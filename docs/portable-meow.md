# Meow calico implementation

The portable worker independently adapts the permitted official Molly Rocket
native C algorithm under its zlib license. The unmodified source, notice and digest
are in [third_party/meow_hash](../third_party/meow_hash/README.md). No Jai library
implementation or supplied reference executable was consulted. Public declarations,
field order, constants and mutable initializers come from the reviewed Meow page.

`reg` aliases the single bootstrap's canonical `__reg` type. All register macros
bind real compiler-managed 128-bit operands, including mutations and indexed u64/u32
extraction. No Code/struct/scalar substitute is used. A valid original vector probe
passes interpreter/native; the former scalar-u64 probe is preserved as a compile
rejection because the reviewed register contract explicitly excludes that category.

The facade loads topical data/register/finalization/stream files. Private finish,
state-block and wrapping helpers remain file-local. Both MeowBegin forms, block
absorption, incremental absorption, both finalizers and one-shot hashing execute
the actual calico AES/mix/shuffle algorithm. The source-built compiler lowers the
assembly operations through ordinary supported IR, so host ARM64 execution is real;
this is not a claim of physical x64 register pinning or hardware AES throughput.

MeowDefaultSeed, MeowMaskLen and MeowShiftAdjust are initialized mutable entities.
Two imports retain identical addresses. Edited seeds/masks/shift adjustments change
subsequent applicable calls, and restoring values restores digests. One-shot tails
use the public shift table/page-window handling; padded streaming tails follow the
native C path and do not require that adjustment. Default tables come strictly from
the public oracle, not from inferred original Jai behavior.

Verified behavior includes empty/null-source zero-length input, all short tail
lengths, 256-byte block boundaries, page boundaries, four input offsets, arbitrary
seeds, edited globals, fragmented state updates and repeatable non-mutating state
finalization. Both pre-fold 128-byte outputs are checked against real C results.
The active state lanes occupy the first 128 bytes of the reviewed 256-byte
RegisterFile; its remaining bytes and unused Buffer/Pad contents are preserved.
The exact ancillary state-byte contract remains under review.

The original C comparison is built by our C++ wrapper with AES-NI and its real
debug hook. On this macOS ARM64 host it executes the freshly built x64 program;
no supplied binary is run. It produced 317 original cases with pinned source/data
digests, documented in [fixture provenance](../tests/portable-stdlib/fixtures/README.md).
`python3 -B tools/build_portable_meow_fixtures.py --verify-native` rebuilds and
requires byte-identical reproduction. Other hosts can run the genuine committed
test data without a native x64 comparison dependency. The Jai vector test passes
interpreter, native O0 and native O2 execution.

The focused runner stages the fixture and checks the module using the portable
worker's baseline dependencies. The existing own x64-gated Meow test initially
needed the specified Basic.exit, missing from that baseline. A separate target
overlay copies NEW Basic/String/File_Utilities and private basic/string/files,
basic-interface/native-path from the foundations worker, retaining our prelude,
Meow and other dependencies. With explicit x86_64-apple-darwin/x64 selection the
old assertions execute and pass interpreter/native. This staged composition is
not production integration; peer checkouts remain untouched.

Ancillary contracts not established by the reviewed page: raw MeowEnd receives the
trailing input region and overwrites r1/r3 residual scratch operands; Store128
writes 128 **bytes** of pre-fold state, following the permitted C algorithm, not
16 bytes. MEOW_DUMP_STATE currently prints the title and eight pairs of decimal
u64 lanes; real output is tested, but reference diagnostic format/hook behavior
requires review. Caller input/output must provide the documented readable/writable
windows. Null nonempty input and invalid lane indices reject. Concurrent mutation
of public tables or use of one state requires caller synchronization.

Implementation performance differs from tuned x64 C: no prefetch strategy is
claimed, and assembly lowering may use portable software/vector operations. No
benchmark or cryptographic guarantee is claimed. Public constants remain exact.
