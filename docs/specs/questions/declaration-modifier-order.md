# Declaration modifier order

Open: the specs describe `using`, `#as` and `#no_reset` individually but do not
say how they combine in front of a declaration. The parser accepts `using`,
`#as` and `#no_reset` in any order before the declaration, because a
third-party program writes `using #no_reset model: Model #align 64;`.

Unconfirmed: whether other flag directives (`#program_export`, `#elsewhere`)
are also permitted between `using` and the name, and whether the order is
significant.
