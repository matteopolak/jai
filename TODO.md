# TODO

Work we know about but haven't done yet. Remove an item when it lands (or move it to an issue).

## Releases and distribution

- **Sign and notarize macOS binaries.** Developer ID Application certificate, hardened runtime and `notarytool` in `release.yml`.
  - `jaic` probably needs `com.apple.security.cs.disable-library-validation` (it loads user dylibs in `jaic run`/`#run`) and `allow-unsigned-executable-memory` or `allow-jit` (libffi closures). Verify with the native-library and WebGPU tests.
  - Only browser-downloaded archives are affected today (Homebrew, `install.sh` and the VS Code download aren't quarantined).
- **Sign Windows binaries** (e.g. Azure Trusted Signing). Unsigned exes that are new every release fail winget's Defender reputation check (`Validation-Defender-Error`).
- **winget:** [microsoft/winget-pkgs#448536](https://github.com/microsoft/winget-pkgs/pull/448536) (0.4.2) is blocked by Defender. The zips go to Microsoft's WDSI file submission; once they're cleared, close #448536 and open one PR for the latest version.

## Language and compiler

- **Possible version drift** from the conformance run (details in the uncommitted `conformance-local/NOTES.md`), left alone until confirmed against a current beta:
  - `Formatter` printing as a struct;
  - one-character strings as `u8` (`x += "s"`, `ifx 1 else "a"`);
  - slice `==`;
  - constant float division by zero;
  - leniencies such as `u32 & ~0x7`.

## Extensions

- **Add portable SIMD (`Extensions/SIMD`).**
  - Type-safe: check at compile time that operations are valid, and pick the best lanes and layout.
  - Runtime feature detection is a requirement.
  - For type-safe API inspiration, look at `fearless_simd` and `std::simd` (Rust) and `std::experimental::simd` (C++).
  - Dogfood on chess-jai: it hand-writes SSE with a CPU fallback. Rewrite those parts with portable SIMD and benchmark them.

## Later

Not needed yet. These could live in a separate repo (server and client together) or in `Extensions/`.

- **Build an HTTP server.**
  - Uses reflection to generate an OpenAPI schema, or exposes an intermediate form that an OpenAPI generator and other tools can ingest.
  - Handlers take typed arguments that the request is parsed into, like axum.
- **Build a type-safe HTTP client** that parses an OpenAPI spec at compile time so every call is fully typed.
- **Build an ergonomic compile-time ORM** (Postgres).
  - Generates optimized SQL at compile time from how the whole query and its result are used (only the columns read, joins instead of N+1 lookups), and raw SQL can be mixed in.
  - Every query's result is typed by preparing it against a real Postgres at compile time, and results parse straight into generated types with nothing dynamic at runtime.
  - The database is embedded, so there are no dependencies: PGlite (Postgres compiled to wasm, in memory) driven from the metaprogram through a wasm runtime. It applies the project's migrations, then types every query. Cache the migrated schema keyed on a hash of the migration files so builds stay fast.
  - Every query is known at compile time, so all of them can be prepared and cached.
  - Cache each query's types keyed on its SQL plus the schema hash, so a migration that changes a column type invalidates it automatically. Record the tables and columns each query uses so a migration only invalidates the queries it affects.
  - The cache can be committed (like sqlx's offline mode) so CI and fresh clones build without booting the database, with a check that fails when it's stale.
  - Fallback if PGlite's extension set is too limited: per-platform Postgres binaries, like the `embedded-postgres` packages.
- **Build a compile-time regex** (e.g. a `regex` `#expand` macro) that generates optimized matching code, so no regex library is needed at runtime.
  - Returns a generated type with named captures and exact sizes.
  - Infers capture types where it can: a group that can only match a few strings becomes an enum, and `[0-9]+` parses as a number.
  - Can match into a struct you declare: `stuff: Result; re.match(text, *stuff)` (or `re.match(text, Result)`). Fields map to groups by name and each field's type decides the parsing (`color: Color` parses the enum by member name, `count: u8` is range-checked). A field without a group, or a group without a field, is a compile error.
  - Chooses the best strategy for each part: DFA, exact match or backtracking.
