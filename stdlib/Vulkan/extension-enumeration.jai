// Independently authored count/query/fill helpers using exact owner dispatch.
#scope_module
Vk_Extension_Memory :: #import "Basic";
#scope_export
vkGetPhysicalDeviceQueueFamilyProperties2KHR :: (physicalDevice: VkPhysicalDevice) -> [] VkQueueFamilyProperties2 {
    data: [] VkQueueFamilyProperties2;
    instance := _vk_physical_instance(physicalDevice);
    assert(instance != null, "Register the Vulkan handle and exact parent before extension queries");
    native := cast(PFN_vkGetPhysicalDeviceQueueFamilyProperties2KHR) vkGetInstanceProcAddr(instance, Vk_Extension_Memory.temp_c_string("vkGetPhysicalDeviceQueueFamilyProperties2KHR"));
    assert(native != null, "vkGetPhysicalDeviceQueueFamilyProperties2KHR is unavailable; enable its extension before this query");
    count: u32 = 0;
    native(physicalDevice, *count, null);
    if count == 0 return data;
    capacity := count;
    data.data = cast(*VkQueueFamilyProperties2) Vk_Extension_Memory.alloc(cast(s64) capacity * size_of(VkQueueFamilyProperties2));
    assert(data.data != null, "Out of host memory for Vulkan query");
    data.count = cast(s64) capacity;
    memset(data.data, 0, data.count * size_of(VkQueueFamilyProperties2));
    for *data it.sType = VkStructureType.QUEUE_FAMILY_PROPERTIES_2;
    native(physicalDevice, *count, data.data);
    assert(count <= capacity, "Vulkan query returned more entries than the supplied capacity");
    data.count = cast(s64) count;
    return data;
}
vkGetPhysicalDeviceSparseImageFormatProperties2KHR :: (physicalDevice: VkPhysicalDevice, pFormatInfo: *VkPhysicalDeviceSparseImageFormatInfo2) -> [] VkSparseImageFormatProperties2 {
    data: [] VkSparseImageFormatProperties2;
    instance := _vk_physical_instance(physicalDevice);
    assert(instance != null, "Register the Vulkan handle and exact parent before extension queries");
    native := cast(PFN_vkGetPhysicalDeviceSparseImageFormatProperties2KHR) vkGetInstanceProcAddr(instance, Vk_Extension_Memory.temp_c_string("vkGetPhysicalDeviceSparseImageFormatProperties2KHR"));
    assert(native != null, "vkGetPhysicalDeviceSparseImageFormatProperties2KHR is unavailable; enable its extension before this query");
    count: u32 = 0;
    native(physicalDevice, pFormatInfo, *count, null);
    if count == 0 return data;
    capacity := count;
    data.data = cast(*VkSparseImageFormatProperties2) Vk_Extension_Memory.alloc(cast(s64) capacity * size_of(VkSparseImageFormatProperties2));
    assert(data.data != null, "Out of host memory for Vulkan query");
    data.count = cast(s64) capacity;
    memset(data.data, 0, data.count * size_of(VkSparseImageFormatProperties2));
    for *data it.sType = VkStructureType.SPARSE_IMAGE_FORMAT_PROPERTIES_2;
    native(physicalDevice, pFormatInfo, *count, data.data);
    assert(count <= capacity, "Vulkan query returned more entries than the supplied capacity");
    data.count = cast(s64) count;
    return data;
}
vkEnumeratePhysicalDeviceGroupsKHR :: (instance: VkInstance) -> [] VkPhysicalDeviceGroupProperties, VkResult {
    data: [] VkPhysicalDeviceGroupProperties;
    if !(_vk_registered_instance(instance)) return data, VkResult.ERROR_INITIALIZATION_FAILED;
    native := cast(PFN_vkEnumeratePhysicalDeviceGroupsKHR) vkGetInstanceProcAddr(instance, Vk_Extension_Memory.temp_c_string("vkEnumeratePhysicalDeviceGroupsKHR"));
    if native == null return data, VkResult.ERROR_EXTENSION_NOT_PRESENT;
    count: u32 = 0;
    status := native(instance, *count, null);
    if cast(s32) status < 0 || count == 0 return data, status;
    capacity := count;
    data.data = cast(*VkPhysicalDeviceGroupProperties) Vk_Extension_Memory.alloc(cast(s64) capacity * size_of(VkPhysicalDeviceGroupProperties));
    if data.data == null return data, VkResult.ERROR_OUT_OF_HOST_MEMORY;
    data.count = cast(s64) capacity;
    memset(data.data, 0, data.count * size_of(VkPhysicalDeviceGroupProperties));
    for *data it.sType = VkStructureType.PHYSICAL_DEVICE_GROUP_PROPERTIES;
    status = native(instance, *count, data.data);
    if cast(s32) status < 0 {
        Vk_Extension_Memory.free(data.data);
        data.data = null;
        data.count = 0;
        return data, status;
    }
    assert(count <= capacity, "Vulkan query returned more entries than the supplied capacity");
    data.count = cast(s64) count;
    if !_vk_register_groups(instance, count, data.data) {
        Vk_Extension_Memory.free(data.data);
        data.data = null;
        data.count = 0;
        return data, VkResult.ERROR_OUT_OF_HOST_MEMORY;
    }
    return data, status;
}
vkGetImageSparseMemoryRequirements2KHR :: (device: VkDevice, pInfo: *VkImageSparseMemoryRequirementsInfo2) -> [] VkSparseImageMemoryRequirements2 {
    data: [] VkSparseImageMemoryRequirements2;
    assert(_vk_registered_device(device), "Register the Vulkan handle and exact parent before extension queries");
    native := cast(PFN_vkGetImageSparseMemoryRequirements2KHR) vkGetDeviceProcAddr(device, Vk_Extension_Memory.temp_c_string("vkGetImageSparseMemoryRequirements2KHR"));
    assert(native != null, "vkGetImageSparseMemoryRequirements2KHR is unavailable; enable its extension before this query");
    count: u32 = 0;
    native(device, pInfo, *count, null);
    if count == 0 return data;
    capacity := count;
    data.data = cast(*VkSparseImageMemoryRequirements2) Vk_Extension_Memory.alloc(cast(s64) capacity * size_of(VkSparseImageMemoryRequirements2));
    assert(data.data != null, "Out of host memory for Vulkan query");
    data.count = cast(s64) capacity;
    memset(data.data, 0, data.count * size_of(VkSparseImageMemoryRequirements2));
    for *data it.sType = VkStructureType.SPARSE_IMAGE_MEMORY_REQUIREMENTS_2;
    native(device, pInfo, *count, data.data);
    assert(count <= capacity, "Vulkan query returned more entries than the supplied capacity");
    data.count = cast(s64) count;
    return data;
}
vkGetPastPresentationTimingGOOGLE :: (device: VkDevice, swapchain: VkSwapchainKHR) -> [] VkPastPresentationTimingGOOGLE, VkResult {
    data: [] VkPastPresentationTimingGOOGLE;
    if !(_vk_registered_device(device)) return data, VkResult.ERROR_INITIALIZATION_FAILED;
    native := cast(PFN_vkGetPastPresentationTimingGOOGLE) vkGetDeviceProcAddr(device, Vk_Extension_Memory.temp_c_string("vkGetPastPresentationTimingGOOGLE"));
    if native == null return data, VkResult.ERROR_EXTENSION_NOT_PRESENT;
    count: u32 = 0;
    status := native(device, swapchain, *count, null);
    if cast(s32) status < 0 || count == 0 return data, status;
    capacity := count;
    data.data = cast(*VkPastPresentationTimingGOOGLE) Vk_Extension_Memory.alloc(cast(s64) capacity * size_of(VkPastPresentationTimingGOOGLE));
    if data.data == null return data, VkResult.ERROR_OUT_OF_HOST_MEMORY;
    data.count = cast(s64) capacity;
    status = native(device, swapchain, *count, data.data);
    if cast(s32) status < 0 {
        Vk_Extension_Memory.free(data.data);
        data.data = null;
        data.count = 0;
        return data, status;
    }
    assert(count <= capacity, "Vulkan query returned more entries than the supplied capacity");
    data.count = cast(s64) count;
    return data, status;
}
vkGetQueueCheckpointDataNV :: (queue: VkQueue) -> [] VkCheckpointDataNV {
    data: [] VkCheckpointDataNV;
    device := _vk_queue_device(queue);
    assert(device != null, "Register the Vulkan handle and exact parent before extension queries");
    native := cast(PFN_vkGetQueueCheckpointDataNV) vkGetDeviceProcAddr(device, Vk_Extension_Memory.temp_c_string("vkGetQueueCheckpointDataNV"));
    assert(native != null, "vkGetQueueCheckpointDataNV is unavailable; enable its extension before this query");
    count: u32 = 0;
    native(queue, *count, null);
    if count == 0 return data;
    capacity := count;
    data.data = cast(*VkCheckpointDataNV) Vk_Extension_Memory.alloc(cast(s64) capacity * size_of(VkCheckpointDataNV));
    assert(data.data != null, "Out of host memory for Vulkan query");
    data.count = cast(s64) capacity;
    memset(data.data, 0, data.count * size_of(VkCheckpointDataNV));
    for *data it.sType = VkStructureType.CHECKPOINT_DATA_NV;
    native(queue, *count, data.data);
    assert(count <= capacity, "Vulkan query returned more entries than the supplied capacity");
    data.count = cast(s64) count;
    return data;
}
