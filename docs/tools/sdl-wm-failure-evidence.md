# SDL window-manager failure evidence

Linux sanitizer job 117243021817 failed the real SDL window-manager runtime assertion. Its retained record does not establish the selected SDL video backend or native provider version. No offscreen-driver explanation or success is inferred.

The unchanged real hidden-window operation in `stdlib/SDL/tests/sdl-wm.jai` now stores its single `SDL_GetWindowWMInfo` return and, only on failure, prints that return, the reported subsystem, current public SDL video driver, version/revision and public/native structure sizes. The original success, platform/subsystem, pointer, canary and ABI assertions remain required. No extra window call, replacement provider, backend override or skip was added; native helper source/assets are unchanged.

The current source check and unchanged repository formatter check pass. Actual Linux sanitizer replay remains required and is owned by the SDL implementer. The already running d9f32f30 catalogue keeps its original captured fixture, preserving that snapshot's evidence. Initial formatter invocation incorrectly used unsupported `--write`; the normal formatting command and subsequent `--check` succeeded. That setup error is not a runtime result.
