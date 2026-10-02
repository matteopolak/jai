//! Keep original declaration insertion requests and checked source receipts.
use super::*;

pub(super) struct Jobs<'requests> {
    requests: &'requests [jai_modules::DeclarationInsertionRequest],
    pub(super) decisions: Vec<DiscoveryInsertionDecision>,
    pub(super) pending: Vec<DiscoveryInsertionPending>,
}

impl<'requests> Jobs<'requests> {
    pub(super) fn new(requests: &'requests [jai_modules::DeclarationInsertionRequest]) -> Self {
        Self {
            requests,
            decisions: vec![],
            pending: vec![],
        }
    }

    pub(super) fn evaluate(
        &mut self,
        context: &crate::compile_time::Context<'_>,
        owners: &HashMap<jai_modules::InsertionRequestId, ProcedureId>,
        declarations: &ScopedDeclarations<'_>,
        types: &mut TypeRegistry,
        places: &mut PlaceRegistry,
        meta: &mut crate::reflection::MetaContext,
    ) -> Result<usize, LocatedDiagnostic> {
        self.pending.clear();
        let before = self.decisions.len();
        for request in self.requests {
            if request.publication.is_some()
                || self
                    .decisions
                    .iter()
                    .any(|decision| decision.request == request.id)
            {
                continue;
            }
            let owner = owners
                .get(&request.id)
                .copied()
                .ok_or_else(|| LocatedDiagnostic {
                    location: request.location,
                    message: "declaration insertion has no retained source execution owner".into(),
                })?;
            let child = context.for_source(owner, request.file, request.location.source);
            let result =
                insertion_queries::evaluate(request, &child, declarations, types, places, meta);
            context.merge_pending_from(&child);
            match result {
                Ok(code) => self.decisions.push(DiscoveryInsertionDecision {
                    request: request.id,
                    code,
                }),
                Err(diagnostic) => self.pending.push(DiscoveryInsertionPending {
                    request: request.id,
                    diagnostic,
                }),
            }
        }
        Ok(self.decisions.len() - before)
    }
}
