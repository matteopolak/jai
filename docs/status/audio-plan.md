# Audio implementation plan

Goal: implement reviewed Sound_Player in the dedicated audio worktree.
Architecture: one facade loads independently organized audio units, preserving
one storage location for mutable globals. Device-independent PCM mixing, cache
pages, stream ownership and native queues have separate responsibilities.

- [ ] Audit declarations, aliases, defaults, identity and target conditions.
- [ ] Test then implement sample math, bounds, interpolation and repeat.
- [ ] Test then implement panning, listener transforms and editable VBAP.
- [ ] Test then implement page lifecycle/queues with NEW Adpcm and stb_vorbis.
- [ ] Test then implement stream ownership, synchronized updates and retirement.
- [ ] Implement native SDK output and test muted device lifecycle.
- [ ] Run actual source-built formatter/linter, interpreter, native O0/O2 and
  cross-target checks; commit stable logical checkpoints and continue.
- [ ] Maintain per-export inventory, feature docs, deviations and questions.

Explicit autonomous-work instructions govern execution without subagents or
approval pauses. No peer edits, shared packaging changes or reference access.

Current checkpoints implement and test public declaration identity, PCM mixing,
gain/listener/VBAP helpers, actual compressed queues, owned lifecycle and real
host native output. These are locally integrated sources with native evidence,
not completion of the whole scope. Pending: reviewed exact spatial/orientation
and interpolation contracts, Android target/backend, focus/background lifecycle,
Linux/Windows native execution and release packaging. History and independent
entity-phase synchronization are now resolved and implemented. The per-export
inventory records missing direct behavioral references rather than treating
signature probes as conformance.
