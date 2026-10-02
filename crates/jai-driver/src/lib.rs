//! Filesystem compilation units with source-preserving diagnostic mapping.
use jai_lexer::{Directive, Kind, Punct};
use jai_source::{Diagnostic, Span};
use std::{
    collections::HashSet,
    fmt, fs,
    path::{Path, PathBuf},
};

#[derive(Clone, Copy, Debug, PartialEq, Eq, Hash)]
pub struct SourceId(usize);
#[derive(Clone, Copy, Debug, PartialEq, Eq, Hash)]
pub struct UnitId(usize);
#[derive(Clone, Copy, Debug, PartialEq, Eq, Hash)]
pub struct ModuleId(usize);
#[derive(Debug)]
pub struct Source {
    id: SourceId,
    path: PathBuf,
    text: String,
}
#[derive(Debug)]
struct Mapping {
    source: SourceId,
    generated: Span,
    original: usize,
}
#[derive(Debug)]
pub struct CompilationUnit {
    id: UnitId,
    module: ModuleId,
    sources: Vec<Source>,
    text: String,
    mappings: Vec<Mapping>,
}
impl SourceId {
    pub fn index(self) -> usize {
        self.0
    }
}
impl UnitId {
    pub fn index(self) -> usize {
        self.0
    }
}
impl ModuleId {
    pub fn index(self) -> usize {
        self.0
    }
}
impl Source {
    pub fn id(&self) -> SourceId {
        self.id
    }
    pub fn path(&self) -> &Path {
        &self.path
    }
    pub fn text(&self) -> &str {
        &self.text
    }
}
#[derive(Debug)]
pub enum Error {
    Io {
        path: PathBuf,
        cause: std::io::Error,
    },
    Decode {
        path: PathBuf,
        diagnostic: Diagnostic,
    },
    Located {
        source: SourceId,
        path: PathBuf,
        diagnostic: Diagnostic,
        rendered: String,
    },
    Diagnostic(Diagnostic),
    LoadCycle {
        path: PathBuf,
    },
}
impl fmt::Display for Error {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            Self::Io { path, cause } => write!(f, "{}: {cause}", path.display()),
            Self::Decode { path, diagnostic } => write!(f, "{}: {diagnostic}", path.display()),
            Self::Located { rendered, .. } => f.write_str(rendered),
            Self::Diagnostic(d) => fmt::Display::fmt(d, f),
            Self::LoadCycle { path } => write!(f, "{}: cyclic #load", path.display()),
        }
    }
}
impl std::error::Error for Error {
    fn source(&self) -> Option<&(dyn std::error::Error + 'static)> {
        match self {
            Self::Io { cause, .. } => Some(cause),
            Self::Decode { diagnostic, .. }
            | Self::Located { diagnostic, .. }
            | Self::Diagnostic(diagnostic) => Some(diagnostic),
            Self::LoadCycle { .. } => None,
        }
    }
}
impl CompilationUnit {
    pub fn id(&self) -> UnitId {
        self.id
    }
    pub fn module(&self) -> ModuleId {
        self.module
    }
    pub fn sources(&self) -> &[Source] {
        &self.sources
    }
    fn located(&self, source: SourceId, diagnostic: Diagnostic) -> Error {
        let file = &self.sources[source.0];
        let rendered = diagnostic.render(&file.path.to_string_lossy(), &file.text);
        Error::Located {
            source,
            path: file.path.clone(),
            diagnostic,
            rendered,
        }
    }

    pub fn load(path: &Path) -> Result<Self, Error> {
        let mut unit = Self {
            id: UnitId(0),
            module: ModuleId(0),
            sources: vec![],
            text: String::new(),
            mappings: vec![],
        };
        unit.visit(path, &mut HashSet::new(), &mut HashSet::new())?;
        Ok(unit)
    }
    pub fn parse(&self) -> Result<jai_syntax::Module, Error> {
        jai_syntax::parse(&self.text).map_err(|d| self.diagnostic(d))
    }
    pub fn resolve(&self) -> Result<jai_sema::Program, Error> {
        jai_sema::resolve(&self.parse()?).map_err(|d| self.diagnostic(d))
    }
    fn diagnostic(&self, mut d: Diagnostic) -> Error {
        if let Some(m) = self
            .mappings
            .iter()
            .find(|m| m.generated.start <= d.span.start && d.span.start < m.generated.end)
        {
            let s = &self.sources[m.source.0];
            let start = m.original + d.span.start - m.generated.start;
            d.span = Span::new(start, start + d.span.end.saturating_sub(d.span.start));
            self.located(s.id, d)
        } else {
            Error::Diagnostic(d)
        }
    }
    fn append(&mut self, id: SourceId, start: usize, end: usize) {
        let generated = Span::new(self.text.len(), self.text.len() + end - start);
        self.text.push_str(&self.sources[id.0].text[start..end]);
        self.mappings.push(Mapping {
            source: id,
            generated,
            original: start,
        });
    }
    fn visit(
        &mut self,
        path: &Path,
        active: &mut HashSet<PathBuf>,
        seen: &mut HashSet<PathBuf>,
    ) -> Result<(), Error> {
        let path = path.canonicalize().map_err(|cause| Error::Io {
            path: path.to_owned(),
            cause,
        })?;
        if active.contains(&path) {
            return Err(Error::LoadCycle { path });
        }
        if !seen.insert(path.clone()) {
            return Ok(());
        }
        active.insert(path.clone());
        let bytes = fs::read(&path).map_err(|cause| Error::Io {
            path: path.clone(),
            cause,
        })?;
        let text = jai_lexer::decode_source(&bytes)
            .map_err(|diagnostic| Error::Decode {
                path: path.clone(),
                diagnostic,
            })?
            .into_owned();
        let id = SourceId(self.sources.len());
        self.sources.push(Source {
            id,
            path: path.clone(),
            text,
        });
        let tokens = jai_lexer::lex(&self.sources[id.0].text).map_err(|d| self.located(id, d))?;
        let mut depth = 0usize;
        let mut cursor = 0;
        let mut i = 0;
        while i < tokens.len() {
            let t = tokens[i];
            match t.kind {
                Kind::Punctuation(Punct::OpenBrace) => depth += 1,
                Kind::Punctuation(Punct::CloseBrace) => depth = depth.saturating_sub(1),
                Kind::Directive(Directive::Import) => {
                    return Err(self.located(
                        id,
                        Diagnostic::new(t.span, "#import module scopes are not implemented"),
                    ));
                }
                Kind::Directive(Directive::Load) => {
                    let fail = |message| self.located(id, Diagnostic::new(t.span, message));
                    if depth != 0 {
                        return Err(fail("#load is supported only at top level"));
                    }
                    let Some(value) = tokens.get(i + 1).filter(|v| v.kind == Kind::String) else {
                        return Err(fail("#load requires a literal file path"));
                    };
                    let raw = value.span.text(&self.sources[id.0].text);
                    let name = raw[1..raw.len() - 1].to_owned();
                    if name.contains('\\') || name.is_empty() {
                        return Err(fail("#load paths must be nonempty unescaped strings"));
                    }
                    if tokens
                        .get(i + 2)
                        .is_none_or(|v| v.kind != Kind::Punctuation(Punct::Semicolon))
                    {
                        return Err(fail("expected ';' after #load"));
                    }
                    self.append(id, cursor, t.span.start);
                    self.text.push('\n');
                    self.visit(&path.parent().unwrap().join(name), active, seen)?;
                    self.text.push('\n');
                    cursor = tokens[i + 2].span.end;
                    i += 2;
                }
                _ => {}
            }
            i += 1;
        }
        self.append(id, cursor, self.sources[id.0].text.len());
        active.remove(&path);
        Ok(())
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::sync::atomic::{AtomicUsize, Ordering};
    static NEXT: AtomicUsize = AtomicUsize::new(0);
    struct Fixture(PathBuf);
    impl Fixture {
        fn new(files: &[(&str, &str)]) -> Self {
            let root = std::env::temp_dir().join(format!(
                "jai-driver-{}-{}",
                std::process::id(),
                NEXT.fetch_add(1, Ordering::Relaxed)
            ));
            fs::create_dir_all(&root).unwrap();
            for (name, text) in files {
                fs::write(root.join(name), text).unwrap();
            }
            Self(root)
        }
        fn load(&self) -> Result<CompilationUnit, Error> {
            CompilationUnit::load(&self.0.join("main.jai"))
        }
    }
    impl Drop for Fixture {
        fn drop(&mut self) {
            let _ = fs::remove_dir_all(&self.0);
        }
    }
    #[test]
    fn recursive_load_resolves_symbols_and_deduplicates() {
        let f = Fixture::new(&[
            (
                "main.jai",
                "#load \"helper.jai\"; #load \"./helper.jai\"; main :: () -> int { return answer(); }",
            ),
            (
                "helper.jai",
                "#load \"value.jai\"; answer :: () -> int { return value; }",
            ),
            ("value.jai", "value :: 42;"),
        ]);
        let unit = f.load().unwrap();
        assert_eq!(unit.sources().len(), 3);
        unit.resolve().unwrap();
    }
    #[test]
    fn diagnostic_points_into_loaded_file() {
        let f = Fixture::new(&[
            ("main.jai", "#load \"bad.jai\"; main :: () {}"),
            ("bad.jai", "\nbad :: () -> int { return absent; }"),
        ]);
        let error = f.load().unwrap().resolve().unwrap_err().to_string();
        assert!(error.contains("bad.jai:2:"), "{error}");
    }
    #[test]
    fn structured_errors_and_immutable_source_identity() {
        let fixture = Fixture::new(&[
            ("main.jai", "#load \"bad.jai\"; main :: () {}"),
            ("bad.jai", "\nbad :: () -> int { return absent; }"),
        ]);
        let unit = fixture.load().unwrap();
        assert_eq!(unit.id().index(), 0);
        assert_eq!(unit.module().index(), 0);
        let source = &unit.sources()[1];
        assert_eq!(source.id().index(), 1);
        assert_eq!(source.path().file_name().unwrap(), "bad.jai");
        assert!(source.text().starts_with('\n'));
        match unit.resolve().unwrap_err() {
            Error::Located {
                source: id,
                path,
                diagnostic,
                ..
            } => {
                assert_eq!(id, source.id());
                assert_eq!(path, source.path());
                assert!(diagnostic.span.start > 0);
            }
            other => panic!("expected located diagnostic, got {other:?}"),
        }
        assert!(matches!(
            Fixture::new(&[("main.jai", "#load \"main.jai\";")]).load(),
            Err(Error::LoadCycle { .. })
        ));
        assert!(matches!(
            Fixture::new(&[("main.jai", "#load \"missing.jai\";")]).load(),
            Err(Error::Io { .. })
        ));
    }
    #[test]
    fn cycles_missing_files_and_imports_fail() {
        for files in [
            vec![("main.jai", "#load \"main.jai\";")],
            vec![("main.jai", "#load \"missing.jai\";")],
            vec![("main.jai", "#import \"Basic\";")],
            vec![("main.jai", "main :: () { #load \"a.jai\"; }")],
            vec![("main.jai", "#load \"a.jai\"")],
        ] {
            assert!(Fixture::new(&files).load().is_err());
        }
    }
}
