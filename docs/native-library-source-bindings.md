# Native library source bindings

## What it is

`NativeSourceLibraryBinding` ties a real reached graph library declaration to its actual source owner and defining module environment. The frozen IR `ForeignLibrarySources` table retains these witnesses independently of debug information.

## How it works

The graph constructor reads declaration metadata and an actual `SourceRecord` allocation/span, then encodes the real defining environment. The library finalizer transfers these records and verifies that every record refers to a final row. Frozen recovery requires a borrowed row from that exact `Library`. Owner selection and full admission are separate: changed metadata remains a selected source-owner match and is rejected by the complete kind/options/environment check, rather than falling back to the declaration's native path.

## How to change it

Keep actual row membership, retained source identity and complete defining environment checks together. Dense declaration IDs may change across a genuine retained-source graph rebuild. Equal path/text/hash data cannot establish a binding. If local library declarations gain options, extend the immutable metadata comparison before adding native use. Procedure-local library rows currently have no graph witness and cannot receive source-native authority through this table.

## Configuration

There are no flags. The selected source provider/journal must retain genuine source snapshots across rebuilds. A fresh equal source observation cannot rebase. These bindings confer no native read, link or execution authority without the separate authentic fresh artifact receipt.

## Dependencies

This packet requires the retained-source-identity consumer and the selected graph/provider ownership foundation. It uses `ModuleGraph::module_environment_origin`, actual semantic foreign library lowering and the final `ProgramBuilder::finish_library` boundary. Full BuildCpp factory/catalog and final artifact receipt binding are separate finite recovery units. Formatting/apply checks are not native or compiler acceptance.
