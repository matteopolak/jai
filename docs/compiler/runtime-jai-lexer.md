# Independent runtime Jai lexer

`stdlib/Jai_Lexer` exposes the reviewed public token values, data records and
procedure signatures. `tools/generate-jai-lexer-contract.py` generates declarations
and the keyword/operator tables from the reviewed inventory. The scanner is newly
implemented Jai under `stdlib/internal/jai-lexer`; it never delegates tokenization
to the Rust compiler, parser, a supplied executable or a reference library.

## Behavior

The implementation has eight buffered lookahead slots, copied identifier storage
through the public Pool allocator, independently allocated string contents,
ASCII identifiers/keywords, notes, nested block/line comments, numeric radices,
decimal exponents and documented float precision flags. Hex float widths are
validated. String decoding handles ordinary escapes, byte/decimal escapes and
Unicode scalar escapes. Here strings implement delimiter boundaries, whitespace
in the `cr` header modifier, retained indentation and CRLF conversion.

Error reporting sets `reported_error` and writes a diagnostic. Integer overflow
retains the wrapped accumulated value and sets OVERFLOWED; invalid binary digits
remain available to the next token. Invalid digit helpers leave the character
unconsumed. A second decimal point is consumed before reporting an error.
The scanner and public helpers perform real work; none return invented tokens or
success statuses for failed operations.

Coordinates are one-based byte coordinates in this independent implementation.
The reviewed contract does not settle every initial coordinate/counter convention,
malformed recovery case, note grammar or parser disambiguation token spelling;
those remain questions. Identifier hashes are zero and explicitly unspecified by
the contract. The copied identifier strings retain the lexer's atom-pool lifetime;
input strings must remain alive until scanning finishes. `set_input_from_file`
uses the public File API and owns that input until reset.

## Verification

The public token/EOF fixture and two new fixtures exercise lookahead, coordinates,
keywords/operators, nested comments, fractional precision, IEEE bit patterns,
string escapes, here strings and malformed input/overflow. All three passed in
both interpreter and native LLVM execution against the independent foundation.
Run them through the test overlay described in [compiler facades](compiler-facades.md):

```sh
TMPDIR="$PWD/target" python3 tests/stdlib-contract/run.py \
  --jaic "$PWD/target/debug/jaic" --stdlib-root "$PWD/target/cleanroom-test-stdlib" \
  --case jai-lexer-token-and-eof-contracts \
  --case jai-lexer-lookahead-precision-and-here-strings \
  --case jai-lexer-malformed-prefix-and-overflow
```

Repeat with `--mode native` to exercise the runtime code emitted by LLVM.
