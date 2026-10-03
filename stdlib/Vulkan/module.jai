#load "version.jai";
// Independently normalized ABI contract. No reference procedure bodies or binaries.
#module_parameters ( USE_VULKAN_1_1 := true ) ;
VK_NULL_HANDLE :: null ;
VK_TRUE : VkBool32 : 1 ;
VK_FALSE : VkBool32 : 0 ;
VK_WHOLE_SIZE : u64 : xx ~ 0 ;
VK_ATTACHMENT_UNUSED : u32 : 0xffff_ffff ;
VK_QUEUE_FAMILY_IGNORED : u32 : 0xffff_ffff ;
VK_REMAINING_ARRAY_LAYERS : u32 : 0xffff_ffff ;
VK_REMAINING_MIP_LEVELS : u32 : 0xffff_ffff ;
VK_SUBPASS_EXTERNAL : u32 : 0xffff_ffff ;
VK_MAX_PHYSICAL_DEVICE_NAME_SIZE : u32 : 256 ;
VK_UUID_SIZE : u32 : 16 ;
VK_MAX_MEMORY_TYPES : u32 : 32 ;
VK_MAX_MEMORY_HEAPS : u32 : 16 ;
VK_MAX_EXTENSION_NAME_SIZE : u32 : 256 ;
VK_MAX_DESCRIPTION_SIZE : u32 : 256 ;
VK_API_VERSION_1_0 :: #run VK_MAKE_VERSION ( 1 , 0 , 0 ) ;
VK_API_VERSION_1_1 :: #run VK_MAKE_VERSION ( 1 , 1 , 0 ) ;
VK_API_VERSION_1_2 :: #run VK_MAKE_VERSION ( 1 , 2 , 0 ) ;
#if OS == . WINDOWS {
    #load "generated_windows.jai" ;
    #load "windows_extras.jai" ;
    vkCreateWin32SurfaceKHR :: ( instance : VkInstance , pCreateInfo : * VkWin32SurfaceCreateInfoKHR , pAllocator : * VkAllocationCallbacks , pSurface : * VkSurfaceKHR ) -> VkResult #foreign libvulkan ;
    vkGetPhysicalDeviceWin32PresentationSupportKHR :: ( physicalDevice : VkPhysicalDevice , queueFamilyIndex : u32 ) -> VkBool32 #foreign libvulkan ;
    #scope_file
    libvulkan :: #system_library "vulkan-1";
}
else #if OS == . LINUX || OS == . ANDROID {
    #load "generated_linux.jai" ;
    libvulkan :: #system_library "vulkan" ;
}
else {
    #assert false "Unsupported OS" ;
}

#load "dispatch-native.jai";
#load "dispatch-registry.jai";
#if OS == .LINUX || OS == .ANDROID { #load "extension-enumeration.jai"; }
