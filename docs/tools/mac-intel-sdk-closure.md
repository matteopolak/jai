# Intel Mac CI SDK development dependencies

Job 117243022036 failed before the stdlib runner: the installed LLVM prefix lacked `include/clang-c/Index.h`. Missing production-bindings and coverage files are downstream setup consequences, not additional passing or failing library cases.

The common Mac installer now requests `clangdev=23.1.2` in its normal Intel environment, alongside the existing pinned LLVM, Clang and sanitizer packages. Public conda-forge package metadata confirms the osx-64 23.1.2 package and its matching `libclang` dependency. The installer checks the actual clang-c header and libclang dylib before exporting the prefix. All normal Mac consumers use this common installer. The separate static packaging branch is unchanged.

Validation: `bash -n tools/install_ci_llvm_macos.sh` passes. Package availability/dependency metadata was queried directly from `https://api.anaconda.org/package/conda-forge/clangdev` and `https://api.anaconda.org/package/conda-forge/libclang`; this is native SDK metadata, not a Jai implementation input. This ARM host has not installed or executed the Intel conda environment. Actual Intel CI provisioning, generator execution and stdlib gates remain required; no native success is inferred from syntax or metadata checks.
