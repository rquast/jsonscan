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

- (NSString*)getBitDepthOptions:(ICScannerBitDepth)bitDepth
{
    
    switch (bitDepth) {
        case ICScannerBitDepth1Bit:
            return @"1";
        case ICScannerBitDepth8Bits:
            return @"8";
        case ICScannerBitDepth16Bits:
            return @"16";
        default:
            return @"Not Available";
    }

}

- (NSString*)getMeasurementUnitOptions:(ICScannerMeasurementUnit)measurementUnit
{
    
    switch (measurementUnit) {
        case ICScannerMeasurementUnitInches:
            return @"Inches";
        case ICScannerMeasurementUnitCentimeters:
            return @"Centimeters";
        case ICScannerMeasurementUnitPicas:
            return @"Picas";
        case ICScannerMeasurementUnitPoints:
            return @"Points";
        case ICScannerMeasurementUnitTwips:
            return @"Twips";
        case ICScannerMeasurementUnitPixels:
            return @"Pixels";
        default:
            return @"Not Available";
    }
    
}

- (NSString*)getPixelDataTypeOptions:(ICScannerPixelDataType)pixelDataType
{
    
    switch (pixelDataType) {
        case ICScannerPixelDataTypeBW:
            return @"Black and White";
        case ICScannerPixelDataTypeGray:
            return @"Grayscale";
        case ICScannerPixelDataTypeRGB:
            return @"RGB";
        case ICScannerPixelDataTypePalette:
            return @"Indexed";
        case ICScannerPixelDataTypeCMY:
            return @"CMY";
        case ICScannerPixelDataTypeCMYK:
            return @"CMYK";
        case ICScannerPixelDataTypeYUV:
            return @"YUV";
        case ICScannerPixelDataTypeYUVK:
            return @"YUVK";
        case ICScannerPixelDataTypeCIEXYZ:
            return @"CIEXYZ";
        default:
            return @"Not Available";
    }
    
}

- (NSString*)getScanAreaOrientation:(ICEXIFOrientationType)scanAreaOrientation
{
    
    switch (scanAreaOrientation) {
        case ICEXIFOrientation1:
            return @"Normal";
        case ICEXIFOrientation2:
            return @"Flipped Horizontally";
        case ICEXIFOrientation3:
            return @"Rotated 180";
        case ICEXIFOrientation4:
            return @"Flipped Vertically";
        case ICEXIFOrientation5:
            return @"Rotated 90 CCW and Flipped Vertically";
        case ICEXIFOrientation6:
            return @"Rotated 90 CCW";
        case ICEXIFOrientation7:
            return @"Rotated 90 CW and Flipped Vertically";
        case ICEXIFOrientation8:
            return @"Rotated 90 CW";
        default:
            return @"Not Available";
    }
    
}

- (NSString*)getScannerOptions:(ICScannerFunctionalUnit*)functionalUnit
{
 
    // TODO: Move the key strings into a dictionary so they it can be used listing the type of option and a description of it.
    // Also, link the related keys together in the dictionary, and make the dictionary printable to the cli.
    
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
    
    // functionalUnit.overviewImage ???
    
    [readwrite setObject:[NSString stringWithFormat:@"%@", @(functionalUnit.overviewResolution)] forKey:@"overview-resolution"];

    ICScannerPixelDataType pixelDataType = functionalUnit.pixelDataType;
    [readwrite setObject:[self getPixelDataTypeOptions:pixelDataType] forKey:@"pixel-data-type"];

    [readonly setObject:functionalUnit.preferredResolutions forKey:@"preferred-resolutions"];

    [readonly setObject:functionalUnit.preferredScaleFactors forKey:@"preferred-scale-factors"];
    
    [readwrite setObject:[NSString stringWithFormat:@"%@", @(functionalUnit.scaleFactor)] forKey:@"scale-factor"];
 
    NSRect scanArea = functionalUnit.scanArea;
    [readwrite setObject:[self getRectOptions:&scanArea] forKey:@"scan-area"];

    [readonly setObject:functionalUnit.supportedBitDepths forKey:@"supported-bit-depths"];
    
    ICEXIFOrientationType scanAreaOrientation = functionalUnit.scanAreaOrientation;
    [readwrite setObject:[self getScanAreaOrientation:scanAreaOrientation] forKey:@"scan-area-orientation"];
    
    // IMPORTANT ONEs.
    // functionalUnit.supportedBitDepths
    // functionalUnit.supportedResolutions
    // functionalUnit.supportedScaleFactors
    // functionalUnit.supportedMeasurementUnits
    
    // [dictionary setObject:functionalUnit.bitDepth forKey:@"bit-depth"];
    
    if ( ( functionalUnit.scanInProgress == NO ) && ( functionalUnit.overviewScanInProgress == NO ) )
    {
        if ( functionalUnit.type == ICScannerFunctionalUnitTypeDocumentFeeder )
        {
            ICScannerFunctionalUnitDocumentFeeder* dfu = (ICScannerFunctionalUnitDocumentFeeder*)functionalUnit;
            
            [readonly setObject:dfu.documentLoaded ? @"true": @"false" forKey:@"is-document-loaded"];
            
            // Can't access pointer of a property. This is a workaround.
            NSSize documentSize = dfu.documentSize;
            [readonly setObject:[self getSizeOptions:&documentSize] forKey:@"document-size"];
            
            NSSize physicalSize = dfu.physicalSize;
            [readonly setObject:[self getSizeOptions:&physicalSize] forKey:@"physical-size"];
            
            [readwrite setObject:dfu.duplexScanningEnabled ? @"true": @"false" forKey:@"is-duplex-scanning-enabled"];
            
            [readonly setObject:dfu.reverseFeederPageOrder ? @"true": @"false" forKey:@"is-reverse-feeder-page-order"];
            
            [readonly setObject:dfu.supportsDuplexScanning ? @"true": @"false" forKey:@"supports-duplex-scanning"];
            
            [readwrite setObject:[NSString stringWithFormat:@"%@", @(dfu.resolution)] forKey:@"resolution"];
            
            // IMPORTANT ONE.
            // dfu.documentType
            
            // dfu.evenPageOrientation
            // dfu.oddPageOrientation
            
            // IMPORTANT ONE.
            // dfu.supportedDocumentTypes

        }
    }
    
    return [self serializeJSON:@{@"response": @"settings", @"read-only-settings": readonly, @"read-write-settings": readwrite}];
}

@end