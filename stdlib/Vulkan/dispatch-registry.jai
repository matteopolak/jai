// Independently authored provenance registry. It never inspects opaque handle memory.
#scope_module
Vk_Registry_Memory :: #import "Basic";
_Vk_Handle_Family :: enum { INSTANCE; PHYSICAL_DEVICE; DEVICE; QUEUE; }
_Vk_Handle_Record :: struct {
    family: _Vk_Handle_Family;
    generation: u64;
    instance: VkInstance;
    instance_generation: u64;
    physical: VkPhysicalDevice;
    physical_generation: u64;
    device: VkDevice;
    device_generation: u64;
    queue: VkQueue;
    next: *_Vk_Handle_Record;
}
_vk_registry_head: *_Vk_Handle_Record;
_vk_registry_guard: u32;
_vk_registry_next_generation: u64 = 1;
_vk_registry_lock :: () {
    while true {
        acquired, previous := compare_and_swap(*_vk_registry_guard, cast(u32) 0, cast(u32) 1);
        if acquired return;
    }
}
_vk_registry_unlock :: () {
    released, previous := compare_and_swap(*_vk_registry_guard, cast(u32) 1, cast(u32) 0);
    assert(released, "Vulkan registry lock ownership mismatch");
}
_vk_registry_new :: () -> *_Vk_Handle_Record {
    node := cast(*_Vk_Handle_Record) _vk_registry_malloc(cast(_Vk_Size) size_of(_Vk_Handle_Record));
    if node != null Vk_Registry_Memory.memset(node, 0, size_of(_Vk_Handle_Record));
    return node;
}
_vk_registry_stamp :: (node: *_Vk_Handle_Record) -> bool {
    if _vk_registry_next_generation == 0 return false;
    node.generation = _vk_registry_next_generation;
    _vk_registry_next_generation += 1;
    node.next = _vk_registry_head;
    _vk_registry_head = node;
    return true;
}
// These searches are called only while the registry lock is held.
_vk_registry_instance :: (instance: VkInstance) -> *_Vk_Handle_Record {
    node := _vk_registry_head;
    while node != null {
        if node.family == .INSTANCE && node.instance == instance return node;
        node = node.next;
    }
    return null;
}
_vk_registry_physical :: (physical: VkPhysicalDevice) -> *_Vk_Handle_Record {
    node := _vk_registry_head;
    while node != null {
        if node.family == .PHYSICAL_DEVICE && node.physical == physical return node;
        node = node.next;
    }
    return null;
}
_vk_registry_device :: (device: VkDevice) -> *_Vk_Handle_Record {
    node := _vk_registry_head;
    while node != null {
        if node.family == .DEVICE && node.device == device return node;
        node = node.next;
    }
    return null;
}
_vk_registry_queue :: (queue: VkQueue) -> *_Vk_Handle_Record {
    node := _vk_registry_head;
    while node != null {
        if node.family == .QUEUE && node.queue == queue return node;
        node = node.next;
    }
    return null;
}
_vk_registry_valid_instance :: (node: *_Vk_Handle_Record) -> bool {
    if node == null return false;
    root := _vk_registry_instance(node.instance);
    return root != null && root.generation == node.instance_generation;
}
_vk_registry_valid_physical :: (node: *_Vk_Handle_Record) -> bool {
    if !_vk_registry_valid_instance(node) return false;
    parent := _vk_registry_physical(node.physical);
    return parent != null && parent.generation == node.physical_generation;
}
_vk_registry_valid_device :: (node: *_Vk_Handle_Record) -> bool {
    if !_vk_registry_valid_physical(node) return false;
    parent := _vk_registry_device(node.device);
    return parent != null && parent.generation == node.device_generation;
}
_vk_registered_instance :: (instance: VkInstance) -> bool {
    _vk_registry_lock();
    found := _vk_registry_instance(instance) != null;
    _vk_registry_unlock();
    return found;
}
_vk_physical_instance :: (physical: VkPhysicalDevice) -> VkInstance {
    result: VkInstance;
    _vk_registry_lock();
    node := _vk_registry_physical(physical);
    if _vk_registry_valid_instance(node) result = node.instance;
    _vk_registry_unlock();
    return result;
}
_vk_registered_device :: (device: VkDevice) -> bool {
    _vk_registry_lock();
    valid := _vk_registry_valid_physical(_vk_registry_device(device));
    _vk_registry_unlock();
    return valid;
}
_vk_queue_device :: (queue: VkQueue) -> VkDevice {
    result: VkDevice;
    _vk_registry_lock();
    node := _vk_registry_queue(queue);
    if _vk_registry_valid_device(node) result = node.device;
    _vk_registry_unlock();
    return result;
}
// Allocation, deallocation, SDK calls, and user callbacks always run outside the lock.
#scope_export
vk_register_instance :: (instance: VkInstance) -> bool {
    if instance == null return false;
    fresh := _vk_registry_new();
    if fresh == null return false;
    fresh.family = .INSTANCE;
    fresh.instance = instance;
    _vk_registry_lock();
    existing := _vk_registry_instance(instance);
    inserted := false;
    if existing == null {
        inserted = _vk_registry_stamp(fresh);
        if inserted fresh.instance_generation = fresh.generation;
    }
    _vk_registry_unlock();
    if !inserted _vk_registry_free(fresh);
    return inserted || existing != null;
}
vk_register_physical_device :: (instance: VkInstance, physical: VkPhysicalDevice) -> bool {
    if physical == null || instance == null return false;
    fresh := _vk_registry_new();
    if fresh == null return false;
    fresh.family = .PHYSICAL_DEVICE;
    fresh.instance = instance;
    fresh.physical = physical;
    inserted := false;
    valid := false;
    _vk_registry_lock();
    parent := _vk_registry_instance(instance);
    existing := _vk_registry_physical(physical);
    if parent != null {
        if existing != null {
            valid = existing.instance == instance && existing.instance_generation == parent.generation;
        } else {
            fresh.instance_generation = parent.generation;
            inserted = _vk_registry_stamp(fresh);
            if inserted fresh.physical_generation = fresh.generation;
            valid = inserted;
        }
    }
    _vk_registry_unlock();
    if !inserted _vk_registry_free(fresh);
    return valid;
}
vk_register_device :: (physical: VkPhysicalDevice, device: VkDevice) -> bool {
    if physical == null || device == null return false;
    fresh := _vk_registry_new();
    if fresh == null return false;
    fresh.family = .DEVICE;
    fresh.physical = physical;
    fresh.device = device;
    inserted := false;
    valid := false;
    _vk_registry_lock();
    parent := _vk_registry_physical(physical);
    existing := _vk_registry_device(device);
    if _vk_registry_valid_instance(parent) {
        if existing != null {
            valid = existing.physical == physical && existing.physical_generation == parent.generation;
        } else {
            fresh.instance = parent.instance;
            fresh.instance_generation = parent.instance_generation;
            fresh.physical_generation = parent.generation;
            inserted = _vk_registry_stamp(fresh);
            if inserted fresh.device_generation = fresh.generation;
            valid = inserted;
        }
    }
    _vk_registry_unlock();
    if !inserted _vk_registry_free(fresh);
    return valid;
}
vk_register_queue :: (device: VkDevice, queue: VkQueue) -> bool {
    if device == null || queue == null return false;
    fresh := _vk_registry_new();
    if fresh == null return false;
    fresh.family = .QUEUE;
    fresh.device = device;
    fresh.queue = queue;
    inserted := false;
    valid := false;
    _vk_registry_lock();
    parent := _vk_registry_device(device);
    existing := _vk_registry_queue(queue);
    if _vk_registry_valid_physical(parent) {
        if existing != null {
            valid = existing.device == device && existing.device_generation == parent.generation;
        } else {
            fresh.instance = parent.instance;
            fresh.instance_generation = parent.instance_generation;
            fresh.physical = parent.physical;
            fresh.physical_generation = parent.physical_generation;
            fresh.device_generation = parent.generation;
            inserted = _vk_registry_stamp(fresh);
            valid = inserted;
        }
    }
    _vk_registry_unlock();
    if !inserted _vk_registry_free(fresh);
    return valid;
}
#scope_module
_vk_registry_remove :: (family: _Vk_Handle_Family, instance: VkInstance = null,
                        physical: VkPhysicalDevice = null, device: VkDevice = null,
                        queue: VkQueue = null) {
    detached: *_Vk_Handle_Record;
    _vk_registry_lock();
    origin: *_Vk_Handle_Record;
    if family == .INSTANCE origin = _vk_registry_instance(instance);
    else if family == .PHYSICAL_DEVICE origin = _vk_registry_physical(physical);
    else if family == .DEVICE origin = _vk_registry_device(device);
    else origin = _vk_registry_queue(queue);
    if origin != null {
        generation := origin.generation;
        link := *_vk_registry_head;
        while link.* != null {
            node := link.*;
            should_remove := node == origin;
            if family == .INSTANCE should_remove = node.instance == instance && node.instance_generation == generation;
            else if family == .PHYSICAL_DEVICE should_remove = node.physical == physical && node.physical_generation == generation;
            else if family == .DEVICE should_remove = node.device == device && node.device_generation == generation;
            if should_remove {
                link.* = node.next;
                node.next = detached;
                detached = node;
            } else link = *node.next;
        }
    }
    _vk_registry_unlock();
    while detached != null {
        node := detached;
        detached = node.next;
        _vk_registry_free(node);
    }
}
#scope_export
vk_unregister_instance :: (instance: VkInstance) { _vk_registry_remove(.INSTANCE, instance=instance); }
vk_unregister_physical_device :: (physical: VkPhysicalDevice) { _vk_registry_remove(.PHYSICAL_DEVICE, physical=physical); }
vk_unregister_device :: (device: VkDevice) { _vk_registry_remove(.DEVICE, device=device); }
vk_unregister_queue :: (queue: VkQueue) { _vk_registry_remove(.QUEUE, queue=queue); }

vkCreateInstance :: (pCreateInfo: *VkInstanceCreateInfo, pAllocator: *VkAllocationCallbacks, pInstance: *VkInstance) -> VkResult #c_call {
    status := _vk_sdk_vkCreateInstance(pCreateInfo, pAllocator, pInstance);
    if status == .SUCCESS {
        vk_unregister_instance(pInstance.*); // A newly created native handle starts a new lifetime.
        if !vk_register_instance(pInstance.*) {
            _vk_sdk_vkDestroyInstance(pInstance.*, pAllocator);
            pInstance.* = null;
            return .ERROR_OUT_OF_HOST_MEMORY;
        }
    }
    return status;
}
vkDestroyInstance :: (instance: VkInstance, pAllocator: *VkAllocationCallbacks) #c_call {
    vk_unregister_instance(instance);
    _vk_sdk_vkDestroyInstance(instance, pAllocator);
}
vkEnumeratePhysicalDevices :: (instance: VkInstance, pPhysicalDeviceCount: *u32, pPhysicalDevices: *VkPhysicalDevice) -> VkResult #c_call {
    if !_vk_registered_instance(instance) return .ERROR_INITIALIZATION_FAILED;
    status := _vk_sdk_vkEnumeratePhysicalDevices(instance, pPhysicalDeviceCount, pPhysicalDevices);
    if pPhysicalDevices != null && (status == .SUCCESS || status == .INCOMPLETE) {
        for i: 0..cast(s64) pPhysicalDeviceCount.* - 1 {
            if !vk_register_physical_device(instance, pPhysicalDevices[i]) return .ERROR_OUT_OF_HOST_MEMORY;
        }
    }
    return status;
}
vkCreateDevice :: (physicalDevice: VkPhysicalDevice, pCreateInfo: *VkDeviceCreateInfo, pAllocator: *VkAllocationCallbacks, pDevice: *VkDevice) -> VkResult #c_call {
    if _vk_physical_instance(physicalDevice) == null return .ERROR_INITIALIZATION_FAILED;
    status := _vk_sdk_vkCreateDevice(physicalDevice, pCreateInfo, pAllocator, pDevice);
    if status == .SUCCESS {
        vk_unregister_device(pDevice.*);
        if !vk_register_device(physicalDevice, pDevice.*) {
            _vk_sdk_vkDestroyDevice(pDevice.*, pAllocator);
            pDevice.* = null;
            return .ERROR_OUT_OF_HOST_MEMORY;
        }
    }
    return status;
}
vkDestroyDevice :: (device: VkDevice, pAllocator: *VkAllocationCallbacks) #c_call {
    vk_unregister_device(device);
    _vk_sdk_vkDestroyDevice(device, pAllocator);
}
vkGetDeviceQueue :: (device: VkDevice, queueFamilyIndex: u32, queueIndex: u32, pQueue: *VkQueue) #c_call {
    assert(_vk_registered_device(device), "Register an externally created Vulkan device before retrieving queues");
    _vk_sdk_vkGetDeviceQueue(device, queueFamilyIndex, queueIndex, pQueue);
    assert(vk_register_queue(device, pQueue.*), "Vulkan queue registration failed");
}
vkGetDeviceQueue2 :: (device: VkDevice, pQueueInfo: *VkDeviceQueueInfo2, pQueue: *VkQueue) #c_call {
    assert(_vk_registered_device(device), "Register an externally created Vulkan device before retrieving queues");
    _vk_sdk_vkGetDeviceQueue2(device, pQueueInfo, pQueue);
    assert(vk_register_queue(device, pQueue.*), "Vulkan queue registration failed");
}
#scope_module
_vk_register_groups :: (instance: VkInstance, count: u32, groups: *VkPhysicalDeviceGroupProperties) -> bool {
    for g: 0..cast(s64) count - 1 {
        assert(groups[g].physicalDeviceCount <= VK_MAX_DEVICE_GROUP_SIZE, "Invalid Vulkan group count");
        for d: 0..cast(s64) groups[g].physicalDeviceCount - 1 {
            if !vk_register_physical_device(instance, groups[g].physicalDevices[d]) return false;
        }
    }
    return true;
}
#scope_export
vkEnumeratePhysicalDeviceGroups :: (instance: VkInstance, pPhysicalDeviceGroupCount: *u32, pPhysicalDeviceGroupProperties: *VkPhysicalDeviceGroupProperties) -> VkResult #c_call {
    if !_vk_registered_instance(instance) return .ERROR_INITIALIZATION_FAILED;
    status := _vk_sdk_vkEnumeratePhysicalDeviceGroups(instance, pPhysicalDeviceGroupCount, pPhysicalDeviceGroupProperties);
    if pPhysicalDeviceGroupProperties != null && (status == .SUCCESS || status == .INCOMPLETE) {
        if !_vk_register_groups(instance, pPhysicalDeviceGroupCount.*, pPhysicalDeviceGroupProperties) return .ERROR_OUT_OF_HOST_MEMORY;
    }
    return status;
}
