//! Full procedure expressions retain their actual source header and body.
use super::*;

impl Parser<'_> {
    pub(super) fn starts_anonymous_procedure(&self) -> bool {
        let mut start = self.at;
        if matches!(
            self.token().kind,
            Kind::Keyword(Keyword::Inline | Keyword::NoInline)
        ) {
            start += 1;
        }
        if self
            .tokens
            .get(start)
            .is_none_or(|token| token.kind != Kind::Punctuation(Punct::OpenParen))
        {
            return false;
        }
        let mut depth = 0;
        for (offset, token) in self.tokens[start..].iter().enumerate() {
            match token.kind {
                Kind::Punctuation(Punct::OpenParen) => depth += 1,
                Kind::Punctuation(Punct::CloseParen) => {
                    depth -= 1;
                    if depth == 0 {
                        return self.tokens.get(start + offset + 1).is_some_and(|next| {
                            matches!(
                                next.kind,
                                Kind::Punctuation(Punct::Arrow | Punct::OpenBrace)
                            ) || safety_checks::is_check_directive(next.kind)
                                || matches!(
                                    next.kind,
                                    Kind::Directive(
                                        Directive::CCall
                                            | Directive::CppMethod
                                            | Directive::NoContext
                                            | Directive::NoDebug
                                            | Directive::CompileTime
                                            | Directive::Expand
                                            | Directive::Deprecated
                                            | Directive::Modify
                                    )
                                )
                        });
                    }
                }
                Kind::Eof => return false,
                _ => {}
            }
        }
        false
    }

    pub(super) fn anonymous_procedure(&mut self) -> Result<Expression, Diagnostic> {
        let start = self.token().span.start;
        let (mut header, _, _) = self.source_procedure_header(false)?;
        if header.convention == jai_types::CallingConvention::C {
            self.validate_c_variadic(&header.parameters)?;
        }
        header.modify = self.modify_directive()?;
        let body = self.block()?;
        header.notes = self.notes()?;
        let span = Span::new(start, self.tokens[self.at - 1].span.end);
        Ok(Expression {
            span,
            kind: ExpressionKind::AnonymousProcedure(Box::new(SourceProcedureSyntax {
                header,
                body,
                span,
            })),
        })
    }
}
