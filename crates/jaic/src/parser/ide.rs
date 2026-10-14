//! Editor-only recovery. Never used by the strict compiler entry points.
use super::*;

pub struct IdeParse {
    pub file: File,
    pub tokens: Vec<Token>,
    pub diagnostics: Vec<Diagnostic>,
}

pub fn parse_file_ide(file: FileId, text: &str) -> IdeParse {
    let (tokens, diagnostics) = crate::lexer::lex_ide(file, text);
    let mut parsed = parse_tokens_ide(file, text, tokens);
    parsed.diagnostics.splice(0..0, diagnostics);
    parsed
}

/// Like `parse_tokens`, but keeps independent statements after an error. All spans
/// refer to the current original source, with no inserted values or declarations.
pub fn parse_tokens_ide(file: FileId, text: &str, tokens: Vec<Token>) -> IdeParse {
    let (strict, tokens) = parse_tokens(file, text, tokens);
    if let Ok(file) = strict {
        return IdeParse {
            file,
            tokens,
            diagnostics: Vec::new(),
        };
    }
    let mut parser = Parser::new(text, tokens);
    parser.recovery = Some(Vec::new());
    let stmts = parser
        .parse_file_stmts()
        .expect("IDE statement recovery always progresses");
    IdeParse {
        file: File {
            file,
            stmts,
        },
        tokens: parser.toks,
        diagnostics: parser.recovery.unwrap(),
    }
}

impl Parser<'_> {
    /// Indentation is a recovery hint only after strict parsing failed. A declaration
    /// beginning at or before an unclosed block's header is a plausible sibling.
    pub(super) fn ide_block_boundary(&self, open: Span) -> bool {
        if self.recovery.is_none() || !self.newline_before() || self.span().start <= open.start {
            return false;
        }
        let indent = |byte: u32| {
            let prefix = &self.src[..byte as usize];
            let line = prefix.rsplit('\n').next().unwrap_or("");
            line.len() - line.trim_start_matches([' ', '\t']).len()
        };
        matches!(self.tok(), Tok::Ident(_))
            && self.at_n(1, P::ColonColon)
            && indent(self.span().start) <= indent(open.start)
    }

    pub(super) fn ide_close_block(&mut self, open: Span, context: &str) -> PResult<Span> {
        if !self.at(P::RBrace) && self.recovery.is_some() {
            let error = self.expected("`}`", context);
            self.recovery
                .as_mut()
                .unwrap()
                .push(Diagnostic::error(open, error.message));
            self.block_end = self.pos;
            return Ok(Span {
                end: self.span().start,
                ..open
            });
        }
        self.expect(P::RBrace, context)
    }

    pub(super) fn parse_stmt_recovering(&mut self, in_block: bool) -> PResult<Option<Stmt>> {
        let start = self.pos;
        let saved_list = self.in_list;
        let saved_operator = self.pending_operator.clone();
        let saved_notes = self.pending_notes.clone();
        let saved_end = self.block_end;
        match self.parse_stmt() {
            Ok(stmt) => Ok(Some(stmt)),
            Err(error) => {
                // Do not build a maximum-depth chain of recovered enclosing blocks:
                // later AST consumers recurse too. Discard the outer statement instead.
                if in_block && error.message.starts_with("code is nested too deeply") {
                    return Err(error);
                }
                let Some(errors) = self.recovery.as_mut() else {
                    return Err(error);
                };
                // The malformed statement owns the diagnostic: the strict parser often
                // notices a missing suffix only at the next, otherwise healthy line.
                errors.push(Diagnostic::error(self.toks[start].span, error.message));
                self.in_list = saved_list;
                self.pending_operator = saved_operator;
                self.pending_notes = saved_notes;
                self.block_end = saved_end;
                if self.recover_multiline_token(start) {
                    return Ok(None);
                }
                self.ide_synchronize(start, in_block);
                Ok(None)
            }
        }
    }

    pub(super) fn ide_synchronize(&mut self, start: usize, in_block: bool) {
        self.pos = start;
        let mut braces = 0usize;
        let mut brackets = 0usize;
        loop {
            if self.pos > start && self.ide_block_boundary(self.toks[start].span) {
                break;
            }
            if self.at_eof()
                || (self.pos > start && braces == 0 && brackets == 0 && self.newline_before())
            {
                break;
            }
            match self.tok() {
                Tok::Punct(P::LBrace | P::DotBrace) => braces += 1,
                Tok::Punct(P::LBracket | P::DotBracket) => brackets += 1,
                Tok::Punct(P::RBracket) => {
                    brackets = brackets.saturating_sub(1);
                    // An explicit outer list closer also ends a damaged inner
                    // struct-literal element whose closing brace was removed.
                    braces = 0;
                }
                Tok::Punct(P::RBrace) if braces > 0 => braces -= 1,
                Tok::Punct(P::RBrace) if in_block => break,
                Tok::Punct(P::Semi) if braces == 0 && brackets == 0 => {
                    self.bump();
                    break;
                }
                _ => {}
            }
            self.bump();
        }
    }

    /// A malformed ordinary string can swallow later lines up to an unrelated quote.
    /// Once its containing statement actually fails, rescan after its opening line.
    /// Valid multiline literals in successful statements keep their original tokens.
    fn recover_multiline_token(&mut self, start: usize) -> bool {
        let from = self.toks[start].span.start as usize;
        let Some(newline) = self.src[from..].find('\n').map(|n| from + n + 1) else {
            return false;
        };
        let crossed = self.toks[start..=self.pos.min(self.toks.len() - 1)]
            .iter()
            .any(|token| {
                matches!(token.tok, Tok::Str(_))
                    && (token.span.start as usize) < newline
                    && token.span.end as usize > newline
                    && self.src.as_bytes()[token.span.start as usize] == b'"'
            });
        if !crossed {
            return false;
        }
        let file = self.toks[start].span.file;
        let (mut suffix, errors) = crate::lexer::lex_ide(file, &self.src[newline..]);
        for token in &mut suffix {
            token.span.start += newline as u32;
            token.span.end += newline as u32;
        }
        self.recovery
            .as_mut()
            .unwrap()
            .extend(errors.into_iter().map(|mut e| {
                e.span.start += newline as u32;
                e.span.end += newline as u32;
                e
            }));
        self.toks.truncate(start);
        self.toks.extend(suffix);
        // The caller must resume at this token, not skip the next healthy line.
        self.pos = start;
        true
    }
}
