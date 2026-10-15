# Compile-time file identity reduction

The combined configured-SDK/Mac suite completed its interpreter and native O0/O2 runtime cases, then failed strict lint of the Rewrite driver. Resetting the generated source did not repair lint. No rewrite implementation or compiler exception was added.

The independent reduction in tools/reduce_generator_lint_path_alias.py writes one owned generated file through the resolved assigned target path and reads it through the worktree's target symlink. It imports only Basic/File and runs at compile time. Actual outcomes:

| Case | Exit | Physical file afterward |
| --- | ---: | --- |
| JAIC write resolved/read symlink | 0 | new |
| jailint write/read resolved | 0 | old (sandbox overlay) |
| jailint write resolved/read symlink | 1 | old (sandbox overlay) |

The native filesystem recognizes both paths as the same file. SandboxHost.path normalizes paths lexically, while its read-only backing RootedFs canonicalizes compiler source paths. Overlay writes and reads through these aliases therefore use different keys. This explains why the Rewrite plugin writes its compiler-reported canonical filename but its driver rereads stale bytes through target. The failure reproduces without Rewrite, workspace interception, or model code.

Compiler owner should repair canonical identity in the general backing-filesystem/overlay protocol, preserving virtual files and nonexisting paths. The reduction records sources and actual command outcomes in the assigned target/generator-lint-path-alias-evidence.json; generated source stays in this worktree's ignored .work directory. No other external cache or reference compiler is used. The combined strict-lint gate remains blocked until that shared fix is integrated and verified.
