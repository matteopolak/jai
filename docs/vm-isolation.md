# Native VM isolation

## What it is

A proposed execution boundary for inspecting the original Jai compiler and collecting compatibility evidence after user approval. The user prefers native virtualization, so x86 emulation and Rosetta translation are excluded from the local workflow.

## How it works

This host is ARM64 and `jai-macos` includes an ARM64 slice. Use a fresh ARM64 macOS guest through Apple's Virtualization framework (for example UTM's Apple virtualization backend). Firecracker's Linux/KVM requirements make it unsuitable as a direct macOS runner. An ARM64 Linux guest can statically inspect the Linux executable but cannot run its x86-64 code natively.

UTM is installed, but its current VM inventory is empty. No guest has been installed, configured or started for this project. After the user authorized cleanup of obsolete shared Cargo target artifacts, the worldgen task reported roughly 95 GiB free. This is sufficient for the proposed local setup, but the user subsequently chose GitHub-hosted compiler checks while keeping supplied reference bytes local. No restore image has been downloaded and no local guest installation is currently planned. See [GitHub analysis](github-analysis.md) for hosted compiler checks and the restriction on reference transfer.

Before reference execution, remove network devices, directory sharing, clipboard/drag-and-drop integration, USB passthrough and optional guest agents. Do not sign into iCloud or provide credentials. Deliver hashed inputs on a dedicated read-only disk; use a disposable guest output disk. Inspect actual VM configuration rather than assuming UI defaults are isolated. Shut down the guest before reading results; handle results as untrusted data and never execute exported programs on the host automatically.

Only after a concrete static audit and explicit user approval, begin with version/help and a small inspected source program. Record guest OS, tool versions, input hashes, process creation and filesystem changes, enforcing time and resource limits. Native library loading and `#run` must be treated as code execution. Use a fresh guest state for subsequent experiments.

## How to change it

Add an automated guest runner only after a guest is available and its integration settings have been verified. Keep execution approval scoped to named binaries, hashes and commands. A VM improves isolation but cannot establish that a binary is harmless. Do not reuse or modify the user's unrelated VMs.

`tools/macos_restore_info.swift` queries Apple's supported restore catalog through `VZMacOSRestoreImage.latestSupported`. It emits a structured URL, OS/build version, minimum CPU/RAM requirements and hardware-model compatibility. It creates no guest and downloads no restore image. Build it with `xcrun swiftc -parse-as-library -module-cache-path artifacts/vm/swift-module-cache tools/macos_restore_info.swift -o artifacts/vm/macos-restore-info`, then ad-hoc sign this newly built helper with `codesign --force --sign - --entitlements tools/macos-vm.entitlements.plist artifacts/vm/macos-restore-info`. Run it only as our own tool; never sign or run a reference executable as part of this workflow. Without the virtualization entitlement, Apple's installation service returned catalog error 10001; the signed helper query succeeded.

## Configuration

Initial defaults: 2 vCPUs, 4 GiB RAM or the restore image's required minimum, disconnected networking and dedicated writable guest disks. The macOS guest's necessary display/input devices remain available; every additional host integration must be justified and reviewed.

The user authorized the worldgen task to reclaim obsolete shared Cargo target artifacts, superseding the earlier prohibition for that scoped cleanup. It completed the cleanup while retaining active build outputs and dependencies. Cleanup permission does not authorize execution of supplied binaries. Notify that task before any future CPU-heavy local guest setup and retain at least 15 GiB host headroom.

The signed metadata query returned macOS 27.0.1, build `26A434`, with a supported hardware model and minimum 2 CPUs / 4 GiB RAM. An HTTPS HEAD request to the returned Apple CDN URL reports 26,637,307,067 bytes (about 24.8 GiB) for the restore image alone. Consequently the cleanup request now targets at least 75 GiB available, leaving installation/guest headroom. `artifacts/vm/restore-info.json` records the queried metadata; it is not evidence of a downloaded image or installed guest.

## Dependencies

An ARM64 Mac with virtualization access, UTM or another Apple Virtualization framework runner, Apple macOS restore media and enough disk space. Other platforms require their own native hosts or appropriate guests for full runtime acceptance.

The metadata helper additionally uses the installed Xcode/Swift SDK, Foundation and Apple's Virtualization framework. See [Apple's macOS VM installation documentation](https://developer.apple.com/documentation/virtualization/installing-macos-on-a-virtual-machine) and [UTM's native macOS guest instructions](https://docs.getutm.app/guest-support/macos/).
