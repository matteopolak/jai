# Literal syntax

`jai-syntax` decodes quoted strings, byte character literals, and here strings without invoking the supplied compiler. String values remain `Vec<u8>` because Jai strings can contain arbitrary bytes, including zero and invalid UTF-8.

## How it works

The lexer records raw token spans. `literals.rs` decodes these spans, and the expression parser records the resulting literal kind. Here strings keep a separate `HereStringLiteral` with decoded `bytes` and ordered typed `modifiers`; this preserves their identity for later tooling and lowering.

Quoted strings support `\e`, `\n`, `\r`, `\t`, `\"`, `\\`, `\0`, `\xAB`, `\d123`, `\uABCD`, and `\UABCDEF12`. Hexadecimal byte escapes require two digits; decimal byte escapes require three digits and must fit in 255. Unicode escapes must denote a valid Unicode scalar and produce UTF-8 bytes. `\%` produces the formatting sentinel byte `0x1f`, rather than a percent byte. The print subsystem eventually interprets that sentinel as a literal percent.

The supported `#char "A"` subset decodes one byte. The decoder also accepts `#char "\xFF"` and `#char "\0"`. Empty strings, multiple decoded bytes, and multibyte Unicode text such as `#char "é"` produce a diagnostic. This byte interpretation follows recent corpus examples describing `#char` as yielding `u8`, together with the supplied byte-oriented module usage. The supplied tutorial does not establish non-ASCII `#char` semantics, so Unicode-codepoint character interpretation remains unverified and unsupported.

Semantic expressions, constant evaluation, and overload matching all retain that decoded byte as a typed `u8` constant. It therefore compares directly with indexed string bytes in both VM execution and generated native code; it does not acquire the weak type of an ordinary integer literal.

Here strings start after the header's newline and end before the terminator line. Leading spaces and tabs in the body remain intact. A terminator can be indented with spaces or tabs; a longer identifier such as `ENDING` does not terminate a string tagged `END`. The newline before the terminator stays in the body. Empty bodies are allowed.

```jai
text :: #string END
    "quoted text" and \n remain verbatim
END

windows_text :: #string,cr END
one
two
END

format_text :: #string,\% END
discount: 50\%
END
```

Default here strings normalize CRLF to LF. `HereStringModifier::CarriageReturn` (`cr`) normalizes both LF and CRLF to CRLF. `HereStringModifier::FormattingEscape` (`\%`) decodes only `\%` into byte `0x1f`; other backslashes remain verbatim. Modifiers can be combined, and their source order is retained. Unknown and duplicate modifiers produce explicit diagnostics; indentation trimming and other unverified modifier behavior are unsupported.

Decimal floating-point literals preserve an exact canonical lexical spelling with separators removed. `DecimalLiteral::round_f32` and `round_f64` parse directly at the requested width, avoiding an intermediate `f64` conversion for `f32`. Finite overflow is reported at rounding time. `0h` bit literals retain exact 32-bit or 64-bit IEEE-754 bits. Hexadecimal fractional floats remain explicitly unsupported because the supplied number tutorial establishes `0x` integers and `0h` bit patterns but does not establish fractional `0x` semantics.

## How to change it

Update the decoders and focused tests in `crates/jai-syntax/src/literals.rs`. For a new literal kind or modifier, also update the public reexports and the expression parser hook. Keep here strings distinct from ordinary strings, and verify any new transformations against supplied source or a pinned corpus example before implementing them.

The lexer owns token boundaries and terminator detection. Keep its rules and decoder validation aligned. The tests include complete here-string tokens from the supplied string tutorial and the recent Focus configuration parser, plus malformed forms, newline normalization, formatting sentinels, byte characters, and decimal rounding boundaries.

Run `RUSTC_WRAPPER= CARGO_TARGET_DIR=target cargo test -p jai-syntax --locked -j1` for syntax validation. These tests compile this Rust implementation and read source fixtures; they do not execute original compiler binaries, libraries, or object files.

## Configuration

No environment variables affect decoding. Literal headers configure here-string transformations using `cr` and `\%`. Float rounding width is selected by the caller through `round_f32` or `round_f64`.

## Dependencies and evidence

The decoder relies on `jai-source` for spans and diagnostics, `jai-lexer` for tokenization, `jai-types` for float widths, and the internal integer decoder. It adds no external dependency.

Behavior is grounded in `reference/how_to/005_strings.jai` (byte escapes, verbatim here strings, and newline normalization), `reference/how_to/018_print_functions.jai` (`\%` and the `0x1f` sentinel), and `reference/how_to/002_number_types.jai` (numeric separators and `0h` bits). Recent `#string,\%` examples are in `corpus/upstream/focus-editor--focus/src/config_parser.jai`. The byte character evidence includes `corpus/upstream/withlang-dev--open-jai/utils/stress.jai` and `reference/modules/Text_File_Handler/module.jai`. Corpus revisions and source provenance are recorded in `corpus/upstreams.json`; this source evidence does not imply compatibility verified by running the original compiler.
