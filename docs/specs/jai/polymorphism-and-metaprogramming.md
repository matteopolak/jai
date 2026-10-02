# Polymorphism, compile-time execution and code generation

Jai uses compile-time values, polymorphic declarations, macros, reflection, and workspaces as parts of the language. This page separates compile-time evaluation from runtime control flow and summarizes what the sample corpus demonstrates.

## Source evidence

The tutorial corpus covers typechecking, static branches, polymorphic procedures and structs, baked parameters, type restrictions and variants, compile-time execution, metaprogram workspaces and plugins, code insertion, syntax-tree inspection, custom iteration, and metadata reduction. Standalone examples exercise code-value construction, self-inspection, symbol lookup, and source reduction.

## Compile-time constants and `#run`

`::` creates a constant binding. Compile-time type values, literal values, and results of compile-time evaluation can be used in type positions and static conditions. `#run expression` evaluates a procedure or block during compilation and exposes its result as a constant. This is distinct from runtime execution: it may create declarations, calculate type information, and prepare generated code before the program runs.

```jai
capacity :: 6;
square :: (n: s64) -> s64 { return n * n; }
SQUARE_OF_CAPACITY :: #run square(capacity);
Buffer :: struct ($T: Type) { data: [capacity] T; }
```

`#if` compiles one branch based on a constant condition. The lessons use platform/build constants such as `OS`, `CPU`, and `IS_CROSS_COMPILING`. A non-constant mutable variable is not accepted merely because its initializer appears obvious. `is_constant` is used to select compile-time assertions and conditional baking. Constantness is a property relevant to typechecking/evaluation, not an optimizer guess.

Compile-time execution runs in an environment with platform dependencies. The supplied cross-compilation lessons distinguish ordinary target-workspace `#run` from explicit `#run,host`; they do not promise automatic host-ABI substitution for arbitrary foreign/system calls. See the execution boundary below.

### Cross-target compile-time execution

The supplied `950_cross-compiling` lesson establishes these different execution domains:

| Form | Compilation and lookup domain | Native-operation boundary |
| --- | --- | --- |
| Ordinary `#run` in a cross-target workspace | Target bytecode, target `OS`/`CPU`, and target types/declarations | Execution occurs during the host compiler process. Target foreign libraries, syscall constants, and assembly must actually be usable on the host; general native-call remapping is not promised. |
| `#run,host` | An isolated host workspace with host `OS`/`CPU` and explicitly declared host imports | Host module variants are compiled and called. Target identifiers/types are not implicitly visible. |
| Host metaprogram work | The metaprogram's own workspace | It can perform host work and pass generated source/results into the target workspace through public compiler APIs. |

For ordinary cross-target `#run`, the documented exceptions are that the `Context_Base` portion is initialized with host workspace values (including allocator/logger procedure pointers), and calls to `runtime_support_default_allocator_proc` are redirected to the host workspace's equivalent. This explains supported allocation without requiring arbitrary target platform functions to become host functions. A target procedure can still contain target-specific code before reaching a host context procedure, so the host logger pointer alone does not guarantee every logging call works across architectures.

Consequently, a Linux-target timing call carrying Linux clock identifiers into a macOS native call, or a Linux errno-symbol lookup unavailable on macOS, is outside the promised portable ordinary-`#run` domain. The reviewed source does not require converting all native constants/symbols to macOS equivalents. This is a compatibility limitation of ordinary cross-target execution, not proof that all cross-compilation or all compile-time native calls are unsupported.

`#run,host` is the documented form for such host operations. Its imports must be declared inside the isolated host procedure; importing a host module into the outer target workspace is not equivalent. The lesson restricts the isolated procedure to no arguments and results consisting of built-in primitive types, strings, or arrays of built-in primitives. It does not promise arbitrary target-defined aggregate transfer or capture of outer target names. In a non-cross-compiling workspace, the directive behaves like ordinary `#run`.

The documented official configuration uses the `Compiler` API rather than an assumed command-line `-os` flag: create a workspace, read its `Build_Options`, set `os_target = .LINUX` and `cpu_target = .X64`, then apply the options before adding target source. The supplied lesson uses `output_type = .OBJECT_FILE` to avoid requiring target libraries/linking. `runtime_support_definitions = .ENTRY_POINT_AND_INIT` is optional when an externally linkable entry point is desired; it is not needed to establish the host/target execution distinction. Begin interception, add source with `add_build_file`/`add_build_string`, and observe that workspace's `Message_Complete.error_code`. The host metaprogram can suppress its own output with `set_build_options_dc`.

An independent official oracle can therefore compile an ordinary host harness file which configures this child workspace through those public APIs, using separate target inputs for ordinary `#run` and isolated `#run,host`. No undocumented target CLI option is necessary. This review did not execute that oracle and does not certify the installed SDK's linker, native library, architecture, or host-directive support beyond the supplied lesson's contract.

## Polymorphic procedures and structs

`$T` declares a compile-time type variable inferred from a call. The procedure body is typechecked for the concrete type arguments; a result can depend on the inferred type. Polymorphic parameters can be named and reused across parameters/results. `$value` requires a compile-time value argument, while `$$value` is an optional bake: it can be constant when supplied as a constant, and runtime-valued otherwise. `is_constant` and `#if` let a body specialize behavior when that optional value is available at compile time. Auto-bakes allow eligible arguments to become compile-time parameters when calls supply constants; examples distinguish fixed polymorphic parameters from inferred bakes.

The example corpus also uses `#bake_arguments` to create a specialized callable by fixing selected arguments of an existing procedure. This is a compile-time callable construction pattern, distinct from ordinary default arguments: its result is another callable with a reduced set of supplied inputs.

Polymorphic structs accept compile-time type or value parameters and create specialized aggregate types. Type restrictions constrain which types may be substituted. `#type,distinct` and `#type,isa` provide type variants with different compatibility behavior. The samples show `#modify` blocks for compile-time inspection and validation/customization of types. They do not fully specify specialization caching, overload ranking, or all constraint grammar; those are compatibility questions for targeted evidence.

## Macros, `Code`, and `#insert`

An `#expand` procedure is a macro-like compile-time expansion. The arguments can include code values, and backticks can refer to names visible at the call site. A backtick identifier is caller-scope name lookup; it does not splice a `Code` parameter based on that parameter's name. Use `#insert` with the `Code` value to insert that argument. The examples demonstrate inserting a string of Jai source, inserting a `Code` value, returning generated code from `#run`, and using scope options to make inserted code resolve in caller scope.

```jai
scale_result :: (factor: s64) #expand {
    `result *= factor;
}

apply_scale :: () {
    result := 7;
    scale_result(4);
}
```

That sketch illustrates caller-visible expansion, not a fully specified macro grammar. In particular, exact binding rules for backticks, hygiene, evaluation timing, and insert-scope modifiers must follow concrete examples. Code values can also be parsed and modified via compiler APIs; `compiler_get_nodes`/related helpers expose syntax structures and convert edited structures back to `Code`. Such mutation is compile-time work and should not be mistaken for runtime reflection.

## Reflection and compiler integration

`type_info(T)` requests runtime metadata for a type. For a named declaration, `Type_Info.name` reports that declared name (the lesson checks a type declared as `Derived` and observes `"Derived"`). A type alias is the same type, not a new nominal declaration; do not expose an implementation record's internal alias name in place of the public declaration name. The lessons do not establish formatting for parameterized type instances, so callers should not depend on such strings. The 935 lesson demonstrates that only metadata needed by the program is retained, and struct directives can reduce metadata, including omitting it or representing procedure types as void pointers for metadata purposes. The value's actual compile-time type is unchanged by metadata reduction.

The Compiler module examples demonstrate custom metaprograms, build-string/file injection, workspaces, compiler messages/interception, source browsing, hooks, custom checks, module browsing, and caller-code inspection. These facilities are not all intrinsic syntax: many are APIs made available through compiler modules and a metaprogram entry point. A compiler implementation should keep language semantics distinct from tool/workspace API behavior.

Other lessons broaden the lifecycle picture: `#no_reset` can preserve compile-time-initialized global data into runtime output, but ordinary pointers are not generally relocated; the default metaprogram performs startup/build behavior and can be replaced or augmented; command-line arguments after the metaprogram separator are consumed by the metaprogram; and an accompanying design essay discusses language tradeoffs without defining additional syntax. Inline `#asm` may also appear during compile-time execution, subject to architecture and backend support.

## Implementation concerns

- Keep compile-time evaluation separate from runtime IR while sharing correct type rules.
- Type variables and baked values affect signatures and specialization; preserve their compile-time nature.
- `#if` excludes a branch semantically but requires parseable source in both arms.
- `#insert` and macro expansion need caller scope and inserted-code location to be represented deliberately.
- Runtime `Type_Info` has an explicit size/retention cost and reduction directives change metadata only.
- Cross-compilation must not assume host compile-time execution behaves like execution on the target.
- The examples leave grammar details, error recovery, expansion recursion limits, and exact metaprogram lifecycle incomplete; record those as implementation questions rather than guesses.
