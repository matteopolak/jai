# Debug_Info clean implementation questions

Inputs: reviewed modules/debug-info.md, developer-tools-api.json contextual refinements, developer-tools-questions.md and independently authored snapshot only.

1. Resolved by the final reviewed contract: Procedure and Inline_Site embed Codeview_Symbol at offset zero; subsequent offsets follow the target Jai aggregate ABI. Procedure preserves LPROC32/GPROC32/LPROC32_ID/GPROC32_ID; Inline_Site fixes INLINESITE. All four formerly blocked public functions are implemented and tested. Auxiliary payloads without a reviewed common-base projection are wire-validated without inventing typed casts. This is a documented parser representation limit, not a retained blocker for these APIs.
2. Resolved by refreshed contextual policy: Name_Table has `buffer` and `string_to_name_map`, and its map-related types are private opaque referents. The implementation now uses independent dense key/value arrays and retained serialized presence/deletion bitmaps without exporting those private type names. PDB parsing is implemented.
3. Confirm parse_compilation_unit_v4 offset/full_cu_data conventions. Independent policy: offset identifies the initial length within the complete debug_info section; full_cu_data is that entire section; type offsets and translated CU-relative references are section absolute. cu_index is nonnegative metadata only. Strings borrow storage; arrays use the active allocator.
4. Confirm DWARF filename compatibility. Independent policy preserves encoded one-based file/directory IDs; directory zero means no prefix; absolute paths stay absolute; relative paths join a directory with '/'. Joined strings are newly allocated, unjoined strings borrowed. Query ordering remains table order.
5. Confirm MSF derived policies: independent reader uses 4096-byte MSF7, growth=1 page, pnMax=u32 max, FPM bit count=32768, FPM count=ceil(page_count/32768), FPM0=1/FPM1=2/dataMin=3. User streams begin at index5. FPM arrays use active word count, rover=0, fill=all-free on initialization/growth; set_all marks all represented bits free. Freed-map records no pending frees for a read snapshot. These are independent policies, not claimed reference equivalence.
6. Implemented independent inline policies: ChangeCodeOffsetBase sets a literal procedure-relative byte base, while CodeOffset selects an offset relative to that base. Move annotations emit rows; a subsequent move bounds the previous row, and explicit lengths close the current row. Length does not advance the accumulated code offset. Empty/zero-length/unclosed streams fail. Children replace parent regions and must fit a parent-decoded range; nesting is limited to64. Column-end annotations are consumed without inventing end-column output. `copy_and_truncate_blocks` uses clipped half-open ranges, global successors across file blocks, last repeated row within a block and rejects ambiguous equal-address rows across blocks. The independent implementation deep copies rows/columns; this is stronger ownership behavior than the source's permitted views, and is not a reference-equivalence claim.

No blocking contract/dependency remains for the assigned public function scope.

| Formerly blocked public function | Current implementation |
| --- | --- |
| parse_codeview_symbols | Transactional C13 compiler/procedure/inline graph and source-table parsing, checked compressed operands and scope references. |
| decode_inline_site_line_info | Matching inlinee lookup, bounded annotation state, owned line sequences and explicit unfinished-range diagnostics. |
| overlay_inlinesite | Contained-range splitting, inline insertion and recursive child placement with bounded nesting. |
| overlay_inlinesites | Ordered sites; failures release all intermediate output and return an empty result. |

Original SDK object oracles and real Mac interpreter/native O0/O2 exercise these endpoints. The remaining format/representation limits are documented in docs/debug-info-public-parsers.md. The local coordinator routing evidence is docs/worker-inbox.md; agent_message is not exposed in this session.
