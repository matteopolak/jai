# Audio worker deviations and dependencies

- Described baseline implementation is absent; independently creating it here.
- Signatures/shapes omit behavioral policies; precise questions are recorded.
  Independently chosen behavior is not an oracle compatibility claim.
- Existing offline test depends on OFFLINE/render_offline absent from reviewed
  parameters/inventory. Preserved and classified as an unreviewed extension test.
- Playback, decoders, queues and target ABI remain unfinished until tested.
- No agent_message capability; commentary/status docs carry notifications.
- Shell here-documents fail because temporary files are denied by OS sandbox.
  Durable edits use patch/Python writes; no alternate access attempted. Initial
  empty files were detected and replaced before any completion claim.
