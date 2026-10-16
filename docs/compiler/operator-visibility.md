# Operator visibility through canonical type aliases

Root's independent public behavior receipt (coordinator-language-oracles.json)
rejects both symbolic subtraction and explicit operator calls through a facade
that exports only a canonical type alias. Direct Definition imports pass both.
An alias preserves type identity, but does not import its defining scope's names.

Symbolic candidate discovery previously searched operand declaration scopes in
addition to normal lexical lookup. This exposed private imports and bypassed
filtered reexports, while explicit calls already used ordinary lookup. Candidates
now use normal scope resolution, preserving visible overload sets and normal
lookup errors. Unary, binary, comparison and indexed getter/setter/address paths
share this rule. The separate for_expansion protocol lookup is unchanged.

Original tests reject hidden symbolic/unary/explicit forms and accept direct or
filtered using reexports. This does not invent public Math or other facade exports.
Facades that need public operators must expose their documented overloads through
normal reexports; dependency owners must review that inventory. Existing accidental
operand-home success is not a compatibility oracle and must not be retained by a
module-name exception.
