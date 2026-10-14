# Private standard-library source loading

`stdlib/internal` is reserved for library-owned dependencies. This distribution
policy does not make installed source secret or establish a security sandbox.
Applications use public module facades.

The source loader canonicalizes both the destination and the selected library
root through its `FileSystem`. A destination inside `<stdlib>/internal` requires
an originating source file whose canonical path belongs to that library tree.
The check runs before module-cache and loaded-file deduplication, so a facade
loading a helper does not authorize a later application import of that helper.
Direct application entry files in the internal directory are rejected as well.

The boundary covers module-name imports, explicit file and directory imports,
`#load`, relative traversal and native symlinks. Virtual filesystems use lexical
normalization; consecutive leading `..` components retain their meaning.
Library-owned `#load` and imports remain available. Visibility remains separate:
facades keep implementation module aliases file-local and expose reviewed public
declarations explicitly.

The selected bootstrap determines the library root. Without a selected bootstrap
there is no installed library identity and this policy is inactive. Generated
source labels alone do not establish library ownership. Scoped build strings now
retain known lexical source provenance from their Code/FILE selector, including
relative-load resolution. Unscoped generated text has no such provenance and
cannot directly import private helpers. As documented above, this distribution
rule is not a security boundary around metaprogram source insertion.

Implementation: `check_source_access`, `load_file` and `load_module` in
`crates/jaic/src/sema/modules.rs`. Verification:

```sh
CARGO_TARGET_DIR=target RUSTC_WRAPPER= cargo test --locked -p jaic --test cleanroom_modules
```

The original tests include a native symlink fixture created only under this
checkout's `target/cleanroom-fixtures` directory.
