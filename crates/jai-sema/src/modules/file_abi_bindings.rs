//! Source receipts for a closed POSIX stdio adapter; no native library is loaded.
use super::*;
use jai_types::{Architecture, BuildTarget, OperatingSystem};
use jai_vm::file_abi::{FileAbiOperation, FileAbiProcedure, StdioAuthority};
use std::{path::PathBuf, sync::Arc};

#[derive(Clone, Debug)]
struct SourceReceipt {
    file: FileInstanceId,
    path: PathBuf,
    text: Arc<str>,
}
/// Explicit embedding authority for the selected configured POSIX source. A receipt
/// retains immutable graph text and file identity; another graph cannot reuse its IDs.
#[derive(Clone, Debug)]
pub struct FileAbiBindingContext {
    target: BuildTarget,
    entry: SourceReceipt,
    stdio: SourceReceipt,
    allocator: Option<SourceReceipt>,
}
impl FileAbiBindingContext {
    pub fn from_graph(
        graph: &ModuleGraph,
        import_dirs: &[PathBuf],
        target: BuildTarget,
    ) -> Option<Self> {
        if target.layout != jai_types::LayoutPolicy::lp64() {
            return None;
        }
        let relative = match (&target.operating_system, &target.architecture) {
            (OperatingSystem::MacOS, Architecture::Arm64) => "macos/arm64/stdio.jai",
            (OperatingSystem::MacOS, Architecture::X86_64) => "macos/x64/stdio.jai",
            (OperatingSystem::Linux, Architecture::Arm64 | Architecture::X86_64) => {
                "linux/stdio.jai"
            }
            _ => return None,
        };
        for directory in import_dirs {
            let entry_path = directory.join("POSIX/module.jai").canonicalize().ok();
            let stdio_path = directory
                .join("POSIX/bindings")
                .join(relative)
                .canonicalize()
                .ok();
            let (Some(entry_path), Some(stdio_path)) = (entry_path, stdio_path) else {
                continue;
            };
            let allocator_path = directory
                .join("Default_Allocator/module.jai")
                .canonicalize()
                .ok();
            let allocator = graph
                .modules()
                .iter()
                .filter_map(|module| receipt(graph, module.entry()))
                .find(|receipt| Some(&receipt.path) == allocator_path.as_ref());
            for module in graph.modules() {
                let entry = receipt(graph, module.entry())?;
                if entry.path != entry_path {
                    continue;
                }
                for file in module.files() {
                    let stdio = receipt(graph, *file)?;
                    if stdio.path == stdio_path {
                        return Some(Self {
                            target,
                            entry,
                            stdio,
                            allocator,
                        });
                    }
                }
            }
        }
        None
    }
    /// Whether this same graph includes a selected default allocator receipt.
    pub fn includes_default_allocator(&self) -> bool {
        self.allocator.is_some()
    }
    pub fn target(&self) -> &BuildTarget {
        &self.target
    }
}
fn receipt(graph: &ModuleGraph, file: FileInstanceId) -> Option<SourceReceipt> {
    let source = graph.sources().get(graph.file(file)?.source())?;
    Some(SourceReceipt {
        file,
        path: source.path().to_owned(),
        text: source.shared_text(),
    })
}
fn matches_receipt(graph: &ModuleGraph, expected: &SourceReceipt) -> bool {
    receipt(graph, expected.file).is_some_and(|actual| {
        actual.path == expected.path && Arc::ptr_eq(&actual.text, &expected.text)
    })
}
pub(super) fn bind(
    graph: &ModuleGraph,
    types: &TypeRegistry,
    declarations: &ScopedDeclarations<'_>,
    context: Option<&FileAbiBindingContext>,
    target: Option<&BuildTarget>,
) -> Result<HashMap<ProcedureId, FileAbiProcedure>, LocatedDiagnostic> {
    let Some(context) = context else {
        return Ok(HashMap::new());
    };
    let site = graph
        .file(context.stdio.file)
        .map(|file| SourceSpan {
            source: file.source(),
            span: Span::default(),
        })
        .unwrap_or_else(|| {
            graph
                .locate(graph.module(graph.root()).unwrap().entry(), Span::default())
                .unwrap()
        });
    let error = |message: String| graph.diagnostic(site, message);
    if target != Some(&context.target)
        || !matches_receipt(graph, &context.entry)
        || !matches_receipt(graph, &context.stdio)
    {
        return Err(error(
            "stdio source receipt differs from this graph or selected target".into(),
        ));
    }
    let selected: Vec<_> = graph
        .declarations()
        .iter()
        .filter(|declaration| declaration.file() == context.stdio.file)
        .collect();
    let file = selected
        .iter()
        .find(|declaration| graph.symbols().name(declaration.name()) == "FILE")
        .and_then(|declaration| declarations.nominals.declarations.get(&declaration.id()))
        .copied()
        .ok_or_else(|| error("selected stdio source has no resolved nominal FILE".into()))?;
    let mut candidates = Vec::new();
    let mut library = None;
    for declaration in selected {
        let FileDeclarationKind::ProcedurePrototype(prototype) = &declaration.syntax().kind else {
            continue;
        };
        let operation = match graph.symbols().name(prototype.name) {
            "fopen" => FileAbiOperation::Open,
            "fread" => FileAbiOperation::Read,
            "fwrite" => FileAbiOperation::Write,
            "fseek" => FileAbiOperation::Seek,
            "ftello" | "ftello64" => FileAbiOperation::Tell,
            "feof" => FileAbiOperation::Eof,
            "fclose" => FileAbiOperation::Close,
            _ => continue,
        };
        let signature = declarations
            .signatures
            .get(&declaration.id())
            .ok_or_else(|| error("selected stdio declaration has no checked signature".into()))?;
        let origin = foreign_libraries::origin(graph, declaration.file(), prototype)?;
        let PrototypeOrigin::Foreign {
            library: Some(actual),
            ..
        } = &origin
        else {
            return Err(error(
                "selected stdio declaration has no canonical library".into(),
            ));
        };
        let jai_ir::ForeignLibraryId::File(library_id) = actual.id else {
            return Err(error(
                "stdio library must be a defining file declaration".into(),
            ));
        };
        if graph
            .declaration(library_id)
            .is_none_or(|decl| decl.file() != context.stdio.file)
        {
            return Err(error(
                "stdio library is outside the selected source receipt".into(),
            ));
        }
        if library.as_ref().is_some_and(|previous| previous != actual) {
            return Err(error(
                "selected stdio declarations use different libraries".into(),
            ));
        }
        library = Some(actual.clone());
        candidates.push((
            operation,
            ProcedurePrototype {
                id: signature.id,
                signature: signature.ty,
                origin,
            },
        ));
    }
    let library = library.ok_or_else(|| {
        error("selected stdio source has no supported foreign declarations".into())
    })?;
    let authority = StdioAuthority::from_verified_source(
        library,
        file,
        candidates
            .iter()
            .map(|(operation, prototype)| (prototype.id, *operation)),
        types,
    )
    .map_err(|failure| error(failure.to_string()))?;
    candidates
        .iter()
        .map(|(_, prototype)| {
            authority
                .bind(prototype, types)
                .map(|binding| (prototype.id, binding))
                .map_err(|failure| error(failure.to_string()))
        })
        .collect()
}

/// Bind only the actual selected Default_Allocator C fallback declarations. The
/// allocator's ordinary dispatch body still runs; these calls never use native malloc.
pub(super) fn bind_heap(
    graph: &ModuleGraph,
    types: &TypeRegistry,
    declarations: &ScopedDeclarations<'_>,
    context: Option<&FileAbiBindingContext>,
    target: Option<&BuildTarget>,
) -> Result<HashMap<ProcedureId, jai_vm::heap_abi::HeapAbiProcedure>, LocatedDiagnostic> {
    use jai_vm::heap_abi::{HeapAbiOperation, HeapAuthority};
    let Some(context) = context else {
        return Ok(HashMap::new());
    };
    let Some(allocator) = &context.allocator else {
        return Ok(HashMap::new());
    };
    let site = graph
        .locate(graph.module(graph.root()).unwrap().entry(), Span::default())
        .unwrap();
    let error = |message: String| graph.diagnostic(site, message);
    if target != Some(&context.target) || !matches_receipt(graph, allocator) {
        return Err(error(
            "default allocator receipt differs from this graph or target".into(),
        ));
    }
    let mut candidates = Vec::new();
    let mut library = None;
    for declaration in graph
        .declarations()
        .iter()
        .filter(|declaration| declaration.file() == allocator.file)
    {
        let FileDeclarationKind::ProcedurePrototype(prototype) = &declaration.syntax().kind else {
            continue;
        };
        let operation = match graph.symbols().name(prototype.name) {
            "c_malloc" => HeapAbiOperation::Malloc,
            "c_realloc" => HeapAbiOperation::Realloc,
            "c_free" => HeapAbiOperation::Free,
            _ => continue,
        };
        let signature = declarations
            .signatures
            .get(&declaration.id())
            .ok_or_else(|| {
                error("allocator foreign declaration has no checked signature".into())
            })?;
        let origin = foreign_libraries::origin(graph, declaration.file(), prototype)?;
        let PrototypeOrigin::Foreign {
            library: Some(actual),
            ..
        } = &origin
        else {
            return Err(error(
                "allocator declaration has no canonical library".into(),
            ));
        };
        let jai_ir::ForeignLibraryId::File(id) = actual.id else {
            return Err(error(
                "allocator library must be a defining file declaration".into(),
            ));
        };
        if graph
            .declaration(id)
            .is_none_or(|declaration| declaration.file() != allocator.file)
            || library.as_ref().is_some_and(|previous| previous != actual)
        {
            return Err(error(
                "allocator library differs from its selected source receipt".into(),
            ));
        }
        library = Some(actual.clone());
        candidates.push((
            operation,
            ProcedurePrototype {
                id: signature.id,
                signature: signature.ty,
                origin,
            },
        ));
    }
    let Some(library) = library else {
        return Ok(HashMap::new());
    };
    let authority = HeapAuthority::from_verified_source(
        library,
        candidates
            .iter()
            .map(|(operation, prototype)| (prototype.id, *operation)),
    )
    .map_err(|failure| error(failure.to_string()))?;
    candidates
        .iter()
        .map(|(_, prototype)| {
            authority
                .bind(prototype, types)
                .map(|binding| (prototype.id, binding))
                .map_err(|failure| error(failure.to_string()))
        })
        .collect()
}
