# Nominal record unary operator eligibility

Confirmed independent failure: visible operator ! on Base works but Derived :: #type,isa Base and nested nominal records fail before candidate lookup. Public ! also required normalization at the using boundary. Preserved RED logs live under own T7 numerics/apollo-comparisons (and the earlier focus-version-diagnostic compiler-only receipts); original Focus diagnostic bytes remain unchanged.

The production patch changes only public_filter_name's recognized public ! symbol and the initial try_unary_operator_overload record guard: inspect types.kind(types.repr_struct(operand.ty())). This admits the canonical representation of nominal record wrappers while preserving operand identity for the existing visibility/candidate/conversion machinery. Enums and unrelated records do not gain conversions. No check_call, parser, LSP, pending-runtime, alias-refresh, or stdlib type-name exception is changed.

Independent tests cover Base/Derived/Nested equality/order/arithmetic and zero-test inheritance; custom equality proves != synthesis; private, unimported, unrelated, only/exclude and internal-name negatives are preserved. Plain #type without isa behavior is deliberately not classified by a guessed negative; root has a separate source-only probe.

The source-built approved309 child copied 748 guarded inputs. Only sema/using.rs and sema/calls.rs differ from that receipt. The exact patch, new regression test, tool hashes and native receipts are in /Volumes/T7/codex-builds/jai-cleanroom-01a137eb/numerics/apollo-comparisons. Shared S128 production changes and manifest are separate and must be adopted together by integration. Shared Git/index is not touched by this worker.
