# Explicit raw heap build profile

The reviewed raw heap signatures and complete contextual records are sufficient
for safe implementation. The source does not declare the FIRST_CLASS_HEAPS
import parameter/default. Preserve the independently documented false packaging
default; permit a build to supply this missing compile-time selection through a
private build configuration. No public module parameter or export is added.

Use a private `rpmalloc-build` module and a production configuration tool that
writes that module in an owned/staged stdlib tree. Public raw declarations retain
their exact conditional association and aliases. This is our explicit packaging
mechanism, not a claim about the missing original selection mechanism.

There are three approaches: forwarding raw records to SDK storage is unsafe;
reusing the rewrite's canonical record storage is also unsafe because field
orders differ. Select a shared independently authored adapter algorithm compiled
against separate complete reviewed C mirrors. Generate mirrors and offset/width
probes from reviewed raw/rewrite records independently. Raw atomic members use
actual C atomic storage/access; neither public record reaches SDK heap APIs.

Factor native profile naming/imports/compilation into one reusable generator
configuration. Enabled raw heaps have separate SDK, callback and facade symbols
for both statistics settings. The existing disabled-raw/rewrite profile behavior
stays intact. Ownership, retirement, callback context and serialization follow
the accepted typed adapter. Canonical raw aliases retain heap_t identity.

Implementation and validation:

- [x] Add a public spec-derived raw heap program and observe missing exports.
- [x] Add the explicit private build selector and generated profile plumbing.
- [x] Generate complete raw mirrors/probes; implement all eleven canonical raw
  operations, including checked calloc, and preserve nine procedure aliases.
- [x] Test both statistics settings, reflection/aliases, field offsets/widths,
  actual counters, allocation/reallocation/free, callback failure/lifetime,
  cross-thread frees, ownership and coexistence with the rewrite domain.
- [x] Retain source checks on six desktop configurations, real host programs,
  native SDK/storage assertions, sanitizer checks and export privacy.
- [x] Run production formatting, strict scoped lint and regeneration; update
  per-API coverage/questions/deviations and commit a logical checkpoint.

Metadata allocation failure remains an explicit separate transactional design
gap. This profile work must not hide its fail-fast policy or full-graph copy and
serialization costs. Windows/Linux native execution remains unverified here.

Select a source package explicitly (never another worker's checkout):

```sh
python3 tools/native_bindings/configure_rpmalloc.py \
  --stdlib .work/staged/stdlib --first-class-heaps true
python3 tools/native_bindings/build_rpmalloc.py --output .work/native
```

The targeted builder checks the pinned official source/patch hashes and builds
all four SDK/callback domains. On Mac, `--arch x86_64 --arch arm64` builds universal
archives. The full production dependency builder also builds all domains, in
dependency order. Verify the explicit source profile with:

```sh
python3 tools/native_bindings/verify_rpmalloc_heaps.py \
  --compiler .work/target-producer-refresh/debug/jaic \
  --formatter .work/jaifmt-production --native-libs .work/native \
  --rpmalloc-first-class-heaps --macos-both-cpus
python3 tools/native_bindings/verify.py \
  --compiler .work/target-producer-refresh/debug/jaic --module rpmalloc \
  --runtime --rpmalloc-first-class-heaps
```

Omit --macos-both-cpus for host archives. The second command still reports six
genuine unresolved public-inventory checks; configuration verification still
reports eighteen failures at generic/dump names. No partial profile is called
complete by the successful targeted heap checks.
