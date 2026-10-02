# File_Watcher remaining contract requests

Reviewed input: `modules/file-watcher.md`. No private record fields or reference
output are requested. Supported Linux/Windows work proceeds independently.

1. What is the exact `OS_HAS_INOTIFY` predicate? Does it include Android? What are
   the intended declarations/bodies of empty PS5/NN_SWITCH2 branches? Current CLI
   checks support Linux/Windows/Mac x64/arm64; no unavailable target formula is
   invented.
2. Does `changed` mean new OS records, changed pending records, or delivered
   callbacks? Current policy is callbacks delivered, with positive wait output
   while watches or delayed callbacks exist.
3. Is root `SCAN_CHILDREN` sufficient after inotify overflow, or must the library
   rebuild recursive registrations? Lost individual notifications cannot be
   reconstructed. Current backend requests enumeration and keeps surviving
   watches; registrations/renames lost during overflow can require recovery.
4. If a configured root itself moves outside watched parents, must the watcher
   stop that tree, follow native identity, or report paths under its original
   name? Linux reports the move but lacks the new path without a watched parent
   cookie pair; keeping the original path can become stale. Windows root-handle
   rename behavior likewise needs a policy. Child rename pairs inside watched
   trees already update Linux paths.
5. Is retry expected after native cancellation/close failure in by-value deinit?
   Is the caller's record reusable without explicit reset? Current policy retains
   live Windows ownership for safe retry and requires reset after consumption.
   No callback is invoked by deinit.
6. The refreshed contract specifies `Basic.seconds_since_init()` timestamps.
   Preserved Mac code consumes its native monotonic timestamp directly. Does Mac
   also require conversion to the Basic epoch? This batch preserves actual Mac
   code as assigned rather than changing it alongside new backends.
