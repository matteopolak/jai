# Reviewed Math matrix operators

The Math facade already publicly imports the internal operator overload set.
The missing declarations were in internal/numerics/math_matrix.jai. The
coordinator's filtered official0.2.030 observations confirm that
Matrix2_Identity * Vector2.{3,5} compiles and returns x3/y5; the refreshed Math
spec supplies the complete fourteen-form matrix operator family.

## Implementation and public behavior

The eleven typed multiplication overloads delegate to the existing canonical
multiply functions. They preserve row-by-column order and value results:
Matrix2/Vector2, Matrix3/Vector3, Matrix4/Vector4, Matrix4x3/Vector4, plus
Matrix2/Matrix2, Matrix3/Matrix3, Matrix4/Matrix3, Matrix4/Matrix4,
Matrix4x3/Matrix4x3, Matrix4/Matrix4x3 and Matrix4x3/Matrix4.
Matrix4x3/Vector4 returns Vector3. Both mixed Matrix4/Matrix4x3 products
return Matrix4, and their operand order remains distinct.
Matrix4/Matrix4 retains the reviewed #no_alias attribute.

The remaining three generic declarations use the canonical AnyMatrix interface:
scalar multiplication with #symmetric, addition of the same matrix type, and
subtraction of the same matrix type. Each copies its left matrix and processes
every stored coefficient through its existing floats view. Scalar scaling
therefore includes affine translation coefficients as well as the linear part;
it differs from the separately named geometric scale helper.

Parameter names, result types, interface guards and attributes match the
reviewed declarations. The Math facade, canonical types/overlays/storage,
named multiply implementations and other arithmetic algorithms are unchanged.
Operators live before the internal file-private helper boundary, so the existing
public facade exports them without extra aliases or new compiler behavior.
There is no new configuration, native dependency or allocation.

## Verification

Run from the shared tree:

~~~sh
python3 -B tests/portable-stdlib/math-matrix-operators/verify.py
~~~

The runner rebuilds the current shared compiler/linter into the assigned
foundations T7 target and guards their Rust source hashes across the build and
tests. It builds the unchanged real repository jaifmt, formats/checks only owned
Jai files, and runs warnings-denied lint on Math and the three positive owned
fixtures. Deliberately invalid fixtures are verified by required compile errors,
not represented as lint-clean programs.

The original Matrix2 fixture failed before the production edit with no matching
operator*. The existing vector/scalar/named-multiply control passed. A second
before receipt records the broader matrix family failing on Matrix2*Matrix2.
Both failed receipts remain intact under foundations/matrix-operator-1y11gpqp.

The passing receipt is foundations/matrix-operator-proof-39s4u7vr/results.json:
31 focused commands and a separately recorded source build. Five fixtures each
run in interpreter and actual Mac ARM64 native O0/O2, for15 runtime executions.
Two fixtures are unchanged independently authored safe peer oracle/control
sources. The owned family fixture exercises all fourteen reviewed declarations,
checks noncommutative products against an independent row/column calculation,
covers implicit affine rows and mixed-size result types, checks scalar symmetry
and every coefficient of addition/subtraction/scaling for all four matrix types.
The Matrix2 fixture additionally covers zero vectors, rotation, composition,
canonical result type and unchanged operands. Existing vector Hadamard/scalar
overloads and named matrix multiplication remain covered.

Reverse Vector2*Matrix2 and mixed Matrix2+Matrix3 remain rejected with required
overload diagnostics. No negative assertion is skipped. Compiler and watched
Math hashes match before/after the successful suite. Native optional crash
backtrace support is disabled for these executables; assertions remain enabled,
and no native ABI assets are altered.

## Integration boundary

The only production path for this batch is
stdlib/internal/numerics/math_matrix.jai. Exact owned hashes, baseline hashes,
commands/tools and source guards are recorded in
[the handoff manifest](status/foundations-math-matrix-operators.json).
The sole integrator owns Git/index actions. Prior Hash/Math facade and Table
handoffs remain unchanged; only this matrix implementation hash advances.

All reviewed matrix-family contracts are now represented and tested. This
receipt does not claim all unrelated Math APIs, other native platforms, an
actual full shader application replay or the coordinator's full400 gate.
The shader worker owns replay of the unchanged admitted application fragment
with this production source; ready AppKit/callable integration remains separate.
No reference implementation, original application mutation, compiler patch,
test-specific exception or synthetic fallback was used.
