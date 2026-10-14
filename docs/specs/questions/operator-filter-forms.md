# Operator filter forms

Resolved: official Jai0.2.030 observations supplied by root establish `"-"` as
the public using-only filter spelling, and reject the internal `"operator-"`
string as an operator selection. The reviewed public inventories contain
`+ - * / == != < <= > >= [] []= *[]`; their existing declaration identities are
translated consistently at the name-filter boundary.

Reviewer/root request: confirm public names for any additional supported unary
`!`/`~`, remainder, bitwise/shift, compound-assignment and conversion operators,
including whether pointer indexing is exactly `"*[]"` in filters. Operator
syntax accepted by the independent scanner does not itself establish the
reference filter API. Mapping overloaded operators and virtual member names are
not established by the reviewed aggregate-map examples and remain unchanged.

The six canonical facade migrations are dependency use, not new public APIs or
new overloads. Their owners should replace internal strings with the corresponding
public symbols and retain every existing parameterized import instance.
