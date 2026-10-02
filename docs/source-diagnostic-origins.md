# Source diagnostic origins

## What it is

Diagnostics can retain the exact `SourceId` that owns their byte range. This
keeps errors in quoted code and compile-time execution attached to the original
file after semantic lowering restores the caller's lexical context.

## How it works

`Diagnostic::new` creates a range whose source is supplied by the calling
compiler stage. `Diagnostic::at_source` accepts a complete `SourceSpan` and
retains its explicit source identity. `with_fallback_source` fills only a missing
identity, so an outer insertion or procedure cannot replace a nested error's
origin. `LocatedDiagnostic::new` honors that explicit identity before using its
fallback source.

Quoted lowering attaches its retained source before restoring name lookup and
source overrides. VM failures already carry a `SourceSpan`; conversion back to a
semantic diagnostic preserves it. Rendering looks up that identity in the same
compilation's `SourceMap`, which owns the original text and file path. A path
string never determines source ownership.

## How to change it

When converting a located error to a plain diagnostic, use
`Diagnostic::at_source(error.location, error.message)`. When returning an error
from lowering code with a temporary source origin, attach that origin before
restoring the context, preserving any explicit origin already on the error.
Add a cross-file regression that checks both the source record and the exact
source text selected by the byte range.

## Configuration

There are no flags. Source identities belong to one compilation session and
must be resolved with that session's source map. Byte ranges remain half-open
UTF-8 offsets; rendering uses one-based line and character-column coordinates.

## Dependencies

`jai-source` owns the diagnostic types and source map. `jai-sema` propagates
origins across quotes, macros and `#run`; `jai-driver` renders located errors.
