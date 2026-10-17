# SDL3 formatter integration blocker

Owned code is `stdlib/Extensions/SDL3/*.jai` and `stdlib/Extensions/SDL3/tests/*.jai`. The requested `jaifmt --check` pass is **not established**. No formatter/rule suppression, replacement formatter or original-library fallback is used.

Actual source/tool attempts in this worker (2026-10-14):

1. Built repository Rust sources with `CARGO_BUILD_JOBS=2 CARGO_TARGET_DIR=$PWD/artifacts/sdl3/tools-target cargo build --locked -j 2 -p jailint -p jaic-cli`. Build passed. That snapshot's jailint expects the former bootstrap layout, so it cannot use the new `stdlib/prelude` bootstrap. It was not accepted as lint verification.
2. Built the authorized newer own compiler's linter, with all output kept here: `CARGO_BUILD_JOBS=2 CARGO_TARGET_DIR=$PWD/artifacts/sdl3/review-tools cargo build --manifest-path ../compiler/Cargo.toml --locked -j 2 -p jailint`. Build passed, without writing the compiler worktree. Its `jailint -D warnings` checks pass on owned files and all six source-identical generated declaration/ABI sets (see `tools/sdl3_lint.py`). This does **not** establish formatter success.
3. Assembled the test stdlib under `artifacts/sdl3/test-stdlib` solely from authorized new `../stdlib/stdlib`, `../compiler/stdlib/Compiler` and `../compiler/stdlib/internal`, retaining this worker's SDL3 module. No missing public module was filled from an old distribution.
4. Ran `JAIC_STDLIB=$PWD/artifacts/sdl3/test-stdlib ../compiler/target/debug/jaic jaifmt/main.jai -O2 -exe artifacts/sdl3/tools-target/jaifmt`. It fails at `jaifmt/main.jai:348`: `module POSIX not found`. The new independent stdlib currently has no POSIX facade. The CLI needs the reviewed `STDIN_FILENO` and libc `read` declarations; File's new implementation also imports POSIX.
5. To diagnose beyond that first missing import, a tool-only, nonshipped `artifacts/sdl3/review-bootstrap/POSIX/module.jai` supplied exactly the reviewed native `STDIN_FILENO` and `read` declarations (no placeholder body) and the build was retried with `-import_dir artifacts/sdl3/review-bootstrap`. It then fails in `Extensions/Args/generate.jai:775`: `print(*out, ...)` cannot match Basic's available `(format_string: string, ...)` overload. The required builder overload is a reviewed public declaration in `docs/specs/stdlib/modules/basic.md`: `print :: (builder: *String_Builder, format_string: string, args: ..Any) -> bool`.
6. A direct probe of the repository formatter engine, without substituting a formatting algorithm, also fails: `Extensions/Jai_Format/format.jai:28` cannot resolve Basic's `tprint`. The reviewed declaration is `tprint :: (format_string: string, args: ..Any) -> string`. The compiler/stdlib worker must provide its real behavior; a heap-only alias, dummy string or ignored diagnostic would not satisfy the contract.

Minimal engine reproducer, which needs neither Args nor File:

```jai
#import "Basic";
#import "Extensions/Jai_Format";
#run {
    output, ok, error := format_source("main::(){x:=1;}");
    assert(ok);
    print("%", output);
}
main :: () {}
```

A final refresh of the authorized new dependency sources was performed and the real CLI build retried. The no-bootstrap attempt still exits 1 on missing POSIX; the diagnostic bootstrap attempt now exits 1 at `jaifmt/main.jai:53`, unknown `exit` (also a reviewed Basic declaration). The direct formatter-engine retry still fails on `tprint`. These latest results are in `artifacts/sdl3/review/format-retries.json` and `formatter-engine-retry.log`. Changes in the first reported diagnostic do not establish completion of the missing overloads.

Required integration correction: implement/re-export the reviewed Basic overload, `tprint` and `exit` with their actual contracts, and integrate the new POSIX facade needed by the repository CLI/File. The subsequently supplied docs/implementation-ownership.md assigns Basic builder/formatting/missing exports to foundations and argument/runtime work to portable, with facade overlaps integrated by the coordinator. This crosses SDL3 ownership; no peer checkout or shipped Basic/POSIX source was modified here. These are dependency/module-completeness blockers, not an SDL3-specific parser exception to add.

After that integration, build the **real** repository CLI again, then execute:

```sh
JAIC_STDLIB=... <source-built-jaic> jaifmt/main.jai -O2 -exe artifacts/sdl3/tools-target/jaifmt
artifacts/sdl3/tools-target/jaifmt stdlib/Extensions/SDL3 stdlib/Extensions/SDL3/tests
artifacts/sdl3/tools-target/jaifmt --check stdlib/Extensions/SDL3 stdlib/Extensions/SDL3/tests
python3 tools/sdl3_gen.py --source artifacts/sdl3/SDL3-3.4.18 --jaifmt artifacts/sdl3/tools-target/jaifmt --check
```

`--jaifmt` invokes the real CLI's `--stdin --config <repo>/jaifmt.toml` on every generated Jai output and requires a second formatting pass to be byte-identical. It does not skip type/lint/ABI assertions. When formatting becomes available, regenerate with the same flag before checking in normalized output. Raw generation is reproducible now; formatted generation and CLI check remain pending this integration.

2026-10-15 native CI repair retry: the same real CLI build against the authorized staged new stdlib again exits 1 at `jaifmt/main.jai:348`, `module POSIX not found`. Exact log: `artifacts/sdl3/ci-7350b86/formatter-retry.log`. Strict own-source lint was rerun after the Windows generated declaration correction and passed on owned files plus all six target sets. Formatting remains unestablished; no replacement formatter, rule suppression, old library fallback or added staging shim was used.
