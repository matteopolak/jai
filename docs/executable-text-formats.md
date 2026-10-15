# Executable lexer and text-based dylibs

These implementations use reviewed public records and official Apple SDK text
stubs. They do not depend on the differently shaped Jai_Lexer records. No compiler
exceptions, original/reference bodies, vendor implementations or raw reference
logs were used.

## Lexer policies

Coordinates are one-based byte positions with exclusive token ends and LF line
breaks. The eight-entry circular queue accepts lookahead indices 0–7. Exhaustion
returns an ERROR sentinel, sets reported_error, prints a diagnostic and leaves
queue/cursor intact. Repeated peeks do not rescan/report. eat_token advances the
queue; get_last_token returns the previous consumed slot.

Identifiers begin with ASCII letters, underscore, dollar or high bytes; digits
may continue them. The limit is 512 bytes. High bytes are not a Unicode identifier
classification claim. The vocabulary has no reserved-word token variants, so
names remain IDENT; check_for_keyword recognizes the exposed triple punctuation
spellings. Other punctuation uses its byte value.

Numeric tokens use IDENT plus NUMBER/value flags and retain source spelling,
because this reviewed enum has no NUMBER member. Decimal/hex/binary integers,
integer underscores, fractions and signed decimal exponents are scanned.
Malformed digits/prefixes/separators/exponents report ERROR. Integer range
overflow sets OVERFLOWED; float range and binary32 requirements use Basic's
float64 converter after removing integer separators. Floats default to float64;
more than 15 scanned mantissa digits conservatively request float64 precision.
has_a_big_exponent uses nonzero absolute values below 1e-4 or at least 1e15.

Double quotes decode ordinary C escapes, raw-byte hex escapes and Unicode
4/8-hex-digit escapes into UTF-8, rejecting surrogate/out-of-range scalars.
Single quotes use doubled quotes. Triple-double-quoted here strings retain raw
multiline content. Line and nested block comments are supported. Here-string
line count is one plus embedded LF count; non-here strings return zero.
nonblank_lines_processed counts token-start lines; total_lines_processed counts
consumed LF bytes.

check_for_equals expects the cursor following an already scanned base operator.
If equals follows, it selects augmented minus subtractor using checked wide
arithmetic and optionally consumes equals; otherwise it selects c. Character
and digit helpers bound EOF, invalid digits leave the cursor unchanged, and
unwinding safely recomputes the prior byte position. Remainder requests must
match current coordinates and consume an optional following LF.

String input is borrowed; file input is owned and freed on reset. Resetting to
a subview of owned input copies it before release. user_data survives reset.
Reset to an empty string to release file input. Identifier/numeric/here-string
text borrows input; decoded strings use Basic's temporary allocator until reset.
Queue slots survive until consumed/reused or input is reset. Error diagnostics
set the public flag and external-error line field; details do not set the flag.

## TBD policies and ownership

The parser supports UTF-8 Apple TBD YAML v3/v4, multiple documents, comments,
quoted/plain scalars, multiline flow lists, trailing commas and block scalar
lists. Tags select the schema; v4 requires tbd-version 4. Install name and
nonempty targets are required. Duplicate keys/root targets, groups outside the
declared targets, invalid UTF-8 and malformed/unsupported input fail safely.
YAML comments require separation whitespace, so embedded hash characters survive.
YAML hex escapes denote Unicode scalars and produce UTF-8 rather than raw bytes.

V3 arch/platform lists normalize to targets: macosx becomes macos, Intel mobile
targets select simulators, and zippered architectures select macos/maccatalyst.
Supported v3 architectures/platforms are explicit in tbd_map_targets. V4 preserves
target strings, including SDK extended architectures.

Exports preserve target groups. Ordinary, weak and thread-local names populate
symbols. Objective-C classes expand to class/metaclass names; ivars and EH types
receive their standard symbol prefixes. Reexported libraries populate re_exports;
v4 reexports symbol groups populate that field with the same ObjC expansions.
Unrepresented metadata (versions, flags, clients, umbrellas) is parsed in the
supported scalar/list/map spelling and ignored. This is not a general YAML
engine: aliases, anchors, arbitrary tags, flow maps, block scalars, multiline
quoted folding and TBD v1/v2/JSON v5 are unsupported. Historical edges are not
claimed.

Memory and file APIs return deep-owned strings/arrays. Input may immediately be
freed or modified. File APIs always release their read buffer. Free each target,
symbol and reexport string, their arrays, install name, group array and document
array with matching Basic free/array_free; tests show the full release sequence.
Failure releases all partial documents and returns a null empty slice. Basic's
checked allocation policy applies; recoverable exhaustion is not promised.

## Independent evidence

tools/build_executable_text_fixtures.py authors v3/v4 data accepted by the SDK's
tapi archive info/list-symbols commands. SDK libobjc/libSystem samples are copied
only to untracked target storage. Tests inspect public fields and dump symbol
sets. tools/check_executable_formats.py compares every returned main-document
exported symbol per architecture with Apple's tapi output after interpreter and
each native Mac O0/O2 run. Original fixtures include embedded hashes and YAML
Unicode escapes. SDK libSystem exercises dozens of documents and reexports.

Tests cover queue wrap/exhaustion, helpers/diagnostics, comments, numeric range,
escapes/here strings, identifier limits, file/subview lifetimes, owned TBD results,
block/flow lists, duplicate/unsupported/malformed input, invalid UTF-8, partial
multi-document cleanup and every prefix of an original TBD. Complete prefixes
may validly omit optional exports/end markers; their public shape is checked.
Tracking allocators reach zero. Diagnostics are retained, validated and compared
byte-for-byte across execution modes.

Read-only clean-room review reproduced embedded-hash and YAML-hex bugs before
repair. Regressions first failed, then passed with tapi equality; the reviewer
independently confirmed interpreter/native repairs. Source tools use the assigned
T7 target directory and Cargo jobs=2.
