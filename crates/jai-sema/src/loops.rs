//! Resolve lexical loop names once, before LLVM block construction.
use super::*;

impl Resolver<'_> {
    fn enter_loop(&mut self, name: Option<Symbol>) -> LoopId {
        let id = LoopId(self.next_loop);
        self.next_loop += 1;
        self.loops.push(LoopBinding { id, name });
        id
    }
    pub(super) fn resolve_while(
        &mut self,
        condition: &syntax::WhileCondition,
        body: &[syntax::Statement],
    ) -> Result<Statement, Diagnostic> {
        self.scopes.push(HashMap::new());
        let (condition, name) = match condition {
            syntax::WhileCondition::Expression(e) => {
                (LoopCondition::Value(self.expr(e)?.condition(e.span)?), None)
            }
            syntax::WhileCondition::Binding { name, initializer } => {
                let value = self.expr(initializer)?.value(initializer.span)?;
                let condition = match value {
                    ValueExpr::Int(e) => LoopCondition::BoundInt(self.declare_int(*name)?, e),
                    ValueExpr::Bool(e) => LoopCondition::BoundBool(self.declare_bool(*name)?, e),
                };
                (condition, Some(*name))
            }
        };
        let id = self.enter_loop(name);
        let body = self.block(body, true)?;
        self.loops.pop();
        self.scopes.pop();
        Ok(Statement::While {
            id,
            condition,
            body,
        })
    }
    pub(super) fn resolve_range(
        &mut self,
        range: &syntax::RangeLoop,
    ) -> Result<Statement, Diagnostic> {
        // Resolve endpoints before introducing the iterator; outer names stay visible.
        let start = self.expr(&range.start)?.int(range.start.span)?;
        let end = self.expr(&range.end)?.int(range.end.span)?;
        self.scopes.push(HashMap::new());
        let iterator = self.declare_int(range.iterator)?;
        let id = self.enter_loop(Some(range.iterator));
        let body = self.block(&range.body, true)?;
        self.loops.pop();
        self.scopes.pop();
        Ok(Statement::Range(RangeLoop {
            id,
            iterator,
            start,
            end,
            direction: range.direction,
            body,
        }))
    }
    pub(super) fn resolve_jump(
        &self,
        kind: syntax::JumpKind,
        target: syntax::LoopTarget,
        span: Span,
    ) -> Result<Statement, Diagnostic> {
        let active = match target {
            syntax::LoopTarget::Innermost => self.loops.last(),
            syntax::LoopTarget::Named(name) => {
                self.loops.iter().rev().find(|l| l.name == Some(name))
            }
        }
        .ok_or_else(|| {
            Diagnostic::new(span, "break/continue must target an active enclosing loop")
        })?;
        Ok(match kind {
            syntax::JumpKind::Break => Statement::Break(active.id),
            syntax::JumpKind::Continue => Statement::Continue(active.id),
        })
    }
}
