# Portable implementation gaps

This worker ledger complements docs/specs/stdlib/questions.md. Local tests prove
the implemented behavior; they do not establish missing reference contracts.

- Text_File_Handler helpers return independently allocated array strings/table
  keys. Callers free each plus container storage. The spec does not yet settle
  exact helper ownership. With version parsing enabled, startup currently requires
  a nonnegative decimal bracketed first processed line; sign/whitespace/missing
  header edges need review. CR/LF/CRLF are recognized; terminal newline produces
  no extra final empty line. Diagnostics include file, line and caller location;
  exact wording is not claimed. Public error receives its handler by value, so
  owning parse/load paths explicitly set the sticky failed flag.
- Remap_Context's lexical expansion is withheld. The pending macro-push-context
  reproducer retains a failed restoration assertion: caller-scope context push
  ends at the macro block. Both remap procedures are implemented. Duplicate
  base/custom names and optional stack-trace adjustment remain unspecified.
- pending/widened-bitwise.jai retains the byte-cast/bitwise narrowing failure;
  Wav_File assembles bytes using explicitly widened locals. Duplicate WAV fmt/fact
  policy remains under review; current parser takes first fmt/data and last fact.
- pending/workspace-hook.jai records compile-time workspace retrieval failure.
  Thread's automatic workspace metadata remains withheld, not fabricated as zero.
- Apollo duration representation/rounding is assumed signed femtoseconds, which
  is not explicitly established in the current spec prose. Do not extend native
  or calendar conversion from round-trip evidence alone.
- Flat_Pool's default reserve and overwrite option scope/value are absent.
- Process finite STILL_RUNNING boolean, live deinit/stdin inheritance, and the
  quote grammar beyond supported double quotes remain under review.
- Command_Line nested/overlay fields, help result/priority/layout and full numeric
  consumption edges remain under review. Flat fields and fixed arrays work.
- System's Linux topology queries currently use the permitted online logical
  fallback. CPU counter semantics are unresolved and that export is withheld.
  Android is not accepted by the current CLI; macOS x64 passwd shape is missing
  from the new native binding inventory.
- The source-built full jaifmt CLI now builds with the new foundations modules
  in an integration directory and passes the complete owned --check scope.
  The temporary file-only frontend has been removed.

Scalar hash seed mixing was clarified in the latest reviewed Hash page. It is
assigned to the foundations worker; no duplicate implementation is added here.
