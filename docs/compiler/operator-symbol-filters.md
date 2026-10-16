# Public operator names in using filters

`using,only(.["-"]) Basic` selects subtraction. The compiler previously compared
that public string to its internal `operator-` declaration key, rejecting the
symbol and accepting the internal spelling instead. The coordinator's sanitized
official Jai0.2.030 observations confirm that symbolic Apollo_Time/S128 controls
build and execute successfully, while the internal-string control is rejected.
This worker did not inspect original code or execute reference binaries.

The fix is confined to `sema/using.rs::filter_target`, its private public-name
helper, and `sema/scope.rs::filter_hides`. Both import and standalone module using
paths now compare only/except names in the public namespace and retain the
original declaration key for lookup. No declaration, overload, type, storage,
privacy or callable metadata is copied or renamed. Aggregate map behavior is
unchanged. Ordinary names such as `operator_count` remain ordinary names; unknown
filter names remain legal, selecting nothing for only and hiding nothing for
except. An internal operator spelling is therefore not a compatibility alias.

Translation covers the thirteen forms inventoried in reviewed public module
contracts: `+`, `-`, `*`, `/`, `==`, `!=`, `<`, `<=`, `>`, `>=`, `[]`, `[]=`,
`*[]`. Unary and binary subtraction share the public minus symbol. Additional
operator-filter forms are a precise reviewer question rather than guessed from
the compiler scanner. No parser, IDE scanner, LSP, module loader or callable
metadata source was edited.

`cleanroom_operator_filters` independently executes compile-time assertions for
each reviewed family. Equality uses deliberately different overload behavior
from built-in structural equality. Exclusion checks name the equality declaration
explicitly because hiding an overload does not prohibit built-in equality.
Index exclusions use an intermediate facade exposing just that operator so
legitimate alternate index overloads cannot obscure the visibility check.
Controls cover nested filtered reexports, named/anonymous imports, ordinary
procedure aliases, public types with private overloads, named members and mutable
storage identity. Existing operator-visibility and module-filter tests also run.

Six existing canonical facades require a companion public-string migration:
Basic, Math, RadixSort, Bit_Array, Soa and Xar currently use internal operator keys
inside computed string filters. The correct compiler semantics stop those
strings selecting operators. This is a consumer dependency, not a reason to
retain internal-name aliases or invent overloads. Their owners were notified in
the authorized shared inbox. The compiler worker has not edited those production
files or peer checkouts. Actual Basic controls remain failing until that migration
is integrated; generic core test passes do not count as canonical library success.

Native O0/O2 validation is deferred to the integrator's serialized native gate
unless a focused lease is granted. No native execution was attempted by this
worker. Fresh RED, failed consumer attempt and test receipts are preserved under
`artifacts/T7numerics`; source-built tools use the isolated
`/Volumes/T7/codex-builds/jai-cleanroom-01a137eb/numerics/compiler-symbol-filters-015`
target. [Contract questions](../specs/questions/operator-filter-forms.md) and
[verification status](../status/compiler-symbol-filters-015.md) record current
limits and coordination.
