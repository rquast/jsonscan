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

- (NSDictionary*)getSizeOptions:(NSSize*)size
{
    return @{@"width": [NSString stringWithFormat:@"%@", @(size->width)], @"height": [NSString stringWithFormat:@"%@", @(size->height)]};
}

- (NSDictionary*)getRectOptions:(NSRect*)rect
{
    return @{@"x": [NSString stringWithFormat:@"%@", @(rect->origin.x)], @"y": [NSString stringWithFormat:@"%@", @(rect->origin.y)],  @"width": [NSString stringWithFormat:@"%@", @(rect->size.width)], @"height": [NSString stringWithFormat:@"%@", @(rect->size.height)]};
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
        case ICScannerDocumentTypeA4:
        case ICScannerDocumentTypeB5:
        case ICScannerDocumentTypeUSLetter:
        case ICScannerDocumentTypeUSLegal:
        case ICScannerDocumentTypeA5:
        case ICScannerDocumentTypeISOB4:
        case ICScannerDocumentTypeISOB6:
        case ICScannerDocumentTypeUSLedger:
        case ICScannerDocumentTypeUSExecutive:
        case ICScannerDocumentTypeA3:
        case ICScannerDocumentTypeISOB3:
        case ICScannerDocumentTypeA6:
        case ICScannerDocumentTypeC4:
        case ICScannerDocumentTypeC5:
        case ICScannerDocumentTypeC6:
        case ICScannerDocumentType4A0:
        case ICScannerDocumentType2A0:
        case ICScannerDocumentTypeA0:
        case ICScannerDocumentTypeA1:
        case ICScannerDocumentTypeA2:
        case ICScannerDocumentTypeA7:
        case ICScannerDocumentTypeA8:
        case ICScannerDocumentTypeA9:
        case ICScannerDocumentType10:
        case ICScannerDocumentTypeISOB0:
        case ICScannerDocumentTypeISOB1:
        case ICScannerDocumentTypeISOB2:
        case ICScannerDocumentTypeISOB5:
        case ICScannerDocumentTypeISOB7:
        case ICScannerDocumentTypeISOB8:
        case ICScannerDocumentTypeISOB9:
        case ICScannerDocumentTypeISOB10:
        case ICScannerDocumentTypeJISB0:
        case ICScannerDocumentTypeJISB1:
        case ICScannerDocumentTypeJISB2:
        case ICScannerDocumentTypeJISB3:
        case ICScannerDocumentTypeJISB4:
        case ICScannerDocumentTypeJISB6:
        case ICScannerDocumentTypeJISB7:
        case ICScannerDocumentTypeJISB8:
        case ICScannerDocumentTypeJISB9:
        case ICScannerDocumentTypeJISB10:
        case ICScannerDocumentTypeC0:
        case ICScannerDocumentTypeC1:
        case ICScannerDocumentTypeC2:
        case ICScannerDocumentTypeC3:
        case ICScannerDocumentTypeC7:
        case ICScannerDocumentTypeC8:
        case ICScannerDocumentTypeC9:
        case ICScannerDocumentTypeC10:
        case ICScannerDocumentTypeUSStatement:
        case ICScannerDocumentTypeBusinessCard:
        case ICScannerDocumentTypeE:
        case ICScannerDocumentType3R:
        case ICScannerDocumentType4R:
        case ICScannerDocumentType5R:
        case ICScannerDocumentType6R:
        case ICScannerDocumentType8R:
        case ICScannerDocumentTypeS8R:
        case ICScannerDocumentType10R:
        case ICScannerDocumentTypeS10R:
        case ICScannerDocumentType11R:
        case ICScannerDocumentType12R:
        case ICScannerDocumentTypeS12R:
        case ICScannerDocumentType110:
        case ICScannerDocumentTypeAPSH:
        case ICScannerDocumentTypeAPSC:
        case ICScannerDocumentTypeAPSP:
        case ICScannerDocumentType135:
        case ICScannerDocumentTypeMF:
        case ICScannerDocumentTypeLF:
        default:
            return nil;
    }
};

- (NSDictionary*)getScanAreaOrientation:(ICEXIFOrientationType)scanAreaOrientation
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
    
    // TODO: Ordered Dictionary
    
    // TODO: Constant keys with descriptions.
    
    // TODO: functionalUnit.overviewImage
    
    NSMutableDictionary * readonly = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * readwrite = [[NSMutableDictionary alloc] init];

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
    [readwrite setObject:[self getScanAreaOrientation:scanAreaOrientation] forKey:@"scan-area-orientation"];
    
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
            
            // IMPORTANT ONE.
            ICScannerDocumentType documentType = dfu.documentType;
            
            
            // dfu.evenPageOrientation
            // dfu.oddPageOrientation
            
            // IMPORTANT ONE.
            // dfu.supportedDocumentTypes

        }
    }
    
    return [self serializeJSON:@{@"response": @"settings", @"read-only-settings": readonly, @"read-write-settings": readwrite}];
    
}

@end