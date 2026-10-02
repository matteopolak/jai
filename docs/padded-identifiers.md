# Padded identifiers

## What it is

An identifier can contain a backslash followed by ASCII spaces to align its suffix with nearby declarations. `time\        _report` has the same interned spelling as `time_report`, while its source span includes the padding.

## How it works

The lexer keeps one token across each backslash and following spaces. `Token::spelling` removes those portions when a name is classified or interned; ordinary names return a borrowed spelling. Raw token spans continue to drive diagnostics, source capture, and source browsing. Canonical names also classify keywords and built-in type annotations, so padding cannot create a separate symbol or evade keyword recognition.

This follows the supplied `Jai_Lexer` source's `parse_ident` loop. Only ASCII spaces after a backslash are padding. Tabs, newlines, comments, and other whitespace terminate the token; an ordinary space without a backslash still separates tokens. A backslash must occur inside a name, rather than starting a standalone identifier. Existing Unicode name characters retain their original UTF-8 byte spans.

The unchanged Compiler source uses this spelling for `Message_Performance_Report` fields. The pinned `5B.ident_back.jai` examples declare `hel\ lo` and reference `hello`; Focus uses padded names in editor and File_Async sources.

## How to change it

Update identifier scanning and `Token::spelling` together in `jai-lexer/src/lib.rs`. Name consumers should use the canonical spelling and retain the token's original span. `Parser::name`, built-in type classification, and note-name interning are the syntax boundaries; do not normalize the whole source text or change diagnostic offsets.

Lexer regressions cover keyword classification and boundaries. `jai-syntax/tests/padded-identifiers.rs` checks the supplied Compiler field shapes, canonical symbol identity, padded built-in annotations, and rejected newline joins.

## Configuration

There are no flags or environment variables. Padding is part of the source grammar, independently of module loading and target selection.

## Dependencies

The implementation uses `jai-lexer` tokens, `jai-source` byte spans and spelling interner, and the existing `jai-syntax` name/type parser. It adds no external dependencies and executes no supplied compiler artifact.
