# ImGui nested methods and native C++ verification

The reviewed `split` belongs to `TextFilter.TextRange`. The former verifier
flattened it onto `TextFilter`, creating six false public-name failures.
Generator metadata now retains declaring record paths. Literal/comment braces
and omitted procedure-body markers are normalized separately from type scopes;
aggregate field order, overload order, signatures and SDK symbols stay intact.
No `TextFilter.split` convenience alias is exported to satisfy the old check.

`imgui-nested.jai` checks three SDK record sizes and five offsets against a
real C++ oracle before calling SDK constructors. It preserves SDK object/vector
initialization, calls the nested public method, checks three returned slices,
frees data through the SDK allocator and checks the canonical nested type name.
This is an actual Jai-to-C++ native test, complementing the separate C++/libffi
program; no SDK function is mocked. Both native programs pass on the host, and
all six desktop declaration/public-name/source configurations pass.

The first native Jai link exposed missing `std::terminate`, exception-runtime
and personality symbols. A reusable private C++ runtime dependency now selects
libc++ on macOS and libstdc++ on Linux for ImGui, NVTT and meshoptimizer, matching
their default native build recipes. Windows SDK packages must provide matching
CRT dependencies through their build/import metadata; Windows runtime was not
tested here. Explicit `link_always` can load the C++ runtime for constants-only
imports. The proper long-term refinement is general native-library dependency
metadata so transitive runtime libraries are linked only with the owning SDK.

Evidence: `.work/imgui-qualified-native-current.json` and subsequent SDK-scope
reports. Initial missing-runtime and metadata failures remain in earlier reports.
This verifies the selected records/methods, not every ImGui aggregate or native
operation; the existing glyph/other provisional ABI audit remains required.
