//! "Did you mean" help for unknown names. Working out the closest visible name costs a walk
//! over every scope in reach, so it happens when an error is rendered for the user, not each
//! time a lookup fails (failed lookups are routine while checking overloads and `#if`s).
use super::scope::{ScopeId, UsingEntry};
use super::{Compiler, Sym};
use crate::source::{Diagnostic, Span};

impl Compiler {
    /// Remember where the last unknown identifier was looked up, for `render`.
    pub(crate) fn note_unknown_name(&mut self, span: Span, scope: ScopeId) {
        self.last_unknown_name = Some((span, scope));
    }

    /// `d` with a `help: a similar name exists` line when it reports the last unknown
    /// identifier and a visible name is close to it.
    pub(crate) fn with_name_suggestion(&self, d: &Diagnostic) -> Option<Diagnostic> {
        let (span, scope) = self.last_unknown_name?;
        if d.span != span || !d.message.starts_with("unknown identifier") {
            return None;
        }
        let wanted = self.sources.snippet(span);
        let names = self.names_visible_from(scope);
        let d = d.clone().with_label("not found in this scope");
        Some(
            match crate::suggest::closest(wanted, names.iter().copied()) {
                Some(found) => d.with_fix(format!("a similar name exists: `{found}`"), span, found),
                None => d,
            },
        )
    }

    /// The names a lookup from `scope` can reach without loading anything new: each enclosing
    /// scope's own names, the modules it imports or `using`s, and Preload / Runtime_Support.
    fn names_visible_from(&self, scope: ScopeId) -> Vec<&'static str> {
        let mut names = Vec::new();
        let mut module_scopes = Vec::new();
        let mut current = Some(scope);
        while let Some(sid) = current {
            let s = self.scope(sid);
            names.extend(s.names.keys().map(|n| n.as_str()));
            for entry in &s.usings {
                if let UsingEntry::Module(m, _) = entry {
                    module_scopes.push(self.modules[m.0 as usize].scope);
                }
            }
            for import in &s.imports {
                if let Some(m) = import.module {
                    module_scopes.push(self.modules[m.0 as usize].scope);
                }
            }
            current = s.parent;
        }
        for m in [self.preload, self.runtime_support].into_iter().flatten() {
            module_scopes.push(self.modules[m.0 as usize].scope);
        }
        for sid in module_scopes {
            names.extend(self.scope(sid).names.keys().map(|n| n.as_str()));
        }
        names.retain(|n| !n.starts_with("__"));
        names.sort_unstable();
        names.dedup();
        names
    }

    /// A failed `#assert`: its message, or the condition when it has none.
    pub(super) fn static_assert_failed(
        &self,
        cond: &crate::ast::Expr,
        span: Span,
        message: String,
    ) -> Diagnostic {
        let text = self.sources.snippet_or_empty(cond.span).trim();
        let shown = (!text.is_empty() && !text.contains('\n') && text.len() <= 80).then_some(text);
        let mut d = match (message.is_empty(), shown) {
            (false, _) => Diagnostic::error(span, format!("#assert failed: {message}")),
            (true, Some("false")) => {
                Diagnostic::error(span, "#assert failed: this `#assert(false)` was compiled")
            }
            (true, Some(text)) => {
                Diagnostic::error(span, format!("#assert failed: `{text}` is false"))
            }
            (true, None) => Diagnostic::error(span, "#assert failed: its condition is false"),
        };
        if !message.is_empty()
            && let Some(text) = shown
        {
            d = d.with_label(format!("`{text}` is false"));
        }
        if shown == Some("false") {
            d = d.with_note(
                Span::NONE,
                "`#assert(false)` marks code that does not support this configuration (OS, CPU or build options); the code around it says which",
            );
        }
        d
    }

    /// `type `T` has no member `x``, with the closest member name or the members there are.
    pub(super) fn no_member(&self, ty: crate::types::TypeId, name: Sym, span: Span) -> Diagnostic {
        use crate::types::TypeKind;
        let shown = self.types.name(ty);
        let (what, members): (&str, Vec<String>) = match self.types.kind(ty) {
            TypeKind::Struct(id) => (
                "type",
                self.types
                    .struct_info(*id)
                    .fields
                    .iter()
                    .filter_map(|f| f.name.map(|n| n.to_string()))
                    .collect(),
            ),
            TypeKind::Enum(id) => (
                "enum",
                self.types
                    .enum_info(*id)
                    .members
                    .iter()
                    .map(|(n, _)| n.to_string())
                    .collect(),
            ),
            TypeKind::Pointer(inner) => {
                if matches!(self.types.kind(*inner), TypeKind::Pointer(_)) {
                    return Diagnostic::error(
                        span,
                        format!("type `{shown}` has no member `{name}`"),
                    )
                    .with_help(
                        "this is a pointer to a pointer: dereference it once with `.*` first",
                    );
                }
                ("type", Vec::new())
            }
            _ => ("type", Vec::new()),
        };
        let mut d = Diagnostic::error(span, format!("{what} `{shown}` has no member `{name}`"));
        if let Some(near) =
            crate::suggest::closest(name.as_str(), members.iter().map(String::as_str))
        {
            let near = near.to_string();
            d = d.with_fix(
                format!("a member with a similar name exists: `{near}`"),
                span,
                near,
            );
        } else if !members.is_empty() && members.len() <= 12 {
            let list: Vec<String> = members.iter().map(|m| format!("`{m}`")).collect();
            d = d.with_note(Span::NONE, format!("its members are {}", list.join(", ")));
        } else if members.is_empty()
            && matches!(
                self.types.kind(ty),
                TypeKind::Int { .. } | TypeKind::Float { .. } | TypeKind::Bool
            )
        {
            d = d.with_note(
                Span::NONE,
                format!("`{shown}` is a plain value without members"),
            );
        }
        d
    }
}
