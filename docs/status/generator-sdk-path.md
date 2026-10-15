# Configured SDK fixture and symlinked build storage

The original configured-SDK fixture failed at its native-facade symlink assertion when this worktree's target directory pointed to the assigned T7 build directory. The builder canonicalizes its prefix with Path.resolve, while the fixture compared the resulting link and runtime search paths against a lexical worktree/target path.

The fixture now resolves its owned SDK root once, after retaining its existing refusal to replace a symlink at that root. Library link, compiler wrapper and runtime-search-path assertions use the same canonical root as the builder. This fixes directory identity in the test, with no compiler path exception and no weakened native-library check.

`python3 tools/check_developer_sdk_configuration.py` reproduced the original failure before the change, then passed after it. Actual configured include discovery, native helper dependencies/rpaths, generated bindings, interpreter/native O0/O2 emitters and consumers, formatting and warnings-denied lint executed. The script restored the primary SDK configuration in its finally block. Raw before/after logs are retained in the assigned CARGO_TARGET_DIR as generator-sdk-before.log and generator-sdk-after.log; native evidence remains in docs/native/developer-tools-configured-sdk-evidence.json.

This is focused evidence. Combined developer-tools suite status is reported separately and is not inferred from this result.
