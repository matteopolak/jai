# Numerics implementation status

In progress. Canonical facades for Math, Sloppy_Math, Float16 and
Color_Interpolation now exist. The first test exercises strict Matrix3 inverse
thresholds, Matrix4 failure identity, normalization by length, scalar categories,
HSV degrees, and all 65,536 half encodings. Interpreter and native O0 passed on
2026-10-14 with the locally source-built fresh peer compiler. This is initial
coverage, not a claim of full six-module completion.

Fresh compiler sources and foundation are copied read-only from peers into this
workspace's ignored `artifacts/`; all builds and integration writes occur there.
`-no_dce` currently fails in the staged foundation at `Basic.Buffer`, unrelated
to the numeric API. Targeted test compilation remains usable.

Pending: broader numeric oracles, portable-target checks, Color sampling tests,
GetRect and GetRect_LeftHanded implementation and integration, declaration audit,
and final status review. Scalar elementary functions are independently designed
portable algorithms; no host frexp, ldexp, or cbrt imports are required.
