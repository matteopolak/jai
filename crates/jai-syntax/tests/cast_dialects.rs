//! Static parsing of the original cast statement bytes; no reference tool executes.
use jai_source::{SourceMap, Symbols};
use std::{fs, path::Path};

#[test]
fn supplied_cast_statements_keep_their_original_source_spelling() {
    for (relative, prefix) in [
        (
            "reference/modules/Hash_Table.jai",
            "mask := cast,trunc(u32)",
        ),
        (
            "corpus/upstream/ostef--Vk-Engine/Modules/Hash_Map.jai",
            "mask := cast, trunc(map.HashType)",
        ),
        (
            "corpus/upstream/roeyb1--sgpu/shader_vfs.jai",
            "refcount_ptr: *u32 = cast(*u32, cast(*u8, this) + 16)",
        ),
        (
            "reference/modules/Ico_File.jai",
            "entry.Width  = cast,trunc(u8) size",
        ),
        (
            "corpus/upstream/roeyb1--sgpu/module.jai",
            "return (it_index + 1).(Gpu_Queue)",
        ),
    ] {
        let path = Path::new(env!("CARGO_MANIFEST_DIR"))
            .join("../..")
            .join(relative);
        let bytes = fs::read(path).unwrap();
        let text = jai_lexer::decode_source(&bytes).unwrap();
        let start = text.find(prefix).unwrap();
        let end = start + text[start..].find(';').unwrap() + 1;
        let statement = &text[start..end];
        let fixture = format!("main::(){{{statement}}}");
        let mut sources = SourceMap::default();
        let id = sources.insert(relative.into(), fixture);
        let result = jai_syntax::parse_file(sources.get(id).unwrap(), &mut Symbols::default());
        if relative == "reference/modules/Hash_Table.jai" {
            // The cast policy now parses; legacy macro capture remains a separate boundary.
            let error = result.unwrap_err();
            assert_eq!(
                error.location.span.text(sources.get(id).unwrap().text()),
                "`"
            );
            assert_eq!(
                error.message,
                "expected expression; this syntax is not implemented yet"
            );
        } else {
            assert!(result.is_ok(), "{relative}: {result:?}");
        }
    }
}
