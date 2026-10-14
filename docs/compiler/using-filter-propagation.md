# Using filters through binding and layout

Parsed using filters remain attached to resolved procedure signatures. Ordinary
procedure bodies and expanded macros apply them through the shared using-entry
resolver when binding parameter names. Static and computed only/except lists
therefore expose the same selected names as standalone using declarations.
Static and procedure-based name maps resolve back to the original parameter's
members, preserving lvalue storage rather than manufacturing copied fields.

Embedded using fields resolve their computed filters while laying out each
field, using that field's lexical scope. The resulting static names/maps feed
the same promoted-member resolver used by member access, inline layout targets
and name-clash checks. Canonical field names and offsets remain unchanged.

Original core regressions exercise ordinary and expanded procedures, static and
computed only/except, static/computed parameter maps, embedded computed selection
and mapper-based renaming. Pointer comparisons and executed mutations verify
that exposed names address their original fields. An incomplete self-referential
mapper target still encounters the completeness diagnostic; that case requires
further implementation/coverage. Exhaustive collision and nested mapping behavior
is not claimed by these tests.

IDE module completion separately follows filtered transitive reexports. It guards
the current traversal path rather than globally discarding repeated modules,
allowing distinct filtered import paths to contribute different visible names.
