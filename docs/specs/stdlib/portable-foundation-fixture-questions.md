# Foundation configuration fixture boundary

Reviewed rule: Basic PROGRAM-wide settings are configured once from the main
program using the second import parameter list. Non-main modules may not
configure those program settings. Root's sanitized official workspace verdict
establishes non-main configuration rejection and valid child-main-only false
configuration acceptance; its named JSON receipt is not present in this
worker's shared filesystem, so no alternate source lookup was attempted.

Independent current control:
tests/portable-stdlib/foundation-config-negative/non-main.jai imports
Non_Main_Basic_Parameters from its local modules directory and calls run.
That module configures Basic ENABLE_ASSERT=false and run actually calls print.
Fresh source checks unexpectedly accept this in all six desktop CPU/OS targets.

Question for compiler owner/root: enforce/reconcile this precise called-module
boundary against the reviewed main-only rule. This is not an unused-import
classification and does not justify permitting late overwrite or broad eager
parameter discovery. If needed root can return a sanitized official verdict
for these independently authored public inputs. No stdlib/core workaround,
positive classification or skipped negative is authorized by this observation.

The separate competing-main control correctly rejects ENABLE_ASSERT true
after false. The seven corrected positive main programs configure settings
legally and already pass interpreter/native O0/O2. Their migration can integrate
independently; the additional negative remains explicitly RED and owned by the
compiler disposition, not silently counted as fixed.
