// Actual Vulkan loader exports, kept private behind lifecycle tracking.
#scope_module
#if OS == .WINDOWS {
    _Vk_Loader :: #system_library "vulkan-1";
    _Vk_Registry_C :: #system_library "msvcrt";
} else {
    _Vk_Loader :: #system_library "vulkan";
    _Vk_Registry_C :: #system_library "c";
}
#if CPU == .X64 || CPU == .ARM64 { _Vk_Size :: u64; }
else { _Vk_Size :: u32; }
_vk_registry_malloc :: (size: _Vk_Size) -> *void #foreign _Vk_Registry_C "malloc";
_vk_registry_free :: (memory: *void) #foreign _Vk_Registry_C "free";
_vk_sdk_vkCreateInstance :: ( pCreateInfo : * VkInstanceCreateInfo , pAllocator : * VkAllocationCallbacks , pInstance : * VkInstance ) -> VkResult #foreign _Vk_Loader "vkCreateInstance";
_vk_sdk_vkDestroyInstance :: ( instance : VkInstance , pAllocator : * VkAllocationCallbacks ) -> void #foreign _Vk_Loader "vkDestroyInstance";
_vk_sdk_vkEnumeratePhysicalDevices :: ( instance : VkInstance , pPhysicalDeviceCount : * u32 , pPhysicalDevices : * VkPhysicalDevice ) -> VkResult #foreign _Vk_Loader "vkEnumeratePhysicalDevices";
_vk_sdk_vkCreateDevice :: ( physicalDevice : VkPhysicalDevice , pCreateInfo : * VkDeviceCreateInfo , pAllocator : * VkAllocationCallbacks , pDevice : * VkDevice ) -> VkResult #foreign _Vk_Loader "vkCreateDevice";
_vk_sdk_vkDestroyDevice :: ( device : VkDevice , pAllocator : * VkAllocationCallbacks ) -> void #foreign _Vk_Loader "vkDestroyDevice";
_vk_sdk_vkGetDeviceQueue :: ( device : VkDevice , queueFamilyIndex : u32 , queueIndex : u32 , pQueue : * VkQueue ) -> void #foreign _Vk_Loader "vkGetDeviceQueue";
_vk_sdk_vkGetDeviceQueue2 :: ( device : VkDevice , pQueueInfo : * VkDeviceQueueInfo2 , pQueue : * VkQueue ) -> void #foreign _Vk_Loader "vkGetDeviceQueue2";
_vk_sdk_vkEnumeratePhysicalDeviceGroups :: ( instance : VkInstance , pPhysicalDeviceGroupCount : * u32 , pPhysicalDeviceGroupProperties : * VkPhysicalDeviceGroupProperties ) -> VkResult #foreign _Vk_Loader "vkEnumeratePhysicalDeviceGroups";
