//! Declarations and directive statements (`#import`, `#load`, `#if`, ...).
use super::stmt::stmt;
use super::{PResult, Parser};
use crate::ast::{AstId, Decl, DeclKind, Foreign, ForeignName, Ident, Import, ImportSource, ScopeKind, Stmt, StmtKind, UsingFilter};
use crate::intern::Sym;
use crate::lexer::{P, Tok};
use crate::source::Span;
use std::rc::Rc;

/// Directives that may trail a declaration (`x: int #align 16;`).
struct DeclNames {
    names: Vec<Ident>,
    existing: Vec<bool>,
}

const DECL_FLAGS: &[&str] = &["no_reset", "elsewhere", "deprecated", "program_export", "type_info_none"];

/// Directive statements that take a plain list of expressions up to the `;`.
const GENERIC_DIRECTIVES: &[&str] =
    &["library", "system_library", "foreign_library", "foreign_system_library", "program_export", "poke_name"];

impl Parser<'_> {
    // -- declarations -------------------------------------------------------

    /// At offset `n`: ``[`]name {, name} :``, `::` or `:=`, an `operator` declaration, or a
    /// mixed list such as `a=, b := f()` / `a:, b = f()`.
    pub(super) fn decl_ahead(&self, n: usize) -> bool {
        let mut i = n;
        if matches!(self.tok_at(i), Tok::Punct(P::Backtick)) {
            i += 1;
        }
        if self.kw_at(i) == Some("operator") && self.operator_end(i + 1).is_some() {
            return true;
        }
        let mut declared_marker = false;
        loop {
            if !matches!(self.tok_at(i), Tok::Ident(_)) {
                return false;
            }
            i += 1;
            match (self.tok_at(i), self.tok_at(i + 1)) {
                (Tok::Punct(P::Eq), Tok::Punct(P::Comma | P::ColonEq)) => i += 1,
                (Tok::Punct(P::Colon), Tok::Punct(P::Comma)) => {
                    declared_marker = true;
                    i += 1;
                }
                _ => {}
            }
            if !matches!(self.tok_at(i), Tok::Punct(P::Comma)) {
                return match self.tok_at(i) {
                    Tok::Punct(P::Colon | P::ColonColon | P::ColonEq) => true,
                    Tok::Punct(P::Eq) => declared_marker,
                    _ => false,
                };
            }
            i += 1;
        }
    }

    /// Offset after leading `using[,filter]` / `#as` modifiers if a declaration follows them.
    pub(super) fn decl_modifiers_end(&self, n: usize) -> Option<usize> {
        let mut i = n;
        loop {
            if self.kw_at(i) == Some("using") {
                i = self.using_filter_end(i + 1);
            } else if self.directive_at(i) == Some("as") {
                i += 1;
            } else {
                break;
            }
        }
        (i > n && self.decl_ahead(i)).then_some(i)
    }

    /// Offset after an optional `,only(..)` / `,except(..)` / `,map(..)` starting at offset `n`.
    fn using_filter_end(&self, n: usize) -> usize {
        if self.at_n(n, P::Comma) && matches!(self.kw_at(n + 1), Some("only" | "except" | "map")) && self.at_n(n + 2, P::LParen) {
            if let Some(close) = self.matching_paren(n + 2) {
                return close - self.pos + 1;
            }
        }
        n
    }

    /// `using,except(x) #as name: T`: consumes the modifiers, then the declaration.
    pub(super) fn parse_modified_decl(&mut self) -> PResult<Stmt> {
        let (mut using, mut as_, mut filter) = (false, false, UsingFilter::None);
        loop {
            if self.at_kw("using") {
                self.bump();
                using = true;
                filter = self.parse_using_filter()?;
            } else if self.at_directive("as") {
                self.bump();
                as_ = true;
            } else {
                break;
            }
        }
        let mut declaration = self.parse_decl(using, as_)?;
        if !matches!(filter, UsingFilter::None) {
            match &mut declaration.kind {
                StmtKind::Decl(decl) => {
                    if let Some(decl) = Rc::get_mut(decl) {
                        decl.using_filter = Some(filter);
                    }
                }
                StmtKind::Import(import) => {
                    if let Some(import) = Rc::get_mut(import) {
                        import.using = Some(filter);
                    }
                }
                _ => {}
            }
        }
        Ok(declaration)
    }

    /// For `operator <punct>... ::` starting at the first punctuation token, the offset of `::`.
    fn operator_end(&self, from: usize) -> Option<usize> {
        let mut i = from;
        while i < from + 4 {
            match self.tok_at(i) {
                Tok::Punct(P::ColonColon) if i > from => return Some(i),
                Tok::Punct(P::Colon | P::ColonEq | P::ColonColon | P::Comma | P::Semi | P::Dot) => return None,
                Tok::Punct(_) => i += 1,
                _ => return None,
            }
        }
        None
    }

    /// Declaration without its terminator. The cursor is at the first name (or backtick).
    pub(super) fn parse_decl(&mut self, using: bool, as_: bool) -> PResult<Stmt> {
        let start = self.span();
        let backtick = self.eat(P::Backtick);
        let DeclNames { names, existing } = self.parse_decl_names()?;
        let mut decl = Decl {
            id: AstId::fresh(),
            names,
            kind: DeclKind::Var,
            ty: None,
            value: None,
            extra_values: Vec::new(),
            existing,
            foreign: None,
            union_tag: None,
            using_filter: None,
            using,
            as_,
            backtick,
            align: None,
            flags: Vec::new(),
            notes: Vec::new(),
            span: start,
        };
        match self.tok() {
            Tok::Punct(P::ColonColon) => {
                self.bump();
                decl.kind = DeclKind::Const;
                if self.at_directive("import") {
                    return self.parse_named_import(decl.names.first().copied(), start);
                }
                self.parse_decl_values(&mut decl)?;
            }
            Tok::Punct(P::ColonEq) => {
                self.bump();
                self.parse_decl_values(&mut decl)?;
            }
            Tok::Punct(P::Eq) if !decl.existing.is_empty() => {
                self.bump();
                self.parse_decl_values(&mut decl)?;
            }
            _ => self.parse_typed_decl_rest(&mut decl)?,
        }
        self.parse_decl_suffix(&mut decl)?;
        decl.span = start.to(self.prev_span());
        let span = decl.span;
        Ok(stmt(StmtKind::Decl(Rc::new(decl)), span))
    }

    /// Declared names, with the assigned-to-existing mask for mixed lists.
    fn parse_decl_names(&mut self) -> PResult<DeclNames> {
        if self.at_kw("operator") && self.operator_end(1).is_some() {
            let start = self.bump();
            let mut text = String::new();
            while !self.at(P::ColonColon) {
                if let Tok::Punct(p) = self.tok() {
                    text.push_str(p.text());
                }
                self.bump();
            }
            let name = Ident { name: Sym::intern(&format!("operator{text}")), span: start.to(self.prev_span()) };
            self.pending_operator = Some(text.into());
            return Ok(DeclNames { names: vec![name], existing: Vec::new() });
        }
        let (mut names, mut existing) = (Vec::new(), Vec::new());
        let (mut any_assigned, mut any_declared_marker) = (false, false);
        loop {
            names.push(self.ident("as declaration name")?);
            let assigned = matches!(self.tok(), Tok::Punct(P::Eq)) && matches!(self.tok_at(1), Tok::Punct(P::Comma | P::ColonEq));
            let declared = matches!(self.tok(), Tok::Punct(P::Colon)) && matches!(self.tok_at(1), Tok::Punct(P::Comma));
            if assigned || declared {
                self.bump();
            }
            any_assigned |= assigned;
            any_declared_marker |= declared;
            // In `a:, b = f()` the unmarked names are the existing variables.
            existing.push((assigned, declared));
            if !self.eat(P::Comma) {
                break;
            }
        }
        let existing = if any_declared_marker {
            existing.into_iter().map(|(_, declared)| !declared).collect()
        } else if any_assigned {
            existing.into_iter().map(|(assigned, _)| assigned).collect()
        } else {
            Vec::new()
        };
        Ok(DeclNames { names, existing })
    }

    /// After the names: `: T`, `: T = v`, `: T : v`, `: = v`.
    fn parse_typed_decl_rest(&mut self, decl: &mut Decl) -> PResult<()> {
        self.expect(P::Colon, "after the declaration name")?;
        if !matches!(self.tok(), Tok::Punct(P::Eq | P::Colon)) {
            decl.ty = Some(self.parse_expr()?);
        }
        self.parse_decl_suffix(decl)?;
        if self.eat(P::Eq) {
            self.parse_decl_values(decl)?;
        } else if self.eat(P::Colon) {
            decl.kind = DeclKind::Const;
            self.parse_decl_values(decl)?;
        }
        Ok(())
    }

    /// One value, or several for `a, b := 1, 2;`.
    fn parse_decl_values(&mut self, decl: &mut Decl) -> PResult<()> {
        decl.value = Some(self.parse_expr()?);
        while decl.names.len() > 1 && self.eat(P::Comma) {
            decl.extra_values.push(self.parse_expr()?);
        }
        Ok(())
    }

    /// Trailing `#align N`, flags such as `#no_reset`, and `@notes`.
    fn parse_decl_suffix(&mut self, decl: &mut Decl) -> PResult<()> {
        loop {
            match self.tok() {
                Tok::Note(_) => decl.notes.extend(self.parse_notes()),
                Tok::Directive(name) if name.as_str() == "align" => {
                    self.bump();
                    decl.align = Some(self.parse_unary()?);
                }
                Tok::Directive(name) if name.as_str() == "elsewhere" => {
                    decl.flags.push(Ident { name: *name, span: self.span() });
                    self.bump();
                    decl.foreign = self.parse_elsewhere_library()?;
                }
                Tok::Directive(name) if DECL_FLAGS.contains(&name.as_str()) => {
                    decl.flags.push(Ident { name: *name, span: self.span() });
                    self.bump();
                }
                _ => return Ok(()),
            }
        }
    }

    /// Optional `lib ["symbol"]` after `#elsewhere`.
    pub(super) fn parse_elsewhere_library(&mut self) -> PResult<Option<Foreign>> {
        if !matches!(self.tok(), Tok::Ident(_)) || self.newline_before() {
            return Ok(None);
        }
        let library = Some(self.ident("after '#elsewhere'")?);
        let name = self.parse_foreign_symbol();
        Ok(Some(Foreign { library, name }))
    }

    /// Optional string literal naming the foreign symbol.
    pub(super) fn parse_foreign_symbol(&mut self) -> ForeignName {
        match self.tok() {
            Tok::Str(s) => {
                let name = String::from_utf8_lossy(s).into_owned();
                self.bump();
                ForeignName::Named(name.into())
            }
            _ => ForeignName::Default,
        }
    }

    // -- directive statements -------------------------------------------------

    pub(super) fn parse_directive_stmt(&mut self, name: &str) -> PResult<Stmt> {
        let start = self.span();
        match name {
            "if" => self.parse_static_if(),
            "import" => {
                let import = self.parse_import(None, start)?;
                self.end_stmt("after '#import'")?;
                Ok(import)
            }
            "load" => self.parse_load(),
            "scope_file" => self.parse_scope(ScopeKind::File),
            "scope_export" => self.parse_scope(ScopeKind::Export),
            "scope_module" => self.parse_scope(ScopeKind::Module),
            "run" => self.parse_run_stmt(),
            "insert" => self.parse_insert_stmt(),
            "assert" => self.parse_assert(),
            "add_context" => self.parse_add_context(),
            "module_parameters" => self.parse_module_parameters(),
            "placeholder" => self.parse_placeholder(),
            "place" => self.parse_place(),
            "overlay" => self.parse_overlay(),
            "through" => {
                self.bump();
                self.end_stmt("after '#through'")?;
                Ok(stmt(StmtKind::Through, start))
            }
            "as" => self.parse_terminated_simple(),
            "no_abc" | "no_aoc" if self.at_n(1, P::LBrace) => {
                // `#no_aoc { ... }`: a block with checks disabled; the flag itself is not kept.
                self.bump();
                self.parse_stmt()
            }
            "no_reset" | "program_export" if self.decl_ahead(1) => self.parse_flagged_decl(),
            name if GENERIC_DIRECTIVES.contains(&name) => self.parse_generic_directive(),
            _ => self.parse_terminated_simple(),
        }
    }

    fn parse_static_if(&mut self) -> PResult<Stmt> {
        let start = self.bump();
        let value = self.parse_expr()?;
        if self.at(P::EqEq) {
            self.bump();
            let cases = self.parse_cases()?;
            return Ok(stmt(StmtKind::StaticSwitch { value, cases }, start.to(self.prev_span())));
        }
        self.eat_kw("then");
        let then_branch = self.parse_static_branch()?;
        let else_branch = if self.eat_kw("else") { self.parse_static_branch()? } else { Vec::new() };
        Ok(stmt(StmtKind::StaticIf { cond: value, then_branch, else_branch }, start.to(self.prev_span())))
    }

    /// A `{ ... }` list (no new scope) or a single statement.
    fn parse_static_branch(&mut self) -> PResult<Vec<Stmt>> {
        if !self.at(P::LBrace) {
            return Ok(vec![self.parse_stmt()?]);
        }
        self.bump();
        let stmts = self.parse_stmts_until_close()?;
        self.expect(P::RBrace, "to end the '#if' body")?;
        Ok(stmts)
    }

    /// `#import "Module"`, `#import,file "x.jai"`, with optional `(PARAM = value)`.
    /// The terminating `;` is left to the caller.
    fn parse_import(&mut self, name: Option<Ident>, start: Span) -> PResult<Stmt> {
        self.bump();
        let mut flags = Vec::new();
        let mut kind = None;
        for flag in self.parse_directive_flags()? {
            match flag.name.name.as_str() {
                "file" | "dir" | "string" => kind = Some(flag.name.name.as_str()),
                _ => flags.push(flag.name),
            }
        }
        let (text, _) = self.string_lit("after '#import'")?;
        let text: Rc<str> = String::from_utf8_lossy(&text).into();
        let source = match kind {
            Some("file") => ImportSource::File(text),
            Some("dir") => ImportSource::Dir(text),
            Some("string") => ImportSource::String(text),
            _ => ImportSource::Module(text),
        };
        let mut params = Vec::new();
        while self.eat(P::LParen) {
            params.extend(self.parse_args(P::RParen, "in import parameters")?);
        }
        let span = start.to(self.prev_span());
        Ok(stmt(StmtKind::Import(Rc::new(Import { source, params, name, flags, using: None, span })), span))
    }

    /// `Name :: #import "X"`, after the `::`.
    fn parse_named_import(&mut self, name: Option<Ident>, start: Span) -> PResult<Stmt> {
        self.parse_import(name, start)
    }

    fn parse_load(&mut self) -> PResult<Stmt> {
        let start = self.bump();
        self.parse_directive_flags()?;
        let (path, span) = self.string_lit("after '#load'")?;
        self.end_stmt("after '#load'")?;
        let path: Rc<str> = String::from_utf8_lossy(&path).into();
        Ok(stmt(StmtKind::Load { path, span }, start.to(span)))
    }

    fn parse_scope(&mut self, kind: ScopeKind) -> PResult<Stmt> {
        let span = self.bump();
        self.eat(P::Semi);
        Ok(stmt(StmtKind::Scope(kind), span))
    }

    fn parse_run_stmt(&mut self) -> PResult<Stmt> {
        let start = self.span();
        let run = self.parse_expr()?;
        self.end_stmt("after '#run'")?;
        Ok(stmt(StmtKind::Run(run), start.to(self.prev_span())))
    }

    fn parse_insert_stmt(&mut self) -> PResult<Stmt> {
        let start = self.bump();
        let (flags, scope) = Self::split_insert_flags(self.parse_directive_flags()?);
        let replacements = self.parse_insert_replacements()?;
        let value = self.parse_expr()?;
        self.end_stmt("after '#insert'")?;
        Ok(stmt(StmtKind::Insert { value, flags, scope, replacements }, start.to(self.prev_span())))
    }

    fn parse_assert(&mut self) -> PResult<Stmt> {
        let assert = self.parse_assert_core()?;
        self.end_stmt("after '#assert'")?;
        Ok(assert)
    }

    /// `#assert cond ["message"]` without the terminator.
    pub(super) fn parse_assert_core(&mut self) -> PResult<Stmt> {
        let start = self.bump();
        let cond = self.parse_expr()?;
        self.eat(P::Comma);
        let message = if matches!(self.tok(), Tok::Str(_)) { Some(self.parse_expr()?) } else { None };
        Ok(stmt(StmtKind::Assert { cond, message }, start.to(self.prev_span())))
    }

    fn parse_add_context(&mut self) -> PResult<Stmt> {
        let add_context = self.parse_add_context_core()?;
        self.end_stmt("after '#add_context'")?;
        Ok(add_context)
    }

    /// `#add_context [#as] [using] name: T [= v]` without the terminator.
    pub(super) fn parse_add_context_core(&mut self) -> PResult<Stmt> {
        let start = self.bump();
        let declaration = self.parse_simple_stmt()?;
        match declaration.kind {
            StmtKind::Decl(decl) => Ok(stmt(StmtKind::AddContext(decl), start.to(self.prev_span()))),
            _ => Err(crate::source::Diagnostic::error(start, "expected a declaration after '#add_context'")),
        }
    }

    /// `#module_parameters (A := 1) (B := 2);` or with a trailing block.
    fn parse_module_parameters(&mut self) -> PResult<Stmt> {
        let start = self.bump();
        let mut groups = Vec::new();
        while self.eat(P::LParen) {
            groups.push(self.parse_params(P::RParen)?);
        }
        let mut groups = groups.into_iter();
        let params = groups.next().unwrap_or_default();
        let runtime_params = groups.next().unwrap_or_default();
        let body = if self.at(P::LBrace) {
            Some(self.parse_block()?)
        } else {
            self.end_stmt("after '#module_parameters'")?;
            None
        };
        Ok(stmt(StmtKind::ModuleParameters { params, runtime_params, body }, start.to(self.prev_span())))
    }

    fn parse_placeholder(&mut self) -> PResult<Stmt> {
        let start = self.bump();
        let mut names = vec![self.ident("after '#placeholder'")?];
        while self.eat(P::Comma) {
            names.push(self.ident("after ','")?);
        }
        self.end_stmt("after '#placeholder'")?;
        Ok(stmt(StmtKind::Placeholder(names), start.to(self.prev_span())))
    }

    fn parse_place(&mut self) -> PResult<Stmt> {
        let start = self.bump();
        let target = self.parse_expr()?;
        self.end_stmt("after '#place'")?;
        Ok(stmt(StmtKind::Place(target), start.to(self.prev_span())))
    }

    fn parse_overlay(&mut self) -> PResult<Stmt> {
        let start = self.bump();
        self.expect(P::LParen, "after '#overlay'")?;
        let target = self.parse_expr()?;
        let end = self.expect(P::RParen, "after the '#overlay' target")?;
        Ok(stmt(StmtKind::Overlay(target), start.to(end)))
    }

    /// `#no_reset x := 0;` / `#program_export f :: ...`: a flag in front of a declaration.
    fn parse_flagged_decl(&mut self) -> PResult<Stmt> {
        let flag = Ident { name: match self.tok() { Tok::Directive(sym) => *sym, _ => Sym::intern("") }, span: self.bump() };
        let mut declaration = self.parse_terminated_simple()?;
        if let StmtKind::Decl(decl) = &mut declaration.kind
            && let Some(decl) = Rc::get_mut(decl)
        {
            decl.flags.push(flag);
        }
        Ok(declaration)
    }

    /// `#library "x";`, `#poke_name Module name;` and similar statements.
    fn parse_generic_directive(&mut self) -> PResult<Stmt> {
        let start = self.span();
        let Tok::Directive(sym) = self.tok().clone() else { return Err(self.expected("directive", "")) };
        self.bump();
        let name = Ident { name: sym, span: start };
        let flags = self.parse_directive_flags()?.into_iter().map(|flag| flag.name).collect();
        let mut args = Vec::new();
        while !matches!(self.tok(), Tok::Punct(P::Semi) | Tok::Eof) && !self.at_prev(P::RBrace) {
            if let Some(operator) = self.try_operator_name() {
                args.push(operator);
            } else {
                args.push(self.parse_postfix(true)?);
            }
            self.eat(P::Comma);
        }
        self.end_stmt("after the directive")?;
        Ok(stmt(StmtKind::Directive { name, flags, args }, start.to(self.prev_span())))
    }

    /// `operator==` style names as a single identifier expression.
    fn try_operator_name(&mut self) -> Option<crate::ast::Expr> {
        if !(self.at_kw("operator") && matches!(self.tok_at(1), Tok::Punct(p) if !matches!(p, P::Semi | P::Comma))) {
            return None;
        }
        let start = self.bump();
        let mut text = String::from("operator");
        while let Tok::Punct(p) = self.tok() {
            if matches!(p, P::Semi | P::Comma) {
                break;
            }
            text.push_str(p.text());
            self.bump();
        }
        let span = start.to(self.prev_span());
        Some(super::expr::mk(crate::ast::ExprKind::Ident(Sym::intern(&text)), span))
    }
}
