#import "JsonConfiguration.h"

#define NSLog(FORMAT, ...) printf("%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

@implementation JsonConfiguration

- (id)init
{
    self = [super init];
    if (self)
    {
        _action = [JsonConfiguration defaultAction];
    }
    return self;
}

+ (NSDictionary*)defaultAction
{
    return @{@"action": @"list"};
}

- (void)parseJSON:(NSString*)jsonString
{
    
    NSData * jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError * error = nil;
    
    _action = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    
    if (_action == nil) {
        NSLog(@"{\"repsonse\": \"error\", \"message\": \"%@\"}", [error localizedDescription]);
    }
    
}

- (NSString*)serializeJSON:(NSDictionary*)dictionary
{
    NSError * error = nil;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&error];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

- (MutableOrderedDictionary*)getSizeOptions:(NSSize*)size
{
    
    MutableOrderedDictionary * d = [[MutableOrderedDictionary alloc] init];
    [d setObject:[NSString stringWithFormat:@"%@", @(size->width)] forKey:@"width"];
    [d setObject:[NSString stringWithFormat:@"%@", @(size->height)] forKey:@"height"];
    return d;
    
}

- (MutableOrderedDictionary*)getRectOptions:(NSRect*)rect
{
    
    MutableOrderedDictionary * d = [[MutableOrderedDictionary alloc] init];
    [d setObject:[NSString stringWithFormat:@"%@", @(rect->origin.x)] forKey:@"x"];
    [d setObject:[NSString stringWithFormat:@"%@", @(rect->origin.y)] forKey:@"y"];
    [d setObject:[NSString stringWithFormat:@"%@", @(rect->size.width)] forKey:@"width"];
    [d setObject:[NSString stringWithFormat:@"%@", @(rect->size.height)] forKey:@"height"];
    return d;
    
}

- (NSDictionary*)getBitDepthOptions:(ICScannerBitDepth)bitDepth
{
    
    switch (bitDepth) {
        case ICScannerBitDepth1Bit:
            return @{[NSString stringWithFormat:@"%@", @(ICScannerBitDepth1Bit)]: @"1 Bit"};
        case ICScannerBitDepth8Bits:
            return @{[NSString stringWithFormat:@"%@", @(ICScannerBitDepth8Bits)]: @"8 Bits"};
        case ICScannerBitDepth16Bits:
            return @{[NSString stringWithFormat:@"%@", @(ICScannerBitDepth16Bits)]: @"16 Bits"};
        default:
            return nil;
    }

}

- (NSDictionary*)getResolutionOptions:(NSUInteger)resolution
{
    return @{[NSString stringWithFormat:@"%@", @(resolution)]: [NSString stringWithFormat:@"%@ DPI", @(resolution)]};
}

- (NSDictionary*)getScaleFactorOptions:(NSUInteger)resolution
{
    return @{[NSString stringWithFormat:@"%@", @(resolution)]: [NSString stringWithFormat:@"%@%%", @(resolution)]};
}

- (NSDictionary*)getMeasurementUnitOptions:(ICScannerMeasurementUnit)measurementUnit
{
    
    switch (measurementUnit) {
        case ICScannerMeasurementUnitInches:
            return @{[NSString stringWithFormat:@"%@", @(ICScannerMeasurementUnitInches)]: @"Inches"};
        case ICScannerMeasurementUnitCentimeters:
            return @{[NSString stringWithFormat:@"%@", @(ICScannerMeasurementUnitCentimeters)]: @"Centimeters"};
        case ICScannerMeasurementUnitPicas:
            return @{[NSString stringWithFormat:@"%@", @(ICScannerMeasurementUnitPicas)]: @"Picas"};
        case ICScannerMeasurementUnitPoints:
            return @{[NSString stringWithFormat:@"%@", @(ICScannerMeasurementUnitPoints)]: @"Points"};
        case ICScannerMeasurementUnitTwips:
            return @{[NSString stringWithFormat:@"%@", @(ICScannerMeasurementUnitTwips)]: @"Twips"};
        case ICScannerMeasurementUnitPixels:
            return @{[NSString stringWithFormat:@"%@", @(ICScannerMeasurementUnitPixels)]: @"Pixels"};
        default:
            return nil;
    }
    
}

- (NSDictionary*)getPixelDataTypeOptions:(ICScannerPixelDataType)pixelDataType
{
    
    switch (pixelDataType) {
        case ICScannerPixelDataTypeBW:
            return @{[NSString stringWithFormat:@"%@", @(ICScannerMeasurementUnitInches)]: @"Black and White"};
        case ICScannerPixelDataTypeGray:
            return @{[NSString stringWithFormat:@"%@", @(ICScannerPixelDataTypeGray)]: @"Grayscale"};
        case ICScannerPixelDataTypeRGB:
            return @{[NSString stringWithFormat:@"%@", @(ICScannerPixelDataTypeRGB)]: @"RGB"};
        case ICScannerPixelDataTypePalette:
            return @{[NSString stringWithFormat:@"%@", @(ICScannerPixelDataTypePalette)]: @"Indexed"};
        case ICScannerPixelDataTypeCMY:
            return @{[NSString stringWithFormat:@"%@", @(ICScannerPixelDataTypeCMY)]: @"CMY"};
        case ICScannerPixelDataTypeCMYK:
            return @{[NSString stringWithFormat:@"%@", @(ICScannerPixelDataTypeCMYK)]: @"CMYK"};
        case ICScannerPixelDataTypeYUV:
            return @{[NSString stringWithFormat:@"%@", @(ICScannerPixelDataTypeYUV)]: @"YUV"};
        case ICScannerPixelDataTypeYUVK:
            return @{[NSString stringWithFormat:@"%@", @(ICScannerPixelDataTypeYUVK)]: @"YUVK"};
        case ICScannerPixelDataTypeCIEXYZ:
            return @{[NSString stringWithFormat:@"%@", @(ICScannerPixelDataTypeCIEXYZ)]: @"CIEXYZ"};
        default:
            return nil;
    }
    
}


- (NSDictionary*)getDocumentTypeOptions:(ICScannerDocumentType)documentType
{
    switch (documentType) {
        case ICScannerDocumentTypeDefault:
            return @{[NSString stringWithFormat:@"%@", @(ICScannerDocumentTypeDefault)]: @"Default"};
        case ICScannerDocumentTypeA4:
            return @{[NSString stringWithFormat:@"%@", @(ICScannerDocumentTypeA4)]: @"A4"};
        case ICScannerDocumentTypeB5:
            return @{[NSString stringWithFormat:@"%@", @(ICScannerDocumentTypeB5)]: @"B5"};
        case ICScannerDocumentTypeUSLetter:
            return @{[NSString stringWithFormat:@"%@", @(ICScannerDocumentTypeUSLetter)]: @"US Letter"};
        case ICScannerDocumentTypeUSLegal:
            return @{[NSString stringWithFormat:@"%@", @(ICScannerDocumentTypeUSLegal)]: @"US Legal"};
        case ICScannerDocumentTypeA5:
            return @{[NSString stringWithFormat:@"%@", @(ICScannerDocumentTypeA5)]: @"A5"};
        case ICScannerDocumentTypeISOB4:
            return @{[NSString stringWithFormat:@"%@", @(ICScannerDocumentTypeISOB4)]: @"ISO B4"};
        case ICScannerDocumentTypeISOB6:
            return @{[NSString stringWithFormat:@"%@", @(ICScannerDocumentTypeISOB6)]: @"ISO B6"};
        case ICScannerDocumentTypeUSLedger:
            return @{[NSString stringWithFormat:@"%@", @(ICScannerDocumentTypeUSLedger)]: @"US Ledger"};
        case ICScannerDocumentTypeUSExecutive:
            return @{[NSString stringWithFormat:@"%@", @(ICScannerDocumentTypeUSExecutive)]: @"US Executive"};
        case ICScannerDocumentTypeA3:
            return @{[NSString stringWithFormat:@"%@", @(ICScannerDocumentTypeA3)]: @"A3"};
        case ICScannerDocumentTypeISOB3:
            return @{[NSString stringWithFormat:@"%@", @(ICScannerDocumentTypeISOB3)]: @"ISO B3"};
        case ICScannerDocumentTypeA6:
            return @{[NSString stringWithFormat:@"%@", @(ICScannerDocumentTypeA6)]: @"A6"};
        case ICScannerDocumentTypeC4:
            return @{[NSString stringWithFormat:@"%@", @(ICScannerDocumentTypeC4)]: @"C4"};
        case ICScannerDocumentTypeC5:
            return @{[NSString stringWithFormat:@"%@", @(ICScannerDocumentTypeC5)]: @"C5"};
        case ICScannerDocumentTypeC6:
            return @{[NSString stringWithFormat:@"%@", @(ICScannerDocumentTypeC6)]: @"C6"};
        case ICScannerDocumentType4A0:
            return @{[NSString stringWithFormat:@"%@", @(ICScannerDocumentType4A0)]: @"4A0"};
        case ICScannerDocumentType2A0:
            return @{[NSString stringWithFormat:@"%@", @(ICScannerDocumentType2A0)]: @"2A0"};
        case ICScannerDocumentTypeA0:
            return @{[NSString stringWithFormat:@"%@", @(ICScannerDocumentTypeA0)]: @"A0"};
        case ICScannerDocumentTypeA1:
            return @{[NSString stringWithFormat:@"%@", @(ICScannerDocumentTypeA1)]: @"A1"};
        case ICScannerDocumentTypeA2:
            return @{[NSString stringWithFormat:@"%@", @(ICScannerDocumentTypeA2)]: @"A2"};
        case ICScannerDocumentTypeA7:
            return @{[NSString stringWithFormat:@"%@", @(ICScannerDocumentTypeA7)]: @"A7"};
        case ICScannerDocumentTypeA8:
            return @{[NSString stringWithFormat:@"%@", @(ICScannerDocumentTypeA8)]: @"A8"};
        case ICScannerDocumentTypeA9:
            return @{[NSString stringWithFormat:@"%@", @(ICScannerDocumentTypeA9)]: @"A9"};
        case ICScannerDocumentType10:
            return @{[NSString stringWithFormat:@"%@", @(ICScannerDocumentType10)]: @"A10"};
        case ICScannerDocumentTypeISOB0:
            return @{[NSString stringWithFormat:@"%@", @(ICScannerDocumentTypeISOB0)]: @"ISO B0"};
        case ICScannerDocumentTypeISOB1:
            return @{[NSString stringWithFormat:@"%@", @(ICScannerDocumentTypeISOB1)]: @"ISO B1"};
        case ICScannerDocumentTypeISOB2:
            return @{[NSString stringWithFormat:@"%@", @(ICScannerDocumentTypeISOB2)]: @"ISO B2"};
        case ICScannerDocumentTypeISOB5:
            return @{[NSString stringWithFormat:@"%@", @(ICScannerDocumentTypeISOB5)]: @"ISO B5"};
        case ICScannerDocumentTypeISOB7:
            return @{[NSString stringWithFormat:@"%@", @(ICScannerDocumentTypeISOB7)]: @"ISO B7"};
        case ICScannerDocumentTypeISOB8:
            return @{[NSString stringWithFormat:@"%@", @(ICScannerDocumentTypeISOB8)]: @"ISO B8"};
        case ICScannerDocumentTypeISOB9:
            return @{[NSString stringWithFormat:@"%@", @(ICScannerDocumentTypeISOB9)]: @"ISO B9"};
        case ICScannerDocumentTypeISOB10:
            return @{[NSString stringWithFormat:@"%@", @(ICScannerDocumentTypeISOB10)]: @"ISO B10"};
        case ICScannerDocumentTypeJISB0:
            return @{[NSString stringWithFormat:@"%@", @(ICScannerDocumentTypeJISB0)]: @"JIS B0"};
        case ICScannerDocumentTypeJISB1:
            return @{[NSString stringWithFormat:@"%@", @(ICScannerDocumentTypeJISB1)]: @"JIS B1"};
        case ICScannerDocumentTypeJISB2:
            return @{[NSString stringWithFormat:@"%@", @(ICScannerDocumentTypeJISB2)]: @"JIS B2"};
        case ICScannerDocumentTypeJISB3:
            return @{[NSString stringWithFormat:@"%@", @(ICScannerDocumentTypeJISB3)]: @"JIS B3"};
        case ICScannerDocumentTypeJISB4:
            return @{[NSString stringWithFormat:@"%@", @(ICScannerDocumentTypeJISB4)]: @"JIS B4"};
        case ICScannerDocumentTypeJISB6:
            return @{[NSString stringWithFormat:@"%@", @(ICScannerDocumentTypeJISB6)]: @"JIS B6"};
        case ICScannerDocumentTypeJISB7:
            return @{[NSString stringWithFormat:@"%@", @(ICScannerDocumentTypeJISB7)]: @"JIS B7"};
        case ICScannerDocumentTypeJISB8:
            return @{[NSString stringWithFormat:@"%@", @(ICScannerDocumentTypeJISB8)]: @"JIS B8"};
        case ICScannerDocumentTypeJISB9:
            return @{[NSString stringWithFormat:@"%@", @(ICScannerDocumentTypeJISB9)]: @"JIS B9"};
        case ICScannerDocumentTypeJISB10:
            return @{[NSString stringWithFormat:@"%@", @(ICScannerDocumentTypeJISB10)]: @"JIS B10"};
        case ICScannerDocumentTypeC0:
            return @{[NSString stringWithFormat:@"%@", @(ICScannerDocumentTypeC0)]: @"C0"};
        case ICScannerDocumentTypeC1:
            return @{[NSString stringWithFormat:@"%@", @(ICScannerDocumentTypeC1)]: @"C1"};
        case ICScannerDocumentTypeC2:
            return @{[NSString stringWithFormat:@"%@", @(ICScannerDocumentTypeC2)]: @"C2"};
        case ICScannerDocumentTypeC3:
            return @{[NSString stringWithFormat:@"%@", @(ICScannerDocumentTypeC3)]: @"C3"};
        case ICScannerDocumentTypeC7:
            return @{[NSString stringWithFormat:@"%@", @(ICScannerDocumentTypeC7)]: @"C7"};
        case ICScannerDocumentTypeC8:
            return @{[NSString stringWithFormat:@"%@", @(ICScannerDocumentTypeC8)]: @"C8"};
        case ICScannerDocumentTypeC9:
            return @{[NSString stringWithFormat:@"%@", @(ICScannerDocumentTypeC9)]: @"C9"};
        case ICScannerDocumentTypeC10:
            return @{[NSString stringWithFormat:@"%@", @(ICScannerDocumentTypeC10)]: @"C10"};
        case ICScannerDocumentTypeUSStatement:
            return @{[NSString stringWithFormat:@"%@", @(ICScannerDocumentTypeUSStatement)]: @"US Statement"};
        case ICScannerDocumentTypeBusinessCard:
            return @{[NSString stringWithFormat:@"%@", @(ICScannerDocumentTypeBusinessCard)]: @"Business Card"};
        case ICScannerDocumentTypeE:
            return @{[NSString stringWithFormat:@"%@", @(ICScannerDocumentTypeE)]: @"E"};
        case ICScannerDocumentType3R:
            return @{[NSString stringWithFormat:@"%@", @(ICScannerDocumentType3R)]: @"3R"};
        case ICScannerDocumentType4R:
            return @{[NSString stringWithFormat:@"%@", @(ICScannerDocumentType4R)]: @"4R"};
        case ICScannerDocumentType5R:
            return @{[NSString stringWithFormat:@"%@", @(ICScannerDocumentType5R)]: @"5R"};
        case ICScannerDocumentType6R:
            return @{[NSString stringWithFormat:@"%@", @(ICScannerDocumentType6R)]: @"6R"};
        case ICScannerDocumentType8R:
            return @{[NSString stringWithFormat:@"%@", @(ICScannerDocumentType8R)]: @"8R"};
        case ICScannerDocumentTypeS8R:
            return @{[NSString stringWithFormat:@"%@", @(ICScannerDocumentTypeS8R)]: @"S8R"};
        case ICScannerDocumentType10R:
            return @{[NSString stringWithFormat:@"%@", @(ICScannerDocumentType10R)]: @"10R"};
        case ICScannerDocumentTypeS10R:
            return @{[NSString stringWithFormat:@"%@", @(ICScannerDocumentTypeS10R)]: @"S10R"};
        case ICScannerDocumentType11R:
            return @{[NSString stringWithFormat:@"%@", @(ICScannerDocumentType11R)]: @"11R"};
        case ICScannerDocumentType12R:
            return @{[NSString stringWithFormat:@"%@", @(ICScannerDocumentType12R)]: @"12R"};
        case ICScannerDocumentTypeS12R:
            return @{[NSString stringWithFormat:@"%@", @(ICScannerDocumentTypeS12R)]: @"S12R"};
        case ICScannerDocumentType110:
            return @{[NSString stringWithFormat:@"%@", @(ICScannerDocumentType110)]: @"110"};
        case ICScannerDocumentTypeAPSH:
            return @{[NSString stringWithFormat:@"%@", @(ICScannerDocumentTypeAPSH)]: @"APSH"};
        case ICScannerDocumentTypeAPSC:
            return @{[NSString stringWithFormat:@"%@", @(ICScannerDocumentTypeAPSC)]: @"APSC"};
        case ICScannerDocumentTypeAPSP:
            return @{[NSString stringWithFormat:@"%@", @(ICScannerDocumentTypeAPSP)]: @"APSP"};
        case ICScannerDocumentType135:
            return @{[NSString stringWithFormat:@"%@", @(ICScannerDocumentType135)]: @"135"};
        case ICScannerDocumentTypeMF:
            return @{[NSString stringWithFormat:@"%@", @(ICScannerDocumentTypeMF)]: @"MF"};
        case ICScannerDocumentTypeLF:
            return @{[NSString stringWithFormat:@"%@", @(ICScannerDocumentTypeLF)]: @"LF"};
        default:
            return nil;
    }
};

- (NSDictionary*)getOrientationOptions:(ICEXIFOrientationType)scanAreaOrientation
{
    
    switch (scanAreaOrientation) {
        case ICEXIFOrientation1:
            return @{[NSString stringWithFormat:@"%@", @(ICEXIFOrientation1)]: @"Normal"};
        case ICEXIFOrientation2:
            return @{[NSString stringWithFormat:@"%@", @(ICEXIFOrientation2)]: @"Flipped Horizontally"};
        case ICEXIFOrientation3:
            return @{[NSString stringWithFormat:@"%@", @(ICEXIFOrientation3)]: @"Rotated 180"};
        case ICEXIFOrientation4:
            return @{[NSString stringWithFormat:@"%@", @(ICEXIFOrientation4)]: @"Flipped Vertically"};
        case ICEXIFOrientation5:
            return @{[NSString stringWithFormat:@"%@", @(ICEXIFOrientation5)]: @"Rotated 90 CCW and Flipped Vertically"};
        case ICEXIFOrientation6:
            return @{[NSString stringWithFormat:@"%@", @(ICEXIFOrientation6)]: @"Rotated 90 CCW"};
        case ICEXIFOrientation7:
            return @{[NSString stringWithFormat:@"%@", @(ICEXIFOrientation7)]: @"Rotated 90 CW and Flipped Vertically"};
        case ICEXIFOrientation8:
            return @{[NSString stringWithFormat:@"%@", @(ICEXIFOrientation8)]: @"Rotated 90 CW"};
        default:
            return nil;
    }
    
}

- (NSString*)getScannerOptions:(ICScannerFunctionalUnit*)functionalUnit
{
    
    // TODO: Constant keys with descriptions.
    
    // TODO: functionalUnit.overviewImage
    
    MutableOrderedDictionary * readonly = [[MutableOrderedDictionary alloc] init];
    MutableOrderedDictionary * readwrite = [[MutableOrderedDictionary alloc] init];

    [readonly setObject:functionalUnit.acceptsThresholdForBlackAndWhiteScanning ? @"true": @"false" forKey:@"can-use-black-white-threshold"];
    [readonly setObject:functionalUnit.canPerformOverviewScan ? @"true": @"false" forKey:@"can-perform-overview-scan"];
    
    [readonly setObject:functionalUnit.usesThresholdForBlackAndWhiteScanning ? @"true": @"false" forKey:@"use-back-white-threshold"];
    
    [readonly setObject:[NSString stringWithFormat:@"%@", @(functionalUnit.defaultThresholdForBlackAndWhiteScanning)] forKey:@"default-black-and-white-threshold"];
    
    ICScannerBitDepth bitDepth = functionalUnit.bitDepth;
    [readwrite setObject:[self getBitDepthOptions:bitDepth] forKey:@"bit-depth"];
    
    ICScannerMeasurementUnit measurementUnit = functionalUnit.measurementUnit;
    [readwrite setObject:[self getMeasurementUnitOptions:measurementUnit] forKey:@"measurement-unit"];
    
    [readonly setObject:[NSString stringWithFormat:@"%@", @(functionalUnit.nativeXResolution)] forKey:@"native-x-resolution"];
    [readonly setObject:[NSString stringWithFormat:@"%@", @(functionalUnit.nativeYResolution)] forKey:@"native-y-resolution"];
    
    [readwrite setObject:[NSString stringWithFormat:@"%@", @(functionalUnit.overviewResolution)] forKey:@"overview-resolution"];

    ICScannerPixelDataType pixelDataType = functionalUnit.pixelDataType;
    [readwrite setObject:[self getPixelDataTypeOptions:pixelDataType] forKey:@"pixel-data-type"];
    
    [readwrite setObject:[NSString stringWithFormat:@"%@", @(functionalUnit.scaleFactor)] forKey:@"scale-factor"];
    
    NSMutableDictionary * supportedBitDepths = [[NSMutableDictionary alloc] init];
    [functionalUnit.supportedBitDepths enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [supportedBitDepths addEntriesFromDictionary:[self getBitDepthOptions:idx]];
    }];
    [readonly setObject:supportedBitDepths forKey:@"supported-bit-depths"];
    
    NSMutableDictionary * preferredResolutions = [[NSMutableDictionary alloc] init];
    [functionalUnit.preferredResolutions enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [preferredResolutions addEntriesFromDictionary:[self getResolutionOptions:idx]];
    }];
    [readonly setObject:preferredResolutions forKey:@"preferred-resolutions"];
    
    NSMutableDictionary * preferredScaleFactors = [[NSMutableDictionary alloc] init];
    [functionalUnit.preferredScaleFactors enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [preferredResolutions addEntriesFromDictionary:[self getScaleFactorOptions:idx]];
    }];
    [readonly setObject:preferredScaleFactors forKey:@"preferred-scale-factors"];
    
    NSMutableDictionary * supportedMeasurementUnits = [[NSMutableDictionary alloc] init];
    [functionalUnit.supportedMeasurementUnits enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [preferredResolutions addEntriesFromDictionary:[self getMeasurementUnitOptions:idx]];
    }];
    [readonly setObject:supportedMeasurementUnits forKey:@"supported-measurement-units"];
    
    NSRect scanArea = functionalUnit.scanArea;
    [readwrite setObject:[self getRectOptions:&scanArea] forKey:@"scan-area"];

    ICEXIFOrientationType scanAreaOrientation = functionalUnit.scanAreaOrientation;
    [readwrite setObject:[self getOrientationOptions:scanAreaOrientation] forKey:@"scan-area-orientation"];
    
    if ((functionalUnit.scanInProgress == NO) && (functionalUnit.overviewScanInProgress == NO)) {
        
        if (functionalUnit.type == ICScannerFunctionalUnitTypeDocumentFeeder) {
            
            ICScannerFunctionalUnitDocumentFeeder* dfu = (ICScannerFunctionalUnitDocumentFeeder*)functionalUnit;
            
            [readonly setObject:dfu.documentLoaded ? @"true": @"false" forKey:@"is-document-loaded"];

            NSSize documentSize = dfu.documentSize;
            [readonly setObject:[self getSizeOptions:&documentSize] forKey:@"document-size"];
            
            NSSize physicalSize = dfu.physicalSize;
            [readonly setObject:[self getSizeOptions:&physicalSize] forKey:@"physical-size"];
            
            [readwrite setObject:dfu.duplexScanningEnabled ? @"true": @"false" forKey:@"is-duplex-scanning-enabled"];
            
            [readonly setObject:dfu.reverseFeederPageOrder ? @"true": @"false" forKey:@"is-reverse-feeder-page-order"];
            
            [readonly setObject:dfu.supportsDuplexScanning ? @"true": @"false" forKey:@"supports-duplex-scanning"];
            
            [readwrite setObject:[NSString stringWithFormat:@"%@", @(dfu.resolution)] forKey:@"resolution"];

            ICScannerDocumentType documentType = dfu.documentType;
            [readwrite setObject:[self getDocumentTypeOptions:documentType] forKey:@"document-type"];
            
            NSMutableDictionary * supportedDocumentTypes = [[NSMutableDictionary alloc] init];
            [dfu.supportedDocumentTypes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
                [supportedDocumentTypes addEntriesFromDictionary:[self getDocumentTypeOptions:idx]];
            }];
            [readonly setObject:supportedDocumentTypes forKey:@"supported-document-types"];
            
            ICEXIFOrientationType evenPageOrientation = dfu.evenPageOrientation;
            [readwrite setObject:[self getOrientationOptions:evenPageOrientation] forKey:@"even-page-orientation"];

            ICEXIFOrientationType oddPageOrientation = dfu.oddPageOrientation;
            [readwrite setObject:[self getOrientationOptions:oddPageOrientation] forKey:@"odd-page-orientation"];

        }
    }
    
    return [self serializeJSON:@{@"response": @"settings", @"read-only-settings": readonly, @"read-write-settings": readwrite}];
    
}

@end