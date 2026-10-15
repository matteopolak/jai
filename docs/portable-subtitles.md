# Subtitle text and rendering

The Subtitles facade exports the reviewed records, version constant, procedures,
and mutable CSV counters. Canonical Basic.String_Builder and Hash_Table.Table
identities are retained. Private files separate records, parsing/lifecycle,
serialization and renderers. CSV wrappers pass facade-owned counters by pointer;
constant copies cannot satisfy the writable public-storage contract.

The parser uses canonical Text_File_Handler for comments, trimming and version
headers. It borrows memory input and all token/text views. File loading owns the
read buffer. Section lookup is built after parsing so its pointers survive
dynamic-array growth. Error cleanup releases every nested array and lookup;
free releases source bytes only when data_owned, then clears the record.

Serialization creates caller-owned builder output, preserving section/instant/
event ordering and omitting negative times. Float output uses Basic SHORTEST
rather than rounding timestamps. This owned-result lifetime is a provisional
choice pending the focused lifetime question; it is not claimed reference-exact.

HTML preserves raw text and names intentionally, skips empty speakers and
renders emphasis/directions. CSV joins adjacent speaker lines, doubles quotes,
retains embedded newlines and maps names. Document formatting resets row 262;
single-section formatting uses the caller's row number and resets audio index.
Raw section/filename columns are intentional reviewed behavior.

## Public API and execution

| API | Original regression evidence |
| --- | --- |
| Subtitles / Section / Instant / Line / Event, SECTION_VERSION_NUMBER | Parsed fields, enum widths, canonical reflected names, serializer version |
| load_subtitles_from_memory | Borrowed source, comments, CRLF, arbitrary version, finalized/embed, events, negative/nonmonotonic times |
| load_subtitles_from_file | Real Unicode filename and owned source |
| free | Memory input remains live; file-owned value and nested arrays cleared |
| serialize | Reparse canonical output, event-before-instant and line ordering |
| get_sections_for_characters | Input-order uniqueness and empty-speaker matching |
| format_sections_as_html | Document wrapping, raw markup, mapping, emphasis/directions, omitted events/empty speakers |
| format_section_as_html | Container-only output |
| csv_line_number / csv_line_index_within_section | Writable globals change real renderer output |
| format_sections_as_csv | Exact seven-column multiline output and reset behavior |
| format_section_as_csv | Caller row counter preserved |
| flush_csv_lines | Direct call with caller counters, two-digit audio name |
| csv_quote | Embedded quote/comma/newline |

Interpreter and native O0/O2 pass on macOS ARM64. Compiled WASI passes under
tools/wasi_run.mjs with real filesystem operations. Independent Python csv.reader
confirms seven columns and decoded content. Windows-target strict lint passes;
this is target checking, not native Windows execution.

Narrow unresolved positional-event/negative-time serialization, initial counters,
empty-row and temporary-result contracts remain in the questions document.
Malformed headers safely fail even though the reviewed original may fail to
propagate Text_File_Handler errors. No assertions or checks are suppressed.
