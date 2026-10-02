# S128 and nominal operator questions

Reviewed basic.md supplies S128 equality, ! and four order signatures and Apollo_Time #type,isa S128. These are implemented without an Apollo wrapper. != uses the existing compiler synthesis from ==; independent custom equality controls distinguish this from structural equality.

Open source-only oracle question: does Plain :: #type Base (without isa), with visible Base ordering operators, implicitly participate in the Base operator call? Our independent plain-distinct-oracle-request.jai compiles in our compiler. An earlier negative expectation was unsupported and failed; that RED is retained and no compiler change enforces it. Root may compile the supplied one-file probe using its authorized oracle. No reference source or binary was accessed by this worker.

Not unresolved: #type,isa Base and nested isa comparisons and ! use generic lookup with public visibility. The Struct-only unary eligibility defect was independently reduced and fixed under the exact function grant. A same-shaped unrelated struct still rejects the overload, and private/unimported/filtered-out operators remain hidden.

Remaining reviewed S128 arithmetic exports outside this comparison/! grant: unary -, <<, >>, / and *. Existing + and binary - remain unchanged. This handoff does not claim those facilities complete.
