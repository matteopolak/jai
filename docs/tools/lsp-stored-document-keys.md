# Stored document keys for filesystem aliases

This corrective batch is required with 886abcd9. Earlier URI checks did not force
syntax fallbacks and are insufficient for final acceptance.

A request now obtains the actual stored URI and current buffer together through
Session::document_entry. Session hover, definition, completion, document symbols
and their binding helpers propagate that key. Own-file private and local checks
therefore compare stored identities. Source-detail extraction accepts a Document,
so it cannot accidentally index a URI map with a caller spelling. Assembly scope
completion obtains the same stored entry before checked/syntax lookup. Disk
workspace symbols exclude any filesystem-proven open identity through open_file_uri.

No filename case folding, private export broadening, symbol-specific handling,
parser/compiler changes or stdlib/Extensions changes are included.

## Reproductions and checks

All receipts are under assigned T7
scratch/uri-stored-key-20261016. The fresh independent source snapshot has raw
fingerprint 6b22bdece46c37c484c2370d2b2827f4da0d964bcca08a698b16aa46d4456c09
(the raw inventory includes filesystem AppleDouble metadata). Narrow prerequisite
patching preserves the shared producer's auto-import aliases and stdlib_root work.

- focused-red.log: declaration binding and document details panic, own private
  binding missing, workspace symbol duplicated. The initial inactive-branch
  assembly expectation returned no checked names; this did not prove its path.
- focused-red-prelude.log: explicitly unavailable prelude forces real assembly
  syntax fallback and reproduces the source-detail panic. All five tests fail.
- lib-green.log: 36 library tests pass, including six original stored-key tests.
  Public hover asserts the syntax fallback note, definition preserves stored
  spelling, private completion works, another file cannot obtain private bindings,
  and an unproven uppercase filename remains a missing document.
- native-red/: real macOS stdio requests reproduce internal errors for alias
  hover (missing prelude) and document symbols (production stdlib). No Jai
  programs are run.
- native-green/: four phases, two fresh servers and 40 feature requests pass.
  Each server opens a symlink URI, queries the canonical file URI, then edits
  through that URI at UTF-16 positions following an emoji. Hover/definition on
  declaration, local and own-file private uses, assembly/private completion,
  document symbols and workspace-symbol deduplication are asserted.
  The deliberately unavailable-prelude server retains the explicit startup
  configuration warning; it is fallback evidence, not production-library proof.
  The second server uses the current independent production stdlib.
- Scoped rustfmt and warnings-denied LSP Clippy pass. Expanded existing suites
  are being rerun with explicit T7 TMPDIR; their final result is recorded in the
  progress file and subsequent handoff.

Run tools/lsp_stored_document_keys.py with --binary, --stdlib and --output all
inside the assigned T7 LSP namespace. It records transport, stderr and structured
assertion results. It requires native local symlink support; native Windows
requests remain a coordinator requirement and are not established by macOS.

## Integration requirements

Final merged acceptance still requires the coordinator to adopt this correction
with the existing URI/query-safety handoffs and rerun normal native Windows and
merged corpus checks. The distinct callback batch will consume approved compiler
metadata 41233d85 through integrated ba0d992c (constant-extraction fix included).
Its safe handoff was located at ../producer-handoffs/current-repair-batch; do not
stack both full patches. The current root source snapshot did not yet expose
those accessors when this URI batch was tested. No callback completion claim is
made here. No release, remote action or benchmark was performed.
