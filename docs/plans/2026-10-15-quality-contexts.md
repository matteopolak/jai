# Target/context lint integration

Use actual repository jaifmt and jailint built against the combined production
library. Source programs supply real public imports and module arguments; no
library file is rewritten or replaced to make tools compile.

1. Preserve original format/lint failure evidence and source hashes.
2. Validate linter manifests: zero exit alone is insufficient; incomplete
   contexts and denied findings cannot establish clean source coverage.
3. Run real reviewed positive programs with explicit native/WASI source targets.
   Preserve private import rules and required module parameters.
4. Aggregate actual complete visited files, retain partial/unvisited files and
   fail the gate for every owned source lacking clean complete coverage.
5. Expand real contexts to remaining producer scopes and configurations.
   Intentional negative programs require precise rejection validation and
   separate classification; they never become successful body lint.
6. Require all remaining profiles, formatting idempotence and source stability.
   Target source checks never establish native SDK/hardware execution.

Initial implementation:49 positive root contract programs, seven targets each,
with explicit MSVC triples and canonical WASI selection. Four protocol tests
reject incomplete/denied/invalid contexts and retain unvisited files. Host
execution checks1137 owned sources;207 have clean complete context,930 remain
uncovered and four context checks fail. This is explicitly incomplete coverage,
not a replacement green lint gate. Original190-check diagnostic report remains.
Next: real producer configured/private contexts, negative metadata and remaining
module profiles; fix actual body/diagnostic findings instead of suppressing them.
