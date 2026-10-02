# Remaining SIMD scalar-left contract

The reviewed SIMD page explicitly leaves the reversed scalar-left forms of `-` and `/` unspecified, despite their `#symmetric` attributes. Should `scalar - vector` / `scalar / vector` reverse the per-lane operation, or preserve the existing vector-left operation after argument swapping? The canonical attributes remain unchanged; the independent implementation and tests support vector-left operations without inventing an answer for these two forms.

The reviewed evidence separately identifies undefined scatter values and incomplete full-width horizontal output. The independent implementation follows the page's explicitly stated intended input-to-destination mapping and interleaved pair sums. Tests prove those real defined behaviors, without claiming exact output compatibility with uninitialized or unwritten reference values.
