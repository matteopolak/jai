# Focused Hash/Math/File corpus questions

## Hash nominal scalar admissibility

The public `get_hash(x: $T, ...) #modify` guard unwraps reflected `.VARIANT`
metadata repeatedly and then accepts integer, bool, enum, pointer, or float
base kinds. Thus a nominal `#type,isa u64` is admitted by the generic scalar
guard; struct-backed wrappers are not. Integer-like values then use the
documented `cast,no_check(u64)` and Knuth path, while float values use the
scalar byte-hash path. The guard itself does not distinguish `#type,isa` from
`#type,distinct`; exact conversion behavior for distinct wrappers remains
unverified, so portable callers should supply an explicit scalar-field hasher
when they need a defined mapping. This answer is source-derived from the
public guard and hashing declarations; no reference compiler or binary oracle
was executed. See the corresponding behavior paragraph in `modules/hash.md`.

## Uniform visibility provenance

ACCESS-hash-verified rluba--uniform/first.jai calls unqualified get_absolute_path
at19, anonymously imports only Basic/Compiler/String under #scope_file at47-51,
and #loads modules/stubborn/run.jai at1. That bundled directory is explicitly
excluded by ACCESS.json and was not inspected. Qualified File.get_absolute_path
and its exact two-return API pass; omission of File gives the expected unknown
identifier diagnostic with a File import suggestion.

Coordinator: provide a sanitized import/scope-only reduction of the bundled
loader showing whether File is publicly imported into first.jai's namespace,
or explicitly admit a provenance-reviewed application helper through ACCESS
before any read. Do not provide reference-library bodies. No unsupported Basic/
Compiler/String re-export or private-visibility leak is proposed.


## Loader admission consumed; remaining exact comparison

Coordinator admitted original application loader aliases through ACCESS;
run.jai SHA0e4c47d33ae65811636379ab57d4204a5dfd2bf1b9857656424380f4bcb702ae
was verified before reading. File import202 is file-private after #scope_file170.
Lines2/3 are embedded generated-preamble text, not lexical imports. The actual
configured uniform case uses compile_time args via ['-','test'] and mode run.
The name is used as an argument in first.jai's #run test branch. An original
loaded-private-import reduction reproduces unknown identifier; a public-import
control succeeds. No canonical File facade gap exists. Please compare that
precise scope/argument reduction with the official oracle and reconcile the
prior no-default-executable receipt before asking for an export/visibility fix.
Older admission request above is resolved and historical. Reviewed Hash variant
answer above is implemented; exact conversion behavior for distinct wrappers
remains the existing source-reviewed limitation, not an invented coercion rule.


## Official scope comparison resolved (current Table follow-up)

The sanitized official observations now settle the prior question: a top-level
anonymous #import File after #scope_file in a loaded file is visible to its
consumer. Named File::#import File stays private; Basic without File stays
negative. Original uniform '- test' ran146 passing compile-time tests. The
old negative anonymous-import captures are preserved as failed compatibility
premises, not accepted behavior. Independent positive/negative fixtures and
current evidence are linked in ../../foundations-table-scope.md. Compiler owner
ea7f5673 implements the general scope repair; it has not yet been adopted in
this shared source at handoff. No File export change is required.
