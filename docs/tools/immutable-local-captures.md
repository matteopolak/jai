# Immutable local verification captures

`tools/native_bindings/shared_snapshot.py` now validates output placement against
the directories actually selected as inputs. Ordinary local artifact outputs are
allowed; the source root itself and outputs inside stdlib or any selected extra
directory are rejected before capture. This prevents recursive copies without
a worker/role path whitelist. Source before/copy/after hashes and read-only copies
remain mandatory, and mutation invalidates a capture. Executable bits are
preserved while all write bits are removed; captured helpers remain runnable
without consumer-specific chmod repairs.

The bindings-specific local-output exception introduced during external-drive
permission delays was a concrete path workaround. It is replaced by the general
overlap rule, with its exact predecessor preserved at04cb08e3 and the failing
ordinary-local-output regression retained. No compiler/library semantics or SDK
results change. Tests verify actual immutable bytes, original preservation, copy
mutation detection and recursive selected-ancestor rejection:

```
python3 -B -m unittest discover -s tools/native_bindings -p test_shared_snapshot.py
```

An additional regression reproduced executable helper bits being lost by the old
blanket0444 mode. All four utility tests now pass, including an actually executed
copied helper. This is tool transport verification, not native
library behavior, platform acceptance or a substitute for the final combined run.
