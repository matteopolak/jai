# Reviewed Objective_C helpers

The independently authored public helpers now implement the delivered encoding,
validation, registration and class-construction contracts. The canonical
`Class`, `id`, `Selector`, reflection records and Basic builder/allocator stay
shared. `Selector` transparently aliases `*void`; both encode as `:`. No nominal
replacement or type-name exception is used.

Encoding appends to an existing builder and returns caller-released strings
through its allocating forms. It handles the reviewed scalar codes, byte
pointers, fixed/view/resizable arrays, strings, procedure markers, recursive
pointer depth and exact `isa: Class` recognition. Constants, imported and using
members are omitted. Unsupported categories such as Any assert as specified.

Function encoding concatenates the declared return/arguments; it inserts no
receiver, selector or numeric offset metadata. Standalone encoding does not
require a method signature. Method validation separately checks C convention,
return/argument counts, supported receiver categories and exact Selector type.
The checker remains deliberately limited as reviewed; callers must provide
native-compatible implementations. Real method installation uses instance or
metaclass handles, copies temporary native strings and asserts on SDK rejection.

Class creation reserves the first reflected member, uses the reflected names,
logs missing parents/allocation/ivar failures and returns null. Parent/new-class
size differences warn and do not cancel creation. No Jai defaults are copied
into native instances. Runtime owns the real class/instance allocations; no
public record pointer is forwarded as native class storage. Callers must respect
the fragile layout precondition before accessing instances. Mismatched test
records are used only for class metadata queries, never instance dereferences.

The member-stub helper uses the reviewed installed framework spelling directly,
closes its temporary handle and returns lowercased-field/size-delta declaration
text. The previous guessed alternate path has been removed.

`tools/native_bindings/verify_objc_contracts.py` captures the entire current
stdlib plus owned tests/helpers/spec/config, verifies the capture and runs
read-only immutable inputs. It builds the independent official-SDK C/Objective-C
probe locally and records SDK/header and tool identities. It checks:

- Exact public encoding and builder/ownership behavior.
- Real native class/ivar layout, signed 32-bit instance/metaclass dispatch,
  structure returns, release, name collisions and mismatched-layout warnings.
- No copying of Jai record defaults during native object allocation.
- Active invalid convention/receiver/selector/isa/Any/duplicate-method failures.
- Root privacy, strict complete-context lint, formatting and immutable inputs.

Native evidence is Mac ARM64; Mac x64 is source-only in the fresh batch. iOS
source/native execution remains unverified because the compiler target and SDK
execution are not supplied by these Mac checks. Linux/Windows are outside this
module's reviewed availability.

The old SDK fixture expected C-preferred i/I codes, `*void -> ^v`, an implicit
receiver and overlay rejection. Those were independent implementation policies,
superseded by the reviewed l/L, canonical alias, declared-argument and warning
contracts. Native size/alignment, ivar offsets, receiver pointer footprint,
dispatch, disposal and actual SDK allocation failure assertions remain active.
One intermediate oracle assumed using inheritance exposed an isa entry;
canonical reflection instead retains the using member, which the encoding
omits. The corrected exact receiver encoding preserves that public rule.
Failed intermediate receipts remain in worker scratch.

Reproduce with independently source-built tools and a worker-private root:

```sh
python3 tools/native_bindings/verify_objc_contracts.py \
  --compiler /path/to/own/jaic --jailint /path/to/own/jailint \
  --formatter /path/to/own/jaifmt --output-root /path/to/own/scratch
```

The latest exact receipt is indexed by
`docs/status/bindings-shared-audit.json`; its result applies to the captured
input identity, not future moving-source changes. Global corpus and final
assembled integration remain coordinator-owned.
