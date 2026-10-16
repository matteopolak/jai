# Passive IDE entry metadata

Compiler::ide_selected_entry_path() returns Option<&Path> for the existing captured IDE entry. It borrows the canonical path already recorded by prepare_sources; it performs no source read, import expansion, settling, interpretation, selection or allocation.

The current capture is the first file input in the initial prepared source batch when IDE facts are enabled. String-only batches and non-IDE compilers return None. Adding a file later does not invent a replacement for an initially unknown entry. This accessor exposes the existing observation; it does not broaden source selection or infer a main file from loaded modules.

LSP can serialize this optional observation for generated workspace compilers alongside its own known Session entry/import directories/workspace identity. None must remain unknown. Source-loaded and program-complete observations remain separate: a captured entry is not proof that its sources were reached or checked.

Three original tests verify a canonical path containing spaces and Unicode, passive reads while a failing top-level assertion remains unsettled, string-only and late-file unknowns, and the non-IDE case. No language-server implementation or Jai public API is changed. The frozen603 audit receipts remain as captured; this addition cannot retroactively identify their unknown analysis roots.
