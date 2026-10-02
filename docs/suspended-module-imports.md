# Suspended module imports

## What it is

An import retains its actual module identity and already-discovered public declarations while the provider waits for compile-time discovery. This lets typed discovery resolve a provider's `using` enum without losing aliases in its importer.

## How it works

Argument evaluation first selects a canonical module instance. When expansion returns `GraphError::Pending`, a file import binds that instance and its current exports, then preserves the original pending result. Discovery remains incomplete; an executable cannot be produced from this checkpoint.

For example, `Width :: u64; using Flags :: enum_flags Width { FIRST :: 1; }` pauses at the retained `using` request. Its importer can already resolve `Native.Width` or an anonymously imported `Width`, so semantic preparation can produce the enum decision.

Retries bind the same module and declaration IDs, refresh exports added by completed discovery, and retain one dependency edge for each original import site. Private bindings remain inaccessible. Pending argument evaluation creates no import binding. Lexical imports keep their bindings in the semantic scope that owns them.

## How to change it

The publication boundary is `jai-modules`' `loader/suspended_imports.rs`. Keep pending discovery separate from completed module readiness, and use `bind_import` for the normal visibility and collision rules. When adding a new source representation, retain the original import location and canonical module instance through retries.

The module regressions cover identity, privacy, retry edges, export refresh, and argument waits. The semantic `using-source` tests check both namespace and anonymous imports by executing independently authored programs.

## Configuration

There are no new flags. Existing import modes, module arguments, `GraphOptions.import_dirs`, and source-provider configuration still select the module.

## Dependencies

This uses the module graph, retained `FileUsingRequest` decisions, canonical source identities, and the existing import visibility rules. Semantic acceptance also relies on `jai-sema`'s shared typed preparation and the `jai-vm` interpreter.
