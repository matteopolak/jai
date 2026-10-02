# Semantic module parameter discovery

## What it is

The retained source graph delegates module parameters that require semantic type specialization or member conformance to the compiler's existing semantic preparation. Decisions return canonical source identities, so discovery and final compilation never exchange registry-local `TypeId` values.

## How it works

The pure binder handles ready scalar, enum, string, and structural type arguments. When it reaches an advanced type, interface, or value coercion, `GraphDiscovery::pending_parameter_requests()` exposes a `DeferredParameter` with its original defining file, module, span, and structured inputs. Requests survive graph retries and retain their IDs. A request ID also identifies its discovery session; a response from another session is rejected.

`resolve_discovery_parameters` prepares the same nominal registry and record specialization owner used for ordinary compilation. A generic type application runs the normal binder, including argument coercion and omitted defaults. Its response contains the actual template `DeclarationId` and bound arguments in formal declaration order. Integer width, float bits, enum declaration identity, string bytes, and nested type structure remain typed data. Named argument order inside a generic type application therefore normalizes to one type identity, while the outer module import retains its documented ordered request identity.

For example, `Box(u8, 2)` and `Box(N=2, T=u8)` produce the same type response for `Box::struct(T:Type, N:int=1)`. Importing a module with either response reuses that instance. `Box(u16, 2)` produces a different type response. Defaults declared in a module header retain that module's actual source template identity.

`resolve_parameter` checks the response kind, referenced declarations, and generic formal argument count. Responses are immutable: repeating an equal response is safe, but replacing it is an error. The graph publishes a parameter only after its pending checks succeed. Final semantic resolution rematerializes type keys with the existing mutable `RecordSpecializations` owner. The `ParameterId -> TypeId` map then supplies canonical types to annotations and value lookups; there is no mutable cache hidden in immutable nominal metadata.

Interface checks compare ready field types in that registry and follow `using` fields with cycle and ambiguity checks. Concrete generic record fields participate in the same comparison. Explicitly typed direct procedure members compare full signatures, including result types, calling convention, context, and variadic shape.

The driver polls parameter requests and source conditions on the same discovery session. Parameter preparation runs before requiring procedure annotations whose module type variables are still pending. Ordinary procedure and condition preparation retains its normal declaration/header ordering.

Type queries retain their original expression and defining file in a `ResolveType` task. Generic procedure dependency requests additionally retain the actual `SourceSpecializationKey`; equal file spans with different baked arguments receive independent responses. Preparation decodes those normalized source arguments into the same semantic registry and passes the resulting substitution to the canonical type resolver. The graph never rewrites a baked variable into guessed syntax or accepts a transient semantic type ID.

Required `$X` and optional `$$X` baking both retain dormant generic source dependencies until an actual specialization supplies their bindings. Optional baking does not force a runtime argument into a compile-time constant. A runtime formal with a restricted type, such as `x:$T/Allowed`, also makes its source dependencies specialization-dependent. Restricted type queries retain the original variable, nominal or interface constraint, and source span; an unbound introducing variable remains pending. Resolving the variable alone is insufficient proof. Existing module headers such as `$I/interface Required` still route through the interface-conformance task. `#this` outside an enclosing record field annotation is rejected with a located diagnostic.

A nominal module header such as `R:$I/BaseType` retains a `CheckNominal` task containing the supplied and required source type keys. Semantic preparation rematerializes both in the same registry and uses the procedure matcher's canonical ancestry checker. Identity or a unique declared `using` ancestry path satisfies the constraint; matching fields, ordinary record fields, and `#as` conversion fields do not. Published field IDs are checked against their owner and canonical type, and traversal preserves cycle, ambiguity, and work-budget diagnostics. The actual supplied type remains the parameter's type, including its extra members. The graph publishes `R` and `$I` only after receiving the separate immutable `NominalSatisfied` response. Interface proof responses cannot satisfy this task.

Header preparation can obtain an explicitly typed global's annotation before its storage or initializer is prepared. The canonical resolver reads that annotation in the global's defining file, disables caller lexical substitutions, and detects cycles among annotation dependencies. Inferred globals still require their ordinary semantic readiness; a type query does not execute its operand to invent a header type.

Request deduplication also compares the actual typed task. A shared outer annotation location is insufficient to identify nested applications: their original source anchors remain distinct, and interface/value checks retain their concrete nominal inputs. Separate applications within one callback signature therefore cannot reuse each other's response.

## Remaining boundaries

Aggregate-valued module arguments and aggregate generic arguments still need a canonical source constant codec. Anonymous/generated nominal types and captured code values need retained source origins. Modified records require committed modifier replay outcomes; promoted methods, inferred method signatures, and baked generic interface methods remain pending. These cases retain a source diagnostic rather than claiming incomplete conformance.

A parameter response is not an effect receipt. The scheduling layer owns compiler effect commit and replay. The graph does not execute effects or accept runtime addresses. The type encoder rejects modified generic types until their modifier outcomes can be retained without replaying effects during rematerialization.

## How to change it

Extend `jai-modules/src/parameter_requests.rs` for request tasks, session identity, and response validation. `source_arguments.rs` defines normalized generic arguments; weak literals must be contextualized before entering these keys. Update both the encoder in `jai-sema/src/modules/parameter_discovery.rs` and the decoder in `aggregates/parameterized/module_applications.rs` when adding an argument form.

`type_parameters.rs` captures pure-binder pending work, and `params.rs` captures nominal header constraints. `parameter_interfaces.rs` handles ready member conformance. `parameter_nominals.rs` adapts the real source record facts to the shared `restriction_facts.rs` ancestry checker. The `modules.rs` preparation wrapper and driver `source_discovery.rs` route requests; avoid creating another semantic registry or copying the compilation phase pipeline.

Graph tests in `jai-modules/tests/parameter-discovery.rs` cover retries, immutable responses, foreign sessions, and invalid source identities. Driver tests in `jai-driver/tests/module-parameter-discovery.rs` compile source applications and execute the rewritten VM for generic type arguments/defaults and inherited/generic interfaces. The graph API tests alone do not prove semantic conformance or executable generic bodies.

## Configuration

`SemanticDiscoveryOptions` selects graph search paths, bootstrap sources, explicit target facts, compile-time limits, workspace, and effect policy. `DiscoveryEffectPolicy::Disabled` runs without compiler effects. The session policy uses the existing committed effect replay mechanism. Neither policy permits modified-interface support to bypass the pending replay boundary.

Nominal ancestry uses the shared fixed limits in `restriction_facts.rs`: 128 ancestry levels and 4096 traversal steps, including field validation. These are compiler work limits rather than target or import settings; change them in that shared checker so procedure and module restrictions retain the same policy.

## Dependencies

The graph depends on structured `jai-syntax`, stable `jai-source` identities, and checked `jai-types` values. The semantic adapter uses the existing nominal registry, generic record binder, and specialization metadata. The driver owns source discovery and compiler effect replay. No supplied Jai binary or library is executed.
