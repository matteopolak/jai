# Source and caller locations

`#caller_location` is a deferred procedure parameter default. Omitting the argument produces a value of the source-declared `Source_Code_Location` type at that call's source span.

`#location()` produces that nominal record at the directive's own source position. `#file` produces the exact retained UTF-8 filename, `#filepath` produces its containing directory, and `#line` produces the one-based source line as `s64`. These source expressions are also immutable declaration-site constants; a `#location()` parameter default keeps its definition's coordinates when called later.

## How it works

The syntax tree retains a `CallerLocation` expression marker. Semantic signatures and callback metadata carry `ParameterDefault::CallerLocation` separately from immutable `ConstantValue` defaults. Generic matching retains the marker and its proved nominal type; specialization never substitutes fabricated coordinates.

The same carrier represents `#code,null` as a typed `CodeNull` default. Checked compiler source adapters consume its semantic Code identity before publishing a runtime call. The ordinary runtime argument binder rejects that default; Code has no runtime constant or storage representation.

The shared callable argument binder materializes omitted defaults after binding supplied arguments. It validates the actual source nominal's field order and types: `fully_pathed_filename: string`, `line_number: s64`, and `character_number: s64`. Inferred defaults resolve the visible `Source_Code_Location` declaration through the defining file's module scope, including the adopted Preload declaration when bootstrap is enabled.

Expanding procedures validate caller-location formals in their defining scope for both supplied and omitted arguments. Their omitted caller defaults use the same typed carrier and materializer, after supplied arguments have been bound. Other evaluated omitted macro defaults retain the existing unsupported diagnostic.

The first header phase reserves callable types before defining record fields. Location inference therefore proves the retained source nominal identity during reservation, then checks its fields in complete headers and at materialization. Moving field validation ahead of record definition would reject valid inferred defaults.

The filename comes from the retained `SourceMap` record. `#filepath` uses that path's parent directory without adding a separator; the root directory remains `/`. A source with no retained parent directory produces a diagnostic. No working-directory or lexical-scope fallback substitutes another path. Line and character numbers are one-based; characters count Unicode scalar values rather than UTF-8 bytes. Quoted-code source overrides preserve the quoted call's original source independently of the insertion's lexical binding scope. Explicit location arguments and ordinary record defaults retain their supplied values.

Macro expansion retains an ordered chain of invocation `SourceSpan` values independently of the macro definition's AST origin. A deferred caller default uses the latest active invocation; a literal source directive uses its retained AST origin. Arguments and defaults of an expanding procedure bind before its invocation is pushed. A nested macro's default can therefore retain the enclosing invocation; a call generated inside its body sees the nested invocation. Passing a location explicitly preserves that record through further calls. Inserting original quoted code temporarily restores that code's own provenance, then restores the expansion state on success or error. Neither debug suppression nor lexical scope changes erase source identity.

The supplied source contracts distinguish directory and filename: `reference/modules/File_Utilities/examples/path_example.jai:5` uses `#filepath` to set the working directory, and the metaprogramming tutorials append a `/` when building paths from it. The supplied `reference/CHANGELOG.txt` entries at lines 3285 and 3360 describe relative compiler paths and diagnostic propagation through caller locations; they do not specify an outermost replacement for nested macro invocations. The tests preserve the latest recorded invocation and explicit location forwarding without discarding the retained chain.

```jai
probe :: (loc := #caller_location) -> s64 {
    return loc.line_number;
}
main :: () -> s64 {
    return probe();
}
```

## How to change it

`crates/jai-sema/src/caller_locations.rs` owns nominal validation and deferred-default binding. `source_locations.rs` owns retained source validation, coordinates, and record materialization. `procedure_values/bind_arguments.rs` is the shared call binder. Keep direct, indirect, named, local, and generic defaults on that path; procedure type identity itself does not include source names or defaults.

Source provenance overrides use the same semantic debug capture as retained debug information. Extending quote insertion or macro expansion must install and restore that override while resolving the retained syntax. A `#caller_location` marker in an ordinary expression or a scalar parameter default produces a diagnostic.

Keep source leaves in the scoped typed constant evaluator and its literal inference/classification paths. The source-free scalar parser/evaluator cannot invent a file context. `#location()` currently accepts an empty argument list; declaration queries such as `#location(#this)` require a separate declaration-provenance service and receive a precise rejection.

## Configuration

Runtime location expressions and deferred caller materialization require an explicitly selected `ResolveOptions.target` or `ResolveOptions.layout`. They validate the nominal layout against that policy; they do not guess host target facts. Filename, directory, and line leaves have no target-layout requirement. Immutable declaration-site location constants follow the existing typed record-default path; explicit location overrides do not require deferred materialization.

## Dependencies

This feature relies on the syntax marker, the module graph's nominal declarations, `jai-source` immutable records, `jai-types` layout validation, semantic callback metadata, and the VM/native record and string value paths.

The independently authored `jai-sema` caller-location tests exercise source semantics, VM execution, quoted source, compile-time calls, and rejection boundaries. `jai-codegen/tests/caller_locations.rs` checks exact filenames and Unicode columns in VM execution and freshly emitted native objects. No supplied native toolchain is executed by these fixtures.
