# Portable sound implementation

The `Sound_Player` facade loads independently grouped public records, scalar
sample arithmetic and live topology storage under `internal/audio`. It preserves
the reviewed module parameters. Nineteen canonical common records/enums retain
all reviewed fields/defaults/order, including stream/data/configuration and
decoder/page records. `generate_sound_records.py` extracts only reviewed public
shapes, groups them by subsystem dependencies and runs our source-built formatter.
Math types are imported from the numerics worker, with no duplicate math module.
The decoder records alone do not claim decoder execution support.

Supported operations are the two-input `add`, in-place `plus_equals`, all three
`multiply` overloads, `times_equals`, bounded little-endian `get_magic4` and
`count_retired_decoders`. Addition uses the requested 0–8 channels; remaining
result channels start at zero. In-place addition preserves inactive channels.
Multiplication operates on all eight lanes. These inactive-channel and bounds
policies need detailed reference review; no implicit clipping or perceptual
volume law is invented. Invalid inputs fail through real assertions.

The reviewed `arcs_6ch`/`arcs_8ch` initializers are mutable arrays with the exact
speaker pairs and zero matrix defaults. `arcs` remains a mutable slice, and
`retired_decoders` is a mutable resizable pointer array. `the_accumulator` retains
its specified 48,000-element mutable storage and canonical sample type. Shared
imports reference the same entities. No snapshot aliases or private copies are
used. Caller mutation/decoder counting currently requires caller synchronization;
there is no initialized audio thread/backend yet.

Playback initialization/shutdown, enumeration/backends, stream lifecycle, queues,
mixing/resampling, panning, volume law, file loading and compressed-page decoding
remain unfinished. Cached_Ogg_Decoder and platform-native ABI records also remain
unimplemented in this batch; no opaque replacement or fake successful device is
provided. The additional speaker/source direction arrays need reviewed initial
values and processing contracts before real panning implementation. The reviewed
Matrix2 inverse helper requires coordination with delegated numerics work.

`tests/portable-stdlib/sound-samples.jai` exercises arithmetic, inactive lane
preservation, derived sample layout, canonical reflected names/defaults,
bounded magic reads, exact topology pairs and cross-import mutable storage.
Separate checked-fault tests cover excessive channel counts and truncated reads.
Interpreter/native and target checks use the source-built compiler and new
numerics integration input; this is not a whole playback-system integration pass.
