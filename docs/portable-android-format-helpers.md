# Android formatter aliases

The four reviewed aliases fh/fh2/fh4/fh8 now use the exact #bake_arguments
definitions, forwarding Basic.formatInt with base16 and minimum widths2/4/8 where
specified. They return the canonical FormatInt, preserving its other named
parameters/defaults and caller value metadata. No substitute formatter record,
copied implementation or invented convenience export is introduced.

`python3 -B tools/check_portable_android_format_helpers.py` passes interpreter/native
Mac O0/O2 and full scoped strict lint. All256 values are compared at all four
baked widths; additional checks cover canonical reflected type, full-width unsigned
input, named padding/minimum width and grouping options. Missing-export evidence
is target/android-format-helpers-red.log; final evidence is
target/android-format-helpers-final.log. This is alias/parameter forwarding
coverage, not an independent certification of every Basic formatter algorithm.
