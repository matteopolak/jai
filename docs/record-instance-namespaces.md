# Record instance namespaces

## What it is

A record instance can read its actual declared namespace members and its own baked template parameters. This supports unchanged source such as Focus Ring_Buffer's `ring_buffer.Size`, while preserving canonical nominal identity and storage field behavior.

## How it works

Member lookup resolves actual storage fields and promoted field paths first. The optional field lookup returns `None` only when the member is absent; ambiguous promotion, cycles, and invalid record metadata remain errors. Successful field projections retain their existing live storage places.

When no field exists, specialized instances expose their original declared members and original template formals. The broader environment used to check a nested definition can contain outer or injected names; those names do not become additional instance members. Local namespace lookup retains its declaration registry policy.

Simple local, global, or static receivers can supply a namespace member directly. A receiver expression that needs evaluation uses the existing `Bind` expression with a genuine procedure-owned binding identity, then yields the checked member value. Pointer receivers bind the pointer expression without loading the pointed-to record merely to read a namespace constant. An effectful receiver of a Type or Code member currently produces a located error because its evaluation cannot be represented by the existing compile-time member path. Pure instance Type queries remain supported.

## How to change it

`jai-sema/src/modules/aggregates/instance_members.rs` owns namespace fallback and receiver evaluation. `member_value` in the aggregate resolver calls it after field absence. `local_declarations/metadata.rs` provides `optional_field_path`; preserve its distinction between absence and a failed projection.

The specialized namespace owner checks original source member names and formal declarations through actual record origins. Do not use every name in the specialization's evaluation substitution as a member. Keep pointer evaluation separate from record dereferencing, and allocate expression binding IDs through the checked owner allocator. Candidate preview reads immutable published namespace facts; it cannot trigger method bodies or describe an effectful receiver's constant member as a baked argument.

The bounded checkpoint `artifacts/component-checkpoints/collection-source-runtime-20261002T140932Z/validation.json` passes source fixtures for value and pointer receiver effects, pure Type members, inherited-name rejection, and the effectful Type boundary. The complete unchanged Focus Ring_Buffer fixture also completes in the VM and generated native execution, demanding actual `.Size` access during specialization.

The same checkpoint privately stages a Type-annotation path for `[]map.Entry`, required by unchanged Vk-Engine Hash_Map. It uses the named storage binding's actual record or pointer-to-record type and then checks the same allowlisted namespace members. It evaluates no runtime receiver. A real storage field takes precedence and cannot become a type; a constant member also cannot masquerade as a Type member. The helper and narrow `local_type_name` consumer are retained in the checkpoint's source and patches; their live activation remains pending the integration lease.

## Configuration

No new flags. Existing definition substitutions, source checking policy, expression binding ownership, record metadata, and ordinary compile-time Type rules apply.

## Dependencies

The record specialization registry and local declaration registry retain original members and baked values. Canonical type and field IDs establish lookup identity. Existing `jai-ir` projections and `Bind` expressions execute through the Rust VM and LLVM backend.
