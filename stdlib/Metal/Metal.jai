// Metal API classes, selectors and enums.
init_metal :: () {
    __selectors.GPUEndTime = cast(*void) sel_registerName(cast(*u8) "GPUEndTime\0");
    __selectors.GPUStartTime = cast(*void) sel_registerName(cast(*u8) "GPUStartTime\0");
    __selectors.access = cast(*void) sel_registerName(cast(*u8) "access\0");
    __selectors.addCompletedHandler_ = cast(*void) sel_registerName(cast(*u8) "addCompletedHandler:\0");
    __selectors.addDebugMarker_range_ = cast(*void) sel_registerName(cast(*u8) "addDebugMarker:range:\0");
    __selectors.addScheduledHandler_ = cast(*void) sel_registerName(cast(*u8) "addScheduledHandler:\0");
    __selectors.alignment = cast(*void) sel_registerName(cast(*u8) "alignment\0");
    __selectors.allocatedSize = cast(*void) sel_registerName(cast(*u8) "allocatedSize\0");
    __selectors.allowGPUOptimizedContents = cast(*void) sel_registerName(cast(*u8) "allowGPUOptimizedContents\0");
    __selectors.allowsNextDrawableTimeout = cast(*void) sel_registerName(cast(*u8) "allowsNextDrawableTimeout\0");
    __selectors.alphaBlendOperation = cast(*void) sel_registerName(cast(*u8) "alphaBlendOperation\0");
    __selectors.areProgrammableSamplePositionsSupported = cast(*void) sel_registerName(cast(*u8) "areProgrammableSamplePositionsSupported\0");
    __selectors.areRasterOrderGroupsSupported = cast(*void) sel_registerName(cast(*u8) "areRasterOrderGroupsSupported\0");
    __selectors.argumentBuffersSupport = cast(*void) sel_registerName(cast(*u8) "argumentBuffersSupport\0");
    __selectors.argumentDescriptor = cast(*void) sel_registerName(cast(*u8) "argumentDescriptor\0");
    __selectors.argumentIndex = cast(*void) sel_registerName(cast(*u8) "argumentIndex\0");
    __selectors.argumentIndexStride = cast(*void) sel_registerName(cast(*u8) "argumentIndexStride\0");
    __selectors.arguments = cast(*void) sel_registerName(cast(*u8) "arguments\0");
    __selectors.arrayLength = cast(*void) sel_registerName(cast(*u8) "arrayLength\0");
    __selectors.arrayType = cast(*void) sel_registerName(cast(*u8) "arrayType\0");
    __selectors.attributeIndex = cast(*void) sel_registerName(cast(*u8) "attributeIndex\0");
    __selectors.attributeType = cast(*void) sel_registerName(cast(*u8) "attributeType\0");
    __selectors.attributes = cast(*void) sel_registerName(cast(*u8) "attributes\0");
    __selectors.backFaceStencil = cast(*void) sel_registerName(cast(*u8) "backFaceStencil\0");
    __selectors.beginScope = cast(*void) sel_registerName(cast(*u8) "beginScope\0");
    __selectors.blitCommandEncoder = cast(*void) sel_registerName(cast(*u8) "blitCommandEncoder\0");
    __selectors.borderColor = cast(*void) sel_registerName(cast(*u8) "borderColor\0");
    __selectors.buffer = cast(*void) sel_registerName(cast(*u8) "buffer\0");
    __selectors.bufferAlignment = cast(*void) sel_registerName(cast(*u8) "bufferAlignment\0");
    __selectors.bufferBytesPerRow = cast(*void) sel_registerName(cast(*u8) "bufferBytesPerRow\0");
    __selectors.bufferDataSize = cast(*void) sel_registerName(cast(*u8) "bufferDataSize\0");
    __selectors.bufferDataType = cast(*void) sel_registerName(cast(*u8) "bufferDataType\0");
    __selectors.bufferIndex = cast(*void) sel_registerName(cast(*u8) "bufferIndex\0");
    __selectors.bufferOffset = cast(*void) sel_registerName(cast(*u8) "bufferOffset\0");
    __selectors.bufferPointerType = cast(*void) sel_registerName(cast(*u8) "bufferPointerType\0");
    __selectors.bufferStructType = cast(*void) sel_registerName(cast(*u8) "bufferStructType\0");
    __selectors.buffers = cast(*void) sel_registerName(cast(*u8) "buffers\0");
    __selectors.clearColor = cast(*void) sel_registerName(cast(*u8) "clearColor\0");
    __selectors.clearDepth = cast(*void) sel_registerName(cast(*u8) "clearDepth\0");
    __selectors.clearStencil = cast(*void) sel_registerName(cast(*u8) "clearStencil\0");
    __selectors.colorAttachments = cast(*void) sel_registerName(cast(*u8) "colorAttachments\0");
    __selectors.colorspace = cast(*void) sel_registerName(cast(*u8) "colorspace\0");
    __selectors.commandBuffer = cast(*void) sel_registerName(cast(*u8) "commandBuffer\0");
    __selectors.commandBufferWithUnretainedReferences = cast(*void) sel_registerName(cast(*u8) "commandBufferWithUnretainedReferences\0");
    __selectors.commandQueue = cast(*void) sel_registerName(cast(*u8) "commandQueue\0");
    __selectors.commandTypes = cast(*void) sel_registerName(cast(*u8) "commandTypes\0");
    __selectors.commit = cast(*void) sel_registerName(cast(*u8) "commit\0");
    __selectors.compareFunction = cast(*void) sel_registerName(cast(*u8) "compareFunction\0");
    __selectors.computeCommandEncoder = cast(*void) sel_registerName(cast(*u8) "computeCommandEncoder\0");
    __selectors.computeCommandEncoderWithDispatchType_ = cast(*void) sel_registerName(cast(*u8) "computeCommandEncoderWithDispatchType:\0");
    __selectors.computeFunction = cast(*void) sel_registerName(cast(*u8) "computeFunction\0");
    __selectors.constantBlockAlignment = cast(*void) sel_registerName(cast(*u8) "constantBlockAlignment\0");
    __selectors.constantDataAtIndex_ = cast(*void) sel_registerName(cast(*u8) "constantDataAtIndex:\0");
    __selectors.contents = cast(*void) sel_registerName(cast(*u8) "contents\0");
    __selectors.copyFromBuffer_sourceOffset_sourceBytesPerRow_sourceBytesPerImage_sourceSize_toTexture_destinationSlice_destinationLevel_destinationOrigin_ = cast(*void) sel_registerName(cast(*u8) "copyFromBuffer:sourceOffset:sourceBytesPerRow:sourceBytesPerImage:sourceSize:toTexture:destinationSlice:destinationLevel:destinationOrigin:\0");
    __selectors.copyFromBuffer_sourceOffset_sourceBytesPerRow_sourceBytesPerImage_sourceSize_toTexture_destinationSlice_destinationLevel_destinationOrigin_options_ = cast(*void) sel_registerName(cast(*u8) "copyFromBuffer:sourceOffset:sourceBytesPerRow:sourceBytesPerImage:sourceSize:toTexture:destinationSlice:destinationLevel:destinationOrigin:options:\0");
    __selectors.copyFromBuffer_sourceOffset_toBuffer_destinationOffset_size_ = cast(*void) sel_registerName(cast(*u8) "copyFromBuffer:sourceOffset:toBuffer:destinationOffset:size:\0");
    __selectors.copyFromTexture_sourceSlice_sourceLevel_sourceOrigin_sourceSize_toBuffer_destinationOffset_destinationBytesPerRow_destinationBytesPerImage_ = cast(*void) sel_registerName(cast(*u8) "copyFromTexture:sourceSlice:sourceLevel:sourceOrigin:sourceSize:toBuffer:destinationOffset:destinationBytesPerRow:destinationBytesPerImage:\0");
    __selectors.copyFromTexture_sourceSlice_sourceLevel_sourceOrigin_sourceSize_toBuffer_destinationOffset_destinationBytesPerRow_destinationBytesPerImage_options_ = cast(*void) sel_registerName(cast(*u8) "copyFromTexture:sourceSlice:sourceLevel:sourceOrigin:sourceSize:toBuffer:destinationOffset:destinationBytesPerRow:destinationBytesPerImage:options:\0");
    __selectors.copyFromTexture_sourceSlice_sourceLevel_sourceOrigin_sourceSize_toTexture_destinationSlice_destinationLevel_destinationOrigin_ = cast(*void) sel_registerName(cast(*u8) "copyFromTexture:sourceSlice:sourceLevel:sourceOrigin:sourceSize:toTexture:destinationSlice:destinationLevel:destinationOrigin:\0");
    __selectors.copyIndirectCommandBuffer_sourceRange_destination_destinationIndex_ = cast(*void) sel_registerName(cast(*u8) "copyIndirectCommandBuffer:sourceRange:destination:destinationIndex:\0");
    __selectors.cpuCacheMode = cast(*void) sel_registerName(cast(*u8) "cpuCacheMode\0");
    __selectors.currentAllocatedSize = cast(*void) sel_registerName(cast(*u8) "currentAllocatedSize\0");
    __selectors.dataSize = cast(*void) sel_registerName(cast(*u8) "dataSize\0");
    __selectors.dataType = cast(*void) sel_registerName(cast(*u8) "dataType\0");
    __selectors.defaultCaptureScope = cast(*void) sel_registerName(cast(*u8) "defaultCaptureScope\0");
    __selectors.depth = cast(*void) sel_registerName(cast(*u8) "depth\0");
    __selectors.depthAttachment = cast(*void) sel_registerName(cast(*u8) "depthAttachment\0");
    __selectors.depthAttachmentPixelFormat = cast(*void) sel_registerName(cast(*u8) "depthAttachmentPixelFormat\0");
    __selectors.depthCompareFunction = cast(*void) sel_registerName(cast(*u8) "depthCompareFunction\0");
    __selectors.depthFailureOperation = cast(*void) sel_registerName(cast(*u8) "depthFailureOperation\0");
    __selectors.depthPlane = cast(*void) sel_registerName(cast(*u8) "depthPlane\0");
    __selectors.depthResolveFilter = cast(*void) sel_registerName(cast(*u8) "depthResolveFilter\0");
    __selectors.depthStencilPassOperation = cast(*void) sel_registerName(cast(*u8) "depthStencilPassOperation\0");
    __selectors.destinationAlphaBlendFactor = cast(*void) sel_registerName(cast(*u8) "destinationAlphaBlendFactor\0");
    __selectors.destinationRGBBlendFactor = cast(*void) sel_registerName(cast(*u8) "destinationRGBBlendFactor\0");
    __selectors.device = cast(*void) sel_registerName(cast(*u8) "device\0");
    __selectors.didModifyRange_ = cast(*void) sel_registerName(cast(*u8) "didModifyRange:\0");
    __selectors.dispatchQueue = cast(*void) sel_registerName(cast(*u8) "dispatchQueue\0");
    __selectors.dispatchThreadgroupsWithIndirectBuffer_indirectBufferOffset_threadsPerThreadgroup_ = cast(*void) sel_registerName(cast(*u8) "dispatchThreadgroupsWithIndirectBuffer:indirectBufferOffset:threadsPerThreadgroup:\0");
    __selectors.dispatchThreadgroups_threadsPerThreadgroup_ = cast(*void) sel_registerName(cast(*u8) "dispatchThreadgroups:threadsPerThreadgroup:\0");
    __selectors.dispatchThreads_threadsPerThreadgroup_ = cast(*void) sel_registerName(cast(*u8) "dispatchThreads:threadsPerThreadgroup:\0");
    __selectors.dispatchType = cast(*void) sel_registerName(cast(*u8) "dispatchType\0");
    __selectors.displaySyncEnabled = cast(*void) sel_registerName(cast(*u8) "displaySyncEnabled\0");
    __selectors.drawIndexedPatches_patchIndexBuffer_patchIndexBufferOffset_controlPointIndexBuffer_controlPointIndexBufferOffset_indirectBuffer_indirectBufferOffset_ = cast(*void) sel_registerName(cast(*u8) "drawIndexedPatches:patchIndexBuffer:patchIndexBufferOffset:controlPointIndexBuffer:controlPointIndexBufferOffset:indirectBuffer:indirectBufferOffset:\0");
    __selectors.drawIndexedPatches_patchStart_patchCount_patchIndexBuffer_patchIndexBufferOffset_controlPointIndexBuffer_controlPointIndexBufferOffset_instanceCount_baseInstance_ = cast(*void) sel_registerName(cast(*u8) "drawIndexedPatches:patchStart:patchCount:patchIndexBuffer:patchIndexBufferOffset:controlPointIndexBuffer:controlPointIndexBufferOffset:instanceCount:baseInstance:\0");
    __selectors.drawIndexedPatches_patchStart_patchCount_patchIndexBuffer_patchIndexBufferOffset_controlPointIndexBuffer_controlPointIndexBufferOffset_instanceCount_baseInstance_tessellationFactorBuffer_tessellationFactorBufferOffset_tessellationFactorBufferInstanceStride_ = cast(*void) sel_registerName(cast(*u8) "drawIndexedPatches:patchStart:patchCount:patchIndexBuffer:patchIndexBufferOffset:controlPointIndexBuffer:controlPointIndexBufferOffset:instanceCount:baseInstance:tessellationFactorBuffer:tessellationFactorBufferOffset:tessellationFactorBufferInstanceStride:\0");
    __selectors.drawIndexedPrimitives_indexCount_indexType_indexBuffer_indexBufferOffset_ = cast(*void) sel_registerName(cast(*u8) "drawIndexedPrimitives:indexCount:indexType:indexBuffer:indexBufferOffset:\0");
    __selectors.drawIndexedPrimitives_indexCount_indexType_indexBuffer_indexBufferOffset_instanceCount_ = cast(*void) sel_registerName(cast(*u8) "drawIndexedPrimitives:indexCount:indexType:indexBuffer:indexBufferOffset:instanceCount:\0");
    __selectors.drawIndexedPrimitives_indexCount_indexType_indexBuffer_indexBufferOffset_instanceCount_baseVertex_baseInstance_ = cast(*void) sel_registerName(cast(*u8) "drawIndexedPrimitives:indexCount:indexType:indexBuffer:indexBufferOffset:instanceCount:baseVertex:baseInstance:\0");
    __selectors.drawIndexedPrimitives_indexType_indexBuffer_indexBufferOffset_indirectBuffer_indirectBufferOffset_ = cast(*void) sel_registerName(cast(*u8) "drawIndexedPrimitives:indexType:indexBuffer:indexBufferOffset:indirectBuffer:indirectBufferOffset:\0");
    __selectors.drawPatches_patchIndexBuffer_patchIndexBufferOffset_indirectBuffer_indirectBufferOffset_ = cast(*void) sel_registerName(cast(*u8) "drawPatches:patchIndexBuffer:patchIndexBufferOffset:indirectBuffer:indirectBufferOffset:\0");
    __selectors.drawPatches_patchStart_patchCount_patchIndexBuffer_patchIndexBufferOffset_instanceCount_baseInstance_ = cast(*void) sel_registerName(cast(*u8) "drawPatches:patchStart:patchCount:patchIndexBuffer:patchIndexBufferOffset:instanceCount:baseInstance:\0");
    __selectors.drawPatches_patchStart_patchCount_patchIndexBuffer_patchIndexBufferOffset_instanceCount_baseInstance_tessellationFactorBuffer_tessellationFactorBufferOffset_tessellationFactorBufferInstanceStride_ = cast(*void) sel_registerName(cast(*u8) "drawPatches:patchStart:patchCount:patchIndexBuffer:patchIndexBufferOffset:instanceCount:baseInstance:tessellationFactorBuffer:tessellationFactorBufferOffset:tessellationFactorBufferInstanceStride:\0");
    __selectors.drawPrimitives_indirectBuffer_indirectBufferOffset_ = cast(*void) sel_registerName(cast(*u8) "drawPrimitives:indirectBuffer:indirectBufferOffset:\0");
    __selectors.drawPrimitives_vertexStart_vertexCount_ = cast(*void) sel_registerName(cast(*u8) "drawPrimitives:vertexStart:vertexCount:\0");
    __selectors.drawPrimitives_vertexStart_vertexCount_instanceCount_ = cast(*void) sel_registerName(cast(*u8) "drawPrimitives:vertexStart:vertexCount:instanceCount:\0");
    __selectors.drawPrimitives_vertexStart_vertexCount_instanceCount_baseInstance_ = cast(*void) sel_registerName(cast(*u8) "drawPrimitives:vertexStart:vertexCount:instanceCount:baseInstance:\0");
    __selectors.drawableSize = cast(*void) sel_registerName(cast(*u8) "drawableSize\0");
    __selectors.elementArrayType = cast(*void) sel_registerName(cast(*u8) "elementArrayType\0");
    __selectors.elementIsArgumentBuffer = cast(*void) sel_registerName(cast(*u8) "elementIsArgumentBuffer\0");
    __selectors.elementPointerType = cast(*void) sel_registerName(cast(*u8) "elementPointerType\0");
    __selectors.elementStructType = cast(*void) sel_registerName(cast(*u8) "elementStructType\0");
    __selectors.elementTextureReferenceType = cast(*void) sel_registerName(cast(*u8) "elementTextureReferenceType\0");
    __selectors.elementType = cast(*void) sel_registerName(cast(*u8) "elementType\0");
    __selectors.encodeSignalEvent_value_ = cast(*void) sel_registerName(cast(*u8) "encodeSignalEvent:value:\0");
    __selectors.encodeWaitForEvent_value_ = cast(*void) sel_registerName(cast(*u8) "encodeWaitForEvent:value:\0");
    __selectors.encodedLength = cast(*void) sel_registerName(cast(*u8) "encodedLength\0");
    __selectors.endEncoding = cast(*void) sel_registerName(cast(*u8) "endEncoding\0");
    __selectors.endScope = cast(*void) sel_registerName(cast(*u8) "endScope\0");
    __selectors.enqueue = cast(*void) sel_registerName(cast(*u8) "enqueue\0");
    __selectors.error = cast(*void) sel_registerName(cast(*u8) "error\0");
    __selectors.executeCommandsInBuffer_indirectBuffer_indirectBufferOffset_ = cast(*void) sel_registerName(cast(*u8) "executeCommandsInBuffer:indirectBuffer:indirectBufferOffset:\0");
    __selectors.executeCommandsInBuffer_withRange_ = cast(*void) sel_registerName(cast(*u8) "executeCommandsInBuffer:withRange:\0");
    __selectors.fastMathEnabled = cast(*void) sel_registerName(cast(*u8) "fastMathEnabled\0");
    __selectors.fillBuffer_range_value_ = cast(*void) sel_registerName(cast(*u8) "fillBuffer:range:value:\0");
    __selectors.format = cast(*void) sel_registerName(cast(*u8) "format\0");
    __selectors.fragmentArguments = cast(*void) sel_registerName(cast(*u8) "fragmentArguments\0");
    __selectors.fragmentBuffers = cast(*void) sel_registerName(cast(*u8) "fragmentBuffers\0");
    __selectors.fragmentFunction = cast(*void) sel_registerName(cast(*u8) "fragmentFunction\0");
    __selectors.framebufferOnly = cast(*void) sel_registerName(cast(*u8) "framebufferOnly\0");
    __selectors.frontFaceStencil = cast(*void) sel_registerName(cast(*u8) "frontFaceStencil\0");
    __selectors.functionConstantsDictionary = cast(*void) sel_registerName(cast(*u8) "functionConstantsDictionary\0");
    __selectors.functionNames = cast(*void) sel_registerName(cast(*u8) "functionNames\0");
    __selectors.functionType = cast(*void) sel_registerName(cast(*u8) "functionType\0");
    __selectors.generateMipmapsForTexture_ = cast(*void) sel_registerName(cast(*u8) "generateMipmapsForTexture:\0");
    __selectors.getBytes_bytesPerRow_bytesPerImage_fromRegion_mipmapLevel_slice_ = cast(*void) sel_registerName(cast(*u8) "getBytes:bytesPerRow:bytesPerImage:fromRegion:mipmapLevel:slice:\0");
    __selectors.getBytes_bytesPerRow_fromRegion_mipmapLevel_ = cast(*void) sel_registerName(cast(*u8) "getBytes:bytesPerRow:fromRegion:mipmapLevel:\0");
    __selectors.getDefaultSamplePositions_count_ = cast(*void) sel_registerName(cast(*u8) "getDefaultSamplePositions:count:\0");
    __selectors.getSamplePositions_count_ = cast(*void) sel_registerName(cast(*u8) "getSamplePositions:count:\0");
    __selectors.heap = cast(*void) sel_registerName(cast(*u8) "heap\0");
    __selectors.heapBufferSizeAndAlignWithLength_options_ = cast(*void) sel_registerName(cast(*u8) "heapBufferSizeAndAlignWithLength:options:\0");
    __selectors.heapTextureSizeAndAlignWithDescriptor_ = cast(*void) sel_registerName(cast(*u8) "heapTextureSizeAndAlignWithDescriptor:\0");
    __selectors.height = cast(*void) sel_registerName(cast(*u8) "height\0");
    __selectors.index = cast(*void) sel_registerName(cast(*u8) "index\0");
    __selectors.indexBufferIndex = cast(*void) sel_registerName(cast(*u8) "indexBufferIndex\0");
    __selectors.indexType = cast(*void) sel_registerName(cast(*u8) "indexType\0");
    __selectors.indirectRenderCommandAtIndex_ = cast(*void) sel_registerName(cast(*u8) "indirectRenderCommandAtIndex:\0");
    __selectors.inheritBuffers = cast(*void) sel_registerName(cast(*u8) "inheritBuffers\0");
    __selectors.inheritPipelineState = cast(*void) sel_registerName(cast(*u8) "inheritPipelineState\0");
    __selectors.init = cast(*void) sel_registerName(cast(*u8) "init\0");
    __selectors.initWithDispatchQueue_ = cast(*void) sel_registerName(cast(*u8) "initWithDispatchQueue:\0");
    __selectors.inputPrimitiveTopology = cast(*void) sel_registerName(cast(*u8) "inputPrimitiveTopology\0");
    __selectors.insertDebugCaptureBoundary = cast(*void) sel_registerName(cast(*u8) "insertDebugCaptureBoundary\0");
    __selectors.insertDebugSignpost_ = cast(*void) sel_registerName(cast(*u8) "insertDebugSignpost:\0");
    __selectors.iosurface = cast(*void) sel_registerName(cast(*u8) "iosurface\0");
    __selectors.iosurfacePlane = cast(*void) sel_registerName(cast(*u8) "iosurfacePlane\0");
    __selectors.isActive = cast(*void) sel_registerName(cast(*u8) "isActive\0");
    __selectors.isAliasable = cast(*void) sel_registerName(cast(*u8) "isAliasable\0");
    __selectors.isAlphaToCoverageEnabled = cast(*void) sel_registerName(cast(*u8) "isAlphaToCoverageEnabled\0");
    __selectors.isAlphaToOneEnabled = cast(*void) sel_registerName(cast(*u8) "isAlphaToOneEnabled\0");
    __selectors.isBlendingEnabled = cast(*void) sel_registerName(cast(*u8) "isBlendingEnabled\0");
    __selectors.isCapturing = cast(*void) sel_registerName(cast(*u8) "isCapturing\0");
    __selectors.isDepth24Stencil8PixelFormatSupported = cast(*void) sel_registerName(cast(*u8) "isDepth24Stencil8PixelFormatSupported\0");
    __selectors.isDepthTexture = cast(*void) sel_registerName(cast(*u8) "isDepthTexture\0");
    __selectors.isDepthWriteEnabled = cast(*void) sel_registerName(cast(*u8) "isDepthWriteEnabled\0");
    __selectors.isFramebufferOnly = cast(*void) sel_registerName(cast(*u8) "isFramebufferOnly\0");
    __selectors.isHeadless = cast(*void) sel_registerName(cast(*u8) "isHeadless\0");
    __selectors.isLowPower = cast(*void) sel_registerName(cast(*u8) "isLowPower\0");
    __selectors.isPatchControlPointData = cast(*void) sel_registerName(cast(*u8) "isPatchControlPointData\0");
    __selectors.isPatchData = cast(*void) sel_registerName(cast(*u8) "isPatchData\0");
    __selectors.isRasterizationEnabled = cast(*void) sel_registerName(cast(*u8) "isRasterizationEnabled\0");
    __selectors.isRemovable = cast(*void) sel_registerName(cast(*u8) "isRemovable\0");
    __selectors.isShareable = cast(*void) sel_registerName(cast(*u8) "isShareable\0");
    __selectors.isTessellationFactorScaleEnabled = cast(*void) sel_registerName(cast(*u8) "isTessellationFactorScaleEnabled\0");
    __selectors.kernelEndTime = cast(*void) sel_registerName(cast(*u8) "kernelEndTime\0");
    __selectors.kernelStartTime = cast(*void) sel_registerName(cast(*u8) "kernelStartTime\0");
    __selectors.label = cast(*void) sel_registerName(cast(*u8) "label\0");
    __selectors.languageVersion = cast(*void) sel_registerName(cast(*u8) "languageVersion\0");
    __selectors.layer = cast(*void) sel_registerName(cast(*u8) "layer\0");
    __selectors.layouts = cast(*void) sel_registerName(cast(*u8) "layouts\0");
    __selectors.length = cast(*void) sel_registerName(cast(*u8) "length\0");
    __selectors.level = cast(*void) sel_registerName(cast(*u8) "level\0");
    __selectors.loadAction = cast(*void) sel_registerName(cast(*u8) "loadAction\0");
    __selectors.lodAverage = cast(*void) sel_registerName(cast(*u8) "lodAverage\0");
    __selectors.lodMaxClamp = cast(*void) sel_registerName(cast(*u8) "lodMaxClamp\0");
    __selectors.lodMinClamp = cast(*void) sel_registerName(cast(*u8) "lodMinClamp\0");
    __selectors.magFilter = cast(*void) sel_registerName(cast(*u8) "magFilter\0");
    __selectors.makeAliasable = cast(*void) sel_registerName(cast(*u8) "makeAliasable\0");
    __selectors.maxAnisotropy = cast(*void) sel_registerName(cast(*u8) "maxAnisotropy\0");
    __selectors.maxArgumentBufferSamplerCount = cast(*void) sel_registerName(cast(*u8) "maxArgumentBufferSamplerCount\0");
    __selectors.maxAvailableSizeWithAlignment_ = cast(*void) sel_registerName(cast(*u8) "maxAvailableSizeWithAlignment:\0");
    __selectors.maxBufferLength = cast(*void) sel_registerName(cast(*u8) "maxBufferLength\0");
    __selectors.maxFragmentBufferBindCount = cast(*void) sel_registerName(cast(*u8) "maxFragmentBufferBindCount\0");
    __selectors.maxTessellationFactor = cast(*void) sel_registerName(cast(*u8) "maxTessellationFactor\0");
    __selectors.maxThreadgroupMemoryLength = cast(*void) sel_registerName(cast(*u8) "maxThreadgroupMemoryLength\0");
    __selectors.maxThreadsPerThreadgroup = cast(*void) sel_registerName(cast(*u8) "maxThreadsPerThreadgroup\0");
    __selectors.maxTotalThreadsPerThreadgroup = cast(*void) sel_registerName(cast(*u8) "maxTotalThreadsPerThreadgroup\0");
    __selectors.maxVertexBufferBindCount = cast(*void) sel_registerName(cast(*u8) "maxVertexBufferBindCount\0");
    __selectors.maximumDrawableCount = cast(*void) sel_registerName(cast(*u8) "maximumDrawableCount\0");
    __selectors.memberByName_ = cast(*void) sel_registerName(cast(*u8) "memberByName:\0");
    __selectors.members = cast(*void) sel_registerName(cast(*u8) "members\0");
    __selectors.memoryBarrierWithResources_count_ = cast(*void) sel_registerName(cast(*u8) "memoryBarrierWithResources:count:\0");
    __selectors.memoryBarrierWithResources_count_afterStages_beforeStages_ = cast(*void) sel_registerName(cast(*u8) "memoryBarrierWithResources:count:afterStages:beforeStages:\0");
    __selectors.memoryBarrierWithScope_ = cast(*void) sel_registerName(cast(*u8) "memoryBarrierWithScope:\0");
    __selectors.memoryBarrierWithScope_afterStages_beforeStages_ = cast(*void) sel_registerName(cast(*u8) "memoryBarrierWithScope:afterStages:beforeStages:\0");
    __selectors.minFilter = cast(*void) sel_registerName(cast(*u8) "minFilter\0");
    __selectors.minimumLinearTextureAlignmentForPixelFormat_ = cast(*void) sel_registerName(cast(*u8) "minimumLinearTextureAlignmentForPixelFormat:\0");
    __selectors.minimumTextureBufferAlignmentForPixelFormat_ = cast(*void) sel_registerName(cast(*u8) "minimumTextureBufferAlignmentForPixelFormat:\0");
    __selectors.mipFilter = cast(*void) sel_registerName(cast(*u8) "mipFilter\0");
    __selectors.mipmapLevelCount = cast(*void) sel_registerName(cast(*u8) "mipmapLevelCount\0");
    __selectors.mutability = cast(*void) sel_registerName(cast(*u8) "mutability\0");
    __selectors.name = cast(*void) sel_registerName(cast(*u8) "name\0");
    __selectors.newArgumentEncoderForBufferAtIndex_ = cast(*void) sel_registerName(cast(*u8) "newArgumentEncoderForBufferAtIndex:\0");
    __selectors.newArgumentEncoderWithArguments_ = cast(*void) sel_registerName(cast(*u8) "newArgumentEncoderWithArguments:\0");
    __selectors.newArgumentEncoderWithBufferIndex_ = cast(*void) sel_registerName(cast(*u8) "newArgumentEncoderWithBufferIndex:\0");
    __selectors.newArgumentEncoderWithBufferIndex_reflection_ = cast(*void) sel_registerName(cast(*u8) "newArgumentEncoderWithBufferIndex:reflection:\0");
    __selectors.newBufferWithBytesNoCopy_length_options_deallocator_ = cast(*void) sel_registerName(cast(*u8) "newBufferWithBytesNoCopy:length:options:deallocator:\0");
    __selectors.newBufferWithBytes_length_options_ = cast(*void) sel_registerName(cast(*u8) "newBufferWithBytes:length:options:\0");
    __selectors.newBufferWithLength_options_ = cast(*void) sel_registerName(cast(*u8) "newBufferWithLength:options:\0");
    __selectors.newCaptureScopeWithCommandQueue_ = cast(*void) sel_registerName(cast(*u8) "newCaptureScopeWithCommandQueue:\0");
    __selectors.newCaptureScopeWithDevice_ = cast(*void) sel_registerName(cast(*u8) "newCaptureScopeWithDevice:\0");
    __selectors.newCommandQueue = cast(*void) sel_registerName(cast(*u8) "newCommandQueue\0");
    __selectors.newCommandQueueWithMaxCommandBufferCount_ = cast(*void) sel_registerName(cast(*u8) "newCommandQueueWithMaxCommandBufferCount:\0");
    __selectors.newComputePipelineStateWithDescriptor_options_completionHandler_ = cast(*void) sel_registerName(cast(*u8) "newComputePipelineStateWithDescriptor:options:completionHandler:\0");
    __selectors.newComputePipelineStateWithDescriptor_options_reflection_error_ = cast(*void) sel_registerName(cast(*u8) "newComputePipelineStateWithDescriptor:options:reflection:error:\0");
    __selectors.newComputePipelineStateWithFunction_completionHandler_ = cast(*void) sel_registerName(cast(*u8) "newComputePipelineStateWithFunction:completionHandler:\0");
    __selectors.newComputePipelineStateWithFunction_error_ = cast(*void) sel_registerName(cast(*u8) "newComputePipelineStateWithFunction:error:\0");
    __selectors.newComputePipelineStateWithFunction_options_completionHandler_ = cast(*void) sel_registerName(cast(*u8) "newComputePipelineStateWithFunction:options:completionHandler:\0");
    __selectors.newComputePipelineStateWithFunction_options_reflection_error_ = cast(*void) sel_registerName(cast(*u8) "newComputePipelineStateWithFunction:options:reflection:error:\0");
    __selectors.newDefaultLibrary = cast(*void) sel_registerName(cast(*u8) "newDefaultLibrary\0");
    __selectors.newDefaultLibraryWithBundle_error_ = cast(*void) sel_registerName(cast(*u8) "newDefaultLibraryWithBundle:error:\0");
    __selectors.newDepthStencilStateWithDescriptor_ = cast(*void) sel_registerName(cast(*u8) "newDepthStencilStateWithDescriptor:\0");
    __selectors.newEvent = cast(*void) sel_registerName(cast(*u8) "newEvent\0");
    __selectors.newFence = cast(*void) sel_registerName(cast(*u8) "newFence\0");
    __selectors.newFunctionWithName_ = cast(*void) sel_registerName(cast(*u8) "newFunctionWithName:\0");
    __selectors.newFunctionWithName_constantValues_completionHandler_ = cast(*void) sel_registerName(cast(*u8) "newFunctionWithName:constantValues:completionHandler:\0");
    __selectors.newFunctionWithName_constantValues_error_ = cast(*void) sel_registerName(cast(*u8) "newFunctionWithName:constantValues:error:\0");
    __selectors.newHeapWithDescriptor_ = cast(*void) sel_registerName(cast(*u8) "newHeapWithDescriptor:\0");
    __selectors.newIndirectCommandBufferWithDescriptor_maxCommandCount_options_ = cast(*void) sel_registerName(cast(*u8) "newIndirectCommandBufferWithDescriptor:maxCommandCount:options:\0");
    __selectors.newLibraryWithData_error_ = cast(*void) sel_registerName(cast(*u8) "newLibraryWithData:error:\0");
    __selectors.newLibraryWithFile_error_ = cast(*void) sel_registerName(cast(*u8) "newLibraryWithFile:error:\0");
    __selectors.newLibraryWithSource_options_completionHandler_ = cast(*void) sel_registerName(cast(*u8) "newLibraryWithSource:options:completionHandler:\0");
    __selectors.newLibraryWithSource_options_error_ = cast(*void) sel_registerName(cast(*u8) "newLibraryWithSource:options:error:\0");
    __selectors.newLibraryWithURL_error_ = cast(*void) sel_registerName(cast(*u8) "newLibraryWithURL:error:\0");
    __selectors.newRenderPipelineStateWithDescriptor_completionHandler_ = cast(*void) sel_registerName(cast(*u8) "newRenderPipelineStateWithDescriptor:completionHandler:\0");
    __selectors.newRenderPipelineStateWithDescriptor_error_ = cast(*void) sel_registerName(cast(*u8) "newRenderPipelineStateWithDescriptor:error:\0");
    __selectors.newRenderPipelineStateWithDescriptor_options_completionHandler_ = cast(*void) sel_registerName(cast(*u8) "newRenderPipelineStateWithDescriptor:options:completionHandler:\0");
    __selectors.newRenderPipelineStateWithDescriptor_options_reflection_error_ = cast(*void) sel_registerName(cast(*u8) "newRenderPipelineStateWithDescriptor:options:reflection:error:\0");
    __selectors.newSamplerStateWithDescriptor_ = cast(*void) sel_registerName(cast(*u8) "newSamplerStateWithDescriptor:\0");
    __selectors.newSharedEvent = cast(*void) sel_registerName(cast(*u8) "newSharedEvent\0");
    __selectors.newSharedEventHandle = cast(*void) sel_registerName(cast(*u8) "newSharedEventHandle\0");
    __selectors.newSharedEventWithHandle_ = cast(*void) sel_registerName(cast(*u8) "newSharedEventWithHandle:\0");
    __selectors.newSharedTextureHandle = cast(*void) sel_registerName(cast(*u8) "newSharedTextureHandle\0");
    __selectors.newSharedTextureWithDescriptor_ = cast(*void) sel_registerName(cast(*u8) "newSharedTextureWithDescriptor:\0");
    __selectors.newSharedTextureWithHandle_ = cast(*void) sel_registerName(cast(*u8) "newSharedTextureWithHandle:\0");
    __selectors.newTextureViewWithPixelFormat_ = cast(*void) sel_registerName(cast(*u8) "newTextureViewWithPixelFormat:\0");
    __selectors.newTextureViewWithPixelFormat_textureType_levels_slices_ = cast(*void) sel_registerName(cast(*u8) "newTextureViewWithPixelFormat:textureType:levels:slices:\0");
    __selectors.newTextureWithDescriptor_ = cast(*void) sel_registerName(cast(*u8) "newTextureWithDescriptor:\0");
    __selectors.newTextureWithDescriptor_iosurface_plane_ = cast(*void) sel_registerName(cast(*u8) "newTextureWithDescriptor:iosurface:plane:\0");
    __selectors.newTextureWithDescriptor_offset_bytesPerRow_ = cast(*void) sel_registerName(cast(*u8) "newTextureWithDescriptor:offset:bytesPerRow:\0");
    __selectors.nextDrawable = cast(*void) sel_registerName(cast(*u8) "nextDrawable\0");
    __selectors.normalizedCoordinates = cast(*void) sel_registerName(cast(*u8) "normalizedCoordinates\0");
    __selectors.notifyListener_atValue_block_ = cast(*void) sel_registerName(cast(*u8) "notifyListener:atValue:block:\0");
    __selectors.objectAtIndexedSubscript_ = cast(*void) sel_registerName(cast(*u8) "objectAtIndexedSubscript:\0");
    __selectors.offset = cast(*void) sel_registerName(cast(*u8) "offset\0");
    __selectors.optimizeContentsForCPUAccess_ = cast(*void) sel_registerName(cast(*u8) "optimizeContentsForCPUAccess:\0");
    __selectors.optimizeContentsForCPUAccess_slice_level_ = cast(*void) sel_registerName(cast(*u8) "optimizeContentsForCPUAccess:slice:level:\0");
    __selectors.optimizeContentsForGPUAccess_ = cast(*void) sel_registerName(cast(*u8) "optimizeContentsForGPUAccess:\0");
    __selectors.optimizeContentsForGPUAccess_slice_level_ = cast(*void) sel_registerName(cast(*u8) "optimizeContentsForGPUAccess:slice:level:\0");
    __selectors.optimizeIndirectCommandBuffer_withRange_ = cast(*void) sel_registerName(cast(*u8) "optimizeIndirectCommandBuffer:withRange:\0");
    __selectors.parallelRenderCommandEncoderWithDescriptor_ = cast(*void) sel_registerName(cast(*u8) "parallelRenderCommandEncoderWithDescriptor:\0");
    __selectors.parentRelativeLevel = cast(*void) sel_registerName(cast(*u8) "parentRelativeLevel\0");
    __selectors.parentRelativeSlice = cast(*void) sel_registerName(cast(*u8) "parentRelativeSlice\0");
    __selectors.parentTexture = cast(*void) sel_registerName(cast(*u8) "parentTexture\0");
    __selectors.patchControlPointCount = cast(*void) sel_registerName(cast(*u8) "patchControlPointCount\0");
    __selectors.patchType = cast(*void) sel_registerName(cast(*u8) "patchType\0");
    __selectors.pixelFormat = cast(*void) sel_registerName(cast(*u8) "pixelFormat\0");
    __selectors.pointerType = cast(*void) sel_registerName(cast(*u8) "pointerType\0");
    __selectors.popDebugGroup = cast(*void) sel_registerName(cast(*u8) "popDebugGroup\0");
    __selectors.preprocessorMacros = cast(*void) sel_registerName(cast(*u8) "preprocessorMacros\0");
    __selectors.present = cast(*void) sel_registerName(cast(*u8) "present\0");
    __selectors.presentAtTime_ = cast(*void) sel_registerName(cast(*u8) "presentAtTime:\0");
    __selectors.presentDrawable_ = cast(*void) sel_registerName(cast(*u8) "presentDrawable:\0");
    __selectors.presentDrawable_atTime_ = cast(*void) sel_registerName(cast(*u8) "presentDrawable:atTime:\0");
    __selectors.presentsWithTransaction = cast(*void) sel_registerName(cast(*u8) "presentsWithTransaction\0");
    __selectors.pushDebugGroup_ = cast(*void) sel_registerName(cast(*u8) "pushDebugGroup:\0");
    __selectors.rAddressMode = cast(*void) sel_registerName(cast(*u8) "rAddressMode\0");
    __selectors.rasterSampleCount = cast(*void) sel_registerName(cast(*u8) "rasterSampleCount\0");
    __selectors.readMask = cast(*void) sel_registerName(cast(*u8) "readMask\0");
    __selectors.readWriteTextureSupport = cast(*void) sel_registerName(cast(*u8) "readWriteTextureSupport\0");
    __selectors.recommendedMaxWorkingSetSize = cast(*void) sel_registerName(cast(*u8) "recommendedMaxWorkingSetSize\0");
    __selectors.registryID = cast(*void) sel_registerName(cast(*u8) "registryID\0");
    __selectors.removeAllDebugMarkers = cast(*void) sel_registerName(cast(*u8) "removeAllDebugMarkers\0");
    __selectors.renderCommandEncoder = cast(*void) sel_registerName(cast(*u8) "renderCommandEncoder\0");
    __selectors.renderCommandEncoderWithDescriptor_ = cast(*void) sel_registerName(cast(*u8) "renderCommandEncoderWithDescriptor:\0");
    __selectors.renderPassDescriptor = cast(*void) sel_registerName(cast(*u8) "renderPassDescriptor\0");
    __selectors.renderTargetArrayLength = cast(*void) sel_registerName(cast(*u8) "renderTargetArrayLength\0");
    __selectors.replaceRegion_mipmapLevel_slice_withBytes_bytesPerRow_bytesPerImage_ = cast(*void) sel_registerName(cast(*u8) "replaceRegion:mipmapLevel:slice:withBytes:bytesPerRow:bytesPerImage:\0");
    __selectors.replaceRegion_mipmapLevel_withBytes_bytesPerRow_ = cast(*void) sel_registerName(cast(*u8) "replaceRegion:mipmapLevel:withBytes:bytesPerRow:\0");
    __selectors.required = cast(*void) sel_registerName(cast(*u8) "required\0");
    __selectors.reset = cast(*void) sel_registerName(cast(*u8) "reset\0");
    __selectors.resetCommandsInBuffer_withRange_ = cast(*void) sel_registerName(cast(*u8) "resetCommandsInBuffer:withRange:\0");
    __selectors.resetWithRange_ = cast(*void) sel_registerName(cast(*u8) "resetWithRange:\0");
    __selectors.resolveDepthPlane = cast(*void) sel_registerName(cast(*u8) "resolveDepthPlane\0");
    __selectors.resolveLevel = cast(*void) sel_registerName(cast(*u8) "resolveLevel\0");
    __selectors.resolveSlice = cast(*void) sel_registerName(cast(*u8) "resolveSlice\0");
    __selectors.resolveTexture = cast(*void) sel_registerName(cast(*u8) "resolveTexture\0");
    __selectors.resourceOptions = cast(*void) sel_registerName(cast(*u8) "resourceOptions\0");
    __selectors.retainedReferences = cast(*void) sel_registerName(cast(*u8) "retainedReferences\0");
    __selectors.rgbBlendOperation = cast(*void) sel_registerName(cast(*u8) "rgbBlendOperation\0");
    __selectors.rootResource = cast(*void) sel_registerName(cast(*u8) "rootResource\0");
    __selectors.sAddressMode = cast(*void) sel_registerName(cast(*u8) "sAddressMode\0");
    __selectors.sampleCount = cast(*void) sel_registerName(cast(*u8) "sampleCount\0");
    __selectors.setAccess_ = cast(*void) sel_registerName(cast(*u8) "setAccess:\0");
    __selectors.setAllowGPUOptimizedContents_ = cast(*void) sel_registerName(cast(*u8) "setAllowGPUOptimizedContents:\0");
    __selectors.setAllowsNextDrawableTimeout_ = cast(*void) sel_registerName(cast(*u8) "setAllowsNextDrawableTimeout:\0");
    __selectors.setAlphaBlendOperation_ = cast(*void) sel_registerName(cast(*u8) "setAlphaBlendOperation:\0");
    __selectors.setAlphaToCoverageEnabled_ = cast(*void) sel_registerName(cast(*u8) "setAlphaToCoverageEnabled:\0");
    __selectors.setAlphaToOneEnabled_ = cast(*void) sel_registerName(cast(*u8) "setAlphaToOneEnabled:\0");
    __selectors.setArgumentBuffer_offset_ = cast(*void) sel_registerName(cast(*u8) "setArgumentBuffer:offset:\0");
    __selectors.setArgumentBuffer_startOffset_arrayElement_ = cast(*void) sel_registerName(cast(*u8) "setArgumentBuffer:startOffset:arrayElement:\0");
    __selectors.setArrayLength_ = cast(*void) sel_registerName(cast(*u8) "setArrayLength:\0");
    __selectors.setBackFaceStencil_ = cast(*void) sel_registerName(cast(*u8) "setBackFaceStencil:\0");
    __selectors.setBlendColorRed_green_blue_alpha_ = cast(*void) sel_registerName(cast(*u8) "setBlendColorRed:green:blue:alpha:\0");
    __selectors.setBlendingEnabled_ = cast(*void) sel_registerName(cast(*u8) "setBlendingEnabled:\0");
    __selectors.setBorderColor_ = cast(*void) sel_registerName(cast(*u8) "setBorderColor:\0");
    __selectors.setBufferIndex_ = cast(*void) sel_registerName(cast(*u8) "setBufferIndex:\0");
    __selectors.setBufferOffset_atIndex_ = cast(*void) sel_registerName(cast(*u8) "setBufferOffset:atIndex:\0");
    __selectors.setBuffer_offset_atIndex_ = cast(*void) sel_registerName(cast(*u8) "setBuffer:offset:atIndex:\0");
    __selectors.setBuffers_offsets_withRange_ = cast(*void) sel_registerName(cast(*u8) "setBuffers:offsets:withRange:\0");
    __selectors.setBytes_length_atIndex_ = cast(*void) sel_registerName(cast(*u8) "setBytes:length:atIndex:\0");
    __selectors.setClearColor_ = cast(*void) sel_registerName(cast(*u8) "setClearColor:\0");
    __selectors.setClearDepth_ = cast(*void) sel_registerName(cast(*u8) "setClearDepth:\0");
    __selectors.setClearStencil_ = cast(*void) sel_registerName(cast(*u8) "setClearStencil:\0");
    __selectors.setColorStoreActionOptions_atIndex_ = cast(*void) sel_registerName(cast(*u8) "setColorStoreActionOptions:atIndex:\0");
    __selectors.setColorStoreAction_atIndex_ = cast(*void) sel_registerName(cast(*u8) "setColorStoreAction:atIndex:\0");
    __selectors.setColorspace_ = cast(*void) sel_registerName(cast(*u8) "setColorspace:\0");
    __selectors.setCommandTypes_ = cast(*void) sel_registerName(cast(*u8) "setCommandTypes:\0");
    __selectors.setCompareFunction_ = cast(*void) sel_registerName(cast(*u8) "setCompareFunction:\0");
    __selectors.setComputeFunction_ = cast(*void) sel_registerName(cast(*u8) "setComputeFunction:\0");
    __selectors.setComputePipelineState_ = cast(*void) sel_registerName(cast(*u8) "setComputePipelineState:\0");
    __selectors.setConstantBlockAlignment_ = cast(*void) sel_registerName(cast(*u8) "setConstantBlockAlignment:\0");
    __selectors.setConstantValue_type_atIndex_ = cast(*void) sel_registerName(cast(*u8) "setConstantValue:type:atIndex:\0");
    __selectors.setConstantValue_type_withName_ = cast(*void) sel_registerName(cast(*u8) "setConstantValue:type:withName:\0");
    __selectors.setConstantValues_type_withRange_ = cast(*void) sel_registerName(cast(*u8) "setConstantValues:type:withRange:\0");
    __selectors.setCpuCacheMode_ = cast(*void) sel_registerName(cast(*u8) "setCpuCacheMode:\0");
    __selectors.setCullMode_ = cast(*void) sel_registerName(cast(*u8) "setCullMode:\0");
    __selectors.setDataType_ = cast(*void) sel_registerName(cast(*u8) "setDataType:\0");
    __selectors.setDefaultCaptureScope_ = cast(*void) sel_registerName(cast(*u8) "setDefaultCaptureScope:\0");
    __selectors.setDepthAttachmentPixelFormat_ = cast(*void) sel_registerName(cast(*u8) "setDepthAttachmentPixelFormat:\0");
    __selectors.setDepthAttachment_ = cast(*void) sel_registerName(cast(*u8) "setDepthAttachment:\0");
    __selectors.setDepthBias_slopeScale_clamp_ = cast(*void) sel_registerName(cast(*u8) "setDepthBias:slopeScale:clamp:\0");
    __selectors.setDepthClipMode_ = cast(*void) sel_registerName(cast(*u8) "setDepthClipMode:\0");
    __selectors.setDepthCompareFunction_ = cast(*void) sel_registerName(cast(*u8) "setDepthCompareFunction:\0");
    __selectors.setDepthFailureOperation_ = cast(*void) sel_registerName(cast(*u8) "setDepthFailureOperation:\0");
    __selectors.setDepthPlane_ = cast(*void) sel_registerName(cast(*u8) "setDepthPlane:\0");
    __selectors.setDepthResolveFilter_ = cast(*void) sel_registerName(cast(*u8) "setDepthResolveFilter:\0");
    __selectors.setDepthStencilPassOperation_ = cast(*void) sel_registerName(cast(*u8) "setDepthStencilPassOperation:\0");
    __selectors.setDepthStencilState_ = cast(*void) sel_registerName(cast(*u8) "setDepthStencilState:\0");
    __selectors.setDepthStoreActionOptions_ = cast(*void) sel_registerName(cast(*u8) "setDepthStoreActionOptions:\0");
    __selectors.setDepthStoreAction_ = cast(*void) sel_registerName(cast(*u8) "setDepthStoreAction:\0");
    __selectors.setDepthWriteEnabled_ = cast(*void) sel_registerName(cast(*u8) "setDepthWriteEnabled:\0");
    __selectors.setDepth_ = cast(*void) sel_registerName(cast(*u8) "setDepth:\0");
    __selectors.setDestinationAlphaBlendFactor_ = cast(*void) sel_registerName(cast(*u8) "setDestinationAlphaBlendFactor:\0");
    __selectors.setDestinationRGBBlendFactor_ = cast(*void) sel_registerName(cast(*u8) "setDestinationRGBBlendFactor:\0");
    __selectors.setDevice_ = cast(*void) sel_registerName(cast(*u8) "setDevice:\0");
    __selectors.setDisplaySyncEnabled_ = cast(*void) sel_registerName(cast(*u8) "setDisplaySyncEnabled:\0");
    __selectors.setDrawableSize_ = cast(*void) sel_registerName(cast(*u8) "setDrawableSize:\0");
    __selectors.setFastMathEnabled_ = cast(*void) sel_registerName(cast(*u8) "setFastMathEnabled:\0");
    __selectors.setFormat_ = cast(*void) sel_registerName(cast(*u8) "setFormat:\0");
    __selectors.setFragmentBufferOffset_atIndex_ = cast(*void) sel_registerName(cast(*u8) "setFragmentBufferOffset:atIndex:\0");
    __selectors.setFragmentBuffer_offset_atIndex_ = cast(*void) sel_registerName(cast(*u8) "setFragmentBuffer:offset:atIndex:\0");
    __selectors.setFragmentBuffers_offsets_withRange_ = cast(*void) sel_registerName(cast(*u8) "setFragmentBuffers:offsets:withRange:\0");
    __selectors.setFragmentBytes_length_atIndex_ = cast(*void) sel_registerName(cast(*u8) "setFragmentBytes:length:atIndex:\0");
    __selectors.setFragmentFunction_ = cast(*void) sel_registerName(cast(*u8) "setFragmentFunction:\0");
    __selectors.setFragmentSamplerState_atIndex_ = cast(*void) sel_registerName(cast(*u8) "setFragmentSamplerState:atIndex:\0");
    __selectors.setFragmentSamplerState_lodMinClamp_lodMaxClamp_atIndex_ = cast(*void) sel_registerName(cast(*u8) "setFragmentSamplerState:lodMinClamp:lodMaxClamp:atIndex:\0");
    __selectors.setFragmentSamplerStates_lodMinClamps_lodMaxClamps_withRange_ = cast(*void) sel_registerName(cast(*u8) "setFragmentSamplerStates:lodMinClamps:lodMaxClamps:withRange:\0");
    __selectors.setFragmentSamplerStates_withRange_ = cast(*void) sel_registerName(cast(*u8) "setFragmentSamplerStates:withRange:\0");
    __selectors.setFragmentTexture_atIndex_ = cast(*void) sel_registerName(cast(*u8) "setFragmentTexture:atIndex:\0");
    __selectors.setFragmentTextures_withRange_ = cast(*void) sel_registerName(cast(*u8) "setFragmentTextures:withRange:\0");
    __selectors.setFramebufferOnly_ = cast(*void) sel_registerName(cast(*u8) "setFramebufferOnly:\0");
    __selectors.setFrontFaceStencil_ = cast(*void) sel_registerName(cast(*u8) "setFrontFaceStencil:\0");
    __selectors.setFrontFacingWinding_ = cast(*void) sel_registerName(cast(*u8) "setFrontFacingWinding:\0");
    __selectors.setHeight_ = cast(*void) sel_registerName(cast(*u8) "setHeight:\0");
    __selectors.setIndexBufferIndex_ = cast(*void) sel_registerName(cast(*u8) "setIndexBufferIndex:\0");
    __selectors.setIndexType_ = cast(*void) sel_registerName(cast(*u8) "setIndexType:\0");
    __selectors.setIndex_ = cast(*void) sel_registerName(cast(*u8) "setIndex:\0");
    __selectors.setIndirectCommandBuffer_atIndex_ = cast(*void) sel_registerName(cast(*u8) "setIndirectCommandBuffer:atIndex:\0");
    __selectors.setIndirectCommandBuffers_withRange_ = cast(*void) sel_registerName(cast(*u8) "setIndirectCommandBuffers:withRange:\0");
    __selectors.setInheritBuffers_ = cast(*void) sel_registerName(cast(*u8) "setInheritBuffers:\0");
    __selectors.setInheritPipelineState_ = cast(*void) sel_registerName(cast(*u8) "setInheritPipelineState:\0");
    __selectors.setInputPrimitiveTopology_ = cast(*void) sel_registerName(cast(*u8) "setInputPrimitiveTopology:\0");
    __selectors.setLabel_ = cast(*void) sel_registerName(cast(*u8) "setLabel:\0");
    __selectors.setLanguageVersion_ = cast(*void) sel_registerName(cast(*u8) "setLanguageVersion:\0");
    __selectors.setLevel_ = cast(*void) sel_registerName(cast(*u8) "setLevel:\0");
    __selectors.setLoadAction_ = cast(*void) sel_registerName(cast(*u8) "setLoadAction:\0");
    __selectors.setLodAverage_ = cast(*void) sel_registerName(cast(*u8) "setLodAverage:\0");
    __selectors.setLodMaxClamp_ = cast(*void) sel_registerName(cast(*u8) "setLodMaxClamp:\0");
    __selectors.setLodMinClamp_ = cast(*void) sel_registerName(cast(*u8) "setLodMinClamp:\0");
    __selectors.setMagFilter_ = cast(*void) sel_registerName(cast(*u8) "setMagFilter:\0");
    __selectors.setMaxAnisotropy_ = cast(*void) sel_registerName(cast(*u8) "setMaxAnisotropy:\0");
    __selectors.setMaxFragmentBufferBindCount_ = cast(*void) sel_registerName(cast(*u8) "setMaxFragmentBufferBindCount:\0");
    __selectors.setMaxTessellationFactor_ = cast(*void) sel_registerName(cast(*u8) "setMaxTessellationFactor:\0");
    __selectors.setMaxTotalThreadsPerThreadgroup_ = cast(*void) sel_registerName(cast(*u8) "setMaxTotalThreadsPerThreadgroup:\0");
    __selectors.setMaxVertexBufferBindCount_ = cast(*void) sel_registerName(cast(*u8) "setMaxVertexBufferBindCount:\0");
    __selectors.setMaximumDrawableCount_ = cast(*void) sel_registerName(cast(*u8) "setMaximumDrawableCount:\0");
    __selectors.setMinFilter_ = cast(*void) sel_registerName(cast(*u8) "setMinFilter:\0");
    __selectors.setMipFilter_ = cast(*void) sel_registerName(cast(*u8) "setMipFilter:\0");
    __selectors.setMipmapLevelCount_ = cast(*void) sel_registerName(cast(*u8) "setMipmapLevelCount:\0");
    __selectors.setMutability_ = cast(*void) sel_registerName(cast(*u8) "setMutability:\0");
    __selectors.setNormalizedCoordinates_ = cast(*void) sel_registerName(cast(*u8) "setNormalizedCoordinates:\0");
    __selectors.setObject_atIndexedSubscript_ = cast(*void) sel_registerName(cast(*u8) "setObject:atIndexedSubscript:\0");
    __selectors.setOffset_ = cast(*void) sel_registerName(cast(*u8) "setOffset:\0");
    __selectors.setPixelFormat_ = cast(*void) sel_registerName(cast(*u8) "setPixelFormat:\0");
    __selectors.setPreprocessorMacros_ = cast(*void) sel_registerName(cast(*u8) "setPreprocessorMacros:\0");
    __selectors.setPresentsWithTransaction_ = cast(*void) sel_registerName(cast(*u8) "setPresentsWithTransaction:\0");
    __selectors.setPurgeableState_ = cast(*void) sel_registerName(cast(*u8) "setPurgeableState:\0");
    __selectors.setRAddressMode_ = cast(*void) sel_registerName(cast(*u8) "setRAddressMode:\0");
    __selectors.setRasterSampleCount_ = cast(*void) sel_registerName(cast(*u8) "setRasterSampleCount:\0");
    __selectors.setRasterizationEnabled_ = cast(*void) sel_registerName(cast(*u8) "setRasterizationEnabled:\0");
    __selectors.setReadMask_ = cast(*void) sel_registerName(cast(*u8) "setReadMask:\0");
    __selectors.setRenderPipelineState_ = cast(*void) sel_registerName(cast(*u8) "setRenderPipelineState:\0");
    __selectors.setRenderPipelineState_atIndex_ = cast(*void) sel_registerName(cast(*u8) "setRenderPipelineState:atIndex:\0");
    __selectors.setRenderPipelineStates_withRange_ = cast(*void) sel_registerName(cast(*u8) "setRenderPipelineStates:withRange:\0");
    __selectors.setRenderTargetArrayLength_ = cast(*void) sel_registerName(cast(*u8) "setRenderTargetArrayLength:\0");
    __selectors.setResolveDepthPlane_ = cast(*void) sel_registerName(cast(*u8) "setResolveDepthPlane:\0");
    __selectors.setResolveLevel_ = cast(*void) sel_registerName(cast(*u8) "setResolveLevel:\0");
    __selectors.setResolveSlice_ = cast(*void) sel_registerName(cast(*u8) "setResolveSlice:\0");
    __selectors.setResolveTexture_ = cast(*void) sel_registerName(cast(*u8) "setResolveTexture:\0");
    __selectors.setResourceOptions_ = cast(*void) sel_registerName(cast(*u8) "setResourceOptions:\0");
    __selectors.setRgbBlendOperation_ = cast(*void) sel_registerName(cast(*u8) "setRgbBlendOperation:\0");
    __selectors.setSAddressMode_ = cast(*void) sel_registerName(cast(*u8) "setSAddressMode:\0");
    __selectors.setSampleCount_ = cast(*void) sel_registerName(cast(*u8) "setSampleCount:\0");
    __selectors.setSamplePositions_count_ = cast(*void) sel_registerName(cast(*u8) "setSamplePositions:count:\0");
    __selectors.setSamplerState_atIndex_ = cast(*void) sel_registerName(cast(*u8) "setSamplerState:atIndex:\0");
    __selectors.setSamplerState_lodMinClamp_lodMaxClamp_atIndex_ = cast(*void) sel_registerName(cast(*u8) "setSamplerState:lodMinClamp:lodMaxClamp:atIndex:\0");
    __selectors.setSamplerStates_lodMinClamps_lodMaxClamps_withRange_ = cast(*void) sel_registerName(cast(*u8) "setSamplerStates:lodMinClamps:lodMaxClamps:withRange:\0");
    __selectors.setSamplerStates_withRange_ = cast(*void) sel_registerName(cast(*u8) "setSamplerStates:withRange:\0");
    __selectors.setScissorRect_ = cast(*void) sel_registerName(cast(*u8) "setScissorRect:\0");
    __selectors.setScissorRects_count_ = cast(*void) sel_registerName(cast(*u8) "setScissorRects:count:\0");
    __selectors.setSignaledValue_ = cast(*void) sel_registerName(cast(*u8) "setSignaledValue:\0");
    __selectors.setSize_ = cast(*void) sel_registerName(cast(*u8) "setSize:\0");
    __selectors.setSlice_ = cast(*void) sel_registerName(cast(*u8) "setSlice:\0");
    __selectors.setSourceAlphaBlendFactor_ = cast(*void) sel_registerName(cast(*u8) "setSourceAlphaBlendFactor:\0");
    __selectors.setSourceRGBBlendFactor_ = cast(*void) sel_registerName(cast(*u8) "setSourceRGBBlendFactor:\0");
    __selectors.setStageInRegionWithIndirectBuffer_indirectBufferOffset_ = cast(*void) sel_registerName(cast(*u8) "setStageInRegionWithIndirectBuffer:indirectBufferOffset:\0");
    __selectors.setStageInRegion_ = cast(*void) sel_registerName(cast(*u8) "setStageInRegion:\0");
    __selectors.setStageInputDescriptor_ = cast(*void) sel_registerName(cast(*u8) "setStageInputDescriptor:\0");
    __selectors.setStencilAttachmentPixelFormat_ = cast(*void) sel_registerName(cast(*u8) "setStencilAttachmentPixelFormat:\0");
    __selectors.setStencilAttachment_ = cast(*void) sel_registerName(cast(*u8) "setStencilAttachment:\0");
    __selectors.setStencilCompareFunction_ = cast(*void) sel_registerName(cast(*u8) "setStencilCompareFunction:\0");
    __selectors.setStencilFailureOperation_ = cast(*void) sel_registerName(cast(*u8) "setStencilFailureOperation:\0");
    __selectors.setStencilFrontReferenceValue_backReferenceValue_ = cast(*void) sel_registerName(cast(*u8) "setStencilFrontReferenceValue:backReferenceValue:\0");
    __selectors.setStencilReferenceValue_ = cast(*void) sel_registerName(cast(*u8) "setStencilReferenceValue:\0");
    __selectors.setStencilResolveFilter_ = cast(*void) sel_registerName(cast(*u8) "setStencilResolveFilter:\0");
    __selectors.setStencilStoreActionOptions_ = cast(*void) sel_registerName(cast(*u8) "setStencilStoreActionOptions:\0");
    __selectors.setStencilStoreAction_ = cast(*void) sel_registerName(cast(*u8) "setStencilStoreAction:\0");
    __selectors.setStepFunction_ = cast(*void) sel_registerName(cast(*u8) "setStepFunction:\0");
    __selectors.setStepRate_ = cast(*void) sel_registerName(cast(*u8) "setStepRate:\0");
    __selectors.setStorageMode_ = cast(*void) sel_registerName(cast(*u8) "setStorageMode:\0");
    __selectors.setStoreActionOptions_ = cast(*void) sel_registerName(cast(*u8) "setStoreActionOptions:\0");
    __selectors.setStoreAction_ = cast(*void) sel_registerName(cast(*u8) "setStoreAction:\0");
    __selectors.setStride_ = cast(*void) sel_registerName(cast(*u8) "setStride:\0");
    __selectors.setSupportArgumentBuffers_ = cast(*void) sel_registerName(cast(*u8) "setSupportArgumentBuffers:\0");
    __selectors.setSupportIndirectCommandBuffers_ = cast(*void) sel_registerName(cast(*u8) "setSupportIndirectCommandBuffers:\0");
    __selectors.setTAddressMode_ = cast(*void) sel_registerName(cast(*u8) "setTAddressMode:\0");
    __selectors.setTessellationControlPointIndexType_ = cast(*void) sel_registerName(cast(*u8) "setTessellationControlPointIndexType:\0");
    __selectors.setTessellationFactorBuffer_offset_instanceStride_ = cast(*void) sel_registerName(cast(*u8) "setTessellationFactorBuffer:offset:instanceStride:\0");
    __selectors.setTessellationFactorFormat_ = cast(*void) sel_registerName(cast(*u8) "setTessellationFactorFormat:\0");
    __selectors.setTessellationFactorScaleEnabled_ = cast(*void) sel_registerName(cast(*u8) "setTessellationFactorScaleEnabled:\0");
    __selectors.setTessellationFactorScale_ = cast(*void) sel_registerName(cast(*u8) "setTessellationFactorScale:\0");
    __selectors.setTessellationFactorStepFunction_ = cast(*void) sel_registerName(cast(*u8) "setTessellationFactorStepFunction:\0");
    __selectors.setTessellationOutputWindingOrder_ = cast(*void) sel_registerName(cast(*u8) "setTessellationOutputWindingOrder:\0");
    __selectors.setTessellationPartitionMode_ = cast(*void) sel_registerName(cast(*u8) "setTessellationPartitionMode:\0");
    __selectors.setTextureType_ = cast(*void) sel_registerName(cast(*u8) "setTextureType:\0");
    __selectors.setTexture_ = cast(*void) sel_registerName(cast(*u8) "setTexture:\0");
    __selectors.setTexture_atIndex_ = cast(*void) sel_registerName(cast(*u8) "setTexture:atIndex:\0");
    __selectors.setTextures_withRange_ = cast(*void) sel_registerName(cast(*u8) "setTextures:withRange:\0");
    __selectors.setThreadGroupSizeIsMultipleOfThreadExecutionWidth_ = cast(*void) sel_registerName(cast(*u8) "setThreadGroupSizeIsMultipleOfThreadExecutionWidth:\0");
    __selectors.setThreadgroupMemoryLength_atIndex_ = cast(*void) sel_registerName(cast(*u8) "setThreadgroupMemoryLength:atIndex:\0");
    __selectors.setTriangleFillMode_ = cast(*void) sel_registerName(cast(*u8) "setTriangleFillMode:\0");
    __selectors.setUsage_ = cast(*void) sel_registerName(cast(*u8) "setUsage:\0");
    __selectors.setVertexBufferOffset_atIndex_ = cast(*void) sel_registerName(cast(*u8) "setVertexBufferOffset:atIndex:\0");
    __selectors.setVertexBuffer_offset_atIndex_ = cast(*void) sel_registerName(cast(*u8) "setVertexBuffer:offset:atIndex:\0");
    __selectors.setVertexBuffers_offsets_withRange_ = cast(*void) sel_registerName(cast(*u8) "setVertexBuffers:offsets:withRange:\0");
    __selectors.setVertexBytes_length_atIndex_ = cast(*void) sel_registerName(cast(*u8) "setVertexBytes:length:atIndex:\0");
    __selectors.setVertexDescriptor_ = cast(*void) sel_registerName(cast(*u8) "setVertexDescriptor:\0");
    __selectors.setVertexFunction_ = cast(*void) sel_registerName(cast(*u8) "setVertexFunction:\0");
    __selectors.setVertexSamplerState_atIndex_ = cast(*void) sel_registerName(cast(*u8) "setVertexSamplerState:atIndex:\0");
    __selectors.setVertexSamplerState_lodMinClamp_lodMaxClamp_atIndex_ = cast(*void) sel_registerName(cast(*u8) "setVertexSamplerState:lodMinClamp:lodMaxClamp:atIndex:\0");
    __selectors.setVertexSamplerStates_lodMinClamps_lodMaxClamps_withRange_ = cast(*void) sel_registerName(cast(*u8) "setVertexSamplerStates:lodMinClamps:lodMaxClamps:withRange:\0");
    __selectors.setVertexSamplerStates_withRange_ = cast(*void) sel_registerName(cast(*u8) "setVertexSamplerStates:withRange:\0");
    __selectors.setVertexTexture_atIndex_ = cast(*void) sel_registerName(cast(*u8) "setVertexTexture:atIndex:\0");
    __selectors.setVertexTextures_withRange_ = cast(*void) sel_registerName(cast(*u8) "setVertexTextures:withRange:\0");
    __selectors.setViewport_ = cast(*void) sel_registerName(cast(*u8) "setViewport:\0");
    __selectors.setViewports_count_ = cast(*void) sel_registerName(cast(*u8) "setViewports:count:\0");
    __selectors.setVisibilityResultBuffer_ = cast(*void) sel_registerName(cast(*u8) "setVisibilityResultBuffer:\0");
    __selectors.setVisibilityResultMode_offset_ = cast(*void) sel_registerName(cast(*u8) "setVisibilityResultMode:offset:\0");
    __selectors.setWantsExtendedDynamicRangeContent_ = cast(*void) sel_registerName(cast(*u8) "setWantsExtendedDynamicRangeContent:\0");
    __selectors.setWidth_ = cast(*void) sel_registerName(cast(*u8) "setWidth:\0");
    __selectors.setWriteMask_ = cast(*void) sel_registerName(cast(*u8) "setWriteMask:\0");
    __selectors.sharedCaptureManager = cast(*void) sel_registerName(cast(*u8) "sharedCaptureManager\0");
    __selectors.signaledValue = cast(*void) sel_registerName(cast(*u8) "signaledValue\0");
    __selectors.size = cast(*void) sel_registerName(cast(*u8) "size\0");
    __selectors.slice = cast(*void) sel_registerName(cast(*u8) "slice\0");
    __selectors.sourceAlphaBlendFactor = cast(*void) sel_registerName(cast(*u8) "sourceAlphaBlendFactor\0");
    __selectors.sourceRGBBlendFactor = cast(*void) sel_registerName(cast(*u8) "sourceRGBBlendFactor\0");
    __selectors.stageInputAttributes = cast(*void) sel_registerName(cast(*u8) "stageInputAttributes\0");
    __selectors.stageInputDescriptor = cast(*void) sel_registerName(cast(*u8) "stageInputDescriptor\0");
    __selectors.stageInputOutputDescriptor = cast(*void) sel_registerName(cast(*u8) "stageInputOutputDescriptor\0");
    __selectors.startCaptureWithCommandQueue_ = cast(*void) sel_registerName(cast(*u8) "startCaptureWithCommandQueue:\0");
    __selectors.startCaptureWithDevice_ = cast(*void) sel_registerName(cast(*u8) "startCaptureWithDevice:\0");
    __selectors.startCaptureWithScope_ = cast(*void) sel_registerName(cast(*u8) "startCaptureWithScope:\0");
    __selectors.staticThreadgroupMemoryLength = cast(*void) sel_registerName(cast(*u8) "staticThreadgroupMemoryLength\0");
    __selectors.status = cast(*void) sel_registerName(cast(*u8) "status\0");
    __selectors.stencilAttachment = cast(*void) sel_registerName(cast(*u8) "stencilAttachment\0");
    __selectors.stencilAttachmentPixelFormat = cast(*void) sel_registerName(cast(*u8) "stencilAttachmentPixelFormat\0");
    __selectors.stencilCompareFunction = cast(*void) sel_registerName(cast(*u8) "stencilCompareFunction\0");
    __selectors.stencilFailureOperation = cast(*void) sel_registerName(cast(*u8) "stencilFailureOperation\0");
    __selectors.stencilResolveFilter = cast(*void) sel_registerName(cast(*u8) "stencilResolveFilter\0");
    __selectors.stepFunction = cast(*void) sel_registerName(cast(*u8) "stepFunction\0");
    __selectors.stepRate = cast(*void) sel_registerName(cast(*u8) "stepRate\0");
    __selectors.stopCapture = cast(*void) sel_registerName(cast(*u8) "stopCapture\0");
    __selectors.storageMode = cast(*void) sel_registerName(cast(*u8) "storageMode\0");
    __selectors.storeAction = cast(*void) sel_registerName(cast(*u8) "storeAction\0");
    __selectors.storeActionOptions = cast(*void) sel_registerName(cast(*u8) "storeActionOptions\0");
    __selectors.stride = cast(*void) sel_registerName(cast(*u8) "stride\0");
    __selectors.structType = cast(*void) sel_registerName(cast(*u8) "structType\0");
    __selectors.supportArgumentBuffers = cast(*void) sel_registerName(cast(*u8) "supportArgumentBuffers\0");
    __selectors.supportIndirectCommandBuffers = cast(*void) sel_registerName(cast(*u8) "supportIndirectCommandBuffers\0");
    __selectors.supportsFeatureSet_ = cast(*void) sel_registerName(cast(*u8) "supportsFeatureSet:\0");
    __selectors.supportsTextureSampleCount_ = cast(*void) sel_registerName(cast(*u8) "supportsTextureSampleCount:\0");
    __selectors.synchronizeResource_ = cast(*void) sel_registerName(cast(*u8) "synchronizeResource:\0");
    __selectors.synchronizeTexture_slice_level_ = cast(*void) sel_registerName(cast(*u8) "synchronizeTexture:slice:level:\0");
    __selectors.tAddressMode = cast(*void) sel_registerName(cast(*u8) "tAddressMode\0");
    __selectors.tessellationControlPointIndexType = cast(*void) sel_registerName(cast(*u8) "tessellationControlPointIndexType\0");
    __selectors.tessellationFactorFormat = cast(*void) sel_registerName(cast(*u8) "tessellationFactorFormat\0");
    __selectors.tessellationFactorStepFunction = cast(*void) sel_registerName(cast(*u8) "tessellationFactorStepFunction\0");
    __selectors.tessellationOutputWindingOrder = cast(*void) sel_registerName(cast(*u8) "tessellationOutputWindingOrder\0");
    __selectors.tessellationPartitionMode = cast(*void) sel_registerName(cast(*u8) "tessellationPartitionMode\0");
    __selectors.texture = cast(*void) sel_registerName(cast(*u8) "texture\0");
    __selectors.texture2DDescriptorWithPixelFormat_width_height_mipmapped_ = cast(*void) sel_registerName(cast(*u8) "texture2DDescriptorWithPixelFormat:width:height:mipmapped:\0");
    __selectors.textureBarrier = cast(*void) sel_registerName(cast(*u8) "textureBarrier\0");
    __selectors.textureBufferDescriptorWithPixelFormat_width_resourceOptions_usage_ = cast(*void) sel_registerName(cast(*u8) "textureBufferDescriptorWithPixelFormat:width:resourceOptions:usage:\0");
    __selectors.textureCubeDescriptorWithPixelFormat_size_mipmapped_ = cast(*void) sel_registerName(cast(*u8) "textureCubeDescriptorWithPixelFormat:size:mipmapped:\0");
    __selectors.textureDataType = cast(*void) sel_registerName(cast(*u8) "textureDataType\0");
    __selectors.textureReferenceType = cast(*void) sel_registerName(cast(*u8) "textureReferenceType\0");
    __selectors.textureType = cast(*void) sel_registerName(cast(*u8) "textureType\0");
    __selectors.threadExecutionWidth = cast(*void) sel_registerName(cast(*u8) "threadExecutionWidth\0");
    __selectors.threadGroupSizeIsMultipleOfThreadExecutionWidth = cast(*void) sel_registerName(cast(*u8) "threadGroupSizeIsMultipleOfThreadExecutionWidth\0");
    __selectors.threadgroupMemoryAlignment = cast(*void) sel_registerName(cast(*u8) "threadgroupMemoryAlignment\0");
    __selectors.threadgroupMemoryDataSize = cast(*void) sel_registerName(cast(*u8) "threadgroupMemoryDataSize\0");
    __selectors.type = cast(*void) sel_registerName(cast(*u8) "type\0");
    __selectors.updateFence_ = cast(*void) sel_registerName(cast(*u8) "updateFence:\0");
    __selectors.updateFence_afterStages_ = cast(*void) sel_registerName(cast(*u8) "updateFence:afterStages:\0");
    __selectors.usage = cast(*void) sel_registerName(cast(*u8) "usage\0");
    __selectors.useHeap_ = cast(*void) sel_registerName(cast(*u8) "useHeap:\0");
    __selectors.useHeaps_count_ = cast(*void) sel_registerName(cast(*u8) "useHeaps:count:\0");
    __selectors.useResource_usage_ = cast(*void) sel_registerName(cast(*u8) "useResource:usage:\0");
    __selectors.useResources_count_usage_ = cast(*void) sel_registerName(cast(*u8) "useResources:count:usage:\0");
    __selectors.usedSize = cast(*void) sel_registerName(cast(*u8) "usedSize\0");
    __selectors.vertexArguments = cast(*void) sel_registerName(cast(*u8) "vertexArguments\0");
    __selectors.vertexAttributes = cast(*void) sel_registerName(cast(*u8) "vertexAttributes\0");
    __selectors.vertexBuffers = cast(*void) sel_registerName(cast(*u8) "vertexBuffers\0");
    __selectors.vertexDescriptor = cast(*void) sel_registerName(cast(*u8) "vertexDescriptor\0");
    __selectors.vertexFunction = cast(*void) sel_registerName(cast(*u8) "vertexFunction\0");
    __selectors.visibilityResultBuffer = cast(*void) sel_registerName(cast(*u8) "visibilityResultBuffer\0");
    __selectors.waitForFence_ = cast(*void) sel_registerName(cast(*u8) "waitForFence:\0");
    __selectors.waitForFence_beforeStages_ = cast(*void) sel_registerName(cast(*u8) "waitForFence:beforeStages:\0");
    __selectors.waitUntilCompleted = cast(*void) sel_registerName(cast(*u8) "waitUntilCompleted\0");
    __selectors.waitUntilScheduled = cast(*void) sel_registerName(cast(*u8) "waitUntilScheduled\0");
    __selectors.wantsExtendedDynamicRangeContent = cast(*void) sel_registerName(cast(*u8) "wantsExtendedDynamicRangeContent\0");
    __selectors.width = cast(*void) sel_registerName(cast(*u8) "width\0");
    __selectors.writeMask = cast(*void) sel_registerName(cast(*u8) "writeMask\0");
}
#scope_module
#import "Basic";
#import "Objective_C";
CGColorSpaceRef :: *void;
IOSurfaceRef :: *void;
#scope_file
uint32_t :: u32;
uint64_t :: u64;
uint16_t :: u16;
uint8_t :: u8;
int32_t :: s32;
#scope_export
CAMetalDrawable :: struct {
    texture :: (self: *CAMetalDrawable) -> id {
        invoke: (receiver: *CAMetalDrawable, selector: SEL) -> id #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "texture\0"));
    }
    layer :: (self: *CAMetalDrawable) -> *CAMetalLayer {
        invoke: (receiver: *CAMetalDrawable, selector: SEL) -> *CAMetalLayer #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "layer\0"));
    }
}
CAMetalLayer :: struct {
    using calayer: CALayer;
    _priv: *_CAMetalLayerPrivate;
    nextDrawable :: (self: *CAMetalLayer) -> *CAMetalDrawable {
        invoke: (receiver: *CAMetalLayer, selector: SEL) -> *CAMetalDrawable #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "nextDrawable\0"));
    }
    device :: (self: *CAMetalLayer) -> *MTLDevice {
        invoke: (receiver: *CAMetalLayer, selector: SEL) -> *MTLDevice #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "device\0"));
    }
    setDevice :: (self: *CAMetalLayer, device: *MTLDevice) -> () {
        invoke: (receiver: *CAMetalLayer, selector: SEL, device: *MTLDevice) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setDevice:\0"), device);
    }
    pixelFormat :: (self: *CAMetalLayer) -> MTLPixelFormat {
        invoke: (receiver: *CAMetalLayer, selector: SEL) -> MTLPixelFormat #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "pixelFormat\0"));
    }
    setPixelFormat :: (self: *CAMetalLayer, pixelFormat: MTLPixelFormat) -> () {
        invoke: (receiver: *CAMetalLayer, selector: SEL, pixelFormat: MTLPixelFormat) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setPixelFormat:\0"), pixelFormat);
    }
    framebufferOnly :: (self: *CAMetalLayer) -> BOOL {
        invoke: (receiver: *CAMetalLayer, selector: SEL) -> BOOL #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "framebufferOnly\0"));
    }
    setFramebufferOnly :: (self: *CAMetalLayer, framebufferOnly: BOOL) -> () {
        invoke: (receiver: *CAMetalLayer, selector: SEL, framebufferOnly: BOOL) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setFramebufferOnly:\0"), framebufferOnly);
    }
    drawableSize :: (self: *CAMetalLayer) -> CGSize {
        invoke: (receiver: *CAMetalLayer, selector: SEL) -> CGSize #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "drawableSize\0"));
    }
    setDrawableSize :: (self: *CAMetalLayer, drawableSize: CGSize) -> () {
        invoke: (receiver: *CAMetalLayer, selector: SEL, drawableSize: CGSize) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setDrawableSize:\0"), drawableSize);
    }
    maximumDrawableCount :: (self: *CAMetalLayer) -> NSUInteger {
        invoke: (receiver: *CAMetalLayer, selector: SEL) -> NSUInteger #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "maximumDrawableCount\0"));
    }
    setMaximumDrawableCount :: (self: *CAMetalLayer, maximumDrawableCount: NSUInteger) -> () {
        invoke: (receiver: *CAMetalLayer, selector: SEL, maximumDrawableCount: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setMaximumDrawableCount:\0"), maximumDrawableCount);
    }
    presentsWithTransaction :: (self: *CAMetalLayer) -> BOOL {
        invoke: (receiver: *CAMetalLayer, selector: SEL) -> BOOL #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "presentsWithTransaction\0"));
    }
    setPresentsWithTransaction :: (self: *CAMetalLayer, presentsWithTransaction: BOOL) -> () {
        invoke: (receiver: *CAMetalLayer, selector: SEL, presentsWithTransaction: BOOL) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setPresentsWithTransaction:\0"), presentsWithTransaction);
    }
    colorspace :: (self: *CAMetalLayer) -> CGColorSpaceRef {
        invoke: (receiver: *CAMetalLayer, selector: SEL) -> CGColorSpaceRef #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "colorspace\0"));
    }
    setColorspace :: (self: *CAMetalLayer, colorspace: CGColorSpaceRef) -> () {
        invoke: (receiver: *CAMetalLayer, selector: SEL, colorspace: CGColorSpaceRef) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setColorspace:\0"), colorspace);
    }
    wantsExtendedDynamicRangeContent :: (self: *CAMetalLayer) -> BOOL {
        invoke: (receiver: *CAMetalLayer, selector: SEL) -> BOOL #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "wantsExtendedDynamicRangeContent\0"));
    }
    setWantsExtendedDynamicRangeContent :: (self: *CAMetalLayer, wantsExtendedDynamicRangeContent: BOOL) -> () {
        invoke: (receiver: *CAMetalLayer, selector: SEL, wantsExtendedDynamicRangeContent: BOOL) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setWantsExtendedDynamicRangeContent:\0"), wantsExtendedDynamicRangeContent);
    }
    displaySyncEnabled :: (self: *CAMetalLayer) -> BOOL {
        invoke: (receiver: *CAMetalLayer, selector: SEL) -> BOOL #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "displaySyncEnabled\0"));
    }
    setDisplaySyncEnabled :: (self: *CAMetalLayer, displaySyncEnabled: BOOL) -> () {
        invoke: (receiver: *CAMetalLayer, selector: SEL, displaySyncEnabled: BOOL) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setDisplaySyncEnabled:\0"), displaySyncEnabled);
    }
    allowsNextDrawableTimeout :: (self: *CAMetalLayer) -> BOOL {
        invoke: (receiver: *CAMetalLayer, selector: SEL) -> BOOL #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "allowsNextDrawableTimeout\0"));
    }
    setAllowsNextDrawableTimeout :: (self: *CAMetalLayer, allowsNextDrawableTimeout: BOOL) -> () {
        invoke: (receiver: *CAMetalLayer, selector: SEL, allowsNextDrawableTimeout: BOOL) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setAllowsNextDrawableTimeout:\0"), allowsNextDrawableTimeout);
    }
}
_CAMetalLayerPrivate :: struct {}
MTLOrigin :: struct {
    x: NSUInteger;
    y: NSUInteger;
    z: NSUInteger;
}
MTLOriginMake :: (x: NSUInteger, y: NSUInteger, z: NSUInteger) -> MTLOrigin {
    result: MTLOrigin;
    result.x = x;
    result.y = y;
    result.z = z;
    return result;
}
MTLSize :: struct {
    width: NSUInteger;
    height: NSUInteger;
    depth: NSUInteger;
}
MTLSizeMake :: (width: NSUInteger, height: NSUInteger, depth: NSUInteger) -> MTLSize {
    result: MTLSize;
    result.width = width;
    result.height = height;
    result.depth = depth;
    return result;
}
MTLRegion :: struct {
    origin: MTLOrigin;
    size: MTLSize;
}
MTLRegionMake1D :: (x: NSUInteger, width: NSUInteger) -> MTLRegion {
    result: MTLRegion;
    result.origin = MTLOriginMake(x, 0, 0);
    result.size = MTLSizeMake(width, 1, 1);
    return result;
}
MTLRegionMake2D :: (x: NSUInteger, y: NSUInteger, width: NSUInteger, height: NSUInteger) -> MTLRegion {
    result: MTLRegion;
    result.origin = MTLOriginMake(x, y, 0);
    result.size = MTLSizeMake(width, height, 1);
    return result;
}
MTLRegionMake3D :: (x: NSUInteger, y: NSUInteger, z: NSUInteger, width: NSUInteger, height: NSUInteger, depth: NSUInteger) -> MTLRegion {
    result: MTLRegion;
    result.origin = MTLOriginMake(x, y, z);
    result.size = MTLSizeMake(width, height, depth);
    return result;
}
MTLSamplePosition :: struct {
    x: float32;
    y: float32;
}
MTLSamplePositionMake :: (x: float, y: float) -> MTLSamplePosition {
    result: MTLSamplePosition;
    result.x = x;
    result.y = y;
    return result;
}
using MTLResourceUsage :: enum NSUInteger {
    MTLResourceUsageRead :: 1;
    MTLResourceUsageWrite :: 2;
    MTLResourceUsageSample :: 4;
}
using MTLBarrierScope :: enum NSUInteger {
    MTLBarrierScopeBuffers :: 1;
    MTLBarrierScopeTextures :: 2;
    MTLBarrierScopeRenderTargets :: 4;
}
MTLCommandEncoder :: struct {
    endEncoding :: (self: *MTLCommandEncoder) -> () {
        invoke: (receiver: *MTLCommandEncoder, selector: SEL) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "endEncoding\0"));
    }
    insertDebugSignpost :: (self: *MTLCommandEncoder, _string: *NSString) -> () {
        invoke: (receiver: *MTLCommandEncoder, selector: SEL, _string: *NSString) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "insertDebugSignpost:\0"), _string);
    }
    pushDebugGroup :: (self: *MTLCommandEncoder, _string: *NSString) -> () {
        invoke: (receiver: *MTLCommandEncoder, selector: SEL, _string: *NSString) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "pushDebugGroup:\0"), _string);
    }
    popDebugGroup :: (self: *MTLCommandEncoder) -> () {
        invoke: (receiver: *MTLCommandEncoder, selector: SEL) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "popDebugGroup\0"));
    }
    device :: (self: *MTLCommandEncoder) -> id {
        invoke: (receiver: *MTLCommandEncoder, selector: SEL) -> id #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "device\0"));
    }
    label :: (self: *MTLCommandEncoder) -> *NSString {
        invoke: (receiver: *MTLCommandEncoder, selector: SEL) -> *NSString #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "label\0"));
    }
    setLabel :: (self: *MTLCommandEncoder, label: *NSString) -> () {
        invoke: (receiver: *MTLCommandEncoder, selector: SEL, label: *NSString) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setLabel:\0"), label);
    }
}
using MTLPixelFormat :: enum NSUInteger {
    MTLPixelFormatInvalid :: 0;
    MTLPixelFormatA8Unorm :: 1;
    MTLPixelFormatR8Unorm :: 10;
    MTLPixelFormatR8Unorm_sRGB :: 11;
    MTLPixelFormatR8Snorm :: 12;
    MTLPixelFormatR8Uint :: 13;
    MTLPixelFormatR8Sint :: 14;
    MTLPixelFormatR16Unorm :: 20;
    MTLPixelFormatR16Snorm :: 22;
    MTLPixelFormatR16Uint :: 23;
    MTLPixelFormatR16Sint :: 24;
    MTLPixelFormatR16Float :: 25;
    MTLPixelFormatRG8Unorm :: 30;
    MTLPixelFormatRG8Unorm_sRGB :: 31;
    MTLPixelFormatRG8Snorm :: 32;
    MTLPixelFormatRG8Uint :: 33;
    MTLPixelFormatRG8Sint :: 34;
    MTLPixelFormatB5G6R5Unorm :: 40;
    MTLPixelFormatA1BGR5Unorm :: 41;
    MTLPixelFormatABGR4Unorm :: 42;
    MTLPixelFormatBGR5A1Unorm :: 43;
    MTLPixelFormatR32Uint :: 53;
    MTLPixelFormatR32Sint :: 54;
    MTLPixelFormatR32Float :: 55;
    MTLPixelFormatRG16Unorm :: 60;
    MTLPixelFormatRG16Snorm :: 62;
    MTLPixelFormatRG16Uint :: 63;
    MTLPixelFormatRG16Sint :: 64;
    MTLPixelFormatRG16Float :: 65;
    MTLPixelFormatRGBA8Unorm :: 70;
    MTLPixelFormatRGBA8Unorm_sRGB :: 71;
    MTLPixelFormatRGBA8Snorm :: 72;
    MTLPixelFormatRGBA8Uint :: 73;
    MTLPixelFormatRGBA8Sint :: 74;
    MTLPixelFormatBGRA8Unorm :: 80;
    MTLPixelFormatBGRA8Unorm_sRGB :: 81;
    MTLPixelFormatRGB10A2Unorm :: 90;
    MTLPixelFormatRGB10A2Uint :: 91;
    MTLPixelFormatRG11B10Float :: 92;
    MTLPixelFormatRGB9E5Float :: 93;
    MTLPixelFormatBGR10A2Unorm :: 94;
    MTLPixelFormatBGR10_XR :: 554;
    MTLPixelFormatBGR10_XR_sRGB :: 555;
    MTLPixelFormatRG32Uint :: 103;
    MTLPixelFormatRG32Sint :: 104;
    MTLPixelFormatRG32Float :: 105;
    MTLPixelFormatRGBA16Unorm :: 110;
    MTLPixelFormatRGBA16Snorm :: 112;
    MTLPixelFormatRGBA16Uint :: 113;
    MTLPixelFormatRGBA16Sint :: 114;
    MTLPixelFormatRGBA16Float :: 115;
    MTLPixelFormatBGRA10_XR :: 552;
    MTLPixelFormatBGRA10_XR_sRGB :: 553;
    MTLPixelFormatRGBA32Uint :: 123;
    MTLPixelFormatRGBA32Sint :: 124;
    MTLPixelFormatRGBA32Float :: 125;
    MTLPixelFormatBC1_RGBA :: 130;
    MTLPixelFormatBC1_RGBA_sRGB :: 131;
    MTLPixelFormatBC2_RGBA :: 132;
    MTLPixelFormatBC2_RGBA_sRGB :: 133;
    MTLPixelFormatBC3_RGBA :: 134;
    MTLPixelFormatBC3_RGBA_sRGB :: 135;
    MTLPixelFormatBC4_RUnorm :: 140;
    MTLPixelFormatBC4_RSnorm :: 141;
    MTLPixelFormatBC5_RGUnorm :: 142;
    MTLPixelFormatBC5_RGSnorm :: 143;
    MTLPixelFormatBC6H_RGBFloat :: 150;
    MTLPixelFormatBC6H_RGBUfloat :: 151;
    MTLPixelFormatBC7_RGBAUnorm :: 152;
    MTLPixelFormatBC7_RGBAUnorm_sRGB :: 153;
    MTLPixelFormatPVRTC_RGB_2BPP :: 160;
    MTLPixelFormatPVRTC_RGB_2BPP_sRGB :: 161;
    MTLPixelFormatPVRTC_RGB_4BPP :: 162;
    MTLPixelFormatPVRTC_RGB_4BPP_sRGB :: 163;
    MTLPixelFormatPVRTC_RGBA_2BPP :: 164;
    MTLPixelFormatPVRTC_RGBA_2BPP_sRGB :: 165;
    MTLPixelFormatPVRTC_RGBA_4BPP :: 166;
    MTLPixelFormatPVRTC_RGBA_4BPP_sRGB :: 167;
    MTLPixelFormatEAC_R11Unorm :: 170;
    MTLPixelFormatEAC_R11Snorm :: 172;
    MTLPixelFormatEAC_RG11Unorm :: 174;
    MTLPixelFormatEAC_RG11Snorm :: 176;
    MTLPixelFormatEAC_RGBA8 :: 178;
    MTLPixelFormatEAC_RGBA8_sRGB :: 179;
    MTLPixelFormatETC2_RGB8 :: 180;
    MTLPixelFormatETC2_RGB8_sRGB :: 181;
    MTLPixelFormatETC2_RGB8A1 :: 182;
    MTLPixelFormatETC2_RGB8A1_sRGB :: 183;
    MTLPixelFormatASTC_4x4_sRGB :: 186;
    MTLPixelFormatASTC_5x4_sRGB :: 187;
    MTLPixelFormatASTC_5x5_sRGB :: 188;
    MTLPixelFormatASTC_6x5_sRGB :: 189;
    MTLPixelFormatASTC_6x6_sRGB :: 190;
    MTLPixelFormatASTC_8x5_sRGB :: 192;
    MTLPixelFormatASTC_8x6_sRGB :: 193;
    MTLPixelFormatASTC_8x8_sRGB :: 194;
    MTLPixelFormatASTC_10x5_sRGB :: 195;
    MTLPixelFormatASTC_10x6_sRGB :: 196;
    MTLPixelFormatASTC_10x8_sRGB :: 197;
    MTLPixelFormatASTC_10x10_sRGB :: 198;
    MTLPixelFormatASTC_12x10_sRGB :: 199;
    MTLPixelFormatASTC_12x12_sRGB :: 200;
    MTLPixelFormatASTC_4x4_LDR :: 204;
    MTLPixelFormatASTC_5x4_LDR :: 205;
    MTLPixelFormatASTC_5x5_LDR :: 206;
    MTLPixelFormatASTC_6x5_LDR :: 207;
    MTLPixelFormatASTC_6x6_LDR :: 208;
    MTLPixelFormatASTC_8x5_LDR :: 210;
    MTLPixelFormatASTC_8x6_LDR :: 211;
    MTLPixelFormatASTC_8x8_LDR :: 212;
    MTLPixelFormatASTC_10x5_LDR :: 213;
    MTLPixelFormatASTC_10x6_LDR :: 214;
    MTLPixelFormatASTC_10x8_LDR :: 215;
    MTLPixelFormatASTC_10x10_LDR :: 216;
    MTLPixelFormatASTC_12x10_LDR :: 217;
    MTLPixelFormatASTC_12x12_LDR :: 218;
    MTLPixelFormatGBGR422 :: 240;
    MTLPixelFormatBGRG422 :: 241;
    MTLPixelFormatDepth16Unorm :: 250;
    MTLPixelFormatDepth32Float :: 252;
    MTLPixelFormatStencil8 :: 253;
    MTLPixelFormatDepth24Unorm_Stencil8 :: 255;
    MTLPixelFormatDepth32Float_Stencil8 :: 260;
    MTLPixelFormatX32_Stencil8 :: 261;
    MTLPixelFormatX24_Stencil8 :: 262;
}
using MTLPurgeableState :: enum NSUInteger {
    MTLPurgeableStateKeepCurrent :: 1;
    MTLPurgeableStateNonVolatile :: 2;
    MTLPurgeableStateVolatile :: 3;
    MTLPurgeableStateEmpty :: 4;
}
using MTLCPUCacheMode :: enum NSUInteger {
    MTLCPUCacheModeDefaultCache :: 0;
    MTLCPUCacheModeWriteCombined :: 1;
}
using MTLStorageMode :: enum NSUInteger {
    MTLStorageModeShared :: 0;
    MTLStorageModeManaged :: 1;
    MTLStorageModePrivate :: 2;
    MTLStorageModeMemoryless :: 3;
}
using MTLResourceOptions :: enum NSUInteger {
    MTLResourceCPUCacheModeDefaultCache :: 0;
    MTLResourceCPUCacheModeWriteCombined :: 1;
    MTLResourceStorageModeShared :: 0;
    MTLResourceStorageModeManaged :: 16;
    MTLResourceStorageModePrivate :: 32;
    MTLResourceStorageModeMemoryless :: 48;
    MTLResourceHazardTrackingModeUntracked :: 256;
    MTLResourceOptionCPUCacheModeDefault :: 0;
    MTLResourceOptionCPUCacheModeWriteCombined :: 1;
}
MTLResource :: struct {
    setPurgeableState :: (self: *MTLResource, state: MTLPurgeableState) -> MTLPurgeableState {
        invoke: (receiver: *MTLResource, selector: SEL, state: MTLPurgeableState) -> MTLPurgeableState #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "setPurgeableState:\0"), state);
    }
    makeAliasable :: (self: *MTLResource) -> () {
        invoke: (receiver: *MTLResource, selector: SEL) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "makeAliasable\0"));
    }
    isAliasable :: (self: *MTLResource) -> BOOL {
        invoke: (receiver: *MTLResource, selector: SEL) -> BOOL #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "isAliasable\0"));
    }
    label :: (self: *MTLResource) -> *NSString {
        invoke: (receiver: *MTLResource, selector: SEL) -> *NSString #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "label\0"));
    }
    setLabel :: (self: *MTLResource, label: *NSString) -> () {
        invoke: (receiver: *MTLResource, selector: SEL, label: *NSString) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setLabel:\0"), label);
    }
    device :: (self: *MTLResource) -> id {
        invoke: (receiver: *MTLResource, selector: SEL) -> id #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "device\0"));
    }
    cpuCacheMode :: (self: *MTLResource) -> MTLCPUCacheMode {
        invoke: (receiver: *MTLResource, selector: SEL) -> MTLCPUCacheMode #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "cpuCacheMode\0"));
    }
    storageMode :: (self: *MTLResource) -> MTLStorageMode {
        invoke: (receiver: *MTLResource, selector: SEL) -> MTLStorageMode #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "storageMode\0"));
    }
    heap :: (self: *MTLResource) -> id {
        invoke: (receiver: *MTLResource, selector: SEL) -> id #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "heap\0"));
    }
    allocatedSize :: (self: *MTLResource) -> NSUInteger {
        invoke: (receiver: *MTLResource, selector: SEL) -> NSUInteger #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "allocatedSize\0"));
    }
}
MTLBuffer :: struct {
    using MTLResourceUsage;
    contents :: (self: *MTLBuffer) -> *void {
        invoke: (receiver: *MTLBuffer, selector: SEL) -> *void #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "contents\0"));
    }
    didModifyRange :: (self: *MTLBuffer, range: NSRange) -> () {
        invoke: (receiver: *MTLBuffer, selector: SEL, range: NSRange) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "didModifyRange:\0"), range);
    }
    newTextureWithDescriptor_offset_bytesPerRow :: (self: *MTLBuffer, descriptor: *MTLTextureDescriptor, offset: NSUInteger, bytesPerRow: NSUInteger) -> id {
        invoke: (receiver: *MTLBuffer, selector: SEL, descriptor: *MTLTextureDescriptor, offset: NSUInteger, bytesPerRow: NSUInteger) -> id #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "newTextureWithDescriptor:offset:bytesPerRow:\0"), descriptor, offset, bytesPerRow);
    }
    addDebugMarker_range :: (self: *MTLBuffer, marker: *NSString, range: NSRange) -> () {
        invoke: (receiver: *MTLBuffer, selector: SEL, marker: *NSString, range: NSRange) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "addDebugMarker:range:\0"), marker, range);
    }
    removeAllDebugMarkers :: (self: *MTLBuffer) -> () {
        invoke: (receiver: *MTLBuffer, selector: SEL) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "removeAllDebugMarkers\0"));
    }
    length :: (self: *MTLBuffer) -> NSUInteger {
        invoke: (receiver: *MTLBuffer, selector: SEL) -> NSUInteger #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "length\0"));
    }
}
using MTLTextureType :: enum NSUInteger {
    MTLTextureType1D :: 0;
    MTLTextureType1DArray :: 1;
    MTLTextureType2D :: 2;
    MTLTextureType2DArray :: 3;
    MTLTextureType2DMultisample :: 4;
    MTLTextureTypeCube :: 5;
    MTLTextureTypeCubeArray :: 6;
    MTLTextureType3D :: 7;
    MTLTextureType2DMultisampleArray :: 8;
    MTLTextureTypeTextureBuffer :: 9;
}
MTLSharedTextureHandle :: struct {
    nsobject: NSObject;
    _priv: *MTLSharedTextureHandlePrivate;
    device :: (self: *MTLSharedTextureHandle) -> id {
        invoke: (receiver: *MTLSharedTextureHandle, selector: SEL) -> id #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "device\0"));
    }
    label :: (self: *MTLSharedTextureHandle) -> *NSString {
        invoke: (receiver: *MTLSharedTextureHandle, selector: SEL) -> *NSString #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "label\0"));
    }
}
MTLSharedTextureHandlePrivate :: struct {}
using MTLTextureUsage :: enum NSUInteger {
    MTLTextureUsageUnknown :: 0;
    MTLTextureUsageShaderRead :: 1;
    MTLTextureUsageShaderWrite :: 2;
    MTLTextureUsageRenderTarget :: 4;
    MTLTextureUsagePixelFormatView :: 16;
}
MTLTextureDescriptor :: struct {
    nsobject: NSObject;
    texture2DDescriptorWithPixelFormat_width_height_mipmapped :: (pixelFormat: MTLPixelFormat, width: NSUInteger, height: NSUInteger, mipmapped: BOOL) -> *MTLTextureDescriptor {
        invoke: (receiver: Class, selector: SEL, pixelFormat: MTLPixelFormat, width: NSUInteger, height: NSUInteger, mipmapped: BOOL) -> *MTLTextureDescriptor #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(objc_getClass(cast(*u8) "MTLTextureDescriptor\0"), sel_registerName(cast(*u8) "texture2DDescriptorWithPixelFormat:width:height:mipmapped:\0"), pixelFormat, width, height, mipmapped);
    }
    textureCubeDescriptorWithPixelFormat_size_mipmapped :: (pixelFormat: MTLPixelFormat, size: NSUInteger, mipmapped: BOOL) -> *MTLTextureDescriptor {
        invoke: (receiver: Class, selector: SEL, pixelFormat: MTLPixelFormat, size: NSUInteger, mipmapped: BOOL) -> *MTLTextureDescriptor #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(objc_getClass(cast(*u8) "MTLTextureDescriptor\0"), sel_registerName(cast(*u8) "textureCubeDescriptorWithPixelFormat:size:mipmapped:\0"), pixelFormat, size, mipmapped);
    }
    textureBufferDescriptorWithPixelFormat_width_resourceOptions_usage :: (pixelFormat: MTLPixelFormat, width: NSUInteger, resourceOptions: MTLResourceOptions, usage: MTLTextureUsage) -> *MTLTextureDescriptor {
        invoke: (receiver: Class, selector: SEL, pixelFormat: MTLPixelFormat, width: NSUInteger, resourceOptions: MTLResourceOptions, usage: MTLTextureUsage) -> *MTLTextureDescriptor #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(objc_getClass(cast(*u8) "MTLTextureDescriptor\0"), sel_registerName(cast(*u8) "textureBufferDescriptorWithPixelFormat:width:resourceOptions:usage:\0"), pixelFormat, width, resourceOptions, usage);
    }
    textureType :: (self: *MTLTextureDescriptor) -> MTLTextureType {
        invoke: (receiver: *MTLTextureDescriptor, selector: SEL) -> MTLTextureType #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "textureType\0"));
    }
    setTextureType :: (self: *MTLTextureDescriptor, textureType: MTLTextureType) -> () {
        invoke: (receiver: *MTLTextureDescriptor, selector: SEL, textureType: MTLTextureType) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setTextureType:\0"), textureType);
    }
    pixelFormat :: (self: *MTLTextureDescriptor) -> MTLPixelFormat {
        invoke: (receiver: *MTLTextureDescriptor, selector: SEL) -> MTLPixelFormat #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "pixelFormat\0"));
    }
    setPixelFormat :: (self: *MTLTextureDescriptor, pixelFormat: MTLPixelFormat) -> () {
        invoke: (receiver: *MTLTextureDescriptor, selector: SEL, pixelFormat: MTLPixelFormat) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setPixelFormat:\0"), pixelFormat);
    }
    width :: (self: *MTLTextureDescriptor) -> NSUInteger {
        invoke: (receiver: *MTLTextureDescriptor, selector: SEL) -> NSUInteger #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "width\0"));
    }
    setWidth :: (self: *MTLTextureDescriptor, width: NSUInteger) -> () {
        invoke: (receiver: *MTLTextureDescriptor, selector: SEL, width: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setWidth:\0"), width);
    }
    height :: (self: *MTLTextureDescriptor) -> NSUInteger {
        invoke: (receiver: *MTLTextureDescriptor, selector: SEL) -> NSUInteger #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "height\0"));
    }
    setHeight :: (self: *MTLTextureDescriptor, height: NSUInteger) -> () {
        invoke: (receiver: *MTLTextureDescriptor, selector: SEL, height: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setHeight:\0"), height);
    }
    depth :: (self: *MTLTextureDescriptor) -> NSUInteger {
        invoke: (receiver: *MTLTextureDescriptor, selector: SEL) -> NSUInteger #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "depth\0"));
    }
    setDepth :: (self: *MTLTextureDescriptor, depth: NSUInteger) -> () {
        invoke: (receiver: *MTLTextureDescriptor, selector: SEL, depth: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setDepth:\0"), depth);
    }
    mipmapLevelCount :: (self: *MTLTextureDescriptor) -> NSUInteger {
        invoke: (receiver: *MTLTextureDescriptor, selector: SEL) -> NSUInteger #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "mipmapLevelCount\0"));
    }
    setMipmapLevelCount :: (self: *MTLTextureDescriptor, mipmapLevelCount: NSUInteger) -> () {
        invoke: (receiver: *MTLTextureDescriptor, selector: SEL, mipmapLevelCount: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setMipmapLevelCount:\0"), mipmapLevelCount);
    }
    sampleCount :: (self: *MTLTextureDescriptor) -> NSUInteger {
        invoke: (receiver: *MTLTextureDescriptor, selector: SEL) -> NSUInteger #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "sampleCount\0"));
    }
    setSampleCount :: (self: *MTLTextureDescriptor, sampleCount: NSUInteger) -> () {
        invoke: (receiver: *MTLTextureDescriptor, selector: SEL, sampleCount: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setSampleCount:\0"), sampleCount);
    }
    arrayLength :: (self: *MTLTextureDescriptor) -> NSUInteger {
        invoke: (receiver: *MTLTextureDescriptor, selector: SEL) -> NSUInteger #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "arrayLength\0"));
    }
    setArrayLength :: (self: *MTLTextureDescriptor, arrayLength: NSUInteger) -> () {
        invoke: (receiver: *MTLTextureDescriptor, selector: SEL, arrayLength: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setArrayLength:\0"), arrayLength);
    }
    resourceOptions :: (self: *MTLTextureDescriptor) -> MTLResourceOptions {
        invoke: (receiver: *MTLTextureDescriptor, selector: SEL) -> MTLResourceOptions #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "resourceOptions\0"));
    }
    setResourceOptions :: (self: *MTLTextureDescriptor, resourceOptions: MTLResourceOptions) -> () {
        invoke: (receiver: *MTLTextureDescriptor, selector: SEL, resourceOptions: MTLResourceOptions) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setResourceOptions:\0"), resourceOptions);
    }
    cpuCacheMode :: (self: *MTLTextureDescriptor) -> MTLCPUCacheMode {
        invoke: (receiver: *MTLTextureDescriptor, selector: SEL) -> MTLCPUCacheMode #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "cpuCacheMode\0"));
    }
    setCpuCacheMode :: (self: *MTLTextureDescriptor, cpuCacheMode: MTLCPUCacheMode) -> () {
        invoke: (receiver: *MTLTextureDescriptor, selector: SEL, cpuCacheMode: MTLCPUCacheMode) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setCpuCacheMode:\0"), cpuCacheMode);
    }
    storageMode :: (self: *MTLTextureDescriptor) -> MTLStorageMode {
        invoke: (receiver: *MTLTextureDescriptor, selector: SEL) -> MTLStorageMode #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "storageMode\0"));
    }
    setStorageMode :: (self: *MTLTextureDescriptor, storageMode: MTLStorageMode) -> () {
        invoke: (receiver: *MTLTextureDescriptor, selector: SEL, storageMode: MTLStorageMode) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setStorageMode:\0"), storageMode);
    }
    usage :: (self: *MTLTextureDescriptor) -> MTLTextureUsage {
        invoke: (receiver: *MTLTextureDescriptor, selector: SEL) -> MTLTextureUsage #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "usage\0"));
    }
    setUsage :: (self: *MTLTextureDescriptor, usage: MTLTextureUsage) -> () {
        invoke: (receiver: *MTLTextureDescriptor, selector: SEL, usage: MTLTextureUsage) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setUsage:\0"), usage);
    }
    allowGPUOptimizedContents :: (self: *MTLTextureDescriptor) -> BOOL {
        invoke: (receiver: *MTLTextureDescriptor, selector: SEL) -> BOOL #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "allowGPUOptimizedContents\0"));
    }
    setAllowGPUOptimizedContents :: (self: *MTLTextureDescriptor, allowGPUOptimizedContents: BOOL) -> () {
        invoke: (receiver: *MTLTextureDescriptor, selector: SEL, allowGPUOptimizedContents: BOOL) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setAllowGPUOptimizedContents:\0"), allowGPUOptimizedContents);
    }
}
MTLTexture :: struct {
    using MTLResource;
    getBytes_bytesPerRow_bytesPerImage_fromRegion_mipmapLevel_slice :: (self: *MTLTexture, pixelBytes: *void, bytesPerRow: NSUInteger, bytesPerImage: NSUInteger, region: MTLRegion, level: NSUInteger, slice: NSUInteger) -> () {
        invoke: (receiver: *MTLTexture, selector: SEL, pixelBytes: *void, bytesPerRow: NSUInteger, bytesPerImage: NSUInteger, region: MTLRegion, level: NSUInteger, slice: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "getBytes:bytesPerRow:bytesPerImage:fromRegion:mipmapLevel:slice:\0"), pixelBytes, bytesPerRow, bytesPerImage, region, level, slice);
    }
    replaceRegion_mipmapLevel_slice_withBytes_bytesPerRow_bytesPerImage :: (self: *MTLTexture, region: MTLRegion, level: NSUInteger, slice: NSUInteger, pixelBytes: *void, bytesPerRow: NSUInteger, bytesPerImage: NSUInteger) -> () {
        invoke: (receiver: *MTLTexture, selector: SEL, region: MTLRegion, level: NSUInteger, slice: NSUInteger, pixelBytes: *void, bytesPerRow: NSUInteger, bytesPerImage: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "replaceRegion:mipmapLevel:slice:withBytes:bytesPerRow:bytesPerImage:\0"), region, level, slice, pixelBytes, bytesPerRow, bytesPerImage);
    }
    getBytes_bytesPerRow_fromRegion_mipmapLevel :: (self: *MTLTexture, pixelBytes: *void, bytesPerRow: NSUInteger, region: MTLRegion, level: NSUInteger) -> () {
        invoke: (receiver: *MTLTexture, selector: SEL, pixelBytes: *void, bytesPerRow: NSUInteger, region: MTLRegion, level: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "getBytes:bytesPerRow:fromRegion:mipmapLevel:\0"), pixelBytes, bytesPerRow, region, level);
    }
    replaceRegion_mipmapLevel_withBytes_bytesPerRow :: (self: *MTLTexture, region: MTLRegion, level: NSUInteger, pixelBytes: *void, bytesPerRow: NSUInteger) -> () {
        invoke: (receiver: *MTLTexture, selector: SEL, region: MTLRegion, level: NSUInteger, pixelBytes: *void, bytesPerRow: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "replaceRegion:mipmapLevel:withBytes:bytesPerRow:\0"), region, level, pixelBytes, bytesPerRow);
    }
    newTextureViewWithPixelFormat :: (self: *MTLTexture, pixelFormat: MTLPixelFormat) -> id {
        invoke: (receiver: *MTLTexture, selector: SEL, pixelFormat: MTLPixelFormat) -> id #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "newTextureViewWithPixelFormat:\0"), pixelFormat);
    }
    newTextureViewWithPixelFormat_textureType_levels_slices :: (self: *MTLTexture, pixelFormat: MTLPixelFormat, textureType: MTLTextureType, levelRange: NSRange, sliceRange: NSRange) -> id {
        invoke: (receiver: *MTLTexture, selector: SEL, pixelFormat: MTLPixelFormat, textureType: MTLTextureType, levelRange: NSRange, sliceRange: NSRange) -> id #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "newTextureViewWithPixelFormat:textureType:levels:slices:\0"), pixelFormat, textureType, levelRange, sliceRange);
    }
    newSharedTextureHandle :: (self: *MTLTexture) -> *MTLSharedTextureHandle {
        invoke: (receiver: *MTLTexture, selector: SEL) -> *MTLSharedTextureHandle #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "newSharedTextureHandle\0"));
    }
    rootResource :: (self: *MTLTexture) -> id {
        invoke: (receiver: *MTLTexture, selector: SEL) -> id #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "rootResource\0"));
    }
    parentTexture :: (self: *MTLTexture) -> id {
        invoke: (receiver: *MTLTexture, selector: SEL) -> id #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "parentTexture\0"));
    }
    parentRelativeLevel :: (self: *MTLTexture) -> NSUInteger {
        invoke: (receiver: *MTLTexture, selector: SEL) -> NSUInteger #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "parentRelativeLevel\0"));
    }
    parentRelativeSlice :: (self: *MTLTexture) -> NSUInteger {
        invoke: (receiver: *MTLTexture, selector: SEL) -> NSUInteger #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "parentRelativeSlice\0"));
    }
    buffer :: (self: *MTLTexture) -> id {
        invoke: (receiver: *MTLTexture, selector: SEL) -> id #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "buffer\0"));
    }
    bufferOffset :: (self: *MTLTexture) -> NSUInteger {
        invoke: (receiver: *MTLTexture, selector: SEL) -> NSUInteger #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "bufferOffset\0"));
    }
    bufferBytesPerRow :: (self: *MTLTexture) -> NSUInteger {
        invoke: (receiver: *MTLTexture, selector: SEL) -> NSUInteger #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "bufferBytesPerRow\0"));
    }
    iosurface :: (self: *MTLTexture) -> IOSurfaceRef {
        invoke: (receiver: *MTLTexture, selector: SEL) -> IOSurfaceRef #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "iosurface\0"));
    }
    iosurfacePlane :: (self: *MTLTexture) -> NSUInteger {
        invoke: (receiver: *MTLTexture, selector: SEL) -> NSUInteger #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "iosurfacePlane\0"));
    }
    textureType :: (self: *MTLTexture) -> MTLTextureType {
        invoke: (receiver: *MTLTexture, selector: SEL) -> MTLTextureType #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "textureType\0"));
    }
    pixelFormat :: (self: *MTLTexture) -> MTLPixelFormat {
        invoke: (receiver: *MTLTexture, selector: SEL) -> MTLPixelFormat #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "pixelFormat\0"));
    }
    width :: (self: *MTLTexture) -> NSUInteger {
        invoke: (receiver: *MTLTexture, selector: SEL) -> NSUInteger #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "width\0"));
    }
    height :: (self: *MTLTexture) -> NSUInteger {
        invoke: (receiver: *MTLTexture, selector: SEL) -> NSUInteger #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "height\0"));
    }
    depth :: (self: *MTLTexture) -> NSUInteger {
        invoke: (receiver: *MTLTexture, selector: SEL) -> NSUInteger #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "depth\0"));
    }
    mipmapLevelCount :: (self: *MTLTexture) -> NSUInteger {
        invoke: (receiver: *MTLTexture, selector: SEL) -> NSUInteger #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "mipmapLevelCount\0"));
    }
    sampleCount :: (self: *MTLTexture) -> NSUInteger {
        invoke: (receiver: *MTLTexture, selector: SEL) -> NSUInteger #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "sampleCount\0"));
    }
    arrayLength :: (self: *MTLTexture) -> NSUInteger {
        invoke: (receiver: *MTLTexture, selector: SEL) -> NSUInteger #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "arrayLength\0"));
    }
    usage :: (self: *MTLTexture) -> MTLTextureUsage {
        invoke: (receiver: *MTLTexture, selector: SEL) -> MTLTextureUsage #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "usage\0"));
    }
    isShareable :: (self: *MTLTexture) -> BOOL {
        invoke: (receiver: *MTLTexture, selector: SEL) -> BOOL #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "isShareable\0"));
    }
    isFramebufferOnly :: (self: *MTLTexture) -> BOOL {
        invoke: (receiver: *MTLTexture, selector: SEL) -> BOOL #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "isFramebufferOnly\0"));
    }
    allowGPUOptimizedContents :: (self: *MTLTexture) -> BOOL {
        invoke: (receiver: *MTLTexture, selector: SEL) -> BOOL #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "allowGPUOptimizedContents\0"));
    }
}
using MTLDataType :: enum NSUInteger {
    MTLDataTypeNone :: 0;
    MTLDataTypeStruct :: 1;
    MTLDataTypeArray :: 2;
    MTLDataTypeFloat :: 3;
    MTLDataTypeFloat2 :: 4;
    MTLDataTypeFloat3 :: 5;
    MTLDataTypeFloat4 :: 6;
    MTLDataTypeFloat2x2 :: 7;
    MTLDataTypeFloat2x3 :: 8;
    MTLDataTypeFloat2x4 :: 9;
    MTLDataTypeFloat3x2 :: 10;
    MTLDataTypeFloat3x3 :: 11;
    MTLDataTypeFloat3x4 :: 12;
    MTLDataTypeFloat4x2 :: 13;
    MTLDataTypeFloat4x3 :: 14;
    MTLDataTypeFloat4x4 :: 15;
    MTLDataTypeHalf :: 16;
    MTLDataTypeHalf2 :: 17;
    MTLDataTypeHalf3 :: 18;
    MTLDataTypeHalf4 :: 19;
    MTLDataTypeHalf2x2 :: 20;
    MTLDataTypeHalf2x3 :: 21;
    MTLDataTypeHalf2x4 :: 22;
    MTLDataTypeHalf3x2 :: 23;
    MTLDataTypeHalf3x3 :: 24;
    MTLDataTypeHalf3x4 :: 25;
    MTLDataTypeHalf4x2 :: 26;
    MTLDataTypeHalf4x3 :: 27;
    MTLDataTypeHalf4x4 :: 28;
    MTLDataTypeInt :: 29;
    MTLDataTypeInt2 :: 30;
    MTLDataTypeInt3 :: 31;
    MTLDataTypeInt4 :: 32;
    MTLDataTypeUInt :: 33;
    MTLDataTypeUInt2 :: 34;
    MTLDataTypeUInt3 :: 35;
    MTLDataTypeUInt4 :: 36;
    MTLDataTypeShort :: 37;
    MTLDataTypeShort2 :: 38;
    MTLDataTypeShort3 :: 39;
    MTLDataTypeShort4 :: 40;
    MTLDataTypeUShort :: 41;
    MTLDataTypeUShort2 :: 42;
    MTLDataTypeUShort3 :: 43;
    MTLDataTypeUShort4 :: 44;
    MTLDataTypeChar :: 45;
    MTLDataTypeChar2 :: 46;
    MTLDataTypeChar3 :: 47;
    MTLDataTypeChar4 :: 48;
    MTLDataTypeUChar :: 49;
    MTLDataTypeUChar2 :: 50;
    MTLDataTypeUChar3 :: 51;
    MTLDataTypeUChar4 :: 52;
    MTLDataTypeBool :: 53;
    MTLDataTypeBool2 :: 54;
    MTLDataTypeBool3 :: 55;
    MTLDataTypeBool4 :: 56;
    MTLDataTypeTexture :: 58;
    MTLDataTypeSampler :: 59;
    MTLDataTypePointer :: 60;
    MTLDataTypeRenderPipeline :: 78;
    MTLDataTypeIndirectCommandBuffer :: 80;
}
using MTLArgumentType :: enum NSUInteger {
    MTLArgumentTypeBuffer :: 0;
    MTLArgumentTypeThreadgroupMemory :: 1;
    MTLArgumentTypeTexture :: 2;
    MTLArgumentTypeSampler :: 3;
}
using MTLArgumentAccess :: enum NSUInteger {
    MTLArgumentAccessReadOnly :: 0;
    MTLArgumentAccessReadWrite :: 1;
    MTLArgumentAccessWriteOnly :: 2;
}
MTLType :: struct {
    nsobject: NSObject;
    dataType :: (self: *MTLType) -> MTLDataType {
        invoke: (receiver: *MTLType, selector: SEL) -> MTLDataType #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "dataType\0"));
    }
}
MTLStructMember :: struct {
    nsobject: NSObject;
    structType :: (self: *MTLStructMember) -> *MTLStructType {
        invoke: (receiver: *MTLStructMember, selector: SEL) -> *MTLStructType #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "structType\0"));
    }
    arrayType :: (self: *MTLStructMember) -> *MTLArrayType {
        invoke: (receiver: *MTLStructMember, selector: SEL) -> *MTLArrayType #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "arrayType\0"));
    }
    textureReferenceType :: (self: *MTLStructMember) -> *MTLTextureReferenceType {
        invoke: (receiver: *MTLStructMember, selector: SEL) -> *MTLTextureReferenceType #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "textureReferenceType\0"));
    }
    pointerType :: (self: *MTLStructMember) -> *MTLPointerType {
        invoke: (receiver: *MTLStructMember, selector: SEL) -> *MTLPointerType #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "pointerType\0"));
    }
    name :: (self: *MTLStructMember) -> *NSString {
        invoke: (receiver: *MTLStructMember, selector: SEL) -> *NSString #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "name\0"));
    }
    offset :: (self: *MTLStructMember) -> NSUInteger {
        invoke: (receiver: *MTLStructMember, selector: SEL) -> NSUInteger #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "offset\0"));
    }
    dataType :: (self: *MTLStructMember) -> MTLDataType {
        invoke: (receiver: *MTLStructMember, selector: SEL) -> MTLDataType #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "dataType\0"));
    }
    argumentIndex :: (self: *MTLStructMember) -> NSUInteger {
        invoke: (receiver: *MTLStructMember, selector: SEL) -> NSUInteger #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "argumentIndex\0"));
    }
}
MTLStructType :: struct {
    mtltype: MTLType;
    memberByName :: (self: *MTLStructType, name: *NSString) -> *MTLStructMember {
        invoke: (receiver: *MTLStructType, selector: SEL, name: *NSString) -> *MTLStructMember #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "memberByName:\0"), name);
    }
    members :: (self: *MTLStructType) -> *NSArray(*MTLStructMember) {
        invoke: (receiver: *MTLStructType, selector: SEL) -> *NSArray(*MTLStructMember) #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "members\0"));
    }
}
MTLArrayType :: struct {
    mtltype: MTLType;
    elementStructType :: (self: *MTLArrayType) -> *MTLStructType {
        invoke: (receiver: *MTLArrayType, selector: SEL) -> *MTLStructType #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "elementStructType\0"));
    }
    elementArrayType :: (self: *MTLArrayType) -> *MTLArrayType {
        invoke: (receiver: *MTLArrayType, selector: SEL) -> *MTLArrayType #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "elementArrayType\0"));
    }
    elementTextureReferenceType :: (self: *MTLArrayType) -> *MTLTextureReferenceType {
        invoke: (receiver: *MTLArrayType, selector: SEL) -> *MTLTextureReferenceType #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "elementTextureReferenceType\0"));
    }
    elementPointerType :: (self: *MTLArrayType) -> *MTLPointerType {
        invoke: (receiver: *MTLArrayType, selector: SEL) -> *MTLPointerType #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "elementPointerType\0"));
    }
    elementType :: (self: *MTLArrayType) -> MTLDataType {
        invoke: (receiver: *MTLArrayType, selector: SEL) -> MTLDataType #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "elementType\0"));
    }
    arrayLength :: (self: *MTLArrayType) -> NSUInteger {
        invoke: (receiver: *MTLArrayType, selector: SEL) -> NSUInteger #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "arrayLength\0"));
    }
    stride :: (self: *MTLArrayType) -> NSUInteger {
        invoke: (receiver: *MTLArrayType, selector: SEL) -> NSUInteger #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "stride\0"));
    }
    argumentIndexStride :: (self: *MTLArrayType) -> NSUInteger {
        invoke: (receiver: *MTLArrayType, selector: SEL) -> NSUInteger #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "argumentIndexStride\0"));
    }
}
MTLPointerType :: struct {
    mtltype: MTLType;
    elementStructType :: (self: *MTLPointerType) -> *MTLStructType {
        invoke: (receiver: *MTLPointerType, selector: SEL) -> *MTLStructType #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "elementStructType\0"));
    }
    elementArrayType :: (self: *MTLPointerType) -> *MTLArrayType {
        invoke: (receiver: *MTLPointerType, selector: SEL) -> *MTLArrayType #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "elementArrayType\0"));
    }
    elementType :: (self: *MTLPointerType) -> MTLDataType {
        invoke: (receiver: *MTLPointerType, selector: SEL) -> MTLDataType #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "elementType\0"));
    }
    access :: (self: *MTLPointerType) -> MTLArgumentAccess {
        invoke: (receiver: *MTLPointerType, selector: SEL) -> MTLArgumentAccess #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "access\0"));
    }
    alignment :: (self: *MTLPointerType) -> NSUInteger {
        invoke: (receiver: *MTLPointerType, selector: SEL) -> NSUInteger #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "alignment\0"));
    }
    dataSize :: (self: *MTLPointerType) -> NSUInteger {
        invoke: (receiver: *MTLPointerType, selector: SEL) -> NSUInteger #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "dataSize\0"));
    }
    elementIsArgumentBuffer :: (self: *MTLPointerType) -> BOOL {
        invoke: (receiver: *MTLPointerType, selector: SEL) -> BOOL #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "elementIsArgumentBuffer\0"));
    }
}
MTLTextureReferenceType :: struct {
    mtltype: MTLType;
    textureDataType :: (self: *MTLTextureReferenceType) -> MTLDataType {
        invoke: (receiver: *MTLTextureReferenceType, selector: SEL) -> MTLDataType #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "textureDataType\0"));
    }
    textureType :: (self: *MTLTextureReferenceType) -> MTLTextureType {
        invoke: (receiver: *MTLTextureReferenceType, selector: SEL) -> MTLTextureType #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "textureType\0"));
    }
    access :: (self: *MTLTextureReferenceType) -> MTLArgumentAccess {
        invoke: (receiver: *MTLTextureReferenceType, selector: SEL) -> MTLArgumentAccess #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "access\0"));
    }
    isDepthTexture :: (self: *MTLTextureReferenceType) -> BOOL {
        invoke: (receiver: *MTLTextureReferenceType, selector: SEL) -> BOOL #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "isDepthTexture\0"));
    }
}
MTLArgument :: struct {
    nsobject: NSObject;
    name :: (self: *MTLArgument) -> *NSString {
        invoke: (receiver: *MTLArgument, selector: SEL) -> *NSString #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "name\0"));
    }
    type :: (self: *MTLArgument) -> MTLArgumentType {
        invoke: (receiver: *MTLArgument, selector: SEL) -> MTLArgumentType #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "type\0"));
    }
    access :: (self: *MTLArgument) -> MTLArgumentAccess {
        invoke: (receiver: *MTLArgument, selector: SEL) -> MTLArgumentAccess #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "access\0"));
    }
    index :: (self: *MTLArgument) -> NSUInteger {
        invoke: (receiver: *MTLArgument, selector: SEL) -> NSUInteger #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "index\0"));
    }
    isActive :: (self: *MTLArgument) -> BOOL {
        invoke: (receiver: *MTLArgument, selector: SEL) -> BOOL #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "isActive\0"));
    }
    bufferAlignment :: (self: *MTLArgument) -> NSUInteger {
        invoke: (receiver: *MTLArgument, selector: SEL) -> NSUInteger #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "bufferAlignment\0"));
    }
    bufferDataSize :: (self: *MTLArgument) -> NSUInteger {
        invoke: (receiver: *MTLArgument, selector: SEL) -> NSUInteger #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "bufferDataSize\0"));
    }
    bufferDataType :: (self: *MTLArgument) -> MTLDataType {
        invoke: (receiver: *MTLArgument, selector: SEL) -> MTLDataType #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "bufferDataType\0"));
    }
    bufferStructType :: (self: *MTLArgument) -> *MTLStructType {
        invoke: (receiver: *MTLArgument, selector: SEL) -> *MTLStructType #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "bufferStructType\0"));
    }
    bufferPointerType :: (self: *MTLArgument) -> *MTLPointerType {
        invoke: (receiver: *MTLArgument, selector: SEL) -> *MTLPointerType #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "bufferPointerType\0"));
    }
    threadgroupMemoryAlignment :: (self: *MTLArgument) -> NSUInteger {
        invoke: (receiver: *MTLArgument, selector: SEL) -> NSUInteger #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "threadgroupMemoryAlignment\0"));
    }
    threadgroupMemoryDataSize :: (self: *MTLArgument) -> NSUInteger {
        invoke: (receiver: *MTLArgument, selector: SEL) -> NSUInteger #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "threadgroupMemoryDataSize\0"));
    }
    textureType :: (self: *MTLArgument) -> MTLTextureType {
        invoke: (receiver: *MTLArgument, selector: SEL) -> MTLTextureType #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "textureType\0"));
    }
    textureDataType :: (self: *MTLArgument) -> MTLDataType {
        invoke: (receiver: *MTLArgument, selector: SEL) -> MTLDataType #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "textureDataType\0"));
    }
    isDepthTexture :: (self: *MTLArgument) -> BOOL {
        invoke: (receiver: *MTLArgument, selector: SEL) -> BOOL #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "isDepthTexture\0"));
    }
    arrayLength :: (self: *MTLArgument) -> NSUInteger {
        invoke: (receiver: *MTLArgument, selector: SEL) -> NSUInteger #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "arrayLength\0"));
    }
}
MTLAutoreleasedArgument :: *MTLArgument;
using MTLPatchType :: enum NSUInteger {
    MTLPatchTypeNone :: 0;
    MTLPatchTypeTriangle :: 1;
    MTLPatchTypeQuad :: 2;
}
MTLVertexAttribute :: struct {
    nsobject: NSObject;
    name :: (self: *MTLVertexAttribute) -> *NSString {
        invoke: (receiver: *MTLVertexAttribute, selector: SEL) -> *NSString #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "name\0"));
    }
    attributeIndex :: (self: *MTLVertexAttribute) -> NSUInteger {
        invoke: (receiver: *MTLVertexAttribute, selector: SEL) -> NSUInteger #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "attributeIndex\0"));
    }
    attributeType :: (self: *MTLVertexAttribute) -> MTLDataType {
        invoke: (receiver: *MTLVertexAttribute, selector: SEL) -> MTLDataType #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "attributeType\0"));
    }
    isActive :: (self: *MTLVertexAttribute) -> BOOL {
        invoke: (receiver: *MTLVertexAttribute, selector: SEL) -> BOOL #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "isActive\0"));
    }
    isPatchData :: (self: *MTLVertexAttribute) -> BOOL {
        invoke: (receiver: *MTLVertexAttribute, selector: SEL) -> BOOL #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "isPatchData\0"));
    }
    isPatchControlPointData :: (self: *MTLVertexAttribute) -> BOOL {
        invoke: (receiver: *MTLVertexAttribute, selector: SEL) -> BOOL #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "isPatchControlPointData\0"));
    }
}
MTLAttribute :: struct {
    nsobject: NSObject;
    name :: (self: *MTLAttribute) -> *NSString {
        invoke: (receiver: *MTLAttribute, selector: SEL) -> *NSString #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "name\0"));
    }
    attributeIndex :: (self: *MTLAttribute) -> NSUInteger {
        invoke: (receiver: *MTLAttribute, selector: SEL) -> NSUInteger #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "attributeIndex\0"));
    }
    attributeType :: (self: *MTLAttribute) -> MTLDataType {
        invoke: (receiver: *MTLAttribute, selector: SEL) -> MTLDataType #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "attributeType\0"));
    }
    isActive :: (self: *MTLAttribute) -> BOOL {
        invoke: (receiver: *MTLAttribute, selector: SEL) -> BOOL #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "isActive\0"));
    }
    isPatchData :: (self: *MTLAttribute) -> BOOL {
        invoke: (receiver: *MTLAttribute, selector: SEL) -> BOOL #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "isPatchData\0"));
    }
    isPatchControlPointData :: (self: *MTLAttribute) -> BOOL {
        invoke: (receiver: *MTLAttribute, selector: SEL) -> BOOL #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "isPatchControlPointData\0"));
    }
}
using MTLFunctionType :: enum NSUInteger {
    MTLFunctionTypeVertex :: 1;
    MTLFunctionTypeFragment :: 2;
    MTLFunctionTypeKernel :: 3;
}
MTLFunctionConstant :: struct {
    nsobject: NSObject;
    name :: (self: *MTLFunctionConstant) -> *NSString {
        invoke: (receiver: *MTLFunctionConstant, selector: SEL) -> *NSString #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "name\0"));
    }
    type :: (self: *MTLFunctionConstant) -> MTLDataType {
        invoke: (receiver: *MTLFunctionConstant, selector: SEL) -> MTLDataType #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "type\0"));
    }
    index :: (self: *MTLFunctionConstant) -> NSUInteger {
        invoke: (receiver: *MTLFunctionConstant, selector: SEL) -> NSUInteger #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "index\0"));
    }
    required :: (self: *MTLFunctionConstant) -> BOOL {
        invoke: (receiver: *MTLFunctionConstant, selector: SEL) -> BOOL #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "required\0"));
    }
}
MTLFunction :: struct {
    newArgumentEncoderWithBufferIndex :: (self: *MTLFunction, bufferIndex: NSUInteger) -> id {
        invoke: (receiver: *MTLFunction, selector: SEL, bufferIndex: NSUInteger) -> id #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "newArgumentEncoderWithBufferIndex:\0"), bufferIndex);
    }
    newArgumentEncoderWithBufferIndex_reflection :: (self: *MTLFunction, bufferIndex: NSUInteger, reflection: **MTLArgument) -> id {
        invoke: (receiver: *MTLFunction, selector: SEL, bufferIndex: NSUInteger, reflection: **MTLArgument) -> id #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "newArgumentEncoderWithBufferIndex:reflection:\0"), bufferIndex, reflection);
    }
    label :: (self: *MTLFunction) -> *NSString {
        invoke: (receiver: *MTLFunction, selector: SEL) -> *NSString #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "label\0"));
    }
    setLabel :: (self: *MTLFunction, label: *NSString) -> () {
        invoke: (receiver: *MTLFunction, selector: SEL, label: *NSString) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setLabel:\0"), label);
    }
    device :: (self: *MTLFunction) -> id {
        invoke: (receiver: *MTLFunction, selector: SEL) -> id #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "device\0"));
    }
    functionType :: (self: *MTLFunction) -> MTLFunctionType {
        invoke: (receiver: *MTLFunction, selector: SEL) -> MTLFunctionType #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "functionType\0"));
    }
    patchType :: (self: *MTLFunction) -> MTLPatchType {
        invoke: (receiver: *MTLFunction, selector: SEL) -> MTLPatchType #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "patchType\0"));
    }
    patchControlPointCount :: (self: *MTLFunction) -> NSInteger {
        invoke: (receiver: *MTLFunction, selector: SEL) -> NSInteger #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "patchControlPointCount\0"));
    }
    vertexAttributes :: (self: *MTLFunction) -> *NSArray(*MTLVertexAttribute) {
        invoke: (receiver: *MTLFunction, selector: SEL) -> *NSArray(*MTLVertexAttribute) #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "vertexAttributes\0"));
    }
    stageInputAttributes :: (self: *MTLFunction) -> *NSArray(*MTLAttribute) {
        invoke: (receiver: *MTLFunction, selector: SEL) -> *NSArray(*MTLAttribute) #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "stageInputAttributes\0"));
    }
    name :: (self: *MTLFunction) -> *NSString {
        invoke: (receiver: *MTLFunction, selector: SEL) -> *NSString #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "name\0"));
    }
    functionConstantsDictionary :: (self: *MTLFunction) -> *NSDictionary(*NSString, *MTLFunctionConstant) {
        invoke: (receiver: *MTLFunction, selector: SEL) -> *NSDictionary(*NSString, *MTLFunctionConstant) #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "functionConstantsDictionary\0"));
    }
}
using MTLLanguageVersion :: enum NSUInteger {
    MTLLanguageVersion1_0 :: 65536;
    MTLLanguageVersion1_1 :: 65537;
    MTLLanguageVersion1_2 :: 65538;
    MTLLanguageVersion2_0 :: 131072;
    MTLLanguageVersion2_1 :: 131073;
}
MTLCompileOptions :: struct {
    nsobject: NSObject;
    preprocessorMacros :: (self: *MTLCompileOptions) -> *NSDictionary(*NSString, *NSObject) {
        invoke: (receiver: *MTLCompileOptions, selector: SEL) -> *NSDictionary(*NSString, *NSObject) #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "preprocessorMacros\0"));
    }
    setPreprocessorMacros :: (self: *MTLCompileOptions, preprocessorMacros: *NSDictionary) -> () {
        invoke: (receiver: *MTLCompileOptions, selector: SEL, preprocessorMacros: *NSDictionary) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setPreprocessorMacros:\0"), preprocessorMacros);
    }
    fastMathEnabled :: (self: *MTLCompileOptions) -> BOOL {
        invoke: (receiver: *MTLCompileOptions, selector: SEL) -> BOOL #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "fastMathEnabled\0"));
    }
    setFastMathEnabled :: (self: *MTLCompileOptions, fastMathEnabled: BOOL) -> () {
        invoke: (receiver: *MTLCompileOptions, selector: SEL, fastMathEnabled: BOOL) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setFastMathEnabled:\0"), fastMathEnabled);
    }
    languageVersion :: (self: *MTLCompileOptions) -> MTLLanguageVersion {
        invoke: (receiver: *MTLCompileOptions, selector: SEL) -> MTLLanguageVersion #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "languageVersion\0"));
    }
    setLanguageVersion :: (self: *MTLCompileOptions, languageVersion: MTLLanguageVersion) -> () {
        invoke: (receiver: *MTLCompileOptions, selector: SEL, languageVersion: MTLLanguageVersion) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setLanguageVersion:\0"), languageVersion);
    }
}
MTLLibraryErrorDomain: *NSString;
using MTLLibraryError :: enum NSUInteger {
    MTLLibraryErrorUnsupported :: 1;
    MTLLibraryErrorInternal :: 2;
    MTLLibraryErrorCompileFailure :: 3;
    MTLLibraryErrorCompileWarning :: 4;
    MTLLibraryErrorFunctionNotFound :: 5;
    MTLLibraryErrorFileNotFound :: 6;
}
MTLLibrary :: struct {
    newFunctionWithName :: (self: *MTLLibrary, functionName: *NSString) -> id {
        invoke: (receiver: *MTLLibrary, selector: SEL, functionName: *NSString) -> id #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "newFunctionWithName:\0"), functionName);
    }
    newFunctionWithName_constantValues_error :: (self: *MTLLibrary, name: *NSString, constantValues: *MTLFunctionConstantValues, error: **NSError) -> id {
        invoke: (receiver: *MTLLibrary, selector: SEL, name: *NSString, constantValues: *MTLFunctionConstantValues, error: **NSError) -> id #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "newFunctionWithName:constantValues:error:\0"), name, constantValues, error);
    }
    label :: (self: *MTLLibrary) -> *NSString {
        invoke: (receiver: *MTLLibrary, selector: SEL) -> *NSString #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "label\0"));
    }
    setLabel :: (self: *MTLLibrary, label: *NSString) -> () {
        invoke: (receiver: *MTLLibrary, selector: SEL, label: *NSString) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setLabel:\0"), label);
    }
    device :: (self: *MTLLibrary) -> id {
        invoke: (receiver: *MTLLibrary, selector: SEL) -> id #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "device\0"));
    }
    functionNames :: (self: *MTLLibrary) -> *NSArray(*NSString) {
        invoke: (receiver: *MTLLibrary, selector: SEL) -> *NSArray(*NSString) #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "functionNames\0"));
    }
}
MTLCreateSystemDefaultDevice :: () -> id #foreign Metal;
MTLCopyAllDevices :: () -> *NSArray(id) #foreign Metal;
MTLDeviceNotificationName :: *NSString;
MTLDeviceWasAddedNotification: MTLDeviceNotificationName;
MTLDeviceRemovalRequestedNotification: MTLDeviceNotificationName;
MTLDeviceWasRemovedNotification: MTLDeviceNotificationName;
MTLRemoveDeviceObserver :: (observer: id) -> () #foreign Metal;
using MTLFeatureSet :: enum NSUInteger {
    MTLFeatureSet_iOS_GPUFamily1_v1 :: 0;
    MTLFeatureSet_iOS_GPUFamily2_v1 :: 1;
    MTLFeatureSet_iOS_GPUFamily1_v2 :: 2;
    MTLFeatureSet_iOS_GPUFamily2_v2 :: 3;
    MTLFeatureSet_iOS_GPUFamily3_v1 :: 4;
    MTLFeatureSet_iOS_GPUFamily1_v3 :: 5;
    MTLFeatureSet_iOS_GPUFamily2_v3 :: 6;
    MTLFeatureSet_iOS_GPUFamily3_v2 :: 7;
    MTLFeatureSet_iOS_GPUFamily1_v4 :: 8;
    MTLFeatureSet_iOS_GPUFamily2_v4 :: 9;
    MTLFeatureSet_iOS_GPUFamily3_v3 :: 10;
    MTLFeatureSet_iOS_GPUFamily4_v1 :: 11;
    MTLFeatureSet_iOS_GPUFamily1_v5 :: 12;
    MTLFeatureSet_iOS_GPUFamily2_v5 :: 13;
    MTLFeatureSet_iOS_GPUFamily3_v4 :: 14;
    MTLFeatureSet_iOS_GPUFamily4_v2 :: 15;
    MTLFeatureSet_macOS_GPUFamily1_v1 :: 10000;
    MTLFeatureSet_OSX_GPUFamily1_v1 :: 10000;
    MTLFeatureSet_macOS_GPUFamily1_v2 :: 10001;
    MTLFeatureSet_OSX_GPUFamily1_v2 :: 10001;
    MTLFeatureSet_macOS_ReadWriteTextureTier2 :: 10002;
    MTLFeatureSet_OSX_ReadWriteTextureTier2 :: 10002;
    MTLFeatureSet_macOS_GPUFamily1_v3 :: 10003;
    MTLFeatureSet_macOS_GPUFamily1_v4 :: 10004;
    MTLFeatureSet_macOS_GPUFamily2_v1 :: 10005;
    MTLFeatureSet_tvOS_GPUFamily1_v1 :: 30000;
    MTLFeatureSet_TVOS_GPUFamily1_v1 :: 30000;
    MTLFeatureSet_tvOS_GPUFamily1_v2 :: 30001;
    MTLFeatureSet_tvOS_GPUFamily1_v3 :: 30002;
    MTLFeatureSet_tvOS_GPUFamily1_v4 :: 30004;
}
using MTLPipelineOption :: enum NSUInteger {
    MTLPipelineOptionNone :: 0;
    MTLPipelineOptionArgumentInfo :: 1;
    MTLPipelineOptionBufferTypeInfo :: 2;
}
using MTLReadWriteTextureTier :: enum NSUInteger {
    MTLReadWriteTextureTierNone :: 0;
    MTLReadWriteTextureTier1 :: 1;
    MTLReadWriteTextureTier2 :: 2;
}
using MTLArgumentBuffersTier :: enum NSUInteger {
    MTLArgumentBuffersTier1 :: 0;
    MTLArgumentBuffersTier2 :: 1;
}
MTLSizeAndAlign :: struct {
    size: NSUInteger;
    align: NSUInteger;
}
MTLAutoreleasedRenderPipelineReflection :: *MTLRenderPipelineReflection;
MTLAutoreleasedComputePipelineReflection :: *MTLComputePipelineReflection;
MTLArgumentDescriptor :: struct {
    nsobject: NSObject;
    argumentDescriptor :: () -> *MTLArgumentDescriptor {
        invoke: (receiver: Class, selector: SEL) -> *MTLArgumentDescriptor #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(objc_getClass(cast(*u8) "MTLArgumentDescriptor\0"), sel_registerName(cast(*u8) "argumentDescriptor\0"));
    }
    dataType :: (self: *MTLArgumentDescriptor) -> MTLDataType {
        invoke: (receiver: *MTLArgumentDescriptor, selector: SEL) -> MTLDataType #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "dataType\0"));
    }
    setDataType :: (self: *MTLArgumentDescriptor, dataType: MTLDataType) -> () {
        invoke: (receiver: *MTLArgumentDescriptor, selector: SEL, dataType: MTLDataType) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setDataType:\0"), dataType);
    }
    index :: (self: *MTLArgumentDescriptor) -> NSUInteger {
        invoke: (receiver: *MTLArgumentDescriptor, selector: SEL) -> NSUInteger #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "index\0"));
    }
    setIndex :: (self: *MTLArgumentDescriptor, index: NSUInteger) -> () {
        invoke: (receiver: *MTLArgumentDescriptor, selector: SEL, index: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setIndex:\0"), index);
    }
    arrayLength :: (self: *MTLArgumentDescriptor) -> NSUInteger {
        invoke: (receiver: *MTLArgumentDescriptor, selector: SEL) -> NSUInteger #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "arrayLength\0"));
    }
    setArrayLength :: (self: *MTLArgumentDescriptor, arrayLength: NSUInteger) -> () {
        invoke: (receiver: *MTLArgumentDescriptor, selector: SEL, arrayLength: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setArrayLength:\0"), arrayLength);
    }
    access :: (self: *MTLArgumentDescriptor) -> MTLArgumentAccess {
        invoke: (receiver: *MTLArgumentDescriptor, selector: SEL) -> MTLArgumentAccess #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "access\0"));
    }
    setAccess :: (self: *MTLArgumentDescriptor, access: MTLArgumentAccess) -> () {
        invoke: (receiver: *MTLArgumentDescriptor, selector: SEL, access: MTLArgumentAccess) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setAccess:\0"), access);
    }
    textureType :: (self: *MTLArgumentDescriptor) -> MTLTextureType {
        invoke: (receiver: *MTLArgumentDescriptor, selector: SEL) -> MTLTextureType #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "textureType\0"));
    }
    setTextureType :: (self: *MTLArgumentDescriptor, textureType: MTLTextureType) -> () {
        invoke: (receiver: *MTLArgumentDescriptor, selector: SEL, textureType: MTLTextureType) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setTextureType:\0"), textureType);
    }
    constantBlockAlignment :: (self: *MTLArgumentDescriptor) -> NSUInteger {
        invoke: (receiver: *MTLArgumentDescriptor, selector: SEL) -> NSUInteger #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "constantBlockAlignment\0"));
    }
    setConstantBlockAlignment :: (self: *MTLArgumentDescriptor, constantBlockAlignment: NSUInteger) -> () {
        invoke: (receiver: *MTLArgumentDescriptor, selector: SEL, constantBlockAlignment: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setConstantBlockAlignment:\0"), constantBlockAlignment);
    }
}
MTLDevice :: struct {
    newCommandQueue :: (self: *MTLDevice) -> *MTLCommandQueue {
        invoke: (receiver: *MTLDevice, selector: SEL) -> *MTLCommandQueue #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "newCommandQueue\0"));
    }
    newCommandQueueWithMaxCommandBufferCount :: (self: *MTLDevice, maxCommandBufferCount: NSUInteger) -> *MTLCommandQueue {
        invoke: (receiver: *MTLDevice, selector: SEL, maxCommandBufferCount: NSUInteger) -> *MTLCommandQueue #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "newCommandQueueWithMaxCommandBufferCount:\0"), maxCommandBufferCount);
    }
    heapTextureSizeAndAlignWithDescriptor :: (self: *MTLDevice, desc: *MTLTextureDescriptor) -> MTLSizeAndAlign {
        invoke: (receiver: *MTLDevice, selector: SEL, desc: *MTLTextureDescriptor) -> MTLSizeAndAlign #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "heapTextureSizeAndAlignWithDescriptor:\0"), desc);
    }
    heapBufferSizeAndAlignWithLength_options :: (self: *MTLDevice, length: NSUInteger, options: MTLResourceOptions) -> MTLSizeAndAlign {
        invoke: (receiver: *MTLDevice, selector: SEL, length: NSUInteger, options: MTLResourceOptions) -> MTLSizeAndAlign #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "heapBufferSizeAndAlignWithLength:options:\0"), length, options);
    }
    newHeapWithDescriptor :: (self: *MTLDevice, descriptor: *MTLHeapDescriptor) -> id {
        invoke: (receiver: *MTLDevice, selector: SEL, descriptor: *MTLHeapDescriptor) -> id #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "newHeapWithDescriptor:\0"), descriptor);
    }
    newBufferWithLength_options :: (self: *MTLDevice, length: NSUInteger, options: MTLResourceOptions) -> *MTLBuffer {
        invoke: (receiver: *MTLDevice, selector: SEL, length: NSUInteger, options: MTLResourceOptions) -> *MTLBuffer #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "newBufferWithLength:options:\0"), length, options);
    }
    newBufferWithBytes_length_options :: (self: *MTLDevice, pointer: *void, length: NSUInteger, options: MTLResourceOptions) -> *MTLBuffer {
        invoke: (receiver: *MTLDevice, selector: SEL, pointer: *void, length: NSUInteger, options: MTLResourceOptions) -> *MTLBuffer #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "newBufferWithBytes:length:options:\0"), pointer, length, options);
    }
    newDepthStencilStateWithDescriptor :: (self: *MTLDevice, descriptor: *MTLDepthStencilDescriptor) -> id {
        invoke: (receiver: *MTLDevice, selector: SEL, descriptor: *MTLDepthStencilDescriptor) -> id #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "newDepthStencilStateWithDescriptor:\0"), descriptor);
    }
    newTextureWithDescriptor :: (self: *MTLDevice, descriptor: *MTLTextureDescriptor) -> id {
        invoke: (receiver: *MTLDevice, selector: SEL, descriptor: *MTLTextureDescriptor) -> id #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "newTextureWithDescriptor:\0"), descriptor);
    }
    newTextureWithDescriptor_iosurface_plane :: (self: *MTLDevice, descriptor: *MTLTextureDescriptor, iosurface: IOSurfaceRef, plane: NSUInteger) -> id {
        invoke: (receiver: *MTLDevice, selector: SEL, descriptor: *MTLTextureDescriptor, iosurface: IOSurfaceRef, plane: NSUInteger) -> id #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "newTextureWithDescriptor:iosurface:plane:\0"), descriptor, iosurface, plane);
    }
    newSharedTextureWithDescriptor :: (self: *MTLDevice, descriptor: *MTLTextureDescriptor) -> id {
        invoke: (receiver: *MTLDevice, selector: SEL, descriptor: *MTLTextureDescriptor) -> id #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "newSharedTextureWithDescriptor:\0"), descriptor);
    }
    newSharedTextureWithHandle :: (self: *MTLDevice, sharedHandle: *MTLSharedTextureHandle) -> id {
        invoke: (receiver: *MTLDevice, selector: SEL, sharedHandle: *MTLSharedTextureHandle) -> id #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "newSharedTextureWithHandle:\0"), sharedHandle);
    }
    newSamplerStateWithDescriptor :: (self: *MTLDevice, descriptor: *MTLSamplerDescriptor) -> id {
        invoke: (receiver: *MTLDevice, selector: SEL, descriptor: *MTLSamplerDescriptor) -> id #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "newSamplerStateWithDescriptor:\0"), descriptor);
    }
    newDefaultLibrary :: (self: *MTLDevice) -> *MTLLibrary {
        invoke: (receiver: *MTLDevice, selector: SEL) -> *MTLLibrary #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "newDefaultLibrary\0"));
    }
    newDefaultLibraryWithBundle_error :: (self: *MTLDevice, bundle: *NSBundle, error: **NSError) -> *MTLLibrary {
        invoke: (receiver: *MTLDevice, selector: SEL, bundle: *NSBundle, error: **NSError) -> *MTLLibrary #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "newDefaultLibraryWithBundle:error:\0"), bundle, error);
    }
    newLibraryWithFile_error :: (self: *MTLDevice, filepath: *NSString, error: **NSError) -> *MTLLibrary {
        invoke: (receiver: *MTLDevice, selector: SEL, filepath: *NSString, error: **NSError) -> *MTLLibrary #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "newLibraryWithFile:error:\0"), filepath, error);
    }
    newLibraryWithURL_error :: (self: *MTLDevice, url: *NSURL, error: **NSError) -> *MTLLibrary {
        invoke: (receiver: *MTLDevice, selector: SEL, url: *NSURL, error: **NSError) -> *MTLLibrary #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "newLibraryWithURL:error:\0"), url, error);
    }
    newLibraryWithData_error :: (self: *MTLDevice, data: dispatch_data_t, error: **NSError) -> *MTLLibrary {
        invoke: (receiver: *MTLDevice, selector: SEL, data: dispatch_data_t, error: **NSError) -> *MTLLibrary #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "newLibraryWithData:error:\0"), data, error);
    }
    newLibraryWithSource_options_error :: (self: *MTLDevice, source: *NSString, options: *MTLCompileOptions, error: **NSError) -> *MTLLibrary {
        invoke: (receiver: *MTLDevice, selector: SEL, source: *NSString, options: *MTLCompileOptions, error: **NSError) -> *MTLLibrary #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "newLibraryWithSource:options:error:\0"), source, options, error);
    }
    newRenderPipelineStateWithDescriptor_error :: (self: *MTLDevice, descriptor: *MTLRenderPipelineDescriptor, error: **NSError) -> *MTLRenderPipelineState {
        invoke: (receiver: *MTLDevice, selector: SEL, descriptor: *MTLRenderPipelineDescriptor, error: **NSError) -> *MTLRenderPipelineState #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "newRenderPipelineStateWithDescriptor:error:\0"), descriptor, error);
    }
    newRenderPipelineStateWithDescriptor_options_reflection_error :: (self: *MTLDevice, descriptor: *MTLRenderPipelineDescriptor, options: MTLPipelineOption, reflection: **MTLRenderPipelineReflection, error: **NSError) -> id {
        invoke: (receiver: *MTLDevice, selector: SEL, descriptor: *MTLRenderPipelineDescriptor, options: MTLPipelineOption, reflection: **MTLRenderPipelineReflection, error: **NSError) -> id #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "newRenderPipelineStateWithDescriptor:options:reflection:error:\0"), descriptor, options, reflection, error);
    }
    newComputePipelineStateWithFunction_error :: (self: *MTLDevice, computeFunction: id, error: **NSError) -> *MTLComputePipelineState {
        invoke: (receiver: *MTLDevice, selector: SEL, computeFunction: id, error: **NSError) -> *MTLComputePipelineState #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "newComputePipelineStateWithFunction:error:\0"), computeFunction, error);
    }
    newComputePipelineStateWithFunction_options_reflection_error :: (self: *MTLDevice, computeFunction: id, options: MTLPipelineOption, reflection: **MTLComputePipelineReflection, error: **NSError) -> *MTLComputePipelineState {
        invoke: (receiver: *MTLDevice, selector: SEL, computeFunction: id, options: MTLPipelineOption, reflection: **MTLComputePipelineReflection, error: **NSError) -> *MTLComputePipelineState #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "newComputePipelineStateWithFunction:options:reflection:error:\0"), computeFunction, options, reflection, error);
    }
    newComputePipelineStateWithDescriptor_options_reflection_error :: (self: *MTLDevice, descriptor: *MTLComputePipelineDescriptor, options: MTLPipelineOption, reflection: **MTLComputePipelineReflection, error: **NSError) -> id {
        invoke: (receiver: *MTLDevice, selector: SEL, descriptor: *MTLComputePipelineDescriptor, options: MTLPipelineOption, reflection: **MTLComputePipelineReflection, error: **NSError) -> id #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "newComputePipelineStateWithDescriptor:options:reflection:error:\0"), descriptor, options, reflection, error);
    }
    newFence :: (self: *MTLDevice) -> id {
        invoke: (receiver: *MTLDevice, selector: SEL) -> id #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "newFence\0"));
    }
    supportsFeatureSet :: (self: *MTLDevice, featureSet: MTLFeatureSet) -> BOOL {
        invoke: (receiver: *MTLDevice, selector: SEL, featureSet: MTLFeatureSet) -> BOOL #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "supportsFeatureSet:\0"), featureSet);
    }
    supportsTextureSampleCount :: (self: *MTLDevice, sampleCount: NSUInteger) -> BOOL {
        invoke: (receiver: *MTLDevice, selector: SEL, sampleCount: NSUInteger) -> BOOL #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "supportsTextureSampleCount:\0"), sampleCount);
    }
    minimumLinearTextureAlignmentForPixelFormat :: (self: *MTLDevice, format: MTLPixelFormat) -> NSUInteger {
        invoke: (receiver: *MTLDevice, selector: SEL, format: MTLPixelFormat) -> NSUInteger #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "minimumLinearTextureAlignmentForPixelFormat:\0"), format);
    }
    minimumTextureBufferAlignmentForPixelFormat :: (self: *MTLDevice, format: MTLPixelFormat) -> NSUInteger {
        invoke: (receiver: *MTLDevice, selector: SEL, format: MTLPixelFormat) -> NSUInteger #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "minimumTextureBufferAlignmentForPixelFormat:\0"), format);
    }
    getDefaultSamplePositions_count :: (self: *MTLDevice, positions: *MTLSamplePosition, count: NSUInteger) -> () {
        invoke: (receiver: *MTLDevice, selector: SEL, positions: *MTLSamplePosition, count: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "getDefaultSamplePositions:count:\0"), positions, count);
    }
    newArgumentEncoderWithArguments :: (self: *MTLDevice, arguments: *NSArray(*MTLArgumentDescriptor)) -> id {
        invoke: (receiver: *MTLDevice, selector: SEL, arguments: *NSArray(*MTLArgumentDescriptor)) -> id #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "newArgumentEncoderWithArguments:\0"), arguments);
    }
    newIndirectCommandBufferWithDescriptor_maxCommandCount_options :: (self: *MTLDevice, descriptor: *MTLIndirectCommandBufferDescriptor, maxCount: NSUInteger, options: MTLResourceOptions) -> id {
        invoke: (receiver: *MTLDevice, selector: SEL, descriptor: *MTLIndirectCommandBufferDescriptor, maxCount: NSUInteger, options: MTLResourceOptions) -> id #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "newIndirectCommandBufferWithDescriptor:maxCommandCount:options:\0"), descriptor, maxCount, options);
    }
    newEvent :: (self: *MTLDevice) -> id {
        invoke: (receiver: *MTLDevice, selector: SEL) -> id #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "newEvent\0"));
    }
    newSharedEvent :: (self: *MTLDevice) -> id {
        invoke: (receiver: *MTLDevice, selector: SEL) -> id #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "newSharedEvent\0"));
    }
    newSharedEventWithHandle :: (self: *MTLDevice, sharedEventHandle: *MTLSharedEventHandle) -> id {
        invoke: (receiver: *MTLDevice, selector: SEL, sharedEventHandle: *MTLSharedEventHandle) -> id #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "newSharedEventWithHandle:\0"), sharedEventHandle);
    }
    name :: (self: *MTLDevice) -> *NSString {
        invoke: (receiver: *MTLDevice, selector: SEL) -> *NSString #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "name\0"));
    }
    registryID :: (self: *MTLDevice) -> uint64_t {
        invoke: (receiver: *MTLDevice, selector: SEL) -> uint64_t #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "registryID\0"));
    }
    maxThreadsPerThreadgroup :: (self: *MTLDevice) -> MTLSize {
        #if CPU == .X64 {
            value: MTLSize;
            send_stret: (output: *MTLSize, receiver: *MTLDevice, selector: SEL) -> void #c_call;
            send_stret = cast(type_of(send_stret)) objc_msgSend_stret;
            send_stret(*value, self, sel_registerName(cast(*u8) "maxThreadsPerThreadgroup\0"));
            return value;
        } else {
            invoke: (receiver: *MTLDevice, selector: SEL) -> MTLSize #c_call;
            invoke = cast(type_of(invoke)) objc_msgSend;
            return invoke(self, sel_registerName(cast(*u8) "maxThreadsPerThreadgroup\0"));
        }
    }
    isLowPower :: (self: *MTLDevice) -> BOOL {
        invoke: (receiver: *MTLDevice, selector: SEL) -> BOOL #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "isLowPower\0"));
    }
    isHeadless :: (self: *MTLDevice) -> BOOL {
        invoke: (receiver: *MTLDevice, selector: SEL) -> BOOL #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "isHeadless\0"));
    }
    isRemovable :: (self: *MTLDevice) -> BOOL {
        invoke: (receiver: *MTLDevice, selector: SEL) -> BOOL #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "isRemovable\0"));
    }
    recommendedMaxWorkingSetSize :: (self: *MTLDevice) -> uint64_t {
        invoke: (receiver: *MTLDevice, selector: SEL) -> uint64_t #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "recommendedMaxWorkingSetSize\0"));
    }
    isDepth24Stencil8PixelFormatSupported :: (self: *MTLDevice) -> BOOL {
        invoke: (receiver: *MTLDevice, selector: SEL) -> BOOL #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "isDepth24Stencil8PixelFormatSupported\0"));
    }
    readWriteTextureSupport :: (self: *MTLDevice) -> MTLReadWriteTextureTier {
        invoke: (receiver: *MTLDevice, selector: SEL) -> MTLReadWriteTextureTier #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "readWriteTextureSupport\0"));
    }
    argumentBuffersSupport :: (self: *MTLDevice) -> MTLArgumentBuffersTier {
        invoke: (receiver: *MTLDevice, selector: SEL) -> MTLArgumentBuffersTier #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "argumentBuffersSupport\0"));
    }
    areRasterOrderGroupsSupported :: (self: *MTLDevice) -> BOOL {
        invoke: (receiver: *MTLDevice, selector: SEL) -> BOOL #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "areRasterOrderGroupsSupported\0"));
    }
    currentAllocatedSize :: (self: *MTLDevice) -> NSUInteger {
        invoke: (receiver: *MTLDevice, selector: SEL) -> NSUInteger #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "currentAllocatedSize\0"));
    }
    maxThreadgroupMemoryLength :: (self: *MTLDevice) -> NSUInteger {
        invoke: (receiver: *MTLDevice, selector: SEL) -> NSUInteger #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "maxThreadgroupMemoryLength\0"));
    }
    maxArgumentBufferSamplerCount :: (self: *MTLDevice) -> NSUInteger {
        invoke: (receiver: *MTLDevice, selector: SEL) -> NSUInteger #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "maxArgumentBufferSamplerCount\0"));
    }
    areProgrammableSamplePositionsSupported :: (self: *MTLDevice) -> BOOL {
        invoke: (receiver: *MTLDevice, selector: SEL) -> BOOL #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "areProgrammableSamplePositionsSupported\0"));
    }
    maxBufferLength :: (self: *MTLDevice) -> NSUInteger {
        invoke: (receiver: *MTLDevice, selector: SEL) -> NSUInteger #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "maxBufferLength\0"));
    }
}
MTLFence :: struct {
    device :: (self: *MTLFence) -> id {
        invoke: (receiver: *MTLFence, selector: SEL) -> id #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "device\0"));
    }
    label :: (self: *MTLFence) -> *NSString {
        invoke: (receiver: *MTLFence, selector: SEL) -> *NSString #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "label\0"));
    }
    setLabel :: (self: *MTLFence, label: *NSString) -> () {
        invoke: (receiver: *MTLFence, selector: SEL, label: *NSString) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setLabel:\0"), label);
    }
}
using MTLBlitOption :: enum NSUInteger {
    MTLBlitOptionNone :: 0;
    MTLBlitOptionDepthFromDepthStencil :: 1;
    MTLBlitOptionStencilFromDepthStencil :: 2;
    MTLBlitOptionRowLinearPVRTC :: 4;
}
MTLBlitCommandEncoder :: struct {
    synchronizeResource :: (self: *MTLBlitCommandEncoder, resource: id) -> () {
        invoke: (receiver: *MTLBlitCommandEncoder, selector: SEL, resource: id) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "synchronizeResource:\0"), resource);
    }
    synchronizeTexture_slice_level :: (self: *MTLBlitCommandEncoder, texture: id, slice: NSUInteger, level: NSUInteger) -> () {
        invoke: (receiver: *MTLBlitCommandEncoder, selector: SEL, texture: id, slice: NSUInteger, level: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "synchronizeTexture:slice:level:\0"), texture, slice, level);
    }
    copyFromTexture_sourceSlice_sourceLevel_sourceOrigin_sourceSize_toTexture_destinationSlice_destinationLevel_destinationOrigin :: (self: *MTLBlitCommandEncoder, sourceTexture: id, sourceSlice: NSUInteger, sourceLevel: NSUInteger, sourceOrigin: MTLOrigin, sourceSize: MTLSize, destinationTexture: id, destinationSlice: NSUInteger, destinationLevel: NSUInteger, destinationOrigin: MTLOrigin) -> () {
        invoke: (receiver: *MTLBlitCommandEncoder, selector: SEL, sourceTexture: id, sourceSlice: NSUInteger, sourceLevel: NSUInteger, sourceOrigin: MTLOrigin, sourceSize: MTLSize, destinationTexture: id, destinationSlice: NSUInteger, destinationLevel: NSUInteger, destinationOrigin: MTLOrigin) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "copyFromTexture:sourceSlice:sourceLevel:sourceOrigin:sourceSize:toTexture:destinationSlice:destinationLevel:destinationOrigin:\0"), sourceTexture, sourceSlice, sourceLevel, sourceOrigin, sourceSize, destinationTexture, destinationSlice, destinationLevel, destinationOrigin);
    }
    copyFromBuffer_sourceOffset_sourceBytesPerRow_sourceBytesPerImage_sourceSize_toTexture_destinationSlice_destinationLevel_destinationOrigin :: (self: *MTLBlitCommandEncoder, sourceBuffer: id, sourceOffset: NSUInteger, sourceBytesPerRow: NSUInteger, sourceBytesPerImage: NSUInteger, sourceSize: MTLSize, destinationTexture: id, destinationSlice: NSUInteger, destinationLevel: NSUInteger, destinationOrigin: MTLOrigin) -> () {
        invoke: (receiver: *MTLBlitCommandEncoder, selector: SEL, sourceBuffer: id, sourceOffset: NSUInteger, sourceBytesPerRow: NSUInteger, sourceBytesPerImage: NSUInteger, sourceSize: MTLSize, destinationTexture: id, destinationSlice: NSUInteger, destinationLevel: NSUInteger, destinationOrigin: MTLOrigin) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "copyFromBuffer:sourceOffset:sourceBytesPerRow:sourceBytesPerImage:sourceSize:toTexture:destinationSlice:destinationLevel:destinationOrigin:\0"), sourceBuffer, sourceOffset, sourceBytesPerRow, sourceBytesPerImage, sourceSize, destinationTexture, destinationSlice, destinationLevel, destinationOrigin);
    }
    copyFromBuffer_sourceOffset_sourceBytesPerRow_sourceBytesPerImage_sourceSize_toTexture_destinationSlice_destinationLevel_destinationOrigin_options :: (self: *MTLBlitCommandEncoder, sourceBuffer: id, sourceOffset: NSUInteger, sourceBytesPerRow: NSUInteger, sourceBytesPerImage: NSUInteger, sourceSize: MTLSize, destinationTexture: id, destinationSlice: NSUInteger, destinationLevel: NSUInteger, destinationOrigin: MTLOrigin, options: MTLBlitOption) -> () {
        invoke: (receiver: *MTLBlitCommandEncoder, selector: SEL, sourceBuffer: id, sourceOffset: NSUInteger, sourceBytesPerRow: NSUInteger, sourceBytesPerImage: NSUInteger, sourceSize: MTLSize, destinationTexture: id, destinationSlice: NSUInteger, destinationLevel: NSUInteger, destinationOrigin: MTLOrigin, options: MTLBlitOption) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "copyFromBuffer:sourceOffset:sourceBytesPerRow:sourceBytesPerImage:sourceSize:toTexture:destinationSlice:destinationLevel:destinationOrigin:options:\0"), sourceBuffer, sourceOffset, sourceBytesPerRow, sourceBytesPerImage, sourceSize, destinationTexture, destinationSlice, destinationLevel, destinationOrigin, options);
    }
    copyFromTexture_sourceSlice_sourceLevel_sourceOrigin_sourceSize_toBuffer_destinationOffset_destinationBytesPerRow_destinationBytesPerImage :: (self: *MTLBlitCommandEncoder, sourceTexture: id, sourceSlice: NSUInteger, sourceLevel: NSUInteger, sourceOrigin: MTLOrigin, sourceSize: MTLSize, destinationBuffer: id, destinationOffset: NSUInteger, destinationBytesPerRow: NSUInteger, destinationBytesPerImage: NSUInteger) -> () {
        invoke: (receiver: *MTLBlitCommandEncoder, selector: SEL, sourceTexture: id, sourceSlice: NSUInteger, sourceLevel: NSUInteger, sourceOrigin: MTLOrigin, sourceSize: MTLSize, destinationBuffer: id, destinationOffset: NSUInteger, destinationBytesPerRow: NSUInteger, destinationBytesPerImage: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "copyFromTexture:sourceSlice:sourceLevel:sourceOrigin:sourceSize:toBuffer:destinationOffset:destinationBytesPerRow:destinationBytesPerImage:\0"), sourceTexture, sourceSlice, sourceLevel, sourceOrigin, sourceSize, destinationBuffer, destinationOffset, destinationBytesPerRow, destinationBytesPerImage);
    }
    copyFromTexture_sourceSlice_sourceLevel_sourceOrigin_sourceSize_toBuffer_destinationOffset_destinationBytesPerRow_destinationBytesPerImage_options :: (self: *MTLBlitCommandEncoder, sourceTexture: id, sourceSlice: NSUInteger, sourceLevel: NSUInteger, sourceOrigin: MTLOrigin, sourceSize: MTLSize, destinationBuffer: id, destinationOffset: NSUInteger, destinationBytesPerRow: NSUInteger, destinationBytesPerImage: NSUInteger, options: MTLBlitOption) -> () {
        invoke: (receiver: *MTLBlitCommandEncoder, selector: SEL, sourceTexture: id, sourceSlice: NSUInteger, sourceLevel: NSUInteger, sourceOrigin: MTLOrigin, sourceSize: MTLSize, destinationBuffer: id, destinationOffset: NSUInteger, destinationBytesPerRow: NSUInteger, destinationBytesPerImage: NSUInteger, options: MTLBlitOption) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "copyFromTexture:sourceSlice:sourceLevel:sourceOrigin:sourceSize:toBuffer:destinationOffset:destinationBytesPerRow:destinationBytesPerImage:options:\0"), sourceTexture, sourceSlice, sourceLevel, sourceOrigin, sourceSize, destinationBuffer, destinationOffset, destinationBytesPerRow, destinationBytesPerImage, options);
    }
    generateMipmapsForTexture :: (self: *MTLBlitCommandEncoder, texture: id) -> () {
        invoke: (receiver: *MTLBlitCommandEncoder, selector: SEL, texture: id) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "generateMipmapsForTexture:\0"), texture);
    }
    fillBuffer_range_value :: (self: *MTLBlitCommandEncoder, buffer: id, range: NSRange, value: uint8_t) -> () {
        invoke: (receiver: *MTLBlitCommandEncoder, selector: SEL, buffer: id, range: NSRange, value: uint8_t) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "fillBuffer:range:value:\0"), buffer, range, value);
    }
    copyFromBuffer_sourceOffset_toBuffer_destinationOffset_size :: (self: *MTLBlitCommandEncoder, sourceBuffer: id, sourceOffset: NSUInteger, destinationBuffer: id, destinationOffset: NSUInteger, size: NSUInteger) -> () {
        invoke: (receiver: *MTLBlitCommandEncoder, selector: SEL, sourceBuffer: id, sourceOffset: NSUInteger, destinationBuffer: id, destinationOffset: NSUInteger, size: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "copyFromBuffer:sourceOffset:toBuffer:destinationOffset:size:\0"), sourceBuffer, sourceOffset, destinationBuffer, destinationOffset, size);
    }
    updateFence :: (self: *MTLBlitCommandEncoder, fence: id) -> () {
        invoke: (receiver: *MTLBlitCommandEncoder, selector: SEL, fence: id) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "updateFence:\0"), fence);
    }
    waitForFence :: (self: *MTLBlitCommandEncoder, fence: id) -> () {
        invoke: (receiver: *MTLBlitCommandEncoder, selector: SEL, fence: id) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "waitForFence:\0"), fence);
    }
    optimizeContentsForGPUAccess :: (self: *MTLBlitCommandEncoder, texture: id) -> () {
        invoke: (receiver: *MTLBlitCommandEncoder, selector: SEL, texture: id) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "optimizeContentsForGPUAccess:\0"), texture);
    }
    optimizeContentsForGPUAccess_slice_level :: (self: *MTLBlitCommandEncoder, texture: id, slice: NSUInteger, level: NSUInteger) -> () {
        invoke: (receiver: *MTLBlitCommandEncoder, selector: SEL, texture: id, slice: NSUInteger, level: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "optimizeContentsForGPUAccess:slice:level:\0"), texture, slice, level);
    }
    optimizeContentsForCPUAccess :: (self: *MTLBlitCommandEncoder, texture: id) -> () {
        invoke: (receiver: *MTLBlitCommandEncoder, selector: SEL, texture: id) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "optimizeContentsForCPUAccess:\0"), texture);
    }
    optimizeContentsForCPUAccess_slice_level :: (self: *MTLBlitCommandEncoder, texture: id, slice: NSUInteger, level: NSUInteger) -> () {
        invoke: (receiver: *MTLBlitCommandEncoder, selector: SEL, texture: id, slice: NSUInteger, level: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "optimizeContentsForCPUAccess:slice:level:\0"), texture, slice, level);
    }
    resetCommandsInBuffer_withRange :: (self: *MTLBlitCommandEncoder, buffer: id, range: NSRange) -> () {
        invoke: (receiver: *MTLBlitCommandEncoder, selector: SEL, buffer: id, range: NSRange) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "resetCommandsInBuffer:withRange:\0"), buffer, range);
    }
    copyIndirectCommandBuffer_sourceRange_destination_destinationIndex :: (self: *MTLBlitCommandEncoder, source: id, sourceRange: NSRange, destination: id, destinationIndex: NSUInteger) -> () {
        invoke: (receiver: *MTLBlitCommandEncoder, selector: SEL, source: id, sourceRange: NSRange, destination: id, destinationIndex: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "copyIndirectCommandBuffer:sourceRange:destination:destinationIndex:\0"), source, sourceRange, destination, destinationIndex);
    }
    optimizeIndirectCommandBuffer_withRange :: (self: *MTLBlitCommandEncoder, indirectCommandBuffer: id, range: NSRange) -> () {
        invoke: (receiver: *MTLBlitCommandEncoder, selector: SEL, indirectCommandBuffer: id, range: NSRange) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "optimizeIndirectCommandBuffer:withRange:\0"), indirectCommandBuffer, range);
    }
}
using MTLCommandBufferStatus :: enum NSUInteger {
    MTLCommandBufferStatusNotEnqueued :: 0;
    MTLCommandBufferStatusEnqueued :: 1;
    MTLCommandBufferStatusCommitted :: 2;
    MTLCommandBufferStatusScheduled :: 3;
    MTLCommandBufferStatusCompleted :: 4;
    MTLCommandBufferStatusError :: 5;
}
MTLCommandBufferErrorDomain: *NSString;
using MTLCommandBufferError :: enum NSUInteger {
    MTLCommandBufferErrorNone :: 0;
    MTLCommandBufferErrorInternal :: 1;
    MTLCommandBufferErrorTimeout :: 2;
    MTLCommandBufferErrorPageFault :: 3;
    MTLCommandBufferErrorBlacklisted :: 4;
    MTLCommandBufferErrorNotPermitted :: 7;
    MTLCommandBufferErrorOutOfMemory :: 8;
    MTLCommandBufferErrorInvalidResource :: 9;
    MTLCommandBufferErrorMemoryless :: 10;
    MTLCommandBufferErrorDeviceRemoved :: 11;
}
using MTLDispatchType :: enum NSUInteger {
    MTLDispatchTypeSerial :: 0;
    MTLDispatchTypeConcurrent :: 1;
}
MTLCommandBuffer :: struct {
    enqueue :: (self: *MTLCommandBuffer) -> () {
        invoke: (receiver: *MTLCommandBuffer, selector: SEL) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "enqueue\0"));
    }
    commit :: (self: *MTLCommandBuffer) -> () {
        invoke: (receiver: *MTLCommandBuffer, selector: SEL) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "commit\0"));
    }
    presentDrawable :: (self: *MTLCommandBuffer, drawable: id) -> () {
        invoke: (receiver: *MTLCommandBuffer, selector: SEL, drawable: id) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "presentDrawable:\0"), drawable);
    }
    presentDrawable_atTime :: (self: *MTLCommandBuffer, drawable: id, presentationTime: CFTimeInterval) -> () {
        invoke: (receiver: *MTLCommandBuffer, selector: SEL, drawable: id, presentationTime: CFTimeInterval) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "presentDrawable:atTime:\0"), drawable, presentationTime);
    }
    waitUntilScheduled :: (self: *MTLCommandBuffer) -> () {
        invoke: (receiver: *MTLCommandBuffer, selector: SEL) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "waitUntilScheduled\0"));
    }
    waitUntilCompleted :: (self: *MTLCommandBuffer) -> () {
        invoke: (receiver: *MTLCommandBuffer, selector: SEL) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "waitUntilCompleted\0"));
    }
    blitCommandEncoder :: (self: *MTLCommandBuffer) -> *MTLBlitCommandEncoder {
        invoke: (receiver: *MTLCommandBuffer, selector: SEL) -> *MTLBlitCommandEncoder #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "blitCommandEncoder\0"));
    }
    renderCommandEncoderWithDescriptor :: (self: *MTLCommandBuffer, renderPassDescriptor: *MTLRenderPassDescriptor) -> *MTLRenderCommandEncoder {
        invoke: (receiver: *MTLCommandBuffer, selector: SEL, renderPassDescriptor: *MTLRenderPassDescriptor) -> *MTLRenderCommandEncoder #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "renderCommandEncoderWithDescriptor:\0"), renderPassDescriptor);
    }
    computeCommandEncoder :: (self: *MTLCommandBuffer) -> *MTLComputeCommandEncoder {
        invoke: (receiver: *MTLCommandBuffer, selector: SEL) -> *MTLComputeCommandEncoder #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "computeCommandEncoder\0"));
    }
    computeCommandEncoderWithDispatchType :: (self: *MTLCommandBuffer, dispatchType: MTLDispatchType) -> *MTLComputeCommandEncoder {
        invoke: (receiver: *MTLCommandBuffer, selector: SEL, dispatchType: MTLDispatchType) -> *MTLComputeCommandEncoder #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "computeCommandEncoderWithDispatchType:\0"), dispatchType);
    }
    encodeWaitForEvent_value :: (self: *MTLCommandBuffer, event: id, value: uint64_t) -> () {
        invoke: (receiver: *MTLCommandBuffer, selector: SEL, event: id, value: uint64_t) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "encodeWaitForEvent:value:\0"), event, value);
    }
    encodeSignalEvent_value :: (self: *MTLCommandBuffer, event: id, value: uint64_t) -> () {
        invoke: (receiver: *MTLCommandBuffer, selector: SEL, event: id, value: uint64_t) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "encodeSignalEvent:value:\0"), event, value);
    }
    parallelRenderCommandEncoderWithDescriptor :: (self: *MTLCommandBuffer, renderPassDescriptor: *MTLRenderPassDescriptor) -> id {
        invoke: (receiver: *MTLCommandBuffer, selector: SEL, renderPassDescriptor: *MTLRenderPassDescriptor) -> id #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "parallelRenderCommandEncoderWithDescriptor:\0"), renderPassDescriptor);
    }
    pushDebugGroup :: (self: *MTLCommandBuffer, _string: *NSString) -> () {
        invoke: (receiver: *MTLCommandBuffer, selector: SEL, _string: *NSString) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "pushDebugGroup:\0"), _string);
    }
    popDebugGroup :: (self: *MTLCommandBuffer) -> () {
        invoke: (receiver: *MTLCommandBuffer, selector: SEL) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "popDebugGroup\0"));
    }
    device :: (self: *MTLCommandBuffer) -> id {
        invoke: (receiver: *MTLCommandBuffer, selector: SEL) -> id #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "device\0"));
    }
    commandQueue :: (self: *MTLCommandBuffer) -> id {
        invoke: (receiver: *MTLCommandBuffer, selector: SEL) -> id #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "commandQueue\0"));
    }
    retainedReferences :: (self: *MTLCommandBuffer) -> BOOL {
        invoke: (receiver: *MTLCommandBuffer, selector: SEL) -> BOOL #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "retainedReferences\0"));
    }
    label :: (self: *MTLCommandBuffer) -> *NSString {
        invoke: (receiver: *MTLCommandBuffer, selector: SEL) -> *NSString #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "label\0"));
    }
    setLabel :: (self: *MTLCommandBuffer, label: *NSString) -> () {
        invoke: (receiver: *MTLCommandBuffer, selector: SEL, label: *NSString) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setLabel:\0"), label);
    }
    kernelStartTime :: (self: *MTLCommandBuffer) -> CFTimeInterval {
        invoke: (receiver: *MTLCommandBuffer, selector: SEL) -> CFTimeInterval #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "kernelStartTime\0"));
    }
    kernelEndTime :: (self: *MTLCommandBuffer) -> CFTimeInterval {
        invoke: (receiver: *MTLCommandBuffer, selector: SEL) -> CFTimeInterval #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "kernelEndTime\0"));
    }
    GPUStartTime :: (self: *MTLCommandBuffer) -> CFTimeInterval {
        invoke: (receiver: *MTLCommandBuffer, selector: SEL) -> CFTimeInterval #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "GPUStartTime\0"));
    }
    GPUEndTime :: (self: *MTLCommandBuffer) -> CFTimeInterval {
        invoke: (receiver: *MTLCommandBuffer, selector: SEL) -> CFTimeInterval #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "GPUEndTime\0"));
    }
    status :: (self: *MTLCommandBuffer) -> MTLCommandBufferStatus {
        invoke: (receiver: *MTLCommandBuffer, selector: SEL) -> MTLCommandBufferStatus #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "status\0"));
    }
    error :: (self: *MTLCommandBuffer) -> *NSError {
        invoke: (receiver: *MTLCommandBuffer, selector: SEL) -> *NSError #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "error\0"));
    }
}
MTLDispatchThreadgroupsIndirectArguments :: struct {
    threadgroupsPerGrid: [3] uint32_t;
}
MTLStageInRegionIndirectArguments :: struct {
    stageInOrigin: [3] uint32_t;
    stageInSize: [3] uint32_t;
}
MTLComputeCommandEncoder :: struct {
    setComputePipelineState :: (self: *MTLComputeCommandEncoder, state: id) -> () {
        invoke: (receiver: *MTLComputeCommandEncoder, selector: SEL, state: id) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setComputePipelineState:\0"), state);
    }
    setBytes_length_atIndex :: (self: *MTLComputeCommandEncoder, bytes: *void, length: NSUInteger, index: NSUInteger) -> () {
        invoke: (receiver: *MTLComputeCommandEncoder, selector: SEL, bytes: *void, length: NSUInteger, index: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setBytes:length:atIndex:\0"), bytes, length, index);
    }
    setBuffer_offset_atIndex :: (self: *MTLComputeCommandEncoder, buffer: id, offset: NSUInteger, index: NSUInteger) -> () {
        invoke: (receiver: *MTLComputeCommandEncoder, selector: SEL, buffer: id, offset: NSUInteger, index: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setBuffer:offset:atIndex:\0"), buffer, offset, index);
    }
    setBufferOffset_atIndex :: (self: *MTLComputeCommandEncoder, offset: NSUInteger, index: NSUInteger) -> () {
        invoke: (receiver: *MTLComputeCommandEncoder, selector: SEL, offset: NSUInteger, index: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setBufferOffset:atIndex:\0"), offset, index);
    }
    setBuffers_offsets_withRange :: (self: *MTLComputeCommandEncoder, buffers: *id, offsets: *NSUInteger, range: NSRange) -> () {
        invoke: (receiver: *MTLComputeCommandEncoder, selector: SEL, buffers: *id, offsets: *NSUInteger, range: NSRange) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setBuffers:offsets:withRange:\0"), buffers, offsets, range);
    }
    setTexture_atIndex :: (self: *MTLComputeCommandEncoder, texture: id, index: NSUInteger) -> () {
        invoke: (receiver: *MTLComputeCommandEncoder, selector: SEL, texture: id, index: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setTexture:atIndex:\0"), texture, index);
    }
    setTextures_withRange :: (self: *MTLComputeCommandEncoder, textures: *id, range: NSRange) -> () {
        invoke: (receiver: *MTLComputeCommandEncoder, selector: SEL, textures: *id, range: NSRange) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setTextures:withRange:\0"), textures, range);
    }
    setSamplerState_atIndex :: (self: *MTLComputeCommandEncoder, sampler: id, index: NSUInteger) -> () {
        invoke: (receiver: *MTLComputeCommandEncoder, selector: SEL, sampler: id, index: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setSamplerState:atIndex:\0"), sampler, index);
    }
    setSamplerStates_withRange :: (self: *MTLComputeCommandEncoder, samplers: *id, range: NSRange) -> () {
        invoke: (receiver: *MTLComputeCommandEncoder, selector: SEL, samplers: *id, range: NSRange) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setSamplerStates:withRange:\0"), samplers, range);
    }
    setSamplerState_lodMinClamp_lodMaxClamp_atIndex :: (self: *MTLComputeCommandEncoder, sampler: id, lodMinClamp: float32, lodMaxClamp: float32, index: NSUInteger) -> () {
        invoke: (receiver: *MTLComputeCommandEncoder, selector: SEL, sampler: id, lodMinClamp: float32, lodMaxClamp: float32, index: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setSamplerState:lodMinClamp:lodMaxClamp:atIndex:\0"), sampler, lodMinClamp, lodMaxClamp, index);
    }
    setSamplerStates_lodMinClamps_lodMaxClamps_withRange :: (self: *MTLComputeCommandEncoder, samplers: *id, lodMinClamps: *float32, lodMaxClamps: *float32, range: NSRange) -> () {
        invoke: (receiver: *MTLComputeCommandEncoder, selector: SEL, samplers: *id, lodMinClamps: *float32, lodMaxClamps: *float32, range: NSRange) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setSamplerStates:lodMinClamps:lodMaxClamps:withRange:\0"), samplers, lodMinClamps, lodMaxClamps, range);
    }
    setThreadgroupMemoryLength_atIndex :: (self: *MTLComputeCommandEncoder, length: NSUInteger, index: NSUInteger) -> () {
        invoke: (receiver: *MTLComputeCommandEncoder, selector: SEL, length: NSUInteger, index: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setThreadgroupMemoryLength:atIndex:\0"), length, index);
    }
    setStageInRegion :: (self: *MTLComputeCommandEncoder, region: MTLRegion) -> () {
        invoke: (receiver: *MTLComputeCommandEncoder, selector: SEL, region: MTLRegion) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setStageInRegion:\0"), region);
    }
    setStageInRegionWithIndirectBuffer_indirectBufferOffset :: (self: *MTLComputeCommandEncoder, indirectBuffer: id, indirectBufferOffset: NSUInteger) -> () {
        invoke: (receiver: *MTLComputeCommandEncoder, selector: SEL, indirectBuffer: id, indirectBufferOffset: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setStageInRegionWithIndirectBuffer:indirectBufferOffset:\0"), indirectBuffer, indirectBufferOffset);
    }
    dispatchThreadgroups_threadsPerThreadgroup :: (self: *MTLComputeCommandEncoder, threadgroupsPerGrid: MTLSize, threadsPerThreadgroup: MTLSize) -> () {
        invoke: (receiver: *MTLComputeCommandEncoder, selector: SEL, threadgroupsPerGrid: MTLSize, threadsPerThreadgroup: MTLSize) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "dispatchThreadgroups:threadsPerThreadgroup:\0"), threadgroupsPerGrid, threadsPerThreadgroup);
    }
    dispatchThreadgroupsWithIndirectBuffer_indirectBufferOffset_threadsPerThreadgroup :: (self: *MTLComputeCommandEncoder, indirectBuffer: id, indirectBufferOffset: NSUInteger, threadsPerThreadgroup: MTLSize) -> () {
        invoke: (receiver: *MTLComputeCommandEncoder, selector: SEL, indirectBuffer: id, indirectBufferOffset: NSUInteger, threadsPerThreadgroup: MTLSize) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "dispatchThreadgroupsWithIndirectBuffer:indirectBufferOffset:threadsPerThreadgroup:\0"), indirectBuffer, indirectBufferOffset, threadsPerThreadgroup);
    }
    dispatchThreads_threadsPerThreadgroup :: (self: *MTLComputeCommandEncoder, threadsPerGrid: MTLSize, threadsPerThreadgroup: MTLSize) -> () {
        invoke: (receiver: *MTLComputeCommandEncoder, selector: SEL, threadsPerGrid: MTLSize, threadsPerThreadgroup: MTLSize) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "dispatchThreads:threadsPerThreadgroup:\0"), threadsPerGrid, threadsPerThreadgroup);
    }
    updateFence :: (self: *MTLComputeCommandEncoder, fence: id) -> () {
        invoke: (receiver: *MTLComputeCommandEncoder, selector: SEL, fence: id) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "updateFence:\0"), fence);
    }
    waitForFence :: (self: *MTLComputeCommandEncoder, fence: id) -> () {
        invoke: (receiver: *MTLComputeCommandEncoder, selector: SEL, fence: id) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "waitForFence:\0"), fence);
    }
    useResource_usage :: (self: *MTLComputeCommandEncoder, resource: id, usage: MTLResourceUsage) -> () {
        invoke: (receiver: *MTLComputeCommandEncoder, selector: SEL, resource: id, usage: MTLResourceUsage) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "useResource:usage:\0"), resource, usage);
    }
    useResources_count_usage :: (self: *MTLComputeCommandEncoder, resources: *id, count: NSUInteger, usage: MTLResourceUsage) -> () {
        invoke: (receiver: *MTLComputeCommandEncoder, selector: SEL, resources: *id, count: NSUInteger, usage: MTLResourceUsage) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "useResources:count:usage:\0"), resources, count, usage);
    }
    useHeap :: (self: *MTLComputeCommandEncoder, heap: id) -> () {
        invoke: (receiver: *MTLComputeCommandEncoder, selector: SEL, heap: id) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "useHeap:\0"), heap);
    }
    useHeaps_count :: (self: *MTLComputeCommandEncoder, heaps: *id, count: NSUInteger) -> () {
        invoke: (receiver: *MTLComputeCommandEncoder, selector: SEL, heaps: *id, count: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "useHeaps:count:\0"), heaps, count);
    }
    memoryBarrierWithScope :: (self: *MTLComputeCommandEncoder, scope: MTLBarrierScope) -> () {
        invoke: (receiver: *MTLComputeCommandEncoder, selector: SEL, scope: MTLBarrierScope) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "memoryBarrierWithScope:\0"), scope);
    }
    memoryBarrierWithResources_count :: (self: *MTLComputeCommandEncoder, resources: *id, count: NSUInteger) -> () {
        invoke: (receiver: *MTLComputeCommandEncoder, selector: SEL, resources: *id, count: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "memoryBarrierWithResources:count:\0"), resources, count);
    }
    dispatchType :: (self: *MTLComputeCommandEncoder) -> MTLDispatchType {
        invoke: (receiver: *MTLComputeCommandEncoder, selector: SEL) -> MTLDispatchType #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "dispatchType\0"));
    }
}
MTLCommandQueue :: struct {
    commandBuffer :: (self: *MTLCommandQueue) -> *MTLCommandBuffer {
        invoke: (receiver: *MTLCommandQueue, selector: SEL) -> *MTLCommandBuffer #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "commandBuffer\0"));
    }
    commandBufferWithUnretainedReferences :: (self: *MTLCommandQueue) -> *MTLCommandBuffer {
        invoke: (receiver: *MTLCommandQueue, selector: SEL) -> *MTLCommandBuffer #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "commandBufferWithUnretainedReferences\0"));
    }
    insertDebugCaptureBoundary :: (self: *MTLCommandQueue) -> () {
        invoke: (receiver: *MTLCommandQueue, selector: SEL) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "insertDebugCaptureBoundary\0"));
    }
    label :: (self: *MTLCommandQueue) -> *NSString {
        invoke: (receiver: *MTLCommandQueue, selector: SEL) -> *NSString #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "label\0"));
    }
    setLabel :: (self: *MTLCommandQueue, label: *NSString) -> () {
        invoke: (receiver: *MTLCommandQueue, selector: SEL, label: *NSString) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setLabel:\0"), label);
    }
    device :: (self: *MTLCommandQueue) -> id {
        invoke: (receiver: *MTLCommandQueue, selector: SEL) -> id #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "device\0"));
    }
}
using MTLCompareFunction :: enum NSUInteger {
    MTLCompareFunctionNever :: 0;
    MTLCompareFunctionLess :: 1;
    MTLCompareFunctionEqual :: 2;
    MTLCompareFunctionLessEqual :: 3;
    MTLCompareFunctionGreater :: 4;
    MTLCompareFunctionNotEqual :: 5;
    MTLCompareFunctionGreaterEqual :: 6;
    MTLCompareFunctionAlways :: 7;
}
using MTLStencilOperation :: enum NSUInteger {
    MTLStencilOperationKeep :: 0;
    MTLStencilOperationZero :: 1;
    MTLStencilOperationReplace :: 2;
    MTLStencilOperationIncrementClamp :: 3;
    MTLStencilOperationDecrementClamp :: 4;
    MTLStencilOperationInvert :: 5;
    MTLStencilOperationIncrementWrap :: 6;
    MTLStencilOperationDecrementWrap :: 7;
}
MTLStencilDescriptor :: struct {
    nsobject: NSObject;
    stencilCompareFunction :: (self: *MTLStencilDescriptor) -> MTLCompareFunction {
        invoke: (receiver: *MTLStencilDescriptor, selector: SEL) -> MTLCompareFunction #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "stencilCompareFunction\0"));
    }
    setStencilCompareFunction :: (self: *MTLStencilDescriptor, stencilCompareFunction: MTLCompareFunction) -> () {
        invoke: (receiver: *MTLStencilDescriptor, selector: SEL, stencilCompareFunction: MTLCompareFunction) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setStencilCompareFunction:\0"), stencilCompareFunction);
    }
    stencilFailureOperation :: (self: *MTLStencilDescriptor) -> MTLStencilOperation {
        invoke: (receiver: *MTLStencilDescriptor, selector: SEL) -> MTLStencilOperation #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "stencilFailureOperation\0"));
    }
    setStencilFailureOperation :: (self: *MTLStencilDescriptor, stencilFailureOperation: MTLStencilOperation) -> () {
        invoke: (receiver: *MTLStencilDescriptor, selector: SEL, stencilFailureOperation: MTLStencilOperation) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setStencilFailureOperation:\0"), stencilFailureOperation);
    }
    depthFailureOperation :: (self: *MTLStencilDescriptor) -> MTLStencilOperation {
        invoke: (receiver: *MTLStencilDescriptor, selector: SEL) -> MTLStencilOperation #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "depthFailureOperation\0"));
    }
    setDepthFailureOperation :: (self: *MTLStencilDescriptor, depthFailureOperation: MTLStencilOperation) -> () {
        invoke: (receiver: *MTLStencilDescriptor, selector: SEL, depthFailureOperation: MTLStencilOperation) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setDepthFailureOperation:\0"), depthFailureOperation);
    }
    depthStencilPassOperation :: (self: *MTLStencilDescriptor) -> MTLStencilOperation {
        invoke: (receiver: *MTLStencilDescriptor, selector: SEL) -> MTLStencilOperation #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "depthStencilPassOperation\0"));
    }
    setDepthStencilPassOperation :: (self: *MTLStencilDescriptor, depthStencilPassOperation: MTLStencilOperation) -> () {
        invoke: (receiver: *MTLStencilDescriptor, selector: SEL, depthStencilPassOperation: MTLStencilOperation) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setDepthStencilPassOperation:\0"), depthStencilPassOperation);
    }
    readMask :: (self: *MTLStencilDescriptor) -> uint32_t {
        invoke: (receiver: *MTLStencilDescriptor, selector: SEL) -> uint32_t #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "readMask\0"));
    }
    setReadMask :: (self: *MTLStencilDescriptor, readMask: uint32_t) -> () {
        invoke: (receiver: *MTLStencilDescriptor, selector: SEL, readMask: uint32_t) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setReadMask:\0"), readMask);
    }
    writeMask :: (self: *MTLStencilDescriptor) -> uint32_t {
        invoke: (receiver: *MTLStencilDescriptor, selector: SEL) -> uint32_t #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "writeMask\0"));
    }
    setWriteMask :: (self: *MTLStencilDescriptor, writeMask: uint32_t) -> () {
        invoke: (receiver: *MTLStencilDescriptor, selector: SEL, writeMask: uint32_t) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setWriteMask:\0"), writeMask);
    }
}
MTLDepthStencilDescriptor :: struct {
    nsobject: NSObject;
    depthCompareFunction :: (self: *MTLDepthStencilDescriptor) -> MTLCompareFunction {
        invoke: (receiver: *MTLDepthStencilDescriptor, selector: SEL) -> MTLCompareFunction #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "depthCompareFunction\0"));
    }
    setDepthCompareFunction :: (self: *MTLDepthStencilDescriptor, depthCompareFunction: MTLCompareFunction) -> () {
        invoke: (receiver: *MTLDepthStencilDescriptor, selector: SEL, depthCompareFunction: MTLCompareFunction) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setDepthCompareFunction:\0"), depthCompareFunction);
    }
    isDepthWriteEnabled :: (self: *MTLDepthStencilDescriptor) -> BOOL {
        invoke: (receiver: *MTLDepthStencilDescriptor, selector: SEL) -> BOOL #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "isDepthWriteEnabled\0"));
    }
    setDepthWriteEnabled :: (self: *MTLDepthStencilDescriptor, depthWriteEnabled: BOOL) -> () {
        invoke: (receiver: *MTLDepthStencilDescriptor, selector: SEL, depthWriteEnabled: BOOL) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setDepthWriteEnabled:\0"), depthWriteEnabled);
    }
    frontFaceStencil :: (self: *MTLDepthStencilDescriptor) -> *MTLStencilDescriptor {
        invoke: (receiver: *MTLDepthStencilDescriptor, selector: SEL) -> *MTLStencilDescriptor #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "frontFaceStencil\0"));
    }
    setFrontFaceStencil :: (self: *MTLDepthStencilDescriptor, frontFaceStencil: *MTLStencilDescriptor) -> () {
        invoke: (receiver: *MTLDepthStencilDescriptor, selector: SEL, frontFaceStencil: *MTLStencilDescriptor) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setFrontFaceStencil:\0"), frontFaceStencil);
    }
    backFaceStencil :: (self: *MTLDepthStencilDescriptor) -> *MTLStencilDescriptor {
        invoke: (receiver: *MTLDepthStencilDescriptor, selector: SEL) -> *MTLStencilDescriptor #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "backFaceStencil\0"));
    }
    setBackFaceStencil :: (self: *MTLDepthStencilDescriptor, backFaceStencil: *MTLStencilDescriptor) -> () {
        invoke: (receiver: *MTLDepthStencilDescriptor, selector: SEL, backFaceStencil: *MTLStencilDescriptor) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setBackFaceStencil:\0"), backFaceStencil);
    }
    label :: (self: *MTLDepthStencilDescriptor) -> *NSString {
        invoke: (receiver: *MTLDepthStencilDescriptor, selector: SEL) -> *NSString #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "label\0"));
    }
    setLabel :: (self: *MTLDepthStencilDescriptor, label: *NSString) -> () {
        invoke: (receiver: *MTLDepthStencilDescriptor, selector: SEL, label: *NSString) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setLabel:\0"), label);
    }
}
MTLDepthStencilState :: struct {
    label :: (self: *MTLDepthStencilState) -> *NSString {
        invoke: (receiver: *MTLDepthStencilState, selector: SEL) -> *NSString #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "label\0"));
    }
    device :: (self: *MTLDepthStencilState) -> id {
        invoke: (receiver: *MTLDepthStencilState, selector: SEL) -> id #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "device\0"));
    }
}
MTLDrawable :: struct {
    present :: (self: *MTLDrawable) -> () {
        invoke: (receiver: *MTLDrawable, selector: SEL) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "present\0"));
    }
    presentAtTime :: (self: *MTLDrawable, presentationTime: CFTimeInterval) -> () {
        invoke: (receiver: *MTLDrawable, selector: SEL, presentationTime: CFTimeInterval) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "presentAtTime:\0"), presentationTime);
    }
}
using MTLLoadAction :: enum NSUInteger {
    MTLLoadActionDontCare :: 0;
    MTLLoadActionLoad :: 1;
    MTLLoadActionClear :: 2;
}
using MTLStoreAction :: enum NSUInteger {
    MTLStoreActionDontCare :: 0;
    MTLStoreActionStore :: 1;
    MTLStoreActionMultisampleResolve :: 2;
    MTLStoreActionStoreAndMultisampleResolve :: 3;
    MTLStoreActionUnknown :: 4;
    MTLStoreActionCustomSampleDepthStore :: 5;
}
using MTLStoreActionOptions :: enum NSUInteger {
    MTLStoreActionOptionNone :: 0;
    MTLStoreActionOptionCustomSamplePositions :: 1;
}
MTLClearColor :: struct {
    red: float64;
    green: float64;
    blue: float64;
    alpha: float64;
}
MTLRenderPassAttachmentDescriptor :: struct {
    nsobject: NSObject;
    texture :: (self: *MTLRenderPassAttachmentDescriptor) -> id {
        invoke: (receiver: *MTLRenderPassAttachmentDescriptor, selector: SEL) -> id #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "texture\0"));
    }
    setTexture :: (self: *MTLRenderPassAttachmentDescriptor, texture: id) -> () {
        invoke: (receiver: *MTLRenderPassAttachmentDescriptor, selector: SEL, texture: id) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setTexture:\0"), texture);
    }
    level :: (self: *MTLRenderPassAttachmentDescriptor) -> NSUInteger {
        invoke: (receiver: *MTLRenderPassAttachmentDescriptor, selector: SEL) -> NSUInteger #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "level\0"));
    }
    setLevel :: (self: *MTLRenderPassAttachmentDescriptor, level: NSUInteger) -> () {
        invoke: (receiver: *MTLRenderPassAttachmentDescriptor, selector: SEL, level: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setLevel:\0"), level);
    }
    slice :: (self: *MTLRenderPassAttachmentDescriptor) -> NSUInteger {
        invoke: (receiver: *MTLRenderPassAttachmentDescriptor, selector: SEL) -> NSUInteger #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "slice\0"));
    }
    setSlice :: (self: *MTLRenderPassAttachmentDescriptor, slice: NSUInteger) -> () {
        invoke: (receiver: *MTLRenderPassAttachmentDescriptor, selector: SEL, slice: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setSlice:\0"), slice);
    }
    depthPlane :: (self: *MTLRenderPassAttachmentDescriptor) -> NSUInteger {
        invoke: (receiver: *MTLRenderPassAttachmentDescriptor, selector: SEL) -> NSUInteger #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "depthPlane\0"));
    }
    setDepthPlane :: (self: *MTLRenderPassAttachmentDescriptor, depthPlane: NSUInteger) -> () {
        invoke: (receiver: *MTLRenderPassAttachmentDescriptor, selector: SEL, depthPlane: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setDepthPlane:\0"), depthPlane);
    }
    resolveTexture :: (self: *MTLRenderPassAttachmentDescriptor) -> id {
        invoke: (receiver: *MTLRenderPassAttachmentDescriptor, selector: SEL) -> id #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "resolveTexture\0"));
    }
    setResolveTexture :: (self: *MTLRenderPassAttachmentDescriptor, resolveTexture: id) -> () {
        invoke: (receiver: *MTLRenderPassAttachmentDescriptor, selector: SEL, resolveTexture: id) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setResolveTexture:\0"), resolveTexture);
    }
    resolveLevel :: (self: *MTLRenderPassAttachmentDescriptor) -> NSUInteger {
        invoke: (receiver: *MTLRenderPassAttachmentDescriptor, selector: SEL) -> NSUInteger #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "resolveLevel\0"));
    }
    setResolveLevel :: (self: *MTLRenderPassAttachmentDescriptor, resolveLevel: NSUInteger) -> () {
        invoke: (receiver: *MTLRenderPassAttachmentDescriptor, selector: SEL, resolveLevel: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setResolveLevel:\0"), resolveLevel);
    }
    resolveSlice :: (self: *MTLRenderPassAttachmentDescriptor) -> NSUInteger {
        invoke: (receiver: *MTLRenderPassAttachmentDescriptor, selector: SEL) -> NSUInteger #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "resolveSlice\0"));
    }
    setResolveSlice :: (self: *MTLRenderPassAttachmentDescriptor, resolveSlice: NSUInteger) -> () {
        invoke: (receiver: *MTLRenderPassAttachmentDescriptor, selector: SEL, resolveSlice: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setResolveSlice:\0"), resolveSlice);
    }
    resolveDepthPlane :: (self: *MTLRenderPassAttachmentDescriptor) -> NSUInteger {
        invoke: (receiver: *MTLRenderPassAttachmentDescriptor, selector: SEL) -> NSUInteger #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "resolveDepthPlane\0"));
    }
    setResolveDepthPlane :: (self: *MTLRenderPassAttachmentDescriptor, resolveDepthPlane: NSUInteger) -> () {
        invoke: (receiver: *MTLRenderPassAttachmentDescriptor, selector: SEL, resolveDepthPlane: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setResolveDepthPlane:\0"), resolveDepthPlane);
    }
    loadAction :: (self: *MTLRenderPassAttachmentDescriptor) -> MTLLoadAction {
        invoke: (receiver: *MTLRenderPassAttachmentDescriptor, selector: SEL) -> MTLLoadAction #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "loadAction\0"));
    }
    setLoadAction :: (self: *MTLRenderPassAttachmentDescriptor, loadAction: MTLLoadAction) -> () {
        invoke: (receiver: *MTLRenderPassAttachmentDescriptor, selector: SEL, loadAction: MTLLoadAction) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setLoadAction:\0"), loadAction);
    }
    storeAction :: (self: *MTLRenderPassAttachmentDescriptor) -> MTLStoreAction {
        invoke: (receiver: *MTLRenderPassAttachmentDescriptor, selector: SEL) -> MTLStoreAction #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "storeAction\0"));
    }
    setStoreAction :: (self: *MTLRenderPassAttachmentDescriptor, storeAction: MTLStoreAction) -> () {
        invoke: (receiver: *MTLRenderPassAttachmentDescriptor, selector: SEL, storeAction: MTLStoreAction) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setStoreAction:\0"), storeAction);
    }
    storeActionOptions :: (self: *MTLRenderPassAttachmentDescriptor) -> MTLStoreActionOptions {
        invoke: (receiver: *MTLRenderPassAttachmentDescriptor, selector: SEL) -> MTLStoreActionOptions #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "storeActionOptions\0"));
    }
    setStoreActionOptions :: (self: *MTLRenderPassAttachmentDescriptor, storeActionOptions: MTLStoreActionOptions) -> () {
        invoke: (receiver: *MTLRenderPassAttachmentDescriptor, selector: SEL, storeActionOptions: MTLStoreActionOptions) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setStoreActionOptions:\0"), storeActionOptions);
    }
}
MTLRenderPassColorAttachmentDescriptor :: struct {
    using #as mtlrenderpassattachmentdescriptor: MTLRenderPassAttachmentDescriptor;
    clearColor :: (self: *MTLRenderPassColorAttachmentDescriptor) -> MTLClearColor {
        #if CPU == .X64 {
            value: MTLClearColor;
            send_stret: (output: *MTLClearColor, receiver: *MTLRenderPassColorAttachmentDescriptor, selector: SEL) -> void #c_call;
            send_stret = cast(type_of(send_stret)) objc_msgSend_stret;
            send_stret(*value, self, sel_registerName(cast(*u8) "clearColor\0"));
            return value;
        } else {
            invoke: (receiver: *MTLRenderPassColorAttachmentDescriptor, selector: SEL) -> MTLClearColor #c_call;
            invoke = cast(type_of(invoke)) objc_msgSend;
            return invoke(self, sel_registerName(cast(*u8) "clearColor\0"));
        }
    }
    setClearColor :: (self: *MTLRenderPassColorAttachmentDescriptor, clearColor: MTLClearColor) -> () {
        invoke: (receiver: *MTLRenderPassColorAttachmentDescriptor, selector: SEL, clearColor: MTLClearColor) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setClearColor:\0"), clearColor);
    }
}
using MTLMultisampleDepthResolveFilter :: enum NSUInteger {
    MTLMultisampleDepthResolveFilterSample0 :: 0;
    MTLMultisampleDepthResolveFilterMin :: 1;
    MTLMultisampleDepthResolveFilterMax :: 2;
}
MTLRenderPassDepthAttachmentDescriptor :: struct {
    mtlrenderpassattachmentdescriptor: MTLRenderPassAttachmentDescriptor;
    clearDepth :: (self: *MTLRenderPassDepthAttachmentDescriptor) -> float64 {
        invoke: (receiver: *MTLRenderPassDepthAttachmentDescriptor, selector: SEL) -> float64 #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "clearDepth\0"));
    }
    setClearDepth :: (self: *MTLRenderPassDepthAttachmentDescriptor, clearDepth: float64) -> () {
        invoke: (receiver: *MTLRenderPassDepthAttachmentDescriptor, selector: SEL, clearDepth: float64) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setClearDepth:\0"), clearDepth);
    }
    depthResolveFilter :: (self: *MTLRenderPassDepthAttachmentDescriptor) -> MTLMultisampleDepthResolveFilter {
        invoke: (receiver: *MTLRenderPassDepthAttachmentDescriptor, selector: SEL) -> MTLMultisampleDepthResolveFilter #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "depthResolveFilter\0"));
    }
    setDepthResolveFilter :: (self: *MTLRenderPassDepthAttachmentDescriptor, depthResolveFilter: MTLMultisampleDepthResolveFilter) -> () {
        invoke: (receiver: *MTLRenderPassDepthAttachmentDescriptor, selector: SEL, depthResolveFilter: MTLMultisampleDepthResolveFilter) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setDepthResolveFilter:\0"), depthResolveFilter);
    }
}
using MTLMultisampleStencilResolveFilter :: enum NSUInteger {
    MTLMultisampleStencilResolveFilterSample0 :: 0;
    MTLMultisampleStencilResolveFilterDepthResolvedSample :: 1;
}
MTLRenderPassStencilAttachmentDescriptor :: struct {
    mtlrenderpassattachmentdescriptor: MTLRenderPassAttachmentDescriptor;
    clearStencil :: (self: *MTLRenderPassStencilAttachmentDescriptor) -> uint32_t {
        invoke: (receiver: *MTLRenderPassStencilAttachmentDescriptor, selector: SEL) -> uint32_t #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "clearStencil\0"));
    }
    setClearStencil :: (self: *MTLRenderPassStencilAttachmentDescriptor, clearStencil: uint32_t) -> () {
        invoke: (receiver: *MTLRenderPassStencilAttachmentDescriptor, selector: SEL, clearStencil: uint32_t) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setClearStencil:\0"), clearStencil);
    }
    stencilResolveFilter :: (self: *MTLRenderPassStencilAttachmentDescriptor) -> MTLMultisampleStencilResolveFilter {
        invoke: (receiver: *MTLRenderPassStencilAttachmentDescriptor, selector: SEL) -> MTLMultisampleStencilResolveFilter #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "stencilResolveFilter\0"));
    }
    setStencilResolveFilter :: (self: *MTLRenderPassStencilAttachmentDescriptor, stencilResolveFilter: MTLMultisampleStencilResolveFilter) -> () {
        invoke: (receiver: *MTLRenderPassStencilAttachmentDescriptor, selector: SEL, stencilResolveFilter: MTLMultisampleStencilResolveFilter) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setStencilResolveFilter:\0"), stencilResolveFilter);
    }
}
MTLRenderPassColorAttachmentDescriptorArray :: struct {
    nsobject: NSObject;
    objectAtIndexedSubscript :: (self: *MTLRenderPassColorAttachmentDescriptorArray, attachmentIndex: NSUInteger) -> *MTLRenderPassColorAttachmentDescriptor {
        invoke: (receiver: *MTLRenderPassColorAttachmentDescriptorArray, selector: SEL, attachmentIndex: NSUInteger) -> *MTLRenderPassColorAttachmentDescriptor #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "objectAtIndexedSubscript:\0"), attachmentIndex);
    }
    setObject_atIndexedSubscript :: (self: *MTLRenderPassColorAttachmentDescriptorArray, attachment: *MTLRenderPassColorAttachmentDescriptor, attachmentIndex: NSUInteger) -> () {
        invoke: (receiver: *MTLRenderPassColorAttachmentDescriptorArray, selector: SEL, attachment: *MTLRenderPassColorAttachmentDescriptor, attachmentIndex: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setObject:atIndexedSubscript:\0"), attachment, attachmentIndex);
    }
}
MTLRenderPassDescriptor :: struct {
    nsobject: NSObject;
    renderPassDescriptor :: () -> *MTLRenderPassDescriptor {
        invoke: (receiver: Class, selector: SEL) -> *MTLRenderPassDescriptor #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(objc_getClass(cast(*u8) "MTLRenderPassDescriptor\0"), sel_registerName(cast(*u8) "renderPassDescriptor\0"));
    }
    setSamplePositions_count :: (self: *MTLRenderPassDescriptor, positions: *MTLSamplePosition, count: NSUInteger) -> () {
        invoke: (receiver: *MTLRenderPassDescriptor, selector: SEL, positions: *MTLSamplePosition, count: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setSamplePositions:count:\0"), positions, count);
    }
    getSamplePositions_count :: (self: *MTLRenderPassDescriptor, positions: *MTLSamplePosition, count: NSUInteger) -> NSUInteger {
        invoke: (receiver: *MTLRenderPassDescriptor, selector: SEL, positions: *MTLSamplePosition, count: NSUInteger) -> NSUInteger #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "getSamplePositions:count:\0"), positions, count);
    }
    colorAttachments :: (self: *MTLRenderPassDescriptor) -> *MTLRenderPassColorAttachmentDescriptorArray {
        invoke: (receiver: *MTLRenderPassDescriptor, selector: SEL) -> *MTLRenderPassColorAttachmentDescriptorArray #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "colorAttachments\0"));
    }
    depthAttachment :: (self: *MTLRenderPassDescriptor) -> *MTLRenderPassDepthAttachmentDescriptor {
        invoke: (receiver: *MTLRenderPassDescriptor, selector: SEL) -> *MTLRenderPassDepthAttachmentDescriptor #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "depthAttachment\0"));
    }
    setDepthAttachment :: (self: *MTLRenderPassDescriptor, depthAttachment: *MTLRenderPassDepthAttachmentDescriptor) -> () {
        invoke: (receiver: *MTLRenderPassDescriptor, selector: SEL, depthAttachment: *MTLRenderPassDepthAttachmentDescriptor) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setDepthAttachment:\0"), depthAttachment);
    }
    stencilAttachment :: (self: *MTLRenderPassDescriptor) -> *MTLRenderPassStencilAttachmentDescriptor {
        invoke: (receiver: *MTLRenderPassDescriptor, selector: SEL) -> *MTLRenderPassStencilAttachmentDescriptor #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "stencilAttachment\0"));
    }
    setStencilAttachment :: (self: *MTLRenderPassDescriptor, stencilAttachment: *MTLRenderPassStencilAttachmentDescriptor) -> () {
        invoke: (receiver: *MTLRenderPassDescriptor, selector: SEL, stencilAttachment: *MTLRenderPassStencilAttachmentDescriptor) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setStencilAttachment:\0"), stencilAttachment);
    }
    visibilityResultBuffer :: (self: *MTLRenderPassDescriptor) -> id {
        invoke: (receiver: *MTLRenderPassDescriptor, selector: SEL) -> id #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "visibilityResultBuffer\0"));
    }
    setVisibilityResultBuffer :: (self: *MTLRenderPassDescriptor, visibilityResultBuffer: id) -> () {
        invoke: (receiver: *MTLRenderPassDescriptor, selector: SEL, visibilityResultBuffer: id) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setVisibilityResultBuffer:\0"), visibilityResultBuffer);
    }
    renderTargetArrayLength :: (self: *MTLRenderPassDescriptor) -> NSUInteger {
        invoke: (receiver: *MTLRenderPassDescriptor, selector: SEL) -> NSUInteger #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "renderTargetArrayLength\0"));
    }
    setRenderTargetArrayLength :: (self: *MTLRenderPassDescriptor, renderTargetArrayLength: NSUInteger) -> () {
        invoke: (receiver: *MTLRenderPassDescriptor, selector: SEL, renderTargetArrayLength: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setRenderTargetArrayLength:\0"), renderTargetArrayLength);
    }
}
MTLClearColorMake :: (red: float64, green: float64, blue: float64, alpha: float64) -> MTLClearColor {
    result: MTLClearColor;
    result.red = red;
    result.green = green;
    result.blue = blue;
    result.alpha = alpha;
    return result;
}
using MTLAttributeFormat :: enum NSUInteger {
    MTLAttributeFormatInvalid :: 0;
    MTLAttributeFormatUChar2 :: 1;
    MTLAttributeFormatUChar3 :: 2;
    MTLAttributeFormatUChar4 :: 3;
    MTLAttributeFormatChar2 :: 4;
    MTLAttributeFormatChar3 :: 5;
    MTLAttributeFormatChar4 :: 6;
    MTLAttributeFormatUChar2Normalized :: 7;
    MTLAttributeFormatUChar3Normalized :: 8;
    MTLAttributeFormatUChar4Normalized :: 9;
    MTLAttributeFormatChar2Normalized :: 10;
    MTLAttributeFormatChar3Normalized :: 11;
    MTLAttributeFormatChar4Normalized :: 12;
    MTLAttributeFormatUShort2 :: 13;
    MTLAttributeFormatUShort3 :: 14;
    MTLAttributeFormatUShort4 :: 15;
    MTLAttributeFormatShort2 :: 16;
    MTLAttributeFormatShort3 :: 17;
    MTLAttributeFormatShort4 :: 18;
    MTLAttributeFormatUShort2Normalized :: 19;
    MTLAttributeFormatUShort3Normalized :: 20;
    MTLAttributeFormatUShort4Normalized :: 21;
    MTLAttributeFormatShort2Normalized :: 22;
    MTLAttributeFormatShort3Normalized :: 23;
    MTLAttributeFormatShort4Normalized :: 24;
    MTLAttributeFormatHalf2 :: 25;
    MTLAttributeFormatHalf3 :: 26;
    MTLAttributeFormatHalf4 :: 27;
    MTLAttributeFormatFloat :: 28;
    MTLAttributeFormatFloat2 :: 29;
    MTLAttributeFormatFloat3 :: 30;
    MTLAttributeFormatFloat4 :: 31;
    MTLAttributeFormatInt :: 32;
    MTLAttributeFormatInt2 :: 33;
    MTLAttributeFormatInt3 :: 34;
    MTLAttributeFormatInt4 :: 35;
    MTLAttributeFormatUInt :: 36;
    MTLAttributeFormatUInt2 :: 37;
    MTLAttributeFormatUInt3 :: 38;
    MTLAttributeFormatUInt4 :: 39;
    MTLAttributeFormatInt1010102Normalized :: 40;
    MTLAttributeFormatUInt1010102Normalized :: 41;
    MTLAttributeFormatUChar4Normalized_BGRA :: 42;
    MTLAttributeFormatUChar :: 45;
    MTLAttributeFormatChar :: 46;
    MTLAttributeFormatUCharNormalized :: 47;
    MTLAttributeFormatCharNormalized :: 48;
    MTLAttributeFormatUShort :: 49;
    MTLAttributeFormatShort :: 50;
    MTLAttributeFormatUShortNormalized :: 51;
    MTLAttributeFormatShortNormalized :: 52;
    MTLAttributeFormatHalf :: 53;
}
using MTLIndexType :: enum NSUInteger {
    MTLIndexTypeUInt16 :: 0;
    MTLIndexTypeUInt32 :: 1;
}
using MTLStepFunction :: enum NSUInteger {
    MTLStepFunctionConstant :: 0;
    MTLStepFunctionPerVertex :: 1;
    MTLStepFunctionPerInstance :: 2;
    MTLStepFunctionPerPatch :: 3;
    MTLStepFunctionPerPatchControlPoint :: 4;
    MTLStepFunctionThreadPositionInGridX :: 5;
    MTLStepFunctionThreadPositionInGridY :: 6;
    MTLStepFunctionThreadPositionInGridXIndexed :: 7;
    MTLStepFunctionThreadPositionInGridYIndexed :: 8;
}
MTLBufferLayoutDescriptor :: struct {
    nsobject: NSObject;
    stride :: (self: *MTLBufferLayoutDescriptor) -> NSUInteger {
        invoke: (receiver: *MTLBufferLayoutDescriptor, selector: SEL) -> NSUInteger #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "stride\0"));
    }
    setStride :: (self: *MTLBufferLayoutDescriptor, stride: NSUInteger) -> () {
        invoke: (receiver: *MTLBufferLayoutDescriptor, selector: SEL, stride: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setStride:\0"), stride);
    }
    stepFunction :: (self: *MTLBufferLayoutDescriptor) -> MTLStepFunction {
        invoke: (receiver: *MTLBufferLayoutDescriptor, selector: SEL) -> MTLStepFunction #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "stepFunction\0"));
    }
    setStepFunction :: (self: *MTLBufferLayoutDescriptor, stepFunction: MTLStepFunction) -> () {
        invoke: (receiver: *MTLBufferLayoutDescriptor, selector: SEL, stepFunction: MTLStepFunction) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setStepFunction:\0"), stepFunction);
    }
    stepRate :: (self: *MTLBufferLayoutDescriptor) -> NSUInteger {
        invoke: (receiver: *MTLBufferLayoutDescriptor, selector: SEL) -> NSUInteger #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "stepRate\0"));
    }
    setStepRate :: (self: *MTLBufferLayoutDescriptor, stepRate: NSUInteger) -> () {
        invoke: (receiver: *MTLBufferLayoutDescriptor, selector: SEL, stepRate: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setStepRate:\0"), stepRate);
    }
}
MTLBufferLayoutDescriptorArray :: struct {
    nsobject: NSObject;
    objectAtIndexedSubscript :: (self: *MTLBufferLayoutDescriptorArray, index: NSUInteger) -> *MTLBufferLayoutDescriptor {
        invoke: (receiver: *MTLBufferLayoutDescriptorArray, selector: SEL, index: NSUInteger) -> *MTLBufferLayoutDescriptor #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "objectAtIndexedSubscript:\0"), index);
    }
    setObject_atIndexedSubscript :: (self: *MTLBufferLayoutDescriptorArray, bufferDesc: *MTLBufferLayoutDescriptor, index: NSUInteger) -> () {
        invoke: (receiver: *MTLBufferLayoutDescriptorArray, selector: SEL, bufferDesc: *MTLBufferLayoutDescriptor, index: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setObject:atIndexedSubscript:\0"), bufferDesc, index);
    }
}
MTLAttributeDescriptor :: struct {
    nsobject: NSObject;
    format :: (self: *MTLAttributeDescriptor) -> MTLAttributeFormat {
        invoke: (receiver: *MTLAttributeDescriptor, selector: SEL) -> MTLAttributeFormat #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "format\0"));
    }
    setFormat :: (self: *MTLAttributeDescriptor, format: MTLAttributeFormat) -> () {
        invoke: (receiver: *MTLAttributeDescriptor, selector: SEL, format: MTLAttributeFormat) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setFormat:\0"), format);
    }
    offset :: (self: *MTLAttributeDescriptor) -> NSUInteger {
        invoke: (receiver: *MTLAttributeDescriptor, selector: SEL) -> NSUInteger #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "offset\0"));
    }
    setOffset :: (self: *MTLAttributeDescriptor, offset: NSUInteger) -> () {
        invoke: (receiver: *MTLAttributeDescriptor, selector: SEL, offset: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setOffset:\0"), offset);
    }
    bufferIndex :: (self: *MTLAttributeDescriptor) -> NSUInteger {
        invoke: (receiver: *MTLAttributeDescriptor, selector: SEL) -> NSUInteger #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "bufferIndex\0"));
    }
    setBufferIndex :: (self: *MTLAttributeDescriptor, bufferIndex: NSUInteger) -> () {
        invoke: (receiver: *MTLAttributeDescriptor, selector: SEL, bufferIndex: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setBufferIndex:\0"), bufferIndex);
    }
}
MTLAttributeDescriptorArray :: struct {
    nsobject: NSObject;
    objectAtIndexedSubscript :: (self: *MTLAttributeDescriptorArray, index: NSUInteger) -> *MTLAttributeDescriptor {
        invoke: (receiver: *MTLAttributeDescriptorArray, selector: SEL, index: NSUInteger) -> *MTLAttributeDescriptor #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "objectAtIndexedSubscript:\0"), index);
    }
    setObject_atIndexedSubscript :: (self: *MTLAttributeDescriptorArray, attributeDesc: *MTLAttributeDescriptor, index: NSUInteger) -> () {
        invoke: (receiver: *MTLAttributeDescriptorArray, selector: SEL, attributeDesc: *MTLAttributeDescriptor, index: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setObject:atIndexedSubscript:\0"), attributeDesc, index);
    }
}
MTLStageInputOutputDescriptor :: struct {
    nsobject: NSObject;
    stageInputOutputDescriptor :: () -> *MTLStageInputOutputDescriptor {
        invoke: (receiver: Class, selector: SEL) -> *MTLStageInputOutputDescriptor #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(objc_getClass(cast(*u8) "MTLStageInputOutputDescriptor\0"), sel_registerName(cast(*u8) "stageInputOutputDescriptor\0"));
    }
    reset :: (self: *MTLStageInputOutputDescriptor) -> () {
        invoke: (receiver: *MTLStageInputOutputDescriptor, selector: SEL) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "reset\0"));
    }
    layouts :: (self: *MTLStageInputOutputDescriptor) -> *MTLBufferLayoutDescriptorArray {
        invoke: (receiver: *MTLStageInputOutputDescriptor, selector: SEL) -> *MTLBufferLayoutDescriptorArray #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "layouts\0"));
    }
    attributes :: (self: *MTLStageInputOutputDescriptor) -> *MTLAttributeDescriptorArray {
        invoke: (receiver: *MTLStageInputOutputDescriptor, selector: SEL) -> *MTLAttributeDescriptorArray #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "attributes\0"));
    }
    indexType :: (self: *MTLStageInputOutputDescriptor) -> MTLIndexType {
        invoke: (receiver: *MTLStageInputOutputDescriptor, selector: SEL) -> MTLIndexType #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "indexType\0"));
    }
    setIndexType :: (self: *MTLStageInputOutputDescriptor, indexType: MTLIndexType) -> () {
        invoke: (receiver: *MTLStageInputOutputDescriptor, selector: SEL, indexType: MTLIndexType) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setIndexType:\0"), indexType);
    }
    indexBufferIndex :: (self: *MTLStageInputOutputDescriptor) -> NSUInteger {
        invoke: (receiver: *MTLStageInputOutputDescriptor, selector: SEL) -> NSUInteger #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "indexBufferIndex\0"));
    }
    setIndexBufferIndex :: (self: *MTLStageInputOutputDescriptor, indexBufferIndex: NSUInteger) -> () {
        invoke: (receiver: *MTLStageInputOutputDescriptor, selector: SEL, indexBufferIndex: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setIndexBufferIndex:\0"), indexBufferIndex);
    }
}
using MTLMutability :: enum NSUInteger {
    MTLMutabilityDefault :: 0;
    MTLMutabilityMutable :: 1;
    MTLMutabilityImmutable :: 2;
}
MTLPipelineBufferDescriptor :: struct {
    nsobject: NSObject;
    mutability :: (self: *MTLPipelineBufferDescriptor) -> MTLMutability {
        invoke: (receiver: *MTLPipelineBufferDescriptor, selector: SEL) -> MTLMutability #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "mutability\0"));
    }
    setMutability :: (self: *MTLPipelineBufferDescriptor, mutability: MTLMutability) -> () {
        invoke: (receiver: *MTLPipelineBufferDescriptor, selector: SEL, mutability: MTLMutability) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setMutability:\0"), mutability);
    }
}
MTLPipelineBufferDescriptorArray :: struct {
    nsobject: NSObject;
    objectAtIndexedSubscript :: (self: *MTLPipelineBufferDescriptorArray, bufferIndex: NSUInteger) -> *MTLPipelineBufferDescriptor {
        invoke: (receiver: *MTLPipelineBufferDescriptorArray, selector: SEL, bufferIndex: NSUInteger) -> *MTLPipelineBufferDescriptor #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "objectAtIndexedSubscript:\0"), bufferIndex);
    }
    setObject_atIndexedSubscript :: (self: *MTLPipelineBufferDescriptorArray, buffer: *MTLPipelineBufferDescriptor, bufferIndex: NSUInteger) -> () {
        invoke: (receiver: *MTLPipelineBufferDescriptorArray, selector: SEL, buffer: *MTLPipelineBufferDescriptor, bufferIndex: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setObject:atIndexedSubscript:\0"), buffer, bufferIndex);
    }
}
MTLComputePipelineReflection :: struct {
    nsobject: NSObject;
    arguments :: (self: *MTLComputePipelineReflection) -> *NSArray(*MTLArgument) {
        invoke: (receiver: *MTLComputePipelineReflection, selector: SEL) -> *NSArray(*MTLArgument) #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "arguments\0"));
    }
}
MTLComputePipelineDescriptor :: struct {
    nsobject: NSObject;
    reset :: (self: *MTLComputePipelineDescriptor) -> () {
        invoke: (receiver: *MTLComputePipelineDescriptor, selector: SEL) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "reset\0"));
    }
    label :: (self: *MTLComputePipelineDescriptor) -> *NSString {
        invoke: (receiver: *MTLComputePipelineDescriptor, selector: SEL) -> *NSString #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "label\0"));
    }
    setLabel :: (self: *MTLComputePipelineDescriptor, label: *NSString) -> () {
        invoke: (receiver: *MTLComputePipelineDescriptor, selector: SEL, label: *NSString) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setLabel:\0"), label);
    }
    computeFunction :: (self: *MTLComputePipelineDescriptor) -> id {
        invoke: (receiver: *MTLComputePipelineDescriptor, selector: SEL) -> id #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "computeFunction\0"));
    }
    setComputeFunction :: (self: *MTLComputePipelineDescriptor, computeFunction: id) -> () {
        invoke: (receiver: *MTLComputePipelineDescriptor, selector: SEL, computeFunction: id) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setComputeFunction:\0"), computeFunction);
    }
    threadGroupSizeIsMultipleOfThreadExecutionWidth :: (self: *MTLComputePipelineDescriptor) -> BOOL {
        invoke: (receiver: *MTLComputePipelineDescriptor, selector: SEL) -> BOOL #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "threadGroupSizeIsMultipleOfThreadExecutionWidth\0"));
    }
    setThreadGroupSizeIsMultipleOfThreadExecutionWidth :: (self: *MTLComputePipelineDescriptor, threadGroupSizeIsMultipleOfThreadExecutionWidth: BOOL) -> () {
        invoke: (receiver: *MTLComputePipelineDescriptor, selector: SEL, threadGroupSizeIsMultipleOfThreadExecutionWidth: BOOL) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setThreadGroupSizeIsMultipleOfThreadExecutionWidth:\0"), threadGroupSizeIsMultipleOfThreadExecutionWidth);
    }
    maxTotalThreadsPerThreadgroup :: (self: *MTLComputePipelineDescriptor) -> NSUInteger {
        invoke: (receiver: *MTLComputePipelineDescriptor, selector: SEL) -> NSUInteger #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "maxTotalThreadsPerThreadgroup\0"));
    }
    setMaxTotalThreadsPerThreadgroup :: (self: *MTLComputePipelineDescriptor, maxTotalThreadsPerThreadgroup: NSUInteger) -> () {
        invoke: (receiver: *MTLComputePipelineDescriptor, selector: SEL, maxTotalThreadsPerThreadgroup: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setMaxTotalThreadsPerThreadgroup:\0"), maxTotalThreadsPerThreadgroup);
    }
    stageInputDescriptor :: (self: *MTLComputePipelineDescriptor) -> *MTLStageInputOutputDescriptor {
        invoke: (receiver: *MTLComputePipelineDescriptor, selector: SEL) -> *MTLStageInputOutputDescriptor #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "stageInputDescriptor\0"));
    }
    setStageInputDescriptor :: (self: *MTLComputePipelineDescriptor, stageInputDescriptor: *MTLStageInputOutputDescriptor) -> () {
        invoke: (receiver: *MTLComputePipelineDescriptor, selector: SEL, stageInputDescriptor: *MTLStageInputOutputDescriptor) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setStageInputDescriptor:\0"), stageInputDescriptor);
    }
    buffers :: (self: *MTLComputePipelineDescriptor) -> *MTLPipelineBufferDescriptorArray {
        invoke: (receiver: *MTLComputePipelineDescriptor, selector: SEL) -> *MTLPipelineBufferDescriptorArray #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "buffers\0"));
    }
}
MTLComputePipelineState :: struct {
    label :: (self: *MTLComputePipelineState) -> *NSString {
        invoke: (receiver: *MTLComputePipelineState, selector: SEL) -> *NSString #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "label\0"));
    }
    device :: (self: *MTLComputePipelineState) -> id {
        invoke: (receiver: *MTLComputePipelineState, selector: SEL) -> id #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "device\0"));
    }
    maxTotalThreadsPerThreadgroup :: (self: *MTLComputePipelineState) -> NSUInteger {
        invoke: (receiver: *MTLComputePipelineState, selector: SEL) -> NSUInteger #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "maxTotalThreadsPerThreadgroup\0"));
    }
    threadExecutionWidth :: (self: *MTLComputePipelineState) -> NSUInteger {
        invoke: (receiver: *MTLComputePipelineState, selector: SEL) -> NSUInteger #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "threadExecutionWidth\0"));
    }
    staticThreadgroupMemoryLength :: (self: *MTLComputePipelineState) -> NSUInteger {
        invoke: (receiver: *MTLComputePipelineState, selector: SEL) -> NSUInteger #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "staticThreadgroupMemoryLength\0"));
    }
}
using MTLPrimitiveType :: enum NSUInteger {
    MTLPrimitiveTypePoint :: 0;
    MTLPrimitiveTypeLine :: 1;
    MTLPrimitiveTypeLineStrip :: 2;
    MTLPrimitiveTypeTriangle :: 3;
    MTLPrimitiveTypeTriangleStrip :: 4;
}
using MTLVisibilityResultMode :: enum NSUInteger {
    MTLVisibilityResultModeDisabled :: 0;
    MTLVisibilityResultModeBoolean :: 1;
    MTLVisibilityResultModeCounting :: 2;
}
MTLScissorRect :: struct {
    x: NSUInteger;
    y: NSUInteger;
    width: NSUInteger;
    height: NSUInteger;
}
MTLViewport :: struct {
    originX: float64;
    originY: float64;
    width: float64;
    height: float64;
    znear: float64;
    zfar: float64;
}
using MTLCullMode :: enum NSUInteger {
    MTLCullModeNone :: 0;
    MTLCullModeFront :: 1;
    MTLCullModeBack :: 2;
}
using MTLWinding :: enum NSUInteger {
    MTLWindingClockwise :: 0;
    MTLWindingCounterClockwise :: 1;
}
using MTLDepthClipMode :: enum NSUInteger {
    MTLDepthClipModeClip :: 0;
    MTLDepthClipModeClamp :: 1;
}
using MTLTriangleFillMode :: enum NSUInteger {
    MTLTriangleFillModeFill :: 0;
    MTLTriangleFillModeLines :: 1;
}
MTLDrawPrimitivesIndirectArguments :: struct {
    vertexCount: uint32_t;
    instanceCount: uint32_t;
    vertexStart: uint32_t;
    baseInstance: uint32_t;
}
MTLDrawIndexedPrimitivesIndirectArguments :: struct {
    indexCount: uint32_t;
    instanceCount: uint32_t;
    indexStart: uint32_t;
    baseVertex: int32_t;
    baseInstance: uint32_t;
}
MTLDrawPatchIndirectArguments :: struct {
    patchCount: uint32_t;
    instanceCount: uint32_t;
    patchStart: uint32_t;
    baseInstance: uint32_t;
}
MTLQuadTessellationFactorsHalf :: struct {
    edgeTessellationFactor: [4] uint16_t;
    insideTessellationFactor: [2] uint16_t;
}
MTLTriangleTessellationFactorsHalf :: struct {
    edgeTessellationFactor: [3] uint16_t;
    insideTessellationFactor: uint16_t;
}
using MTLRenderStages :: enum NSUInteger {
    MTLRenderStageVertex :: 1;
    MTLRenderStageFragment :: 2;
}
MTLRenderCommandEncoder :: struct {
    using #as mtlcommandencder: MTLCommandEncoder;
    setRenderPipelineState :: (self: *MTLRenderCommandEncoder, pipelineState: id) -> () {
        invoke: (receiver: *MTLRenderCommandEncoder, selector: SEL, pipelineState: id) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setRenderPipelineState:\0"), pipelineState);
    }
    setVertexBytes_length_atIndex :: (self: *MTLRenderCommandEncoder, bytes: *void, length: NSUInteger, index: NSUInteger) -> () {
        invoke: (receiver: *MTLRenderCommandEncoder, selector: SEL, bytes: *void, length: NSUInteger, index: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setVertexBytes:length:atIndex:\0"), bytes, length, index);
    }
    setVertexBuffer_offset_atIndex :: (self: *MTLRenderCommandEncoder, buffer: id, offset: NSUInteger, index: NSUInteger) -> () {
        invoke: (receiver: *MTLRenderCommandEncoder, selector: SEL, buffer: id, offset: NSUInteger, index: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setVertexBuffer:offset:atIndex:\0"), buffer, offset, index);
    }
    setVertexBufferOffset_atIndex :: (self: *MTLRenderCommandEncoder, offset: NSUInteger, index: NSUInteger) -> () {
        invoke: (receiver: *MTLRenderCommandEncoder, selector: SEL, offset: NSUInteger, index: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setVertexBufferOffset:atIndex:\0"), offset, index);
    }
    setVertexBuffers_offsets_withRange :: (self: *MTLRenderCommandEncoder, buffers: *id, offsets: *NSUInteger, range: NSRange) -> () {
        invoke: (receiver: *MTLRenderCommandEncoder, selector: SEL, buffers: *id, offsets: *NSUInteger, range: NSRange) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setVertexBuffers:offsets:withRange:\0"), buffers, offsets, range);
    }
    setVertexTexture_atIndex :: (self: *MTLRenderCommandEncoder, texture: id, index: NSUInteger) -> () {
        invoke: (receiver: *MTLRenderCommandEncoder, selector: SEL, texture: id, index: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setVertexTexture:atIndex:\0"), texture, index);
    }
    setVertexTextures_withRange :: (self: *MTLRenderCommandEncoder, textures: *id, range: NSRange) -> () {
        invoke: (receiver: *MTLRenderCommandEncoder, selector: SEL, textures: *id, range: NSRange) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setVertexTextures:withRange:\0"), textures, range);
    }
    setVertexSamplerState_atIndex :: (self: *MTLRenderCommandEncoder, sampler: id, index: NSUInteger) -> () {
        invoke: (receiver: *MTLRenderCommandEncoder, selector: SEL, sampler: id, index: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setVertexSamplerState:atIndex:\0"), sampler, index);
    }
    setVertexSamplerStates_withRange :: (self: *MTLRenderCommandEncoder, samplers: *id, range: NSRange) -> () {
        invoke: (receiver: *MTLRenderCommandEncoder, selector: SEL, samplers: *id, range: NSRange) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setVertexSamplerStates:withRange:\0"), samplers, range);
    }
    setVertexSamplerState_lodMinClamp_lodMaxClamp_atIndex :: (self: *MTLRenderCommandEncoder, sampler: id, lodMinClamp: float32, lodMaxClamp: float32, index: NSUInteger) -> () {
        invoke: (receiver: *MTLRenderCommandEncoder, selector: SEL, sampler: id, lodMinClamp: float32, lodMaxClamp: float32, index: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setVertexSamplerState:lodMinClamp:lodMaxClamp:atIndex:\0"), sampler, lodMinClamp, lodMaxClamp, index);
    }
    setVertexSamplerStates_lodMinClamps_lodMaxClamps_withRange :: (self: *MTLRenderCommandEncoder, samplers: *id, lodMinClamps: *float32, lodMaxClamps: *float32, range: NSRange) -> () {
        invoke: (receiver: *MTLRenderCommandEncoder, selector: SEL, samplers: *id, lodMinClamps: *float32, lodMaxClamps: *float32, range: NSRange) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setVertexSamplerStates:lodMinClamps:lodMaxClamps:withRange:\0"), samplers, lodMinClamps, lodMaxClamps, range);
    }
    setViewport :: (self: *MTLRenderCommandEncoder, viewport: MTLViewport) -> () {
        invoke: (receiver: *MTLRenderCommandEncoder, selector: SEL, viewport: MTLViewport) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setViewport:\0"), viewport);
    }
    setViewports_count :: (self: *MTLRenderCommandEncoder, viewports: *MTLViewport, count: NSUInteger) -> () {
        invoke: (receiver: *MTLRenderCommandEncoder, selector: SEL, viewports: *MTLViewport, count: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setViewports:count:\0"), viewports, count);
    }
    setFrontFacingWinding :: (self: *MTLRenderCommandEncoder, frontFacingWinding: MTLWinding) -> () {
        invoke: (receiver: *MTLRenderCommandEncoder, selector: SEL, frontFacingWinding: MTLWinding) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setFrontFacingWinding:\0"), frontFacingWinding);
    }
    setCullMode :: (self: *MTLRenderCommandEncoder, cullMode: MTLCullMode) -> () {
        invoke: (receiver: *MTLRenderCommandEncoder, selector: SEL, cullMode: MTLCullMode) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setCullMode:\0"), cullMode);
    }
    setDepthClipMode :: (self: *MTLRenderCommandEncoder, depthClipMode: MTLDepthClipMode) -> () {
        invoke: (receiver: *MTLRenderCommandEncoder, selector: SEL, depthClipMode: MTLDepthClipMode) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setDepthClipMode:\0"), depthClipMode);
    }
    setDepthBias_slopeScale_clamp :: (self: *MTLRenderCommandEncoder, depthBias: float32, slopeScale: float32, clamp: float32) -> () {
        invoke: (receiver: *MTLRenderCommandEncoder, selector: SEL, depthBias: float32, slopeScale: float32, clamp: float32) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setDepthBias:slopeScale:clamp:\0"), depthBias, slopeScale, clamp);
    }
    setScissorRect :: (self: *MTLRenderCommandEncoder, rect: MTLScissorRect) -> () {
        invoke: (receiver: *MTLRenderCommandEncoder, selector: SEL, rect: MTLScissorRect) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setScissorRect:\0"), rect);
    }
    setScissorRects_count :: (self: *MTLRenderCommandEncoder, scissorRects: *MTLScissorRect, count: NSUInteger) -> () {
        invoke: (receiver: *MTLRenderCommandEncoder, selector: SEL, scissorRects: *MTLScissorRect, count: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setScissorRects:count:\0"), scissorRects, count);
    }
    setTriangleFillMode :: (self: *MTLRenderCommandEncoder, fillMode: MTLTriangleFillMode) -> () {
        invoke: (receiver: *MTLRenderCommandEncoder, selector: SEL, fillMode: MTLTriangleFillMode) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setTriangleFillMode:\0"), fillMode);
    }
    setFragmentBytes_length_atIndex :: (self: *MTLRenderCommandEncoder, bytes: *void, length: NSUInteger, index: NSUInteger) -> () {
        invoke: (receiver: *MTLRenderCommandEncoder, selector: SEL, bytes: *void, length: NSUInteger, index: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setFragmentBytes:length:atIndex:\0"), bytes, length, index);
    }
    setFragmentBuffer_offset_atIndex :: (self: *MTLRenderCommandEncoder, buffer: id, offset: NSUInteger, index: NSUInteger) -> () {
        invoke: (receiver: *MTLRenderCommandEncoder, selector: SEL, buffer: id, offset: NSUInteger, index: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setFragmentBuffer:offset:atIndex:\0"), buffer, offset, index);
    }
    setFragmentBufferOffset_atIndex :: (self: *MTLRenderCommandEncoder, offset: NSUInteger, index: NSUInteger) -> () {
        invoke: (receiver: *MTLRenderCommandEncoder, selector: SEL, offset: NSUInteger, index: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setFragmentBufferOffset:atIndex:\0"), offset, index);
    }
    setFragmentBuffers_offsets_withRange :: (self: *MTLRenderCommandEncoder, buffers: *id, offsets: *NSUInteger, range: NSRange) -> () {
        invoke: (receiver: *MTLRenderCommandEncoder, selector: SEL, buffers: *id, offsets: *NSUInteger, range: NSRange) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setFragmentBuffers:offsets:withRange:\0"), buffers, offsets, range);
    }
    setFragmentTexture_atIndex :: (self: *MTLRenderCommandEncoder, texture: id, index: NSUInteger) -> () {
        invoke: (receiver: *MTLRenderCommandEncoder, selector: SEL, texture: id, index: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setFragmentTexture:atIndex:\0"), texture, index);
    }
    setFragmentTextures_withRange :: (self: *MTLRenderCommandEncoder, textures: *id, range: NSRange) -> () {
        invoke: (receiver: *MTLRenderCommandEncoder, selector: SEL, textures: *id, range: NSRange) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setFragmentTextures:withRange:\0"), textures, range);
    }
    setFragmentSamplerState_atIndex :: (self: *MTLRenderCommandEncoder, sampler: id, index: NSUInteger) -> () {
        invoke: (receiver: *MTLRenderCommandEncoder, selector: SEL, sampler: id, index: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setFragmentSamplerState:atIndex:\0"), sampler, index);
    }
    setFragmentSamplerStates_withRange :: (self: *MTLRenderCommandEncoder, samplers: *id, range: NSRange) -> () {
        invoke: (receiver: *MTLRenderCommandEncoder, selector: SEL, samplers: *id, range: NSRange) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setFragmentSamplerStates:withRange:\0"), samplers, range);
    }
    setFragmentSamplerState_lodMinClamp_lodMaxClamp_atIndex :: (self: *MTLRenderCommandEncoder, sampler: id, lodMinClamp: float32, lodMaxClamp: float32, index: NSUInteger) -> () {
        invoke: (receiver: *MTLRenderCommandEncoder, selector: SEL, sampler: id, lodMinClamp: float32, lodMaxClamp: float32, index: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setFragmentSamplerState:lodMinClamp:lodMaxClamp:atIndex:\0"), sampler, lodMinClamp, lodMaxClamp, index);
    }
    setFragmentSamplerStates_lodMinClamps_lodMaxClamps_withRange :: (self: *MTLRenderCommandEncoder, samplers: *id, lodMinClamps: *float32, lodMaxClamps: *float32, range: NSRange) -> () {
        invoke: (receiver: *MTLRenderCommandEncoder, selector: SEL, samplers: *id, lodMinClamps: *float32, lodMaxClamps: *float32, range: NSRange) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setFragmentSamplerStates:lodMinClamps:lodMaxClamps:withRange:\0"), samplers, lodMinClamps, lodMaxClamps, range);
    }
    setBlendColorRed_green_blue_alpha :: (self: *MTLRenderCommandEncoder, red: float32, green: float32, blue: float32, alpha: float32) -> () {
        invoke: (receiver: *MTLRenderCommandEncoder, selector: SEL, red: float32, green: float32, blue: float32, alpha: float32) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setBlendColorRed:green:blue:alpha:\0"), red, green, blue, alpha);
    }
    setDepthStencilState :: (self: *MTLRenderCommandEncoder, depthStencilState: id) -> () {
        invoke: (receiver: *MTLRenderCommandEncoder, selector: SEL, depthStencilState: id) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setDepthStencilState:\0"), depthStencilState);
    }
    setStencilReferenceValue :: (self: *MTLRenderCommandEncoder, referenceValue: uint32_t) -> () {
        invoke: (receiver: *MTLRenderCommandEncoder, selector: SEL, referenceValue: uint32_t) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setStencilReferenceValue:\0"), referenceValue);
    }
    setStencilFrontReferenceValue_backReferenceValue :: (self: *MTLRenderCommandEncoder, frontReferenceValue: uint32_t, backReferenceValue: uint32_t) -> () {
        invoke: (receiver: *MTLRenderCommandEncoder, selector: SEL, frontReferenceValue: uint32_t, backReferenceValue: uint32_t) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setStencilFrontReferenceValue:backReferenceValue:\0"), frontReferenceValue, backReferenceValue);
    }
    setVisibilityResultMode_offset :: (self: *MTLRenderCommandEncoder, mode: MTLVisibilityResultMode, offset: NSUInteger) -> () {
        invoke: (receiver: *MTLRenderCommandEncoder, selector: SEL, mode: MTLVisibilityResultMode, offset: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setVisibilityResultMode:offset:\0"), mode, offset);
    }
    setColorStoreAction_atIndex :: (self: *MTLRenderCommandEncoder, storeAction: MTLStoreAction, colorAttachmentIndex: NSUInteger) -> () {
        invoke: (receiver: *MTLRenderCommandEncoder, selector: SEL, storeAction: MTLStoreAction, colorAttachmentIndex: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setColorStoreAction:atIndex:\0"), storeAction, colorAttachmentIndex);
    }
    setDepthStoreAction :: (self: *MTLRenderCommandEncoder, storeAction: MTLStoreAction) -> () {
        invoke: (receiver: *MTLRenderCommandEncoder, selector: SEL, storeAction: MTLStoreAction) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setDepthStoreAction:\0"), storeAction);
    }
    setStencilStoreAction :: (self: *MTLRenderCommandEncoder, storeAction: MTLStoreAction) -> () {
        invoke: (receiver: *MTLRenderCommandEncoder, selector: SEL, storeAction: MTLStoreAction) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setStencilStoreAction:\0"), storeAction);
    }
    setColorStoreActionOptions_atIndex :: (self: *MTLRenderCommandEncoder, storeActionOptions: MTLStoreActionOptions, colorAttachmentIndex: NSUInteger) -> () {
        invoke: (receiver: *MTLRenderCommandEncoder, selector: SEL, storeActionOptions: MTLStoreActionOptions, colorAttachmentIndex: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setColorStoreActionOptions:atIndex:\0"), storeActionOptions, colorAttachmentIndex);
    }
    setDepthStoreActionOptions :: (self: *MTLRenderCommandEncoder, storeActionOptions: MTLStoreActionOptions) -> () {
        invoke: (receiver: *MTLRenderCommandEncoder, selector: SEL, storeActionOptions: MTLStoreActionOptions) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setDepthStoreActionOptions:\0"), storeActionOptions);
    }
    setStencilStoreActionOptions :: (self: *MTLRenderCommandEncoder, storeActionOptions: MTLStoreActionOptions) -> () {
        invoke: (receiver: *MTLRenderCommandEncoder, selector: SEL, storeActionOptions: MTLStoreActionOptions) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setStencilStoreActionOptions:\0"), storeActionOptions);
    }
    drawPrimitives_vertexStart_vertexCount_instanceCount :: (self: *MTLRenderCommandEncoder, primitiveType: MTLPrimitiveType, vertexStart: NSUInteger, vertexCount: NSUInteger, instanceCount: NSUInteger) -> () {
        invoke: (receiver: *MTLRenderCommandEncoder, selector: SEL, primitiveType: MTLPrimitiveType, vertexStart: NSUInteger, vertexCount: NSUInteger, instanceCount: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "drawPrimitives:vertexStart:vertexCount:instanceCount:\0"), primitiveType, vertexStart, vertexCount, instanceCount);
    }
    drawPrimitives_vertexStart_vertexCount :: (self: *MTLRenderCommandEncoder, primitiveType: MTLPrimitiveType, vertexStart: NSUInteger, vertexCount: NSUInteger) -> () {
        invoke: (receiver: *MTLRenderCommandEncoder, selector: SEL, primitiveType: MTLPrimitiveType, vertexStart: NSUInteger, vertexCount: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "drawPrimitives:vertexStart:vertexCount:\0"), primitiveType, vertexStart, vertexCount);
    }
    drawIndexedPrimitives_indexCount_indexType_indexBuffer_indexBufferOffset_instanceCount :: (self: *MTLRenderCommandEncoder, primitiveType: MTLPrimitiveType, indexCount: NSUInteger, indexType: MTLIndexType, indexBuffer: id, indexBufferOffset: NSUInteger, instanceCount: NSUInteger) -> () {
        invoke: (receiver: *MTLRenderCommandEncoder, selector: SEL, primitiveType: MTLPrimitiveType, indexCount: NSUInteger, indexType: MTLIndexType, indexBuffer: id, indexBufferOffset: NSUInteger, instanceCount: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "drawIndexedPrimitives:indexCount:indexType:indexBuffer:indexBufferOffset:instanceCount:\0"), primitiveType, indexCount, indexType, indexBuffer, indexBufferOffset, instanceCount);
    }
    drawIndexedPrimitives_indexCount_indexType_indexBuffer_indexBufferOffset :: (self: *MTLRenderCommandEncoder, primitiveType: MTLPrimitiveType, indexCount: NSUInteger, indexType: MTLIndexType, indexBuffer: id, indexBufferOffset: NSUInteger) -> () {
        invoke: (receiver: *MTLRenderCommandEncoder, selector: SEL, primitiveType: MTLPrimitiveType, indexCount: NSUInteger, indexType: MTLIndexType, indexBuffer: id, indexBufferOffset: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "drawIndexedPrimitives:indexCount:indexType:indexBuffer:indexBufferOffset:\0"), primitiveType, indexCount, indexType, indexBuffer, indexBufferOffset);
    }
    drawPrimitives_vertexStart_vertexCount_instanceCount_baseInstance :: (self: *MTLRenderCommandEncoder, primitiveType: MTLPrimitiveType, vertexStart: NSUInteger, vertexCount: NSUInteger, instanceCount: NSUInteger, baseInstance: NSUInteger) -> () {
        invoke: (receiver: *MTLRenderCommandEncoder, selector: SEL, primitiveType: MTLPrimitiveType, vertexStart: NSUInteger, vertexCount: NSUInteger, instanceCount: NSUInteger, baseInstance: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "drawPrimitives:vertexStart:vertexCount:instanceCount:baseInstance:\0"), primitiveType, vertexStart, vertexCount, instanceCount, baseInstance);
    }
    drawIndexedPrimitives_indexCount_indexType_indexBuffer_indexBufferOffset_instanceCount_baseVertex_baseInstance :: (self: *MTLRenderCommandEncoder, primitiveType: MTLPrimitiveType, indexCount: NSUInteger, indexType: MTLIndexType, indexBuffer: id, indexBufferOffset: NSUInteger, instanceCount: NSUInteger, baseVertex: NSInteger, baseInstance: NSUInteger) -> () {
        invoke: (receiver: *MTLRenderCommandEncoder, selector: SEL, primitiveType: MTLPrimitiveType, indexCount: NSUInteger, indexType: MTLIndexType, indexBuffer: id, indexBufferOffset: NSUInteger, instanceCount: NSUInteger, baseVertex: NSInteger, baseInstance: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "drawIndexedPrimitives:indexCount:indexType:indexBuffer:indexBufferOffset:instanceCount:baseVertex:baseInstance:\0"), primitiveType, indexCount, indexType, indexBuffer, indexBufferOffset, instanceCount, baseVertex, baseInstance);
    }
    drawPrimitives_indirectBuffer_indirectBufferOffset :: (self: *MTLRenderCommandEncoder, primitiveType: MTLPrimitiveType, indirectBuffer: id, indirectBufferOffset: NSUInteger) -> () {
        invoke: (receiver: *MTLRenderCommandEncoder, selector: SEL, primitiveType: MTLPrimitiveType, indirectBuffer: id, indirectBufferOffset: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "drawPrimitives:indirectBuffer:indirectBufferOffset:\0"), primitiveType, indirectBuffer, indirectBufferOffset);
    }
    drawIndexedPrimitives_indexType_indexBuffer_indexBufferOffset_indirectBuffer_indirectBufferOffset :: (self: *MTLRenderCommandEncoder, primitiveType: MTLPrimitiveType, indexType: MTLIndexType, indexBuffer: id, indexBufferOffset: NSUInteger, indirectBuffer: id, indirectBufferOffset: NSUInteger) -> () {
        invoke: (receiver: *MTLRenderCommandEncoder, selector: SEL, primitiveType: MTLPrimitiveType, indexType: MTLIndexType, indexBuffer: id, indexBufferOffset: NSUInteger, indirectBuffer: id, indirectBufferOffset: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "drawIndexedPrimitives:indexType:indexBuffer:indexBufferOffset:indirectBuffer:indirectBufferOffset:\0"), primitiveType, indexType, indexBuffer, indexBufferOffset, indirectBuffer, indirectBufferOffset);
    }
    textureBarrier :: (self: *MTLRenderCommandEncoder) -> () {
        invoke: (receiver: *MTLRenderCommandEncoder, selector: SEL) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "textureBarrier\0"));
    }
    updateFence_afterStages :: (self: *MTLRenderCommandEncoder, fence: id, stages: MTLRenderStages) -> () {
        invoke: (receiver: *MTLRenderCommandEncoder, selector: SEL, fence: id, stages: MTLRenderStages) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "updateFence:afterStages:\0"), fence, stages);
    }
    waitForFence_beforeStages :: (self: *MTLRenderCommandEncoder, fence: id, stages: MTLRenderStages) -> () {
        invoke: (receiver: *MTLRenderCommandEncoder, selector: SEL, fence: id, stages: MTLRenderStages) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "waitForFence:beforeStages:\0"), fence, stages);
    }
    setTessellationFactorBuffer_offset_instanceStride :: (self: *MTLRenderCommandEncoder, buffer: id, offset: NSUInteger, instanceStride: NSUInteger) -> () {
        invoke: (receiver: *MTLRenderCommandEncoder, selector: SEL, buffer: id, offset: NSUInteger, instanceStride: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setTessellationFactorBuffer:offset:instanceStride:\0"), buffer, offset, instanceStride);
    }
    setTessellationFactorScale :: (self: *MTLRenderCommandEncoder, scale: float32) -> () {
        invoke: (receiver: *MTLRenderCommandEncoder, selector: SEL, scale: float32) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setTessellationFactorScale:\0"), scale);
    }
    drawPatches_patchStart_patchCount_patchIndexBuffer_patchIndexBufferOffset_instanceCount_baseInstance :: (self: *MTLRenderCommandEncoder, numberOfPatchControlPoints: NSUInteger, patchStart: NSUInteger, patchCount: NSUInteger, patchIndexBuffer: id, patchIndexBufferOffset: NSUInteger, instanceCount: NSUInteger, baseInstance: NSUInteger) -> () {
        invoke: (receiver: *MTLRenderCommandEncoder, selector: SEL, numberOfPatchControlPoints: NSUInteger, patchStart: NSUInteger, patchCount: NSUInteger, patchIndexBuffer: id, patchIndexBufferOffset: NSUInteger, instanceCount: NSUInteger, baseInstance: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "drawPatches:patchStart:patchCount:patchIndexBuffer:patchIndexBufferOffset:instanceCount:baseInstance:\0"), numberOfPatchControlPoints, patchStart, patchCount, patchIndexBuffer, patchIndexBufferOffset, instanceCount, baseInstance);
    }
    drawPatches_patchIndexBuffer_patchIndexBufferOffset_indirectBuffer_indirectBufferOffset :: (self: *MTLRenderCommandEncoder, numberOfPatchControlPoints: NSUInteger, patchIndexBuffer: id, patchIndexBufferOffset: NSUInteger, indirectBuffer: id, indirectBufferOffset: NSUInteger) -> () {
        invoke: (receiver: *MTLRenderCommandEncoder, selector: SEL, numberOfPatchControlPoints: NSUInteger, patchIndexBuffer: id, patchIndexBufferOffset: NSUInteger, indirectBuffer: id, indirectBufferOffset: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "drawPatches:patchIndexBuffer:patchIndexBufferOffset:indirectBuffer:indirectBufferOffset:\0"), numberOfPatchControlPoints, patchIndexBuffer, patchIndexBufferOffset, indirectBuffer, indirectBufferOffset);
    }
    drawIndexedPatches_patchStart_patchCount_patchIndexBuffer_patchIndexBufferOffset_controlPointIndexBuffer_controlPointIndexBufferOffset_instanceCount_baseInstance :: (self: *MTLRenderCommandEncoder, numberOfPatchControlPoints: NSUInteger, patchStart: NSUInteger, patchCount: NSUInteger, patchIndexBuffer: id, patchIndexBufferOffset: NSUInteger, controlPointIndexBuffer: id, controlPointIndexBufferOffset: NSUInteger, instanceCount: NSUInteger, baseInstance: NSUInteger) -> () {
        invoke: (receiver: *MTLRenderCommandEncoder, selector: SEL, numberOfPatchControlPoints: NSUInteger, patchStart: NSUInteger, patchCount: NSUInteger, patchIndexBuffer: id, patchIndexBufferOffset: NSUInteger, controlPointIndexBuffer: id, controlPointIndexBufferOffset: NSUInteger, instanceCount: NSUInteger, baseInstance: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "drawIndexedPatches:patchStart:patchCount:patchIndexBuffer:patchIndexBufferOffset:controlPointIndexBuffer:controlPointIndexBufferOffset:instanceCount:baseInstance:\0"), numberOfPatchControlPoints, patchStart, patchCount, patchIndexBuffer, patchIndexBufferOffset, controlPointIndexBuffer, controlPointIndexBufferOffset, instanceCount, baseInstance);
    }
    drawIndexedPatches_patchIndexBuffer_patchIndexBufferOffset_controlPointIndexBuffer_controlPointIndexBufferOffset_indirectBuffer_indirectBufferOffset :: (self: *MTLRenderCommandEncoder, numberOfPatchControlPoints: NSUInteger, patchIndexBuffer: id, patchIndexBufferOffset: NSUInteger, controlPointIndexBuffer: id, controlPointIndexBufferOffset: NSUInteger, indirectBuffer: id, indirectBufferOffset: NSUInteger) -> () {
        invoke: (receiver: *MTLRenderCommandEncoder, selector: SEL, numberOfPatchControlPoints: NSUInteger, patchIndexBuffer: id, patchIndexBufferOffset: NSUInteger, controlPointIndexBuffer: id, controlPointIndexBufferOffset: NSUInteger, indirectBuffer: id, indirectBufferOffset: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "drawIndexedPatches:patchIndexBuffer:patchIndexBufferOffset:controlPointIndexBuffer:controlPointIndexBufferOffset:indirectBuffer:indirectBufferOffset:\0"), numberOfPatchControlPoints, patchIndexBuffer, patchIndexBufferOffset, controlPointIndexBuffer, controlPointIndexBufferOffset, indirectBuffer, indirectBufferOffset);
    }
    useResource_usage :: (self: *MTLRenderCommandEncoder, resource: id, usage: MTLResourceUsage) -> () {
        invoke: (receiver: *MTLRenderCommandEncoder, selector: SEL, resource: id, usage: MTLResourceUsage) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "useResource:usage:\0"), resource, usage);
    }
    useResources_count_usage :: (self: *MTLRenderCommandEncoder, resources: *id, count: NSUInteger, usage: MTLResourceUsage) -> () {
        invoke: (receiver: *MTLRenderCommandEncoder, selector: SEL, resources: *id, count: NSUInteger, usage: MTLResourceUsage) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "useResources:count:usage:\0"), resources, count, usage);
    }
    useHeap :: (self: *MTLRenderCommandEncoder, heap: id) -> () {
        invoke: (receiver: *MTLRenderCommandEncoder, selector: SEL, heap: id) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "useHeap:\0"), heap);
    }
    useHeaps_count :: (self: *MTLRenderCommandEncoder, heaps: *id, count: NSUInteger) -> () {
        invoke: (receiver: *MTLRenderCommandEncoder, selector: SEL, heaps: *id, count: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "useHeaps:count:\0"), heaps, count);
    }
    executeCommandsInBuffer_withRange :: (self: *MTLRenderCommandEncoder, indirectCommandBuffer: id, executionRange: NSRange) -> () {
        invoke: (receiver: *MTLRenderCommandEncoder, selector: SEL, indirectCommandBuffer: id, executionRange: NSRange) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "executeCommandsInBuffer:withRange:\0"), indirectCommandBuffer, executionRange);
    }
    executeCommandsInBuffer_indirectBuffer_indirectBufferOffset :: (self: *MTLRenderCommandEncoder, indirectCommandbuffer: id, indirectRangeBuffer: id, indirectBufferOffset: NSUInteger) -> () {
        invoke: (receiver: *MTLRenderCommandEncoder, selector: SEL, indirectCommandbuffer: id, indirectRangeBuffer: id, indirectBufferOffset: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "executeCommandsInBuffer:indirectBuffer:indirectBufferOffset:\0"), indirectCommandbuffer, indirectRangeBuffer, indirectBufferOffset);
    }
    memoryBarrierWithScope_afterStages_beforeStages :: (self: *MTLRenderCommandEncoder, scope: MTLBarrierScope, after: MTLRenderStages, before: MTLRenderStages) -> () {
        invoke: (receiver: *MTLRenderCommandEncoder, selector: SEL, scope: MTLBarrierScope, after: MTLRenderStages, before: MTLRenderStages) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "memoryBarrierWithScope:afterStages:beforeStages:\0"), scope, after, before);
    }
    memoryBarrierWithResources_count_afterStages_beforeStages :: (self: *MTLRenderCommandEncoder, resources: *id, count: NSUInteger, after: MTLRenderStages, before: MTLRenderStages) -> () {
        invoke: (receiver: *MTLRenderCommandEncoder, selector: SEL, resources: *id, count: NSUInteger, after: MTLRenderStages, before: MTLRenderStages) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "memoryBarrierWithResources:count:afterStages:beforeStages:\0"), resources, count, after, before);
    }
}
MTLFunctionConstantValues :: struct {
    nsobject: NSObject;
    setConstantValue_type_atIndex :: (self: *MTLFunctionConstantValues, value: *void, type: MTLDataType, index: NSUInteger) -> () {
        invoke: (receiver: *MTLFunctionConstantValues, selector: SEL, value: *void, type: MTLDataType, index: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setConstantValue:type:atIndex:\0"), value, type, index);
    }
    setConstantValues_type_withRange :: (self: *MTLFunctionConstantValues, values: *void, type: MTLDataType, range: NSRange) -> () {
        invoke: (receiver: *MTLFunctionConstantValues, selector: SEL, values: *void, type: MTLDataType, range: NSRange) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setConstantValues:type:withRange:\0"), values, type, range);
    }
    setConstantValue_type_withName :: (self: *MTLFunctionConstantValues, value: *void, type: MTLDataType, name: *NSString) -> () {
        invoke: (receiver: *MTLFunctionConstantValues, selector: SEL, value: *void, type: MTLDataType, name: *NSString) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setConstantValue:type:withName:\0"), value, type, name);
    }
    reset :: (self: *MTLFunctionConstantValues) -> () {
        invoke: (receiver: *MTLFunctionConstantValues, selector: SEL) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "reset\0"));
    }
}
using MTLBlendFactor :: enum NSUInteger {
    MTLBlendFactorZero :: 0;
    MTLBlendFactorOne :: 1;
    MTLBlendFactorSourceColor :: 2;
    MTLBlendFactorOneMinusSourceColor :: 3;
    MTLBlendFactorSourceAlpha :: 4;
    MTLBlendFactorOneMinusSourceAlpha :: 5;
    MTLBlendFactorDestinationColor :: 6;
    MTLBlendFactorOneMinusDestinationColor :: 7;
    MTLBlendFactorDestinationAlpha :: 8;
    MTLBlendFactorOneMinusDestinationAlpha :: 9;
    MTLBlendFactorSourceAlphaSaturated :: 10;
    MTLBlendFactorBlendColor :: 11;
    MTLBlendFactorOneMinusBlendColor :: 12;
    MTLBlendFactorBlendAlpha :: 13;
    MTLBlendFactorOneMinusBlendAlpha :: 14;
    MTLBlendFactorSource1Color :: 15;
    MTLBlendFactorOneMinusSource1Color :: 16;
    MTLBlendFactorSource1Alpha :: 17;
    MTLBlendFactorOneMinusSource1Alpha :: 18;
}
using MTLBlendOperation :: enum NSUInteger {
    MTLBlendOperationAdd :: 0;
    MTLBlendOperationSubtract :: 1;
    MTLBlendOperationReverseSubtract :: 2;
    MTLBlendOperationMin :: 3;
    MTLBlendOperationMax :: 4;
}
using MTLColorWriteMask :: enum NSUInteger {
    MTLColorWriteMaskNone :: 0;
    MTLColorWriteMaskRed :: 8;
    MTLColorWriteMaskGreen :: 4;
    MTLColorWriteMaskBlue :: 2;
    MTLColorWriteMaskAlpha :: 1;
    MTLColorWriteMaskAll :: 15;
}
using MTLPrimitiveTopologyClass :: enum NSUInteger {
    MTLPrimitiveTopologyClassUnspecified :: 0;
    MTLPrimitiveTopologyClassPoint :: 1;
    MTLPrimitiveTopologyClassLine :: 2;
    MTLPrimitiveTopologyClassTriangle :: 3;
}
using MTLTessellationPartitionMode :: enum NSUInteger {
    MTLTessellationPartitionModePow2 :: 0;
    MTLTessellationPartitionModeInteger :: 1;
    MTLTessellationPartitionModeFractionalOdd :: 2;
    MTLTessellationPartitionModeFractionalEven :: 3;
}
using MTLTessellationFactorStepFunction :: enum NSUInteger {
    MTLTessellationFactorStepFunctionConstant :: 0;
    MTLTessellationFactorStepFunctionPerPatch :: 1;
    MTLTessellationFactorStepFunctionPerInstance :: 2;
    MTLTessellationFactorStepFunctionPerPatchAndPerInstance :: 3;
}
using MTLTessellationFactorFormat :: enum NSUInteger {
    MTLTessellationFactorFormatHalf :: 0;
}
using MTLTessellationControlPointIndexType :: enum NSUInteger {
    MTLTessellationControlPointIndexTypeNone :: 0;
    MTLTessellationControlPointIndexTypeUInt16 :: 1;
    MTLTessellationControlPointIndexTypeUInt32 :: 2;
}
MTLRenderPipelineColorAttachmentDescriptor :: struct {
    nsobject: NSObject;
    pixelFormat :: (self: *MTLRenderPipelineColorAttachmentDescriptor) -> MTLPixelFormat {
        invoke: (receiver: *MTLRenderPipelineColorAttachmentDescriptor, selector: SEL) -> MTLPixelFormat #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "pixelFormat\0"));
    }
    setPixelFormat :: (self: *MTLRenderPipelineColorAttachmentDescriptor, pixelFormat: MTLPixelFormat) -> () {
        invoke: (receiver: *MTLRenderPipelineColorAttachmentDescriptor, selector: SEL, pixelFormat: MTLPixelFormat) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setPixelFormat:\0"), pixelFormat);
    }
    isBlendingEnabled :: (self: *MTLRenderPipelineColorAttachmentDescriptor) -> BOOL {
        invoke: (receiver: *MTLRenderPipelineColorAttachmentDescriptor, selector: SEL) -> BOOL #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "isBlendingEnabled\0"));
    }
    setBlendingEnabled :: (self: *MTLRenderPipelineColorAttachmentDescriptor, blendingEnabled: BOOL) -> () {
        invoke: (receiver: *MTLRenderPipelineColorAttachmentDescriptor, selector: SEL, blendingEnabled: BOOL) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setBlendingEnabled:\0"), blendingEnabled);
    }
    sourceRGBBlendFactor :: (self: *MTLRenderPipelineColorAttachmentDescriptor) -> MTLBlendFactor {
        invoke: (receiver: *MTLRenderPipelineColorAttachmentDescriptor, selector: SEL) -> MTLBlendFactor #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "sourceRGBBlendFactor\0"));
    }
    setSourceRGBBlendFactor :: (self: *MTLRenderPipelineColorAttachmentDescriptor, sourceRGBBlendFactor: MTLBlendFactor) -> () {
        invoke: (receiver: *MTLRenderPipelineColorAttachmentDescriptor, selector: SEL, sourceRGBBlendFactor: MTLBlendFactor) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setSourceRGBBlendFactor:\0"), sourceRGBBlendFactor);
    }
    destinationRGBBlendFactor :: (self: *MTLRenderPipelineColorAttachmentDescriptor) -> MTLBlendFactor {
        invoke: (receiver: *MTLRenderPipelineColorAttachmentDescriptor, selector: SEL) -> MTLBlendFactor #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "destinationRGBBlendFactor\0"));
    }
    setDestinationRGBBlendFactor :: (self: *MTLRenderPipelineColorAttachmentDescriptor, destinationRGBBlendFactor: MTLBlendFactor) -> () {
        invoke: (receiver: *MTLRenderPipelineColorAttachmentDescriptor, selector: SEL, destinationRGBBlendFactor: MTLBlendFactor) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setDestinationRGBBlendFactor:\0"), destinationRGBBlendFactor);
    }
    rgbBlendOperation :: (self: *MTLRenderPipelineColorAttachmentDescriptor) -> MTLBlendOperation {
        invoke: (receiver: *MTLRenderPipelineColorAttachmentDescriptor, selector: SEL) -> MTLBlendOperation #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "rgbBlendOperation\0"));
    }
    setRgbBlendOperation :: (self: *MTLRenderPipelineColorAttachmentDescriptor, rgbBlendOperation: MTLBlendOperation) -> () {
        invoke: (receiver: *MTLRenderPipelineColorAttachmentDescriptor, selector: SEL, rgbBlendOperation: MTLBlendOperation) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setRgbBlendOperation:\0"), rgbBlendOperation);
    }
    sourceAlphaBlendFactor :: (self: *MTLRenderPipelineColorAttachmentDescriptor) -> MTLBlendFactor {
        invoke: (receiver: *MTLRenderPipelineColorAttachmentDescriptor, selector: SEL) -> MTLBlendFactor #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "sourceAlphaBlendFactor\0"));
    }
    setSourceAlphaBlendFactor :: (self: *MTLRenderPipelineColorAttachmentDescriptor, sourceAlphaBlendFactor: MTLBlendFactor) -> () {
        invoke: (receiver: *MTLRenderPipelineColorAttachmentDescriptor, selector: SEL, sourceAlphaBlendFactor: MTLBlendFactor) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setSourceAlphaBlendFactor:\0"), sourceAlphaBlendFactor);
    }
    destinationAlphaBlendFactor :: (self: *MTLRenderPipelineColorAttachmentDescriptor) -> MTLBlendFactor {
        invoke: (receiver: *MTLRenderPipelineColorAttachmentDescriptor, selector: SEL) -> MTLBlendFactor #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "destinationAlphaBlendFactor\0"));
    }
    setDestinationAlphaBlendFactor :: (self: *MTLRenderPipelineColorAttachmentDescriptor, destinationAlphaBlendFactor: MTLBlendFactor) -> () {
        invoke: (receiver: *MTLRenderPipelineColorAttachmentDescriptor, selector: SEL, destinationAlphaBlendFactor: MTLBlendFactor) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setDestinationAlphaBlendFactor:\0"), destinationAlphaBlendFactor);
    }
    alphaBlendOperation :: (self: *MTLRenderPipelineColorAttachmentDescriptor) -> MTLBlendOperation {
        invoke: (receiver: *MTLRenderPipelineColorAttachmentDescriptor, selector: SEL) -> MTLBlendOperation #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "alphaBlendOperation\0"));
    }
    setAlphaBlendOperation :: (self: *MTLRenderPipelineColorAttachmentDescriptor, alphaBlendOperation: MTLBlendOperation) -> () {
        invoke: (receiver: *MTLRenderPipelineColorAttachmentDescriptor, selector: SEL, alphaBlendOperation: MTLBlendOperation) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setAlphaBlendOperation:\0"), alphaBlendOperation);
    }
    writeMask :: (self: *MTLRenderPipelineColorAttachmentDescriptor) -> MTLColorWriteMask {
        invoke: (receiver: *MTLRenderPipelineColorAttachmentDescriptor, selector: SEL) -> MTLColorWriteMask #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "writeMask\0"));
    }
    setWriteMask :: (self: *MTLRenderPipelineColorAttachmentDescriptor, writeMask: MTLColorWriteMask) -> () {
        invoke: (receiver: *MTLRenderPipelineColorAttachmentDescriptor, selector: SEL, writeMask: MTLColorWriteMask) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setWriteMask:\0"), writeMask);
    }
}
MTLRenderPipelineReflection :: struct {
    nsobject: NSObject;
    vertexArguments :: (self: *MTLRenderPipelineReflection) -> *NSArray(*MTLArgument) {
        invoke: (receiver: *MTLRenderPipelineReflection, selector: SEL) -> *NSArray(*MTLArgument) #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "vertexArguments\0"));
    }
    fragmentArguments :: (self: *MTLRenderPipelineReflection) -> *NSArray(*MTLArgument) {
        invoke: (receiver: *MTLRenderPipelineReflection, selector: SEL) -> *NSArray(*MTLArgument) #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "fragmentArguments\0"));
    }
}
MTLRenderPipelineDescriptor :: struct {
    nsobject: NSObject;
    reset :: (self: *MTLRenderPipelineDescriptor) -> () {
        invoke: (receiver: *MTLRenderPipelineDescriptor, selector: SEL) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "reset\0"));
    }
    label :: (self: *MTLRenderPipelineDescriptor) -> *NSString {
        invoke: (receiver: *MTLRenderPipelineDescriptor, selector: SEL) -> *NSString #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "label\0"));
    }
    setLabel :: (self: *MTLRenderPipelineDescriptor, label: *NSString) -> () {
        invoke: (receiver: *MTLRenderPipelineDescriptor, selector: SEL, label: *NSString) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setLabel:\0"), label);
    }
    vertexFunction :: (self: *MTLRenderPipelineDescriptor) -> id {
        invoke: (receiver: *MTLRenderPipelineDescriptor, selector: SEL) -> id #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "vertexFunction\0"));
    }
    setVertexFunction :: (self: *MTLRenderPipelineDescriptor, vertexFunction: id) -> () {
        invoke: (receiver: *MTLRenderPipelineDescriptor, selector: SEL, vertexFunction: id) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setVertexFunction:\0"), vertexFunction);
    }
    fragmentFunction :: (self: *MTLRenderPipelineDescriptor) -> id {
        invoke: (receiver: *MTLRenderPipelineDescriptor, selector: SEL) -> id #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "fragmentFunction\0"));
    }
    setFragmentFunction :: (self: *MTLRenderPipelineDescriptor, fragmentFunction: id) -> () {
        invoke: (receiver: *MTLRenderPipelineDescriptor, selector: SEL, fragmentFunction: id) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setFragmentFunction:\0"), fragmentFunction);
    }
    vertexDescriptor :: (self: *MTLRenderPipelineDescriptor) -> *MTLVertexDescriptor {
        invoke: (receiver: *MTLRenderPipelineDescriptor, selector: SEL) -> *MTLVertexDescriptor #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "vertexDescriptor\0"));
    }
    setVertexDescriptor :: (self: *MTLRenderPipelineDescriptor, vertexDescriptor: *MTLVertexDescriptor) -> () {
        invoke: (receiver: *MTLRenderPipelineDescriptor, selector: SEL, vertexDescriptor: *MTLVertexDescriptor) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setVertexDescriptor:\0"), vertexDescriptor);
    }
    sampleCount :: (self: *MTLRenderPipelineDescriptor) -> NSUInteger {
        invoke: (receiver: *MTLRenderPipelineDescriptor, selector: SEL) -> NSUInteger #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "sampleCount\0"));
    }
    setSampleCount :: (self: *MTLRenderPipelineDescriptor, sampleCount: NSUInteger) -> () {
        invoke: (receiver: *MTLRenderPipelineDescriptor, selector: SEL, sampleCount: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setSampleCount:\0"), sampleCount);
    }
    rasterSampleCount :: (self: *MTLRenderPipelineDescriptor) -> NSUInteger {
        invoke: (receiver: *MTLRenderPipelineDescriptor, selector: SEL) -> NSUInteger #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "rasterSampleCount\0"));
    }
    setRasterSampleCount :: (self: *MTLRenderPipelineDescriptor, rasterSampleCount: NSUInteger) -> () {
        invoke: (receiver: *MTLRenderPipelineDescriptor, selector: SEL, rasterSampleCount: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setRasterSampleCount:\0"), rasterSampleCount);
    }
    isAlphaToCoverageEnabled :: (self: *MTLRenderPipelineDescriptor) -> BOOL {
        invoke: (receiver: *MTLRenderPipelineDescriptor, selector: SEL) -> BOOL #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "isAlphaToCoverageEnabled\0"));
    }
    setAlphaToCoverageEnabled :: (self: *MTLRenderPipelineDescriptor, alphaToCoverageEnabled: BOOL) -> () {
        invoke: (receiver: *MTLRenderPipelineDescriptor, selector: SEL, alphaToCoverageEnabled: BOOL) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setAlphaToCoverageEnabled:\0"), alphaToCoverageEnabled);
    }
    isAlphaToOneEnabled :: (self: *MTLRenderPipelineDescriptor) -> BOOL {
        invoke: (receiver: *MTLRenderPipelineDescriptor, selector: SEL) -> BOOL #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "isAlphaToOneEnabled\0"));
    }
    setAlphaToOneEnabled :: (self: *MTLRenderPipelineDescriptor, alphaToOneEnabled: BOOL) -> () {
        invoke: (receiver: *MTLRenderPipelineDescriptor, selector: SEL, alphaToOneEnabled: BOOL) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setAlphaToOneEnabled:\0"), alphaToOneEnabled);
    }
    isRasterizationEnabled :: (self: *MTLRenderPipelineDescriptor) -> BOOL {
        invoke: (receiver: *MTLRenderPipelineDescriptor, selector: SEL) -> BOOL #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "isRasterizationEnabled\0"));
    }
    setRasterizationEnabled :: (self: *MTLRenderPipelineDescriptor, rasterizationEnabled: BOOL) -> () {
        invoke: (receiver: *MTLRenderPipelineDescriptor, selector: SEL, rasterizationEnabled: BOOL) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setRasterizationEnabled:\0"), rasterizationEnabled);
    }
    colorAttachments :: (self: *MTLRenderPipelineDescriptor) -> *MTLRenderPipelineColorAttachmentDescriptorArray {
        invoke: (receiver: *MTLRenderPipelineDescriptor, selector: SEL) -> *MTLRenderPipelineColorAttachmentDescriptorArray #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "colorAttachments\0"));
    }
    depthAttachmentPixelFormat :: (self: *MTLRenderPipelineDescriptor) -> MTLPixelFormat {
        invoke: (receiver: *MTLRenderPipelineDescriptor, selector: SEL) -> MTLPixelFormat #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "depthAttachmentPixelFormat\0"));
    }
    setDepthAttachmentPixelFormat :: (self: *MTLRenderPipelineDescriptor, depthAttachmentPixelFormat: MTLPixelFormat) -> () {
        invoke: (receiver: *MTLRenderPipelineDescriptor, selector: SEL, depthAttachmentPixelFormat: MTLPixelFormat) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setDepthAttachmentPixelFormat:\0"), depthAttachmentPixelFormat);
    }
    stencilAttachmentPixelFormat :: (self: *MTLRenderPipelineDescriptor) -> MTLPixelFormat {
        invoke: (receiver: *MTLRenderPipelineDescriptor, selector: SEL) -> MTLPixelFormat #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "stencilAttachmentPixelFormat\0"));
    }
    setStencilAttachmentPixelFormat :: (self: *MTLRenderPipelineDescriptor, stencilAttachmentPixelFormat: MTLPixelFormat) -> () {
        invoke: (receiver: *MTLRenderPipelineDescriptor, selector: SEL, stencilAttachmentPixelFormat: MTLPixelFormat) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setStencilAttachmentPixelFormat:\0"), stencilAttachmentPixelFormat);
    }
    inputPrimitiveTopology :: (self: *MTLRenderPipelineDescriptor) -> MTLPrimitiveTopologyClass {
        invoke: (receiver: *MTLRenderPipelineDescriptor, selector: SEL) -> MTLPrimitiveTopologyClass #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "inputPrimitiveTopology\0"));
    }
    setInputPrimitiveTopology :: (self: *MTLRenderPipelineDescriptor, inputPrimitiveTopology: MTLPrimitiveTopologyClass) -> () {
        invoke: (receiver: *MTLRenderPipelineDescriptor, selector: SEL, inputPrimitiveTopology: MTLPrimitiveTopologyClass) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setInputPrimitiveTopology:\0"), inputPrimitiveTopology);
    }
    tessellationPartitionMode :: (self: *MTLRenderPipelineDescriptor) -> MTLTessellationPartitionMode {
        invoke: (receiver: *MTLRenderPipelineDescriptor, selector: SEL) -> MTLTessellationPartitionMode #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "tessellationPartitionMode\0"));
    }
    setTessellationPartitionMode :: (self: *MTLRenderPipelineDescriptor, tessellationPartitionMode: MTLTessellationPartitionMode) -> () {
        invoke: (receiver: *MTLRenderPipelineDescriptor, selector: SEL, tessellationPartitionMode: MTLTessellationPartitionMode) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setTessellationPartitionMode:\0"), tessellationPartitionMode);
    }
    maxTessellationFactor :: (self: *MTLRenderPipelineDescriptor) -> NSUInteger {
        invoke: (receiver: *MTLRenderPipelineDescriptor, selector: SEL) -> NSUInteger #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "maxTessellationFactor\0"));
    }
    setMaxTessellationFactor :: (self: *MTLRenderPipelineDescriptor, maxTessellationFactor: NSUInteger) -> () {
        invoke: (receiver: *MTLRenderPipelineDescriptor, selector: SEL, maxTessellationFactor: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setMaxTessellationFactor:\0"), maxTessellationFactor);
    }
    isTessellationFactorScaleEnabled :: (self: *MTLRenderPipelineDescriptor) -> BOOL {
        invoke: (receiver: *MTLRenderPipelineDescriptor, selector: SEL) -> BOOL #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "isTessellationFactorScaleEnabled\0"));
    }
    setTessellationFactorScaleEnabled :: (self: *MTLRenderPipelineDescriptor, tessellationFactorScaleEnabled: BOOL) -> () {
        invoke: (receiver: *MTLRenderPipelineDescriptor, selector: SEL, tessellationFactorScaleEnabled: BOOL) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setTessellationFactorScaleEnabled:\0"), tessellationFactorScaleEnabled);
    }
    tessellationFactorFormat :: (self: *MTLRenderPipelineDescriptor) -> MTLTessellationFactorFormat {
        invoke: (receiver: *MTLRenderPipelineDescriptor, selector: SEL) -> MTLTessellationFactorFormat #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "tessellationFactorFormat\0"));
    }
    setTessellationFactorFormat :: (self: *MTLRenderPipelineDescriptor, tessellationFactorFormat: MTLTessellationFactorFormat) -> () {
        invoke: (receiver: *MTLRenderPipelineDescriptor, selector: SEL, tessellationFactorFormat: MTLTessellationFactorFormat) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setTessellationFactorFormat:\0"), tessellationFactorFormat);
    }
    tessellationControlPointIndexType :: (self: *MTLRenderPipelineDescriptor) -> MTLTessellationControlPointIndexType {
        invoke: (receiver: *MTLRenderPipelineDescriptor, selector: SEL) -> MTLTessellationControlPointIndexType #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "tessellationControlPointIndexType\0"));
    }
    setTessellationControlPointIndexType :: (self: *MTLRenderPipelineDescriptor, tessellationControlPointIndexType: MTLTessellationControlPointIndexType) -> () {
        invoke: (receiver: *MTLRenderPipelineDescriptor, selector: SEL, tessellationControlPointIndexType: MTLTessellationControlPointIndexType) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setTessellationControlPointIndexType:\0"), tessellationControlPointIndexType);
    }
    tessellationFactorStepFunction :: (self: *MTLRenderPipelineDescriptor) -> MTLTessellationFactorStepFunction {
        invoke: (receiver: *MTLRenderPipelineDescriptor, selector: SEL) -> MTLTessellationFactorStepFunction #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "tessellationFactorStepFunction\0"));
    }
    setTessellationFactorStepFunction :: (self: *MTLRenderPipelineDescriptor, tessellationFactorStepFunction: MTLTessellationFactorStepFunction) -> () {
        invoke: (receiver: *MTLRenderPipelineDescriptor, selector: SEL, tessellationFactorStepFunction: MTLTessellationFactorStepFunction) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setTessellationFactorStepFunction:\0"), tessellationFactorStepFunction);
    }
    tessellationOutputWindingOrder :: (self: *MTLRenderPipelineDescriptor) -> MTLWinding {
        invoke: (receiver: *MTLRenderPipelineDescriptor, selector: SEL) -> MTLWinding #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "tessellationOutputWindingOrder\0"));
    }
    setTessellationOutputWindingOrder :: (self: *MTLRenderPipelineDescriptor, tessellationOutputWindingOrder: MTLWinding) -> () {
        invoke: (receiver: *MTLRenderPipelineDescriptor, selector: SEL, tessellationOutputWindingOrder: MTLWinding) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setTessellationOutputWindingOrder:\0"), tessellationOutputWindingOrder);
    }
    vertexBuffers :: (self: *MTLRenderPipelineDescriptor) -> *MTLPipelineBufferDescriptorArray {
        invoke: (receiver: *MTLRenderPipelineDescriptor, selector: SEL) -> *MTLPipelineBufferDescriptorArray #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "vertexBuffers\0"));
    }
    fragmentBuffers :: (self: *MTLRenderPipelineDescriptor) -> *MTLPipelineBufferDescriptorArray {
        invoke: (receiver: *MTLRenderPipelineDescriptor, selector: SEL) -> *MTLPipelineBufferDescriptorArray #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "fragmentBuffers\0"));
    }
    supportIndirectCommandBuffers :: (self: *MTLRenderPipelineDescriptor) -> BOOL {
        invoke: (receiver: *MTLRenderPipelineDescriptor, selector: SEL) -> BOOL #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "supportIndirectCommandBuffers\0"));
    }
    setSupportIndirectCommandBuffers :: (self: *MTLRenderPipelineDescriptor, supportIndirectCommandBuffers: BOOL) -> () {
        invoke: (receiver: *MTLRenderPipelineDescriptor, selector: SEL, supportIndirectCommandBuffers: BOOL) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setSupportIndirectCommandBuffers:\0"), supportIndirectCommandBuffers);
    }
}
MTLRenderPipelineState :: struct {
    label :: (self: *MTLRenderPipelineState) -> *NSString {
        invoke: (receiver: *MTLRenderPipelineState, selector: SEL) -> *NSString #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "label\0"));
    }
    device :: (self: *MTLRenderPipelineState) -> id {
        invoke: (receiver: *MTLRenderPipelineState, selector: SEL) -> id #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "device\0"));
    }
    supportIndirectCommandBuffers :: (self: *MTLRenderPipelineState) -> BOOL {
        invoke: (receiver: *MTLRenderPipelineState, selector: SEL) -> BOOL #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "supportIndirectCommandBuffers\0"));
    }
}
MTLRenderPipelineColorAttachmentDescriptorArray :: struct {
    nsobject: NSObject;
    objectAtIndexedSubscript :: (self: *MTLRenderPipelineColorAttachmentDescriptorArray, attachmentIndex: NSUInteger) -> *MTLRenderPipelineColorAttachmentDescriptor {
        invoke: (receiver: *MTLRenderPipelineColorAttachmentDescriptorArray, selector: SEL, attachmentIndex: NSUInteger) -> *MTLRenderPipelineColorAttachmentDescriptor #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "objectAtIndexedSubscript:\0"), attachmentIndex);
    }
    setObject_atIndexedSubscript :: (self: *MTLRenderPipelineColorAttachmentDescriptorArray, attachment: *MTLRenderPipelineColorAttachmentDescriptor, attachmentIndex: NSUInteger) -> () {
        invoke: (receiver: *MTLRenderPipelineColorAttachmentDescriptorArray, selector: SEL, attachment: *MTLRenderPipelineColorAttachmentDescriptor, attachmentIndex: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setObject:atIndexedSubscript:\0"), attachment, attachmentIndex);
    }
}
using MTLVertexFormat :: enum NSUInteger {
    MTLVertexFormatInvalid :: 0;
    MTLVertexFormatUChar2 :: 1;
    MTLVertexFormatUChar3 :: 2;
    MTLVertexFormatUChar4 :: 3;
    MTLVertexFormatChar2 :: 4;
    MTLVertexFormatChar3 :: 5;
    MTLVertexFormatChar4 :: 6;
    MTLVertexFormatUChar2Normalized :: 7;
    MTLVertexFormatUChar3Normalized :: 8;
    MTLVertexFormatUChar4Normalized :: 9;
    MTLVertexFormatChar2Normalized :: 10;
    MTLVertexFormatChar3Normalized :: 11;
    MTLVertexFormatChar4Normalized :: 12;
    MTLVertexFormatUShort2 :: 13;
    MTLVertexFormatUShort3 :: 14;
    MTLVertexFormatUShort4 :: 15;
    MTLVertexFormatShort2 :: 16;
    MTLVertexFormatShort3 :: 17;
    MTLVertexFormatShort4 :: 18;
    MTLVertexFormatUShort2Normalized :: 19;
    MTLVertexFormatUShort3Normalized :: 20;
    MTLVertexFormatUShort4Normalized :: 21;
    MTLVertexFormatShort2Normalized :: 22;
    MTLVertexFormatShort3Normalized :: 23;
    MTLVertexFormatShort4Normalized :: 24;
    MTLVertexFormatHalf2 :: 25;
    MTLVertexFormatHalf3 :: 26;
    MTLVertexFormatHalf4 :: 27;
    MTLVertexFormatFloat :: 28;
    MTLVertexFormatFloat2 :: 29;
    MTLVertexFormatFloat3 :: 30;
    MTLVertexFormatFloat4 :: 31;
    MTLVertexFormatInt :: 32;
    MTLVertexFormatInt2 :: 33;
    MTLVertexFormatInt3 :: 34;
    MTLVertexFormatInt4 :: 35;
    MTLVertexFormatUInt :: 36;
    MTLVertexFormatUInt2 :: 37;
    MTLVertexFormatUInt3 :: 38;
    MTLVertexFormatUInt4 :: 39;
    MTLVertexFormatInt1010102Normalized :: 40;
    MTLVertexFormatUInt1010102Normalized :: 41;
    MTLVertexFormatUChar4Normalized_BGRA :: 42;
    MTLVertexFormatUChar :: 45;
    MTLVertexFormatChar :: 46;
    MTLVertexFormatUCharNormalized :: 47;
    MTLVertexFormatCharNormalized :: 48;
    MTLVertexFormatUShort :: 49;
    MTLVertexFormatShort :: 50;
    MTLVertexFormatUShortNormalized :: 51;
    MTLVertexFormatShortNormalized :: 52;
    MTLVertexFormatHalf :: 53;
}
using MTLVertexStepFunction :: enum NSUInteger {
    MTLVertexStepFunctionConstant :: 0;
    MTLVertexStepFunctionPerVertex :: 1;
    MTLVertexStepFunctionPerInstance :: 2;
    MTLVertexStepFunctionPerPatch :: 3;
    MTLVertexStepFunctionPerPatchControlPoint :: 4;
}
MTLVertexBufferLayoutDescriptor :: struct {
    nsobject: NSObject;
    stride :: (self: *MTLVertexBufferLayoutDescriptor) -> NSUInteger {
        invoke: (receiver: *MTLVertexBufferLayoutDescriptor, selector: SEL) -> NSUInteger #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "stride\0"));
    }
    setStride :: (self: *MTLVertexBufferLayoutDescriptor, stride: NSUInteger) -> () {
        invoke: (receiver: *MTLVertexBufferLayoutDescriptor, selector: SEL, stride: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setStride:\0"), stride);
    }
    stepFunction :: (self: *MTLVertexBufferLayoutDescriptor) -> MTLVertexStepFunction {
        invoke: (receiver: *MTLVertexBufferLayoutDescriptor, selector: SEL) -> MTLVertexStepFunction #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "stepFunction\0"));
    }
    setStepFunction :: (self: *MTLVertexBufferLayoutDescriptor, stepFunction: MTLVertexStepFunction) -> () {
        invoke: (receiver: *MTLVertexBufferLayoutDescriptor, selector: SEL, stepFunction: MTLVertexStepFunction) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setStepFunction:\0"), stepFunction);
    }
    stepRate :: (self: *MTLVertexBufferLayoutDescriptor) -> NSUInteger {
        invoke: (receiver: *MTLVertexBufferLayoutDescriptor, selector: SEL) -> NSUInteger #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "stepRate\0"));
    }
    setStepRate :: (self: *MTLVertexBufferLayoutDescriptor, stepRate: NSUInteger) -> () {
        invoke: (receiver: *MTLVertexBufferLayoutDescriptor, selector: SEL, stepRate: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setStepRate:\0"), stepRate);
    }
}
MTLVertexBufferLayoutDescriptorArray :: struct {
    nsobject: NSObject;
    objectAtIndexedSubscript :: (self: *MTLVertexBufferLayoutDescriptorArray, index: NSUInteger) -> *MTLVertexBufferLayoutDescriptor {
        invoke: (receiver: *MTLVertexBufferLayoutDescriptorArray, selector: SEL, index: NSUInteger) -> *MTLVertexBufferLayoutDescriptor #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "objectAtIndexedSubscript:\0"), index);
    }
    setObject_atIndexedSubscript :: (self: *MTLVertexBufferLayoutDescriptorArray, bufferDesc: *MTLVertexBufferLayoutDescriptor, index: NSUInteger) -> () {
        invoke: (receiver: *MTLVertexBufferLayoutDescriptorArray, selector: SEL, bufferDesc: *MTLVertexBufferLayoutDescriptor, index: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setObject:atIndexedSubscript:\0"), bufferDesc, index);
    }
}
MTLVertexAttributeDescriptor :: struct {
    nsobject: NSObject;
    format :: (self: *MTLVertexAttributeDescriptor) -> MTLVertexFormat {
        invoke: (receiver: *MTLVertexAttributeDescriptor, selector: SEL) -> MTLVertexFormat #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "format\0"));
    }
    setFormat :: (self: *MTLVertexAttributeDescriptor, format: MTLVertexFormat) -> () {
        invoke: (receiver: *MTLVertexAttributeDescriptor, selector: SEL, format: MTLVertexFormat) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setFormat:\0"), format);
    }
    offset :: (self: *MTLVertexAttributeDescriptor) -> NSUInteger {
        invoke: (receiver: *MTLVertexAttributeDescriptor, selector: SEL) -> NSUInteger #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "offset\0"));
    }
    setOffset :: (self: *MTLVertexAttributeDescriptor, offset: NSUInteger) -> () {
        invoke: (receiver: *MTLVertexAttributeDescriptor, selector: SEL, offset: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setOffset:\0"), offset);
    }
    bufferIndex :: (self: *MTLVertexAttributeDescriptor) -> NSUInteger {
        invoke: (receiver: *MTLVertexAttributeDescriptor, selector: SEL) -> NSUInteger #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "bufferIndex\0"));
    }
    setBufferIndex :: (self: *MTLVertexAttributeDescriptor, bufferIndex: NSUInteger) -> () {
        invoke: (receiver: *MTLVertexAttributeDescriptor, selector: SEL, bufferIndex: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setBufferIndex:\0"), bufferIndex);
    }
}
MTLVertexAttributeDescriptorArray :: struct {
    nsobject: NSObject;
    objectAtIndexedSubscript :: (self: *MTLVertexAttributeDescriptorArray, index: NSUInteger) -> *MTLVertexAttributeDescriptor {
        invoke: (receiver: *MTLVertexAttributeDescriptorArray, selector: SEL, index: NSUInteger) -> *MTLVertexAttributeDescriptor #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "objectAtIndexedSubscript:\0"), index);
    }
    setObject_atIndexedSubscript :: (self: *MTLVertexAttributeDescriptorArray, attributeDesc: *MTLVertexAttributeDescriptor, index: NSUInteger) -> () {
        invoke: (receiver: *MTLVertexAttributeDescriptorArray, selector: SEL, attributeDesc: *MTLVertexAttributeDescriptor, index: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setObject:atIndexedSubscript:\0"), attributeDesc, index);
    }
}
MTLVertexDescriptor :: struct {
    nsobject: NSObject;
    vertexDescriptor :: () -> *MTLVertexDescriptor {
        invoke: (receiver: Class, selector: SEL) -> *MTLVertexDescriptor #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(objc_getClass(cast(*u8) "MTLVertexDescriptor\0"), sel_registerName(cast(*u8) "vertexDescriptor\0"));
    }
    reset :: (self: *MTLVertexDescriptor) -> () {
        invoke: (receiver: *MTLVertexDescriptor, selector: SEL) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "reset\0"));
    }
    layouts :: (self: *MTLVertexDescriptor) -> *MTLVertexBufferLayoutDescriptorArray {
        invoke: (receiver: *MTLVertexDescriptor, selector: SEL) -> *MTLVertexBufferLayoutDescriptorArray #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "layouts\0"));
    }
    attributes :: (self: *MTLVertexDescriptor) -> *MTLVertexAttributeDescriptorArray {
        invoke: (receiver: *MTLVertexDescriptor, selector: SEL) -> *MTLVertexAttributeDescriptorArray #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "attributes\0"));
    }
}
MTLParallelRenderCommandEncoder :: struct {
    renderCommandEncoder :: (self: *MTLParallelRenderCommandEncoder) -> id {
        invoke: (receiver: *MTLParallelRenderCommandEncoder, selector: SEL) -> id #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "renderCommandEncoder\0"));
    }
    setColorStoreAction_atIndex :: (self: *MTLParallelRenderCommandEncoder, storeAction: MTLStoreAction, colorAttachmentIndex: NSUInteger) -> () {
        invoke: (receiver: *MTLParallelRenderCommandEncoder, selector: SEL, storeAction: MTLStoreAction, colorAttachmentIndex: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setColorStoreAction:atIndex:\0"), storeAction, colorAttachmentIndex);
    }
    setDepthStoreAction :: (self: *MTLParallelRenderCommandEncoder, storeAction: MTLStoreAction) -> () {
        invoke: (receiver: *MTLParallelRenderCommandEncoder, selector: SEL, storeAction: MTLStoreAction) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setDepthStoreAction:\0"), storeAction);
    }
    setStencilStoreAction :: (self: *MTLParallelRenderCommandEncoder, storeAction: MTLStoreAction) -> () {
        invoke: (receiver: *MTLParallelRenderCommandEncoder, selector: SEL, storeAction: MTLStoreAction) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setStencilStoreAction:\0"), storeAction);
    }
    setColorStoreActionOptions_atIndex :: (self: *MTLParallelRenderCommandEncoder, storeActionOptions: MTLStoreActionOptions, colorAttachmentIndex: NSUInteger) -> () {
        invoke: (receiver: *MTLParallelRenderCommandEncoder, selector: SEL, storeActionOptions: MTLStoreActionOptions, colorAttachmentIndex: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setColorStoreActionOptions:atIndex:\0"), storeActionOptions, colorAttachmentIndex);
    }
    setDepthStoreActionOptions :: (self: *MTLParallelRenderCommandEncoder, storeActionOptions: MTLStoreActionOptions) -> () {
        invoke: (receiver: *MTLParallelRenderCommandEncoder, selector: SEL, storeActionOptions: MTLStoreActionOptions) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setDepthStoreActionOptions:\0"), storeActionOptions);
    }
    setStencilStoreActionOptions :: (self: *MTLParallelRenderCommandEncoder, storeActionOptions: MTLStoreActionOptions) -> () {
        invoke: (receiver: *MTLParallelRenderCommandEncoder, selector: SEL, storeActionOptions: MTLStoreActionOptions) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setStencilStoreActionOptions:\0"), storeActionOptions);
    }
}
using MTLSamplerMinMagFilter :: enum NSUInteger {
    MTLSamplerMinMagFilterNearest :: 0;
    MTLSamplerMinMagFilterLinear :: 1;
}
using MTLSamplerMipFilter :: enum NSUInteger {
    MTLSamplerMipFilterNotMipmapped :: 0;
    MTLSamplerMipFilterNearest :: 1;
    MTLSamplerMipFilterLinear :: 2;
}
using MTLSamplerAddressMode :: enum NSUInteger {
    MTLSamplerAddressModeClampToEdge :: 0;
    MTLSamplerAddressModeMirrorClampToEdge :: 1;
    MTLSamplerAddressModeRepeat :: 2;
    MTLSamplerAddressModeMirrorRepeat :: 3;
    MTLSamplerAddressModeClampToZero :: 4;
    MTLSamplerAddressModeClampToBorderColor :: 5;
}
using MTLSamplerBorderColor :: enum NSUInteger {
    MTLSamplerBorderColorTransparentBlack :: 0;
    MTLSamplerBorderColorOpaqueBlack :: 1;
    MTLSamplerBorderColorOpaqueWhite :: 2;
}
MTLSamplerDescriptor :: struct {
    nsobject: NSObject;
    minFilter :: (self: *MTLSamplerDescriptor) -> MTLSamplerMinMagFilter {
        invoke: (receiver: *MTLSamplerDescriptor, selector: SEL) -> MTLSamplerMinMagFilter #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "minFilter\0"));
    }
    setMinFilter :: (self: *MTLSamplerDescriptor, minFilter: MTLSamplerMinMagFilter) -> () {
        invoke: (receiver: *MTLSamplerDescriptor, selector: SEL, minFilter: MTLSamplerMinMagFilter) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setMinFilter:\0"), minFilter);
    }
    magFilter :: (self: *MTLSamplerDescriptor) -> MTLSamplerMinMagFilter {
        invoke: (receiver: *MTLSamplerDescriptor, selector: SEL) -> MTLSamplerMinMagFilter #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "magFilter\0"));
    }
    setMagFilter :: (self: *MTLSamplerDescriptor, magFilter: MTLSamplerMinMagFilter) -> () {
        invoke: (receiver: *MTLSamplerDescriptor, selector: SEL, magFilter: MTLSamplerMinMagFilter) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setMagFilter:\0"), magFilter);
    }
    mipFilter :: (self: *MTLSamplerDescriptor) -> MTLSamplerMipFilter {
        invoke: (receiver: *MTLSamplerDescriptor, selector: SEL) -> MTLSamplerMipFilter #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "mipFilter\0"));
    }
    setMipFilter :: (self: *MTLSamplerDescriptor, mipFilter: MTLSamplerMipFilter) -> () {
        invoke: (receiver: *MTLSamplerDescriptor, selector: SEL, mipFilter: MTLSamplerMipFilter) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setMipFilter:\0"), mipFilter);
    }
    maxAnisotropy :: (self: *MTLSamplerDescriptor) -> NSUInteger {
        invoke: (receiver: *MTLSamplerDescriptor, selector: SEL) -> NSUInteger #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "maxAnisotropy\0"));
    }
    setMaxAnisotropy :: (self: *MTLSamplerDescriptor, maxAnisotropy: NSUInteger) -> () {
        invoke: (receiver: *MTLSamplerDescriptor, selector: SEL, maxAnisotropy: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setMaxAnisotropy:\0"), maxAnisotropy);
    }
    sAddressMode :: (self: *MTLSamplerDescriptor) -> MTLSamplerAddressMode {
        invoke: (receiver: *MTLSamplerDescriptor, selector: SEL) -> MTLSamplerAddressMode #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "sAddressMode\0"));
    }
    setSAddressMode :: (self: *MTLSamplerDescriptor, sAddressMode: MTLSamplerAddressMode) -> () {
        invoke: (receiver: *MTLSamplerDescriptor, selector: SEL, sAddressMode: MTLSamplerAddressMode) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setSAddressMode:\0"), sAddressMode);
    }
    tAddressMode :: (self: *MTLSamplerDescriptor) -> MTLSamplerAddressMode {
        invoke: (receiver: *MTLSamplerDescriptor, selector: SEL) -> MTLSamplerAddressMode #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "tAddressMode\0"));
    }
    setTAddressMode :: (self: *MTLSamplerDescriptor, tAddressMode: MTLSamplerAddressMode) -> () {
        invoke: (receiver: *MTLSamplerDescriptor, selector: SEL, tAddressMode: MTLSamplerAddressMode) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setTAddressMode:\0"), tAddressMode);
    }
    rAddressMode :: (self: *MTLSamplerDescriptor) -> MTLSamplerAddressMode {
        invoke: (receiver: *MTLSamplerDescriptor, selector: SEL) -> MTLSamplerAddressMode #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "rAddressMode\0"));
    }
    setRAddressMode :: (self: *MTLSamplerDescriptor, rAddressMode: MTLSamplerAddressMode) -> () {
        invoke: (receiver: *MTLSamplerDescriptor, selector: SEL, rAddressMode: MTLSamplerAddressMode) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setRAddressMode:\0"), rAddressMode);
    }
    borderColor :: (self: *MTLSamplerDescriptor) -> MTLSamplerBorderColor {
        invoke: (receiver: *MTLSamplerDescriptor, selector: SEL) -> MTLSamplerBorderColor #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "borderColor\0"));
    }
    setBorderColor :: (self: *MTLSamplerDescriptor, borderColor: MTLSamplerBorderColor) -> () {
        invoke: (receiver: *MTLSamplerDescriptor, selector: SEL, borderColor: MTLSamplerBorderColor) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setBorderColor:\0"), borderColor);
    }
    normalizedCoordinates :: (self: *MTLSamplerDescriptor) -> BOOL {
        invoke: (receiver: *MTLSamplerDescriptor, selector: SEL) -> BOOL #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "normalizedCoordinates\0"));
    }
    setNormalizedCoordinates :: (self: *MTLSamplerDescriptor, normalizedCoordinates: BOOL) -> () {
        invoke: (receiver: *MTLSamplerDescriptor, selector: SEL, normalizedCoordinates: BOOL) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setNormalizedCoordinates:\0"), normalizedCoordinates);
    }
    lodMinClamp :: (self: *MTLSamplerDescriptor) -> float32 {
        invoke: (receiver: *MTLSamplerDescriptor, selector: SEL) -> float32 #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "lodMinClamp\0"));
    }
    setLodMinClamp :: (self: *MTLSamplerDescriptor, lodMinClamp: float32) -> () {
        invoke: (receiver: *MTLSamplerDescriptor, selector: SEL, lodMinClamp: float32) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setLodMinClamp:\0"), lodMinClamp);
    }
    lodMaxClamp :: (self: *MTLSamplerDescriptor) -> float32 {
        invoke: (receiver: *MTLSamplerDescriptor, selector: SEL) -> float32 #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "lodMaxClamp\0"));
    }
    setLodMaxClamp :: (self: *MTLSamplerDescriptor, lodMaxClamp: float32) -> () {
        invoke: (receiver: *MTLSamplerDescriptor, selector: SEL, lodMaxClamp: float32) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setLodMaxClamp:\0"), lodMaxClamp);
    }
    lodAverage :: (self: *MTLSamplerDescriptor) -> BOOL {
        invoke: (receiver: *MTLSamplerDescriptor, selector: SEL) -> BOOL #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "lodAverage\0"));
    }
    setLodAverage :: (self: *MTLSamplerDescriptor, lodAverage: BOOL) -> () {
        invoke: (receiver: *MTLSamplerDescriptor, selector: SEL, lodAverage: BOOL) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setLodAverage:\0"), lodAverage);
    }
    compareFunction :: (self: *MTLSamplerDescriptor) -> MTLCompareFunction {
        invoke: (receiver: *MTLSamplerDescriptor, selector: SEL) -> MTLCompareFunction #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "compareFunction\0"));
    }
    setCompareFunction :: (self: *MTLSamplerDescriptor, compareFunction: MTLCompareFunction) -> () {
        invoke: (receiver: *MTLSamplerDescriptor, selector: SEL, compareFunction: MTLCompareFunction) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setCompareFunction:\0"), compareFunction);
    }
    supportArgumentBuffers :: (self: *MTLSamplerDescriptor) -> BOOL {
        invoke: (receiver: *MTLSamplerDescriptor, selector: SEL) -> BOOL #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "supportArgumentBuffers\0"));
    }
    setSupportArgumentBuffers :: (self: *MTLSamplerDescriptor, supportArgumentBuffers: BOOL) -> () {
        invoke: (receiver: *MTLSamplerDescriptor, selector: SEL, supportArgumentBuffers: BOOL) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setSupportArgumentBuffers:\0"), supportArgumentBuffers);
    }
    label :: (self: *MTLSamplerDescriptor) -> *NSString {
        invoke: (receiver: *MTLSamplerDescriptor, selector: SEL) -> *NSString #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "label\0"));
    }
    setLabel :: (self: *MTLSamplerDescriptor, label: *NSString) -> () {
        invoke: (receiver: *MTLSamplerDescriptor, selector: SEL, label: *NSString) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setLabel:\0"), label);
    }
}
MTLSamplerState :: struct {
    label :: (self: *MTLSamplerState) -> *NSString {
        invoke: (receiver: *MTLSamplerState, selector: SEL) -> *NSString #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "label\0"));
    }
    device :: (self: *MTLSamplerState) -> id {
        invoke: (receiver: *MTLSamplerState, selector: SEL) -> id #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "device\0"));
    }
}
MTLHeapDescriptor :: struct {
    nsobject: NSObject;
    size :: (self: *MTLHeapDescriptor) -> NSUInteger {
        invoke: (receiver: *MTLHeapDescriptor, selector: SEL) -> NSUInteger #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "size\0"));
    }
    setSize :: (self: *MTLHeapDescriptor, size: NSUInteger) -> () {
        invoke: (receiver: *MTLHeapDescriptor, selector: SEL, size: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setSize:\0"), size);
    }
    storageMode :: (self: *MTLHeapDescriptor) -> MTLStorageMode {
        invoke: (receiver: *MTLHeapDescriptor, selector: SEL) -> MTLStorageMode #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "storageMode\0"));
    }
    setStorageMode :: (self: *MTLHeapDescriptor, storageMode: MTLStorageMode) -> () {
        invoke: (receiver: *MTLHeapDescriptor, selector: SEL, storageMode: MTLStorageMode) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setStorageMode:\0"), storageMode);
    }
    cpuCacheMode :: (self: *MTLHeapDescriptor) -> MTLCPUCacheMode {
        invoke: (receiver: *MTLHeapDescriptor, selector: SEL) -> MTLCPUCacheMode #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "cpuCacheMode\0"));
    }
    setCpuCacheMode :: (self: *MTLHeapDescriptor, cpuCacheMode: MTLCPUCacheMode) -> () {
        invoke: (receiver: *MTLHeapDescriptor, selector: SEL, cpuCacheMode: MTLCPUCacheMode) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setCpuCacheMode:\0"), cpuCacheMode);
    }
}
MTLHeap :: struct {
    maxAvailableSizeWithAlignment :: (self: *MTLHeap, alignment: NSUInteger) -> NSUInteger {
        invoke: (receiver: *MTLHeap, selector: SEL, alignment: NSUInteger) -> NSUInteger #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "maxAvailableSizeWithAlignment:\0"), alignment);
    }
    newBufferWithLength_options :: (self: *MTLHeap, length: NSUInteger, options: MTLResourceOptions) -> *MTLBuffer {
        invoke: (receiver: *MTLHeap, selector: SEL, length: NSUInteger, options: MTLResourceOptions) -> *MTLBuffer #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "newBufferWithLength:options:\0"), length, options);
    }
    newTextureWithDescriptor :: (self: *MTLHeap, desc: *MTLTextureDescriptor) -> id {
        invoke: (receiver: *MTLHeap, selector: SEL, desc: *MTLTextureDescriptor) -> id #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "newTextureWithDescriptor:\0"), desc);
    }
    setPurgeableState :: (self: *MTLHeap, state: MTLPurgeableState) -> MTLPurgeableState {
        invoke: (receiver: *MTLHeap, selector: SEL, state: MTLPurgeableState) -> MTLPurgeableState #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "setPurgeableState:\0"), state);
    }
    label :: (self: *MTLHeap) -> *NSString {
        invoke: (receiver: *MTLHeap, selector: SEL) -> *NSString #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "label\0"));
    }
    setLabel :: (self: *MTLHeap, label: *NSString) -> () {
        invoke: (receiver: *MTLHeap, selector: SEL, label: *NSString) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setLabel:\0"), label);
    }
    device :: (self: *MTLHeap) -> id {
        invoke: (receiver: *MTLHeap, selector: SEL) -> id #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "device\0"));
    }
    storageMode :: (self: *MTLHeap) -> MTLStorageMode {
        invoke: (receiver: *MTLHeap, selector: SEL) -> MTLStorageMode #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "storageMode\0"));
    }
    cpuCacheMode :: (self: *MTLHeap) -> MTLCPUCacheMode {
        invoke: (receiver: *MTLHeap, selector: SEL) -> MTLCPUCacheMode #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "cpuCacheMode\0"));
    }
    size :: (self: *MTLHeap) -> NSUInteger {
        invoke: (receiver: *MTLHeap, selector: SEL) -> NSUInteger #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "size\0"));
    }
    usedSize :: (self: *MTLHeap) -> NSUInteger {
        invoke: (receiver: *MTLHeap, selector: SEL) -> NSUInteger #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "usedSize\0"));
    }
    currentAllocatedSize :: (self: *MTLHeap) -> NSUInteger {
        invoke: (receiver: *MTLHeap, selector: SEL) -> NSUInteger #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "currentAllocatedSize\0"));
    }
}
MTLArgumentEncoder :: struct {
    setArgumentBuffer_offset :: (self: *MTLArgumentEncoder, argumentBuffer: id, offset: NSUInteger) -> () {
        invoke: (receiver: *MTLArgumentEncoder, selector: SEL, argumentBuffer: id, offset: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setArgumentBuffer:offset:\0"), argumentBuffer, offset);
    }
    setArgumentBuffer_startOffset_arrayElement :: (self: *MTLArgumentEncoder, argumentBuffer: id, startOffset: NSUInteger, arrayElement: NSUInteger) -> () {
        invoke: (receiver: *MTLArgumentEncoder, selector: SEL, argumentBuffer: id, startOffset: NSUInteger, arrayElement: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setArgumentBuffer:startOffset:arrayElement:\0"), argumentBuffer, startOffset, arrayElement);
    }
    setBuffer_offset_atIndex :: (self: *MTLArgumentEncoder, buffer: id, offset: NSUInteger, index: NSUInteger) -> () {
        invoke: (receiver: *MTLArgumentEncoder, selector: SEL, buffer: id, offset: NSUInteger, index: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setBuffer:offset:atIndex:\0"), buffer, offset, index);
    }
    setBuffers_offsets_withRange :: (self: *MTLArgumentEncoder, buffers: *id, offsets: *NSUInteger, range: NSRange) -> () {
        invoke: (receiver: *MTLArgumentEncoder, selector: SEL, buffers: *id, offsets: *NSUInteger, range: NSRange) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setBuffers:offsets:withRange:\0"), buffers, offsets, range);
    }
    setTexture_atIndex :: (self: *MTLArgumentEncoder, texture: id, index: NSUInteger) -> () {
        invoke: (receiver: *MTLArgumentEncoder, selector: SEL, texture: id, index: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setTexture:atIndex:\0"), texture, index);
    }
    setTextures_withRange :: (self: *MTLArgumentEncoder, textures: *id, range: NSRange) -> () {
        invoke: (receiver: *MTLArgumentEncoder, selector: SEL, textures: *id, range: NSRange) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setTextures:withRange:\0"), textures, range);
    }
    setSamplerState_atIndex :: (self: *MTLArgumentEncoder, sampler: id, index: NSUInteger) -> () {
        invoke: (receiver: *MTLArgumentEncoder, selector: SEL, sampler: id, index: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setSamplerState:atIndex:\0"), sampler, index);
    }
    setSamplerStates_withRange :: (self: *MTLArgumentEncoder, samplers: *id, range: NSRange) -> () {
        invoke: (receiver: *MTLArgumentEncoder, selector: SEL, samplers: *id, range: NSRange) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setSamplerStates:withRange:\0"), samplers, range);
    }
    constantDataAtIndex :: (self: *MTLArgumentEncoder, index: NSUInteger) -> *void {
        invoke: (receiver: *MTLArgumentEncoder, selector: SEL, index: NSUInteger) -> *void #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "constantDataAtIndex:\0"), index);
    }
    setRenderPipelineState_atIndex :: (self: *MTLArgumentEncoder, pipeline: id, index: NSUInteger) -> () {
        invoke: (receiver: *MTLArgumentEncoder, selector: SEL, pipeline: id, index: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setRenderPipelineState:atIndex:\0"), pipeline, index);
    }
    setRenderPipelineStates_withRange :: (self: *MTLArgumentEncoder, pipelines: *id, range: NSRange) -> () {
        invoke: (receiver: *MTLArgumentEncoder, selector: SEL, pipelines: *id, range: NSRange) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setRenderPipelineStates:withRange:\0"), pipelines, range);
    }
    setIndirectCommandBuffer_atIndex :: (self: *MTLArgumentEncoder, indirectCommandBuffer: id, index: NSUInteger) -> () {
        invoke: (receiver: *MTLArgumentEncoder, selector: SEL, indirectCommandBuffer: id, index: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setIndirectCommandBuffer:atIndex:\0"), indirectCommandBuffer, index);
    }
    setIndirectCommandBuffers_withRange :: (self: *MTLArgumentEncoder, buffers: *id, range: NSRange) -> () {
        invoke: (receiver: *MTLArgumentEncoder, selector: SEL, buffers: *id, range: NSRange) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setIndirectCommandBuffers:withRange:\0"), buffers, range);
    }
    newArgumentEncoderForBufferAtIndex :: (self: *MTLArgumentEncoder, index: NSUInteger) -> id {
        invoke: (receiver: *MTLArgumentEncoder, selector: SEL, index: NSUInteger) -> id #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "newArgumentEncoderForBufferAtIndex:\0"), index);
    }
    device :: (self: *MTLArgumentEncoder) -> id {
        invoke: (receiver: *MTLArgumentEncoder, selector: SEL) -> id #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "device\0"));
    }
    label :: (self: *MTLArgumentEncoder) -> *NSString {
        invoke: (receiver: *MTLArgumentEncoder, selector: SEL) -> *NSString #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "label\0"));
    }
    setLabel :: (self: *MTLArgumentEncoder, label: *NSString) -> () {
        invoke: (receiver: *MTLArgumentEncoder, selector: SEL, label: *NSString) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setLabel:\0"), label);
    }
    encodedLength :: (self: *MTLArgumentEncoder) -> NSUInteger {
        invoke: (receiver: *MTLArgumentEncoder, selector: SEL) -> NSUInteger #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "encodedLength\0"));
    }
    alignment :: (self: *MTLArgumentEncoder) -> NSUInteger {
        invoke: (receiver: *MTLArgumentEncoder, selector: SEL) -> NSUInteger #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "alignment\0"));
    }
}
MTLCaptureManager :: struct {
    nsobject: NSObject;
    _isCapturing: BOOL;
    _defaultCaptureScope: id;
    sharedCaptureManager :: () -> *MTLCaptureManager {
        invoke: (receiver: Class, selector: SEL) -> *MTLCaptureManager #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(objc_getClass(cast(*u8) "MTLCaptureManager\0"), sel_registerName(cast(*u8) "sharedCaptureManager\0"));
    }
    init :: (self: *MTLCaptureManager) -> *MTLCaptureManager {
        invoke: (receiver: *MTLCaptureManager, selector: SEL) -> *MTLCaptureManager #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "init\0"));
    }
    newCaptureScopeWithDevice :: (self: *MTLCaptureManager, device: id) -> id {
        invoke: (receiver: *MTLCaptureManager, selector: SEL, device: id) -> id #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "newCaptureScopeWithDevice:\0"), device);
    }
    newCaptureScopeWithCommandQueue :: (self: *MTLCaptureManager, commandQueue: id) -> id {
        invoke: (receiver: *MTLCaptureManager, selector: SEL, commandQueue: id) -> id #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "newCaptureScopeWithCommandQueue:\0"), commandQueue);
    }
    startCaptureWithDevice :: (self: *MTLCaptureManager, device: id) -> () {
        invoke: (receiver: *MTLCaptureManager, selector: SEL, device: id) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "startCaptureWithDevice:\0"), device);
    }
    startCaptureWithCommandQueue :: (self: *MTLCaptureManager, commandQueue: id) -> () {
        invoke: (receiver: *MTLCaptureManager, selector: SEL, commandQueue: id) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "startCaptureWithCommandQueue:\0"), commandQueue);
    }
    startCaptureWithScope :: (self: *MTLCaptureManager, captureScope: id) -> () {
        invoke: (receiver: *MTLCaptureManager, selector: SEL, captureScope: id) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "startCaptureWithScope:\0"), captureScope);
    }
    stopCapture :: (self: *MTLCaptureManager) -> () {
        invoke: (receiver: *MTLCaptureManager, selector: SEL) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "stopCapture\0"));
    }
    defaultCaptureScope :: (self: *MTLCaptureManager) -> id {
        invoke: (receiver: *MTLCaptureManager, selector: SEL) -> id #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "defaultCaptureScope\0"));
    }
    setDefaultCaptureScope :: (self: *MTLCaptureManager, defaultCaptureScope: id) -> () {
        invoke: (receiver: *MTLCaptureManager, selector: SEL, defaultCaptureScope: id) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setDefaultCaptureScope:\0"), defaultCaptureScope);
    }
    isCapturing :: (self: *MTLCaptureManager) -> BOOL {
        invoke: (receiver: *MTLCaptureManager, selector: SEL) -> BOOL #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "isCapturing\0"));
    }
}
MTLCaptureScope :: struct {
    beginScope :: (self: *MTLCaptureScope) -> () {
        invoke: (receiver: *MTLCaptureScope, selector: SEL) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "beginScope\0"));
    }
    endScope :: (self: *MTLCaptureScope) -> () {
        invoke: (receiver: *MTLCaptureScope, selector: SEL) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "endScope\0"));
    }
    label :: (self: *MTLCaptureScope) -> *NSString {
        invoke: (receiver: *MTLCaptureScope, selector: SEL) -> *NSString #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "label\0"));
    }
    setLabel :: (self: *MTLCaptureScope, label: *NSString) -> () {
        invoke: (receiver: *MTLCaptureScope, selector: SEL, label: *NSString) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setLabel:\0"), label);
    }
    device :: (self: *MTLCaptureScope) -> id {
        invoke: (receiver: *MTLCaptureScope, selector: SEL) -> id #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "device\0"));
    }
    commandQueue :: (self: *MTLCaptureScope) -> id {
        invoke: (receiver: *MTLCaptureScope, selector: SEL) -> id #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "commandQueue\0"));
    }
}
MTLIndirectRenderCommand :: struct {
    setRenderPipelineState :: (self: *MTLIndirectRenderCommand, pipelineState: id) -> () {
        invoke: (receiver: *MTLIndirectRenderCommand, selector: SEL, pipelineState: id) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setRenderPipelineState:\0"), pipelineState);
    }
    setVertexBuffer_offset_atIndex :: (self: *MTLIndirectRenderCommand, buffer: id, offset: NSUInteger, index: NSUInteger) -> () {
        invoke: (receiver: *MTLIndirectRenderCommand, selector: SEL, buffer: id, offset: NSUInteger, index: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setVertexBuffer:offset:atIndex:\0"), buffer, offset, index);
    }
    setFragmentBuffer_offset_atIndex :: (self: *MTLIndirectRenderCommand, buffer: id, offset: NSUInteger, index: NSUInteger) -> () {
        invoke: (receiver: *MTLIndirectRenderCommand, selector: SEL, buffer: id, offset: NSUInteger, index: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setFragmentBuffer:offset:atIndex:\0"), buffer, offset, index);
    }
    drawPatches_patchStart_patchCount_patchIndexBuffer_patchIndexBufferOffset_instanceCount_baseInstance_tessellationFactorBuffer_tessellationFactorBufferOffset_tessellationFactorBufferInstanceStride :: (self: *MTLIndirectRenderCommand, numberOfPatchControlPoints: NSUInteger, patchStart: NSUInteger, patchCount: NSUInteger, patchIndexBuffer: id, patchIndexBufferOffset: NSUInteger, instanceCount: NSUInteger, baseInstance: NSUInteger, buffer: id, offset: NSUInteger, instanceStride: NSUInteger) -> () {
        invoke: (receiver: *MTLIndirectRenderCommand, selector: SEL, numberOfPatchControlPoints: NSUInteger, patchStart: NSUInteger, patchCount: NSUInteger, patchIndexBuffer: id, patchIndexBufferOffset: NSUInteger, instanceCount: NSUInteger, baseInstance: NSUInteger, buffer: id, offset: NSUInteger, instanceStride: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "drawPatches:patchStart:patchCount:patchIndexBuffer:patchIndexBufferOffset:instanceCount:baseInstance:tessellationFactorBuffer:tessellationFactorBufferOffset:tessellationFactorBufferInstanceStride:\0"), numberOfPatchControlPoints, patchStart, patchCount, patchIndexBuffer, patchIndexBufferOffset, instanceCount, baseInstance, buffer, offset, instanceStride);
    }
    drawIndexedPatches_patchStart_patchCount_patchIndexBuffer_patchIndexBufferOffset_controlPointIndexBuffer_controlPointIndexBufferOffset_instanceCount_baseInstance_tessellationFactorBuffer_tessellationFactorBufferOffset_tessellationFactorBufferInstanceStride :: (self: *MTLIndirectRenderCommand, numberOfPatchControlPoints: NSUInteger, patchStart: NSUInteger, patchCount: NSUInteger, patchIndexBuffer: id, patchIndexBufferOffset: NSUInteger, controlPointIndexBuffer: id, controlPointIndexBufferOffset: NSUInteger, instanceCount: NSUInteger, baseInstance: NSUInteger, buffer: id, offset: NSUInteger, instanceStride: NSUInteger) -> () {
        invoke: (receiver: *MTLIndirectRenderCommand, selector: SEL, numberOfPatchControlPoints: NSUInteger, patchStart: NSUInteger, patchCount: NSUInteger, patchIndexBuffer: id, patchIndexBufferOffset: NSUInteger, controlPointIndexBuffer: id, controlPointIndexBufferOffset: NSUInteger, instanceCount: NSUInteger, baseInstance: NSUInteger, buffer: id, offset: NSUInteger, instanceStride: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "drawIndexedPatches:patchStart:patchCount:patchIndexBuffer:patchIndexBufferOffset:controlPointIndexBuffer:controlPointIndexBufferOffset:instanceCount:baseInstance:tessellationFactorBuffer:tessellationFactorBufferOffset:tessellationFactorBufferInstanceStride:\0"), numberOfPatchControlPoints, patchStart, patchCount, patchIndexBuffer, patchIndexBufferOffset, controlPointIndexBuffer, controlPointIndexBufferOffset, instanceCount, baseInstance, buffer, offset, instanceStride);
    }
    drawPrimitives_vertexStart_vertexCount_instanceCount_baseInstance :: (self: *MTLIndirectRenderCommand, primitiveType: MTLPrimitiveType, vertexStart: NSUInteger, vertexCount: NSUInteger, instanceCount: NSUInteger, baseInstance: NSUInteger) -> () {
        invoke: (receiver: *MTLIndirectRenderCommand, selector: SEL, primitiveType: MTLPrimitiveType, vertexStart: NSUInteger, vertexCount: NSUInteger, instanceCount: NSUInteger, baseInstance: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "drawPrimitives:vertexStart:vertexCount:instanceCount:baseInstance:\0"), primitiveType, vertexStart, vertexCount, instanceCount, baseInstance);
    }
    drawIndexedPrimitives_indexCount_indexType_indexBuffer_indexBufferOffset_instanceCount_baseVertex_baseInstance :: (self: *MTLIndirectRenderCommand, primitiveType: MTLPrimitiveType, indexCount: NSUInteger, indexType: MTLIndexType, indexBuffer: id, indexBufferOffset: NSUInteger, instanceCount: NSUInteger, baseVertex: NSInteger, baseInstance: NSUInteger) -> () {
        invoke: (receiver: *MTLIndirectRenderCommand, selector: SEL, primitiveType: MTLPrimitiveType, indexCount: NSUInteger, indexType: MTLIndexType, indexBuffer: id, indexBufferOffset: NSUInteger, instanceCount: NSUInteger, baseVertex: NSInteger, baseInstance: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "drawIndexedPrimitives:indexCount:indexType:indexBuffer:indexBufferOffset:instanceCount:baseVertex:baseInstance:\0"), primitiveType, indexCount, indexType, indexBuffer, indexBufferOffset, instanceCount, baseVertex, baseInstance);
    }
    reset :: (self: *MTLIndirectRenderCommand) -> () {
        invoke: (receiver: *MTLIndirectRenderCommand, selector: SEL) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "reset\0"));
    }
}
using MTLIndirectCommandType :: enum NSUInteger {
    MTLIndirectCommandTypeDraw :: 1;
    MTLIndirectCommandTypeDrawIndexed :: 2;
    MTLIndirectCommandTypeDrawPatches :: 4;
    MTLIndirectCommandTypeDrawIndexedPatches :: 8;
}
MTLIndirectCommandBufferDescriptor :: struct {
    nsobject: NSObject;
    commandTypes :: (self: *MTLIndirectCommandBufferDescriptor) -> MTLIndirectCommandType {
        invoke: (receiver: *MTLIndirectCommandBufferDescriptor, selector: SEL) -> MTLIndirectCommandType #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "commandTypes\0"));
    }
    setCommandTypes :: (self: *MTLIndirectCommandBufferDescriptor, commandTypes: MTLIndirectCommandType) -> () {
        invoke: (receiver: *MTLIndirectCommandBufferDescriptor, selector: SEL, commandTypes: MTLIndirectCommandType) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setCommandTypes:\0"), commandTypes);
    }
    inheritPipelineState :: (self: *MTLIndirectCommandBufferDescriptor) -> BOOL {
        invoke: (receiver: *MTLIndirectCommandBufferDescriptor, selector: SEL) -> BOOL #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "inheritPipelineState\0"));
    }
    setInheritPipelineState :: (self: *MTLIndirectCommandBufferDescriptor, inheritPipelineState: BOOL) -> () {
        invoke: (receiver: *MTLIndirectCommandBufferDescriptor, selector: SEL, inheritPipelineState: BOOL) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setInheritPipelineState:\0"), inheritPipelineState);
    }
    inheritBuffers :: (self: *MTLIndirectCommandBufferDescriptor) -> BOOL {
        invoke: (receiver: *MTLIndirectCommandBufferDescriptor, selector: SEL) -> BOOL #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "inheritBuffers\0"));
    }
    setInheritBuffers :: (self: *MTLIndirectCommandBufferDescriptor, inheritBuffers: BOOL) -> () {
        invoke: (receiver: *MTLIndirectCommandBufferDescriptor, selector: SEL, inheritBuffers: BOOL) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setInheritBuffers:\0"), inheritBuffers);
    }
    maxVertexBufferBindCount :: (self: *MTLIndirectCommandBufferDescriptor) -> NSUInteger {
        invoke: (receiver: *MTLIndirectCommandBufferDescriptor, selector: SEL) -> NSUInteger #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "maxVertexBufferBindCount\0"));
    }
    setMaxVertexBufferBindCount :: (self: *MTLIndirectCommandBufferDescriptor, maxVertexBufferBindCount: NSUInteger) -> () {
        invoke: (receiver: *MTLIndirectCommandBufferDescriptor, selector: SEL, maxVertexBufferBindCount: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setMaxVertexBufferBindCount:\0"), maxVertexBufferBindCount);
    }
    maxFragmentBufferBindCount :: (self: *MTLIndirectCommandBufferDescriptor) -> NSUInteger {
        invoke: (receiver: *MTLIndirectCommandBufferDescriptor, selector: SEL) -> NSUInteger #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "maxFragmentBufferBindCount\0"));
    }
    setMaxFragmentBufferBindCount :: (self: *MTLIndirectCommandBufferDescriptor, maxFragmentBufferBindCount: NSUInteger) -> () {
        invoke: (receiver: *MTLIndirectCommandBufferDescriptor, selector: SEL, maxFragmentBufferBindCount: NSUInteger) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setMaxFragmentBufferBindCount:\0"), maxFragmentBufferBindCount);
    }
}
MTLIndirectCommandBuffer :: struct {
    resetWithRange :: (self: *MTLIndirectCommandBuffer, range: NSRange) -> () {
        invoke: (receiver: *MTLIndirectCommandBuffer, selector: SEL, range: NSRange) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "resetWithRange:\0"), range);
    }
    indirectRenderCommandAtIndex :: (self: *MTLIndirectCommandBuffer, commandIndex: NSUInteger) -> id {
        invoke: (receiver: *MTLIndirectCommandBuffer, selector: SEL, commandIndex: NSUInteger) -> id #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "indirectRenderCommandAtIndex:\0"), commandIndex);
    }
    size :: (self: *MTLIndirectCommandBuffer) -> NSUInteger {
        invoke: (receiver: *MTLIndirectCommandBuffer, selector: SEL) -> NSUInteger #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "size\0"));
    }
}
MTLEvent :: struct {
    device :: (self: *MTLEvent) -> id {
        invoke: (receiver: *MTLEvent, selector: SEL) -> id #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "device\0"));
    }
    label :: (self: *MTLEvent) -> *NSString {
        invoke: (receiver: *MTLEvent, selector: SEL) -> *NSString #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "label\0"));
    }
    setLabel :: (self: *MTLEvent, label: *NSString) -> () {
        invoke: (receiver: *MTLEvent, selector: SEL, label: *NSString) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setLabel:\0"), label);
    }
}
MTLSharedEventListener :: struct {
    nsobject: NSObject;
    init :: (self: *MTLSharedEventListener) -> *MTLSharedEventListener {
        invoke: (receiver: *MTLSharedEventListener, selector: SEL) -> *MTLSharedEventListener #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "init\0"));
    }
    initWithDispatchQueue :: (self: *MTLSharedEventListener, dispatchQueue: dispatch_queue_t) -> *MTLSharedEventListener {
        invoke: (receiver: *MTLSharedEventListener, selector: SEL, dispatchQueue: dispatch_queue_t) -> *MTLSharedEventListener #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "initWithDispatchQueue:\0"), dispatchQueue);
    }
    dispatchQueue :: (self: *MTLSharedEventListener) -> dispatch_queue_t {
        invoke: (receiver: *MTLSharedEventListener, selector: SEL) -> dispatch_queue_t #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "dispatchQueue\0"));
    }
}
MTLSharedEvent :: struct {
    newSharedEventHandle :: (self: *MTLSharedEvent) -> *MTLSharedEventHandle {
        invoke: (receiver: *MTLSharedEvent, selector: SEL) -> *MTLSharedEventHandle #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "newSharedEventHandle\0"));
    }
    signaledValue :: (self: *MTLSharedEvent) -> uint64_t {
        invoke: (receiver: *MTLSharedEvent, selector: SEL) -> uint64_t #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "signaledValue\0"));
    }
    setSignaledValue :: (self: *MTLSharedEvent, signaledValue: uint64_t) -> () {
        invoke: (receiver: *MTLSharedEvent, selector: SEL, signaledValue: uint64_t) -> () #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(self, sel_registerName(cast(*u8) "setSignaledValue:\0"), signaledValue);
    }
}
MTLSharedEventHandle :: struct {
    nsobject: NSObject;
    _priv: *MTLSharedEventHandlePrivate;
    label :: (self: *MTLSharedEventHandle) -> *NSString {
        invoke: (receiver: *MTLSharedEventHandle, selector: SEL) -> *NSString #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(self, sel_registerName(cast(*u8) "label\0"));
    }
}
MTLSharedEventHandlePrivate :: struct {}
#scope_file
Metal :: #system_library,link_always "Metal";
_Generated_Selectors :: struct #type_info_no_size_complaint {
    layer: *void = ---;
    nextDrawable: *void = ---;
    setDevice_: *void = ---;
    framebufferOnly: *void = ---;
    setFramebufferOnly_: *void = ---;
    drawableSize: *void = ---;
    setDrawableSize_: *void = ---;
    maximumDrawableCount: *void = ---;
    setMaximumDrawableCount_: *void = ---;
    presentsWithTransaction: *void = ---;
    setPresentsWithTransaction_: *void = ---;
    colorspace: *void = ---;
    setColorspace_: *void = ---;
    wantsExtendedDynamicRangeContent: *void = ---;
    setWantsExtendedDynamicRangeContent_: *void = ---;
    displaySyncEnabled: *void = ---;
    setDisplaySyncEnabled_: *void = ---;
    allowsNextDrawableTimeout: *void = ---;
    setAllowsNextDrawableTimeout_: *void = ---;
    endEncoding: *void = ---;
    insertDebugSignpost_: *void = ---;
    pushDebugGroup_: *void = ---;
    popDebugGroup: *void = ---;
    device: *void = ---;
    label: *void = ---;
    setLabel_: *void = ---;
    setPurgeableState_: *void = ---;
    makeAliasable: *void = ---;
    isAliasable: *void = ---;
    cpuCacheMode: *void = ---;
    storageMode: *void = ---;
    heap: *void = ---;
    allocatedSize: *void = ---;
    contents: *void = ---;
    didModifyRange_: *void = ---;
    newTextureWithDescriptor_offset_bytesPerRow_: *void = ---;
    addDebugMarker_range_: *void = ---;
    removeAllDebugMarkers: *void = ---;
    length: *void = ---;
    texture2DDescriptorWithPixelFormat_width_height_mipmapped_: *void = ---;
    textureCubeDescriptorWithPixelFormat_size_mipmapped_: *void = ---;
    textureBufferDescriptorWithPixelFormat_width_resourceOptions_usage_: *void = ---;
    textureType: *void = ---;
    setTextureType_: *void = ---;
    pixelFormat: *void = ---;
    setPixelFormat_: *void = ---;
    width: *void = ---;
    setWidth_: *void = ---;
    height: *void = ---;
    setHeight_: *void = ---;
    depth: *void = ---;
    setDepth_: *void = ---;
    mipmapLevelCount: *void = ---;
    setMipmapLevelCount_: *void = ---;
    sampleCount: *void = ---;
    setSampleCount_: *void = ---;
    arrayLength: *void = ---;
    setArrayLength_: *void = ---;
    resourceOptions: *void = ---;
    setResourceOptions_: *void = ---;
    setCpuCacheMode_: *void = ---;
    setStorageMode_: *void = ---;
    usage: *void = ---;
    setUsage_: *void = ---;
    allowGPUOptimizedContents: *void = ---;
    setAllowGPUOptimizedContents_: *void = ---;
    getBytes_bytesPerRow_bytesPerImage_fromRegion_mipmapLevel_slice_: *void = ---;
    replaceRegion_mipmapLevel_slice_withBytes_bytesPerRow_bytesPerImage_: *void = ---;
    getBytes_bytesPerRow_fromRegion_mipmapLevel_: *void = ---;
    replaceRegion_mipmapLevel_withBytes_bytesPerRow_: *void = ---;
    newTextureViewWithPixelFormat_: *void = ---;
    newTextureViewWithPixelFormat_textureType_levels_slices_: *void = ---;
    newSharedTextureHandle: *void = ---;
    rootResource: *void = ---;
    parentTexture: *void = ---;
    parentRelativeLevel: *void = ---;
    parentRelativeSlice: *void = ---;
    buffer: *void = ---;
    bufferOffset: *void = ---;
    bufferBytesPerRow: *void = ---;
    iosurface: *void = ---;
    iosurfacePlane: *void = ---;
    isShareable: *void = ---;
    isFramebufferOnly: *void = ---;
    dataType: *void = ---;
    structType: *void = ---;
    arrayType: *void = ---;
    textureReferenceType: *void = ---;
    pointerType: *void = ---;
    name: *void = ---;
    offset: *void = ---;
    argumentIndex: *void = ---;
    memberByName_: *void = ---;
    members: *void = ---;
    elementStructType: *void = ---;
    elementArrayType: *void = ---;
    elementTextureReferenceType: *void = ---;
    elementPointerType: *void = ---;
    elementType: *void = ---;
    stride: *void = ---;
    argumentIndexStride: *void = ---;
    access: *void = ---;
    alignment: *void = ---;
    dataSize: *void = ---;
    elementIsArgumentBuffer: *void = ---;
    textureDataType: *void = ---;
    isDepthTexture: *void = ---;
    type: *void = ---;
    index: *void = ---;
    isActive: *void = ---;
    bufferAlignment: *void = ---;
    bufferDataSize: *void = ---;
    bufferDataType: *void = ---;
    bufferStructType: *void = ---;
    bufferPointerType: *void = ---;
    threadgroupMemoryAlignment: *void = ---;
    threadgroupMemoryDataSize: *void = ---;
    attributeIndex: *void = ---;
    attributeType: *void = ---;
    isPatchData: *void = ---;
    isPatchControlPointData: *void = ---;
    required: *void = ---;
    newArgumentEncoderWithBufferIndex_: *void = ---;
    newArgumentEncoderWithBufferIndex_reflection_: *void = ---;
    functionType: *void = ---;
    patchType: *void = ---;
    patchControlPointCount: *void = ---;
    vertexAttributes: *void = ---;
    stageInputAttributes: *void = ---;
    functionConstantsDictionary: *void = ---;
    preprocessorMacros: *void = ---;
    setPreprocessorMacros_: *void = ---;
    fastMathEnabled: *void = ---;
    setFastMathEnabled_: *void = ---;
    languageVersion: *void = ---;
    setLanguageVersion_: *void = ---;
    newFunctionWithName_: *void = ---;
    newFunctionWithName_constantValues_error_: *void = ---;
    newFunctionWithName_constantValues_completionHandler_: *void = ---;
    functionNames: *void = ---;
    argumentDescriptor: *void = ---;
    setDataType_: *void = ---;
    setIndex_: *void = ---;
    setAccess_: *void = ---;
    constantBlockAlignment: *void = ---;
    setConstantBlockAlignment_: *void = ---;
    newCommandQueue: *void = ---;
    newCommandQueueWithMaxCommandBufferCount_: *void = ---;
    heapTextureSizeAndAlignWithDescriptor_: *void = ---;
    heapBufferSizeAndAlignWithLength_options_: *void = ---;
    newHeapWithDescriptor_: *void = ---;
    newBufferWithLength_options_: *void = ---;
    newBufferWithBytes_length_options_: *void = ---;
    newBufferWithBytesNoCopy_length_options_deallocator_: *void = ---;
    newDepthStencilStateWithDescriptor_: *void = ---;
    newTextureWithDescriptor_: *void = ---;
    newTextureWithDescriptor_iosurface_plane_: *void = ---;
    newSharedTextureWithDescriptor_: *void = ---;
    newSharedTextureWithHandle_: *void = ---;
    newSamplerStateWithDescriptor_: *void = ---;
    newDefaultLibrary: *void = ---;
    newDefaultLibraryWithBundle_error_: *void = ---;
    newLibraryWithFile_error_: *void = ---;
    newLibraryWithURL_error_: *void = ---;
    newLibraryWithData_error_: *void = ---;
    newLibraryWithSource_options_error_: *void = ---;
    newLibraryWithSource_options_completionHandler_: *void = ---;
    newRenderPipelineStateWithDescriptor_error_: *void = ---;
    newRenderPipelineStateWithDescriptor_options_reflection_error_: *void = ---;
    newRenderPipelineStateWithDescriptor_completionHandler_: *void = ---;
    newRenderPipelineStateWithDescriptor_options_completionHandler_: *void = ---;
    newComputePipelineStateWithFunction_error_: *void = ---;
    newComputePipelineStateWithFunction_options_reflection_error_: *void = ---;
    newComputePipelineStateWithFunction_completionHandler_: *void = ---;
    newComputePipelineStateWithFunction_options_completionHandler_: *void = ---;
    newComputePipelineStateWithDescriptor_options_reflection_error_: *void = ---;
    newComputePipelineStateWithDescriptor_options_completionHandler_: *void = ---;
    newFence: *void = ---;
    supportsFeatureSet_: *void = ---;
    supportsTextureSampleCount_: *void = ---;
    minimumLinearTextureAlignmentForPixelFormat_: *void = ---;
    minimumTextureBufferAlignmentForPixelFormat_: *void = ---;
    getDefaultSamplePositions_count_: *void = ---;
    newArgumentEncoderWithArguments_: *void = ---;
    newIndirectCommandBufferWithDescriptor_maxCommandCount_options_: *void = ---;
    newEvent: *void = ---;
    newSharedEvent: *void = ---;
    newSharedEventWithHandle_: *void = ---;
    registryID: *void = ---;
    maxThreadsPerThreadgroup: *void = ---;
    isLowPower: *void = ---;
    isHeadless: *void = ---;
    isRemovable: *void = ---;
    recommendedMaxWorkingSetSize: *void = ---;
    isDepth24Stencil8PixelFormatSupported: *void = ---;
    readWriteTextureSupport: *void = ---;
    argumentBuffersSupport: *void = ---;
    areRasterOrderGroupsSupported: *void = ---;
    currentAllocatedSize: *void = ---;
    maxThreadgroupMemoryLength: *void = ---;
    maxArgumentBufferSamplerCount: *void = ---;
    areProgrammableSamplePositionsSupported: *void = ---;
    maxBufferLength: *void = ---;
    synchronizeResource_: *void = ---;
    synchronizeTexture_slice_level_: *void = ---;
    copyFromTexture_sourceSlice_sourceLevel_sourceOrigin_sourceSize_toTexture_destinationSlice_destinationLevel_destinationOrigin_: *void = ---;
    copyFromBuffer_sourceOffset_sourceBytesPerRow_sourceBytesPerImage_sourceSize_toTexture_destinationSlice_destinationLevel_destinationOrigin_: *void = ---;
    copyFromBuffer_sourceOffset_sourceBytesPerRow_sourceBytesPerImage_sourceSize_toTexture_destinationSlice_destinationLevel_destinationOrigin_options_: *void = ---;
    copyFromTexture_sourceSlice_sourceLevel_sourceOrigin_sourceSize_toBuffer_destinationOffset_destinationBytesPerRow_destinationBytesPerImage_: *void = ---;
    copyFromTexture_sourceSlice_sourceLevel_sourceOrigin_sourceSize_toBuffer_destinationOffset_destinationBytesPerRow_destinationBytesPerImage_options_: *void = ---;
    generateMipmapsForTexture_: *void = ---;
    fillBuffer_range_value_: *void = ---;
    copyFromBuffer_sourceOffset_toBuffer_destinationOffset_size_: *void = ---;
    updateFence_: *void = ---;
    waitForFence_: *void = ---;
    optimizeContentsForGPUAccess_: *void = ---;
    optimizeContentsForGPUAccess_slice_level_: *void = ---;
    optimizeContentsForCPUAccess_: *void = ---;
    optimizeContentsForCPUAccess_slice_level_: *void = ---;
    resetCommandsInBuffer_withRange_: *void = ---;
    copyIndirectCommandBuffer_sourceRange_destination_destinationIndex_: *void = ---;
    optimizeIndirectCommandBuffer_withRange_: *void = ---;
    enqueue: *void = ---;
    commit: *void = ---;
    addScheduledHandler_: *void = ---;
    presentDrawable_: *void = ---;
    presentDrawable_atTime_: *void = ---;
    waitUntilScheduled: *void = ---;
    addCompletedHandler_: *void = ---;
    waitUntilCompleted: *void = ---;
    blitCommandEncoder: *void = ---;
    renderCommandEncoderWithDescriptor_: *void = ---;
    computeCommandEncoder: *void = ---;
    computeCommandEncoderWithDispatchType_: *void = ---;
    encodeWaitForEvent_value_: *void = ---;
    encodeSignalEvent_value_: *void = ---;
    parallelRenderCommandEncoderWithDescriptor_: *void = ---;
    commandQueue: *void = ---;
    retainedReferences: *void = ---;
    kernelStartTime: *void = ---;
    kernelEndTime: *void = ---;
    GPUStartTime: *void = ---;
    GPUEndTime: *void = ---;
    status: *void = ---;
    error: *void = ---;
    setComputePipelineState_: *void = ---;
    setBytes_length_atIndex_: *void = ---;
    setBuffer_offset_atIndex_: *void = ---;
    setBufferOffset_atIndex_: *void = ---;
    setBuffers_offsets_withRange_: *void = ---;
    setTexture_atIndex_: *void = ---;
    setTextures_withRange_: *void = ---;
    setSamplerState_atIndex_: *void = ---;
    setSamplerStates_withRange_: *void = ---;
    setSamplerState_lodMinClamp_lodMaxClamp_atIndex_: *void = ---;
    setSamplerStates_lodMinClamps_lodMaxClamps_withRange_: *void = ---;
    setThreadgroupMemoryLength_atIndex_: *void = ---;
    setStageInRegion_: *void = ---;
    setStageInRegionWithIndirectBuffer_indirectBufferOffset_: *void = ---;
    dispatchThreadgroups_threadsPerThreadgroup_: *void = ---;
    dispatchThreadgroupsWithIndirectBuffer_indirectBufferOffset_threadsPerThreadgroup_: *void = ---;
    dispatchThreads_threadsPerThreadgroup_: *void = ---;
    useResource_usage_: *void = ---;
    useResources_count_usage_: *void = ---;
    useHeap_: *void = ---;
    useHeaps_count_: *void = ---;
    memoryBarrierWithScope_: *void = ---;
    memoryBarrierWithResources_count_: *void = ---;
    dispatchType: *void = ---;
    commandBuffer: *void = ---;
    commandBufferWithUnretainedReferences: *void = ---;
    insertDebugCaptureBoundary: *void = ---;
    stencilCompareFunction: *void = ---;
    setStencilCompareFunction_: *void = ---;
    stencilFailureOperation: *void = ---;
    setStencilFailureOperation_: *void = ---;
    depthFailureOperation: *void = ---;
    setDepthFailureOperation_: *void = ---;
    depthStencilPassOperation: *void = ---;
    setDepthStencilPassOperation_: *void = ---;
    readMask: *void = ---;
    setReadMask_: *void = ---;
    writeMask: *void = ---;
    setWriteMask_: *void = ---;
    depthCompareFunction: *void = ---;
    setDepthCompareFunction_: *void = ---;
    isDepthWriteEnabled: *void = ---;
    setDepthWriteEnabled_: *void = ---;
    frontFaceStencil: *void = ---;
    setFrontFaceStencil_: *void = ---;
    backFaceStencil: *void = ---;
    setBackFaceStencil_: *void = ---;
    present: *void = ---;
    presentAtTime_: *void = ---;
    texture: *void = ---;
    setTexture_: *void = ---;
    level: *void = ---;
    setLevel_: *void = ---;
    slice: *void = ---;
    setSlice_: *void = ---;
    depthPlane: *void = ---;
    setDepthPlane_: *void = ---;
    resolveTexture: *void = ---;
    setResolveTexture_: *void = ---;
    resolveLevel: *void = ---;
    setResolveLevel_: *void = ---;
    resolveSlice: *void = ---;
    setResolveSlice_: *void = ---;
    resolveDepthPlane: *void = ---;
    setResolveDepthPlane_: *void = ---;
    loadAction: *void = ---;
    setLoadAction_: *void = ---;
    storeAction: *void = ---;
    setStoreAction_: *void = ---;
    storeActionOptions: *void = ---;
    setStoreActionOptions_: *void = ---;
    clearColor: *void = ---;
    setClearColor_: *void = ---;
    clearDepth: *void = ---;
    setClearDepth_: *void = ---;
    depthResolveFilter: *void = ---;
    setDepthResolveFilter_: *void = ---;
    clearStencil: *void = ---;
    setClearStencil_: *void = ---;
    stencilResolveFilter: *void = ---;
    setStencilResolveFilter_: *void = ---;
    objectAtIndexedSubscript_: *void = ---;
    setObject_atIndexedSubscript_: *void = ---;
    renderPassDescriptor: *void = ---;
    setSamplePositions_count_: *void = ---;
    getSamplePositions_count_: *void = ---;
    colorAttachments: *void = ---;
    depthAttachment: *void = ---;
    setDepthAttachment_: *void = ---;
    stencilAttachment: *void = ---;
    setStencilAttachment_: *void = ---;
    visibilityResultBuffer: *void = ---;
    setVisibilityResultBuffer_: *void = ---;
    renderTargetArrayLength: *void = ---;
    setRenderTargetArrayLength_: *void = ---;
    setStride_: *void = ---;
    stepFunction: *void = ---;
    setStepFunction_: *void = ---;
    stepRate: *void = ---;
    setStepRate_: *void = ---;
    format: *void = ---;
    setFormat_: *void = ---;
    setOffset_: *void = ---;
    bufferIndex: *void = ---;
    setBufferIndex_: *void = ---;
    stageInputOutputDescriptor: *void = ---;
    reset: *void = ---;
    layouts: *void = ---;
    attributes: *void = ---;
    indexType: *void = ---;
    setIndexType_: *void = ---;
    indexBufferIndex: *void = ---;
    setIndexBufferIndex_: *void = ---;
    mutability: *void = ---;
    setMutability_: *void = ---;
    arguments: *void = ---;
    computeFunction: *void = ---;
    setComputeFunction_: *void = ---;
    threadGroupSizeIsMultipleOfThreadExecutionWidth: *void = ---;
    setThreadGroupSizeIsMultipleOfThreadExecutionWidth_: *void = ---;
    maxTotalThreadsPerThreadgroup: *void = ---;
    setMaxTotalThreadsPerThreadgroup_: *void = ---;
    stageInputDescriptor: *void = ---;
    setStageInputDescriptor_: *void = ---;
    buffers: *void = ---;
    threadExecutionWidth: *void = ---;
    staticThreadgroupMemoryLength: *void = ---;
    setRenderPipelineState_: *void = ---;
    setVertexBytes_length_atIndex_: *void = ---;
    setVertexBuffer_offset_atIndex_: *void = ---;
    setVertexBufferOffset_atIndex_: *void = ---;
    setVertexBuffers_offsets_withRange_: *void = ---;
    setVertexTexture_atIndex_: *void = ---;
    setVertexTextures_withRange_: *void = ---;
    setVertexSamplerState_atIndex_: *void = ---;
    setVertexSamplerStates_withRange_: *void = ---;
    setVertexSamplerState_lodMinClamp_lodMaxClamp_atIndex_: *void = ---;
    setVertexSamplerStates_lodMinClamps_lodMaxClamps_withRange_: *void = ---;
    setViewport_: *void = ---;
    setViewports_count_: *void = ---;
    setFrontFacingWinding_: *void = ---;
    setCullMode_: *void = ---;
    setDepthClipMode_: *void = ---;
    setDepthBias_slopeScale_clamp_: *void = ---;
    setScissorRect_: *void = ---;
    setScissorRects_count_: *void = ---;
    setTriangleFillMode_: *void = ---;
    setFragmentBytes_length_atIndex_: *void = ---;
    setFragmentBuffer_offset_atIndex_: *void = ---;
    setFragmentBufferOffset_atIndex_: *void = ---;
    setFragmentBuffers_offsets_withRange_: *void = ---;
    setFragmentTexture_atIndex_: *void = ---;
    setFragmentTextures_withRange_: *void = ---;
    setFragmentSamplerState_atIndex_: *void = ---;
    setFragmentSamplerStates_withRange_: *void = ---;
    setFragmentSamplerState_lodMinClamp_lodMaxClamp_atIndex_: *void = ---;
    setFragmentSamplerStates_lodMinClamps_lodMaxClamps_withRange_: *void = ---;
    setBlendColorRed_green_blue_alpha_: *void = ---;
    setDepthStencilState_: *void = ---;
    setStencilReferenceValue_: *void = ---;
    setStencilFrontReferenceValue_backReferenceValue_: *void = ---;
    setVisibilityResultMode_offset_: *void = ---;
    setColorStoreAction_atIndex_: *void = ---;
    setDepthStoreAction_: *void = ---;
    setStencilStoreAction_: *void = ---;
    setColorStoreActionOptions_atIndex_: *void = ---;
    setDepthStoreActionOptions_: *void = ---;
    setStencilStoreActionOptions_: *void = ---;
    drawPrimitives_vertexStart_vertexCount_instanceCount_: *void = ---;
    drawPrimitives_vertexStart_vertexCount_: *void = ---;
    drawIndexedPrimitives_indexCount_indexType_indexBuffer_indexBufferOffset_instanceCount_: *void = ---;
    drawIndexedPrimitives_indexCount_indexType_indexBuffer_indexBufferOffset_: *void = ---;
    drawPrimitives_vertexStart_vertexCount_instanceCount_baseInstance_: *void = ---;
    drawIndexedPrimitives_indexCount_indexType_indexBuffer_indexBufferOffset_instanceCount_baseVertex_baseInstance_: *void = ---;
    drawPrimitives_indirectBuffer_indirectBufferOffset_: *void = ---;
    drawIndexedPrimitives_indexType_indexBuffer_indexBufferOffset_indirectBuffer_indirectBufferOffset_: *void = ---;
    textureBarrier: *void = ---;
    updateFence_afterStages_: *void = ---;
    waitForFence_beforeStages_: *void = ---;
    setTessellationFactorBuffer_offset_instanceStride_: *void = ---;
    setTessellationFactorScale_: *void = ---;
    drawPatches_patchStart_patchCount_patchIndexBuffer_patchIndexBufferOffset_instanceCount_baseInstance_: *void = ---;
    drawPatches_patchIndexBuffer_patchIndexBufferOffset_indirectBuffer_indirectBufferOffset_: *void = ---;
    drawIndexedPatches_patchStart_patchCount_patchIndexBuffer_patchIndexBufferOffset_controlPointIndexBuffer_controlPointIndexBufferOffset_instanceCount_baseInstance_: *void = ---;
    drawIndexedPatches_patchIndexBuffer_patchIndexBufferOffset_controlPointIndexBuffer_controlPointIndexBufferOffset_indirectBuffer_indirectBufferOffset_: *void = ---;
    executeCommandsInBuffer_withRange_: *void = ---;
    executeCommandsInBuffer_indirectBuffer_indirectBufferOffset_: *void = ---;
    memoryBarrierWithScope_afterStages_beforeStages_: *void = ---;
    memoryBarrierWithResources_count_afterStages_beforeStages_: *void = ---;
    setConstantValue_type_atIndex_: *void = ---;
    setConstantValues_type_withRange_: *void = ---;
    setConstantValue_type_withName_: *void = ---;
    isBlendingEnabled: *void = ---;
    setBlendingEnabled_: *void = ---;
    sourceRGBBlendFactor: *void = ---;
    setSourceRGBBlendFactor_: *void = ---;
    destinationRGBBlendFactor: *void = ---;
    setDestinationRGBBlendFactor_: *void = ---;
    rgbBlendOperation: *void = ---;
    setRgbBlendOperation_: *void = ---;
    sourceAlphaBlendFactor: *void = ---;
    setSourceAlphaBlendFactor_: *void = ---;
    destinationAlphaBlendFactor: *void = ---;
    setDestinationAlphaBlendFactor_: *void = ---;
    alphaBlendOperation: *void = ---;
    setAlphaBlendOperation_: *void = ---;
    vertexArguments: *void = ---;
    fragmentArguments: *void = ---;
    vertexFunction: *void = ---;
    setVertexFunction_: *void = ---;
    fragmentFunction: *void = ---;
    setFragmentFunction_: *void = ---;
    vertexDescriptor: *void = ---;
    setVertexDescriptor_: *void = ---;
    rasterSampleCount: *void = ---;
    setRasterSampleCount_: *void = ---;
    isAlphaToCoverageEnabled: *void = ---;
    setAlphaToCoverageEnabled_: *void = ---;
    isAlphaToOneEnabled: *void = ---;
    setAlphaToOneEnabled_: *void = ---;
    isRasterizationEnabled: *void = ---;
    setRasterizationEnabled_: *void = ---;
    depthAttachmentPixelFormat: *void = ---;
    setDepthAttachmentPixelFormat_: *void = ---;
    stencilAttachmentPixelFormat: *void = ---;
    setStencilAttachmentPixelFormat_: *void = ---;
    inputPrimitiveTopology: *void = ---;
    setInputPrimitiveTopology_: *void = ---;
    tessellationPartitionMode: *void = ---;
    setTessellationPartitionMode_: *void = ---;
    maxTessellationFactor: *void = ---;
    setMaxTessellationFactor_: *void = ---;
    isTessellationFactorScaleEnabled: *void = ---;
    setTessellationFactorScaleEnabled_: *void = ---;
    tessellationFactorFormat: *void = ---;
    setTessellationFactorFormat_: *void = ---;
    tessellationControlPointIndexType: *void = ---;
    setTessellationControlPointIndexType_: *void = ---;
    tessellationFactorStepFunction: *void = ---;
    setTessellationFactorStepFunction_: *void = ---;
    tessellationOutputWindingOrder: *void = ---;
    setTessellationOutputWindingOrder_: *void = ---;
    vertexBuffers: *void = ---;
    fragmentBuffers: *void = ---;
    supportIndirectCommandBuffers: *void = ---;
    setSupportIndirectCommandBuffers_: *void = ---;
    renderCommandEncoder: *void = ---;
    minFilter: *void = ---;
    setMinFilter_: *void = ---;
    magFilter: *void = ---;
    setMagFilter_: *void = ---;
    mipFilter: *void = ---;
    setMipFilter_: *void = ---;
    maxAnisotropy: *void = ---;
    setMaxAnisotropy_: *void = ---;
    sAddressMode: *void = ---;
    setSAddressMode_: *void = ---;
    tAddressMode: *void = ---;
    setTAddressMode_: *void = ---;
    rAddressMode: *void = ---;
    setRAddressMode_: *void = ---;
    borderColor: *void = ---;
    setBorderColor_: *void = ---;
    normalizedCoordinates: *void = ---;
    setNormalizedCoordinates_: *void = ---;
    lodMinClamp: *void = ---;
    setLodMinClamp_: *void = ---;
    lodMaxClamp: *void = ---;
    setLodMaxClamp_: *void = ---;
    lodAverage: *void = ---;
    setLodAverage_: *void = ---;
    compareFunction: *void = ---;
    setCompareFunction_: *void = ---;
    supportArgumentBuffers: *void = ---;
    setSupportArgumentBuffers_: *void = ---;
    size: *void = ---;
    setSize_: *void = ---;
    maxAvailableSizeWithAlignment_: *void = ---;
    usedSize: *void = ---;
    setArgumentBuffer_offset_: *void = ---;
    setArgumentBuffer_startOffset_arrayElement_: *void = ---;
    constantDataAtIndex_: *void = ---;
    setRenderPipelineState_atIndex_: *void = ---;
    setRenderPipelineStates_withRange_: *void = ---;
    setIndirectCommandBuffer_atIndex_: *void = ---;
    setIndirectCommandBuffers_withRange_: *void = ---;
    newArgumentEncoderForBufferAtIndex_: *void = ---;
    encodedLength: *void = ---;
    sharedCaptureManager: *void = ---;
    init: *void = ---;
    newCaptureScopeWithDevice_: *void = ---;
    newCaptureScopeWithCommandQueue_: *void = ---;
    startCaptureWithDevice_: *void = ---;
    startCaptureWithCommandQueue_: *void = ---;
    startCaptureWithScope_: *void = ---;
    stopCapture: *void = ---;
    defaultCaptureScope: *void = ---;
    setDefaultCaptureScope_: *void = ---;
    isCapturing: *void = ---;
    beginScope: *void = ---;
    endScope: *void = ---;
    drawPatches_patchStart_patchCount_patchIndexBuffer_patchIndexBufferOffset_instanceCount_baseInstance_tessellationFactorBuffer_tessellationFactorBufferOffset_tessellationFactorBufferInstanceStride_: *void = ---;
    drawIndexedPatches_patchStart_patchCount_patchIndexBuffer_patchIndexBufferOffset_controlPointIndexBuffer_controlPointIndexBufferOffset_instanceCount_baseInstance_tessellationFactorBuffer_tessellationFactorBufferOffset_tessellationFactorBufferInstanceStride_: *void = ---;
    commandTypes: *void = ---;
    setCommandTypes_: *void = ---;
    inheritPipelineState: *void = ---;
    setInheritPipelineState_: *void = ---;
    inheritBuffers: *void = ---;
    setInheritBuffers_: *void = ---;
    maxVertexBufferBindCount: *void = ---;
    setMaxVertexBufferBindCount_: *void = ---;
    maxFragmentBufferBindCount: *void = ---;
    setMaxFragmentBufferBindCount_: *void = ---;
    resetWithRange_: *void = ---;
    indirectRenderCommandAtIndex_: *void = ---;
    initWithDispatchQueue_: *void = ---;
    dispatchQueue: *void = ---;
    notifyListener_atValue_block_: *void = ---;
    newSharedEventHandle: *void = ---;
    signaledValue: *void = ---;
    setSignaledValue_: *void = ---;
}
__selectors: _Generated_Selectors;
