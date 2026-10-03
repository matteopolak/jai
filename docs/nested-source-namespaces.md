# Nested source namespaces

## What it is

Early qualified type annotations can follow transparent named source aliases to nested nominal members. They use the existing owner and nested type reservations even when the independent header pass precedes alias publication.

## How it works

A header such as `stop: *Alias.Overflow_Page` previously looked only for an already published canonical type for `Alias`. If that alias had not reached the original alias cursor yet, graph lookup treated its constant declaration as a namespace and failed.

The type resolver now obtains the shorter namespace prefix from its actual declaring source. Existing lexical bindings and baked type substitutions still take precedence. An original named type alias or unannotated named type constant uses normal recursive alias resolution, including defining-file lookup, the alias cycle guard and typed `PendingType` propagation. The remaining member path is read from the actual record specialization namespace reserved from original nested declarations. No new record shape, member declaration or replacement TypeId is issued.

This is separate from member values and record bodies. A reserved nested nominal can be used as a pointer target; its fields, defaults and methods still require their normal checked source producers. Distinct representations do not unwrap to a transparent namespace, and globals or arbitrary value expressions acquire no namespace through this path.

The reached compatibility source is the authored Basic header `*Temporary_Storage.Overflow_Page`, through Basic's qualified alias to the selected Runtime_Support record. The helper contains no protocol spelling or shape checks.

## How to change it

`modules/aggregates/parameterized/namespace_roots.rs` handles original graph prefix authority; `type_resolution.rs` keeps lexical and substitution precedence and consumes actual reserved member bindings. Add new source forms through their genuine checked resolver and retain typed waits. Avoid selecting a nested type from a guessed layout, substituting a ready outer name for a pending inner binding, or converting pending aliases into diagnostic-only retries.

## Configuration

Normal source type preparation, canonical record reservation and source lookup bounds apply. No platform flag or environment variable selects this helper. The normal target policy remains on the same semantic arena.

## Dependencies

This uses the immutable module graph, Nominals' canonical declaration map, RecordSpecializations' actual reserved namespaces, and the paired TypeResolver. Three new source regressions cover imported alias identity and VM result42, actual placeholder retention, and source storage shadow denial. The exact v2 candidate passed workspace all-target checking and all three regressions on 2026-10-03, with source and tool hashes unchanged (proof `cce3e5482efbaecbd93c3545d30c1a064a3e386a3ec9bd2b115376f31103d58f`). The prior Context gate remains separately accepted. Complete authored Basic acceptance is still pending a rebuilt CLI probe; these regressions establish the nested namespace producer, not the rest of Basic.
