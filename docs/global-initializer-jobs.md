# Retained global initializer jobs

## What it is

File storage initializers are retained source jobs between checked header preparation and final global publication. Each job preserves its original declaration, defining file, expected canonical type, reserved `GlobalId`, and shared-allocator execution owner.

## How it works

`modules/global_initializers.rs` keeps the parser-owned initializer expression. The preparation phase queues these recipes after genuine field defaults are ready, then the existing compile-time worklist checks and evaluates each expression with its actual source scope, provider, cache, context schema, and effects handler.

An aggregate callback initializer uses the ordinary anonymous procedure producer. Its procedure value, checked body, calling convention, and source receipt remain in the retained semantic arenas. An unavailable body or value becomes a real worklist dependency; reserving a storage identity does not publish a zero value or storage binding.

Publication follows original declaration order. A ready value must match its reserved global identity and expected type before its storage binding enters the file namespace. External declarations retain their checked external storage metadata. Initializers without expressions use the actual established default schema.

After initialization, the phase completes parameter defaults and proceeds to full body binding. `Worklist::refresh` merges newly checked signatures and reserves one genuine owner for each newly appended alignment request without replacing the VM cache or resetting the auxiliary allocator.

## How to change it

Change `Jobs::prepare` when adding an initializer source form or type inference rule. Change `Job::evaluate` when extending checked expression materialization, and keep the source authority and expected type attached to the original request.

Keep publication separate from evaluation. An evaluation context borrows the currently published globals; a successful result is published only after those context borrows end. Extend the readiness dependency channels when another unpublished source resource is required.

`prepared_global_initializers` covers a real aggregate anonymous callback and a global alignment job appended after the worklist was created. `prepared_headers` covers field-default ordering and retained source effects.

## Configuration

Jobs inherit the retained `ResolveOptions`, target layout, compile-time limits, compiler adapters, runtime adapters, and effects policy. A different source graph or target requires a new phase.

## Dependencies

The jobs use `jai-modules` declaration identities, `jai-types` canonical types, `jai-ir` globals and procedure values, the semantic anonymous procedure producer, and the existing `jai-vm` readiness and transactional execution path.
