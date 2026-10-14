# Window and rendering implementation

The reviewed module specs are the compatibility oracle. Public nominal records live in
their public modules so reflection retains canonical names; implementation helpers live
under the assigned internal directories. Native types are imported from the bindings
worker's independent modules, never redeclared as convenient substitutes.

Implementation proceeds inline without delegation:

1. Add original failing fixtures for Window_Type, Input, Simp shapes, and transfer functions.
2. Implement canonical records, explicit enum values, and portable format/bitmap helpers.
3. Implement native window/event/clipboard adapters and real rendering/device operations
   wherever the integrated compiler and native declarations support them.
4. Implement keymap dispatch and SDL mapping parsing with owned storage and error cleanup.
5. Exercise interpreter and native O0/O2, cross-target checks, scoped formatting and lint.
6. Record exact missing contracts and semantic/dependency reproducers, retain focused
   durable commits, and update the coverage ledger after every verified milestone.

Integration staging is `target/window-integration-stdlib`; it combines this checkout's
stdlib with permitted NEW bindings/numerics sources, excluding their Extensions trees.
Staging and compiler outputs are expendable; source, regressions, and docs remain here.

Native failures must remain visible. No dummy windows, synthetic font metrics, memory-only
clipboard, fabricated database, or success-returning placeholder constitutes support.

Updated contract execution (2026-10-14): use reviewed public defaults for native
window creation; implement Keymap lifecycle/actions before its text adapter;
conform committed-character delivery to platform-specific counts/filtering;
replace superseded font ownership/atlas assumptions with reviewed shared registries;
implement shader preambles and owned mip storage before public renderer/text paths.
Build the general compiler reflection patch in local target staging and retain
the original failure evidence; no GL-specific pointer table repair is permitted.
