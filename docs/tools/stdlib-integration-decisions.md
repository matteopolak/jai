# Standard-library integration decisions

## What it is

This document records distribution and integration choices for the independently implemented standard library. It complements the compatibility specifications without adding these project policies to the Jai language contract.

## How it works

The compiler loads bootstrap definitions from `stdlib/prelude/module.jai`. Public compatibility module facades reuse those definitions and the independently designed internal library; they do not duplicate bootstrap records or create distinct aliases for the same nominal type.

Public record declarations retain their canonical public type names where reflection exposes those names. A private algorithm or component can have a new internal name, but re-exporting a differently named nominal type is insufficient if callers observe the original name through type metadata or default struct formatting. Keep these compatibility records together as an ABI layer and build independently named algorithms around them.

`stdlib/internal` is reserved for library-owned imports. Application imports and source loads that resolve into that canonical directory are rejected, while files belonging to the installed standard-library tree may resolve those dependencies. Path normalization must cover relative paths and symlinks. This is a compiler distribution policy, not a security or source-confidentiality boundary.

File and module visibility continues to follow the language specification. Public aliases must preserve type identity, overload sets, mutable storage, defaults, and calling conventions. Import filters constrain the names introduced or re-exported by that import; a separately exported named module alias retains its own documented qualified-lookup behavior. Facades use file-local implementation imports and explicit public aliases so that an implementation module alias does not become an accidental public export. Mutable compatibility storage belongs in the public facade, or in a genuine same-name re-export verified to preserve lvalue identity. Do not assume that `Exported :: Impl.mutable_global` creates a live storage alias. Internal operations can receive that public state as a parameter while retaining independent internal names.

Legacy tests may encode behavior from the replaced library that contradicts the public compatibility contract. Preserve the original failing evidence, document the discrepancy, and replace or adapt an expectation only after independent specification review establishes the public behavior. Passing a modified test without this evidence is insufficient. In particular, CRC variant naming, permissive Base64 decoding, and reflection token consumption need their own explicit compatibility cases.

## Distribution native libraries

Release-provided native helpers, including `std_*` and libclang when packaged, must default to the selected installed distribution. Lookup must survive relocation and symlinks and must not depend on the build machine's checkout or SDK installation. Ordinary operating-system libraries retain their platform linkage.

The CLI already accepts `JAIC_NATIVE_LIBS`, a path list replacing its default native-library directory. Preserve existing overrides; this setting alone does not establish coverage for loaders that bypass that directory. Audit each packaged helper and libclang lookup during integration and exercise the unpacked distribution without development paths.

TODO: document any helper-specific or libclang override gaps found by that audit. Add no new override feature in this implementation phase.

Changes involve package manifests, installed-library lookup, and package relocation smoke checks together. Native helper builds and the selected standard-library root determine the installed layout.

## How to change it

Change the compiler loader, library entry, packaging workflow, and installation discovery together when changing bootstrap layout. Update import-resolution tests when changing internal-directory policy. Route API uncertainties to specification review and pass only public-contract clarifications to implementers.

## Configuration

The installed standard-library root is selected by the compiler's existing stdlib configuration, including `JAIC_STDLIB`. The bootstrap entry and reserved internal directory are relative to that selected root; they must not depend on the coordinator's original checkout.

## Dependencies

The compiler loader and name resolver, independently implemented library facades, standard-library specs, package smoke tests, and corpus acceptance suites.
