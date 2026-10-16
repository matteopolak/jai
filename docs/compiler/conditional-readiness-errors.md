# Conditional readiness and error retention

The early plain-condition pass probes whether a condition can resolve from
existing declarations. A failed probe means the item must wait for ordinary
expansion; it must not consume pending work in another scope.

Previously, qualified module lookup could drain pending items during that probe.
An imported invalid condition became Done before its error reached the probe,
which interpreted the error as unready. The later ordinary pass then saw Done
and lost the language error. An independent unknown-name control was accepted
by the compiler, although the coordinator's official offline build rejected it.

Both pending expansion entry points now honor the existing no-expansion probe
mode. The plain-condition pass restores its previous mode before committing a
ready branch. Unready items retain Waiting; normal expansion owns declarations
and propagates errors. This changes no lookup visibility or module identity rule.

Focused controls cover unknown names and undeclared calls, conditional exports,
private declarations, duplicate declarations, overloads, configured-runtime
identity, separate parameterized instances, placeholders, one-time constant
effects, terminal constant failures, and constants whose procedure depends on a
pending declaration. The previously official-rejected cyclic baseline still
fails. No cyclic expansion relaxation is included.

The original purported positive used a module parameter as an exported member.
The coordinator rejected that premise. Its files and earlier receipt remain
unchanged under `readiness-error-preservation/valid`; this compiler's existing
acceptance of that input is outside this patch. A separate `valid-exported`
control adds `public_enabled :: enabled` and uses that public alias; the
coordinator reports an official offline build pass.

The protected Runtime_Support provider has never been read here. Its sanitized
observer showed a failed original condition and later absent aliases, not the
original boolean result or selected flag identity. This generic error-loss fix
does not establish that application's cause. Protected replay remains owned by
the coordinator. Diagnostic observer code is on a separate branch and is not
part of the semantic patch. Native tests are deferred during the coordinator's
active native lease; the focused checks use compiler source and `-check` only.

Historical [RED evidence](../status/runtime-readiness-red-603.json) is retained;
the [followup receipt](../status/runtime-readiness-fix-603.json) records final
commands and tool identity.
