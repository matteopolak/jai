# Standard Library API Review Status

## Review result

The specification is suitable for implementation as a source-grounded compatibility contract, with the unresolved cases below kept visible. This is not a claim that every field relationship or platform ABI layout has been mechanically proven. Implementers should treat documented declarations and target conditions as authoritative and raise discrepancies against the specification, rather than adjusting the contract to match a new implementation.

## Coverage and checks

- The completed static source-versus-spec review covered all 135 indexed module pages. It found no unmapped pages, missing or extra module-level names, truncated inventory signatures, missing aggregate sections, incomplete aggregate code blocks, or procedure-body markers.
- The latest completed report at the time of this review listed 780 aggregate comparison records for manual classification, three signature records in Android, and four unresolved platform-specific alias instances. The Android signature records are the same three NDK callbacks represented both as ordinary and foreign-library declarations; they are conditional binding variants, not three independent API omissions. There were no module-level name deltas or data-operator deltas in that report.
- Aggregate records are candidate differences, not an omission count. The comparator flattens some nested, conditional, `using`, and overlay forms and compares rendered declarations whose spelling can differ while expressing the same ABI. Existing confirmed public shape work includes anonymous unions, COM inheritance prefixes, Compiler nested records, and the Math vector/matrix overlays. The remaining candidates need target-aware review before being described as all exact.
- The audit tool’s unit suite passed 31 tests in the current working tree. A later full-report rerun was stopped after it exposed a serialization issue for `Path` objects nested in unresolved alias chains; report writing now serializes those paths as strings. The interrupted rerun is not counted as a completed verification.

## Manual classifications and known gaps

- BuildCpp’s `Build_Type` and Debug’s `Minidump_State` members are explicitly enumerated in their pages. These were prior omissions and are now present.
- Math’s public vector, quaternion, plane, matrix, and interface shapes are specified, including overlays and fixed array extents. The textual comparator still reports some shape candidates because its normalization does not fully model overlays and alias-based interface requirements.
- Jai_Lexer and executable-format token types include the public token members and aliases in their dedicated sections. A source scanner’s missing-member output for these modules must be checked against the target-specific enum page before treating it as an omission.
- Many candidate differences arise in native API bindings (Direct3D, DXGI, Android, POSIX, Windows, macOS, SDL, Vulkan, FreeType, and NVTT). Conditional headers, anonymous unions, inherited ABI prefixes, generated records, and upstream-declared types make flattened text comparisons insufficient to establish layout. The pages document the known target and ABI relationships; opaque external handles remain explicitly opaque.
- `POSIX.CLOCKS_MONO`, `System.get_error_value`, and `Window_Type.Window_Type` are public aliases whose source chains vary by target. Their public semantics and target distinctions are documented, but the static resolver does not follow all platform import chains.
- Generated, parameterized, or unavailable-target declarations are not evaluated by the scanner. The module pages identify unavailable platform branches where known. Those branches remain unverified until their declaration sources or target SDKs are available.

## Remaining uncertainty

The scanner is an inventory aid, not a Jai semantic evaluator. It cannot prove that every conditional branch is active under every target, reconstruct every `#insert`/generated declaration, or validate native record offsets, packing, and calling conventions. The aggregate report’s unresolved differences are therefore retained as review work rather than converted into claims of either compatibility or incompatibility. The external Gamepad mapping database also lacks a reproducible upstream pin; its documented format and compatibility limit remain the contract.

No implementation source was used as expected-surface evidence. No reference binaries or project tests were run as part of this review.
