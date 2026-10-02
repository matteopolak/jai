# Remaining formatter contract exposed by the 833 target policy review

## Extended floating values in Basic formatting

`tests/extensions/rules-jaic-extensions.jai` calls `tprint("%", sqrtl(one * 2))`
where the value has the compiler extension's native Long_Double type. Linux
ARM64/x64 interpreter and native records fail in Basic's float formatter. The
current implementation accepts runtime sizes 4 and 8 only; the reviewed Basic
contract says that FormatFloat requires a float value without specifying an
extended-float conversion rule. The fixture comment expects printing through
float64, but that comment does not establish the reference public contract.

Does the formatting contract include reflected FLOAT values of native extended
80/128-bit kinds, or must such callers explicitly convert to float64? If they are
accepted, specify whether conversion to float64 is observable policy or whether
the original precision/range and shortest representation must be retained.

The fixture remains a required positive on Linux. This question authorizes no
target exclusion, fixture assertion change, invented export or formatter bypass.
The current matrix repair changes neither Basic nor the fixture.
