# HTTP conformance native dependency setup

Owner: platform-io, shared tree only; integration owns staging/committing.
The original failed evidence remains normal CI run **38887877528**, exact
60d2ff19 temporary candidate. Sanitized coordinator diagnostics report both
Mac/Linux failing the corpus/llhttp step; the bounded Linux diagnostics identify
SDL3 CMake SDK requirements missing and a later missing `-lmbedtls`. No raw CI,
/Users/matthew/projects/jai-reference/quarantined sources or corpus vendor implementation bodies were read.
The independently passing SDL3 artifact run **38887877535** remains separate
positive evidence; it is not proof that HTTP CI installed that profile's SDKs.

## Root causes and correction

`stdlib_runtime.py` prepares the entire native-library catalogue when native
mode is selected and JAIC_NATIVE_LIBS is unset, even for an HTTP-only filter.
That pulls SDL3's required Linux graphics/audio/window SDK configuration into
a workflow that did not install those dependencies. The HTTP codec/server and
default Io/Tls stress consumers require the native TLS adapter, not SDL3.
Installing unrelated SDKs or disabling their profile features would obscure
this dependency-selection error.

Separately, the harness's JAIC_NATIVE_LIBS assignment happens in its subprocess.
The conformance parent's later echo-server and llhttp compiler invocations
cannot inherit a child's environment change. There was no workflow-level native
provider setting, so those commands could fail to find the monolithic mbedtls
archive/adapter even when a child had built it elsewhere.

`tools/http_native.py` prepares the actual HTTP native closure using the existing
`tools/native-libs.json` mbedtls entry without pruning its units, defines or local
configuration/adapter. It reuses the standard pinned download, build, artifact
names and license-copy routines. Both static and shared artifacts plus the
license are required before publishing the provider directory. SDK failures and
missing outputs stay fatal. This is dependency selection, not SDL3 feature
disablement: no SDL3/native profile, library implementation, Extensions source,
mode, test count, assertion, timeout or protocol expectation was changed.

Helper-built providers carry a receipt binding the pinned profile, platform,
local C/config/header inputs, builder source and artifact hashes. Configuration,
builder or artifact drift invalidates reuse and rebuilds the provider. The
default helper-owned location cannot be reused without this identity receipt.
This avoids introducing an existence-only stale provider cache. The builder's
whole-script hash is conservative: unrelated builder edits can cause a harmless
TLS rebuild rather than risk reusing code with changed compilation/link policy.

The workflow builds this SDK before compiler/conformance work and supplies
JAIC_NATIVE_LIBS at job scope. Both HTTP conformance and standalone Io stress
configure their parent environment through the same helper. Their subprocesses
therefore resolve the same archive/dynamic-provider directory. All four
conformance modes and default/O2/Linux-ASan stress variants remain selected.

An explicitly supplied complete JAIC_NATIVE_LIBS provider is preserved.
Incomplete directories are retained after a complete HTTP provider in the path
list; they are not silently accepted as interpreter support. A complete provider
is placed first to avoid taking an archive from one partial directory and the
shared adapter from another. Explicit external provider provenance remains the
caller's responsibility, as with the existing CLI environment contract; merely
finding files is not called proof of their source pin or ABI. Fresh normal CI
builds directly from the pinned source contract.

## Additional real archive transport defect

The bounded real SDK build reproduced FileNotFoundError for
`mbedtls-3.6.7/._.gitattributes` on the assigned macOS/T7 volume. The existing
archive cache moved extracted children one by one while enumerating them.
macOS AppleDouble metadata companions can disappear when their corresponding
files move, invalidating a later entry in that enumeration. A minimal original
archive containing a hidden file reproduces the same failure with `._.attributes`.

The narrow general fix in `build_native_libs.py::fetch` relocates the verified
archive root as a directory, instead of individually moving its children. Cache
layout, archive hash validation and completion marker are unchanged. No metadata
filename exception, ignored failure or internal-disk fallback was introduced.
Cache deletion now fails explicitly if an old source root cannot be removed;
otherwise moving into an undeleted root could nest the new SDK and falsely mark
old inputs current. A separate negative transport test preserves this safety check.
The original tiny transport regression and real SDK build both pass afterwards.
This changes archive transport shared scaffolding; integration must adopt that
small hunk separately from any concurrent native-builder edits. No rpmalloc
artifact/build policy was changed.

## Verification and storage

All captures, caches, SDK artifacts and temporary build paths are under:

`/Volumes/T7/codex-builds/jai-cleanroom-01a137eb/platform-io/target/http-conformance/`

Source and authoritative handoff documentation remain in the shared checkout.
No Git index, commit, remote action, workflow dispatch, comment or publication
was performed by this worker.

Actual bounded evidence:

- Twelve Python setup/transport policy regressions pass. Mock SDK build cases
  verify dispatch/environment/failure policy only and are not native execution.
  The transport regression actually extracts/moves tiny independent archive
  files on T7 and failed before the directory relocation change.
  Cache tests require both changed artifacts and changed profile inputs to rebuild.
- Ruff lint passes all five changed Python files; new helper/test formatting is
  idempotent. Actionlint passes the actual HTTP workflow.
- The pinned **mbedtls-3.6.7** archive passes the existing SHA-256 check:
  `a7e8bcbec0e6f761b4af24f25677626b35f762f68eef79c08677a363212d11f6`.
  The actual production builder produces a macOS ARM64 archive and dylib with
  the configured native TLS adapter. Symbol-table inspection confirms all
  **37** foreign function names from Extensions/Tls/bindings.jai are defined
  by both artifacts. This is build/symbol evidence, not HTTP/TLS runtime proof.
  That SDK build precedes final Python cache-identity and strict cache-cleanup
  checks. The receipt retains the exact build-time builder hash; native compile/
  link policy, SDK pin and local C/config/header bytes are unchanged. Current
  Python policy is unit-verified, not called a full final HTTP runtime pass.
- Sample artifact hashes in this host receipt:
  `libmbedtls.a` SHA-256
  `648d3aed761c724eeb4a640c64249ab7f7bfbeed168ec02c3f49535521f133a3`;
  `libmbedtls.dylib` SHA-256
  `6c1ecf39f5dc14363579700d9bf0930fd8701648522fbb110c31bf174291d2c7`.
  These identify the actual host outputs, not cross-toolchain reproducibility
  expectations. sdk-build-receipt.json records pins, input hashes and output sizes.

Preserved own captures: unit-red.log (missing setup helper), archive-red.log
(actual tiny-archive failure), sdk-build.log (actual first SDK transport failure),
sdk-build-green.log, sdk-build-receipt.json and per-artifact symbol listings.
The original failed CI run is unchanged.

Commands (from the shared checkout, with CARGO_TARGET_DIR/TMPDIR and Python cache
prefix set inside the assigned T7 namespace for local worker use):

```sh
python3 -m unittest discover -s tools -p test_http_native.py
ruff check tools/http_native.py tools/test_http_native.py tools/http_conformance.py tools/io_stress.py tools/build_native_libs.py
ruff format --check tools/http_native.py tools/test_http_native.py
actionlint .github/workflows/http-conformance.yml
python3 tools/http_native.py --out "$JAIC_NATIVE_LIBS" --cache "$HTTP_SOURCE_CACHE"
```

## Remaining gates

No GUI, fault, Jai native/interpreter or full HTTP executions were launched while
integration held its native lease. No new Linux execution is claimed. Normal CI
must rerun the unchanged four-mode conformance and stress steps on both runners.
If a Mac failure remains, supply its first bounded own-test/setup diagnostic;
the initial sanitized summary identifies its failed step but does not establish
its precise exception. No HTTP codec fix or assertion waiver is justified from
that missing detail. The broad default native catalogue setup for unrelated
full suites is unchanged and still requires its own complete SDK provisioning.
