//! Recursive-descent parser producing `ast`.
use crate::ast::File;
use crate::source::{Diagnostic, FileId};

pub fn parse_file(_file: FileId, _text: &str) -> Result<File, Diagnostic> {
    todo!("parser")
}
