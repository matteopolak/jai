# Numerics implementation plan

The reviewed module inventories and behavior tables are the design authority.
Implementation stays in `stdlib/internal/numerics`, with explicit canonical public
facades. No bootstrap or Extensions changes are part of this work.

- [ ] Build a compiler from the peer's fresh Rust sources in ignored local artifacts;
  stage the peer's independent foundation there without writing its checkout.
- [ ] Add scalar/vector/matrix/quaternion and IEEE conversion contract tests before
  implementation. Cover inverse failure tuples and length epsilon boundaries.
- [ ] Implement Math and Sloppy_Math, checking canonical reflection and overlays.
- [ ] Implement Float16 with exhaustive half decoding/round-trip coverage and
  independent Python IEEE conversion vectors.
- [ ] Implement Color_Interpolation with degree HSV, gamma 2.2, endpoint sampling,
  wrapping, duplicate keys, and empty policies.
- [ ] Implement both GetRect conventions using shared private mechanisms and
  canonical records: geometry, drawing callbacks, frame/input/state lifecycles,
  themes, buttons, editable controls, popup/subwindow and editor state.
- [ ] Verify interpreter/native O0/O2, target type checks, and actual WASM where
  tool support permits. Record exact limitations and unresolved contracts.
- [ ] Review declarations against inventories, update docs/README.md and status,
  and commit each verified coherent increment locally.

No absent-user approval or subagent execution is needed or permitted. Questions
are recorded in `docs/specs/stdlib/numerics-questions.md` and do not redefine APIs.
