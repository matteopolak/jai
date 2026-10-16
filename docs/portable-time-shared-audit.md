# Owned Basic time/calendar audit

Thirty reviewed declarations belong to the portable time/calendar implementation. Twenty-seven have supported body evidence; the two Windows FILETIME APIs have source and private arithmetic evidence but still require native Windows verification. `to_float64_seconds` has a precise pending negative-subsecond precision question, not a missing body or claimed fix.

`tools/check_portable_time_shared.py` uses the actual shared library and source-built tools in the explicit worker T7 target. It does not invoke the obsolete foundation staging helper or read a peer checkout. Eight existing independent regression bodies cover signed duration conversion and rounding, float-to-Apollo values, real POSIX clock/calendar normalization and the documented -1 collision, temporary English/ISO text, caller-return macro cleanup, lazy elapsed origin, assertion-disabled Basic instances, and the private FILETIME arithmetic kernel.

Final receipt `/Volumes/T7/codex-builds/jai-cleanroom-01a137eb/stdlib/target/time-shared-d_sdky2l/results.json` has 71 passing checks: 24 actual interpreter/native Mac ARM64 O0/O2 executions, 16 builds, six source checks, six complete owned platform lint contexts plus two unit lint checks, and seventeen format gates. The native calendar environment is explicitly `TZ=UTC0`; this does not claim portable DST resolution.

The earlier `time-shared-0dmxkatf` retains the original external private-`#load` fixture failures. That old fixture remains unchanged for integrator-owned migration. A stdlib unit at `stdlib/Basic/tests/portable-filetime-kernel.jai` runs the same independent arithmetic assertions from the proper trusted library test location. No private source implementation was copied into an application, no privacy rule was widened, and no public helper was exported.

The separate [float precision question](specs/stdlib/portable-time-float-questions.md) preserves a valid -1-femtosecond value converting to zero with success true. The positive regression receipt does not conceal or count that reduction as passing. No new numeric production behavior was introduced.

Native Windows/Linux/Mac X64, SDK error injection and cross-platform ambiguous/nonexistent local dates remain unverified. The compiler's isolated host-clock reductions pass separately; ordinary target foreign calls still do not promise automatic host ABI remapping. Public Basic beyond these owned time declarations remains with foundations.
