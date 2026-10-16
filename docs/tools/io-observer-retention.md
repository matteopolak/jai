# Linux observer capture retention

Normal HTTP CI uploads exactly three selected-copy files after the original
step, including when that step fails: receipt.json, program.stdout and
program.stderr under runner.temp/io-observed-copy. The upload is Linux-only,
always-run unless cancelled, pinned to the existing artifact action, and retained
for seven days. No directory, recursive glob, environment dump, source tree or
binary is selected.

A collecting receipt remains partial evidence and is retained unchanged.
Missing capture files warn; they do not change the original workload result.
There is no continue-on-error, extra launch, kill or retry. The existing12copies,
three rounds, environment/cwd/binary and supervisor timeout remain unchanged.
The sampler180-second cap still ends only sampling.

Three configuration regressions cover failure-time upload, exact allowlist and
retained collecting state with an excluded synthetic sibling. They execute no
HTTP/native workload. Root must admit sanitized retained metadata and diagnostics
before causal classification. A sampled nonfailure never clears failures in other
copies; the original Linux connect failure remains required.
