// AppKit classes, selectors and constants.
init_app_kit :: () {
    _sel.IBeamCursor = cast(Selector) sel_registerName(cast(*u8) "IBeamCursor\0");
    _sel.URL = cast(Selector) sel_registerName(cast(*u8) "URL\0");
    _sel._windowResizeNorthEastSouthWestCursor = cast(Selector) sel_registerName(cast(*u8) "_windowResizeNorthEastSouthWestCursor\0");
    _sel.accessoryView = cast(Selector) sel_registerName(cast(*u8) "accessoryView\0");
    _sel.activateIgnoringOtherApps_ = cast(Selector) sel_registerName(cast(*u8) "activateIgnoringOtherApps:\0");
    _sel.addButtonWithTitle_ = cast(Selector) sel_registerName(cast(*u8) "addButtonWithTitle:\0");
    _sel.addItemWithTitle_action_keyEquivalent_ = cast(Selector) sel_registerName(cast(*u8) "addItemWithTitle:action:keyEquivalent:\0");
    _sel.addItem_ = cast(Selector) sel_registerName(cast(*u8) "addItem:\0");
    _sel.addRepresentation_ = cast(Selector) sel_registerName(cast(*u8) "addRepresentation:\0");
    _sel.addSubview_ = cast(Selector) sel_registerName(cast(*u8) "addSubview:\0");
    _sel.alertStyle = cast(Selector) sel_registerName(cast(*u8) "alertStyle\0");
    _sel.allowedFileTypes = cast(Selector) sel_registerName(cast(*u8) "allowedFileTypes\0");
    _sel.allowsOtherFileTypes = cast(Selector) sel_registerName(cast(*u8) "allowsOtherFileTypes\0");
    _sel.arrowCursor = cast(Selector) sel_registerName(cast(*u8) "arrowCursor\0");
    _sel.associatedEventsMask = cast(Selector) sel_registerName(cast(*u8) "associatedEventsMask\0");
    _sel.backingScaleFactor = cast(Selector) sel_registerName(cast(*u8) "backingScaleFactor\0");
    _sel.bitmapData = cast(Selector) sel_registerName(cast(*u8) "bitmapData\0");
    _sel.blueColor = cast(Selector) sel_registerName(cast(*u8) "blueColor\0");
    _sel.bounds = cast(Selector) sel_registerName(cast(*u8) "bounds\0");
    _sel.buttonNumber = cast(Selector) sel_registerName(cast(*u8) "buttonNumber\0");
    _sel.buttonWithTitle_target_action_ = cast(Selector) sel_registerName(cast(*u8) "buttonWithTitle:target:action:\0");
    _sel.canSelectHiddenExtension = cast(Selector) sel_registerName(cast(*u8) "canSelectHiddenExtension\0");
    _sel.center = cast(Selector) sel_registerName(cast(*u8) "center\0");
    _sel.characters = cast(Selector) sel_registerName(cast(*u8) "characters\0");
    _sel.charactersIgnoringModifiers = cast(Selector) sel_registerName(cast(*u8) "charactersIgnoringModifiers\0");
    _sel.clearContents = cast(Selector) sel_registerName(cast(*u8) "clearContents\0");
    _sel.clickCount = cast(Selector) sel_registerName(cast(*u8) "clickCount\0");
    _sel.close = cast(Selector) sel_registerName(cast(*u8) "close\0");
    _sel.closedHandCursor = cast(Selector) sel_registerName(cast(*u8) "closedHandCursor\0");
    _sel.contentView = cast(Selector) sel_registerName(cast(*u8) "contentView\0");
    _sel.convertPointFromBacking_ = cast(Selector) sel_registerName(cast(*u8) "convertPointFromBacking:\0");
    _sel.convertPointFromScreen_ = cast(Selector) sel_registerName(cast(*u8) "convertPointFromScreen:\0");
    _sel.convertPointToBacking_ = cast(Selector) sel_registerName(cast(*u8) "convertPointToBacking:\0");
    _sel.convertPoint_fromView_ = cast(Selector) sel_registerName(cast(*u8) "convertPoint:fromView:\0");
    _sel.convertRectFromBacking_ = cast(Selector) sel_registerName(cast(*u8) "convertRectFromBacking:\0");
    _sel.convertRectFromScreen_ = cast(Selector) sel_registerName(cast(*u8) "convertRectFromScreen:\0");
    _sel.convertRectToBacking_ = cast(Selector) sel_registerName(cast(*u8) "convertRectToBacking:\0");
    _sel.currentContext = cast(Selector) sel_registerName(cast(*u8) "currentContext\0");
    _sel.deltaX = cast(Selector) sel_registerName(cast(*u8) "deltaX\0");
    _sel.deltaY = cast(Selector) sel_registerName(cast(*u8) "deltaY\0");
    _sel.deltaZ = cast(Selector) sel_registerName(cast(*u8) "deltaZ\0");
    _sel.directoryURL = cast(Selector) sel_registerName(cast(*u8) "directoryURL\0");
    _sel.display = cast(Selector) sel_registerName(cast(*u8) "display\0");
    _sel.doNothing_ = cast(Selector) sel_registerName(cast(*u8) "doNothing:\0");
    _sel.draggingPasteboard = cast(Selector) sel_registerName(cast(*u8) "draggingPasteboard\0");
    _sel.draggingSourceOperationMask = cast(Selector) sel_registerName(cast(*u8) "draggingSourceOperationMask\0");
    _sel.drawRect_ = cast(Selector) sel_registerName(cast(*u8) "drawRect:\0");
    _sel.enterFullScreenMode_withOptions_ = cast(Selector) sel_registerName(cast(*u8) "enterFullScreenMode:withOptions:\0");
    _sel.exitFullScreenModeWithOptions_ = cast(Selector) sel_registerName(cast(*u8) "exitFullScreenModeWithOptions:\0");
    _sel.finishLaunching = cast(Selector) sel_registerName(cast(*u8) "finishLaunching\0");
    _sel.flushBuffer = cast(Selector) sel_registerName(cast(*u8) "flushBuffer\0");
    _sel.frame = cast(Selector) sel_registerName(cast(*u8) "frame\0");
    _sel.generalPasteboard = cast(Selector) sel_registerName(cast(*u8) "generalPasteboard\0");
    _sel.getValues_forAttribute_forVirtualScreen_ = cast(Selector) sel_registerName(cast(*u8) "getValues:forAttribute:forVirtualScreen:\0");
    _sel.hide = cast(Selector) sel_registerName(cast(*u8) "hide\0");
    _sel.informativeText = cast(Selector) sel_registerName(cast(*u8) "informativeText\0");
    _sel.initWithAttributes_ = cast(Selector) sel_registerName(cast(*u8) "initWithAttributes:\0");
    _sel.initWithBitmapDataPlanes_pixelsWide_pixelsHigh_bitsPerSample_samplesPerPixel_hasAlpha_isPlanar_colorSpaceName_bytesPerRow_bitsPerPixel_ = cast(Selector) sel_registerName(cast(*u8) "initWithBitmapDataPlanes:pixelsWide:pixelsHigh:bitsPerSample:samplesPerPixel:hasAlpha:isPlanar:colorSpaceName:bytesPerRow:bitsPerPixel:\0");
    _sel.initWithContentRect_styleMask_backing_defer_ = cast(Selector) sel_registerName(cast(*u8) "initWithContentRect:styleMask:backing:defer:\0");
    _sel.initWithContentRect_styleMask_backing_defer_screen_ = cast(Selector) sel_registerName(cast(*u8) "initWithContentRect:styleMask:backing:defer:screen:\0");
    _sel.initWithFormat_shareContext_ = cast(Selector) sel_registerName(cast(*u8) "initWithFormat:shareContext:\0");
    _sel.initWithSize_ = cast(Selector) sel_registerName(cast(*u8) "initWithSize:\0");
    _sel.initWithTitle_action_keyEquivalent_ = cast(Selector) sel_registerName(cast(*u8) "initWithTitle:action:keyEquivalent:\0");
    _sel.isARepeat = cast(Selector) sel_registerName(cast(*u8) "isARepeat\0");
    _sel.isInFullScreenMode = cast(Selector) sel_registerName(cast(*u8) "isInFullScreenMode\0");
    _sel.keyCode = cast(Selector) sel_registerName(cast(*u8) "keyCode\0");
    _sel.keyEquivalentModifierMask = cast(Selector) sel_registerName(cast(*u8) "keyEquivalentModifierMask\0");
    _sel.keyRepeatDelay = cast(Selector) sel_registerName(cast(*u8) "keyRepeatDelay\0");
    _sel.keyRepeatInterval = cast(Selector) sel_registerName(cast(*u8) "keyRepeatInterval\0");
    _sel.keyWindow = cast(Selector) sel_registerName(cast(*u8) "keyWindow\0");
    _sel.layer = cast(Selector) sel_registerName(cast(*u8) "layer\0");
    _sel.layout = cast(Selector) sel_registerName(cast(*u8) "layout\0");
    _sel.level = cast(Selector) sel_registerName(cast(*u8) "level\0");
    _sel.mainScreen = cast(Selector) sel_registerName(cast(*u8) "mainScreen\0");
    _sel.mainWindow = cast(Selector) sel_registerName(cast(*u8) "mainWindow\0");
    _sel.makeCurrentContext = cast(Selector) sel_registerName(cast(*u8) "makeCurrentContext\0");
    _sel.makeFirstResponder_ = cast(Selector) sel_registerName(cast(*u8) "makeFirstResponder:\0");
    _sel.makeKeyAndOrderFront_ = cast(Selector) sel_registerName(cast(*u8) "makeKeyAndOrderFront:\0");
    _sel.messageText = cast(Selector) sel_registerName(cast(*u8) "messageText\0");
    _sel.modifierFlags = cast(Selector) sel_registerName(cast(*u8) "modifierFlags\0");
    _sel.mouseLocation = cast(Selector) sel_registerName(cast(*u8) "mouseLocation\0");
    _sel.mouseLocationOutsideOfEventStream = cast(Selector) sel_registerName(cast(*u8) "mouseLocationOutsideOfEventStream\0");
    _sel.mouse_inRect_ = cast(Selector) sel_registerName(cast(*u8) "mouse:inRect:\0");
    _sel.nameFieldStringValue = cast(Selector) sel_registerName(cast(*u8) "nameFieldStringValue\0");
    _sel.nextEventMatchingMask_untilDate_inMode_dequeue_ = cast(Selector) sel_registerName(cast(*u8) "nextEventMatchingMask:untilDate:inMode:dequeue:\0");
    _sel.openHandCursor = cast(Selector) sel_registerName(cast(*u8) "openHandCursor\0");
    _sel.openPanel = cast(Selector) sel_registerName(cast(*u8) "openPanel\0");
    _sel.operationNotAllowedCursor = cast(Selector) sel_registerName(cast(*u8) "operationNotAllowedCursor\0");
    _sel.orderFront_ = cast(Selector) sel_registerName(cast(*u8) "orderFront:\0");
    _sel.orderOut_ = cast(Selector) sel_registerName(cast(*u8) "orderOut:\0");
    _sel.pasteboardItems = cast(Selector) sel_registerName(cast(*u8) "pasteboardItems\0");
    _sel.performClose_ = cast(Selector) sel_registerName(cast(*u8) "performClose:\0");
    _sel.pointingHandCursor = cast(Selector) sel_registerName(cast(*u8) "pointingHandCursor\0");
    _sel.presentationOptions = cast(Selector) sel_registerName(cast(*u8) "presentationOptions\0");
    _sel.pressedMouseButtons = cast(Selector) sel_registerName(cast(*u8) "pressedMouseButtons\0");
    _sel.readObjectsForClasses_options_ = cast(Selector) sel_registerName(cast(*u8) "readObjectsForClasses:options:\0");
    _sel.registerForDraggedTypes_ = cast(Selector) sel_registerName(cast(*u8) "registerForDraggedTypes:\0");
    _sel.requestUserAttention_ = cast(Selector) sel_registerName(cast(*u8) "requestUserAttention:\0");
    _sel.resizeLeftRightCursor = cast(Selector) sel_registerName(cast(*u8) "resizeLeftRightCursor\0");
    _sel.resizeUpDownCursor = cast(Selector) sel_registerName(cast(*u8) "resizeUpDownCursor\0");
    _sel.run = cast(Selector) sel_registerName(cast(*u8) "run\0");
    _sel.runModal = cast(Selector) sel_registerName(cast(*u8) "runModal\0");
    _sel.savePanel = cast(Selector) sel_registerName(cast(*u8) "savePanel\0");
    _sel.sendEvent_ = cast(Selector) sel_registerName(cast(*u8) "sendEvent:\0");
    _sel.set = cast(Selector) sel_registerName(cast(*u8) "set\0");
    _sel.setAccessoryView_ = cast(Selector) sel_registerName(cast(*u8) "setAccessoryView:\0");
    _sel.setActivationPolicy_ = cast(Selector) sel_registerName(cast(*u8) "setActivationPolicy:\0");
    _sel.setAlertStyle_ = cast(Selector) sel_registerName(cast(*u8) "setAlertStyle:\0");
    _sel.setAllowedFileTypes_ = cast(Selector) sel_registerName(cast(*u8) "setAllowedFileTypes:\0");
    _sel.setAllowsOtherFileTypes_ = cast(Selector) sel_registerName(cast(*u8) "setAllowsOtherFileTypes:\0");
    _sel.setAppleMenu_ = cast(Selector) sel_registerName(cast(*u8) "setAppleMenu:\0");
    _sel.setBackgroundColor_ = cast(Selector) sel_registerName(cast(*u8) "setBackgroundColor:\0");
    _sel.setCanSelectHiddenExtension_ = cast(Selector) sel_registerName(cast(*u8) "setCanSelectHiddenExtension:\0");
    _sel.setCollectionBehavior_ = cast(Selector) sel_registerName(cast(*u8) "setCollectionBehavior:\0");
    _sel.setContentSize_ = cast(Selector) sel_registerName(cast(*u8) "setContentSize:\0");
    _sel.setContentView_ = cast(Selector) sel_registerName(cast(*u8) "setContentView:\0");
    _sel.setDelegate_ = cast(Selector) sel_registerName(cast(*u8) "setDelegate:\0");
    _sel.setDirectoryURL_ = cast(Selector) sel_registerName(cast(*u8) "setDirectoryURL:\0");
    _sel.setFrameOrigin_ = cast(Selector) sel_registerName(cast(*u8) "setFrameOrigin:\0");
    _sel.setFrame_ = cast(Selector) sel_registerName(cast(*u8) "setFrame:\0");
    _sel.setFrame_display_ = cast(Selector) sel_registerName(cast(*u8) "setFrame:display:\0");
    _sel.setInformativeText_ = cast(Selector) sel_registerName(cast(*u8) "setInformativeText:\0");
    _sel.setKeyEquivalentModifierMask_ = cast(Selector) sel_registerName(cast(*u8) "setKeyEquivalentModifierMask:\0");
    _sel.setLevel_ = cast(Selector) sel_registerName(cast(*u8) "setLevel:\0");
    _sel.setMainMenu_ = cast(Selector) sel_registerName(cast(*u8) "setMainMenu:\0");
    _sel.setMessageText_ = cast(Selector) sel_registerName(cast(*u8) "setMessageText:\0");
    _sel.setNameFieldStringValue_ = cast(Selector) sel_registerName(cast(*u8) "setNameFieldStringValue:\0");
    _sel.setPresentationOptions_ = cast(Selector) sel_registerName(cast(*u8) "setPresentationOptions:\0");
    _sel.setReleasedWhenClosed_ = cast(Selector) sel_registerName(cast(*u8) "setReleasedWhenClosed:\0");
    _sel.setShowsHelp_ = cast(Selector) sel_registerName(cast(*u8) "setShowsHelp:\0");
    _sel.setShowsTagField_ = cast(Selector) sel_registerName(cast(*u8) "setShowsTagField:\0");
    _sel.setSize_ = cast(Selector) sel_registerName(cast(*u8) "setSize:\0");
    _sel.setString_forType_ = cast(Selector) sel_registerName(cast(*u8) "setString:forType:\0");
    _sel.setStyleMask_ = cast(Selector) sel_registerName(cast(*u8) "setStyleMask:\0");
    _sel.setSubmenu_ = cast(Selector) sel_registerName(cast(*u8) "setSubmenu:\0");
    _sel.setTitle_ = cast(Selector) sel_registerName(cast(*u8) "setTitle:\0");
    _sel.setValues_forParameter_ = cast(Selector) sel_registerName(cast(*u8) "setValues:forParameter:\0");
    _sel.setView_ = cast(Selector) sel_registerName(cast(*u8) "setView:\0");
    _sel.setWantsBestResolutionOpenGLSurface_ = cast(Selector) sel_registerName(cast(*u8) "setWantsBestResolutionOpenGLSurface:\0");
    _sel.setWantsLayer_ = cast(Selector) sel_registerName(cast(*u8) "setWantsLayer:\0");
    _sel.sharedApplication = cast(Selector) sel_registerName(cast(*u8) "sharedApplication\0");
    _sel.showsHelp = cast(Selector) sel_registerName(cast(*u8) "showsHelp\0");
    _sel.showsTagField = cast(Selector) sel_registerName(cast(*u8) "showsTagField\0");
    _sel.size = cast(Selector) sel_registerName(cast(*u8) "size\0");
    _sel.stop_ = cast(Selector) sel_registerName(cast(*u8) "stop:\0");
    _sel.stringForType_ = cast(Selector) sel_registerName(cast(*u8) "stringForType:\0");
    _sel.styleMask = cast(Selector) sel_registerName(cast(*u8) "styleMask\0");
    _sel.terminate_ = cast(Selector) sel_registerName(cast(*u8) "terminate:\0");
    _sel.toggleFullScreen_ = cast(Selector) sel_registerName(cast(*u8) "toggleFullScreen:\0");
    _sel.type = cast(Selector) sel_registerName(cast(*u8) "type\0");
    _sel.types = cast(Selector) sel_registerName(cast(*u8) "types\0");
    _sel.unhide = cast(Selector) sel_registerName(cast(*u8) "unhide\0");
    _sel.update = cast(Selector) sel_registerName(cast(*u8) "update\0");
    _sel.updateWindows = cast(Selector) sel_registerName(cast(*u8) "updateWindows\0");
    _sel.view = cast(Selector) sel_registerName(cast(*u8) "view\0");
    _sel.writeObjects_ = cast(Selector) sel_registerName(cast(*u8) "writeObjects:\0");
}
NSApp: *NSApplication #elsewhere;
NSApplicationMain :: (argc: s32, argv: **u8) -> s32 #foreign AppKit;
NSDefaultRunLoopMode: NSRunLoopMode #elsewhere Cocoa;
NSDeviceRGBColorSpace: NSColorSpaceName #elsewhere AppKit;
NSApplicationDelegate :: struct {
    using #as nsobject: NSObject;
} @ObjCProtocol
NSApplication :: struct {
    using #as super: NSObject;
    sharedApplication :: () -> *NSApplication #no_context {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *NSApplication #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) objc_getClass(cast(*u8) "NSApplication\0"), sel_registerName(cast(*u8) "sharedApplication\0"));
    }
    run :: (self: *NSApplication) #no_context {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> void #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(cast(*void) self, sel_registerName(cast(*u8) "run\0"));
    }
    stop :: (self: *NSApplication, sender: id) #no_context {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, sender: id) -> void #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(cast(*void) self, sel_registerName(cast(*u8) "stop:\0"), sender);
    }
    mainWindow :: (self: *NSApplication) -> *NSWindow #no_context {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *NSWindow #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "mainWindow\0"));
    }
    keyWindow :: (self: *NSApplication) -> *NSWindow #no_context {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *NSWindow #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "keyWindow\0"));
    }
    sendEvent :: (self: *NSApplication, event: *NSEvent) #no_context {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, event: *NSEvent) -> void #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(cast(*void) self, sel_registerName(cast(*u8) "sendEvent:\0"), event);
    }
    updateWindows :: (self: *NSApplication) #no_context {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> void #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(cast(*void) self, sel_registerName(cast(*u8) "updateWindows\0"));
    }
    activateIgnoringOtherApps :: (self: *NSApplication, value: BOOL) #no_context {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, value: BOOL) -> void #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(cast(*void) self, sel_registerName(cast(*u8) "activateIgnoringOtherApps:\0"), value);
    }
    setActivationPolicy :: (self: *NSApplication, policy: NSApplicationActivationPolicy) -> BOOL #no_context {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, policy: NSApplicationActivationPolicy) -> BOOL #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "setActivationPolicy:\0"), policy);
    }
    setDelegate :: (self: *NSApplication, del: *NSApplicationDelegate) -> id #no_context {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, del: *NSApplicationDelegate) -> void #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(cast(*void) self, sel_registerName(cast(*u8) "setDelegate:\0"), del);
        return null;
    }
    finishLaunching :: (self: *NSApplication) -> id #no_context {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> void #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(cast(*void) self, sel_registerName(cast(*u8) "finishLaunching\0"));
        return null;
    }
    setMainMenu :: (self: *NSApplication, menu: *NSMenu) -> id #no_context {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, menu: *NSMenu) -> void #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(cast(*void) self, sel_registerName(cast(*u8) "setMainMenu:\0"), menu);
        return null;
    }
    nextEventMatchingMask :: (self: *NSApplication, mask: NSEventMask, untilDate: *NSDate, inMode: NSRunLoopMode, dequeue: BOOL) -> *NSEvent #no_context {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, mask: NSEventMask, untilDate: *NSDate, inMode: NSRunLoopMode, dequeue: BOOL) -> *NSEvent #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "nextEventMatchingMask:untilDate:inMode:dequeue:\0"), mask, untilDate, inMode, dequeue);
    }
    presentationOptions :: (self: *NSApplication) -> NSApplicationPresentationOptions #no_context {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> NSApplicationPresentationOptions #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "presentationOptions\0"));
    }
    setPresentationOptions :: (self: *NSApplication, options: NSApplicationPresentationOptions) #no_context {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, options: NSApplicationPresentationOptions) -> void #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(cast(*void) self, sel_registerName(cast(*u8) "setPresentationOptions:\0"), options);
    }
    setAppleMenu :: (self: *NSApplication, menu: *NSMenu) #no_context {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, menu: *NSMenu) -> void #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(cast(*void) self, sel_registerName(cast(*u8) "setAppleMenu:\0"), menu);
    }
    terminate :: (self: *NSApplication, sender: id) #no_context {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, sender: id) -> void #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(cast(*void) self, sel_registerName(cast(*u8) "terminate:\0"), sender);
    }
    requestUserAttention :: (self: *NSApplication, requestType: NSRequestUserAttentionType) -> NSInteger #no_context {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, requestType: NSRequestUserAttentionType) -> NSInteger #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "requestUserAttention:\0"), requestType);
    }
}
NSEvent :: struct {
    using #as super: NSObject;
    mouseLocation :: () -> NSPoint {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> NSPoint #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) objc_getClass(cast(*u8) "NSEvent\0"), sel_registerName(cast(*u8) "mouseLocation\0"));
    }
    type :: (self: *NSEvent) -> NSEventType {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> NSEventType #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "type\0"));
    }
    characters :: (self: *NSEvent) -> *NSString {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *NSString #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "characters\0"));
    }
    charactersIgnoringModifiers :: (self: *NSEvent) -> *NSString {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *NSString #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "charactersIgnoringModifiers\0"));
    }
    keyCode :: (self: *NSEvent) -> u16 {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> u16 #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "keyCode\0"));
    }
    modifierFlags :: (self: *NSEvent) -> NSEventModifierFlags {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> NSEventModifierFlags #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "modifierFlags\0"));
    }
    isARepeat :: (self: *NSEvent) -> BOOL {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> BOOL #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "isARepeat\0"));
    }
    // A class property: `+[NSEvent keyRepeatDelay]`.
    keyRepeatDelay :: () -> NSTimeInterval {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> NSTimeInterval #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) objc_getClass(cast(*u8) "NSEvent\0"), sel_registerName(cast(*u8) "keyRepeatDelay\0"));
    }
    // A class property: `+[NSEvent keyRepeatInterval]`.
    keyRepeatInterval :: () -> NSTimeInterval {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> NSTimeInterval #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) objc_getClass(cast(*u8) "NSEvent\0"), sel_registerName(cast(*u8) "keyRepeatInterval\0"));
    }
    // A class property: `+[NSEvent pressedMouseButtons]`.
    pressedMouseButtons :: () -> NSUInteger {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> NSUInteger #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) objc_getClass(cast(*u8) "NSEvent\0"), sel_registerName(cast(*u8) "pressedMouseButtons\0"));
    }
    buttonNumber :: (self: *NSEvent) -> NSInteger {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> NSInteger #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "buttonNumber\0"));
    }
    clickCount :: (self: *NSEvent) -> NSInteger {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> NSInteger #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "clickCount\0"));
    }
    associatedEventsMask :: (self: *NSEvent) -> NSEventMask {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> NSEventMask #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "associatedEventsMask\0"));
    }
    deltaX :: (self: *NSEvent) -> CGFloat {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> CGFloat #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "deltaX\0"));
    }
    deltaY :: (self: *NSEvent) -> CGFloat {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> CGFloat #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "deltaY\0"));
    }
    deltaZ :: (self: *NSEvent) -> CGFloat {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> CGFloat #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "deltaZ\0"));
    }
}
using NSEventModifierFlags :: enum_flags u64 {
    NSEventModifierFlagCapsLock :: 1 << 16;
    NSEventModifierFlagShift :: 1 << 17;
    NSEventModifierFlagControl :: 1 << 18;
    NSEventModifierFlagOption :: 1 << 19;
    NSEventModifierFlagCommand :: 1 << 20;
    NSEventModifierFlagNumericPad :: 1 << 21;
    NSEventModifierFlagHelp :: 1 << 22;
    NSEventModifierFlagFunction :: 1 << 23;
    NSEventModifierFlagDeviceIndependentFlagsMask :: 0xffff0000;
}
using NSApplicationPresentationOptions :: enum u64 {
    NSApplicationPresentationDefault :: 0;
    NSApplicationPresentationAutoHideDock :: (1 << 0);
    NSApplicationPresentationHideDock :: (1 << 1);
    NSApplicationPresentationAutoHideMenuBar :: (1 << 2);
    NSApplicationPresentationHideMenuBar :: (1 << 3);
    NSApplicationPresentationDisableAppleMenu :: (1 << 4);
    NSApplicationPresentationDisableProcessSwitching :: (1 << 5);
    NSApplicationPresentationDisableForceQuit :: (1 << 6);
    NSApplicationPresentationDisableSessionTermination :: (1 << 7);
    NSApplicationPresentationDisableHideApplication :: (1 << 8);
    NSApplicationPresentationDisableMenuBarTransparency :: (1 << 9);
    NSApplicationPresentationFullScreen :: (1 << 10);
    NSApplicationPresentationAutoHideToolbar :: (1 << 11);
    NSApplicationPresentationDisableCursorLocationAssistance :: (1 << 12);
}
using NSRequestUserAttentionType :: enum u64 {
    NSCriticalRequest :: 0;
    NSInformationalRequest :: 10;
}
using NSApplicationTerminateReply :: enum u64 {
    NSTerminateCancel :: 0;
    NSTerminateNow :: 1;
    NSTerminateLater :: 2;
}
using NSEventType :: enum u64 {
    NSEventTypeLeftMouseDown :: 1;
    NSEventTypeLeftMouseUp :: 2;
    NSEventTypeRightMouseDown :: 3;
    NSEventTypeRightMouseUp :: 4;
    NSEventTypeMouseMoved :: 5;
    NSEventTypeLeftMouseDragged :: 6;
    NSEventTypeRightMouseDragged :: 7;
    NSEventTypeMouseEntered :: 8;
    NSEventTypeMouseExited :: 9;
    NSEventTypeKeyDown :: 10;
    NSEventTypeKeyUp :: 11;
    NSEventTypeFlagsChanged :: 12;
    NSEventTypeAppKitDefined :: 13;
    NSEventTypeSystemDefined :: 14;
    NSEventTypeApplicationDefined :: 15;
    NSEventTypePeriodic :: 16;
    NSEventTypeCursorUpdate :: 17;
    NSEventTypeScrollWheel :: 22;
    NSEventTypeTabletPoint :: 23;
    NSEventTypeTabletProximity :: 24;
    NSEventTypeOtherMouseDown :: 25;
    NSEventTypeOtherMouseUp :: 26;
    NSEventTypeOtherMouseDragged :: 27;
    NSEventTypeGesture :: 29;
    NSEventTypeMagnify :: 30;
    NSEventTypeSwipe :: 31;
    NSEventTypeRotate :: 18;
    NSEventTypeBeginGesture :: 19;
    NSEventTypeEndGesture :: 20;
}
using NSEventMask :: enum u64 {
    NSEventMaskLeftMouseDown :: 1 << 1;
    NSEventMaskLeftMouseUp :: 1 << 2;
    NSEventMaskRightMouseDown :: 1 << 3;
    NSEventMaskRightMouseUp :: 1 << 4;
    NSEventMaskMouseMoved :: 1 << 5;
    NSEventMaskLeftMouseDragged :: 1 << 6;
    NSEventMaskRightMouseDragged :: 1 << 7;
    NSEventMaskMouseEntered :: 1 << 8;
    NSEventMaskMouseExited :: 1 << 9;
    NSEventMaskKeyDown :: 1 << 10;
    NSEventMaskKeyUp :: 1 << 11;
    NSEventMaskFlagsChanged :: 1 << 12;
    NSEventMaskAppKitDefined :: 1 << 13;
    NSEventMaskSystemDefined :: 1 << 14;
    NSEventMaskApplicationDefined :: 1 << 15;
    NSEventMaskPeriodic :: 1 << 16;
    NSEventMaskCursorUpdate :: 1 << 17;
    NSEventMaskScrollWheel :: 1 << 22;
    NSEventMaskTabletPoint :: 1 << 23;
    NSEventMaskTabletProximity :: 1 << 24;
    NSEventMaskOtherMouseDown :: 1 << 25;
    NSEventMaskOtherMouseUp :: 1 << 26;
    NSEventMaskOtherMouseDragged :: 1 << 27;
    NSEventMaskGesture :: 1 << 29;
    NSEventMaskMagnify :: 1 << 30;
    NSEventMaskSwipe :: 1 << 31;
    NSEventMaskRotate :: 1 << 18;
    NSEventMaskBeginGesture :: 1 << 19;
    NSEventMaskEndGesture :: 1 << 20;
    NSEventMaskAny :: 0xFFFFFFFFFFFFFFFF;
}
using NSApplicationActivationPolicy :: enum s64 {
    NSApplicationActivationPolicyRegular :: 0;
    NSApplicationActivationPolicyAccessory :: 1;
    NSApplicationActivationPolicyProhibited :: 2;
}
using NSWindowStyleMask :: enum_flags u64 {
    NSWindowStyleMaskBorderless :: 0;
    NSWindowStyleMaskTitled :: 1 << 0;
    NSWindowStyleMaskClosable :: 1 << 1;
    NSWindowStyleMaskMiniaturizable :: 1 << 2;
    NSWindowStyleMaskResizable :: 1 << 3;
    NSWindowStyleMaskTexturedBackground :: 1 << 8;
    NSWindowStyleMaskUnifiedTitleAndToolbar :: 1 << 12;
    NSWindowStyleMaskFullScreen :: 1 << 14;
    NSWindowStyleMaskFullSizeContentView :: 1 << 15;
    NSWindowStyleMaskUtilityWindow :: 1 << 4;
    NSWindowStyleMaskDocModalWindow :: 1 << 6;
    NSWindowStyleMaskNonactivatingPanel :: 1 << 7;
    NSWindowStyleMaskHUDWindow :: 1 << 13;
}
using NSWindowCollectionBehavior :: enum_flags u64 {
    NSWindowCollectionBehaviorDefault :: 0;
    NSWindowCollectionBehaviorCanJoinAllSpaces :: 1 << 0;
    NSWindowCollectionBehaviorMoveToActiveSpace :: 1 << 1;
    NSWindowCollectionBehaviorManaged :: 1 << 2;
    NSWindowCollectionBehaviorTransient :: 1 << 3;
    NSWindowCollectionBehaviorStationary :: 1 << 4;
    NSWindowCollectionBehaviorParticipatesInCycle :: 1 << 5;
    NSWindowCollectionBehaviorIgnoresCycle :: 1 << 6;
    NSWindowCollectionBehaviorFullScreenPrimary :: 1 << 7;
    NSWindowCollectionBehaviorFullScreenAuxiliary :: 1 << 8;
    NSWindowCollectionBehaviorFullScreenNone :: 1 << 9;
    NSWindowCollectionBehaviorFullScreenAllowsTiling :: 1 << 11;
    NSWindowCollectionBehaviorFullScreenDisallowsTiling :: 1 << 12;
}
using NSBackingStoreType :: enum u64 {
    NSBackingStoreRetained :: 0;
    NSBackingStoreNonretained :: 1;
    NSBackingStoreBuffered :: 2;
}
NSResponder :: struct {
    using #as super: NSObject;
}
NSWindowController :: struct {
    using #as responder: NSResponder;
}
NSColor :: struct {
    using #as super: NSObject;
    blueColor :: () -> *NSColor {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *NSColor #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) objc_getClass(cast(*u8) "NSColor\0"), sel_registerName(cast(*u8) "blueColor\0"));
    }
}
NSPasteboardReadingOptionKey :: *NSString;
NSPasteboardTypeString: NSPasteboardType #elsewhere AppKit;
NSPasteboardTypePDF: NSPasteboardType #elsewhere AppKit;
NSPasteboardTypeTIFF: NSPasteboardType #elsewhere AppKit;
NSPasteboardTypePNG: NSPasteboardType #elsewhere AppKit;
NSPasteboardTypeRTF: NSPasteboardType #elsewhere AppKit;
NSPasteboardTypeRTFD: NSPasteboardType #elsewhere AppKit;
NSPasteboardTypeHTML: NSPasteboardType #elsewhere AppKit;
NSPasteboardTypeTabularText: NSPasteboardType #elsewhere AppKit;
NSPasteboardTypeFont: NSPasteboardType #elsewhere AppKit;
NSPasteboardTypeRuler: NSPasteboardType #elsewhere AppKit;
NSPasteboardTypeColor: NSPasteboardType #elsewhere AppKit;
NSPasteboardTypeSound: NSPasteboardType #elsewhere AppKit;
NSPasteboardTypeMultipleTextSelection: NSPasteboardType #elsewhere AppKit;
NSPasteboardTypeTextFinderOptions: NSPasteboardType #elsewhere AppKit;
NSPasteboardTypeURL: NSPasteboardType #elsewhere AppKit;
NSPasteboardTypeFileURL: NSPasteboardType #elsewhere AppKit;
NSPasteboard :: struct {
    using #as super: NSObject;
    generalPasteboard :: () -> *NSPasteboard {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *NSPasteboard #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) objc_getClass(cast(*u8) "NSPasteboard\0"), sel_registerName(cast(*u8) "generalPasteboard\0"));
    }
    clearContents :: (self: *NSPasteboard) -> NSInteger {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> NSInteger #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "clearContents\0"));
    }
    setString :: (self: *NSPasteboard, str: *NSString, forType: NSPasteboardType) -> BOOL {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, str: *NSString, forType: NSPasteboardType) -> BOOL #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "setString:forType:\0"), str, forType);
    }
    stringForType :: (self: *NSPasteboard, dataType: NSPasteboardType) -> *NSString {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, dataType: NSPasteboardType) -> *NSString #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "stringForType:\0"), dataType);
    }
    writeObjects :: (self: *NSPasteboard, objects: *NSArray(id)) -> BOOL {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, objects: *NSArray(id)) -> BOOL #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "writeObjects:\0"), objects);
    }
    pasteboardItems :: (self: *NSPasteboard) -> *NSArray(*NSPasteboardItem) {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *NSArray(*NSPasteboardItem) #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "pasteboardItems\0"));
    }
    readObjectsForClasses :: (self: *NSPasteboard, classes: *NSArray(Class), options: *NSDictionary(NSPasteboardReadingOptionKey, id), $T: Type) -> *NSArray(T) {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, classes: *NSArray(Class), options: *NSDictionary(NSPasteboardReadingOptionKey, id)) -> *void #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return cast(*NSArray(T)) invoke(cast(*void) self, sel_registerName(cast(*u8) "readObjectsForClasses:options:\0"), classes, options);
    }
}
NSPasteboardItem :: struct {
    using #as super: NSObject;
    types :: (self: *NSPasteboardItem) -> *NSArray(NSPasteboardType) {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *NSArray(NSPasteboardType) #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "types\0"));
    }
    stringForType :: (self: *NSPasteboardItem, dataType: NSPasteboardType) -> *NSString {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, dataType: NSPasteboardType) -> *NSString #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "stringForType:\0"), dataType);
    }
}
NSWindow :: struct {
    using #as responder: NSResponder;
    convertRectToBacking :: NSView.convertRectToBacking;
    convertRectFromBacking :: NSView.convertRectFromBacking;
    backingScaleFactor :: NSView.backingScaleFactor;
    registerForDraggedTypes :: NSView.registerForDraggedTypes;
    initWithContentRect :: (self: *NSWindow, rect: NSRect, styleMask: NSWindowStyleMask, backing: NSBackingStoreType, _defer: BOOL) -> *NSWindow {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, rect: NSRect, styleMask: NSWindowStyleMask, backing: NSBackingStoreType, _defer: BOOL) -> *NSWindow #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "initWithContentRect:styleMask:backing:defer:\0"), rect, styleMask, backing, _defer);
    }
    initWithContentRect :: (self: id, rect: NSRect, styleMask: NSWindowStyleMask, backing: NSBackingStoreType, _defer: BOOL, screen: *NSScreen) -> *NSWindow {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, rect: NSRect, styleMask: NSWindowStyleMask, backing: NSBackingStoreType, _defer: BOOL, screen: *NSScreen) -> *NSWindow #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "initWithContentRect:styleMask:backing:defer:screen:\0"), rect, styleMask, backing, _defer, screen);
    }
    center :: (self: *NSWindow) {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> void #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(cast(*void) self, sel_registerName(cast(*u8) "center\0"));
    }
    frame :: NSView.frame;
    setFrame :: (self: *NSWindow, frame: NSRect, display: BOOL) {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, frame: NSRect, display: BOOL) -> void #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(cast(*void) self, sel_registerName(cast(*u8) "setFrame:display:\0"), frame, display);
    }
    level :: (self: *NSWindow) -> NSWindowLevel {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> NSWindowLevel #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "level\0"));
    }
    setLevel :: (self: *NSWindow, level: NSWindowLevel) {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, level: NSWindowLevel) -> void #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(cast(*void) self, sel_registerName(cast(*u8) "setLevel:\0"), level);
    }
    makeKeyAndOrderFront :: (self: *NSWindow, sender: id) {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, sender: id) -> void #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(cast(*void) self, sel_registerName(cast(*u8) "makeKeyAndOrderFront:\0"), sender);
    }
    setReleasedWhenClosed :: (self: *NSWindow, value: BOOL) {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, value: BOOL) -> void #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(cast(*void) self, sel_registerName(cast(*u8) "setReleasedWhenClosed:\0"), value);
    }
    setBackgroundColor :: (self: *NSWindow, color: *NSColor) {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, color: *NSColor) -> void #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(cast(*void) self, sel_registerName(cast(*u8) "setBackgroundColor:\0"), color);
    }
    setStyleMask :: (self: *NSWindow, styleMask: NSWindowStyleMask) {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, styleMask: NSWindowStyleMask) -> void #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(cast(*void) self, sel_registerName(cast(*u8) "setStyleMask:\0"), styleMask);
    }
    styleMask :: (self: *NSWindow) -> NSWindowStyleMask {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> NSWindowStyleMask #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "styleMask\0"));
    }
    screen :: (self: *NSWindow) -> *NSScreen {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *NSScreen #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "screen\0"));
    }
    setFrameOrigin :: (self: *NSWindow, pt: NSPoint) {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, pt: NSPoint) -> void #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(cast(*void) self, sel_registerName(cast(*u8) "setFrameOrigin:\0"), pt);
    }
    setDelegate :: (self: *NSWindow, dg: id) {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, dg: id) -> void #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(cast(*void) self, sel_registerName(cast(*u8) "setDelegate:\0"), dg);
    }
    update :: (self: *NSWindow) -> id {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> void #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(cast(*void) self, sel_registerName(cast(*u8) "update\0"));
        return null;
    }
    display :: (self: *NSWindow) -> id {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> void #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(cast(*void) self, sel_registerName(cast(*u8) "display\0"));
        return null;
    }
    setContentSize :: (self: *NSWindow, size: NSSize) {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, size: NSSize) -> void #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(cast(*void) self, sel_registerName(cast(*u8) "setContentSize:\0"), size);
    }
    setCollectionBehavior :: (self: *NSWindow, behavior: NSWindowCollectionBehavior) {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, behavior: NSWindowCollectionBehavior) -> void #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(cast(*void) self, sel_registerName(cast(*u8) "setCollectionBehavior:\0"), behavior);
    }
    setTitle :: (self: *NSWindow, title: *NSString) -> id {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, title: *NSString) -> void #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(cast(*void) self, sel_registerName(cast(*u8) "setTitle:\0"), title);
        return null;
    }
    setContentView :: (self: *NSWindow, contentView: id) {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, contentView: id) -> void #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(cast(*void) self, sel_registerName(cast(*u8) "setContentView:\0"), contentView);
    }
    contentView :: (self: *NSWindow) -> *NSView {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *NSView #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "contentView\0"));
    }
    makeFirstResponder :: (self: *NSWindow, view: id) {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, view: id) -> void #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(cast(*void) self, sel_registerName(cast(*u8) "makeFirstResponder:\0"), view);
    }
    mouseLocationOutsideOfEventStream :: (self: *NSWindow) -> NSPoint {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> NSPoint #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "mouseLocationOutsideOfEventStream\0"));
    }
    performClose :: (self: *NSWindow, sender: id) {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, sender: id) -> void #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(cast(*void) self, sel_registerName(cast(*u8) "performClose:\0"), sender);
    }
    close :: (self: *NSWindow) {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> void #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(cast(*void) self, sel_registerName(cast(*u8) "close\0"));
    }
    convertRectFromScreen :: (self: *NSWindow, rect: NSRect) -> NSRect {
        #if CPU == .X64 {
            result: NSRect;
            invoke: (output: *NSRect, sdk_receiver: *void, sdk_selector: SEL, rect: NSRect) -> void #c_call;
            invoke = cast(type_of(invoke)) objc_msgSend_stret;
            invoke(*result, cast(*void) self, sel_registerName(cast(*u8) "convertRectFromScreen:\0"), rect);
            return result;
        } else {
            invoke: (sdk_receiver: *void, sdk_selector: SEL, rect: NSRect) -> NSRect #c_call;
            invoke = cast(type_of(invoke)) objc_msgSend;
            return invoke(cast(*void) self, sel_registerName(cast(*u8) "convertRectFromScreen:\0"), rect);
        }
    }
    convertPointFromScreen :: (self: *NSWindow, point: NSPoint) -> NSPoint {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, point: NSPoint) -> NSPoint #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "convertPointFromScreen:\0"), point);
    }
    orderOut :: (self: *NSWindow, sender: id) {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, sender: id) -> void #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(cast(*void) self, sel_registerName(cast(*u8) "orderOut:\0"), sender);
    }
    orderFront :: (self: *NSWindow, sender: id) {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, sender: id) -> void #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(cast(*void) self, sel_registerName(cast(*u8) "orderFront:\0"), sender);
    }
    toggleFullScreen :: (self: *NSWindow, sender: id) {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, sender: id) -> void #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(cast(*void) self, sel_registerName(cast(*u8) "toggleFullScreen:\0"), sender);
    }
    setTitle :: (self: *NSWindow, title: string) -> id {
        value := NSString.getTempString(title);
        NSWindow.setTitle(self, value);
        return null;
    }
}
NSPanel :: struct {
    using super_NSWindow: NSWindow;
}
NSSavePanel :: struct {
    using super_NSPanel: NSPanel;
    savePanel :: () -> *NSSavePanel {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *NSSavePanel #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) objc_getClass(cast(*u8) "NSSavePanel\0"), sel_registerName(cast(*u8) "savePanel\0"));
    }
    runModal :: (self: *NSSavePanel) -> NSModalResponse {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> NSModalResponse #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "runModal\0"));
    }
    URL :: (self: *NSSavePanel) -> *NSURL {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *NSURL #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "URL\0"));
    }
    showsTagField :: (self: *NSSavePanel) -> BOOL {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> BOOL #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "showsTagField\0"));
    }
    setShowsTagField :: (self: *NSSavePanel, show: BOOL) {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, show: BOOL) -> void #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(cast(*void) self, sel_registerName(cast(*u8) "setShowsTagField:\0"), show);
    }
    canSelectHiddenExtension :: (self: *NSSavePanel) -> BOOL {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> BOOL #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "canSelectHiddenExtension\0"));
    }
    setCanSelectHiddenExtension :: (self: *NSSavePanel, can: BOOL) {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, can: BOOL) -> void #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(cast(*void) self, sel_registerName(cast(*u8) "setCanSelectHiddenExtension:\0"), can);
    }
    directoryURL :: (self: *NSSavePanel) -> *NSURL {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *NSURL #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "directoryURL\0"));
    }
    setDirectoryURL :: (self: *NSSavePanel, url: *NSURL) {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, url: *NSURL) -> void #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(cast(*void) self, sel_registerName(cast(*u8) "setDirectoryURL:\0"), url);
    }
    setNameFieldStringValue :: (self: *NSSavePanel, value: *NSString) {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, value: *NSString) -> void #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(cast(*void) self, sel_registerName(cast(*u8) "setNameFieldStringValue:\0"), value);
    }
    nameFieldStringValue :: (self: *NSSavePanel) -> *NSString {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *NSString #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "nameFieldStringValue\0"));
    }
    setAllowedFileTypes :: (self: *NSSavePanel, types: *NSArray(*NSString)) {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, types: *NSArray(*NSString)) -> void #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(cast(*void) self, sel_registerName(cast(*u8) "setAllowedFileTypes:\0"), types);
    }
    allowedFileTypes :: (self: *NSSavePanel) -> *NSArray(*NSString) {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *NSArray(*NSString) #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "allowedFileTypes\0"));
    }
    setAllowsOtherFileTypes :: (self: *NSSavePanel, value: BOOL) {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, value: BOOL) -> void #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(cast(*void) self, sel_registerName(cast(*u8) "setAllowsOtherFileTypes:\0"), value);
    }
    allowsOtherFileTypes :: (self: *NSSavePanel) -> BOOL {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> BOOL #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "allowsOtherFileTypes\0"));
    }
}
NSOpenPanel :: struct {
    using super_NSSavePanel: NSSavePanel;
    openPanel :: () -> *NSOpenPanel {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *NSOpenPanel #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) objc_getClass(cast(*u8) "NSOpenPanel\0"), sel_registerName(cast(*u8) "openPanel\0"));
    }
}
NSFileHandlingPanelCancelButton :: NSModalResponseCancel;
NSFileHandlingPanelOKButton :: NSModalResponseOK;
NSAlertFirstButtonReturn: NSModalResponse : 1000;
NSAlertSecondButtonReturn: NSModalResponse : 1001;
NSAlertThirdButtonReturn: NSModalResponse : 1002;
NSModalResponseStop: NSModalResponse : -1000;
NSModalResponseAbort: NSModalResponse : -1001;
NSModalResponseContinue: NSModalResponse : -1002;
NSModalResponseOK: NSModalResponse : 1;
NSModalResponseCancel: NSModalResponse : 0;
NSModalResponse :: s64;
NSWindowLevel :: s64;
NSMenu :: struct {
    using #as super: NSObject;
    addItem :: (self: *NSMenu, item: *NSMenuItem) {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, item: *NSMenuItem) -> void #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(cast(*void) self, sel_registerName(cast(*u8) "addItem:\0"), item);
    }
    addItemWithTitle :: (self: *NSMenu, title: *NSString, action: Selector, keyEquivalent: *NSString) -> *NSMenuItem {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, title: *NSString, action: Selector, keyEquivalent: *NSString) -> *NSMenuItem #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "addItemWithTitle:action:keyEquivalent:\0"), title, action, keyEquivalent);
    }
}
NSMenuItem :: struct {
    using #as super: NSObject;
    initWithTitle :: (self: *NSMenuItem, title: *NSString, action: Selector, keyEquivalent: *NSString) -> *NSMenuItem {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, title: *NSString, action: Selector, keyEquivalent: *NSString) -> *NSMenuItem #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "initWithTitle:action:keyEquivalent:\0"), title, action, keyEquivalent);
    }
    setSubmenu :: (self: *NSMenuItem, sub: *NSMenu) {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, sub: *NSMenu) -> void #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(cast(*void) self, sel_registerName(cast(*u8) "setSubmenu:\0"), sub);
    }
    setKeyEquivalentModifierMask :: (self: *NSMenuItem, value: NSEventModifierFlags) {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, value: NSEventModifierFlags) -> void #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(cast(*void) self, sel_registerName(cast(*u8) "setKeyEquivalentModifierMask:\0"), value);
    }
    keyEquivalentModifierMask :: (self: *NSMenuItem) -> NSEventModifierFlags {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> NSEventModifierFlags #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "keyEquivalentModifierMask\0"));
    }
}
NSView :: struct {
    using #as super: NSObject;
    pad: [152 - size_of(NSObject)] u8;
    addSubView :: (self: *NSView, view: *NSView) {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, view: *NSView) -> void #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(cast(*void) self, sel_registerName(cast(*u8) "addSubview:\0"), view);
    }
    setWantsLayer :: (self: id, yesno: BOOL) {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, yesno: BOOL) -> void #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(cast(*void) self, sel_registerName(cast(*u8) "setWantsLayer:\0"), yesno);
    }
    frame :: (self: id) -> NSRect {
        #if CPU == .X64 {
            result: NSRect;
            invoke: (output: *NSRect, sdk_receiver: *void, sdk_selector: SEL) -> void #c_call;
            invoke = cast(type_of(invoke)) objc_msgSend_stret;
            invoke(*result, cast(*void) self, sel_registerName(cast(*u8) "frame\0"));
            return result;
        } else {
            invoke: (sdk_receiver: *void, sdk_selector: SEL) -> NSRect #c_call;
            invoke = cast(type_of(invoke)) objc_msgSend;
            return invoke(cast(*void) self, sel_registerName(cast(*u8) "frame\0"));
        }
    }
    bounds :: (self: id) -> NSRect {
        #if CPU == .X64 {
            result: NSRect;
            invoke: (output: *NSRect, sdk_receiver: *void, sdk_selector: SEL) -> void #c_call;
            invoke = cast(type_of(invoke)) objc_msgSend_stret;
            invoke(*result, cast(*void) self, sel_registerName(cast(*u8) "bounds\0"));
            return result;
        } else {
            invoke: (sdk_receiver: *void, sdk_selector: SEL) -> NSRect #c_call;
            invoke = cast(type_of(invoke)) objc_msgSend;
            return invoke(cast(*void) self, sel_registerName(cast(*u8) "bounds\0"));
        }
    }
    setFrame :: (self: id, frame: NSRect) {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, frame: NSRect) -> void #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(cast(*void) self, sel_registerName(cast(*u8) "setFrame:\0"), frame);
    }
    setWantsBestResolutionOpenGLSurface :: (self: id, val: BOOL) {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, val: BOOL) -> void #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(cast(*void) self, sel_registerName(cast(*u8) "setWantsBestResolutionOpenGLSurface:\0"), val);
    }
    convertRectToBacking :: (self: id, rect: NSRect) -> NSRect {
        #if CPU == .X64 {
            result: NSRect;
            invoke: (output: *NSRect, sdk_receiver: *void, sdk_selector: SEL, rect: NSRect) -> void #c_call;
            invoke = cast(type_of(invoke)) objc_msgSend_stret;
            invoke(*result, cast(*void) self, sel_registerName(cast(*u8) "convertRectToBacking:\0"), rect);
            return result;
        } else {
            invoke: (sdk_receiver: *void, sdk_selector: SEL, rect: NSRect) -> NSRect #c_call;
            invoke = cast(type_of(invoke)) objc_msgSend;
            return invoke(cast(*void) self, sel_registerName(cast(*u8) "convertRectToBacking:\0"), rect);
        }
    }
    convertRectFromBacking :: (self: id, rect: NSRect) -> NSRect {
        #if CPU == .X64 {
            result: NSRect;
            invoke: (output: *NSRect, sdk_receiver: *void, sdk_selector: SEL, rect: NSRect) -> void #c_call;
            invoke = cast(type_of(invoke)) objc_msgSend_stret;
            invoke(*result, cast(*void) self, sel_registerName(cast(*u8) "convertRectFromBacking:\0"), rect);
            return result;
        } else {
            invoke: (sdk_receiver: *void, sdk_selector: SEL, rect: NSRect) -> NSRect #c_call;
            invoke = cast(type_of(invoke)) objc_msgSend;
            return invoke(cast(*void) self, sel_registerName(cast(*u8) "convertRectFromBacking:\0"), rect);
        }
    }
    convertPointToBacking :: (self: id, point: NSPoint) -> NSPoint {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, point: NSPoint) -> NSPoint #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "convertPointToBacking:\0"), point);
    }
    convertPointFromBacking :: (self: id, point: NSPoint) -> NSPoint {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, point: NSPoint) -> NSPoint #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "convertPointFromBacking:\0"), point);
    }
    backingScaleFactor :: (self: id) -> CGFloat {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> CGFloat #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "backingScaleFactor\0"));
    }
    isInFullScreenMode :: (self: id) -> BOOL {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> BOOL #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "isInFullScreenMode\0"));
    }
    enterFullScreenMode :: (self: id, screen: *NSScreen, withOptions: *NSDictionary) -> BOOL {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, screen: *NSScreen, withOptions: *NSDictionary) -> BOOL #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "enterFullScreenMode:withOptions:\0"), screen, withOptions);
    }
    exitFullScreenModeWithOptions :: (self: id, options: *NSDictionary) {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, options: *NSDictionary) -> void #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(cast(*void) self, sel_registerName(cast(*u8) "exitFullScreenModeWithOptions:\0"), options);
    }
    layer :: (self: id) -> *CALayer {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *CALayer #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "layer\0"));
    }
    mouse_inRect :: (self: id, mouse: NSPoint, inRect: NSRect) -> BOOL {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, mouse: NSPoint, inRect: NSRect) -> BOOL #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "mouse:inRect:\0"), mouse, inRect);
    }
    convertPoint :: (self: id, point: NSPoint, fromView: *NSView) -> NSPoint {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, point: NSPoint, fromView: *NSView) -> NSPoint #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "convertPoint:fromView:\0"), point, fromView);
    }
    drawRect :: (self: id, dirtyRect: NSRect) {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, dirtyRect: NSRect) -> void #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(cast(*void) self, sel_registerName(cast(*u8) "drawRect:\0"), dirtyRect);
    }
    registerForDraggedTypes :: (self: id, newTypes: *NSArray(NSPasteboardType)) {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, newTypes: *NSArray(NSPasteboardType)) -> void #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(cast(*void) self, sel_registerName(cast(*u8) "registerForDraggedTypes:\0"), newTypes);
    }
}
NSViewController :: struct {
    using #as responder: NSResponder;
}
NSOpenGLContext :: struct {
    using #as super: NSObject;
    currentContext :: () -> *NSOpenGLContext {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *NSOpenGLContext #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) objc_getClass(cast(*u8) "NSOpenGLContext\0"), sel_registerName(cast(*u8) "currentContext\0"));
    }
    flushBuffer :: (self: id) {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> void #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(cast(*void) self, sel_registerName(cast(*u8) "flushBuffer\0"));
    }
    update :: (self: id) -> id {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> void #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(cast(*void) self, sel_registerName(cast(*u8) "update\0"));
        return null;
    }
    setView :: (self: id, view: *NSView) {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, view: *NSView) -> void #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(cast(*void) self, sel_registerName(cast(*u8) "setView:\0"), view);
    }
    view :: (self: id) -> *NSView {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *NSView #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "view\0"));
    }
    initWithFormat :: (self: id, format: *NSOpenGLPixelFormat, shareContext: *NSOpenGLContext) -> *NSOpenGLContext {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, format: *NSOpenGLPixelFormat, shareContext: *NSOpenGLContext) -> *NSOpenGLContext #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "initWithFormat:shareContext:\0"), format, shareContext);
    }
    makeCurrentContext :: (self: id) {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> void #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(cast(*void) self, sel_registerName(cast(*u8) "makeCurrentContext\0"));
    }
    setValues :: (self: id, values: *s32, forParameter: NSOpenGLContextParameter) {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, values: *s32, forParameter: NSOpenGLContextParameter) -> void #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(cast(*void) self, sel_registerName(cast(*u8) "setValues:forParameter:\0"), values, forParameter);
    }
}
using NSOpenGLContextParameter :: enum s64 {
    NSOpenGLContextParameterSwapInterval :: 222;
    NSOpenGLContextParameterSurfaceOrder :: 235;
    NSOpenGLContextParameterSurfaceOpacity :: 236;
    NSOpenGLContextParameterSurfaceBackingSize :: 304;
    NSOpenGLContextParameterReclaimResources :: 308;
    NSOpenGLContextParameterCurrentRendererID :: 309;
    NSOpenGLContextParameterGPUVertexProcessing :: 310;
    NSOpenGLContextParameterGPUFragmentProcessing :: 311;
    NSOpenGLContextParameterHasDrawable :: 314;
    NSOpenGLContextParameterMPSwapsInFlight :: 315;
    NSOpenGLContextParameterSwapRectangle :: 200;
    NSOpenGLContextParameterSwapRectangleEnable :: 201;
    NSOpenGLContextParameterRasterizationEnable :: 221;
    NSOpenGLContextParameterStateValidation :: 301;
    NSOpenGLContextParameterSurfaceSurfaceVolatile :: 306;
}
NSOpenGLPixelFormatAttribute :: u32;
NSOpenGLPFAAllRenderers: NSOpenGLPixelFormatAttribute : 1;
NSOpenGLPFATripleBuffer: NSOpenGLPixelFormatAttribute : 3;
NSOpenGLPFADoubleBuffer: NSOpenGLPixelFormatAttribute : 5;
NSOpenGLPFAAuxBuffers: NSOpenGLPixelFormatAttribute : 7;
NSOpenGLPFAColorSize: NSOpenGLPixelFormatAttribute : 8;
NSOpenGLPFAAlphaSize: NSOpenGLPixelFormatAttribute : 11;
NSOpenGLPFADepthSize: NSOpenGLPixelFormatAttribute : 12;
NSOpenGLPFAStencilSize: NSOpenGLPixelFormatAttribute : 13;
NSOpenGLPFAAccumSize: NSOpenGLPixelFormatAttribute : 14;
NSOpenGLPFAMinimumPolicy: NSOpenGLPixelFormatAttribute : 51;
NSOpenGLPFAMaximumPolicy: NSOpenGLPixelFormatAttribute : 52;
NSOpenGLPFASampleBuffers: NSOpenGLPixelFormatAttribute : 55;
NSOpenGLPFASamples: NSOpenGLPixelFormatAttribute : 56;
NSOpenGLPFAAuxDepthStencil: NSOpenGLPixelFormatAttribute : 57;
NSOpenGLPFAColorFloat: NSOpenGLPixelFormatAttribute : 58;
NSOpenGLPFAMultisample: NSOpenGLPixelFormatAttribute : 59;
NSOpenGLPFASupersample: NSOpenGLPixelFormatAttribute : 60;
NSOpenGLPFASampleAlpha: NSOpenGLPixelFormatAttribute : 61;
NSOpenGLPFARendererID: NSOpenGLPixelFormatAttribute : 70;
NSOpenGLPFANoRecovery: NSOpenGLPixelFormatAttribute : 72;
NSOpenGLPFAAccelerated: NSOpenGLPixelFormatAttribute : 73;
NSOpenGLPFAClosestPolicy: NSOpenGLPixelFormatAttribute : 74;
NSOpenGLPFABackingStore: NSOpenGLPixelFormatAttribute : 76;
NSOpenGLPFAScreenMask: NSOpenGLPixelFormatAttribute : 84;
NSOpenGLPFAAllowOfflineRenderers: NSOpenGLPixelFormatAttribute : 96;
NSOpenGLPFAAcceleratedCompute: NSOpenGLPixelFormatAttribute : 97;
NSOpenGLPFAOpenGLProfile: NSOpenGLPixelFormatAttribute : 99;
NSOpenGLPFAVirtualScreenCount: NSOpenGLPixelFormatAttribute : 128;
NSOpenGLPFAStereo: NSOpenGLPixelFormatAttribute : 6;
NSOpenGLPFAOffScreen: NSOpenGLPixelFormatAttribute : 53;
NSOpenGLPFAFullScreen: NSOpenGLPixelFormatAttribute : 54;
NSOpenGLPFASingleRenderer: NSOpenGLPixelFormatAttribute : 71;
NSOpenGLPFARobust: NSOpenGLPixelFormatAttribute : 75;
NSOpenGLPFAMPSafe: NSOpenGLPixelFormatAttribute : 78;
NSOpenGLPFAWindow: NSOpenGLPixelFormatAttribute : 80;
NSOpenGLPFAMultiScreen: NSOpenGLPixelFormatAttribute : 81;
NSOpenGLPFACompliant: NSOpenGLPixelFormatAttribute : 83;
NSOpenGLPFAPixelBuffer: NSOpenGLPixelFormatAttribute : 90;
NSOpenGLPFARemotePixelBuffer: NSOpenGLPixelFormatAttribute : 91;
NSOpenGLProfileVersionLegacy: NSOpenGLPixelFormatAttribute : 0x1000;
NSOpenGLProfileVersion3_2Core: NSOpenGLPixelFormatAttribute : 0x3200;
NSOpenGLProfileVersion4_1Core: NSOpenGLPixelFormatAttribute : 0x4100;
NSOpenGLPixelFormat :: struct {
    using #as super: NSObject;
    initWithAttributes :: (self: id, attrs: *NSOpenGLPixelFormatAttribute) -> *NSOpenGLPixelFormat {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, attrs: *NSOpenGLPixelFormatAttribute) -> *NSOpenGLPixelFormat #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "initWithAttributes:\0"), attrs);
    }
    getValues :: (self: id, values: *s32, forAttribute: NSOpenGLPixelFormatAttribute, forVirtualScreen: s32) {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, values: *s32, forAttribute: NSOpenGLPixelFormatAttribute, forVirtualScreen: s32) -> void #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(cast(*void) self, sel_registerName(cast(*u8) "getValues:forAttribute:forVirtualScreen:\0"), values, forAttribute, forVirtualScreen);
    }
}
NSScreen :: struct {
    using #as super: NSObject;
    mainScreen :: () -> *NSScreen {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *NSScreen #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) objc_getClass(cast(*u8) "NSScreen\0"), sel_registerName(cast(*u8) "mainScreen\0"));
    }
    frame :: NSView.frame;
    backingScaleFactor :: NSView.backingScaleFactor;
}
NSCursor :: struct {
    using #as super: NSObject;
    hide :: () {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> void #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(cast(*void) objc_getClass(cast(*u8) "NSCursor\0"), sel_registerName(cast(*u8) "hide\0"));
    }
    unhide :: () {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> void #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(cast(*void) objc_getClass(cast(*u8) "NSCursor\0"), sel_registerName(cast(*u8) "unhide\0"));
    }
    set :: (cursor: *NSCursor) {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> void #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(cast(*void) cursor, sel_registerName(cast(*u8) "set\0"));
    }
    arrowCursor :: () -> *NSCursor {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *NSCursor #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) objc_getClass(cast(*u8) "NSCursor\0"), sel_registerName(cast(*u8) "arrowCursor\0"));
    }
    IBeamCursor :: () -> *NSCursor {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *NSCursor #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) objc_getClass(cast(*u8) "NSCursor\0"), sel_registerName(cast(*u8) "IBeamCursor\0"));
    }
    pointingHandCursor :: () -> *NSCursor {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *NSCursor #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) objc_getClass(cast(*u8) "NSCursor\0"), sel_registerName(cast(*u8) "pointingHandCursor\0"));
    }
    openHandCursor :: () -> *NSCursor {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *NSCursor #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) objc_getClass(cast(*u8) "NSCursor\0"), sel_registerName(cast(*u8) "openHandCursor\0"));
    }
    closedHandCursor :: () -> *NSCursor {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *NSCursor #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) objc_getClass(cast(*u8) "NSCursor\0"), sel_registerName(cast(*u8) "closedHandCursor\0"));
    }
    operationNotAllowedCursor :: () -> *NSCursor {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *NSCursor #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) objc_getClass(cast(*u8) "NSCursor\0"), sel_registerName(cast(*u8) "operationNotAllowedCursor\0"));
    }
    resizeLeftRightCursor :: () -> *NSCursor {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *NSCursor #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) objc_getClass(cast(*u8) "NSCursor\0"), sel_registerName(cast(*u8) "resizeLeftRightCursor\0"));
    }
    resizeUpDownCursor :: () -> *NSCursor {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *NSCursor #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) objc_getClass(cast(*u8) "NSCursor\0"), sel_registerName(cast(*u8) "resizeUpDownCursor\0"));
    }
}
NSAlert :: struct {
    using #as super: NSObject;
    layout :: (self: *NSAlert) {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> void #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(cast(*void) self, sel_registerName(cast(*u8) "layout\0"));
    }
    alertStyle :: (self: *NSAlert) -> NSAlertStyle {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> NSAlertStyle #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "alertStyle\0"));
    }
    setAlertStyle :: (self: *NSAlert, style: NSAlertStyle) {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, style: NSAlertStyle) -> void #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(cast(*void) self, sel_registerName(cast(*u8) "setAlertStyle:\0"), style);
    }
    accessoryView :: (self: *NSAlert) -> *NSView {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *NSView #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "accessoryView\0"));
    }
    setAccessoryView :: (self: *NSAlert, value: *NSView) {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, value: *NSView) -> void #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(cast(*void) self, sel_registerName(cast(*u8) "setAccessoryView:\0"), value);
    }
    showsHelp :: (self: *NSAlert) -> BOOL {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> BOOL #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "showsHelp\0"));
    }
    setShowsHelp :: (self: *NSAlert, value: BOOL) {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, value: BOOL) -> void #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(cast(*void) self, sel_registerName(cast(*u8) "setShowsHelp:\0"), value);
    }
    runModal :: (self: *NSAlert) -> NSModalResponse {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> NSModalResponse #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "runModal\0"));
    }
    addButtonWithTitle :: (self: *NSAlert, title: *NSString) -> *NSButton {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, title: *NSString) -> *NSButton #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "addButtonWithTitle:\0"), title);
    }
    messageText :: (self: *NSAlert) -> *NSString {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *NSString #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "messageText\0"));
    }
    setMessageText :: (self: *NSAlert, value: *NSString) {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, value: *NSString) -> void #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(cast(*void) self, sel_registerName(cast(*u8) "setMessageText:\0"), value);
    }
    informativeText :: (self: *NSAlert) -> *NSString {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *NSString #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "informativeText\0"));
    }
    setInformativeText :: (self: *NSAlert, value: *NSString) {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, value: *NSString) -> void #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(cast(*void) self, sel_registerName(cast(*u8) "setInformativeText:\0"), value);
    }
    addButtonWithTitle :: (self: *NSAlert, title: string) {
        value := NSString.getTempString(title);
        NSAlert.addButtonWithTitle(self, value);
    }
    setMessageText :: (self: *NSAlert, title: string) {
        value := NSString.getTempString(title);
        NSAlert.setMessageText(self, value);
    }
    setInformativeText :: (self: *NSAlert, title: string) {
        value := NSString.getTempString(title);
        NSAlert.setInformativeText(self, value);
    }
}
NSAlertStyle :: enum u64 {
    NSAlertStyleWarning :: 0;
    NSAlertStyleInformational :: 1;
    NSAlertStyleCritical :: 2;
}
NSButton :: struct {
    using #as view: NSView;
    buttonWithTitle :: (title: *NSString, target: id, action: Selector) -> *NSButton {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, title: *NSString, target: id, action: Selector) -> *NSButton #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) objc_getClass(cast(*u8) "NSButton\0"), sel_registerName(cast(*u8) "buttonWithTitle:target:action:\0"), title, target, action);
    }
}
NSImageRep :: struct {
    using #as super: NSObject;
    size :: (self: *NSImageRep) -> NSSize {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> NSSize #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "size\0"));
    }
    setSize :: (self: *NSImageRep, size: NSSize) {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, size: NSSize) -> void #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(cast(*void) self, sel_registerName(cast(*u8) "setSize:\0"), size);
    }
}
NSBitmapImageRep :: struct {
    using #as image_rep: NSImageRep;
    initWithBitmapDataPlanes :: (self: *NSBitmapImageRep, planes: **u8, pixelsWide: NSInteger, pixelsHigh: NSInteger, bitsPerSample: NSInteger, samplesPerPixel: NSInteger, hasAlpha: BOOL, isPlanar: BOOL, colorSpaceName: NSColorSpaceName, bytesPerRow: NSInteger, bitsPerPixel: NSInteger) -> *NSBitmapImageRep {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, planes: **u8, pixelsWide: NSInteger, pixelsHigh: NSInteger, bitsPerSample: NSInteger, samplesPerPixel: NSInteger, hasAlpha: BOOL, isPlanar: BOOL, colorSpaceName: NSColorSpaceName, bytesPerRow: NSInteger, bitsPerPixel: NSInteger) -> *NSBitmapImageRep #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "initWithBitmapDataPlanes:pixelsWide:pixelsHigh:bitsPerSample:samplesPerPixel:hasAlpha:isPlanar:colorSpaceName:bytesPerRow:bitsPerPixel:\0"), planes, pixelsWide, pixelsHigh, bitsPerSample, samplesPerPixel, hasAlpha, isPlanar, colorSpaceName, bytesPerRow, bitsPerPixel);
    }
    bitmapData :: (self: *NSBitmapImageRep) -> *u8 {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *u8 #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "bitmapData\0"));
    }
}
NSImage :: struct {
    using #as super: NSObject;
    initWithSize :: (self: *NSImage, size: NSSize) -> *NSImage {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, size: NSSize) -> *NSImage #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "initWithSize:\0"), size);
    }
    addRepresentation :: (self: *NSImage, rep: *NSImageRep) {
        invoke: (sdk_receiver: *void, sdk_selector: SEL, rep: *NSImageRep) -> void #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        invoke(cast(*void) self, sel_registerName(cast(*u8) "addRepresentation:\0"), rep);
    }
}
using NSDragOperation :: enum_flags u64 {
    NSDragOperationNone :: 0;
    NSDragOperationCopy :: 1;
    NSDragOperationLink :: 2;
    NSDragOperationGeneric :: 4;
    NSDragOperationPrivate :: 8;
    NSDragOperationMove :: 16;
    NSDragOperationDelete :: 32;
    NSDragOperationEvery :: 0xFFFFFFFFFFFFFFFF;
}
NSDraggingInfo :: struct {
    draggingSourceOperationMask :: (self: id) -> NSDragOperation #no_context {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> NSDragOperation #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "draggingSourceOperationMask\0"));
    }
    draggingPasteboard :: (self: id) -> *NSPasteboard #no_context {
        invoke: (sdk_receiver: *void, sdk_selector: SEL) -> *NSPasteboard #c_call;
        invoke = cast(type_of(invoke)) objc_msgSend;
        return invoke(cast(*void) self, sel_registerName(cast(*u8) "draggingPasteboard\0"));
    }
}
#scope_module
_Selector_Table :: struct {
    characters: Selector;
    run: Selector;
    keyCode: Selector;
    modifierFlags: Selector;
    isARepeat: Selector;
    sharedApplication: Selector;
    mainWindow: Selector;
    sendEvent_: Selector;
    updateWindows: Selector;
    activateIgnoringOtherApps_: Selector;
    setActivationPolicy_: Selector;
    finishLaunching: Selector;
    setMainMenu_: Selector;
    nextEventMatchingMask_untilDate_inMode_dequeue_: Selector;
    blueColor: Selector;
    update: Selector;
    display: Selector;
    contentView: Selector;
    makeKeyAndOrderFront_: Selector;
    setReleasedWhenClosed_: Selector;
    setBackgroundColor_: Selector;
    setStyleMask_: Selector;
    styleMask: Selector;
    setDelegate_: Selector;
    setTitle_: Selector;
    setContentView_: Selector;
    initWithContentRect_styleMask_backing_defer_: Selector;
    initWithContentRect_styleMask_backing_defer_screen_: Selector;
    makeFirstResponder_: Selector;
    addSubview_: Selector;
    setWantsLayer_: Selector;
    flushBuffer: Selector;
    setView_: Selector;
    initWithFormat_shareContext_: Selector;
    makeCurrentContext: Selector;
    initWithAttributes_: Selector;
    type: Selector;
    mouseLocation: Selector;
    generalPasteboard: Selector;
    setString_forType_: Selector;
    types: Selector;
    stringForType_: Selector;
    clearContents: Selector;
    keyRepeatDelay: Selector;
    keyRepeatInterval: Selector;
    pressedMouseButtons: Selector;
    deltaX: Selector;
    deltaY: Selector;
    deltaZ: Selector;
    associatedEventsMask: Selector;
    buttonNumber: Selector;
    clickCount: Selector;
    charactersIgnoringModifiers: Selector;
    mouseLocationOutsideOfEventStream: Selector;
    keyWindow: Selector;
    frame: Selector;
    setFrame_: Selector;
    setFrame_display_: Selector;
    center: Selector;
    convertRectToBacking_: Selector;
    convertRectFromBacking_: Selector;
    convertPointToBacking_: Selector;
    convertPointFromBacking_: Selector;
    backingScaleFactor: Selector;
    setWantsBestResolutionOpenGLSurface_: Selector;
    mainScreen: Selector;
    hide: Selector;
    unhide: Selector;
    set: Selector;
    arrowCursor: Selector;
    IBeamCursor: Selector;
    pointingHandCursor: Selector;
    openHandCursor: Selector;
    closedHandCursor: Selector;
    operationNotAllowedCursor: Selector;
    resizeLeftRightCursor: Selector;
    resizeUpDownCursor: Selector;
    _windowResizeNorthEastSouthWestCursor: Selector;
    isInFullScreenMode: Selector;
    enterFullScreenMode_withOptions_: Selector;
    exitFullScreenModeWithOptions_: Selector;
    toggleFullScreen_: Selector;
    setCollectionBehavior_: Selector;
    setContentSize_: Selector;
    setFrameOrigin_: Selector;
    level: Selector;
    setLevel_: Selector;
    setValues_forParameter_: Selector;
    getValues_forAttribute_forVirtualScreen_: Selector;
    currentContext: Selector;
    view: Selector;
    URL: Selector;
    savePanel: Selector;
    openPanel: Selector;
    runModal: Selector;
    setShowsTagField_: Selector;
    showsTagField: Selector;
    setCanSelectHiddenExtension_: Selector;
    canSelectHiddenExtension: Selector;
    setDirectoryURL_: Selector;
    directoryURL: Selector;
    setNameFieldStringValue_: Selector;
    nameFieldStringValue: Selector;
    allowedFileTypes: Selector;
    setAllowedFileTypes_: Selector;
    allowsOtherFileTypes: Selector;
    setAllowsOtherFileTypes_: Selector;
    alertStyle: Selector;
    setAlertStyle_: Selector;
    informativeText: Selector;
    setInformativeText_: Selector;
    messageText: Selector;
    setMessageText_: Selector;
    layout: Selector;
    accessoryView: Selector;
    setAccessoryView_: Selector;
    showsHelp: Selector;
    setShowsHelp_: Selector;
    addButtonWithTitle_: Selector;
    writeObjects_: Selector;
    pasteboardItems: Selector;
    readObjectsForClasses_options_: Selector;
    size: Selector;
    setSize_: Selector;
    initWithBitmapDataPlanes_pixelsWide_pixelsHigh_bitsPerSample_samplesPerPixel_hasAlpha_isPlanar_colorSpaceName_bytesPerRow_bitsPerPixel_: Selector;
    bitmapData: Selector;
    initWithSize_: Selector;
    addRepresentation_: Selector;
    presentationOptions: Selector;
    setPresentationOptions_: Selector;
    addItem_: Selector;
    initWithTitle_action_keyEquivalent_: Selector;
    setSubmenu_: Selector;
    keyEquivalentModifierMask: Selector;
    setKeyEquivalentModifierMask_: Selector;
    terminate_: Selector;
    addItemWithTitle_action_keyEquivalent_: Selector;
    setAppleMenu_: Selector;
    doNothing_: Selector;
    stop_: Selector;
    layer: Selector;
    performClose_: Selector;
    close: Selector;
    buttonWithTitle_target_action_: Selector;
    requestUserAttention_: Selector;
    mouse_inRect_: Selector;
    convertRectFromScreen_: Selector;
    convertPointFromScreen_: Selector;
    convertPoint_fromView_: Selector;
    bounds: Selector;
    orderOut_: Selector;
    orderFront_: Selector;
    drawRect_: Selector;
    registerForDraggedTypes_: Selector;
    draggingSourceOperationMask: Selector;
    draggingPasteboard: Selector;
}
#import "Objective_C";
Cocoa :: #system_library "Cocoa";
AppKit :: #system_library "AppKit";
#load "CoreGraphics.jai";
_sel: _Selector_Table;
