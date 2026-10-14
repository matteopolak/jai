# Sound_Player contract refinement status

The refreshed reviewed module spec resolves questions 2, 4, 6, 7 and 9.
Implementation follows those rules; original private source behavior is not an
additional dependency or compatibility input.

- Spatial projection is gated by listener/SPATIALIZED state. VBAP selects the
  greatest-minimum pair and retains positive components outside coverage.
  Closeness uses planar distance and min(VERY_CLOSE, inner_radius * 0.75).
  Locked mono/stereo, music coefficients and footstep rear exclusion are defined.
  Stereo positional override is not active behavior; no invented override is
  required. Invalid VBAP topology remains a caller precondition.
- Successful buffer bounds return true/true and truncate at repeat end; final
  interpolation holds the page endpoint. Accumulation always returns false,
  supports signed/zero rate and advances through missing-data silence except
  while waiting for initial compressed pages.
- Android adds private AAudio hooks, not missing facade signatures. Its actual
  backend remains blocked by the compiler's absent Android target. Requested
  format/focus warning/channel-mask behavior is documented for that work.
- Seven source channels fit capacity, but no dedicated center-rear mapping is
  specified. No seven-channel layout is invented: the implementation preserves
  caller-configured source directions for seven-channel data. filename metadata
  has no decoder/file-streaming side effect and is intentionally unread.
- Circular distance is rear-to-front, equal cursors zero. Desktop async-hook
  results are Windows/macOS true and Linux false; main-thread updates follow
  that meaning even when a mixer thread exists.
- History and independent entity phases were previously resolved. Gain derivative
  is the documented 1/30 output scale per second. PS5/Switch private backend
  bodies are unavailable; no implementation is inferred.

Narrow numeric clarification for future exact compatibility: the spatial prose
does not specify the shared stereo-base magnitude, initial speaker/source vector
angles, unconstrained-VBAP normalization stage, source-direction rotation rule,
or near-fill blend equation. Current code independently uses a 0.5 shared base,
unit-power normalization after positive-component filtering, channel directions
rotated in the stream's plane, and a linear near-fill blend followed by unit-power
normalization. These satisfy the stated broad rules; their exact private numeric
choices are not claimed as reviewed requirements. This is not a request for
original source and does not block other supported implementation work.

The reviewed original threaded Ogg no-op conflicts with the explicit assignment's
proper playback/queue requirement. Real decoding/completion remains a documented,
intentional behavioral improvement. Duplicate-pointer starts release once when
the final live entry is removed; stop reentrancy is tested. Init/shutdown or
reinitialization from release callbacks remains caller-serialized unless a future
review explicitly establishes broader reentrancy.
