# Record field default jobs

## What it is

Record defaults containing typed compile-time expressions retain a recipe keyed by their canonical `FieldId`. The recipe waits for actual procedure, constant, or field providers instead of publishing an initializer before evaluation completes.

## How it works

`FieldDefaultJobs` belongs to the compilation's `MetaContext`, which the prepared semantic session retains. Collection copies the original field syntax, defining file, source range, record substitution, and ordered default overrides. It follows by-value record and nonempty fixed-array dependencies; pointer fields and zero-length arrays do not demand the pointed-to or element initializer.

Original typed initializers and overrides enter the queue. Implicit aggregate containers retain dormant recipes until construction demands their whole-field default. This distinction matters for anonymous unions: an explicit selected branch must not be overwritten by an unrelated computed container initializer. Construction checks the original field initializer, ordered overrides, and Context schema to identify source-provided whole-field overlays; a cached implicit recipe alone does not establish an overlay.

The source worklist evaluates jobs before completing record method headers. During header preparation, actual procedure, constant, and field dependencies select the prerequisite work; unrelated method headers and bodies stay deferred. The scoped demand also applies to lazy namespace lookup inside a field evaluator. Ordinary body checking later visits the remaining original source bodies, including local records introduced by a prerequisite method. Execution restores the actual captured record namespace and inherits the current compile-time context and effect policy. A recipe publishes its typed value only after its initializer and ordered overrides succeed and the final field type and constant budget are checked.

Field demand records an exact `Context.pending_field_defaults` dependency. Recipes cache `Ready`, `Pending`, and `Failed` states; retries preserve source and field identities. Pure default preparation returns separate ready values and pending fields. Pending cells supply no runtime initializer.

New specializations created while checking a procedure count as worklist progress. The next sweep collects their source field recipes and prepares their actual method providers. Self-written source and native fixtures cover both private exported record methods and a late `Owner(T)` specialization whose field uses `#run seed()` from its own namespace; repeated construction reuses the same checked initializer.

The prepared phase retains the original initialization tail while this prerequisite worklist runs. It constructs globals and completes ordinary default-bearing headers after the requested field cells are ready, using the same registries, body cache, and procedure identities. Source tests cover a zero-argument source method supplying a field used by both a global record and an ordinary `Record.{}` parameter default. Prerequisites that themselves depend on unconstructed globals and record modifier type preparation remain separate readiness work.

## How to change it

Change recipe collection and state in `modules/field_default_jobs`, source environment restoration in `local_declarations/sources`, and worklist ordering in `modules/compile_time/methods`. Preserve canonical field owners and defining-file substitutions. Extend the typed dependency channels when adding providers; do not classify pending work by diagnostic wording or substitute a zero value.

Default construction must distinguish a source initializer or override from an implicit aggregate recipe. New construction forms should request individual selected defaults when they do not require the whole container initializer.

## Configuration

Jobs use the existing compile-time VM execution limits, constant cell/depth budgets, and selected target layout. They introduce no environment variables or command-line flags.

## Dependencies

The implementation uses `jai-ir` typed constants and fields, `jai-types` canonical metadata, parameterized record substitutions, captured lexical source environments, and the shared source worklist/VM cache.
