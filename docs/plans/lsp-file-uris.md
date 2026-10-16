# Native paths and LSP file URIs

Authorized follow-up from filtered worker inbox. Keep separate from named parameter
completion and preserve b064be58, cf7dd80 and 5214e9c. No peer/compiler/stdlib edit.
Use systematic debugging and original regression documents; no native Windows
success claim from macOS or synthetic tests.

Source trace: VSCode forwards `jai.stdlib.path` via `JAIC_STDLIB`. Incoming URI
parsing currently retains `/c:/...` as a filesystem path. Outgoing definitions,
links, hierarchy and auto-imports concatenate native paths after `file://`, losing
Windows drive syntax and interpreting reserved filename characters as URI syntax.

1. Prove the outgoing defect with real LSP requests against a production stdlib
   under a T7 path containing reserved characters. Add independent API tests for
   definitions/links/hierarchy with encoded URI names. Keep red request captures.
2. Centralize native-path construction and URI decoding in DocumentUri. On Windows,
   local drive URIs map to native absolute drive paths; canonicalize drive letter
   and separators, handle canonical verbatim drive prefixes, encode bytes once.
   Preserve local-only authority policy, root-escape/NUL checks and admission caps.
   Do not blanket casefold filenames: filesystem canonicalization establishes real
   file identity without conflating case-sensitive directories.
3. Route actual filesystem-path outputs through the constructor. Distinguish
   already encoded URI components (expansion documents) from native paths. Reuse
   existing filesystem canonicalization for overlay/cache keys and project roots.
4. Add portable Windows codec/drive cases, native-host URI/path roundtrips, config
   roots and original cross-file API regressions. Verify actual native macOS LSP
   with configured production stdlib, partial edits and fresh servers. Native
   Windows/VSCode verification remains required by coordinator.
5. Run scoped Rust format/Clippy and focused suites, document limits/dependencies,
   commit with conventional subject and no issue number. All outputs stay on T7.

No symbol/module/path-specific resolver exception and no fallback library. UNC
authorities and device namespaces remain explicitly unsupported by the existing
local-file service policy; do not silently turn them into another local path.

Executed: red API/alias/native reductions; central codec and shared proven identity;
140 focused source checks; scoped formatting/Clippy/Python syntax; combined 56
native requests on the production candidate. Fixture setup/oracle maintenance is
separate fc5ade0a, documented in docs/tools/lsp-clean-fixtures.md. Final native
Windows/VSCode and merged corpus/CI remain coordinator requirements; no benchmark.
