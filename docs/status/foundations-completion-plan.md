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
- [x] Implement refined module-qualified leak matching as exact procedure name
  plus source-path substring; inclusive first matching leaf, matching/null root
  suffix, and report-owned lifetime have original regression coverage.
- [x] Implement resolved scalar FNV overload, division exercise and wide-conversion
  guards; original public-call reproducers now pass as positive API gates.
- [ ] Retest unavailable Windows/WASI transport when producers supply it.
- [x] Final supported execution/configuration pass, shortest-float interval audit,
  real unchanged jaifmt CLI/check and focused warnings-denied lint; API audit,
  deviations, handoff/index and stable owned commits are current.
- [ ] Complete target-aware/negative-source strict lint after general producer
  workflow support, and WASI unused-code checks after File's private ABI guard.
  Current failures remain visible. Coordinator owns full corpus verification.

No absent user approval or peer response gates independent supported work.
The declaration inventory is a checklist, not an organization template.
