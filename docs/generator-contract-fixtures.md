# Required generator fixtures after official public verdicts

The root-provided sanitized Jai0.2.030 ARM64 follow-up metadata establishes:
visitor VARIADIC-only mutation generates successfully with zero errors;
a genuine variadic C prototype does likewise. The automatic-wrapper control
instead reports one error while generation still returns true and writes output.
That observation is not valid-wrapper ABI proof, and this fixture batch does not
change the production wrapper implementation.

An inert nonmatching macro-prefix entry activates the custom grouping callback.
Matching prefixes perform built-in grouping first and preempt that callback;
an empty prefix list did not invoke it. The exact signed17/ULLmax pair, with
the inert-prefix setup, selects both inputs, generates without errors and
officially compiles with two exact-value assertions and no explicit enum base.
The resulting binary was not executed by root. This does not establish that
every mixed group is lossless or suitable for a native ABI.

Only the central sanitized behavior/selection/schema JSONs were read. Original
implementation bodies, history, distribution and reference execution were not
accessed by this lane. Previous oracle packets/receipts remain unchanged.

## Narrow fixture correction

bindings-custom retains its null-type failure, original two-error diagnostic and unchanged
destination checks. Its VARIADIC-only case now independently requires successful
generation, zero additional errors and a represented variadic tail in a separate
output file. The deliberately mutated ABI is never invoked. The ordinary
generated-schema native consumer is unchanged.

bindings-macro-enums supplies an inert prefix and proves four positive callback
selections. The exact mixed17/ULLmax case now requires two callback selections,
successful generation, zero errors and replacement of its sentinel destination.
A separate bindings-macro-mixed-values schema consumer compiles the exact values
and checks the original-name aliases. It makes no underlying-width/native ABI
claim. The existing Options/WideOptions consumer remains unchanged, including
its size checks and actual native argument/result assertions.

The already-sealed nullable-CType macro correction and all native consumers are
byte-preserved. The two edited producers also stop retaining/freeing model-pool
CType pointers after generation returns: that cleanup was an invalid caller
lifetime assumption, not an assertion or native functionality requirement. No Generator, CType, enum metadata, provider, private printer or
driver implementation is changed. There are no gate skips or refreshed goldens.

## Real current-source verification

Run tools/check_generator_contract_fixtures.py only under a coordinated bounded
runtime slot. It snapshots the current clean Rust/stdlib/selected developer tools
source, verifies pre/post capture hashes and builds jaic/jailint from that capture
using the assigned generator-platform Cargo target. The immutable source is the
input to every subsequent build and program; no peer binaries or old checkout
bodies are overlaid. Capture omits unrelated Input/Extensions-Http and native
artifacts; checked-file manifests prove dependency closure inside the capture.

Official SDK preparation builds the canonical helper/provider and real independent
C fixtures for bindings, model-properties, macro-values and macro-merge. Existing
public library search setup is exercised with real image paths/symbol ownership;
no native loader override is added. TMPDIR and artifacts remain in the own T7
capture. Per-child limits and a600-second total deadline bound the entire run;
all children are reaped and the inbox slot is released in finally.

The runner attempts all five original producers in interpreter/native O0/O2,
then all five unchanged generated consumers and the new exact mixed-value
consumer in the same three modes. It preserves every failure/nonzero result and
returns nonzero if any required producer, consumer or source check fails.
Successful producers alone do not certify consumer ABI correctness.
Source-matched formatter and strict lint check the selected roots; receipts pin
the compiler, native artifacts, source hashes, exact argv and outputs.

The initial capture-j9rgvrrd receipt is retained with a mistaken one-error
expectation for the null-model call. The nested print_function and outer
print_declaration_to_builder fragment commits each diagnose its failed model;
the original two-error assertion is restored without changing the production
printer. The second capture-z0chba7b reaches every producer assertion, but custom aborts
after printing ok in all modes; macro-enum interpreter also aborts after ok.
Both clean fixtures retained pointers/array storage allocated under the
generation model_pool and attempted to free them after the pool was released.
Removing that invalid caller retention/cleanup preserves all conversion/result
assertions and requires another full matrix. No producer exit is counted as
passing merely because it printed ok. No production allocation policy changes.

The initial runtime receipt also exposes unchanged consumer failures: no Sample
alias in the custom schema, unsigned macro type mismatch, and Options width
mismatch. These assertions remain required. Pending exact public contract/owner
review, no inferred native enum metadata or consumer weakening is introduced. Actual Linux/Windows SDK/CI execution remains separately required.
Integration alone owns Git/index and README/workflow adoption. If integrating
the new mixed-value consumer into a shared runner, its required producer is
bindings-macro-enums, which creates developer-tools-macro-mixed-generated.jai.

## Final actual Mac ARM64 receipt

Final capture: capture-0vfoy45i/verification.json under the above T7 namespace.
Compiler SHA256: 4c774e849d9662d3736d8d4a26a24b6fb8371a74865c53fa952a0bdc6392a340.
All15 original producer mode outcomes PASS. Properties, macro-merge and new
exact mixed-value consumers pass all9 outcomes. The three other unchanged
consumers fail all9 outcomes; two strict-lint roots also reject their missing
alias/width assertions. The runner exits1 and reports those required failures.
There are71 command rows,60PASS/11FAIL; source_drift is empty. These are exact
Mac results, not combined CI, Linux/Windows or reference-native ABI acceptance.

A separate captured-compiler source-only reducer confirms the unsigned macro's
exact value but type s64, the float's exact value/type float32, and both generated
enum widths8. An initial float64 source expectation failed and is retained;
the confirmed reducer uses the actual float32 observation. No native program
or SDK library was executed for these follow-up source assertions.
Native-sum/native enum consumers remain unchanged and their unexecuted later
assertions are not reported as passed. Exact remaining questions are in
specs/questions/generator-generated-consumers.md.
