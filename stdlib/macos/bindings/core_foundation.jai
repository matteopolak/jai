// CoreFoundation declarations (strings, URLs, run loops, property lists).
kCFStringEncodingInvalidId :: 0xffffffff;
__kCFStringInlineBufferLength :: 64;
CFTypeID :: u64;
CFOptionFlags :: u64;
CFHashCode :: u64;
CFIndex :: s64;
CFTypeRef :: *void;
__CFString :: struct {}
CFStringRef :: *__CFString;
CFMutableStringRef :: *__CFString;
CFPropertyListRef :: CFTypeRef;

CFComparisonResult :: enum CFIndex {
    LessThan :: -1;
    EqualTo :: 0;
    GreaterThan :: 1;
    kCFCompareLessThan :: LessThan;
    kCFCompareEqualTo :: EqualTo;
    kCFCompareGreaterThan :: GreaterThan;
}

CFComparatorFunction :: #type (val1: *void, val2: *void, _context: *void) -> CFComparisonResult #c_call;
kCFNotFound: CFIndex : -1;

CFRange :: struct {
    location: CFIndex;
    length: CFIndex;
}

__CFRangeMake :: (loc: CFIndex, len: CFIndex) -> CFRange #foreign corefoundation;
__CFNull :: struct {}
CFNullRef :: *__CFNull;
CFNullGetTypeID :: () -> CFTypeID #foreign corefoundation;
kCFNull: CFNullRef #elsewhere corefoundation;
__CFAllocator :: struct {}
CFAllocatorRef :: *__CFAllocator;
kCFAllocatorDefault: CFAllocatorRef #elsewhere corefoundation;
kCFAllocatorSystemDefault: CFAllocatorRef #elsewhere corefoundation;
kCFAllocatorMalloc: CFAllocatorRef #elsewhere corefoundation;
kCFAllocatorMallocZone: CFAllocatorRef #elsewhere corefoundation;
kCFAllocatorNull: CFAllocatorRef #elsewhere corefoundation;
kCFAllocatorUseContext: CFAllocatorRef #elsewhere corefoundation;
CFAllocatorRetainCallBack :: #type (info: *void) -> *void #c_call;
CFAllocatorReleaseCallBack :: #type (info: *void) -> void #c_call;
CFAllocatorCopyDescriptionCallBack :: #type (info: *void) -> CFStringRef #c_call;
CFAllocatorAllocateCallBack :: #type (allocSize: CFIndex, hint: CFOptionFlags, info: *void) -> *void #c_call;
CFAllocatorReallocateCallBack :: #type (ptr: *void, newsize: CFIndex, hint: CFOptionFlags, info: *void) -> *void #c_call;
CFAllocatorDeallocateCallBack :: #type (ptr: *void, info: *void) -> void #c_call;
CFAllocatorPreferredSizeCallBack :: #type (size: CFIndex, hint: CFOptionFlags, info: *void) -> CFIndex #c_call;

CFAllocatorContext :: struct {
    version: CFIndex;
    info: *void;
    retain: CFAllocatorRetainCallBack;
    release: CFAllocatorReleaseCallBack;
    copyDescription: CFAllocatorCopyDescriptionCallBack;
    allocate: CFAllocatorAllocateCallBack;
    reallocate: CFAllocatorReallocateCallBack;
    deallocate: CFAllocatorDeallocateCallBack;
    preferredSize: CFAllocatorPreferredSizeCallBack;
}

CFAllocatorGetTypeID :: () -> CFTypeID #foreign corefoundation;
CFAllocatorSetDefault :: (allocator: CFAllocatorRef) -> void #foreign corefoundation;
CFAllocatorGetDefault :: () -> CFAllocatorRef #foreign corefoundation;
CFAllocatorCreate :: (allocator: CFAllocatorRef, _context: *CFAllocatorContext) -> CFAllocatorRef #foreign corefoundation;
CFAllocatorAllocate :: (allocator: CFAllocatorRef, size: CFIndex, hint: CFOptionFlags) -> *void #foreign corefoundation;
CFAllocatorReallocate :: (allocator: CFAllocatorRef, ptr: *void, newsize: CFIndex, hint: CFOptionFlags) -> *void #foreign corefoundation;
CFAllocatorDeallocate :: (allocator: CFAllocatorRef, ptr: *void) -> void #foreign corefoundation;
CFAllocatorGetPreferredSizeForSize :: (allocator: CFAllocatorRef, size: CFIndex, hint: CFOptionFlags) -> CFIndex #foreign corefoundation;
CFAllocatorGetContext :: (allocator: CFAllocatorRef, _context: *CFAllocatorContext) -> void #foreign corefoundation;
CFGetTypeID :: (cf: CFTypeRef) -> CFTypeID #foreign corefoundation;
CFCopyTypeIDDescription :: (type_id: CFTypeID) -> CFStringRef #foreign corefoundation;
CFRetain :: (cf: CFTypeRef) -> CFTypeRef #foreign corefoundation;
CFRelease :: (cf: CFTypeRef) -> void #foreign corefoundation;
CFAutorelease :: (arg: CFTypeRef) -> CFTypeRef #foreign corefoundation;
CFGetRetainCount :: (cf: CFTypeRef) -> CFIndex #foreign corefoundation;
CFEqual :: (cf1: CFTypeRef, cf2: CFTypeRef) -> Boolean #foreign corefoundation;
CFHash :: (cf: CFTypeRef) -> CFHashCode #foreign corefoundation;
CFCopyDescription :: (cf: CFTypeRef) -> CFStringRef #foreign corefoundation;
CFGetAllocator :: (cf: CFTypeRef) -> CFAllocatorRef #foreign corefoundation;
CFMakeCollectable :: (cf: CFTypeRef) -> CFTypeRef #foreign corefoundation;
CFArrayRetainCallBack :: #type (allocator: CFAllocatorRef, value: *void) -> *void #c_call;
CFArrayReleaseCallBack :: #type (allocator: CFAllocatorRef, value: *void) -> void #c_call;
CFArrayCopyDescriptionCallBack :: #type (value: *void) -> CFStringRef #c_call;
CFArrayEqualCallBack :: #type (value1: *void, value2: *void) -> Boolean #c_call;

CFArrayCallBacks :: struct {
    version: CFIndex;
    retain: CFArrayRetainCallBack;
    release: CFArrayReleaseCallBack;
    copyDescription: CFArrayCopyDescriptionCallBack;
    equal: CFArrayEqualCallBack;
}

kCFTypeArrayCallBacks: CFArrayCallBacks #elsewhere corefoundation;
CFArrayApplierFunction :: #type (value: *void, _context: *void) -> void #c_call;
__CFArray :: struct {}
CFArrayRef :: *__CFArray;
CFMutableArrayRef :: *__CFArray;
CFArrayGetTypeID :: () -> CFTypeID #foreign corefoundation;
CFArrayCreate :: (allocator: CFAllocatorRef, values: **void, numValues: CFIndex, callBacks: *CFArrayCallBacks) -> CFArrayRef #foreign corefoundation;
CFArrayCreateCopy :: (allocator: CFAllocatorRef, theArray: CFArrayRef) -> CFArrayRef #foreign corefoundation;
CFArrayCreateMutable :: (allocator: CFAllocatorRef, capacity: CFIndex, callBacks: *CFArrayCallBacks) -> CFMutableArrayRef #foreign corefoundation;
CFArrayCreateMutableCopy :: (allocator: CFAllocatorRef, capacity: CFIndex, theArray: CFArrayRef) -> CFMutableArrayRef #foreign corefoundation;
CFArrayGetCount :: (theArray: CFArrayRef) -> CFIndex #foreign corefoundation;
CFArrayGetCountOfValue :: (theArray: CFArrayRef, range: CFRange, value: *void) -> CFIndex #foreign corefoundation;
CFArrayContainsValue :: (theArray: CFArrayRef, range: CFRange, value: *void) -> Boolean #foreign corefoundation;
CFArrayGetValueAtIndex :: (theArray: CFArrayRef, idx: CFIndex) -> *void #foreign corefoundation;
CFArrayGetValues :: (theArray: CFArrayRef, range: CFRange, values: **void) -> void #foreign corefoundation;
CFArrayApplyFunction :: (theArray: CFArrayRef, range: CFRange, applier: CFArrayApplierFunction, _context: *void) -> void #foreign corefoundation;
CFArrayGetFirstIndexOfValue :: (theArray: CFArrayRef, range: CFRange, value: *void) -> CFIndex #foreign corefoundation;
CFArrayGetLastIndexOfValue :: (theArray: CFArrayRef, range: CFRange, value: *void) -> CFIndex #foreign corefoundation;
CFArrayBSearchValues :: (theArray: CFArrayRef, range: CFRange, value: *void, comparator: CFComparatorFunction, _context: *void) -> CFIndex #foreign corefoundation;
CFArrayAppendValue :: (theArray: CFMutableArrayRef, value: *void) -> void #foreign corefoundation;
CFArrayInsertValueAtIndex :: (theArray: CFMutableArrayRef, idx: CFIndex, value: *void) -> void #foreign corefoundation;
CFArraySetValueAtIndex :: (theArray: CFMutableArrayRef, idx: CFIndex, value: *void) -> void #foreign corefoundation;
CFArrayRemoveValueAtIndex :: (theArray: CFMutableArrayRef, idx: CFIndex) -> void #foreign corefoundation;
CFArrayRemoveAllValues :: (theArray: CFMutableArrayRef) -> void #foreign corefoundation;
CFArrayReplaceValues :: (theArray: CFMutableArrayRef, range: CFRange, newValues: **void, newCount: CFIndex) -> void #foreign corefoundation;
CFArrayExchangeValuesAtIndices :: (theArray: CFMutableArrayRef, idx1: CFIndex, idx2: CFIndex) -> void #foreign corefoundation;
CFArraySortValues :: (theArray: CFMutableArrayRef, range: CFRange, comparator: CFComparatorFunction, _context: *void) -> void #foreign corefoundation;
CFArrayAppendArray :: (theArray: CFMutableArrayRef, otherArray: CFArrayRef, otherRange: CFRange) -> void #foreign corefoundation;
__CFBag :: struct {}
CFMutableBagRef :: *__CFBag;
__CFBinaryHeap :: struct {}
CFBit :: u32;
__CFBitVector :: struct {}
CFMutableBitVectorRef :: *__CFBitVector;

__CFByteOrder :: enum u32 {
    Unknown :: 0;
    LittleEndian :: 1;
    BigEndian :: 2;
    CFByteOrderUnknown :: Unknown;
    CFByteOrderLittleEndian :: LittleEndian;
    CFByteOrderBigEndian :: BigEndian;
}

CFByteOrder :: CFIndex;

CFSwappedFloat32 :: struct {
    v: u32;
}

CFSwappedFloat64 :: struct {
    v: u64;
}

CFDictionaryRetainCallBack :: #type (allocator: CFAllocatorRef, value: *void) -> *void #c_call;
CFDictionaryReleaseCallBack :: #type (allocator: CFAllocatorRef, value: *void) -> void #c_call;
CFDictionaryCopyDescriptionCallBack :: #type (value: *void) -> CFStringRef #c_call;
CFDictionaryEqualCallBack :: #type (value1: *void, value2: *void) -> Boolean #c_call;
CFDictionaryHashCallBack :: #type (value: *void) -> CFHashCode #c_call;

CFDictionaryKeyCallBacks :: struct {
    version: CFIndex;
    retain: CFDictionaryRetainCallBack;
    release: CFDictionaryReleaseCallBack;
    copyDescription: CFDictionaryCopyDescriptionCallBack;
    equal: CFDictionaryEqualCallBack;
    hash: CFDictionaryHashCallBack;
}

kCFTypeDictionaryKeyCallBacks: CFDictionaryKeyCallBacks #elsewhere corefoundation;
kCFCopyStringDictionaryKeyCallBacks: CFDictionaryKeyCallBacks #elsewhere corefoundation;

CFDictionaryValueCallBacks :: struct {
    version: CFIndex;
    retain: CFDictionaryRetainCallBack;
    release: CFDictionaryReleaseCallBack;
    copyDescription: CFDictionaryCopyDescriptionCallBack;
    equal: CFDictionaryEqualCallBack;
}

kCFTypeDictionaryValueCallBacks: CFDictionaryValueCallBacks #elsewhere corefoundation;
CFDictionaryApplierFunction :: #type (key: *void, value: *void, _context: *void) -> void #c_call;
__CFDictionary :: struct {}
CFDictionaryRef :: *__CFDictionary;
CFMutableDictionaryRef :: *__CFDictionary;
CFDictionaryGetTypeID :: () -> CFTypeID #foreign corefoundation;
CFDictionaryCreate :: (allocator: CFAllocatorRef, keys: **void, values: **void, numValues: CFIndex, keyCallBacks: *CFDictionaryKeyCallBacks, valueCallBacks: *CFDictionaryValueCallBacks) -> CFDictionaryRef #foreign corefoundation;
CFDictionaryCreateCopy :: (allocator: CFAllocatorRef, theDict: CFDictionaryRef) -> CFDictionaryRef #foreign corefoundation;
CFDictionaryCreateMutable :: (allocator: CFAllocatorRef, capacity: CFIndex, keyCallBacks: *CFDictionaryKeyCallBacks, valueCallBacks: *CFDictionaryValueCallBacks) -> CFMutableDictionaryRef #foreign corefoundation;
CFDictionaryCreateMutableCopy :: (allocator: CFAllocatorRef, capacity: CFIndex, theDict: CFDictionaryRef) -> CFMutableDictionaryRef #foreign corefoundation;
CFDictionaryGetCount :: (theDict: CFDictionaryRef) -> CFIndex #foreign corefoundation;
CFDictionaryGetCountOfKey :: (theDict: CFDictionaryRef, key: *void) -> CFIndex #foreign corefoundation;
CFDictionaryGetCountOfValue :: (theDict: CFDictionaryRef, value: *void) -> CFIndex #foreign corefoundation;
CFDictionaryContainsKey :: (theDict: CFDictionaryRef, key: *void) -> Boolean #foreign corefoundation;
CFDictionaryContainsValue :: (theDict: CFDictionaryRef, value: *void) -> Boolean #foreign corefoundation;
CFDictionaryGetValue :: (theDict: CFDictionaryRef, key: *void) -> *void #foreign corefoundation;
CFDictionaryGetValueIfPresent :: (theDict: CFDictionaryRef, key: *void, value: **void) -> Boolean #foreign corefoundation;
CFDictionaryGetKeysAndValues :: (theDict: CFDictionaryRef, keys: **void, values: **void) -> void #foreign corefoundation;
CFDictionaryApplyFunction :: (theDict: CFDictionaryRef, applier: CFDictionaryApplierFunction, _context: *void) -> void #foreign corefoundation;
CFDictionaryAddValue :: (theDict: CFMutableDictionaryRef, key: *void, value: *void) -> void #foreign corefoundation;
CFDictionarySetValue :: (theDict: CFMutableDictionaryRef, key: *void, value: *void) -> void #foreign corefoundation;
CFDictionaryReplaceValue :: (theDict: CFMutableDictionaryRef, key: *void, value: *void) -> void #foreign corefoundation;
CFDictionaryRemoveValue :: (theDict: CFMutableDictionaryRef, key: *void) -> void #foreign corefoundation;
CFDictionaryRemoveAllValues :: (theDict: CFMutableDictionaryRef) -> void #foreign corefoundation;
CFNotificationName :: CFStringRef;
__CFNotificationCenter :: struct {}
CFNotificationCenterRef :: *__CFNotificationCenter;
CFNotificationCallback :: #type (center: CFNotificationCenterRef, observer: *void, name: CFNotificationName, object: *void, userInfo: CFDictionaryRef) -> void #c_call;

CFNotificationSuspensionBehavior :: enum CFIndex {
    Drop :: 1;
    Coalesce :: 2;
    Hold :: 3;
    DeliverImmediately :: 4;
    CFNotificationSuspensionBehaviorDrop :: Drop;
    CFNotificationSuspensionBehaviorCoalesce :: Coalesce;
    CFNotificationSuspensionBehaviorHold :: Hold;
    CFNotificationSuspensionBehaviorDeliverImmediately :: DeliverImmediately;
}

CFNotificationCenterGetTypeID :: () -> CFTypeID #foreign corefoundation;
CFNotificationCenterGetLocalCenter :: () -> CFNotificationCenterRef #foreign corefoundation;
CFNotificationCenterGetDistributedCenter :: () -> CFNotificationCenterRef #foreign corefoundation;
CFNotificationCenterGetDarwinNotifyCenter :: () -> CFNotificationCenterRef #foreign corefoundation;
CFNotificationCenterAddObserver :: (center: CFNotificationCenterRef, observer: *void, callBack: CFNotificationCallback, name: CFStringRef, object: *void, suspensionBehavior: CFNotificationSuspensionBehavior) -> void #foreign corefoundation;
CFNotificationCenterRemoveObserver :: (center: CFNotificationCenterRef, observer: *void, name: CFNotificationName, object: *void) -> void #foreign corefoundation;
CFNotificationCenterRemoveEveryObserver :: (center: CFNotificationCenterRef, observer: *void) -> void #foreign corefoundation;
CFNotificationCenterPostNotification :: (center: CFNotificationCenterRef, name: CFNotificationName, object: *void, userInfo: CFDictionaryRef, deliverImmediately: Boolean) -> void #foreign corefoundation;

kCFNotification :: enum u32 {
    DeliverImmediately :: 1;
    PostToAllSessions :: 2;
    kCFNotificationDeliverImmediately :: DeliverImmediately;
    kCFNotificationPostToAllSessions :: PostToAllSessions;
}

CFNotificationCenterPostNotificationWithOptions :: (center: CFNotificationCenterRef, name: CFNotificationName, object: *void, userInfo: CFDictionaryRef, options: CFOptionFlags) -> void #foreign corefoundation;
CFLocaleIdentifier :: CFStringRef;
CFLocaleKey :: CFStringRef;
__CFLocale :: struct {}
CFLocaleRef :: *__CFLocale;
CFLocaleGetTypeID :: () -> CFTypeID #foreign corefoundation;
CFLocaleGetSystem :: () -> CFLocaleRef #foreign corefoundation;
CFLocaleCopyCurrent :: () -> CFLocaleRef #foreign corefoundation;
CFLocaleCopyAvailableLocaleIdentifiers :: () -> CFArrayRef #foreign corefoundation;
CFLocaleCopyISOLanguageCodes :: () -> CFArrayRef #foreign corefoundation;
CFLocaleCopyISOCountryCodes :: () -> CFArrayRef #foreign corefoundation;
CFLocaleCopyISOCurrencyCodes :: () -> CFArrayRef #foreign corefoundation;
CFLocaleCopyCommonISOCurrencyCodes :: () -> CFArrayRef #foreign corefoundation;
CFLocaleCopyPreferredLanguages :: () -> CFArrayRef #foreign corefoundation;
CFLocaleCreateCanonicalLanguageIdentifierFromString :: (allocator: CFAllocatorRef, localeIdentifier: CFStringRef) -> CFLocaleIdentifier #foreign corefoundation;
CFLocaleCreateCanonicalLocaleIdentifierFromString :: (allocator: CFAllocatorRef, localeIdentifier: CFStringRef) -> CFLocaleIdentifier #foreign corefoundation;
CFLocaleCreateCanonicalLocaleIdentifierFromScriptManagerCodes :: (allocator: CFAllocatorRef, lcode: LangCode, rcode: RegionCode) -> CFLocaleIdentifier #foreign corefoundation;
CFLocaleCreateLocaleIdentifierFromWindowsLocaleCode :: (allocator: CFAllocatorRef, lcid: u32) -> CFLocaleIdentifier #foreign corefoundation;
CFLocaleGetWindowsLocaleCodeFromLocaleIdentifier :: (localeIdentifier: CFLocaleIdentifier) -> u32 #foreign corefoundation;

CFLocaleLanguageDirection :: enum CFIndex {
    Unknown :: 0;
    LeftToRight :: 1;
    RightToLeft :: 2;
    TopToBottom :: 3;
    BottomToTop :: 4;
    kCFLocaleLanguageDirectionUnknown :: Unknown;
    kCFLocaleLanguageDirectionLeftToRight :: LeftToRight;
    kCFLocaleLanguageDirectionRightToLeft :: RightToLeft;
    kCFLocaleLanguageDirectionTopToBottom :: TopToBottom;
    kCFLocaleLanguageDirectionBottomToTop :: BottomToTop;
}

CFLocaleGetLanguageCharacterDirection :: (isoLangCode: CFStringRef) -> CFLocaleLanguageDirection #foreign corefoundation;
CFLocaleGetLanguageLineDirection :: (isoLangCode: CFStringRef) -> CFLocaleLanguageDirection #foreign corefoundation;
CFLocaleCreateComponentsFromLocaleIdentifier :: (allocator: CFAllocatorRef, localeID: CFLocaleIdentifier) -> CFDictionaryRef #foreign corefoundation;
CFLocaleCreateLocaleIdentifierFromComponents :: (allocator: CFAllocatorRef, dictionary: CFDictionaryRef) -> CFLocaleIdentifier #foreign corefoundation;
CFLocaleCreate :: (allocator: CFAllocatorRef, localeIdentifier: CFLocaleIdentifier) -> CFLocaleRef #foreign corefoundation;
CFLocaleCreateCopy :: (allocator: CFAllocatorRef, locale: CFLocaleRef) -> CFLocaleRef #foreign corefoundation;
CFLocaleGetIdentifier :: (locale: CFLocaleRef) -> CFLocaleIdentifier #foreign corefoundation;
CFLocaleGetValue :: (locale: CFLocaleRef, key: CFLocaleKey) -> CFTypeRef #foreign corefoundation;
CFLocaleCopyDisplayNameForPropertyValue :: (displayLocale: CFLocaleRef, key: CFLocaleKey, value: CFStringRef) -> CFStringRef #foreign corefoundation;
kCFLocaleCurrentLocaleDidChangeNotification: CFNotificationName #elsewhere corefoundation;
kCFLocaleIdentifier: CFLocaleKey #elsewhere corefoundation;
kCFLocaleLanguageCode: CFLocaleKey #elsewhere corefoundation;
kCFLocaleCountryCode: CFLocaleKey #elsewhere corefoundation;
kCFLocaleScriptCode: CFLocaleKey #elsewhere corefoundation;
kCFLocaleVariantCode: CFLocaleKey #elsewhere corefoundation;
kCFLocaleExemplarCharacterSet: CFLocaleKey #elsewhere corefoundation;
kCFLocaleCalendarIdentifier: CFLocaleKey #elsewhere corefoundation;
kCFLocaleCalendar: CFLocaleKey #elsewhere corefoundation;
kCFLocaleCollationIdentifier: CFLocaleKey #elsewhere corefoundation;
kCFLocaleUsesMetricSystem: CFLocaleKey #elsewhere corefoundation;
kCFLocaleMeasurementSystem: CFLocaleKey #elsewhere corefoundation;
kCFLocaleDecimalSeparator: CFLocaleKey #elsewhere corefoundation;
kCFLocaleGroupingSeparator: CFLocaleKey #elsewhere corefoundation;
kCFLocaleCurrencySymbol: CFLocaleKey #elsewhere corefoundation;
kCFLocaleCurrencyCode: CFLocaleKey #elsewhere corefoundation;
kCFLocaleCollatorIdentifier: CFLocaleKey #elsewhere corefoundation;
kCFLocaleQuotationBeginDelimiterKey: CFLocaleKey #elsewhere corefoundation;
kCFLocaleQuotationEndDelimiterKey: CFLocaleKey #elsewhere corefoundation;
kCFLocaleAlternateQuotationBeginDelimiterKey: CFLocaleKey #elsewhere corefoundation;
kCFLocaleAlternateQuotationEndDelimiterKey: CFLocaleKey #elsewhere corefoundation;
CFCalendarIdentifier :: CFStringRef;
kCFGregorianCalendar: CFCalendarIdentifier #elsewhere corefoundation;
kCFBuddhistCalendar: CFCalendarIdentifier #elsewhere corefoundation;
kCFChineseCalendar: CFCalendarIdentifier #elsewhere corefoundation;
kCFHebrewCalendar: CFCalendarIdentifier #elsewhere corefoundation;
kCFIslamicCalendar: CFCalendarIdentifier #elsewhere corefoundation;
kCFIslamicCivilCalendar: CFCalendarIdentifier #elsewhere corefoundation;
kCFJapaneseCalendar: CFCalendarIdentifier #elsewhere corefoundation;
kCFRepublicOfChinaCalendar: CFCalendarIdentifier #elsewhere corefoundation;
kCFPersianCalendar: CFCalendarIdentifier #elsewhere corefoundation;
kCFIndianCalendar: CFCalendarIdentifier #elsewhere corefoundation;
kCFISO8601Calendar: CFCalendarIdentifier #elsewhere corefoundation;
kCFIslamicTabularCalendar: CFCalendarIdentifier #elsewhere corefoundation;
kCFIslamicUmmAlQuraCalendar: CFCalendarIdentifier #elsewhere corefoundation;
CFTimeInterval :: float64;
CFAbsoluteTime :: CFTimeInterval;
CFAbsoluteTimeGetCurrent :: () -> CFAbsoluteTime #foreign corefoundation;
kCFAbsoluteTimeIntervalSince1970: CFTimeInterval #elsewhere corefoundation;
kCFAbsoluteTimeIntervalSince1904: CFTimeInterval #elsewhere corefoundation;
__CFDate :: struct {}
CFDateRef :: *__CFDate;
CFDateGetTypeID :: () -> CFTypeID #foreign corefoundation;
CFDateCreate :: (allocator: CFAllocatorRef, at: CFAbsoluteTime) -> CFDateRef #foreign corefoundation;
CFDateGetAbsoluteTime :: (theDate: CFDateRef) -> CFAbsoluteTime #foreign corefoundation;
CFDateGetTimeIntervalSinceDate :: (theDate: CFDateRef, otherDate: CFDateRef) -> CFTimeInterval #foreign corefoundation;
CFDateCompare :: (theDate: CFDateRef, otherDate: CFDateRef, _context: *void) -> CFComparisonResult #foreign corefoundation;
__CFTimeZone :: struct {}
CFTimeZoneRef :: *__CFTimeZone;

CFGregorianDate :: struct {
    year: s32;
    month: s8;
    day: s8;
    hour: s8;
    minute: s8;
    second: float64;
}

CFGregorianUnits :: struct {
    years: s32;
    months: s32;
    days: s32;
    hours: s32;
    minutes: s32;
    seconds: float64;
}

CFGregorianUnitFlags :: CFOptionFlags;

kCFGregorian :: enum u32 {
    UnitsYears :: 1;
    UnitsMonths :: 2;
    UnitsDays :: 4;
    UnitsHours :: 8;
    UnitsMinutes :: 16;
    UnitsSeconds :: 32;
    AllUnits :: 16777215;
    kCFGregorianUnitsYears :: UnitsYears;
    kCFGregorianUnitsMonths :: UnitsMonths;
    kCFGregorianUnitsDays :: UnitsDays;
    kCFGregorianUnitsHours :: UnitsHours;
    kCFGregorianUnitsMinutes :: UnitsMinutes;
    kCFGregorianUnitsSeconds :: UnitsSeconds;
    kCFGregorianAllUnits :: AllUnits;
}

CFGregorianDateIsValid :: (gdate: CFGregorianDate, unitFlags: CFOptionFlags) -> Boolean #foreign corefoundation;
CFGregorianDateGetAbsoluteTime :: (gdate: CFGregorianDate, tz: CFTimeZoneRef) -> CFAbsoluteTime #foreign corefoundation;
CFAbsoluteTimeGetGregorianDate :: (at: CFAbsoluteTime, tz: CFTimeZoneRef) -> CFGregorianDate #foreign corefoundation;
CFAbsoluteTimeAddGregorianUnits :: (at: CFAbsoluteTime, tz: CFTimeZoneRef, units: CFGregorianUnits) -> CFAbsoluteTime #foreign corefoundation;
CFAbsoluteTimeGetDifferenceAsGregorianUnits :: (at1: CFAbsoluteTime, at2: CFAbsoluteTime, tz: CFTimeZoneRef, unitFlags: CFOptionFlags) -> CFGregorianUnits #foreign corefoundation;
CFAbsoluteTimeGetDayOfWeek :: (at: CFAbsoluteTime, tz: CFTimeZoneRef) -> s32 #foreign corefoundation;
CFAbsoluteTimeGetDayOfYear :: (at: CFAbsoluteTime, tz: CFTimeZoneRef) -> s32 #foreign corefoundation;
CFAbsoluteTimeGetWeekOfYear :: (at: CFAbsoluteTime, tz: CFTimeZoneRef) -> s32 #foreign corefoundation;
__CFData :: struct {}
CFDataRef :: *__CFData;
CFMutableDataRef :: *__CFData;
CFDataGetTypeID :: () -> CFTypeID #foreign corefoundation;
CFDataCreate :: (allocator: CFAllocatorRef, bytes: *u8, length: CFIndex) -> CFDataRef #foreign corefoundation;
CFDataCreateWithBytesNoCopy :: (allocator: CFAllocatorRef, bytes: *u8, length: CFIndex, bytesDeallocator: CFAllocatorRef) -> CFDataRef #foreign corefoundation;
CFDataCreateCopy :: (allocator: CFAllocatorRef, theData: CFDataRef) -> CFDataRef #foreign corefoundation;
CFDataCreateMutable :: (allocator: CFAllocatorRef, capacity: CFIndex) -> CFMutableDataRef #foreign corefoundation;
CFDataCreateMutableCopy :: (allocator: CFAllocatorRef, capacity: CFIndex, theData: CFDataRef) -> CFMutableDataRef #foreign corefoundation;
CFDataGetLength :: (theData: CFDataRef) -> CFIndex #foreign corefoundation;
CFDataGetBytePtr :: (theData: CFDataRef) -> *u8 #foreign corefoundation;
CFDataGetMutableBytePtr :: (theData: CFMutableDataRef) -> *u8 #foreign corefoundation;
CFDataGetBytes :: (theData: CFDataRef, range: CFRange, buffer: *u8) -> void #foreign corefoundation;
CFDataSetLength :: (theData: CFMutableDataRef, length: CFIndex) -> void #foreign corefoundation;
CFDataIncreaseLength :: (theData: CFMutableDataRef, extraLength: CFIndex) -> void #foreign corefoundation;
CFDataAppendBytes :: (theData: CFMutableDataRef, bytes: *u8, length: CFIndex) -> void #foreign corefoundation;
CFDataReplaceBytes :: (theData: CFMutableDataRef, range: CFRange, newBytes: *u8, newLength: CFIndex) -> void #foreign corefoundation;
CFDataDeleteBytes :: (theData: CFMutableDataRef, range: CFRange) -> void #foreign corefoundation;

CFDataSearchFlags :: enum_flags CFOptionFlags {
    Backwards :: 0x1;
    Anchored :: 0x2;
    kCFDataSearchBackwards :: Backwards;
    kCFDataSearchAnchored :: Anchored;
}

CFDataFind :: (theData: CFDataRef, dataToFind: CFDataRef, searchRange: CFRange, compareOptions: CFDataSearchFlags) -> CFRange #foreign corefoundation;
__CFCharacterSet :: struct {}
CFCharacterSetRef :: *__CFCharacterSet;
CFMutableCharacterSetRef :: *__CFCharacterSet;

CFCharacterSetPredefinedSet :: enum CFIndex {
    Control :: 1;
    Whitespace :: 2;
    WhitespaceAndNewline :: 3;
    DecimalDigit :: 4;
    Letter :: 5;
    LowercaseLetter :: 6;
    UppercaseLetter :: 7;
    NonBase :: 8;
    Decomposable :: 9;
    AlphaNumeric :: 10;
    Punctuation :: 11;
    CapitalizedLetter :: 13;
    Symbol :: 14;
    Newline :: 15;
    Illegal :: 12;
    kCFCharacterSetControl :: Control;
    kCFCharacterSetWhitespace :: Whitespace;
    kCFCharacterSetWhitespaceAndNewline :: WhitespaceAndNewline;
    kCFCharacterSetDecimalDigit :: DecimalDigit;
    kCFCharacterSetLetter :: Letter;
    kCFCharacterSetLowercaseLetter :: LowercaseLetter;
    kCFCharacterSetUppercaseLetter :: UppercaseLetter;
    kCFCharacterSetNonBase :: NonBase;
    kCFCharacterSetDecomposable :: Decomposable;
    kCFCharacterSetAlphaNumeric :: AlphaNumeric;
    kCFCharacterSetPunctuation :: Punctuation;
    kCFCharacterSetCapitalizedLetter :: CapitalizedLetter;
    kCFCharacterSetSymbol :: Symbol;
    kCFCharacterSetNewline :: Newline;
    kCFCharacterSetIllegal :: Illegal;
}

CFCharacterSetGetTypeID :: () -> CFTypeID #foreign corefoundation;
CFCharacterSetGetPredefined :: (theSetIdentifier: CFCharacterSetPredefinedSet) -> CFCharacterSetRef #foreign corefoundation;
CFCharacterSetCreateWithCharactersInRange :: (alloc: CFAllocatorRef, theRange: CFRange) -> CFCharacterSetRef #foreign corefoundation;
CFCharacterSetCreateWithCharactersInString :: (alloc: CFAllocatorRef, theString: CFStringRef) -> CFCharacterSetRef #foreign corefoundation;
CFCharacterSetCreateWithBitmapRepresentation :: (alloc: CFAllocatorRef, theData: CFDataRef) -> CFCharacterSetRef #foreign corefoundation;
CFCharacterSetCreateInvertedSet :: (alloc: CFAllocatorRef, theSet: CFCharacterSetRef) -> CFCharacterSetRef #foreign corefoundation;
CFCharacterSetIsSupersetOfSet :: (theSet: CFCharacterSetRef, theOtherset: CFCharacterSetRef) -> Boolean #foreign corefoundation;
CFCharacterSetHasMemberInPlane :: (theSet: CFCharacterSetRef, thePlane: CFIndex) -> Boolean #foreign corefoundation;
CFCharacterSetCreateMutable :: (alloc: CFAllocatorRef) -> CFMutableCharacterSetRef #foreign corefoundation;
CFCharacterSetCreateCopy :: (alloc: CFAllocatorRef, theSet: CFCharacterSetRef) -> CFCharacterSetRef #foreign corefoundation;
CFCharacterSetCreateMutableCopy :: (alloc: CFAllocatorRef, theSet: CFCharacterSetRef) -> CFMutableCharacterSetRef #foreign corefoundation;
CFCharacterSetIsCharacterMember :: (theSet: CFCharacterSetRef, theChar: u16) -> Boolean #foreign corefoundation;
CFCharacterSetIsLongCharacterMember :: (theSet: CFCharacterSetRef, theChar: UTF32Char) -> Boolean #foreign corefoundation;
CFCharacterSetCreateBitmapRepresentation :: (alloc: CFAllocatorRef, theSet: CFCharacterSetRef) -> CFDataRef #foreign corefoundation;
CFCharacterSetAddCharactersInRange :: (theSet: CFMutableCharacterSetRef, theRange: CFRange) -> void #foreign corefoundation;
CFCharacterSetRemoveCharactersInRange :: (theSet: CFMutableCharacterSetRef, theRange: CFRange) -> void #foreign corefoundation;
CFCharacterSetAddCharactersInString :: (theSet: CFMutableCharacterSetRef, theString: CFStringRef) -> void #foreign corefoundation;
CFCharacterSetRemoveCharactersInString :: (theSet: CFMutableCharacterSetRef, theString: CFStringRef) -> void #foreign corefoundation;
CFCharacterSetUnion :: (theSet: CFMutableCharacterSetRef, theOtherSet: CFCharacterSetRef) -> void #foreign corefoundation;
CFCharacterSetIntersect :: (theSet: CFMutableCharacterSetRef, theOtherSet: CFCharacterSetRef) -> void #foreign corefoundation;
CFCharacterSetInvert :: (theSet: CFMutableCharacterSetRef) -> void #foreign corefoundation;
CFStringBuiltInEncodings :: CFStringEncoding;

CFStringEncoding :: enum u32 {
    MacRoman :: 0;
    WindowsLatin1 :: 1280;
    ISOLatin1 :: 513;
    NextStepLatin :: 2817;
    ASCII :: 1536;
    Unicode :: 256;
    UTF8 :: 134217984;
    NonLossyASCII :: 3071;
    UTF16 :: 256;
    UTF16BE :: 268435712;
    UTF16LE :: 335544576;
    UTF32 :: 201326848;
    UTF32BE :: 402653440;
    UTF32LE :: 469762304;
    kCFStringEncodingMacRoman :: MacRoman;
    kCFStringEncodingWindowsLatin1 :: WindowsLatin1;
    kCFStringEncodingISOLatin1 :: ISOLatin1;
    kCFStringEncodingNextStepLatin :: NextStepLatin;
    kCFStringEncodingASCII :: ASCII;
    kCFStringEncodingUnicode :: Unicode;
    kCFStringEncodingUTF8 :: UTF8;
    kCFStringEncodingNonLossyASCII :: NonLossyASCII;
    kCFStringEncodingUTF16 :: UTF16;
    kCFStringEncodingUTF16BE :: UTF16BE;
    kCFStringEncodingUTF16LE :: UTF16LE;
    kCFStringEncodingUTF32 :: UTF32;
    kCFStringEncodingUTF32BE :: UTF32BE;
    kCFStringEncodingUTF32LE :: UTF32LE;
}

CFStringGetTypeID :: () -> CFTypeID #foreign corefoundation;
CFStringCreateWithPascalString :: (alloc: CFAllocatorRef, pStr: ConstStr255Param, encoding: CFStringEncoding) -> CFStringRef #foreign corefoundation;
CFStringCreateWithCString :: (alloc: CFAllocatorRef, cStr: *u8, encoding: CFStringEncoding) -> CFStringRef #foreign corefoundation;
CFStringCreateWithBytes :: (alloc: CFAllocatorRef, bytes: *u8, numBytes: CFIndex, encoding: CFStringEncoding, isExternalRepresentation: Boolean) -> CFStringRef #foreign corefoundation;
CFStringCreateWithCharacters :: (alloc: CFAllocatorRef, chars: *u16, numChars: CFIndex) -> CFStringRef #foreign corefoundation;
CFStringCreateWithPascalStringNoCopy :: (alloc: CFAllocatorRef, pStr: ConstStr255Param, encoding: CFStringEncoding, contentsDeallocator: CFAllocatorRef) -> CFStringRef #foreign corefoundation;
CFStringCreateWithCStringNoCopy :: (alloc: CFAllocatorRef, cStr: *u8, encoding: CFStringEncoding, contentsDeallocator: CFAllocatorRef) -> CFStringRef #foreign corefoundation;
CFStringCreateWithBytesNoCopy :: (alloc: CFAllocatorRef, bytes: *u8, numBytes: CFIndex, encoding: CFStringEncoding, isExternalRepresentation: Boolean, contentsDeallocator: CFAllocatorRef) -> CFStringRef #foreign corefoundation;
CFStringCreateWithCharactersNoCopy :: (alloc: CFAllocatorRef, chars: *u16, numChars: CFIndex, contentsDeallocator: CFAllocatorRef) -> CFStringRef #foreign corefoundation;
CFStringCreateWithSubstring :: (alloc: CFAllocatorRef, str: CFStringRef, range: CFRange) -> CFStringRef #foreign corefoundation;
CFStringCreateCopy :: (alloc: CFAllocatorRef, theString: CFStringRef) -> CFStringRef #foreign corefoundation;
CFStringCreateWithFormat :: (alloc: CFAllocatorRef, formatOptions: CFDictionaryRef, format: CFStringRef, __args: ..Any) -> CFStringRef #foreign corefoundation;
CFStringCreateMutable :: (alloc: CFAllocatorRef, maxLength: CFIndex) -> CFMutableStringRef #foreign corefoundation;
CFStringCreateMutableCopy :: (alloc: CFAllocatorRef, maxLength: CFIndex, theString: CFStringRef) -> CFMutableStringRef #foreign corefoundation;
CFStringCreateMutableWithExternalCharactersNoCopy :: (alloc: CFAllocatorRef, chars: *u16, numChars: CFIndex, capacity: CFIndex, externalCharactersAllocator: CFAllocatorRef) -> CFMutableStringRef #foreign corefoundation;
CFStringGetLength :: (theString: CFStringRef) -> CFIndex #foreign corefoundation;
CFStringGetCharacterAtIndex :: (theString: CFStringRef, idx: CFIndex) -> u16 #foreign corefoundation;
CFStringGetCharacters :: (theString: CFStringRef, range: CFRange, buffer: *u16) -> void #foreign corefoundation;
CFStringGetPascalString :: (theString: CFStringRef, buffer: StringPtr, bufferSize: CFIndex, encoding: CFStringEncoding) -> Boolean #foreign corefoundation;
CFStringGetCString :: (theString: CFStringRef, buffer: *u8, bufferSize: CFIndex, encoding: CFStringEncoding) -> Boolean #foreign corefoundation;
CFStringGetPascalStringPtr :: (theString: CFStringRef, encoding: CFStringEncoding) -> ConstStringPtr #foreign corefoundation;
CFStringGetCStringPtr :: (theString: CFStringRef, encoding: CFStringEncoding) -> *u8 #foreign corefoundation;
CFStringGetCharactersPtr :: (theString: CFStringRef) -> *u16 #foreign corefoundation;
CFStringGetBytes :: (theString: CFStringRef, range: CFRange, encoding: CFStringEncoding, lossByte: u8, isExternalRepresentation: Boolean, buffer: *u8, maxBufLen: CFIndex, usedBufLen: *CFIndex) -> CFIndex #foreign corefoundation;
CFStringCreateFromExternalRepresentation :: (alloc: CFAllocatorRef, data: CFDataRef, encoding: CFStringEncoding) -> CFStringRef #foreign corefoundation;
CFStringCreateExternalRepresentation :: (alloc: CFAllocatorRef, theString: CFStringRef, encoding: CFStringEncoding, lossByte: u8) -> CFDataRef #foreign corefoundation;
CFStringGetSmallestEncoding :: (theString: CFStringRef) -> CFStringEncoding #foreign corefoundation;
CFStringGetFastestEncoding :: (theString: CFStringRef) -> CFStringEncoding #foreign corefoundation;
CFStringGetSystemEncoding :: () -> CFStringEncoding #foreign corefoundation;
CFStringGetMaximumSizeForEncoding :: (length: CFIndex, encoding: CFStringEncoding) -> CFIndex #foreign corefoundation;
CFStringGetFileSystemRepresentation :: (_string: CFStringRef, buffer: *u8, maxBufLen: CFIndex) -> Boolean #foreign corefoundation;
CFStringGetMaximumSizeOfFileSystemRepresentation :: (_string: CFStringRef) -> CFIndex #foreign corefoundation;
CFStringCreateWithFileSystemRepresentation :: (alloc: CFAllocatorRef, buffer: *u8) -> CFStringRef #foreign corefoundation;

CFStringCompareFlags :: enum_flags CFOptionFlags {
    CaseInsensitive :: 0x1;
    Backwards :: 0x4;
    Anchored :: 0x8;
    Nonliteral :: 0x10;
    Localized :: 0x20;
    Numerically :: 0x40;
    DiacriticInsensitive :: 0x80;
    WidthInsensitive :: 0x100;
    ForcedOrdering :: 0x200;
    kCFCompareCaseInsensitive :: CaseInsensitive;
    kCFCompareBackwards :: Backwards;
    kCFCompareAnchored :: Anchored;
    kCFCompareNonliteral :: Nonliteral;
    kCFCompareLocalized :: Localized;
    kCFCompareNumerically :: Numerically;
    kCFCompareDiacriticInsensitive :: DiacriticInsensitive;
    kCFCompareWidthInsensitive :: WidthInsensitive;
    kCFCompareForcedOrdering :: ForcedOrdering;
}

CFStringCompareWithOptionsAndLocale :: (theString1: CFStringRef, theString2: CFStringRef, rangeToCompare: CFRange, compareOptions: CFStringCompareFlags, locale: CFLocaleRef) -> CFComparisonResult #foreign corefoundation;
CFStringCompareWithOptions :: (theString1: CFStringRef, theString2: CFStringRef, rangeToCompare: CFRange, compareOptions: CFStringCompareFlags) -> CFComparisonResult #foreign corefoundation;
CFStringCompare :: (theString1: CFStringRef, theString2: CFStringRef, compareOptions: CFStringCompareFlags) -> CFComparisonResult #foreign corefoundation;
CFStringFindWithOptionsAndLocale :: (theString: CFStringRef, stringToFind: CFStringRef, rangeToSearch: CFRange, searchOptions: CFStringCompareFlags, locale: CFLocaleRef, result: *CFRange) -> Boolean #foreign corefoundation;
CFStringFindWithOptions :: (theString: CFStringRef, stringToFind: CFStringRef, rangeToSearch: CFRange, searchOptions: CFStringCompareFlags, result: *CFRange) -> Boolean #foreign corefoundation;
CFStringCreateArrayWithFindResults :: (alloc: CFAllocatorRef, theString: CFStringRef, stringToFind: CFStringRef, rangeToSearch: CFRange, compareOptions: CFStringCompareFlags) -> CFArrayRef #foreign corefoundation;
CFStringFind :: (theString: CFStringRef, stringToFind: CFStringRef, compareOptions: CFStringCompareFlags) -> CFRange #foreign corefoundation;
CFStringHasPrefix :: (theString: CFStringRef, prefix: CFStringRef) -> Boolean #foreign corefoundation;
CFStringHasSuffix :: (theString: CFStringRef, suffix: CFStringRef) -> Boolean #foreign corefoundation;
CFStringGetRangeOfComposedCharactersAtIndex :: (theString: CFStringRef, theIndex: CFIndex) -> CFRange #foreign corefoundation;
CFStringFindCharacterFromSet :: (theString: CFStringRef, theSet: CFCharacterSetRef, rangeToSearch: CFRange, searchOptions: CFStringCompareFlags, result: *CFRange) -> Boolean #foreign corefoundation;
CFStringGetLineBounds :: (theString: CFStringRef, range: CFRange, lineBeginIndex: *CFIndex, lineEndIndex: *CFIndex, contentsEndIndex: *CFIndex) -> void #foreign corefoundation;
CFStringGetParagraphBounds :: (_string: CFStringRef, range: CFRange, parBeginIndex: *CFIndex, parEndIndex: *CFIndex, contentsEndIndex: *CFIndex) -> void #foreign corefoundation;
CFStringGetHyphenationLocationBeforeIndex :: (_string: CFStringRef, location: CFIndex, limitRange: CFRange, options: CFOptionFlags, locale: CFLocaleRef, character: *UTF32Char) -> CFIndex #foreign corefoundation;
CFStringIsHyphenationAvailableForLocale :: (locale: CFLocaleRef) -> Boolean #foreign corefoundation;
CFStringCreateByCombiningStrings :: (alloc: CFAllocatorRef, theArray: CFArrayRef, separatorString: CFStringRef) -> CFStringRef #foreign corefoundation;
CFStringCreateArrayBySeparatingStrings :: (alloc: CFAllocatorRef, theString: CFStringRef, separatorString: CFStringRef) -> CFArrayRef #foreign corefoundation;
CFStringGetIntValue :: (str: CFStringRef) -> s32 #foreign corefoundation;
CFStringGetDoubleValue :: (str: CFStringRef) -> float64 #foreign corefoundation;
CFStringAppend :: (theString: CFMutableStringRef, appendedString: CFStringRef) -> void #foreign corefoundation;
CFStringAppendCharacters :: (theString: CFMutableStringRef, chars: *u16, numChars: CFIndex) -> void #foreign corefoundation;
CFStringAppendPascalString :: (theString: CFMutableStringRef, pStr: ConstStr255Param, encoding: CFStringEncoding) -> void #foreign corefoundation;
CFStringAppendCString :: (theString: CFMutableStringRef, cStr: *u8, encoding: CFStringEncoding) -> void #foreign corefoundation;
CFStringAppendFormat :: (theString: CFMutableStringRef, formatOptions: CFDictionaryRef, format: CFStringRef, __args: ..Any) -> void #foreign corefoundation;
CFStringInsert :: (str: CFMutableStringRef, idx: CFIndex, insertedStr: CFStringRef) -> void #foreign corefoundation;
CFStringDelete :: (theString: CFMutableStringRef, range: CFRange) -> void #foreign corefoundation;
CFStringReplace :: (theString: CFMutableStringRef, range: CFRange, replacement: CFStringRef) -> void #foreign corefoundation;
CFStringReplaceAll :: (theString: CFMutableStringRef, replacement: CFStringRef) -> void #foreign corefoundation;
CFStringFindAndReplace :: (theString: CFMutableStringRef, stringToFind: CFStringRef, replacementString: CFStringRef, rangeToSearch: CFRange, compareOptions: CFStringCompareFlags) -> CFIndex #foreign corefoundation;
CFStringSetExternalCharactersNoCopy :: (theString: CFMutableStringRef, chars: *u16, length: CFIndex, capacity: CFIndex) -> void #foreign corefoundation;
CFStringPad :: (theString: CFMutableStringRef, padString: CFStringRef, length: CFIndex, indexIntoPad: CFIndex) -> void #foreign corefoundation;
CFStringTrim :: (theString: CFMutableStringRef, trimString: CFStringRef) -> void #foreign corefoundation;
CFStringTrimWhitespace :: (theString: CFMutableStringRef) -> void #foreign corefoundation;
CFStringLowercase :: (theString: CFMutableStringRef, locale: CFLocaleRef) -> void #foreign corefoundation;
CFStringUppercase :: (theString: CFMutableStringRef, locale: CFLocaleRef) -> void #foreign corefoundation;
CFStringCapitalize :: (theString: CFMutableStringRef, locale: CFLocaleRef) -> void #foreign corefoundation;

CFStringNormalizationForm :: enum CFIndex {
    D :: 0;
    KD :: 1;
    C :: 2;
    KC :: 3;
    kCFStringNormalizationFormD :: D;
    kCFStringNormalizationFormKD :: KD;
    kCFStringNormalizationFormC :: C;
    kCFStringNormalizationFormKC :: KC;
}

CFStringNormalize :: (theString: CFMutableStringRef, theForm: CFStringNormalizationForm) -> void #foreign corefoundation;
CFStringFold :: (theString: CFMutableStringRef, theFlags: CFStringCompareFlags, theLocale: CFLocaleRef) -> void #foreign corefoundation;
CFStringTransform :: (_string: CFMutableStringRef, range: *CFRange, transform: CFStringRef, reverse: Boolean) -> Boolean #foreign corefoundation;
kCFStringTransformStripCombiningMarks: CFStringRef #elsewhere corefoundation;
kCFStringTransformToLatin: CFStringRef #elsewhere corefoundation;
kCFStringTransformFullwidthHalfwidth: CFStringRef #elsewhere corefoundation;
kCFStringTransformLatinKatakana: CFStringRef #elsewhere corefoundation;
kCFStringTransformLatinHiragana: CFStringRef #elsewhere corefoundation;
kCFStringTransformHiraganaKatakana: CFStringRef #elsewhere corefoundation;
kCFStringTransformMandarinLatin: CFStringRef #elsewhere corefoundation;
kCFStringTransformLatinHangul: CFStringRef #elsewhere corefoundation;
kCFStringTransformLatinArabic: CFStringRef #elsewhere corefoundation;
kCFStringTransformLatinHebrew: CFStringRef #elsewhere corefoundation;
kCFStringTransformLatinThai: CFStringRef #elsewhere corefoundation;
kCFStringTransformLatinCyrillic: CFStringRef #elsewhere corefoundation;
kCFStringTransformLatinGreek: CFStringRef #elsewhere corefoundation;
kCFStringTransformToXMLHex: CFStringRef #elsewhere corefoundation;
kCFStringTransformToUnicodeName: CFStringRef #elsewhere corefoundation;
kCFStringTransformStripDiacritics: CFStringRef #elsewhere corefoundation;
CFStringIsEncodingAvailable :: (encoding: CFStringEncoding) -> Boolean #foreign corefoundation;
CFStringGetListOfAvailableEncodings :: () -> *CFStringEncoding #foreign corefoundation;
CFStringGetNameOfEncoding :: (encoding: CFStringEncoding) -> CFStringRef #foreign corefoundation;
CFStringConvertEncodingToNSStringEncoding :: (encoding: CFStringEncoding) -> u64 #foreign corefoundation;
CFStringConvertNSStringEncodingToEncoding :: (encoding: u64) -> CFStringEncoding #foreign corefoundation;
CFStringConvertEncodingToWindowsCodepage :: (encoding: CFStringEncoding) -> u32 #foreign corefoundation;
CFStringConvertWindowsCodepageToEncoding :: (codepage: u32) -> CFStringEncoding #foreign corefoundation;
CFStringConvertIANACharSetNameToEncoding :: (theString: CFStringRef) -> CFStringEncoding #foreign corefoundation;
CFStringConvertEncodingToIANACharSetName :: (encoding: CFStringEncoding) -> CFStringRef #foreign corefoundation;
CFStringGetMostCompatibleMacStringEncoding :: (encoding: CFStringEncoding) -> CFStringEncoding #foreign corefoundation;

CFStringInlineBuffer :: struct {
    buffer: [64] u16;
    theString: CFStringRef;
    directUniCharBuffer: *u16;
    directCStringBuffer: *u8;
    rangeToBuffer: CFRange;
    bufferedRangeStart: CFIndex;
    bufferedRangeEnd: CFIndex;
}

CFShow :: (obj: CFTypeRef) -> void #foreign corefoundation;
CFShowStr :: (str: CFStringRef) -> void #foreign corefoundation;
__CFStringMakeConstantString :: (cStr: *u8) -> CFStringRef #foreign corefoundation;
CFTimeZoneGetTypeID :: () -> CFTypeID #foreign corefoundation;
CFTimeZoneCopySystem :: () -> CFTimeZoneRef #foreign corefoundation;
CFTimeZoneResetSystem :: () -> void #foreign corefoundation;
CFTimeZoneCopyDefault :: () -> CFTimeZoneRef #foreign corefoundation;
CFTimeZoneSetDefault :: (tz: CFTimeZoneRef) -> void #foreign corefoundation;
CFTimeZoneCopyKnownNames :: () -> CFArrayRef #foreign corefoundation;
CFTimeZoneCopyAbbreviationDictionary :: () -> CFDictionaryRef #foreign corefoundation;
CFTimeZoneSetAbbreviationDictionary :: (dict: CFDictionaryRef) -> void #foreign corefoundation;
CFTimeZoneCreate :: (allocator: CFAllocatorRef, name: CFStringRef, data: CFDataRef) -> CFTimeZoneRef #foreign corefoundation;
CFTimeZoneCreateWithTimeIntervalFromGMT :: (allocator: CFAllocatorRef, ti: CFTimeInterval) -> CFTimeZoneRef #foreign corefoundation;
CFTimeZoneCreateWithName :: (allocator: CFAllocatorRef, name: CFStringRef, tryAbbrev: Boolean) -> CFTimeZoneRef #foreign corefoundation;
CFTimeZoneGetName :: (tz: CFTimeZoneRef) -> CFStringRef #foreign corefoundation;
CFTimeZoneGetData :: (tz: CFTimeZoneRef) -> CFDataRef #foreign corefoundation;
CFTimeZoneGetSecondsFromGMT :: (tz: CFTimeZoneRef, at: CFAbsoluteTime) -> CFTimeInterval #foreign corefoundation;
CFTimeZoneCopyAbbreviation :: (tz: CFTimeZoneRef, at: CFAbsoluteTime) -> CFStringRef #foreign corefoundation;
CFTimeZoneIsDaylightSavingTime :: (tz: CFTimeZoneRef, at: CFAbsoluteTime) -> Boolean #foreign corefoundation;
CFTimeZoneGetDaylightSavingTimeOffset :: (tz: CFTimeZoneRef, at: CFAbsoluteTime) -> CFTimeInterval #foreign corefoundation;
CFTimeZoneGetNextDaylightSavingTimeTransition :: (tz: CFTimeZoneRef, at: CFAbsoluteTime) -> CFAbsoluteTime #foreign corefoundation;

CFTimeZoneNameStyle :: enum CFIndex {
    Standard :: 0;
    ShortStandard :: 1;
    DaylightSaving :: 2;
    ShortDaylightSaving :: 3;
    Generic :: 4;
    ShortGeneric :: 5;
    kCFTimeZoneNameStyleStandard :: Standard;
    kCFTimeZoneNameStyleShortStandard :: ShortStandard;
    kCFTimeZoneNameStyleDaylightSaving :: DaylightSaving;
    kCFTimeZoneNameStyleShortDaylightSaving :: ShortDaylightSaving;
    kCFTimeZoneNameStyleGeneric :: Generic;
    kCFTimeZoneNameStyleShortGeneric :: ShortGeneric;
}

CFTimeZoneCopyLocalizedName :: (tz: CFTimeZoneRef, style: CFTimeZoneNameStyle, locale: CFLocaleRef) -> CFStringRef #foreign corefoundation;
kCFTimeZoneSystemTimeZoneDidChangeNotification: CFNotificationName #elsewhere corefoundation;
__CFCalendar :: struct {}
CFCalendarRef :: *__CFCalendar;
CFCalendarGetTypeID :: () -> CFTypeID #foreign corefoundation;
CFCalendarCopyCurrent :: () -> CFCalendarRef #foreign corefoundation;
CFCalendarCreateWithIdentifier :: (allocator: CFAllocatorRef, identifier: CFCalendarIdentifier) -> CFCalendarRef #foreign corefoundation;
CFCalendarGetIdentifier :: (calendar: CFCalendarRef) -> CFCalendarIdentifier #foreign corefoundation;
CFCalendarCopyLocale :: (calendar: CFCalendarRef) -> CFLocaleRef #foreign corefoundation;
CFCalendarSetLocale :: (calendar: CFCalendarRef, locale: CFLocaleRef) -> void #foreign corefoundation;
CFCalendarCopyTimeZone :: (calendar: CFCalendarRef) -> CFTimeZoneRef #foreign corefoundation;
CFCalendarSetTimeZone :: (calendar: CFCalendarRef, tz: CFTimeZoneRef) -> void #foreign corefoundation;
CFCalendarGetFirstWeekday :: (calendar: CFCalendarRef) -> CFIndex #foreign corefoundation;
CFCalendarSetFirstWeekday :: (calendar: CFCalendarRef, wkdy: CFIndex) -> void #foreign corefoundation;
CFCalendarGetMinimumDaysInFirstWeek :: (calendar: CFCalendarRef) -> CFIndex #foreign corefoundation;
CFCalendarSetMinimumDaysInFirstWeek :: (calendar: CFCalendarRef, mwd: CFIndex) -> void #foreign corefoundation;

CFCalendarUnit :: enum CFOptionFlags {
    Era :: 2;
    Year :: 4;
    Month :: 8;
    Day :: 16;
    Hour :: 32;
    Minute :: 64;
    Second :: 128;
    Week :: 256;
    Weekday :: 512;
    WeekdayOrdinal :: 1024;
    Quarter :: 2048;
    WeekOfMonth :: 4096;
    WeekOfYear :: 8192;
    YearForWeekOfYear :: 16384;
    kCFCalendarUnitEra :: Era;
    kCFCalendarUnitYear :: Year;
    kCFCalendarUnitMonth :: Month;
    kCFCalendarUnitDay :: Day;
    kCFCalendarUnitHour :: Hour;
    kCFCalendarUnitMinute :: Minute;
    kCFCalendarUnitSecond :: Second;
    kCFCalendarUnitWeek :: Week;
    kCFCalendarUnitWeekday :: Weekday;
    kCFCalendarUnitWeekdayOrdinal :: WeekdayOrdinal;
    kCFCalendarUnitQuarter :: Quarter;
    kCFCalendarUnitWeekOfMonth :: WeekOfMonth;
    kCFCalendarUnitWeekOfYear :: WeekOfYear;
    kCFCalendarUnitYearForWeekOfYear :: YearForWeekOfYear;
}

CFCalendarGetMinimumRangeOfUnit :: (calendar: CFCalendarRef, unit: CFCalendarUnit) -> CFRange #foreign corefoundation;
CFCalendarGetMaximumRangeOfUnit :: (calendar: CFCalendarRef, unit: CFCalendarUnit) -> CFRange #foreign corefoundation;
CFCalendarGetRangeOfUnit :: (calendar: CFCalendarRef, smallerUnit: CFCalendarUnit, biggerUnit: CFCalendarUnit, at: CFAbsoluteTime) -> CFRange #foreign corefoundation;
CFCalendarGetOrdinalityOfUnit :: (calendar: CFCalendarRef, smallerUnit: CFCalendarUnit, biggerUnit: CFCalendarUnit, at: CFAbsoluteTime) -> CFIndex #foreign corefoundation;
CFCalendarGetTimeRangeOfUnit :: (calendar: CFCalendarRef, unit: CFCalendarUnit, at: CFAbsoluteTime, startp: *CFAbsoluteTime, tip: *CFTimeInterval) -> Boolean #foreign corefoundation;
CFCalendarComposeAbsoluteTime :: (calendar: CFCalendarRef, at: *CFAbsoluteTime, componentDesc: *u8, __args: ..Any) -> Boolean #foreign corefoundation;
CFCalendarDecomposeAbsoluteTime :: (calendar: CFCalendarRef, at: CFAbsoluteTime, componentDesc: *u8, __args: ..Any) -> Boolean #foreign corefoundation;

anon_enum_6 :: enum u32 {
    kCFCalendarComponentsWrap :: 1;
}

CFCalendarAddComponents :: (calendar: CFCalendarRef, at: *CFAbsoluteTime, options: CFOptionFlags, componentDesc: *u8, __args: ..Any) -> Boolean #foreign corefoundation;
CFCalendarGetComponentDifference :: (calendar: CFCalendarRef, startingAT: CFAbsoluteTime, resultAT: CFAbsoluteTime, options: CFOptionFlags, componentDesc: *u8, __args: ..Any) -> Boolean #foreign corefoundation;
CFDateFormatterKey :: CFStringRef;
__CFDateFormatter :: struct {}
CFDateFormatterRef :: *__CFDateFormatter;
CFDateFormatterCreateDateFormatFromTemplate :: (allocator: CFAllocatorRef, tmplate: CFStringRef, options: CFOptionFlags, locale: CFLocaleRef) -> CFStringRef #foreign corefoundation;
CFDateFormatterGetTypeID :: () -> CFTypeID #foreign corefoundation;
CFDateFormatterStyle :: CFIndex;

kCFDateFormatter :: enum u32 {
    NoStyle :: 0;
    ShortStyle :: 1;
    MediumStyle :: 2;
    LongStyle :: 3;
    FullStyle :: 4;
    kCFDateFormatterNoStyle :: NoStyle;
    kCFDateFormatterShortStyle :: ShortStyle;
    kCFDateFormatterMediumStyle :: MediumStyle;
    kCFDateFormatterLongStyle :: LongStyle;
    kCFDateFormatterFullStyle :: FullStyle;
}

CFISO8601DateFormatOptions :: CFOptionFlags;

kCFISO8601DateFormatWith :: enum u32 {
    Year :: 1;
    Month :: 2;
    WeekOfYear :: 4;
    Day :: 16;
    Time :: 32;
    TimeZone :: 64;
    SpaceBetweenDateAndTime :: 128;
    DashSeparatorInDate :: 256;
    ColonSeparatorInTime :: 512;
    ColonSeparatorInTimeZone :: 1024;
    FractionalSeconds :: 2048;
    FullDate :: 275;
    FullTime :: 1632;
    InternetDateTime :: 1907;
    kCFISO8601DateFormatWithYear :: Year;
    kCFISO8601DateFormatWithMonth :: Month;
    kCFISO8601DateFormatWithWeekOfYear :: WeekOfYear;
    kCFISO8601DateFormatWithDay :: Day;
    kCFISO8601DateFormatWithTime :: Time;
    kCFISO8601DateFormatWithTimeZone :: TimeZone;
    kCFISO8601DateFormatWithSpaceBetweenDateAndTime :: SpaceBetweenDateAndTime;
    kCFISO8601DateFormatWithDashSeparatorInDate :: DashSeparatorInDate;
    kCFISO8601DateFormatWithColonSeparatorInTime :: ColonSeparatorInTime;
    kCFISO8601DateFormatWithColonSeparatorInTimeZone :: ColonSeparatorInTimeZone;
    kCFISO8601DateFormatWithFractionalSeconds :: FractionalSeconds;
    kCFISO8601DateFormatWithFullDate :: FullDate;
    kCFISO8601DateFormatWithFullTime :: FullTime;
    kCFISO8601DateFormatWithInternetDateTime :: InternetDateTime;
}

CFDateFormatterCreateISO8601Formatter :: (allocator: CFAllocatorRef, formatOptions: CFISO8601DateFormatOptions) -> CFDateFormatterRef #foreign corefoundation;
CFDateFormatterCreate :: (allocator: CFAllocatorRef, locale: CFLocaleRef, dateStyle: CFDateFormatterStyle, timeStyle: CFDateFormatterStyle) -> CFDateFormatterRef #foreign corefoundation;
CFDateFormatterGetLocale :: (formatter: CFDateFormatterRef) -> CFLocaleRef #foreign corefoundation;
CFDateFormatterGetDateStyle :: (formatter: CFDateFormatterRef) -> CFDateFormatterStyle #foreign corefoundation;
CFDateFormatterGetTimeStyle :: (formatter: CFDateFormatterRef) -> CFDateFormatterStyle #foreign corefoundation;
CFDateFormatterGetFormat :: (formatter: CFDateFormatterRef) -> CFStringRef #foreign corefoundation;
CFDateFormatterSetFormat :: (formatter: CFDateFormatterRef, formatString: CFStringRef) -> void #foreign corefoundation;
CFDateFormatterCreateStringWithDate :: (allocator: CFAllocatorRef, formatter: CFDateFormatterRef, date: CFDateRef) -> CFStringRef #foreign corefoundation;
CFDateFormatterCreateStringWithAbsoluteTime :: (allocator: CFAllocatorRef, formatter: CFDateFormatterRef, at: CFAbsoluteTime) -> CFStringRef #foreign corefoundation;
CFDateFormatterCreateDateFromString :: (allocator: CFAllocatorRef, formatter: CFDateFormatterRef, _string: CFStringRef, rangep: *CFRange) -> CFDateRef #foreign corefoundation;
CFDateFormatterGetAbsoluteTimeFromString :: (formatter: CFDateFormatterRef, _string: CFStringRef, rangep: *CFRange, atp: *CFAbsoluteTime) -> Boolean #foreign corefoundation;
CFDateFormatterSetProperty :: (formatter: CFDateFormatterRef, key: CFStringRef, value: CFTypeRef) -> void #foreign corefoundation;
CFDateFormatterCopyProperty :: (formatter: CFDateFormatterRef, key: CFDateFormatterKey) -> CFTypeRef #foreign corefoundation;
kCFDateFormatterIsLenient: CFDateFormatterKey #elsewhere corefoundation;
kCFDateFormatterTimeZone: CFDateFormatterKey #elsewhere corefoundation;
kCFDateFormatterCalendarName: CFDateFormatterKey #elsewhere corefoundation;
kCFDateFormatterDefaultFormat: CFDateFormatterKey #elsewhere corefoundation;
kCFDateFormatterTwoDigitStartDate: CFDateFormatterKey #elsewhere corefoundation;
kCFDateFormatterDefaultDate: CFDateFormatterKey #elsewhere corefoundation;
kCFDateFormatterCalendar: CFDateFormatterKey #elsewhere corefoundation;
kCFDateFormatterEraSymbols: CFDateFormatterKey #elsewhere corefoundation;
kCFDateFormatterMonthSymbols: CFDateFormatterKey #elsewhere corefoundation;
kCFDateFormatterShortMonthSymbols: CFDateFormatterKey #elsewhere corefoundation;
kCFDateFormatterWeekdaySymbols: CFDateFormatterKey #elsewhere corefoundation;
kCFDateFormatterShortWeekdaySymbols: CFDateFormatterKey #elsewhere corefoundation;
kCFDateFormatterAMSymbol: CFDateFormatterKey #elsewhere corefoundation;
kCFDateFormatterPMSymbol: CFDateFormatterKey #elsewhere corefoundation;
kCFDateFormatterLongEraSymbols: CFDateFormatterKey #elsewhere corefoundation;
kCFDateFormatterVeryShortMonthSymbols: CFDateFormatterKey #elsewhere corefoundation;
kCFDateFormatterStandaloneMonthSymbols: CFDateFormatterKey #elsewhere corefoundation;
kCFDateFormatterShortStandaloneMonthSymbols: CFDateFormatterKey #elsewhere corefoundation;
kCFDateFormatterVeryShortStandaloneMonthSymbols: CFDateFormatterKey #elsewhere corefoundation;
kCFDateFormatterVeryShortWeekdaySymbols: CFDateFormatterKey #elsewhere corefoundation;
kCFDateFormatterStandaloneWeekdaySymbols: CFDateFormatterKey #elsewhere corefoundation;
kCFDateFormatterShortStandaloneWeekdaySymbols: CFDateFormatterKey #elsewhere corefoundation;
kCFDateFormatterVeryShortStandaloneWeekdaySymbols: CFDateFormatterKey #elsewhere corefoundation;
kCFDateFormatterQuarterSymbols: CFDateFormatterKey #elsewhere corefoundation;
kCFDateFormatterShortQuarterSymbols: CFDateFormatterKey #elsewhere corefoundation;
kCFDateFormatterStandaloneQuarterSymbols: CFDateFormatterKey #elsewhere corefoundation;
kCFDateFormatterShortStandaloneQuarterSymbols: CFDateFormatterKey #elsewhere corefoundation;
kCFDateFormatterGregorianStartDate: CFDateFormatterKey #elsewhere corefoundation;
kCFDateFormatterDoesRelativeDateFormattingKey: CFDateFormatterKey #elsewhere corefoundation;
CFErrorDomain :: CFStringRef;
__CFError :: struct {}
CFErrorRef :: *__CFError;
CFErrorGetTypeID :: () -> CFTypeID #foreign corefoundation;
kCFErrorDomainPOSIX: CFErrorDomain #elsewhere corefoundation;
kCFErrorDomainOSStatus: CFErrorDomain #elsewhere corefoundation;
kCFErrorDomainMach: CFErrorDomain #elsewhere corefoundation;
kCFErrorDomainCocoa: CFErrorDomain #elsewhere corefoundation;
kCFErrorLocalizedDescriptionKey: CFStringRef #elsewhere corefoundation;
kCFErrorLocalizedFailureKey: CFStringRef #elsewhere corefoundation;
kCFErrorLocalizedFailureReasonKey: CFStringRef #elsewhere corefoundation;
kCFErrorLocalizedRecoverySuggestionKey: CFStringRef #elsewhere corefoundation;
kCFErrorDescriptionKey: CFStringRef #elsewhere corefoundation;
kCFErrorUnderlyingErrorKey: CFStringRef #elsewhere corefoundation;
kCFErrorURLKey: CFStringRef #elsewhere corefoundation;
kCFErrorFilePathKey: CFStringRef #elsewhere corefoundation;
CFErrorCreate :: (allocator: CFAllocatorRef, domain: CFErrorDomain, code: CFIndex, userInfo: CFDictionaryRef) -> CFErrorRef #foreign corefoundation;
CFErrorCreateWithUserInfoKeysAndValues :: (allocator: CFAllocatorRef, domain: CFErrorDomain, code: CFIndex, userInfoKeys: **void, userInfoValues: **void, numUserInfoValues: CFIndex) -> CFErrorRef #foreign corefoundation;
CFErrorGetDomain :: (err: CFErrorRef) -> CFErrorDomain #foreign corefoundation;
CFErrorGetCode :: (err: CFErrorRef) -> CFIndex #foreign corefoundation;
CFErrorCopyUserInfo :: (err: CFErrorRef) -> CFDictionaryRef #foreign corefoundation;
CFErrorCopyDescription :: (err: CFErrorRef) -> CFStringRef #foreign corefoundation;
CFErrorCopyFailureReason :: (err: CFErrorRef) -> CFStringRef #foreign corefoundation;
CFErrorCopyRecoverySuggestion :: (err: CFErrorRef) -> CFStringRef #foreign corefoundation;
__CFBoolean :: struct {}
CFBooleanRef :: *__CFBoolean;
kCFBooleanTrue: CFBooleanRef #elsewhere corefoundation;
kCFBooleanFalse: CFBooleanRef #elsewhere corefoundation;
CFBooleanGetTypeID :: () -> CFTypeID #foreign corefoundation;
CFBooleanGetValue :: (boolean: CFBooleanRef) -> Boolean #foreign corefoundation;
CFNumberType :: CFIndex;

kCFNumber :: enum u32 {
    SInt8Type :: 1;
    SInt16Type :: 2;
    SInt32Type :: 3;
    SInt64Type :: 4;
    Float32Type :: 5;
    Float64Type :: 6;
    CharType :: 7;
    ShortType :: 8;
    IntType :: 9;
    LongType :: 10;
    LongLongType :: 11;
    FloatType :: 12;
    DoubleType :: 13;
    CFIndexType :: 14;
    NSIntegerType :: 15;
    CGFloatType :: 16;
    MaxType :: 16;
    kCFNumberSInt8Type :: SInt8Type;
    kCFNumberSInt16Type :: SInt16Type;
    kCFNumberSInt32Type :: SInt32Type;
    kCFNumberSInt64Type :: SInt64Type;
    kCFNumberFloat32Type :: Float32Type;
    kCFNumberFloat64Type :: Float64Type;
    kCFNumberCharType :: CharType;
    kCFNumberShortType :: ShortType;
    kCFNumberIntType :: IntType;
    kCFNumberLongType :: LongType;
    kCFNumberLongLongType :: LongLongType;
    kCFNumberFloatType :: FloatType;
    kCFNumberDoubleType :: DoubleType;
    kCFNumberCFIndexType :: CFIndexType;
    kCFNumberNSIntegerType :: NSIntegerType;
    kCFNumberCGFloatType :: CGFloatType;
    kCFNumberMaxType :: MaxType;
}

__CFNumber :: struct {}
CFNumberRef :: *__CFNumber;
kCFNumberPositiveInfinity: CFNumberRef #elsewhere corefoundation;
kCFNumberNegativeInfinity: CFNumberRef #elsewhere corefoundation;
kCFNumberNaN: CFNumberRef #elsewhere corefoundation;
CFNumberGetTypeID :: () -> CFTypeID #foreign corefoundation;
CFNumberCreate :: (allocator: CFAllocatorRef, theType: CFNumberType, valuePtr: *void) -> CFNumberRef #foreign corefoundation;
CFNumberGetType :: (number: CFNumberRef) -> CFNumberType #foreign corefoundation;
CFNumberGetByteSize :: (number: CFNumberRef) -> CFIndex #foreign corefoundation;
CFNumberIsFloatType :: (number: CFNumberRef) -> Boolean #foreign corefoundation;
CFNumberGetValue :: (number: CFNumberRef, theType: CFNumberType, valuePtr: *void) -> Boolean #foreign corefoundation;
CFNumberCompare :: (number: CFNumberRef, otherNumber: CFNumberRef, _context: *void) -> CFComparisonResult #foreign corefoundation;
CFNumberFormatterKey :: CFStringRef;
__CFNumberFormatter :: struct {}
CFNumberFormatterRef :: *__CFNumberFormatter;
CFNumberFormatterGetTypeID :: () -> CFTypeID #foreign corefoundation;
CFNumberFormatterStyle :: CFIndex;

kCFNumberFormatter :: enum u32 {
    NoStyle :: 0;
    DecimalStyle :: 1;
    CurrencyStyle :: 2;
    PercentStyle :: 3;
    ScientificStyle :: 4;
    SpellOutStyle :: 5;
    OrdinalStyle :: 6;
    CurrencyISOCodeStyle :: 8;
    CurrencyPluralStyle :: 9;
    CurrencyAccountingStyle :: 10;
    kCFNumberFormatterNoStyle :: NoStyle;
    kCFNumberFormatterDecimalStyle :: DecimalStyle;
    kCFNumberFormatterCurrencyStyle :: CurrencyStyle;
    kCFNumberFormatterPercentStyle :: PercentStyle;
    kCFNumberFormatterScientificStyle :: ScientificStyle;
    kCFNumberFormatterSpellOutStyle :: SpellOutStyle;
    kCFNumberFormatterOrdinalStyle :: OrdinalStyle;
    kCFNumberFormatterCurrencyISOCodeStyle :: CurrencyISOCodeStyle;
    kCFNumberFormatterCurrencyPluralStyle :: CurrencyPluralStyle;
    kCFNumberFormatterCurrencyAccountingStyle :: CurrencyAccountingStyle;
}

CFNumberFormatterCreate :: (allocator: CFAllocatorRef, locale: CFLocaleRef, style: CFNumberFormatterStyle) -> CFNumberFormatterRef #foreign corefoundation;
CFNumberFormatterGetLocale :: (formatter: CFNumberFormatterRef) -> CFLocaleRef #foreign corefoundation;
CFNumberFormatterGetStyle :: (formatter: CFNumberFormatterRef) -> CFNumberFormatterStyle #foreign corefoundation;
CFNumberFormatterGetFormat :: (formatter: CFNumberFormatterRef) -> CFStringRef #foreign corefoundation;
CFNumberFormatterSetFormat :: (formatter: CFNumberFormatterRef, formatString: CFStringRef) -> void #foreign corefoundation;
CFNumberFormatterCreateStringWithNumber :: (allocator: CFAllocatorRef, formatter: CFNumberFormatterRef, number: CFNumberRef) -> CFStringRef #foreign corefoundation;
CFNumberFormatterCreateStringWithValue :: (allocator: CFAllocatorRef, formatter: CFNumberFormatterRef, numberType: CFNumberType, valuePtr: *void) -> CFStringRef #foreign corefoundation;
CFNumberFormatterOptionFlags :: CFOptionFlags;

anon_enum_7 :: enum u32 {
    kCFNumberFormatterParseIntegersOnly :: 1;
}

CFNumberFormatterCreateNumberFromString :: (allocator: CFAllocatorRef, formatter: CFNumberFormatterRef, _string: CFStringRef, rangep: *CFRange, options: CFOptionFlags) -> CFNumberRef #foreign corefoundation;
CFNumberFormatterGetValueFromString :: (formatter: CFNumberFormatterRef, _string: CFStringRef, rangep: *CFRange, numberType: CFNumberType, valuePtr: *void) -> Boolean #foreign corefoundation;
CFNumberFormatterSetProperty :: (formatter: CFNumberFormatterRef, key: CFNumberFormatterKey, value: CFTypeRef) -> void #foreign corefoundation;
CFNumberFormatterCopyProperty :: (formatter: CFNumberFormatterRef, key: CFNumberFormatterKey) -> CFTypeRef #foreign corefoundation;
kCFNumberFormatterCurrencyCode: CFNumberFormatterKey #elsewhere corefoundation;
kCFNumberFormatterDecimalSeparator: CFNumberFormatterKey #elsewhere corefoundation;
kCFNumberFormatterCurrencyDecimalSeparator: CFNumberFormatterKey #elsewhere corefoundation;
kCFNumberFormatterAlwaysShowDecimalSeparator: CFNumberFormatterKey #elsewhere corefoundation;
kCFNumberFormatterGroupingSeparator: CFNumberFormatterKey #elsewhere corefoundation;
kCFNumberFormatterUseGroupingSeparator: CFNumberFormatterKey #elsewhere corefoundation;
kCFNumberFormatterPercentSymbol: CFNumberFormatterKey #elsewhere corefoundation;
kCFNumberFormatterZeroSymbol: CFNumberFormatterKey #elsewhere corefoundation;
kCFNumberFormatterNaNSymbol: CFNumberFormatterKey #elsewhere corefoundation;
kCFNumberFormatterInfinitySymbol: CFNumberFormatterKey #elsewhere corefoundation;
kCFNumberFormatterMinusSign: CFNumberFormatterKey #elsewhere corefoundation;
kCFNumberFormatterPlusSign: CFNumberFormatterKey #elsewhere corefoundation;
kCFNumberFormatterCurrencySymbol: CFNumberFormatterKey #elsewhere corefoundation;
kCFNumberFormatterExponentSymbol: CFNumberFormatterKey #elsewhere corefoundation;
kCFNumberFormatterMinIntegerDigits: CFNumberFormatterKey #elsewhere corefoundation;
kCFNumberFormatterMaxIntegerDigits: CFNumberFormatterKey #elsewhere corefoundation;
kCFNumberFormatterMinFractionDigits: CFNumberFormatterKey #elsewhere corefoundation;
kCFNumberFormatterMaxFractionDigits: CFNumberFormatterKey #elsewhere corefoundation;
kCFNumberFormatterGroupingSize: CFNumberFormatterKey #elsewhere corefoundation;
kCFNumberFormatterSecondaryGroupingSize: CFNumberFormatterKey #elsewhere corefoundation;
kCFNumberFormatterRoundingMode: CFNumberFormatterKey #elsewhere corefoundation;
kCFNumberFormatterRoundingIncrement: CFNumberFormatterKey #elsewhere corefoundation;
kCFNumberFormatterFormatWidth: CFNumberFormatterKey #elsewhere corefoundation;
kCFNumberFormatterPaddingPosition: CFNumberFormatterKey #elsewhere corefoundation;
kCFNumberFormatterPaddingCharacter: CFNumberFormatterKey #elsewhere corefoundation;
kCFNumberFormatterDefaultFormat: CFNumberFormatterKey #elsewhere corefoundation;
kCFNumberFormatterMultiplier: CFNumberFormatterKey #elsewhere corefoundation;
kCFNumberFormatterPositivePrefix: CFNumberFormatterKey #elsewhere corefoundation;
kCFNumberFormatterPositiveSuffix: CFNumberFormatterKey #elsewhere corefoundation;
kCFNumberFormatterNegativePrefix: CFNumberFormatterKey #elsewhere corefoundation;
kCFNumberFormatterNegativeSuffix: CFNumberFormatterKey #elsewhere corefoundation;
kCFNumberFormatterPerMillSymbol: CFNumberFormatterKey #elsewhere corefoundation;
kCFNumberFormatterInternationalCurrencySymbol: CFNumberFormatterKey #elsewhere corefoundation;
kCFNumberFormatterCurrencyGroupingSeparator: CFNumberFormatterKey #elsewhere corefoundation;
kCFNumberFormatterIsLenient: CFNumberFormatterKey #elsewhere corefoundation;
kCFNumberFormatterUseSignificantDigits: CFNumberFormatterKey #elsewhere corefoundation;
kCFNumberFormatterMinSignificantDigits: CFNumberFormatterKey #elsewhere corefoundation;
kCFNumberFormatterMaxSignificantDigits: CFNumberFormatterKey #elsewhere corefoundation;
CFNumberFormatterRoundingMode :: CFIndex;

kCFNumberFormatterRound :: enum u32 {
    Ceiling :: 0;
    Floor :: 1;
    Down :: 2;
    Up :: 3;
    HalfEven :: 4;
    HalfDown :: 5;
    HalfUp :: 6;
    kCFNumberFormatterRoundCeiling :: Ceiling;
    kCFNumberFormatterRoundFloor :: Floor;
    kCFNumberFormatterRoundDown :: Down;
    kCFNumberFormatterRoundUp :: Up;
    kCFNumberFormatterRoundHalfEven :: HalfEven;
    kCFNumberFormatterRoundHalfDown :: HalfDown;
    kCFNumberFormatterRoundHalfUp :: HalfUp;
}

CFNumberFormatterPadPosition :: CFIndex;

kCFNumberFormatterPad :: enum u32 {
    BeforePrefix :: 0;
    AfterPrefix :: 1;
    BeforeSuffix :: 2;
    AfterSuffix :: 3;
    kCFNumberFormatterPadBeforePrefix :: BeforePrefix;
    kCFNumberFormatterPadAfterPrefix :: AfterPrefix;
    kCFNumberFormatterPadBeforeSuffix :: BeforeSuffix;
    kCFNumberFormatterPadAfterSuffix :: AfterSuffix;
}

CFNumberFormatterGetDecimalInfoForCurrencyCode :: (currencyCode: CFStringRef, defaultFractionDigits: *s32, roundingIncrement: *float64) -> Boolean #foreign corefoundation;
kCFPreferencesAnyApplication: CFStringRef #elsewhere corefoundation;
kCFPreferencesCurrentApplication: CFStringRef #elsewhere corefoundation;
kCFPreferencesAnyHost: CFStringRef #elsewhere corefoundation;
kCFPreferencesCurrentHost: CFStringRef #elsewhere corefoundation;
kCFPreferencesAnyUser: CFStringRef #elsewhere corefoundation;
kCFPreferencesCurrentUser: CFStringRef #elsewhere corefoundation;
CFPreferencesCopyAppValue :: (key: CFStringRef, applicationID: CFStringRef) -> CFPropertyListRef #foreign corefoundation;
CFPreferencesGetAppBooleanValue :: (key: CFStringRef, applicationID: CFStringRef, keyExistsAndHasValidFormat: *Boolean) -> Boolean #foreign corefoundation;
CFPreferencesGetAppIntegerValue :: (key: CFStringRef, applicationID: CFStringRef, keyExistsAndHasValidFormat: *Boolean) -> CFIndex #foreign corefoundation;
CFPreferencesSetAppValue :: (key: CFStringRef, value: CFPropertyListRef, applicationID: CFStringRef) -> void #foreign corefoundation;
CFPreferencesAddSuitePreferencesToApp :: (applicationID: CFStringRef, suiteID: CFStringRef) -> void #foreign corefoundation;
CFPreferencesRemoveSuitePreferencesFromApp :: (applicationID: CFStringRef, suiteID: CFStringRef) -> void #foreign corefoundation;
CFPreferencesAppSynchronize :: (applicationID: CFStringRef) -> Boolean #foreign corefoundation;
CFPreferencesCopyValue :: (key: CFStringRef, applicationID: CFStringRef, userName: CFStringRef, hostName: CFStringRef) -> CFPropertyListRef #foreign corefoundation;
CFPreferencesCopyMultiple :: (keysToFetch: CFArrayRef, applicationID: CFStringRef, userName: CFStringRef, hostName: CFStringRef) -> CFDictionaryRef #foreign corefoundation;
CFPreferencesSetValue :: (key: CFStringRef, value: CFPropertyListRef, applicationID: CFStringRef, userName: CFStringRef, hostName: CFStringRef) -> void #foreign corefoundation;
CFPreferencesSetMultiple :: (keysToSet: CFDictionaryRef, keysToRemove: CFArrayRef, applicationID: CFStringRef, userName: CFStringRef, hostName: CFStringRef) -> void #foreign corefoundation;
CFPreferencesSynchronize :: (applicationID: CFStringRef, userName: CFStringRef, hostName: CFStringRef) -> Boolean #foreign corefoundation;
CFPreferencesCopyApplicationList :: (userName: CFStringRef, hostName: CFStringRef) -> CFArrayRef #foreign corefoundation;
CFPreferencesCopyKeyList :: (applicationID: CFStringRef, userName: CFStringRef, hostName: CFStringRef) -> CFArrayRef #foreign corefoundation;
CFPreferencesAppValueIsForced :: (key: CFStringRef, applicationID: CFStringRef) -> Boolean #foreign corefoundation;
CFURLPathStyle :: CFIndex;

kCFURL :: enum u32 {
    POSIXPathStyle :: 0;
    HFSPathStyle :: 1;
    WindowsPathStyle :: 2;
    kCFURLPOSIXPathStyle :: POSIXPathStyle;
    kCFURLHFSPathStyle :: HFSPathStyle;
    kCFURLWindowsPathStyle :: WindowsPathStyle;
}

__CFURL :: struct {}
CFURLRef :: *__CFURL;
CFURLGetTypeID :: () -> CFTypeID #foreign corefoundation;
CFURLCreateWithBytes :: (allocator: CFAllocatorRef, URLBytes: *u8, length: CFIndex, encoding: CFStringEncoding, baseURL: CFURLRef) -> CFURLRef #foreign corefoundation;
CFURLCreateData :: (allocator: CFAllocatorRef, url: CFURLRef, encoding: CFStringEncoding, escapeWhitespace: Boolean) -> CFDataRef #foreign corefoundation;
CFURLCreateWithString :: (allocator: CFAllocatorRef, URLString: CFStringRef, baseURL: CFURLRef) -> CFURLRef #foreign corefoundation;
CFURLCreateAbsoluteURLWithBytes :: (alloc: CFAllocatorRef, relativeURLBytes: *u8, length: CFIndex, encoding: CFStringEncoding, baseURL: CFURLRef, useCompatibilityMode: Boolean) -> CFURLRef #foreign corefoundation;
CFURLCreateWithFileSystemPath :: (allocator: CFAllocatorRef, filePath: CFStringRef, pathStyle: CFURLPathStyle, isDirectory: Boolean) -> CFURLRef #foreign corefoundation;
CFURLCreateFromFileSystemRepresentation :: (allocator: CFAllocatorRef, buffer: *u8, bufLen: CFIndex, isDirectory: Boolean) -> CFURLRef #foreign corefoundation;
CFURLCreateWithFileSystemPathRelativeToBase :: (allocator: CFAllocatorRef, filePath: CFStringRef, pathStyle: CFURLPathStyle, isDirectory: Boolean, baseURL: CFURLRef) -> CFURLRef #foreign corefoundation;
CFURLCreateFromFileSystemRepresentationRelativeToBase :: (allocator: CFAllocatorRef, buffer: *u8, bufLen: CFIndex, isDirectory: Boolean, baseURL: CFURLRef) -> CFURLRef #foreign corefoundation;
CFURLGetFileSystemRepresentation :: (url: CFURLRef, resolveAgainstBase: Boolean, buffer: *u8, maxBufLen: CFIndex) -> Boolean #foreign corefoundation;
CFURLCopyAbsoluteURL :: (relativeURL: CFURLRef) -> CFURLRef #foreign corefoundation;
CFURLGetString :: (anURL: CFURLRef) -> CFStringRef #foreign corefoundation;
CFURLGetBaseURL :: (anURL: CFURLRef) -> CFURLRef #foreign corefoundation;
CFURLCanBeDecomposed :: (anURL: CFURLRef) -> Boolean #foreign corefoundation;
CFURLCopyScheme :: (anURL: CFURLRef) -> CFStringRef #foreign corefoundation;
CFURLCopyNetLocation :: (anURL: CFURLRef) -> CFStringRef #foreign corefoundation;
CFURLCopyPath :: (anURL: CFURLRef) -> CFStringRef #foreign corefoundation;
CFURLCopyStrictPath :: (anURL: CFURLRef, isAbsolute: *Boolean) -> CFStringRef #foreign corefoundation;
CFURLCopyFileSystemPath :: (anURL: CFURLRef, pathStyle: CFURLPathStyle) -> CFStringRef #foreign corefoundation;
CFURLHasDirectoryPath :: (anURL: CFURLRef) -> Boolean #foreign corefoundation;
CFURLCopyResourceSpecifier :: (anURL: CFURLRef) -> CFStringRef #foreign corefoundation;
CFURLCopyHostName :: (anURL: CFURLRef) -> CFStringRef #foreign corefoundation;
CFURLGetPortNumber :: (anURL: CFURLRef) -> s32 #foreign corefoundation;
CFURLCopyUserName :: (anURL: CFURLRef) -> CFStringRef #foreign corefoundation;
CFURLCopyPassword :: (anURL: CFURLRef) -> CFStringRef #foreign corefoundation;
CFURLCopyParameterString :: (anURL: CFURLRef, charactersToLeaveEscaped: CFStringRef) -> CFStringRef #foreign corefoundation;
CFURLCopyQueryString :: (anURL: CFURLRef, charactersToLeaveEscaped: CFStringRef) -> CFStringRef #foreign corefoundation;
CFURLCopyFragment :: (anURL: CFURLRef, charactersToLeaveEscaped: CFStringRef) -> CFStringRef #foreign corefoundation;
CFURLCopyLastPathComponent :: (url: CFURLRef) -> CFStringRef #foreign corefoundation;
CFURLCopyPathExtension :: (url: CFURLRef) -> CFStringRef #foreign corefoundation;
CFURLCreateCopyAppendingPathComponent :: (allocator: CFAllocatorRef, url: CFURLRef, pathComponent: CFStringRef, isDirectory: Boolean) -> CFURLRef #foreign corefoundation;
CFURLCreateCopyDeletingLastPathComponent :: (allocator: CFAllocatorRef, url: CFURLRef) -> CFURLRef #foreign corefoundation;
CFURLCreateCopyAppendingPathExtension :: (allocator: CFAllocatorRef, url: CFURLRef, extension: CFStringRef) -> CFURLRef #foreign corefoundation;
CFURLCreateCopyDeletingPathExtension :: (allocator: CFAllocatorRef, url: CFURLRef) -> CFURLRef #foreign corefoundation;
CFURLGetBytes :: (url: CFURLRef, buffer: *u8, bufferLength: CFIndex) -> CFIndex #foreign corefoundation;
CFURLComponentType :: CFIndex;

kCFURLComponent :: enum u32 {
    Scheme :: 1;
    NetLocation :: 2;
    Path :: 3;
    ResourceSpecifier :: 4;
    User :: 5;
    Password :: 6;
    UserInfo :: 7;
    Host :: 8;
    Port :: 9;
    ParameterString :: 10;
    Query :: 11;
    Fragment :: 12;
    kCFURLComponentScheme :: Scheme;
    kCFURLComponentNetLocation :: NetLocation;
    kCFURLComponentPath :: Path;
    kCFURLComponentResourceSpecifier :: ResourceSpecifier;
    kCFURLComponentUser :: User;
    kCFURLComponentPassword :: Password;
    kCFURLComponentUserInfo :: UserInfo;
    kCFURLComponentHost :: Host;
    kCFURLComponentPort :: Port;
    kCFURLComponentParameterString :: ParameterString;
    kCFURLComponentQuery :: Query;
    kCFURLComponentFragment :: Fragment;
}

CFURLGetByteRangeForComponent :: (url: CFURLRef, component: CFURLComponentType, rangeIncludingSeparators: *CFRange) -> CFRange #foreign corefoundation;
CFURLCreateStringByReplacingPercentEscapes :: (allocator: CFAllocatorRef, originalString: CFStringRef, charactersToLeaveEscaped: CFStringRef) -> CFStringRef #foreign corefoundation;
CFURLCreateStringByReplacingPercentEscapesUsingEncoding :: (allocator: CFAllocatorRef, origString: CFStringRef, charsToLeaveEscaped: CFStringRef, encoding: CFStringEncoding) -> CFStringRef #foreign corefoundation;
CFURLCreateStringByAddingPercentEscapes :: (allocator: CFAllocatorRef, originalString: CFStringRef, charactersToLeaveUnescaped: CFStringRef, legalURLCharactersToBeEscaped: CFStringRef, encoding: CFStringEncoding) -> CFStringRef #foreign corefoundation;
CFURLIsFileReferenceURL :: (url: CFURLRef) -> Boolean #foreign corefoundation;
CFURLCreateFileReferenceURL :: (allocator: CFAllocatorRef, url: CFURLRef, error: *CFErrorRef) -> CFURLRef #foreign corefoundation;
CFURLCreateFilePathURL :: (allocator: CFAllocatorRef, url: CFURLRef, error: *CFErrorRef) -> CFURLRef #foreign corefoundation;
FSRef :: struct {}
CFURLCreateFromFSRef :: (allocator: CFAllocatorRef, fsRef: *FSRef) -> CFURLRef #foreign corefoundation;
CFURLGetFSRef :: (url: CFURLRef, fsRef: *FSRef) -> Boolean #foreign corefoundation;
CFURLCopyResourcePropertyForKey :: (url: CFURLRef, key: CFStringRef, propertyValueTypeRefPtr: *void, error: *CFErrorRef) -> Boolean #foreign corefoundation;
CFURLCopyResourcePropertiesForKeys :: (url: CFURLRef, keys: CFArrayRef, error: *CFErrorRef) -> CFDictionaryRef #foreign corefoundation;
CFURLSetResourcePropertyForKey :: (url: CFURLRef, key: CFStringRef, propertyValue: CFTypeRef, error: *CFErrorRef) -> Boolean #foreign corefoundation;
CFURLSetResourcePropertiesForKeys :: (url: CFURLRef, keyedPropertyValues: CFDictionaryRef, error: *CFErrorRef) -> Boolean #foreign corefoundation;
kCFURLKeysOfUnsetValuesKey: CFStringRef #elsewhere corefoundation;
CFURLClearResourcePropertyCacheForKey :: (url: CFURLRef, key: CFStringRef) -> void #foreign corefoundation;
CFURLClearResourcePropertyCache :: (url: CFURLRef) -> void #foreign corefoundation;
CFURLSetTemporaryResourcePropertyForKey :: (url: CFURLRef, key: CFStringRef, propertyValue: CFTypeRef) -> void #foreign corefoundation;
CFURLResourceIsReachable :: (url: CFURLRef, error: *CFErrorRef) -> Boolean #foreign corefoundation;
kCFURLNameKey: CFStringRef #elsewhere corefoundation;
kCFURLLocalizedNameKey: CFStringRef #elsewhere corefoundation;
kCFURLIsRegularFileKey: CFStringRef #elsewhere corefoundation;
kCFURLIsDirectoryKey: CFStringRef #elsewhere corefoundation;
kCFURLIsSymbolicLinkKey: CFStringRef #elsewhere corefoundation;
kCFURLIsVolumeKey: CFStringRef #elsewhere corefoundation;
kCFURLIsPackageKey: CFStringRef #elsewhere corefoundation;
kCFURLIsApplicationKey: CFStringRef #elsewhere corefoundation;
kCFURLApplicationIsScriptableKey: CFStringRef #elsewhere corefoundation;
kCFURLIsSystemImmutableKey: CFStringRef #elsewhere corefoundation;
kCFURLIsUserImmutableKey: CFStringRef #elsewhere corefoundation;
kCFURLIsHiddenKey: CFStringRef #elsewhere corefoundation;
kCFURLHasHiddenExtensionKey: CFStringRef #elsewhere corefoundation;
kCFURLCreationDateKey: CFStringRef #elsewhere corefoundation;
kCFURLContentAccessDateKey: CFStringRef #elsewhere corefoundation;
kCFURLContentModificationDateKey: CFStringRef #elsewhere corefoundation;
kCFURLAttributeModificationDateKey: CFStringRef #elsewhere corefoundation;
kCFURLLinkCountKey: CFStringRef #elsewhere corefoundation;
kCFURLParentDirectoryURLKey: CFStringRef #elsewhere corefoundation;
kCFURLVolumeURLKey: CFStringRef #elsewhere corefoundation;
kCFURLTypeIdentifierKey: CFStringRef #elsewhere corefoundation;
kCFURLLocalizedTypeDescriptionKey: CFStringRef #elsewhere corefoundation;
kCFURLLabelNumberKey: CFStringRef #elsewhere corefoundation;
kCFURLLabelColorKey: CFStringRef #elsewhere corefoundation;
kCFURLLocalizedLabelKey: CFStringRef #elsewhere corefoundation;
kCFURLEffectiveIconKey: CFStringRef #elsewhere corefoundation;
kCFURLCustomIconKey: CFStringRef #elsewhere corefoundation;
kCFURLFileResourceIdentifierKey: CFStringRef #elsewhere corefoundation;
kCFURLVolumeIdentifierKey: CFStringRef #elsewhere corefoundation;
kCFURLPreferredIOBlockSizeKey: CFStringRef #elsewhere corefoundation;
kCFURLIsReadableKey: CFStringRef #elsewhere corefoundation;
kCFURLIsWritableKey: CFStringRef #elsewhere corefoundation;
kCFURLIsExecutableKey: CFStringRef #elsewhere corefoundation;
kCFURLFileSecurityKey: CFStringRef #elsewhere corefoundation;
kCFURLIsExcludedFromBackupKey: CFStringRef #elsewhere corefoundation;
kCFURLTagNamesKey: CFStringRef #elsewhere corefoundation;
kCFURLPathKey: CFStringRef #elsewhere corefoundation;
kCFURLCanonicalPathKey: CFStringRef #elsewhere corefoundation;
kCFURLIsMountTriggerKey: CFStringRef #elsewhere corefoundation;
kCFURLGenerationIdentifierKey: CFStringRef #elsewhere corefoundation;
kCFURLDocumentIdentifierKey: CFStringRef #elsewhere corefoundation;
kCFURLAddedToDirectoryDateKey: CFStringRef #elsewhere corefoundation;
kCFURLQuarantinePropertiesKey: CFStringRef #elsewhere corefoundation;
kCFURLFileResourceTypeKey: CFStringRef #elsewhere corefoundation;
kCFURLFileResourceTypeNamedPipe: CFStringRef #elsewhere corefoundation;
kCFURLFileResourceTypeCharacterSpecial: CFStringRef #elsewhere corefoundation;
kCFURLFileResourceTypeDirectory: CFStringRef #elsewhere corefoundation;
kCFURLFileResourceTypeBlockSpecial: CFStringRef #elsewhere corefoundation;
kCFURLFileResourceTypeRegular: CFStringRef #elsewhere corefoundation;
kCFURLFileResourceTypeSymbolicLink: CFStringRef #elsewhere corefoundation;
kCFURLFileResourceTypeSocket: CFStringRef #elsewhere corefoundation;
kCFURLFileResourceTypeUnknown: CFStringRef #elsewhere corefoundation;
kCFURLFileSizeKey: CFStringRef #elsewhere corefoundation;
kCFURLFileAllocatedSizeKey: CFStringRef #elsewhere corefoundation;
kCFURLTotalFileSizeKey: CFStringRef #elsewhere corefoundation;
kCFURLTotalFileAllocatedSizeKey: CFStringRef #elsewhere corefoundation;
kCFURLIsAliasFileKey: CFStringRef #elsewhere corefoundation;
kCFURLFileProtectionKey: CFStringRef #elsewhere corefoundation;
kCFURLFileProtectionNone: CFStringRef #elsewhere corefoundation;
kCFURLFileProtectionComplete: CFStringRef #elsewhere corefoundation;
kCFURLFileProtectionCompleteUnlessOpen: CFStringRef #elsewhere corefoundation;
kCFURLFileProtectionCompleteUntilFirstUserAuthentication: CFStringRef #elsewhere corefoundation;
kCFURLVolumeLocalizedFormatDescriptionKey: CFStringRef #elsewhere corefoundation;
kCFURLVolumeTotalCapacityKey: CFStringRef #elsewhere corefoundation;
kCFURLVolumeAvailableCapacityKey: CFStringRef #elsewhere corefoundation;
kCFURLVolumeAvailableCapacityForImportantUsageKey: CFStringRef #elsewhere corefoundation;
kCFURLVolumeAvailableCapacityForOpportunisticUsageKey: CFStringRef #elsewhere corefoundation;
kCFURLVolumeResourceCountKey: CFStringRef #elsewhere corefoundation;
kCFURLVolumeSupportsPersistentIDsKey: CFStringRef #elsewhere corefoundation;
kCFURLVolumeSupportsSymbolicLinksKey: CFStringRef #elsewhere corefoundation;
kCFURLVolumeSupportsHardLinksKey: CFStringRef #elsewhere corefoundation;
kCFURLVolumeSupportsJournalingKey: CFStringRef #elsewhere corefoundation;
kCFURLVolumeIsJournalingKey: CFStringRef #elsewhere corefoundation;
kCFURLVolumeSupportsSparseFilesKey: CFStringRef #elsewhere corefoundation;
kCFURLVolumeSupportsZeroRunsKey: CFStringRef #elsewhere corefoundation;
kCFURLVolumeSupportsCaseSensitiveNamesKey: CFStringRef #elsewhere corefoundation;
kCFURLVolumeSupportsCasePreservedNamesKey: CFStringRef #elsewhere corefoundation;
kCFURLVolumeSupportsRootDirectoryDatesKey: CFStringRef #elsewhere corefoundation;
kCFURLVolumeSupportsVolumeSizesKey: CFStringRef #elsewhere corefoundation;
kCFURLVolumeSupportsRenamingKey: CFStringRef #elsewhere corefoundation;
kCFURLVolumeSupportsAdvisoryFileLockingKey: CFStringRef #elsewhere corefoundation;
kCFURLVolumeSupportsExtendedSecurityKey: CFStringRef #elsewhere corefoundation;
kCFURLVolumeIsBrowsableKey: CFStringRef #elsewhere corefoundation;
kCFURLVolumeMaximumFileSizeKey: CFStringRef #elsewhere corefoundation;
kCFURLVolumeIsEjectableKey: CFStringRef #elsewhere corefoundation;
kCFURLVolumeIsRemovableKey: CFStringRef #elsewhere corefoundation;
kCFURLVolumeIsInternalKey: CFStringRef #elsewhere corefoundation;
kCFURLVolumeIsAutomountedKey: CFStringRef #elsewhere corefoundation;
kCFURLVolumeIsLocalKey: CFStringRef #elsewhere corefoundation;
kCFURLVolumeIsReadOnlyKey: CFStringRef #elsewhere corefoundation;
kCFURLVolumeCreationDateKey: CFStringRef #elsewhere corefoundation;
kCFURLVolumeURLForRemountingKey: CFStringRef #elsewhere corefoundation;
kCFURLVolumeUUIDStringKey: CFStringRef #elsewhere corefoundation;
kCFURLVolumeNameKey: CFStringRef #elsewhere corefoundation;
kCFURLVolumeLocalizedNameKey: CFStringRef #elsewhere corefoundation;
kCFURLVolumeIsEncryptedKey: CFStringRef #elsewhere corefoundation;
kCFURLVolumeIsRootFileSystemKey: CFStringRef #elsewhere corefoundation;
kCFURLVolumeSupportsCompressionKey: CFStringRef #elsewhere corefoundation;
kCFURLVolumeSupportsFileCloningKey: CFStringRef #elsewhere corefoundation;
kCFURLVolumeSupportsSwapRenamingKey: CFStringRef #elsewhere corefoundation;
kCFURLVolumeSupportsExclusiveRenamingKey: CFStringRef #elsewhere corefoundation;
kCFURLVolumeSupportsImmutableFilesKey: CFStringRef #elsewhere corefoundation;
kCFURLVolumeSupportsAccessPermissionsKey: CFStringRef #elsewhere corefoundation;
kCFURLIsUbiquitousItemKey: CFStringRef #elsewhere corefoundation;
kCFURLUbiquitousItemHasUnresolvedConflictsKey: CFStringRef #elsewhere corefoundation;
kCFURLUbiquitousItemIsDownloadedKey: CFStringRef #elsewhere corefoundation;
kCFURLUbiquitousItemIsDownloadingKey: CFStringRef #elsewhere corefoundation;
kCFURLUbiquitousItemIsUploadedKey: CFStringRef #elsewhere corefoundation;
kCFURLUbiquitousItemIsUploadingKey: CFStringRef #elsewhere corefoundation;
kCFURLUbiquitousItemPercentDownloadedKey: CFStringRef #elsewhere corefoundation;
kCFURLUbiquitousItemPercentUploadedKey: CFStringRef #elsewhere corefoundation;
kCFURLUbiquitousItemDownloadingStatusKey: CFStringRef #elsewhere corefoundation;
kCFURLUbiquitousItemDownloadingErrorKey: CFStringRef #elsewhere corefoundation;
kCFURLUbiquitousItemUploadingErrorKey: CFStringRef #elsewhere corefoundation;
kCFURLUbiquitousItemDownloadingStatusNotDownloaded: CFStringRef #elsewhere corefoundation;
kCFURLUbiquitousItemDownloadingStatusDownloaded: CFStringRef #elsewhere corefoundation;
kCFURLUbiquitousItemDownloadingStatusCurrent: CFStringRef #elsewhere corefoundation;
CFURLBookmarkCreationOptions :: CFOptionFlags;

kCFURLBookmarkCreation :: enum u32 {
    MinimalBookmarkMask :: 512;
    SuitableForBookmarkFile :: 1024;
    WithSecurityScope :: 2048;
    SecurityScopeAllowOnlyReadAccess :: 4096;
    PreferFileIDResolutionMask :: 256;
    kCFURLBookmarkCreationMinimalBookmarkMask :: MinimalBookmarkMask;
    kCFURLBookmarkCreationSuitableForBookmarkFile :: SuitableForBookmarkFile;
    kCFURLBookmarkCreationWithSecurityScope :: WithSecurityScope;
    kCFURLBookmarkCreationSecurityScopeAllowOnlyReadAccess :: SecurityScopeAllowOnlyReadAccess;
    kCFURLBookmarkCreationPreferFileIDResolutionMask :: PreferFileIDResolutionMask;
}

CFURLBookmarkResolutionOptions :: CFOptionFlags;

kCF :: enum u32 {
    URLBookmarkResolutionWithoutUIMask :: 256;
    URLBookmarkResolutionWithoutMountingMask :: 512;
    URLBookmarkResolutionWithSecurityScope :: 1024;
    BookmarkResolutionWithoutUIMask :: 256;
    BookmarkResolutionWithoutMountingMask :: 512;
    kCFURLBookmarkResolutionWithoutUIMask :: URLBookmarkResolutionWithoutUIMask;
    kCFURLBookmarkResolutionWithoutMountingMask :: URLBookmarkResolutionWithoutMountingMask;
    kCFURLBookmarkResolutionWithSecurityScope :: URLBookmarkResolutionWithSecurityScope;
    kCFBookmarkResolutionWithoutUIMask :: BookmarkResolutionWithoutUIMask;
    kCFBookmarkResolutionWithoutMountingMask :: BookmarkResolutionWithoutMountingMask;
}

CFURLBookmarkFileCreationOptions :: CFOptionFlags;
CFURLCreateBookmarkData :: (allocator: CFAllocatorRef, url: CFURLRef, options: CFURLBookmarkCreationOptions, resourcePropertiesToInclude: CFArrayRef, relativeToURL: CFURLRef, error: *CFErrorRef) -> CFDataRef #foreign corefoundation;
CFURLCreateByResolvingBookmarkData :: (allocator: CFAllocatorRef, bookmark: CFDataRef, options: CFURLBookmarkResolutionOptions, relativeToURL: CFURLRef, resourcePropertiesToInclude: CFArrayRef, isStale: *Boolean, error: *CFErrorRef) -> CFURLRef #foreign corefoundation;
CFURLCreateResourcePropertiesForKeysFromBookmarkData :: (allocator: CFAllocatorRef, resourcePropertiesToReturn: CFArrayRef, bookmark: CFDataRef) -> CFDictionaryRef #foreign corefoundation;
CFURLCreateResourcePropertyForKeyFromBookmarkData :: (allocator: CFAllocatorRef, resourcePropertyKey: CFStringRef, bookmark: CFDataRef) -> CFTypeRef #foreign corefoundation;
CFURLCreateBookmarkDataFromFile :: (allocator: CFAllocatorRef, fileURL: CFURLRef, errorRef: *CFErrorRef) -> CFDataRef #foreign corefoundation;
CFURLWriteBookmarkDataToFile :: (bookmarkRef: CFDataRef, fileURL: CFURLRef, options: CFURLBookmarkFileCreationOptions, errorRef: *CFErrorRef) -> Boolean #foreign corefoundation;
CFURLCreateBookmarkDataFromAliasRecord :: (allocatorRef: CFAllocatorRef, aliasRecordDataRef: CFDataRef) -> CFDataRef #foreign corefoundation;
CFURLStartAccessingSecurityScopedResource :: (url: CFURLRef) -> Boolean #foreign corefoundation;
CFURLStopAccessingSecurityScopedResource :: (url: CFURLRef) -> void #foreign corefoundation;
CFRunLoopMode :: CFStringRef;
__CFRunLoop :: struct {}
CFRunLoopRef :: *__CFRunLoop;
__CFRunLoopSource :: struct {}
CFRunLoopSourceRef :: *__CFRunLoopSource;
__CFRunLoopObserver :: struct {}
CFRunLoopObserverRef :: *__CFRunLoopObserver;
__CFRunLoopTimer :: struct {}
CFRunLoopTimerRef :: *__CFRunLoopTimer;

CFRunLoopRunResult :: enum s32 {
    Finished :: 1;
    Stopped :: 2;
    TimedOut :: 3;
    HandledSource :: 4;
    kCFRunLoopRunFinished :: Finished;
    kCFRunLoopRunStopped :: Stopped;
    kCFRunLoopRunTimedOut :: TimedOut;
    kCFRunLoopRunHandledSource :: HandledSource;
}

CFRunLoopActivity :: enum_flags CFOptionFlags {
    Entry :: 0x1;
    BeforeTimers :: 0x2;
    BeforeSources :: 0x4;
    BeforeWaiting :: 0x20;
    AfterWaiting :: 0x40;
    Exit :: 0x80;
    AllActivities :: 0xfffffff;
    kCFRunLoopEntry :: Entry;
    kCFRunLoopBeforeTimers :: BeforeTimers;
    kCFRunLoopBeforeSources :: BeforeSources;
    kCFRunLoopBeforeWaiting :: BeforeWaiting;
    kCFRunLoopAfterWaiting :: AfterWaiting;
    kCFRunLoopExit :: Exit;
    kCFRunLoopAllActivities :: AllActivities;
}

kCFRunLoopDefaultMode: CFRunLoopMode #elsewhere corefoundation;
kCFRunLoopCommonModes: CFRunLoopMode #elsewhere corefoundation;
CFRunLoopGetTypeID :: () -> CFTypeID #foreign corefoundation;
CFRunLoopGetCurrent :: () -> CFRunLoopRef #foreign corefoundation;
CFRunLoopGetMain :: () -> CFRunLoopRef #foreign corefoundation;
CFRunLoopCopyCurrentMode :: (rl: CFRunLoopRef) -> CFRunLoopMode #foreign corefoundation;
CFRunLoopCopyAllModes :: (rl: CFRunLoopRef) -> CFArrayRef #foreign corefoundation;
CFRunLoopAddCommonMode :: (rl: CFRunLoopRef, mode: CFRunLoopMode) -> void #foreign corefoundation;
CFRunLoopGetNextTimerFireDate :: (rl: CFRunLoopRef, mode: CFRunLoopMode) -> CFAbsoluteTime #foreign corefoundation;
CFRunLoopRun :: () -> void #foreign corefoundation;
CFRunLoopRunInMode :: (mode: CFRunLoopMode, seconds: CFTimeInterval, returnAfterSourceHandled: Boolean) -> CFRunLoopRunResult #foreign corefoundation;
CFRunLoopIsWaiting :: (rl: CFRunLoopRef) -> Boolean #foreign corefoundation;
CFRunLoopWakeUp :: (rl: CFRunLoopRef) -> void #foreign corefoundation;
CFRunLoopStop :: (rl: CFRunLoopRef) -> void #foreign corefoundation;
CFRunLoopPerformBlock :: (rl: CFRunLoopRef, mode: CFTypeRef, block: Block) -> void #foreign corefoundation;
CFRunLoopContainsSource :: (rl: CFRunLoopRef, source: CFRunLoopSourceRef, mode: CFRunLoopMode) -> Boolean #foreign corefoundation;
CFRunLoopAddSource :: (rl: CFRunLoopRef, source: CFRunLoopSourceRef, mode: CFRunLoopMode) -> void #foreign corefoundation;
CFRunLoopRemoveSource :: (rl: CFRunLoopRef, source: CFRunLoopSourceRef, mode: CFRunLoopMode) -> void #foreign corefoundation;
CFRunLoopContainsObserver :: (rl: CFRunLoopRef, observer: CFRunLoopObserverRef, mode: CFRunLoopMode) -> Boolean #foreign corefoundation;
CFRunLoopAddObserver :: (rl: CFRunLoopRef, observer: CFRunLoopObserverRef, mode: CFRunLoopMode) -> void #foreign corefoundation;
CFRunLoopRemoveObserver :: (rl: CFRunLoopRef, observer: CFRunLoopObserverRef, mode: CFRunLoopMode) -> void #foreign corefoundation;
CFRunLoopContainsTimer :: (rl: CFRunLoopRef, timer: CFRunLoopTimerRef, mode: CFRunLoopMode) -> Boolean #foreign corefoundation;
CFRunLoopAddTimer :: (rl: CFRunLoopRef, timer: CFRunLoopTimerRef, mode: CFRunLoopMode) -> void #foreign corefoundation;
CFRunLoopRemoveTimer :: (rl: CFRunLoopRef, timer: CFRunLoopTimerRef, mode: CFRunLoopMode) -> void #foreign corefoundation;

CFRunLoopSourceContext :: struct {
    version: CFIndex;
    info: *void;
    retain: #type (info: *void) -> *void #c_call;
    release: #type (info: *void) -> void #c_call;
    copyDescription: #type (info: *void) -> CFStringRef #c_call;
    equal: #type (info1: *void, info2: *void) -> Boolean #c_call;
    hash: #type (info: *void) -> CFHashCode #c_call;
    schedule: #type (info: *void, rl: CFRunLoopRef, mode: CFRunLoopMode) -> void #c_call;
    cancel: #type (info: *void, rl: CFRunLoopRef, mode: CFRunLoopMode) -> void #c_call;
    perform: #type (info: *void) -> void #c_call;
}

CFRunLoopSourceContext1 :: struct {
    version: CFIndex;
    info: *void;
    retain: #type (info: *void) -> *void #c_call;
    release: #type (info: *void) -> void #c_call;
    copyDescription: #type (info: *void) -> CFStringRef #c_call;
    equal: #type (info1: *void, info2: *void) -> Boolean #c_call;
    hash: #type (info: *void) -> CFHashCode #c_call;
    getPort: #type (info: *void) -> mach_port_t #c_call;
    perform: #type (msg: *void, size: CFIndex, allocator: CFAllocatorRef, info: *void) -> *void #c_call;
}

CFRunLoopSourceGetTypeID :: () -> CFTypeID #foreign corefoundation;
CFRunLoopSourceCreate :: (allocator: CFAllocatorRef, order: CFIndex, _context: *CFRunLoopSourceContext) -> CFRunLoopSourceRef #foreign corefoundation;
CFRunLoopSourceGetOrder :: (source: CFRunLoopSourceRef) -> CFIndex #foreign corefoundation;
CFRunLoopSourceInvalidate :: (source: CFRunLoopSourceRef) -> void #foreign corefoundation;
CFRunLoopSourceIsValid :: (source: CFRunLoopSourceRef) -> Boolean #foreign corefoundation;
CFRunLoopSourceGetContext :: (source: CFRunLoopSourceRef, _context: *CFRunLoopSourceContext) -> void #foreign corefoundation;
CFRunLoopSourceSignal :: (source: CFRunLoopSourceRef) -> void #foreign corefoundation;

CFRunLoopObserverContext :: struct {
    version: CFIndex;
    info: *void;
    retain: #type (info: *void) -> *void #c_call;
    release: #type (info: *void) -> void #c_call;
    copyDescription: #type (info: *void) -> CFStringRef #c_call;
}

CFRunLoopObserverCallBack :: #type (observer: CFRunLoopObserverRef, activity: CFRunLoopActivity, info: *void) -> void #c_call;
CFRunLoopObserverGetTypeID :: () -> CFTypeID #foreign corefoundation;
CFRunLoopObserverCreate :: (allocator: CFAllocatorRef, activities: CFOptionFlags, repeats: Boolean, order: CFIndex, callout: CFRunLoopObserverCallBack, _context: *CFRunLoopObserverContext) -> CFRunLoopObserverRef #foreign corefoundation;
CFRunLoopObserverCreateWithHandler :: (allocator: CFAllocatorRef, activities: CFOptionFlags, repeats: Boolean, order: CFIndex, block: Block) -> CFRunLoopObserverRef #foreign corefoundation;
CFRunLoopObserverGetActivities :: (observer: CFRunLoopObserverRef) -> CFOptionFlags #foreign corefoundation;
CFRunLoopObserverDoesRepeat :: (observer: CFRunLoopObserverRef) -> Boolean #foreign corefoundation;
CFRunLoopObserverGetOrder :: (observer: CFRunLoopObserverRef) -> CFIndex #foreign corefoundation;
CFRunLoopObserverInvalidate :: (observer: CFRunLoopObserverRef) -> void #foreign corefoundation;
CFRunLoopObserverIsValid :: (observer: CFRunLoopObserverRef) -> Boolean #foreign corefoundation;
CFRunLoopObserverGetContext :: (observer: CFRunLoopObserverRef, _context: *CFRunLoopObserverContext) -> void #foreign corefoundation;

CFRunLoopTimerContext :: struct {
    version: CFIndex;
    info: *void;
    retain: #type (info: *void) -> *void #c_call;
    release: #type (info: *void) -> void #c_call;
    copyDescription: #type (info: *void) -> CFStringRef #c_call;
}

CFRunLoopTimerCallBack :: #type (timer: CFRunLoopTimerRef, info: *void) -> void #c_call;
CFRunLoopTimerGetTypeID :: () -> CFTypeID #foreign corefoundation;
CFRunLoopTimerCreate :: (allocator: CFAllocatorRef, fireDate: CFAbsoluteTime, interval: CFTimeInterval, flags: CFOptionFlags, order: CFIndex, callout: CFRunLoopTimerCallBack, _context: *CFRunLoopTimerContext) -> CFRunLoopTimerRef #foreign corefoundation;
CFRunLoopTimerCreateWithHandler :: (allocator: CFAllocatorRef, fireDate: CFAbsoluteTime, interval: CFTimeInterval, flags: CFOptionFlags, order: CFIndex, block: Block) -> CFRunLoopTimerRef #foreign corefoundation;
CFRunLoopTimerGetNextFireDate :: (timer: CFRunLoopTimerRef) -> CFAbsoluteTime #foreign corefoundation;
CFRunLoopTimerSetNextFireDate :: (timer: CFRunLoopTimerRef, fireDate: CFAbsoluteTime) -> void #foreign corefoundation;
CFRunLoopTimerGetInterval :: (timer: CFRunLoopTimerRef) -> CFTimeInterval #foreign corefoundation;
CFRunLoopTimerDoesRepeat :: (timer: CFRunLoopTimerRef) -> Boolean #foreign corefoundation;
CFRunLoopTimerGetOrder :: (timer: CFRunLoopTimerRef) -> CFIndex #foreign corefoundation;
CFRunLoopTimerInvalidate :: (timer: CFRunLoopTimerRef) -> void #foreign corefoundation;
CFRunLoopTimerIsValid :: (timer: CFRunLoopTimerRef) -> Boolean #foreign corefoundation;
CFRunLoopTimerGetContext :: (timer: CFRunLoopTimerRef, _context: *CFRunLoopTimerContext) -> void #foreign corefoundation;
CFRunLoopTimerGetTolerance :: (timer: CFRunLoopTimerRef) -> CFTimeInterval #foreign corefoundation;
CFRunLoopTimerSetTolerance :: (timer: CFRunLoopTimerRef, tolerance: CFTimeInterval) -> void #foreign corefoundation;
__CFSocket :: struct {}
CFSocketRef :: *__CFSocket;
CFSocketError :: CFIndex;

kCFSocket :: enum s32 {
    Success :: 0;
    Error :: -1;
    Timeout :: -2;
    kCFSocketSuccess :: Success;
    kCFSocketError :: Error;
    kCFSocketTimeout :: Timeout;
}

CFSocketSignature :: struct {
    protocolFamily: s32;
    socketType: s32;
    protocol: s32;
    address: CFDataRef;
}

CFSocketCallBackType :: CFOptionFlags;

kCFSocket_1 :: enum u32 {
    NoCallBack :: 0;
    ReadCallBack :: 1;
    AcceptCallBack :: 2;
    DataCallBack :: 3;
    ConnectCallBack :: 4;
    WriteCallBack :: 8;
    kCFSocketNoCallBack :: NoCallBack;
    kCFSocketReadCallBack :: ReadCallBack;
    kCFSocketAcceptCallBack :: AcceptCallBack;
    kCFSocketDataCallBack :: DataCallBack;
    kCFSocketConnectCallBack :: ConnectCallBack;
    kCFSocketWriteCallBack :: WriteCallBack;
}

kCFSocket_2 :: enum u32 {
    AutomaticallyReenableReadCallBack :: 1;
    AutomaticallyReenableAcceptCallBack :: 2;
    AutomaticallyReenableDataCallBack :: 3;
    AutomaticallyReenableWriteCallBack :: 8;
    LeaveErrors :: 64;
    CloseOnInvalidate :: 128;
    kCFSocketAutomaticallyReenableReadCallBack :: AutomaticallyReenableReadCallBack;
    kCFSocketAutomaticallyReenableAcceptCallBack :: AutomaticallyReenableAcceptCallBack;
    kCFSocketAutomaticallyReenableDataCallBack :: AutomaticallyReenableDataCallBack;
    kCFSocketAutomaticallyReenableWriteCallBack :: AutomaticallyReenableWriteCallBack;
    kCFSocketLeaveErrors :: LeaveErrors;
    kCFSocketCloseOnInvalidate :: CloseOnInvalidate;
}

CFSocketCallBack :: #type (s: CFSocketRef, type: CFSocketCallBackType, address: CFDataRef, data: *void, info: *void) -> void #c_call;

CFSocketContext :: struct {
    version: CFIndex;
    info: *void;
    retain: #type (info: *void) -> *void #c_call;
    release: #type (info: *void) -> void #c_call;
    copyDescription: #type (info: *void) -> CFStringRef #c_call;
}

CFSocketNativeHandle :: s32;
CFSocketGetTypeID :: () -> CFTypeID #foreign corefoundation;
CFSocketCreate :: (allocator: CFAllocatorRef, protocolFamily: s32, socketType: s32, protocol: s32, callBackTypes: CFOptionFlags, callout: CFSocketCallBack, _context: *CFSocketContext) -> CFSocketRef #foreign corefoundation;
CFSocketCreateWithNative :: (allocator: CFAllocatorRef, sock: CFSocketNativeHandle, callBackTypes: CFOptionFlags, callout: CFSocketCallBack, _context: *CFSocketContext) -> CFSocketRef #foreign corefoundation;
CFSocketCreateWithSocketSignature :: (allocator: CFAllocatorRef, signature: *CFSocketSignature, callBackTypes: CFOptionFlags, callout: CFSocketCallBack, _context: *CFSocketContext) -> CFSocketRef #foreign corefoundation;
CFSocketCreateConnectedToSocketSignature :: (allocator: CFAllocatorRef, signature: *CFSocketSignature, callBackTypes: CFOptionFlags, callout: CFSocketCallBack, _context: *CFSocketContext, timeout: CFTimeInterval) -> CFSocketRef #foreign corefoundation;
CFSocketSetAddress :: (s: CFSocketRef, address: CFDataRef) -> CFSocketError #foreign corefoundation;
CFSocketConnectToAddress :: (s: CFSocketRef, address: CFDataRef, timeout: CFTimeInterval) -> CFSocketError #foreign corefoundation;
CFSocketInvalidate :: (s: CFSocketRef) -> void #foreign corefoundation;
CFSocketIsValid :: (s: CFSocketRef) -> Boolean #foreign corefoundation;
CFSocketCopyAddress :: (s: CFSocketRef) -> CFDataRef #foreign corefoundation;
CFSocketCopyPeerAddress :: (s: CFSocketRef) -> CFDataRef #foreign corefoundation;
CFSocketGetContext :: (s: CFSocketRef, _context: *CFSocketContext) -> void #foreign corefoundation;
CFSocketGetNative :: (s: CFSocketRef) -> CFSocketNativeHandle #foreign corefoundation;
CFSocketCreateRunLoopSource :: (allocator: CFAllocatorRef, s: CFSocketRef, order: CFIndex) -> CFRunLoopSourceRef #foreign corefoundation;
CFSocketGetSocketFlags :: (s: CFSocketRef) -> CFOptionFlags #foreign corefoundation;
CFSocketSetSocketFlags :: (s: CFSocketRef, flags: CFOptionFlags) -> void #foreign corefoundation;
CFSocketDisableCallBacks :: (s: CFSocketRef, callBackTypes: CFOptionFlags) -> void #foreign corefoundation;
CFSocketEnableCallBacks :: (s: CFSocketRef, callBackTypes: CFOptionFlags) -> void #foreign corefoundation;
CFSocketSendData :: (s: CFSocketRef, address: CFDataRef, data: CFDataRef, timeout: CFTimeInterval) -> CFSocketError #foreign corefoundation;
CFSocketRegisterValue :: (nameServerSignature: *CFSocketSignature, timeout: CFTimeInterval, name: CFStringRef, value: CFPropertyListRef) -> CFSocketError #foreign corefoundation;
CFSocketCopyRegisteredValue :: (nameServerSignature: *CFSocketSignature, timeout: CFTimeInterval, name: CFStringRef, value: *CFPropertyListRef, nameServerAddress: *CFDataRef) -> CFSocketError #foreign corefoundation;
CFSocketRegisterSocketSignature :: (nameServerSignature: *CFSocketSignature, timeout: CFTimeInterval, name: CFStringRef, signature: *CFSocketSignature) -> CFSocketError #foreign corefoundation;
CFSocketCopyRegisteredSocketSignature :: (nameServerSignature: *CFSocketSignature, timeout: CFTimeInterval, name: CFStringRef, signature: *CFSocketSignature, nameServerAddress: *CFDataRef) -> CFSocketError #foreign corefoundation;
CFSocketUnregister :: (nameServerSignature: *CFSocketSignature, timeout: CFTimeInterval, name: CFStringRef) -> CFSocketError #foreign corefoundation;
CFSocketSetDefaultNameRegistryPortNumber :: (port: u16) -> void #foreign corefoundation;
CFSocketGetDefaultNameRegistryPortNumber :: () -> u16 #foreign corefoundation;
kCFSocketCommandKey: CFStringRef #elsewhere corefoundation;
kCFSocketNameKey: CFStringRef #elsewhere corefoundation;
kCFSocketValueKey: CFStringRef #elsewhere corefoundation;
kCFSocketResultKey: CFStringRef #elsewhere corefoundation;
kCFSocketErrorKey: CFStringRef #elsewhere corefoundation;
kCFSocketRegisterCommand: CFStringRef #elsewhere corefoundation;
kCFSocketRetrieveCommand: CFStringRef #elsewhere corefoundation;
CFStreamPropertyKey :: CFStringRef;

CFStreamStatus :: enum CFIndex {
    NotOpen :: 0;
    Opening :: 1;
    Open :: 2;
    Reading :: 3;
    Writing :: 4;
    AtEnd :: 5;
    Closed :: 6;
    Error :: 7;
    kCFStreamStatusNotOpen :: NotOpen;
    kCFStreamStatusOpening :: Opening;
    kCFStreamStatusOpen :: Open;
    kCFStreamStatusReading :: Reading;
    kCFStreamStatusWriting :: Writing;
    kCFStreamStatusAtEnd :: AtEnd;
    kCFStreamStatusClosed :: Closed;
    kCFStreamStatusError :: Error;
}

CFStreamEventType :: CFOptionFlags;

kCFStreamEvent :: enum u32 {
    None :: 0;
    OpenCompleted :: 1;
    HasBytesAvailable :: 2;
    CanAcceptBytes :: 4;
    ErrorOccurred :: 8;
    EndEncountered :: 16;
    kCFStreamEventNone :: None;
    kCFStreamEventOpenCompleted :: OpenCompleted;
    kCFStreamEventHasBytesAvailable :: HasBytesAvailable;
    kCFStreamEventCanAcceptBytes :: CanAcceptBytes;
    kCFStreamEventErrorOccurred :: ErrorOccurred;
    kCFStreamEventEndEncountered :: EndEncountered;
}

CFStreamClientContext :: struct {
    version: CFIndex;
    info: *void;
    retain: #type (info: *void) -> *void #c_call;
    release: #type (info: *void) -> void #c_call;
    copyDescription: #type (info: *void) -> CFStringRef #c_call;
}

__CFReadStream :: struct {}
CFReadStreamRef :: *__CFReadStream;
__CFWriteStream :: struct {}
CFWriteStreamRef :: *__CFWriteStream;
CFReadStreamClientCallBack :: #type (stream: CFReadStreamRef, type: CFStreamEventType, clientCallBackInfo: *void) -> void #c_call;
CFWriteStreamClientCallBack :: #type (stream: CFWriteStreamRef, type: CFStreamEventType, clientCallBackInfo: *void) -> void #c_call;
CFReadStreamGetTypeID :: () -> CFTypeID #foreign corefoundation;
CFWriteStreamGetTypeID :: () -> CFTypeID #foreign corefoundation;
kCFStreamPropertyDataWritten: CFStreamPropertyKey #elsewhere corefoundation;
CFReadStreamCreateWithBytesNoCopy :: (alloc: CFAllocatorRef, bytes: *u8, length: CFIndex, bytesDeallocator: CFAllocatorRef) -> CFReadStreamRef #foreign corefoundation;
CFWriteStreamCreateWithBuffer :: (alloc: CFAllocatorRef, buffer: *u8, bufferCapacity: CFIndex) -> CFWriteStreamRef #foreign corefoundation;
CFWriteStreamCreateWithAllocatedBuffers :: (alloc: CFAllocatorRef, bufferAllocator: CFAllocatorRef) -> CFWriteStreamRef #foreign corefoundation;
CFReadStreamCreateWithFile :: (alloc: CFAllocatorRef, fileURL: CFURLRef) -> CFReadStreamRef #foreign corefoundation;
CFWriteStreamCreateWithFile :: (alloc: CFAllocatorRef, fileURL: CFURLRef) -> CFWriteStreamRef #foreign corefoundation;
CFStreamCreateBoundPair :: (alloc: CFAllocatorRef, readStream: *CFReadStreamRef, writeStream: *CFWriteStreamRef, transferBufferSize: CFIndex) -> void #foreign corefoundation;
kCFStreamPropertyAppendToFile: CFStreamPropertyKey #elsewhere corefoundation;
kCFStreamPropertyFileCurrentOffset: CFStreamPropertyKey #elsewhere corefoundation;
kCFStreamPropertySocketNativeHandle: CFStreamPropertyKey #elsewhere corefoundation;
kCFStreamPropertySocketRemoteHostName: CFStreamPropertyKey #elsewhere corefoundation;
kCFStreamPropertySocketRemotePortNumber: CFStreamPropertyKey #elsewhere corefoundation;
CFStreamCreatePairWithSocket :: (alloc: CFAllocatorRef, sock: CFSocketNativeHandle, readStream: *CFReadStreamRef, writeStream: *CFWriteStreamRef) -> void #foreign corefoundation;
CFStreamCreatePairWithSocketToHost :: (alloc: CFAllocatorRef, host: CFStringRef, port: u32, readStream: *CFReadStreamRef, writeStream: *CFWriteStreamRef) -> void #foreign corefoundation;
CFStreamCreatePairWithPeerSocketSignature :: (alloc: CFAllocatorRef, signature: *CFSocketSignature, readStream: *CFReadStreamRef, writeStream: *CFWriteStreamRef) -> void #foreign corefoundation;
CFReadStreamGetStatus :: (stream: CFReadStreamRef) -> CFStreamStatus #foreign corefoundation;
CFWriteStreamGetStatus :: (stream: CFWriteStreamRef) -> CFStreamStatus #foreign corefoundation;
CFReadStreamCopyError :: (stream: CFReadStreamRef) -> CFErrorRef #foreign corefoundation;
CFWriteStreamCopyError :: (stream: CFWriteStreamRef) -> CFErrorRef #foreign corefoundation;
CFReadStreamOpen :: (stream: CFReadStreamRef) -> Boolean #foreign corefoundation;
CFWriteStreamOpen :: (stream: CFWriteStreamRef) -> Boolean #foreign corefoundation;
CFReadStreamClose :: (stream: CFReadStreamRef) -> void #foreign corefoundation;
CFWriteStreamClose :: (stream: CFWriteStreamRef) -> void #foreign corefoundation;
CFReadStreamHasBytesAvailable :: (stream: CFReadStreamRef) -> Boolean #foreign corefoundation;
CFReadStreamRead :: (stream: CFReadStreamRef, buffer: *u8, bufferLength: CFIndex) -> CFIndex #foreign corefoundation;
CFReadStreamGetBuffer :: (stream: CFReadStreamRef, maxBytesToRead: CFIndex, numBytesRead: *CFIndex) -> *u8 #foreign corefoundation;
CFWriteStreamCanAcceptBytes :: (stream: CFWriteStreamRef) -> Boolean #foreign corefoundation;
CFWriteStreamWrite :: (stream: CFWriteStreamRef, buffer: *u8, bufferLength: CFIndex) -> CFIndex #foreign corefoundation;
CFReadStreamCopyProperty :: (stream: CFReadStreamRef, propertyName: CFStreamPropertyKey) -> CFTypeRef #foreign corefoundation;
CFWriteStreamCopyProperty :: (stream: CFWriteStreamRef, propertyName: CFStreamPropertyKey) -> CFTypeRef #foreign corefoundation;
CFReadStreamSetProperty :: (stream: CFReadStreamRef, propertyName: CFStreamPropertyKey, propertyValue: CFTypeRef) -> Boolean #foreign corefoundation;
CFWriteStreamSetProperty :: (stream: CFWriteStreamRef, propertyName: CFStreamPropertyKey, propertyValue: CFTypeRef) -> Boolean #foreign corefoundation;
CFReadStreamSetClient :: (stream: CFReadStreamRef, streamEvents: CFOptionFlags, clientCB: CFReadStreamClientCallBack, clientContext: *CFStreamClientContext) -> Boolean #foreign corefoundation;
CFWriteStreamSetClient :: (stream: CFWriteStreamRef, streamEvents: CFOptionFlags, clientCB: CFWriteStreamClientCallBack, clientContext: *CFStreamClientContext) -> Boolean #foreign corefoundation;
CFReadStreamScheduleWithRunLoop :: (stream: CFReadStreamRef, runLoop: CFRunLoopRef, runLoopMode: CFRunLoopMode) -> void #foreign corefoundation;
CFWriteStreamScheduleWithRunLoop :: (stream: CFWriteStreamRef, runLoop: CFRunLoopRef, runLoopMode: CFRunLoopMode) -> void #foreign corefoundation;
CFReadStreamUnscheduleFromRunLoop :: (stream: CFReadStreamRef, runLoop: CFRunLoopRef, runLoopMode: CFRunLoopMode) -> void #foreign corefoundation;
CFWriteStreamUnscheduleFromRunLoop :: (stream: CFWriteStreamRef, runLoop: CFRunLoopRef, runLoopMode: CFRunLoopMode) -> void #foreign corefoundation;
CFReadStreamSetDispatchQueue :: (stream: CFReadStreamRef, q: dispatch_queue_t) -> void #foreign corefoundation;
CFWriteStreamSetDispatchQueue :: (stream: CFWriteStreamRef, q: dispatch_queue_t) -> void #foreign corefoundation;
CFReadStreamCopyDispatchQueue :: (stream: CFReadStreamRef) -> dispatch_queue_t #foreign corefoundation;
CFWriteStreamCopyDispatchQueue :: (stream: CFWriteStreamRef) -> dispatch_queue_t #foreign corefoundation;

CFStreamErrorDomain :: enum CFIndex {
    Custom :: -1;
    POSIX :: 1;
    MacOSStatus :: 2;
    kCFStreamErrorDomainCustom :: Custom;
    kCFStreamErrorDomainPOSIX :: POSIX;
    kCFStreamErrorDomainMacOSStatus :: MacOSStatus;
}

CFStreamError :: struct {
    domain: CFIndex;
    error: s32;
}

CFReadStreamGetError :: (stream: CFReadStreamRef) -> CFStreamError #foreign corefoundation;
CFWriteStreamGetError :: (stream: CFWriteStreamRef) -> CFStreamError #foreign corefoundation;
CFPropertyListMutabilityOptions :: CFOptionFlags;

kCFPropertyList :: enum u32 {
    Immutable :: 0;
    MutableContainers :: 1;
    MutableContainersAndLeaves :: 2;
    kCFPropertyListImmutable :: Immutable;
    kCFPropertyListMutableContainers :: MutableContainers;
    kCFPropertyListMutableContainersAndLeaves :: MutableContainersAndLeaves;
}

CFPropertyListCreateFromXMLData :: (allocator: CFAllocatorRef, xmlData: CFDataRef, mutabilityOption: CFOptionFlags, errorString: *CFStringRef) -> CFPropertyListRef #foreign corefoundation;
CFPropertyListCreateXMLData :: (allocator: CFAllocatorRef, propertyList: CFPropertyListRef) -> CFDataRef #foreign corefoundation;
CFPropertyListCreateDeepCopy :: (allocator: CFAllocatorRef, propertyList: CFPropertyListRef, mutabilityOption: CFOptionFlags) -> CFPropertyListRef #foreign corefoundation;
CFPropertyListFormat :: CFIndex;

kCFPropertyList_1 :: enum u32 {
    OpenStepFormat :: 1;
    XMLFormat_v1_0 :: 100;
    BinaryFormat_v1_0 :: 200;
    kCFPropertyListOpenStepFormat :: OpenStepFormat;
    kCFPropertyListXMLFormat_v1_0 :: XMLFormat_v1_0;
    kCFPropertyListBinaryFormat_v1_0 :: BinaryFormat_v1_0;
}

CFPropertyListIsValid :: (plist: CFPropertyListRef, format: CFPropertyListFormat) -> Boolean #foreign corefoundation;
CFPropertyListWriteToStream :: (propertyList: CFPropertyListRef, stream: CFWriteStreamRef, format: CFPropertyListFormat, errorString: *CFStringRef) -> CFIndex #foreign corefoundation;
CFPropertyListCreateFromStream :: (allocator: CFAllocatorRef, stream: CFReadStreamRef, streamLength: CFIndex, mutabilityOption: CFOptionFlags, format: *CFPropertyListFormat, errorString: *CFStringRef) -> CFPropertyListRef #foreign corefoundation;

kCFPropertyList_2 :: enum u32 {
    ReadCorruptError :: 3840;
    ReadUnknownVersionError :: 3841;
    ReadStreamError :: 3842;
    WriteStreamError :: 3851;
    kCFPropertyListReadCorruptError :: ReadCorruptError;
    kCFPropertyListReadUnknownVersionError :: ReadUnknownVersionError;
    kCFPropertyListReadStreamError :: ReadStreamError;
    kCFPropertyListWriteStreamError :: WriteStreamError;
}

CFPropertyListCreateWithData :: (allocator: CFAllocatorRef, data: CFDataRef, options: CFOptionFlags, format: *CFPropertyListFormat, error: *CFErrorRef) -> CFPropertyListRef #foreign corefoundation;
CFPropertyListCreateWithStream :: (allocator: CFAllocatorRef, stream: CFReadStreamRef, streamLength: CFIndex, options: CFOptionFlags, format: *CFPropertyListFormat, error: *CFErrorRef) -> CFPropertyListRef #foreign corefoundation;
CFPropertyListWrite :: (propertyList: CFPropertyListRef, stream: CFWriteStreamRef, format: CFPropertyListFormat, options: CFOptionFlags, error: *CFErrorRef) -> CFIndex #foreign corefoundation;
CFPropertyListCreateData :: (allocator: CFAllocatorRef, propertyList: CFPropertyListRef, format: CFPropertyListFormat, options: CFOptionFlags, error: *CFErrorRef) -> CFDataRef #foreign corefoundation;
__CFSet :: struct {}
CFMutableSetRef :: *__CFSet;
CFStringEncodings :: CFIndex;

kCFStringEncoding_1 :: enum u32 {
    MacJapanese :: 1;
    MacChineseTrad :: 2;
    MacKorean :: 3;
    MacArabic :: 4;
    MacHebrew :: 5;
    MacGreek :: 6;
    MacCyrillic :: 7;
    MacDevanagari :: 9;
    MacGurmukhi :: 10;
    MacGujarati :: 11;
    MacOriya :: 12;
    MacBengali :: 13;
    MacTamil :: 14;
    MacTelugu :: 15;
    MacKannada :: 16;
    MacMalayalam :: 17;
    MacSinhalese :: 18;
    MacBurmese :: 19;
    MacKhmer :: 20;
    MacThai :: 21;
    MacLaotian :: 22;
    MacGeorgian :: 23;
    MacArmenian :: 24;
    MacChineseSimp :: 25;
    MacTibetan :: 26;
    MacMongolian :: 27;
    MacEthiopic :: 28;
    MacCentralEurRoman :: 29;
    MacVietnamese :: 30;
    MacExtArabic :: 31;
    MacSymbol :: 33;
    MacDingbats :: 34;
    MacTurkish :: 35;
    MacCroatian :: 36;
    MacIcelandic :: 37;
    MacRomanian :: 38;
    MacCeltic :: 39;
    MacGaelic :: 40;
    MacFarsi :: 140;
    MacUkrainian :: 152;
    MacInuit :: 236;
    MacVT100 :: 252;
    MacHFS :: 255;
    ISOLatin2 :: 514;
    ISOLatin3 :: 515;
    ISOLatin4 :: 516;
    ISOLatinCyrillic :: 517;
    ISOLatinArabic :: 518;
    ISOLatinGreek :: 519;
    ISOLatinHebrew :: 520;
    ISOLatin5 :: 521;
    ISOLatin6 :: 522;
    ISOLatinThai :: 523;
    ISOLatin7 :: 525;
    ISOLatin8 :: 526;
    ISOLatin9 :: 527;
    ISOLatin10 :: 528;
    DOSLatinUS :: 1024;
    DOSGreek :: 1029;
    DOSBalticRim :: 1030;
    DOSLatin1 :: 1040;
    DOSGreek1 :: 1041;
    DOSLatin2 :: 1042;
    DOSCyrillic :: 1043;
    DOSTurkish :: 1044;
    DOSPortuguese :: 1045;
    DOSIcelandic :: 1046;
    DOSHebrew :: 1047;
    DOSCanadianFrench :: 1048;
    DOSArabic :: 1049;
    DOSNordic :: 1050;
    DOSRussian :: 1051;
    DOSGreek2 :: 1052;
    DOSThai :: 1053;
    DOSJapanese :: 1056;
    DOSChineseSimplif :: 1057;
    DOSKorean :: 1058;
    DOSChineseTrad :: 1059;
    WindowsLatin2 :: 1281;
    WindowsCyrillic :: 1282;
    WindowsGreek :: 1283;
    WindowsLatin5 :: 1284;
    WindowsHebrew :: 1285;
    WindowsArabic :: 1286;
    WindowsBalticRim :: 1287;
    WindowsVietnamese :: 1288;
    WindowsKoreanJohab :: 1296;
    ANSEL :: 1537;
    JIS_X0201_76 :: 1568;
    JIS_X0208_83 :: 1569;
    JIS_X0208_90 :: 1570;
    JIS_X0212_90 :: 1571;
    JIS_C6226_78 :: 1572;
    ShiftJIS_X0213 :: 1576;
    ShiftJIS_X0213_MenKuTen :: 1577;
    GB_2312_80 :: 1584;
    GBK_95 :: 1585;
    GB_18030_2000 :: 1586;
    KSC_5601_87 :: 1600;
    KSC_5601_92_Johab :: 1601;
    CNS_11643_92_P1 :: 1617;
    CNS_11643_92_P2 :: 1618;
    CNS_11643_92_P3 :: 1619;
    ISO_2022_JP :: 2080;
    ISO_2022_JP_2 :: 2081;
    ISO_2022_JP_1 :: 2082;
    ISO_2022_JP_3 :: 2083;
    ISO_2022_CN :: 2096;
    ISO_2022_CN_EXT :: 2097;
    ISO_2022_KR :: 2112;
    EUC_JP :: 2336;
    EUC_CN :: 2352;
    EUC_TW :: 2353;
    EUC_KR :: 2368;
    ShiftJIS :: 2561;
    KOI8_R :: 2562;
    Big5 :: 2563;
    MacRomanLatin1 :: 2564;
    HZ_GB_2312 :: 2565;
    Big5_HKSCS_1999 :: 2566;
    VISCII :: 2567;
    KOI8_U :: 2568;
    Big5_E :: 2569;
    NextStepJapanese :: 2818;
    EBCDIC_US :: 3073;
    EBCDIC_CP037 :: 3074;
    UTF7 :: 67109120;
    UTF7_IMAP :: 2576;
    ShiftJIS_X0213_00 :: 1576;
    kCFStringEncodingMacJapanese :: MacJapanese;
    kCFStringEncodingMacChineseTrad :: MacChineseTrad;
    kCFStringEncodingMacKorean :: MacKorean;
    kCFStringEncodingMacArabic :: MacArabic;
    kCFStringEncodingMacHebrew :: MacHebrew;
    kCFStringEncodingMacGreek :: MacGreek;
    kCFStringEncodingMacCyrillic :: MacCyrillic;
    kCFStringEncodingMacDevanagari :: MacDevanagari;
    kCFStringEncodingMacGurmukhi :: MacGurmukhi;
    kCFStringEncodingMacGujarati :: MacGujarati;
    kCFStringEncodingMacOriya :: MacOriya;
    kCFStringEncodingMacBengali :: MacBengali;
    kCFStringEncodingMacTamil :: MacTamil;
    kCFStringEncodingMacTelugu :: MacTelugu;
    kCFStringEncodingMacKannada :: MacKannada;
    kCFStringEncodingMacMalayalam :: MacMalayalam;
    kCFStringEncodingMacSinhalese :: MacSinhalese;
    kCFStringEncodingMacBurmese :: MacBurmese;
    kCFStringEncodingMacKhmer :: MacKhmer;
    kCFStringEncodingMacThai :: MacThai;
    kCFStringEncodingMacLaotian :: MacLaotian;
    kCFStringEncodingMacGeorgian :: MacGeorgian;
    kCFStringEncodingMacArmenian :: MacArmenian;
    kCFStringEncodingMacChineseSimp :: MacChineseSimp;
    kCFStringEncodingMacTibetan :: MacTibetan;
    kCFStringEncodingMacMongolian :: MacMongolian;
    kCFStringEncodingMacEthiopic :: MacEthiopic;
    kCFStringEncodingMacCentralEurRoman :: MacCentralEurRoman;
    kCFStringEncodingMacVietnamese :: MacVietnamese;
    kCFStringEncodingMacExtArabic :: MacExtArabic;
    kCFStringEncodingMacSymbol :: MacSymbol;
    kCFStringEncodingMacDingbats :: MacDingbats;
    kCFStringEncodingMacTurkish :: MacTurkish;
    kCFStringEncodingMacCroatian :: MacCroatian;
    kCFStringEncodingMacIcelandic :: MacIcelandic;
    kCFStringEncodingMacRomanian :: MacRomanian;
    kCFStringEncodingMacCeltic :: MacCeltic;
    kCFStringEncodingMacGaelic :: MacGaelic;
    kCFStringEncodingMacFarsi :: MacFarsi;
    kCFStringEncodingMacUkrainian :: MacUkrainian;
    kCFStringEncodingMacInuit :: MacInuit;
    kCFStringEncodingMacVT100 :: MacVT100;
    kCFStringEncodingMacHFS :: MacHFS;
    kCFStringEncodingISOLatin2 :: ISOLatin2;
    kCFStringEncodingISOLatin3 :: ISOLatin3;
    kCFStringEncodingISOLatin4 :: ISOLatin4;
    kCFStringEncodingISOLatinCyrillic :: ISOLatinCyrillic;
    kCFStringEncodingISOLatinArabic :: ISOLatinArabic;
    kCFStringEncodingISOLatinGreek :: ISOLatinGreek;
    kCFStringEncodingISOLatinHebrew :: ISOLatinHebrew;
    kCFStringEncodingISOLatin5 :: ISOLatin5;
    kCFStringEncodingISOLatin6 :: ISOLatin6;
    kCFStringEncodingISOLatinThai :: ISOLatinThai;
    kCFStringEncodingISOLatin7 :: ISOLatin7;
    kCFStringEncodingISOLatin8 :: ISOLatin8;
    kCFStringEncodingISOLatin9 :: ISOLatin9;
    kCFStringEncodingISOLatin10 :: ISOLatin10;
    kCFStringEncodingDOSLatinUS :: DOSLatinUS;
    kCFStringEncodingDOSGreek :: DOSGreek;
    kCFStringEncodingDOSBalticRim :: DOSBalticRim;
    kCFStringEncodingDOSLatin1 :: DOSLatin1;
    kCFStringEncodingDOSGreek1 :: DOSGreek1;
    kCFStringEncodingDOSLatin2 :: DOSLatin2;
    kCFStringEncodingDOSCyrillic :: DOSCyrillic;
    kCFStringEncodingDOSTurkish :: DOSTurkish;
    kCFStringEncodingDOSPortuguese :: DOSPortuguese;
    kCFStringEncodingDOSIcelandic :: DOSIcelandic;
    kCFStringEncodingDOSHebrew :: DOSHebrew;
    kCFStringEncodingDOSCanadianFrench :: DOSCanadianFrench;
    kCFStringEncodingDOSArabic :: DOSArabic;
    kCFStringEncodingDOSNordic :: DOSNordic;
    kCFStringEncodingDOSRussian :: DOSRussian;
    kCFStringEncodingDOSGreek2 :: DOSGreek2;
    kCFStringEncodingDOSThai :: DOSThai;
    kCFStringEncodingDOSJapanese :: DOSJapanese;
    kCFStringEncodingDOSChineseSimplif :: DOSChineseSimplif;
    kCFStringEncodingDOSKorean :: DOSKorean;
    kCFStringEncodingDOSChineseTrad :: DOSChineseTrad;
    kCFStringEncodingWindowsLatin2 :: WindowsLatin2;
    kCFStringEncodingWindowsCyrillic :: WindowsCyrillic;
    kCFStringEncodingWindowsGreek :: WindowsGreek;
    kCFStringEncodingWindowsLatin5 :: WindowsLatin5;
    kCFStringEncodingWindowsHebrew :: WindowsHebrew;
    kCFStringEncodingWindowsArabic :: WindowsArabic;
    kCFStringEncodingWindowsBalticRim :: WindowsBalticRim;
    kCFStringEncodingWindowsVietnamese :: WindowsVietnamese;
    kCFStringEncodingWindowsKoreanJohab :: WindowsKoreanJohab;
    kCFStringEncodingANSEL :: ANSEL;
    kCFStringEncodingJIS_X0201_76 :: JIS_X0201_76;
    kCFStringEncodingJIS_X0208_83 :: JIS_X0208_83;
    kCFStringEncodingJIS_X0208_90 :: JIS_X0208_90;
    kCFStringEncodingJIS_X0212_90 :: JIS_X0212_90;
    kCFStringEncodingJIS_C6226_78 :: JIS_C6226_78;
    kCFStringEncodingShiftJIS_X0213 :: ShiftJIS_X0213;
    kCFStringEncodingShiftJIS_X0213_MenKuTen :: ShiftJIS_X0213_MenKuTen;
    kCFStringEncodingGB_2312_80 :: GB_2312_80;
    kCFStringEncodingGBK_95 :: GBK_95;
    kCFStringEncodingGB_18030_2000 :: GB_18030_2000;
    kCFStringEncodingKSC_5601_87 :: KSC_5601_87;
    kCFStringEncodingKSC_5601_92_Johab :: KSC_5601_92_Johab;
    kCFStringEncodingCNS_11643_92_P1 :: CNS_11643_92_P1;
    kCFStringEncodingCNS_11643_92_P2 :: CNS_11643_92_P2;
    kCFStringEncodingCNS_11643_92_P3 :: CNS_11643_92_P3;
    kCFStringEncodingISO_2022_JP :: ISO_2022_JP;
    kCFStringEncodingISO_2022_JP_2 :: ISO_2022_JP_2;
    kCFStringEncodingISO_2022_JP_1 :: ISO_2022_JP_1;
    kCFStringEncodingISO_2022_JP_3 :: ISO_2022_JP_3;
    kCFStringEncodingISO_2022_CN :: ISO_2022_CN;
    kCFStringEncodingISO_2022_CN_EXT :: ISO_2022_CN_EXT;
    kCFStringEncodingISO_2022_KR :: ISO_2022_KR;
    kCFStringEncodingEUC_JP :: EUC_JP;
    kCFStringEncodingEUC_CN :: EUC_CN;
    kCFStringEncodingEUC_TW :: EUC_TW;
    kCFStringEncodingEUC_KR :: EUC_KR;
    kCFStringEncodingShiftJIS :: ShiftJIS;
    kCFStringEncodingKOI8_R :: KOI8_R;
    kCFStringEncodingBig5 :: Big5;
    kCFStringEncodingMacRomanLatin1 :: MacRomanLatin1;
    kCFStringEncodingHZ_GB_2312 :: HZ_GB_2312;
    kCFStringEncodingBig5_HKSCS_1999 :: Big5_HKSCS_1999;
    kCFStringEncodingVISCII :: VISCII;
    kCFStringEncodingKOI8_U :: KOI8_U;
    kCFStringEncodingBig5_E :: Big5_E;
    kCFStringEncodingNextStepJapanese :: NextStepJapanese;
    kCFStringEncodingEBCDIC_US :: EBCDIC_US;
    kCFStringEncodingEBCDIC_CP037 :: EBCDIC_CP037;
    kCFStringEncodingUTF7 :: UTF7;
    kCFStringEncodingUTF7_IMAP :: UTF7_IMAP;
    kCFStringEncodingShiftJIS_X0213_00 :: ShiftJIS_X0213_00;
}

__CFTree :: struct {}
CFURLCreateDataAndPropertiesFromResource :: (alloc: CFAllocatorRef, url: CFURLRef, resourceData: *CFDataRef, properties: *CFDictionaryRef, desiredProperties: CFArrayRef, errorCode: *s32) -> Boolean #foreign corefoundation;
CFURLWriteDataAndPropertiesToResource :: (url: CFURLRef, dataToWrite: CFDataRef, propertiesToWrite: CFDictionaryRef, errorCode: *s32) -> Boolean #foreign corefoundation;
CFURLDestroyResource :: (url: CFURLRef, errorCode: *s32) -> Boolean #foreign corefoundation;
CFURLCreatePropertyFromResource :: (alloc: CFAllocatorRef, url: CFURLRef, property: CFStringRef, errorCode: *s32) -> CFTypeRef #foreign corefoundation;
CFURLError :: CFIndex;

kCFURL_1 :: enum s32 {
    UnknownError :: -10;
    UnknownSchemeError :: -11;
    ResourceNotFoundError :: -12;
    ResourceAccessViolationError :: -13;
    RemoteHostUnavailableError :: -14;
    ImproperArgumentsError :: -15;
    UnknownPropertyKeyError :: -16;
    PropertyKeyUnavailableError :: -17;
    TimeoutError :: -18;
    kCFURLUnknownError :: UnknownError;
    kCFURLUnknownSchemeError :: UnknownSchemeError;
    kCFURLResourceNotFoundError :: ResourceNotFoundError;
    kCFURLResourceAccessViolationError :: ResourceAccessViolationError;
    kCFURLRemoteHostUnavailableError :: RemoteHostUnavailableError;
    kCFURLImproperArgumentsError :: ImproperArgumentsError;
    kCFURLUnknownPropertyKeyError :: UnknownPropertyKeyError;
    kCFURLPropertyKeyUnavailableError :: PropertyKeyUnavailableError;
    kCFURLTimeoutError :: TimeoutError;
}

kCFURLFileExists: CFStringRef #elsewhere corefoundation;
kCFURLFileDirectoryContents: CFStringRef #elsewhere corefoundation;
kCFURLFileLength: CFStringRef #elsewhere corefoundation;
kCFURLFileLastModificationTime: CFStringRef #elsewhere corefoundation;
kCFURLFilePOSIXMode: CFStringRef #elsewhere corefoundation;
kCFURLFileOwnerID: CFStringRef #elsewhere corefoundation;
kCFURLHTTPStatusCode: CFStringRef #elsewhere corefoundation;
kCFURLHTTPStatusLine: CFStringRef #elsewhere corefoundation;
__CFUUID :: struct {}
CFUUIDRef :: *__CFUUID;

CFUUIDBytes :: struct {
    byte0: u8;
    byte1: u8;
    byte2: u8;
    byte3: u8;
    byte4: u8;
    byte5: u8;
    byte6: u8;
    byte7: u8;
    byte8: u8;
    byte9: u8;
    byte10: u8;
    byte11: u8;
    byte12: u8;
    byte13: u8;
    byte14: u8;
    byte15: u8;
}

CFUUIDGetTypeID :: () -> CFTypeID #foreign corefoundation;
CFUUIDCreate :: (alloc: CFAllocatorRef) -> CFUUIDRef #foreign corefoundation;
CFUUIDCreateWithBytes :: (alloc: CFAllocatorRef, byte0: u8, byte1: u8, byte2: u8, byte3: u8, byte4: u8, byte5: u8, byte6: u8, byte7: u8, byte8: u8, byte9: u8, byte10: u8, byte11: u8, byte12: u8, byte13: u8, byte14: u8, byte15: u8) -> CFUUIDRef #foreign corefoundation;
CFUUIDCreateFromString :: (alloc: CFAllocatorRef, uuidStr: CFStringRef) -> CFUUIDRef #foreign corefoundation;
CFUUIDCreateString :: (alloc: CFAllocatorRef, uuid: CFUUIDRef) -> CFStringRef #foreign corefoundation;
CFUUIDGetConstantUUIDWithBytes :: (alloc: CFAllocatorRef, byte0: u8, byte1: u8, byte2: u8, byte3: u8, byte4: u8, byte5: u8, byte6: u8, byte7: u8, byte8: u8, byte9: u8, byte10: u8, byte11: u8, byte12: u8, byte13: u8, byte14: u8, byte15: u8) -> CFUUIDRef #foreign corefoundation;
CFUUIDGetUUIDBytes :: (uuid: CFUUIDRef) -> CFUUIDBytes #foreign corefoundation;
CFUUIDCreateFromUUIDBytes :: (alloc: CFAllocatorRef, bytes: CFUUIDBytes) -> CFUUIDRef #foreign corefoundation;
__CFBundle :: struct {}
CFBundleRef :: *__CFBundle;
CFPlugInRef :: *__CFBundle;
kCFBundleInfoDictionaryVersionKey: CFStringRef #elsewhere corefoundation;
kCFBundleExecutableKey: CFStringRef #elsewhere corefoundation;
kCFBundleIdentifierKey: CFStringRef #elsewhere corefoundation;
kCFBundleVersionKey: CFStringRef #elsewhere corefoundation;
kCFBundleDevelopmentRegionKey: CFStringRef #elsewhere corefoundation;
kCFBundleNameKey: CFStringRef #elsewhere corefoundation;
kCFBundleLocalizationsKey: CFStringRef #elsewhere corefoundation;
CFBundleGetMainBundle :: () -> CFBundleRef #foreign corefoundation;
CFBundleGetBundleWithIdentifier :: (bundleID: CFStringRef) -> CFBundleRef #foreign corefoundation;
CFBundleGetAllBundles :: () -> CFArrayRef #foreign corefoundation;
CFBundleGetTypeID :: () -> CFTypeID #foreign corefoundation;
CFBundleCreate :: (allocator: CFAllocatorRef, bundleURL: CFURLRef) -> CFBundleRef #foreign corefoundation;
CFBundleCreateBundlesFromDirectory :: (allocator: CFAllocatorRef, directoryURL: CFURLRef, bundleType: CFStringRef) -> CFArrayRef #foreign corefoundation;
CFBundleCopyBundleURL :: (bundle: CFBundleRef) -> CFURLRef #foreign corefoundation;
CFBundleGetValueForInfoDictionaryKey :: (bundle: CFBundleRef, key: CFStringRef) -> CFTypeRef #foreign corefoundation;
CFBundleGetInfoDictionary :: (bundle: CFBundleRef) -> CFDictionaryRef #foreign corefoundation;
CFBundleGetLocalInfoDictionary :: (bundle: CFBundleRef) -> CFDictionaryRef #foreign corefoundation;
CFBundleGetPackageInfo :: (bundle: CFBundleRef, packageType: *u32, packageCreator: *u32) -> void #foreign corefoundation;
CFBundleGetIdentifier :: (bundle: CFBundleRef) -> CFStringRef #foreign corefoundation;
CFBundleGetVersionNumber :: (bundle: CFBundleRef) -> u32 #foreign corefoundation;
CFBundleGetDevelopmentRegion :: (bundle: CFBundleRef) -> CFStringRef #foreign corefoundation;
CFBundleCopySupportFilesDirectoryURL :: (bundle: CFBundleRef) -> CFURLRef #foreign corefoundation;
CFBundleCopyResourcesDirectoryURL :: (bundle: CFBundleRef) -> CFURLRef #foreign corefoundation;
CFBundleCopyPrivateFrameworksURL :: (bundle: CFBundleRef) -> CFURLRef #foreign corefoundation;
CFBundleCopySharedFrameworksURL :: (bundle: CFBundleRef) -> CFURLRef #foreign corefoundation;
CFBundleCopySharedSupportURL :: (bundle: CFBundleRef) -> CFURLRef #foreign corefoundation;
CFBundleCopyBuiltInPlugInsURL :: (bundle: CFBundleRef) -> CFURLRef #foreign corefoundation;
CFBundleCopyInfoDictionaryInDirectory :: (bundleURL: CFURLRef) -> CFDictionaryRef #foreign corefoundation;
CFBundleGetPackageInfoInDirectory :: (url: CFURLRef, packageType: *u32, packageCreator: *u32) -> Boolean #foreign corefoundation;
CFBundleCopyResourceURL :: (bundle: CFBundleRef, resourceName: CFStringRef, resourceType: CFStringRef, subDirName: CFStringRef) -> CFURLRef #foreign corefoundation;
CFBundleCopyResourceURLsOfType :: (bundle: CFBundleRef, resourceType: CFStringRef, subDirName: CFStringRef) -> CFArrayRef #foreign corefoundation;
CFBundleCopyLocalizedString :: (bundle: CFBundleRef, key: CFStringRef, value: CFStringRef, tableName: CFStringRef) -> CFStringRef #foreign corefoundation;
CFBundleCopyResourceURLInDirectory :: (bundleURL: CFURLRef, resourceName: CFStringRef, resourceType: CFStringRef, subDirName: CFStringRef) -> CFURLRef #foreign corefoundation;
CFBundleCopyResourceURLsOfTypeInDirectory :: (bundleURL: CFURLRef, resourceType: CFStringRef, subDirName: CFStringRef) -> CFArrayRef #foreign corefoundation;
CFBundleCopyBundleLocalizations :: (bundle: CFBundleRef) -> CFArrayRef #foreign corefoundation;
CFBundleCopyPreferredLocalizationsFromArray :: (locArray: CFArrayRef) -> CFArrayRef #foreign corefoundation;
CFBundleCopyLocalizationsForPreferences :: (locArray: CFArrayRef, prefArray: CFArrayRef) -> CFArrayRef #foreign corefoundation;
CFBundleCopyResourceURLForLocalization :: (bundle: CFBundleRef, resourceName: CFStringRef, resourceType: CFStringRef, subDirName: CFStringRef, localizationName: CFStringRef) -> CFURLRef #foreign corefoundation;
CFBundleCopyResourceURLsOfTypeForLocalization :: (bundle: CFBundleRef, resourceType: CFStringRef, subDirName: CFStringRef, localizationName: CFStringRef) -> CFArrayRef #foreign corefoundation;
CFBundleCopyInfoDictionaryForURL :: (url: CFURLRef) -> CFDictionaryRef #foreign corefoundation;
CFBundleCopyLocalizationsForURL :: (url: CFURLRef) -> CFArrayRef #foreign corefoundation;
CFBundleCopyExecutableArchitecturesForURL :: (url: CFURLRef) -> CFArrayRef #foreign corefoundation;
CFBundleCopyExecutableURL :: (bundle: CFBundleRef) -> CFURLRef #foreign corefoundation;

kCFBundleExecutableArchitecture :: enum u32 {
    I386 :: 7;
    PPC :: 18;
    X86_64 :: 16777223;
    PPC64 :: 16777234;
    kCFBundleExecutableArchitectureI386 :: I386;
    kCFBundleExecutableArchitecturePPC :: PPC;
    kCFBundleExecutableArchitectureX86_64 :: X86_64;
    kCFBundleExecutableArchitecturePPC64 :: PPC64;
}

CFBundleCopyExecutableArchitectures :: (bundle: CFBundleRef) -> CFArrayRef #foreign corefoundation;
CFBundlePreflightExecutable :: (bundle: CFBundleRef, error: *CFErrorRef) -> Boolean #foreign corefoundation;
CFBundleLoadExecutableAndReturnError :: (bundle: CFBundleRef, error: *CFErrorRef) -> Boolean #foreign corefoundation;
CFBundleLoadExecutable :: (bundle: CFBundleRef) -> Boolean #foreign corefoundation;
CFBundleIsExecutableLoaded :: (bundle: CFBundleRef) -> Boolean #foreign corefoundation;
CFBundleUnloadExecutable :: (bundle: CFBundleRef) -> void #foreign corefoundation;
CFBundleGetFunctionPointerForName :: (bundle: CFBundleRef, functionName: CFStringRef) -> *void #foreign corefoundation;
CFBundleGetFunctionPointersForNames :: (bundle: CFBundleRef, functionNames: CFArrayRef, ftbl: **void) -> void #foreign corefoundation;
CFBundleGetDataPointerForName :: (bundle: CFBundleRef, symbolName: CFStringRef) -> *void #foreign corefoundation;
CFBundleGetDataPointersForNames :: (bundle: CFBundleRef, symbolNames: CFArrayRef, stbl: **void) -> void #foreign corefoundation;
CFBundleCopyAuxiliaryExecutableURL :: (bundle: CFBundleRef, executableName: CFStringRef) -> CFURLRef #foreign corefoundation;
CFBundleGetPlugIn :: (bundle: CFBundleRef) -> CFPlugInRef #foreign corefoundation;
CFBundleRefNum :: s32;
CFBundleOpenBundleResourceMap :: (bundle: CFBundleRef) -> CFBundleRefNum #foreign corefoundation;
CFBundleOpenBundleResourceFiles :: (bundle: CFBundleRef, refNum: *CFBundleRefNum, localizedRefNum: *CFBundleRefNum) -> s32 #foreign corefoundation;
CFBundleCloseBundleResourceMap :: (bundle: CFBundleRef, refNum: CFBundleRefNum) -> void #foreign corefoundation;
__CFMessagePort :: struct {}
CFMessagePortRef :: *__CFMessagePort;

kCFMessagePort :: enum s32 {
    Success :: 0;
    SendTimeout :: -1;
    ReceiveTimeout :: -2;
    IsInvalid :: -3;
    TransportError :: -4;
    BecameInvalidError :: -5;
    kCFMessagePortSuccess :: Success;
    kCFMessagePortSendTimeout :: SendTimeout;
    kCFMessagePortReceiveTimeout :: ReceiveTimeout;
    kCFMessagePortIsInvalid :: IsInvalid;
    kCFMessagePortTransportError :: TransportError;
    kCFMessagePortBecameInvalidError :: BecameInvalidError;
}

CFMessagePortContext :: struct {
    version: CFIndex;
    info: *void;
    retain: #type (info: *void) -> *void #c_call;
    release: #type (info: *void) -> void #c_call;
    copyDescription: #type (info: *void) -> CFStringRef #c_call;
}

CFMessagePortCallBack :: #type (local: CFMessagePortRef, msgid: s32, data: CFDataRef, info: *void) -> CFDataRef #c_call;
CFMessagePortInvalidationCallBack :: #type (ms: CFMessagePortRef, info: *void) -> void #c_call;
CFMessagePortGetTypeID :: () -> CFTypeID #foreign corefoundation;
CFMessagePortCreateLocal :: (allocator: CFAllocatorRef, name: CFStringRef, callout: CFMessagePortCallBack, _context: *CFMessagePortContext, shouldFreeInfo: *Boolean) -> CFMessagePortRef #foreign corefoundation;
CFMessagePortCreateRemote :: (allocator: CFAllocatorRef, name: CFStringRef) -> CFMessagePortRef #foreign corefoundation;
CFMessagePortIsRemote :: (ms: CFMessagePortRef) -> Boolean #foreign corefoundation;
CFMessagePortGetName :: (ms: CFMessagePortRef) -> CFStringRef #foreign corefoundation;
CFMessagePortSetName :: (ms: CFMessagePortRef, newName: CFStringRef) -> Boolean #foreign corefoundation;
CFMessagePortGetContext :: (ms: CFMessagePortRef, _context: *CFMessagePortContext) -> void #foreign corefoundation;
CFMessagePortInvalidate :: (ms: CFMessagePortRef) -> void #foreign corefoundation;
CFMessagePortIsValid :: (ms: CFMessagePortRef) -> Boolean #foreign corefoundation;
CFMessagePortGetInvalidationCallBack :: (ms: CFMessagePortRef) -> CFMessagePortInvalidationCallBack #foreign corefoundation;
CFMessagePortSetInvalidationCallBack :: (ms: CFMessagePortRef, callout: CFMessagePortInvalidationCallBack) -> void #foreign corefoundation;
CFMessagePortSendRequest :: (remote: CFMessagePortRef, msgid: s32, data: CFDataRef, sendTimeout: CFTimeInterval, rcvTimeout: CFTimeInterval, replyMode: CFStringRef, returnData: *CFDataRef) -> s32 #foreign corefoundation;
CFMessagePortCreateRunLoopSource :: (allocator: CFAllocatorRef, local: CFMessagePortRef, order: CFIndex) -> CFRunLoopSourceRef #foreign corefoundation;
CFMessagePortSetDispatchQueue :: (ms: CFMessagePortRef, queue: dispatch_queue_t) -> void #foreign corefoundation;
kCFPlugInDynamicRegistrationKey: CFStringRef #elsewhere corefoundation;
kCFPlugInDynamicRegisterFunctionKey: CFStringRef #elsewhere corefoundation;
kCFPlugInUnloadFunctionKey: CFStringRef #elsewhere corefoundation;
kCFPlugInFactoriesKey: CFStringRef #elsewhere corefoundation;
kCFPlugInTypesKey: CFStringRef #elsewhere corefoundation;
CFPlugInDynamicRegisterFunction :: #type (plugIn: CFPlugInRef) -> void #c_call;
CFPlugInUnloadFunction :: #type (plugIn: CFPlugInRef) -> void #c_call;
CFPlugInFactoryFunction :: #type (allocator: CFAllocatorRef, typeUUID: CFUUIDRef) -> *void #c_call;
CFPlugInGetTypeID :: () -> CFTypeID #foreign corefoundation;
CFPlugInCreate :: (allocator: CFAllocatorRef, plugInURL: CFURLRef) -> CFPlugInRef #foreign corefoundation;
CFPlugInGetBundle :: (plugIn: CFPlugInRef) -> CFBundleRef #foreign corefoundation;
CFPlugInSetLoadOnDemand :: (plugIn: CFPlugInRef, flag: Boolean) -> void #foreign corefoundation;
CFPlugInIsLoadOnDemand :: (plugIn: CFPlugInRef) -> Boolean #foreign corefoundation;
CFPlugInFindFactoriesForPlugInType :: (typeUUID: CFUUIDRef) -> CFArrayRef #foreign corefoundation;
CFPlugInFindFactoriesForPlugInTypeInPlugIn :: (typeUUID: CFUUIDRef, plugIn: CFPlugInRef) -> CFArrayRef #foreign corefoundation;
CFPlugInInstanceCreate :: (allocator: CFAllocatorRef, factoryUUID: CFUUIDRef, typeUUID: CFUUIDRef) -> *void #foreign corefoundation;
CFPlugInRegisterFactoryFunction :: (factoryUUID: CFUUIDRef, func: CFPlugInFactoryFunction) -> Boolean #foreign corefoundation;
CFPlugInRegisterFactoryFunctionByName :: (factoryUUID: CFUUIDRef, plugIn: CFPlugInRef, functionName: CFStringRef) -> Boolean #foreign corefoundation;
CFPlugInUnregisterFactory :: (factoryUUID: CFUUIDRef) -> Boolean #foreign corefoundation;
CFPlugInRegisterPlugInType :: (factoryUUID: CFUUIDRef, typeUUID: CFUUIDRef) -> Boolean #foreign corefoundation;
CFPlugInUnregisterPlugInType :: (factoryUUID: CFUUIDRef, typeUUID: CFUUIDRef) -> Boolean #foreign corefoundation;
CFPlugInAddInstanceForFactory :: (factoryID: CFUUIDRef) -> void #foreign corefoundation;
CFPlugInRemoveInstanceForFactory :: (factoryID: CFUUIDRef) -> void #foreign corefoundation;
__CFPlugInInstance :: struct {}
CFPlugInInstanceRef :: *__CFPlugInInstance;
CFPlugInInstanceGetInterfaceFunction :: #type (instance: CFPlugInInstanceRef, interfaceName: CFStringRef, ftbl: **void) -> Boolean #c_call;
CFPlugInInstanceDeallocateInstanceDataFunction :: #type (instanceData: *void) -> void #c_call;
CFPlugInInstanceGetInterfaceFunctionTable :: (instance: CFPlugInInstanceRef, interfaceName: CFStringRef, ftbl: **void) -> Boolean #foreign corefoundation;
CFPlugInInstanceGetFactoryName :: (instance: CFPlugInInstanceRef) -> CFStringRef #foreign corefoundation;
CFPlugInInstanceGetInstanceData :: (instance: CFPlugInInstanceRef) -> *void #foreign corefoundation;
CFPlugInInstanceGetTypeID :: () -> CFTypeID #foreign corefoundation;
CFPlugInInstanceCreateWithInstanceDataSize :: (allocator: CFAllocatorRef, instanceDataSize: CFIndex, deallocateInstanceFunction: CFPlugInInstanceDeallocateInstanceDataFunction, factoryName: CFStringRef, getInterfaceFunction: CFPlugInInstanceGetInterfaceFunction) -> CFPlugInInstanceRef #foreign corefoundation;
__CFMachPort :: struct {}
CFMachPortRef :: *__CFMachPort;

CFMachPortContext :: struct {
    version: CFIndex;
    info: *void;
    retain: #type (info: *void) -> *void #c_call;
    release: #type (info: *void) -> void #c_call;
    copyDescription: #type (info: *void) -> CFStringRef #c_call;
}

CFMachPortCallBack :: #type (port: CFMachPortRef, msg: *void, size: CFIndex, info: *void) -> void #c_call;
CFMachPortInvalidationCallBack :: #type (port: CFMachPortRef, info: *void) -> void #c_call;
CFMachPortGetTypeID :: () -> CFTypeID #foreign corefoundation;
CFMachPortCreate :: (allocator: CFAllocatorRef, callout: CFMachPortCallBack, _context: *CFMachPortContext, shouldFreeInfo: *Boolean) -> CFMachPortRef #foreign corefoundation;
CFMachPortCreateWithPort :: (allocator: CFAllocatorRef, portNum: mach_port_t, callout: CFMachPortCallBack, _context: *CFMachPortContext, shouldFreeInfo: *Boolean) -> CFMachPortRef #foreign corefoundation;
CFMachPortGetPort :: (port: CFMachPortRef) -> mach_port_t #foreign corefoundation;
CFMachPortGetContext :: (port: CFMachPortRef, _context: *CFMachPortContext) -> void #foreign corefoundation;
CFMachPortInvalidate :: (port: CFMachPortRef) -> void #foreign corefoundation;
CFMachPortIsValid :: (port: CFMachPortRef) -> Boolean #foreign corefoundation;
CFMachPortGetInvalidationCallBack :: (port: CFMachPortRef) -> CFMachPortInvalidationCallBack #foreign corefoundation;
CFMachPortSetInvalidationCallBack :: (port: CFMachPortRef, callout: CFMachPortInvalidationCallBack) -> void #foreign corefoundation;
CFMachPortCreateRunLoopSource :: (allocator: CFAllocatorRef, port: CFMachPortRef, order: CFIndex) -> CFRunLoopSourceRef #foreign corefoundation;
__CFAttributedString :: struct {}
CFAttributedStringRef :: *__CFAttributedString;
CFMutableAttributedStringRef :: *__CFAttributedString;
CFAttributedStringGetTypeID :: () -> CFTypeID #foreign corefoundation;
CFAttributedStringCreate :: (alloc: CFAllocatorRef, str: CFStringRef, attributes: CFDictionaryRef) -> CFAttributedStringRef #foreign corefoundation;
CFAttributedStringCreateWithSubstring :: (alloc: CFAllocatorRef, aStr: CFAttributedStringRef, range: CFRange) -> CFAttributedStringRef #foreign corefoundation;
CFAttributedStringCreateCopy :: (alloc: CFAllocatorRef, aStr: CFAttributedStringRef) -> CFAttributedStringRef #foreign corefoundation;
CFAttributedStringGetString :: (aStr: CFAttributedStringRef) -> CFStringRef #foreign corefoundation;
CFAttributedStringGetLength :: (aStr: CFAttributedStringRef) -> CFIndex #foreign corefoundation;
CFAttributedStringGetAttributes :: (aStr: CFAttributedStringRef, loc: CFIndex, effectiveRange: *CFRange) -> CFDictionaryRef #foreign corefoundation;
CFAttributedStringGetAttribute :: (aStr: CFAttributedStringRef, loc: CFIndex, attrName: CFStringRef, effectiveRange: *CFRange) -> CFTypeRef #foreign corefoundation;
CFAttributedStringGetAttributesAndLongestEffectiveRange :: (aStr: CFAttributedStringRef, loc: CFIndex, inRange: CFRange, longestEffectiveRange: *CFRange) -> CFDictionaryRef #foreign corefoundation;
CFAttributedStringGetAttributeAndLongestEffectiveRange :: (aStr: CFAttributedStringRef, loc: CFIndex, attrName: CFStringRef, inRange: CFRange, longestEffectiveRange: *CFRange) -> CFTypeRef #foreign corefoundation;
CFAttributedStringCreateMutableCopy :: (alloc: CFAllocatorRef, maxLength: CFIndex, aStr: CFAttributedStringRef) -> CFMutableAttributedStringRef #foreign corefoundation;
CFAttributedStringCreateMutable :: (alloc: CFAllocatorRef, maxLength: CFIndex) -> CFMutableAttributedStringRef #foreign corefoundation;
CFAttributedStringReplaceString :: (aStr: CFMutableAttributedStringRef, range: CFRange, replacement: CFStringRef) -> void #foreign corefoundation;
CFAttributedStringGetMutableString :: (aStr: CFMutableAttributedStringRef) -> CFMutableStringRef #foreign corefoundation;
CFAttributedStringSetAttributes :: (aStr: CFMutableAttributedStringRef, range: CFRange, replacement: CFDictionaryRef, clearOtherAttributes: Boolean) -> void #foreign corefoundation;
CFAttributedStringSetAttribute :: (aStr: CFMutableAttributedStringRef, range: CFRange, attrName: CFStringRef, value: CFTypeRef) -> void #foreign corefoundation;
CFAttributedStringRemoveAttribute :: (aStr: CFMutableAttributedStringRef, range: CFRange, attrName: CFStringRef) -> void #foreign corefoundation;
CFAttributedStringReplaceAttributedString :: (aStr: CFMutableAttributedStringRef, range: CFRange, replacement: CFAttributedStringRef) -> void #foreign corefoundation;
CFAttributedStringBeginEditing :: (aStr: CFMutableAttributedStringRef) -> void #foreign corefoundation;
CFAttributedStringEndEditing :: (aStr: CFMutableAttributedStringRef) -> void #foreign corefoundation;
__CFURLEnumerator :: struct {}
CFURLEnumeratorRef :: *__CFURLEnumerator;
CFURLEnumeratorGetTypeID :: () -> CFTypeID #foreign corefoundation;
CFURLEnumeratorOptions :: CFOptionFlags;

kCFURLEnumerator :: enum u32 {
    DefaultBehavior :: 0;
    DescendRecursively :: 1;
    SkipInvisibles :: 2;
    GenerateFileReferenceURLs :: 4;
    SkipPackageContents :: 8;
    IncludeDirectoriesPreOrder :: 16;
    IncludeDirectoriesPostOrder :: 32;
    kCFURLEnumeratorDefaultBehavior :: DefaultBehavior;
    kCFURLEnumeratorDescendRecursively :: DescendRecursively;
    kCFURLEnumeratorSkipInvisibles :: SkipInvisibles;
    kCFURLEnumeratorGenerateFileReferenceURLs :: GenerateFileReferenceURLs;
    kCFURLEnumeratorSkipPackageContents :: SkipPackageContents;
    kCFURLEnumeratorIncludeDirectoriesPreOrder :: IncludeDirectoriesPreOrder;
    kCFURLEnumeratorIncludeDirectoriesPostOrder :: IncludeDirectoriesPostOrder;
}

CFURLEnumeratorCreateForDirectoryURL :: (alloc: CFAllocatorRef, directoryURL: CFURLRef, option: CFURLEnumeratorOptions, propertyKeys: CFArrayRef) -> CFURLEnumeratorRef #foreign corefoundation;
CFURLEnumeratorCreateForMountedVolumes :: (alloc: CFAllocatorRef, option: CFURLEnumeratorOptions, propertyKeys: CFArrayRef) -> CFURLEnumeratorRef #foreign corefoundation;
CFURLEnumeratorResult :: CFIndex;

kCFURLEnumerator_1 :: enum u32 {
    Success :: 1;
    End :: 2;
    Error :: 3;
    DirectoryPostOrderSuccess :: 4;
    kCFURLEnumeratorSuccess :: Success;
    kCFURLEnumeratorEnd :: End;
    kCFURLEnumeratorError :: Error;
    kCFURLEnumeratorDirectoryPostOrderSuccess :: DirectoryPostOrderSuccess;
}

CFURLEnumeratorGetNextURL :: (enumerator: CFURLEnumeratorRef, url: *CFURLRef, error: *CFErrorRef) -> CFURLEnumeratorResult #foreign corefoundation;
CFURLEnumeratorSkipDescendents :: (enumerator: CFURLEnumeratorRef) -> void #foreign corefoundation;
CFURLEnumeratorGetDescendentLevel :: (enumerator: CFURLEnumeratorRef) -> CFIndex #foreign corefoundation;
CFURLEnumeratorGetSourceDidChange :: (enumerator: CFURLEnumeratorRef) -> Boolean #foreign corefoundation;
CFStringTokenizerCopyBestStringLanguage :: (_string: CFStringRef, range: CFRange) -> CFStringRef #foreign corefoundation;
__CFStringTokenizer :: struct {}
CFStringTokenizerRef :: *__CFStringTokenizer;

kCFStringTokenizer :: enum u32 {
    UnitWord :: 0;
    UnitSentence :: 1;
    UnitParagraph :: 2;
    UnitLineBreak :: 3;
    UnitWordBoundary :: 4;
    AttributeLatinTranscription :: 65536;
    AttributeLanguage :: 131072;
    kCFStringTokenizerUnitWord :: UnitWord;
    kCFStringTokenizerUnitSentence :: UnitSentence;
    kCFStringTokenizerUnitParagraph :: UnitParagraph;
    kCFStringTokenizerUnitLineBreak :: UnitLineBreak;
    kCFStringTokenizerUnitWordBoundary :: UnitWordBoundary;
    kCFStringTokenizerAttributeLatinTranscription :: AttributeLatinTranscription;
    kCFStringTokenizerAttributeLanguage :: AttributeLanguage;
}

CFStringTokenizerTokenType :: CFOptionFlags;

kCFStringTokenizerToken :: enum u32 {
    None :: 0;
    Normal :: 1;
    HasSubTokensMask :: 2;
    HasDerivedSubTokensMask :: 4;
    HasHasNumbersMask :: 8;
    HasNonLettersMask :: 16;
    IsCJWordMask :: 32;
    kCFStringTokenizerTokenNone :: None;
    kCFStringTokenizerTokenNormal :: Normal;
    kCFStringTokenizerTokenHasSubTokensMask :: HasSubTokensMask;
    kCFStringTokenizerTokenHasDerivedSubTokensMask :: HasDerivedSubTokensMask;
    kCFStringTokenizerTokenHasHasNumbersMask :: HasHasNumbersMask;
    kCFStringTokenizerTokenHasNonLettersMask :: HasNonLettersMask;
    kCFStringTokenizerTokenIsCJWordMask :: IsCJWordMask;
}

CFStringTokenizerGetTypeID :: () -> CFTypeID #foreign corefoundation;
CFStringTokenizerCreate :: (alloc: CFAllocatorRef, _string: CFStringRef, range: CFRange, options: CFOptionFlags, locale: CFLocaleRef) -> CFStringTokenizerRef #foreign corefoundation;
CFStringTokenizerSetString :: (tokenizer: CFStringTokenizerRef, _string: CFStringRef, range: CFRange) -> void #foreign corefoundation;
CFStringTokenizerGoToTokenAtIndex :: (tokenizer: CFStringTokenizerRef, index: CFIndex) -> CFStringTokenizerTokenType #foreign corefoundation;
CFStringTokenizerAdvanceToNextToken :: (tokenizer: CFStringTokenizerRef) -> CFStringTokenizerTokenType #foreign corefoundation;
CFStringTokenizerGetCurrentTokenRange :: (tokenizer: CFStringTokenizerRef) -> CFRange #foreign corefoundation;
CFStringTokenizerCopyCurrentTokenAttribute :: (tokenizer: CFStringTokenizerRef, attribute: CFOptionFlags) -> CFTypeRef #foreign corefoundation;
CFStringTokenizerGetCurrentSubTokens :: (tokenizer: CFStringTokenizerRef, ranges: *CFRange, maxRangeLength: CFIndex, derivedSubTokens: CFMutableArrayRef) -> CFIndex #foreign corefoundation;
CFFileDescriptorNativeDescriptor :: s32;
__CFFileDescriptor :: struct {}
CFFileDescriptorRef :: *__CFFileDescriptor;

kCFFileDescriptor :: enum u32 {
    ReadCallBack :: 1;
    WriteCallBack :: 2;
    kCFFileDescriptorReadCallBack :: ReadCallBack;
    kCFFileDescriptorWriteCallBack :: WriteCallBack;
}

CFFileDescriptorCallBack :: #type (f: CFFileDescriptorRef, callBackTypes: CFOptionFlags, info: *void) -> void #c_call;

CFFileDescriptorContext :: struct {
    version: CFIndex;
    info: *void;
    retain: #type (info: *void) -> *void #c_call;
    release: #type (info: *void) -> void #c_call;
    copyDescription: #type (info: *void) -> CFStringRef #c_call;
}

CFFileDescriptorGetTypeID :: () -> CFTypeID #foreign corefoundation;
CFFileDescriptorCreate :: (allocator: CFAllocatorRef, fd: CFFileDescriptorNativeDescriptor, closeOnInvalidate: Boolean, callout: CFFileDescriptorCallBack, _context: *CFFileDescriptorContext) -> CFFileDescriptorRef #foreign corefoundation;
CFFileDescriptorGetNativeDescriptor :: (f: CFFileDescriptorRef) -> CFFileDescriptorNativeDescriptor #foreign corefoundation;
CFFileDescriptorGetContext :: (f: CFFileDescriptorRef, _context: *CFFileDescriptorContext) -> void #foreign corefoundation;
CFFileDescriptorEnableCallBacks :: (f: CFFileDescriptorRef, callBackTypes: CFOptionFlags) -> void #foreign corefoundation;
CFFileDescriptorDisableCallBacks :: (f: CFFileDescriptorRef, callBackTypes: CFOptionFlags) -> void #foreign corefoundation;
CFFileDescriptorInvalidate :: (f: CFFileDescriptorRef) -> void #foreign corefoundation;
CFFileDescriptorIsValid :: (f: CFFileDescriptorRef) -> Boolean #foreign corefoundation;
CFFileDescriptorCreateRunLoopSource :: (allocator: CFAllocatorRef, f: CFFileDescriptorRef, order: CFIndex) -> CFRunLoopSourceRef #foreign corefoundation;
__CFUserNotification :: struct {}
CFUserNotificationRef :: *__CFUserNotification;
CFUserNotificationCallBack :: #type (userNotification: CFUserNotificationRef, responseFlags: CFOptionFlags) -> void #c_call;
CFUserNotificationGetTypeID :: () -> CFTypeID #foreign corefoundation;
CFUserNotificationCreate :: (allocator: CFAllocatorRef, timeout: CFTimeInterval, flags: CFOptionFlags, error: *s32, dictionary: CFDictionaryRef) -> CFUserNotificationRef #foreign corefoundation;
CFUserNotificationReceiveResponse :: (userNotification: CFUserNotificationRef, timeout: CFTimeInterval, responseFlags: *CFOptionFlags) -> s32 #foreign corefoundation;
CFUserNotificationGetResponseValue :: (userNotification: CFUserNotificationRef, key: CFStringRef, idx: CFIndex) -> CFStringRef #foreign corefoundation;
CFUserNotificationGetResponseDictionary :: (userNotification: CFUserNotificationRef) -> CFDictionaryRef #foreign corefoundation;
CFUserNotificationUpdate :: (userNotification: CFUserNotificationRef, timeout: CFTimeInterval, flags: CFOptionFlags, dictionary: CFDictionaryRef) -> s32 #foreign corefoundation;
CFUserNotificationCancel :: (userNotification: CFUserNotificationRef) -> s32 #foreign corefoundation;
CFUserNotificationCreateRunLoopSource :: (allocator: CFAllocatorRef, userNotification: CFUserNotificationRef, callout: CFUserNotificationCallBack, order: CFIndex) -> CFRunLoopSourceRef #foreign corefoundation;
CFUserNotificationDisplayNotice :: (timeout: CFTimeInterval, flags: CFOptionFlags, iconURL: CFURLRef, soundURL: CFURLRef, localizationURL: CFURLRef, alertHeader: CFStringRef, alertMessage: CFStringRef, defaultButtonTitle: CFStringRef) -> s32 #foreign corefoundation;
CFUserNotificationDisplayAlert :: (timeout: CFTimeInterval, flags: CFOptionFlags, iconURL: CFURLRef, soundURL: CFURLRef, localizationURL: CFURLRef, alertHeader: CFStringRef, alertMessage: CFStringRef, defaultButtonTitle: CFStringRef, alternateButtonTitle: CFStringRef, otherButtonTitle: CFStringRef, responseFlags: *CFOptionFlags) -> s32 #foreign corefoundation;

kCFUserNotification :: enum u32 {
    StopAlertLevel :: 0;
    NoteAlertLevel :: 1;
    CautionAlertLevel :: 2;
    PlainAlertLevel :: 3;
    kCFUserNotificationStopAlertLevel :: StopAlertLevel;
    kCFUserNotificationNoteAlertLevel :: NoteAlertLevel;
    kCFUserNotificationCautionAlertLevel :: CautionAlertLevel;
    kCFUserNotificationPlainAlertLevel :: PlainAlertLevel;
}

kCFUserNotification_1 :: enum u32 {
    DefaultResponse :: 0;
    AlternateResponse :: 1;
    OtherResponse :: 2;
    CancelResponse :: 3;
    kCFUserNotificationDefaultResponse :: DefaultResponse;
    kCFUserNotificationAlternateResponse :: AlternateResponse;
    kCFUserNotificationOtherResponse :: OtherResponse;
    kCFUserNotificationCancelResponse :: CancelResponse;
}

kCFUserNotification_2 :: enum u32 {
    NoDefaultButtonFlag :: 32;
    UseRadioButtonsFlag :: 64;
    kCFUserNotificationNoDefaultButtonFlag :: NoDefaultButtonFlag;
    kCFUserNotificationUseRadioButtonsFlag :: UseRadioButtonsFlag;
}

kCFUserNotificationIconURLKey: CFStringRef #elsewhere corefoundation;
kCFUserNotificationSoundURLKey: CFStringRef #elsewhere corefoundation;
kCFUserNotificationLocalizationURLKey: CFStringRef #elsewhere corefoundation;
kCFUserNotificationAlertHeaderKey: CFStringRef #elsewhere corefoundation;
kCFUserNotificationAlertMessageKey: CFStringRef #elsewhere corefoundation;
kCFUserNotificationDefaultButtonTitleKey: CFStringRef #elsewhere corefoundation;
kCFUserNotificationAlternateButtonTitleKey: CFStringRef #elsewhere corefoundation;
kCFUserNotificationOtherButtonTitleKey: CFStringRef #elsewhere corefoundation;
kCFUserNotificationProgressIndicatorValueKey: CFStringRef #elsewhere corefoundation;
kCFUserNotificationPopUpTitlesKey: CFStringRef #elsewhere corefoundation;
kCFUserNotificationTextFieldTitlesKey: CFStringRef #elsewhere corefoundation;
kCFUserNotificationCheckBoxTitlesKey: CFStringRef #elsewhere corefoundation;
kCFUserNotificationTextFieldValuesKey: CFStringRef #elsewhere corefoundation;
kCFUserNotificationPopUpSelectionKey: CFStringRef #elsewhere corefoundation;

anon_enum_8 :: enum u32 {
    kCFXMLNodeCurrentVersion :: 1;
}

#scope_file
libc :: #system_library "libc";
corefoundation :: #system_library "CoreFoundation";
