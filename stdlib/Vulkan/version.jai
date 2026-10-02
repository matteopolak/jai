// Version packing is defined by Khronos' integer API-version contract.
VK_MAKE_VERSION :: (major: u32, minor: u32, patch: u32) -> u32 {
    return (major * 0x0040_0000) | (minor * 0x0000_1000) | patch;
}
VK_VERSION_MAJOR :: (version: u32) -> u32 { return version / 0x0040_0000; }
VK_VERSION_MINOR :: (version: u32) -> u32 { return (version / 0x0000_1000) & 1023; }
VK_VERSION_PATCH :: (version: u32) -> u32 { return version & 4095; }
VK_MAKE_API_VERSION :: (variant: u32, major: u32, minor: u32, patch: u32) -> u32 {
    return (variant * 0x2000_0000) | VK_MAKE_VERSION(major, minor, patch);
}
VK_API_VERSION_VARIANT :: (version: u32) -> u32 { return version / 0x2000_0000; }
VK_API_VERSION_MAJOR :: (version: u32) -> u32 { return VK_VERSION_MAJOR(version) & 127; }
VK_API_VERSION_MINOR :: (version: u32) -> u32 { return VK_VERSION_MINOR(version); }
VK_API_VERSION_PATCH :: (version: u32) -> u32 { return VK_VERSION_PATCH(version); }
