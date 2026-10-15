#!/usr/bin/env python3
"""Check actual public bionic header ABI with native Clang Android targets.

Downloads only public C headers into the explicitly assigned T7 output. This is
cross-target C layout validation, not execution on an Android device or Jai test.
"""
import hashlib
import json
import os
from pathlib import Path
import re
import subprocess
import tempfile
import urllib.error
import urllib.request

ROOT_URL = "https://raw.githubusercontent.com/aosp-mirror/platform_bionic/master/"
PROBE = r"""
#include <stddef.h>
#include <sys/socket.h>
#include <netinet/in.h>
_Static_assert(SHUT_RD == 0 && SHUT_WR == 1 && SHUT_RDWR == 2, "shutdown values");
_Static_assert(sizeof(sa_family_t) == 2, "family width");
_Static_assert(sizeof(struct sockaddr) == 16 && offsetof(struct sockaddr, sa_data) == 2, "socket address");
_Static_assert(sizeof(struct linger) == 8 && offsetof(struct linger, l_linger) == 4, "linger");
_Static_assert(sizeof(struct in_addr) == 4, "IPv4");
_Static_assert(sizeof(struct ip_mreqn) == 12 && offsetof(struct ip_mreqn, imr_address) == 4 && offsetof(struct ip_mreqn, imr_ifindex) == 8, "membership");
_Static_assert(sizeof(struct in_pktinfo) == 12 && offsetof(struct in_pktinfo, ipi_spec_dst) == 4 && offsetof(struct in_pktinfo, ipi_addr) == 8, "packet info");
_Static_assert(sizeof(struct cmsghdr) == 16 && sizeof(((struct cmsghdr *)0)->cmsg_len) == 8, "ancillary header");
_Static_assert(CMSG_SPACE(0) == 16 && CMSG_SPACE(1) == 24 && CMSG_SPACE(8) == 24 && CMSG_SPACE(9) == 32, "ancillary space");
_Static_assert(_Generic(((struct linger *)0)->l_onoff, int: 1, default: 0), "linger signed integer field");
_Static_assert(_Generic(((struct ip_mreqn *)0)->imr_ifindex, int: 1, default: 0), "membership signed integer field");
_Static_assert(_Generic(((struct in_pktinfo *)0)->ipi_ifindex, int: 1, default: 0), "packet signed integer field");
"""


def main():
    target = Path(os.environ["CARGO_TARGET_DIR"]).resolve()
    if not target.is_relative_to(Path("/Volumes/T7")) or "portable-asn1-socket" not in target.parts:
        raise SystemExit("Use this worker's assigned T7 target")
    output = Path(tempfile.mkdtemp(prefix="android-public-headers-", dir=target))
    source = output / "socket-shapes.c"
    source.write_text(PROBE)
    receipt = {"headers": {}, "commands": [], "verification": "C cross-target static assertions only; Android/Jai execution NOT RUN"}

    for cpu in ["aarch64", "x86_64"]:
        headers = output / cpu / "include"
        headers.mkdir(parents=True)
        for attempt in range(100):
            command = ["clang", "-target", cpu + "-linux-android24", "-nostdlibinc", "-isystem", str(headers),
                       "-std=c11", "-Wall", "-Wextra", "-Werror", "-fsyntax-only", str(source)]
            result = subprocess.run(command, env=dict(os.environ, TMPDIR=str(output)), capture_output=True, text=True)
            (output / (cpu + ".stderr")).write_text(result.stderr)
            missing = re.search(r"fatal error: '([^']+)' file not found", result.stderr)
            if not missing:
                receipt["commands"].append({"argv": command, "returncode": result.returncode})
                (output / "receipt.json").write_text(json.dumps(receipt, indent=2) + "\n")
                if result.returncode:
                    raise SystemExit(f"Header compilation failed: {output}\n{result.stderr}")
                print(cpu + " Android C public header layout assertions PASS", flush=True)
                break
            name = missing[1]
            if not name.endswith(".h") or ".." in Path(name).parts or Path(name).is_absolute():
                raise RuntimeError("Compiler requested a non-header or unsafe path")
            destination = headers / name
            if destination.exists():
                raise RuntimeError("Public header resolution repeated without progress")
            candidates = ["libc/include/" + name, "libc/kernel/uapi/" + name,
                          "libc/kernel/android/uapi/" + name,
                          "libc/kernel/uapi/asm-" + ("arm64" if cpu == "aarch64" else "x86") + "/" + name]
            for relative in candidates:
                try:
                    data = urllib.request.urlopen(ROOT_URL + relative, timeout=30).read()
                except urllib.error.HTTPError as error:
                    if error.code == 404:
                        continue
                    raise
                destination.parent.mkdir(parents=True, exist_ok=True)
                destination.write_bytes(data)
                receipt["headers"][cpu + "/" + name] = {"url": ROOT_URL + relative, "sha256": hashlib.sha256(data).hexdigest()}
                break
            else:
                raise SystemExit(f"Public header dependency unavailable: {name}; evidence: {output}")
        else:
            raise RuntimeError("Public-header dependency limit exceeded")
    print("Evidence: " + str(output))


if __name__ == "__main__":
    main()
