# Remaining Basic implementation plan

Goal: implement every genuine owned Basic export, preserving canonical public
types, overloads, defaults, visibility and completed production behavior.

Architecture: facade aliases select independently organized private services.
Builder output shares existing rendering; reflection and scalar helpers share
type metadata; stack traces own copied nodes/text; debugger bookkeeping feeds
real leak reports and visualization. Portable time/calendar remains peer-owned.
No source implementation outside the authorized NEW producers is an input.

- [x] Builder/reflection/arrays/scalars: write original regressions, observe
  missing APIs, implement shared internals, test reflection identity and real
  allocation/output effects. Record unresolved edge contracts precisely.
- [x] Stack traces: test explicit and contextual linked frames, implement owned
  packing/strings/output/logging, verify caller metadata and lifetime.
- [x] Leak service: independently design private allocation/trace records and
  real synchronized lifecycle bookkeeping; preserve public report layouts;
  implement baseline/exemptions, reachability/grouping/report ownership and
  logging with actual allocations. Request general compiler/runtime root
  enumeration if the supplied APIs cannot implement global-root scanning.
- [x] Native macOS/Linux visualization: implement lifecycle, string management, throttling and
  actual live-state publication using reviewed transport once synchronized.
- [x] Finish Preamble cross semantics through a genuine compiler host predicate;
  the unchanged WASI behavior regression now passes.
- [ ] Finish module-qualified leak matching when exact module mapping is supplied;
  current explicit unsupported diagnostics are not full behavior.
- [ ] Retest unavailable Windows/WASI transport when producers supply it.
- [ ] After each coherent batch: real jaifmt format/check, warnings-denied lint,
  interpreter/native O0/O2 and supported WASI checks, relevant unused-code
  targets; update API audit, deviations, handoff/index and commit owned changes.
- [ ] Final owned pass: all production cases/configurations, shortest-float
  audit, real unchanged jaifmt CLI and scoped lint. Coordinator owns full corpus.

No absent user approval or peer response gates independent supported work.
The declaration inventory is a checklist, not an organization template.
