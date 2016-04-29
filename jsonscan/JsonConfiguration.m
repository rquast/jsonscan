#import "JsonConfiguration.h"

#define NSLog(FORMAT, ...) printf("%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

@implementation JsonConfiguration

- (id)init
{
    self = [super init];
    if (self)
    {
        _options = [JsonConfiguration getOptions];
    }
    return self;
}

+ (NSDictionary*)getOptions
{
    
    return @{
             
             JSCIsDocumentLoaded: @{
                     @"description": @"Is there a page loaded in the document feeder?",
                     },
             JSCIsDuplexScanningEnabled: @{
                     @"description": @"Is double-sided scanning (duplex) enabled?",
                     @"see": JSCSupportsDuplexScanning
                     },
             JSCIsReverseFeederPageOrder: @{
                     @"description": @"Does the document feeder support reading pages from back to front?",
                     },
             JSCSupportsDuplexScanning: @{
                     @"description": @"Does this device support double-sided scanning?",
                     @"see": JSCIsDuplexScanningEnabled
                     },
             JSCCanPerformOverviewScan: @{
                     @"description": @"Can perform an overview scan (a quick scan for displaying a preview image).",
                     @"see": JSCOverviewResolution
                     },
             JSCOverviewResolution: @{
                     @"description": @"Resolution in DPI for overview scans.",
                     @"see": JSCCanPerformOverviewScan
                     },
             JSCMeasurementUnit: @{
                     @"description": @"The measurement unit (type of measurement) used for measurements.",
                     @"see": JSCSupportedMeasurementUnits
                     },
             JSCSupportedMeasurementUnits: @{
                     @"setter": JSCMeasurementUnit,
                     @"description": @"A list of supported measurement units for this device.",
                     },
             JSCResolution: @{
                     @"description": @"The resolution for scanning (in DPI).",
                     @"see": JSCPreferredResolutions
                     },
             JSCPreferredResolutions: @{
                     @"setter": JSCResolution,
                     @"description": @"A list of resolutions that the device prefers for scanning.",
                     },
             JSCNativeXResolution: @{
                     @"description": @"The native resolution of the scanner across the x axis.",
                     @"see": JSCNativeYResolution
                     },
             JSCNativeYResolution: @{
                     @"description": @"The native resolution of the scanner across the y axis.",
                     @"see": JSCNativeXResolution
                     },
             JSCScanArea: @{
                     @"description": @"The area to be scanned.",
                     },
             JSCScanAreaOrientation: @{
                     @"description": @"Page orientation for the scan."
                     },
             JSCEvenPageOrientation: @{
                     @"description": @"Page orientation for the scan for for even pages.",
                     },
             JSCOddPageOrientation: @{
                     @"description": @"Page orientation for the scan for for odd pages.",
                     },
             JSCDocumentType: @{
                     @"description": @"The document type to be scanned.",
                     @"see": JSCSupportedDocumentTypes
                     },
             JSCSupportedDocumentTypes: @{
                     @"setter": JSCDocumentType,
                     @"description": @"A list of supported document types that can be scanned."
                     },
             JSCDocumentSize: @{
                     @"description": @"The size of the document to be scanned."
                     },
             JSCScaleFactor: @{
                     @"description": @"The scale (in percent) that the image is to be scanned at.",
                     @"see": JSCPreferredScaleFactors
                     },
             JSCPreferredScaleFactors: @{
                     @"setter": JSCScaleFactor,
                     @"description": @"A list of preferred scale factors for the device."
                     },
             JSCBitDepth: @{
                     @"description": @"The bit depth to scan at.",
                     @"see": JSCSupportedBitDepths
                     },
             JSCSupportedBitDepths: @{
                     @"setter": JSCBitDepth,
                     @"description": @"A list of supported bit depths the device is capable of.",
                     },
             JSCPixelDataType: @{
                     @"description": @"Pixel data type for the scan.",
                     @"see": JSCSupportedPixelDataTypes
                     },
             JSCSupportedPixelDataTypes: @{
                     @"setter": JSCPixelDataType,
                     @"description": @"A list of supported pixel data types for the device."
                     },
             JSCOptionCanUseBlackWhiteThreshold: @{
                     @"setter": JSCOptionThresholdForBlackAndWhiteScanning,
                     @"description": @"Convert images to black & white using a threshold value.",
                     @"see": JSCOptionDefaultBlackWhiteThreshold
                     },
             JSCOptionDefaultBlackWhiteThreshold: @{
                     @"setter": JSCOptionThresholdForBlackAndWhiteScanning,
                     @"description": @"A default value for the black and white scanning conversion threshold.",
                     @"see": JSCOptionCanUseBlackWhiteThreshold
                     },
             JSCOptionThresholdForBlackAndWhiteScanning: @{
                     @"description": @"A value between 0 and 255 for the black and white scanning conversion threshold.",
                     @"see": JSCOptionCanUseBlackWhiteThreshold
                     }
             
             };
    
}

- (void)parseJSON:(NSString*)jsonString
{
    
    NSData * jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError * error = nil;
    
    _action = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    
    if (_action == nil) {
        NSLog(@"{\"response\": \"error\", \"message\": \"%@\"}", [error localizedDescription]);
    }
    
}

- (NSString*)serializeJSON:(NSDictionary*)dictionary
{
    NSError * error = nil;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&error];
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

- (NSString*)getBoolString:(BOOL)value
{
    return value ? @"true" : @"false";
}

- (void)setScannerOptions:(NSDictionary*)scannerOptions functionalUnit:(ICScannerFunctionalUnit*)functionalUnit
{
    if (scannerOptions == nil) {
        return;
    }
    
    // JSCOptionUseBlackWhiteThreshold
    
    NSString * useBlackWhiteThreshold = [scannerOptions objectForKey:JSCOptionUseBlackWhiteThreshold];
    if (useBlackWhiteThreshold) {
        if ([useBlackWhiteThreshold isEqualToString:@"true"]) {
            functionalUnit.usesThresholdForBlackAndWhiteScanning = YES;
        } else if ([useBlackWhiteThreshold isEqualToString:@"false"]) {
            functionalUnit.usesThresholdForBlackAndWhiteScanning = NO;
        }
    } else {
        functionalUnit.usesThresholdForBlackAndWhiteScanning = NO;
    }
    
    // JSCOptionThresholdForBlackAndWhiteScanning
    
    NSString * blackAndWhiteThreshold = [scannerOptions objectForKey:JSCOptionThresholdForBlackAndWhiteScanning];
    if (blackAndWhiteThreshold) {
        // TODO: make sure this works properly!
        functionalUnit.thresholdForBlackAndWhiteScanning = (unsigned char) blackAndWhiteThreshold.intValue;
    }
    
    // JSCOverviewResolution
    
    NSString * overviewResolution = [scannerOptions objectForKey:JSCOverviewResolution];
    if (overviewResolution) {
        // TODO: make sure this works properly!
        functionalUnit.overviewResolution = (NSUInteger) overviewResolution.integerValue;
    }
    
    // JSCBitDepth
    
    NSString * bitDepth = [scannerOptions objectForKey:JSCBitDepth];
    if (bitDepth) {
        functionalUnit.bitDepth = bitDepth.intValue;
    } else {
        functionalUnit.bitDepth = ICScannerBitDepth8Bits;
    }
    
    // JSCMeasurementUnit
    
    NSString * measurementUnit = [scannerOptions objectForKey:JSCMeasurementUnit];
    if (measurementUnit) {
        functionalUnit.measurementUnit = measurementUnit.intValue;
    }
    
    // JSCPixelDataType
    
    NSString * pixelDataType = [scannerOptions objectForKey:JSCPixelDataType];
    if (pixelDataType) {
        functionalUnit.pixelDataType = pixelDataType.intValue;
    } else {
        functionalUnit.pixelDataType = ICScannerPixelDataTypeRGB;
    }
    
    // JSCScaleFactor
    
    NSString * scaleFactor = [scannerOptions objectForKey:JSCScaleFactor];
    if (scaleFactor) {
        // TODO: make sure this works properly!
        functionalUnit.scaleFactor = (NSUInteger) scaleFactor.integerValue;
    }
    
    // JSCScanArea
    
    NSDictionary * scanArea = [scannerOptions objectForKey:JSCScanArea];
    if (scanArea) {
        // TODO: make sure this works properly!
        functionalUnit.scanArea = NSMakeRect ([[scanArea objectForKey:@"x"] intValue],
                                              [[scanArea objectForKey:@"y"] intValue],
                                              [[scanArea objectForKey:@"width"] intValue],
                                              [[scanArea objectForKey:@"height"] intValue]
                                              );
    } else {
        
        if ( functionalUnit.type != ICScannerFunctionalUnitTypeDocumentFeeder ) {
            
            NSSize s;
            
            functionalUnit.measurementUnit  = ICScannerMeasurementUnitInches;
            
            if ( functionalUnit.type == ICScannerFunctionalUnitTypeFlatbed ) {
                s = ((ICScannerFunctionalUnitFlatbed*)functionalUnit).physicalSize;
            } else if ( functionalUnit.type == ICScannerFunctionalUnitTypePositiveTransparency ) {
                s = ((ICScannerFunctionalUnitPositiveTransparency*)functionalUnit).physicalSize;
            } else {
                s = ((ICScannerFunctionalUnitNegativeTransparency*)functionalUnit).physicalSize;
            }
            
            functionalUnit.scanArea = NSMakeRect(0.0, 0.0, s.width, s.height);
            
        }
        
    }
    
    // JSCScanAreaOrientation
    
    NSString * scanAreaOrientation = [scannerOptions objectForKey:JSCScanAreaOrientation];
    if (scanAreaOrientation) {
        functionalUnit.scanAreaOrientation = scanAreaOrientation.intValue;
    }
    
    
    // JSCResolution
    
    NSString * resolution = [scannerOptions objectForKey:JSCResolution];
    if (resolution) {
        // TODO: make sure this works properly!
        functionalUnit.resolution = (NSUInteger) resolution.integerValue;
    } else {
        functionalUnit.resolution = 300;
    }
    
    if (functionalUnit.type == ICScannerFunctionalUnitTypeDocumentFeeder) {
        
        ICScannerFunctionalUnitDocumentFeeder* dfu = (ICScannerFunctionalUnitDocumentFeeder*)functionalUnit;
        
        // JSCDocumentType
        
        NSString * documentType = [scannerOptions objectForKey:JSCDocumentType];
        if (documentType) {
            dfu.documentType = documentType.intValue;
        }
        
        // JSCEvenPageOrientation
        
        NSString * evenPageOrientation = [scannerOptions objectForKey:JSCEvenPageOrientation];
        if (evenPageOrientation) {
            dfu.evenPageOrientation = evenPageOrientation.intValue;
        }
        
        // JSCOddPageOrientation
        
        NSString * oddPageOrientation = [scannerOptions objectForKey:JSCOddPageOrientation];
        if (oddPageOrientation) {
            dfu.oddPageOrientation = oddPageOrientation.intValue;
        }
        
        // JSCIsDuplexScanningEnabled
        
        NSString * duplexScanningEnabled = [scannerOptions objectForKey:JSCIsDuplexScanningEnabled];
        if (duplexScanningEnabled) {
            if ([duplexScanningEnabled isEqualToString:@"true"]) {
                dfu.duplexScanningEnabled = YES;
            } else if ([duplexScanningEnabled isEqualToString:@"false"]) {
                dfu.duplexScanningEnabled = NO;
            }
        } else {
            dfu.duplexScanningEnabled = NO;
        }
        
    }
    
}

- (MutableOrderedDictionary*)getScannerOptions:(ICScannerFunctionalUnit*)functionalUnit
{
    
    // TODO: functionalUnit.overviewImage
    
    MutableOrderedDictionary * d = [[MutableOrderedDictionary alloc] init];
    MutableOrderedDictionary * readonly = [[MutableOrderedDictionary alloc] init];
    MutableOrderedDictionary * readwrite = [[MutableOrderedDictionary alloc] init];

    [readonly setObject:[self getBoolString: functionalUnit.acceptsThresholdForBlackAndWhiteScanning] forKey:JSCOptionCanUseBlackWhiteThreshold];
    
    [readwrite setObject:[self getBoolString: functionalUnit.usesThresholdForBlackAndWhiteScanning] forKey:JSCOptionUseBlackWhiteThreshold];
    
    [readonly setObject:[NSString stringWithFormat:@"%@", @(functionalUnit.defaultThresholdForBlackAndWhiteScanning)] forKey:JSCOptionDefaultBlackWhiteThreshold];
    
    [readwrite setObject:[NSString stringWithFormat:@"%@", @(functionalUnit.thresholdForBlackAndWhiteScanning)] forKey:JSCOptionThresholdForBlackAndWhiteScanning];
    
    [readonly setObject:[self getBoolString: functionalUnit.canPerformOverviewScan] forKey:JSCCanPerformOverviewScan];
    
    ICScannerBitDepth bitDepth = functionalUnit.bitDepth;
    [readwrite setObject:[self getBitDepthOptions:bitDepth] forKey:JSCBitDepth];
    
    ICScannerMeasurementUnit measurementUnit = functionalUnit.measurementUnit;
    [readwrite setObject:[self getMeasurementUnitOptions:measurementUnit] forKey:JSCMeasurementUnit];
    
    [readonly setObject:[NSString stringWithFormat:@"%@", @(functionalUnit.nativeXResolution)] forKey:JSCNativeXResolution];
    [readonly setObject:[NSString stringWithFormat:@"%@", @(functionalUnit.nativeYResolution)] forKey:JSCNativeYResolution];
    
    [readwrite setObject:[NSString stringWithFormat:@"%@", @(functionalUnit.overviewResolution)] forKey:JSCOverviewResolution];

    ICScannerPixelDataType pixelDataType = functionalUnit.pixelDataType;
    [readwrite setObject:[self getPixelDataTypeOptions:pixelDataType] forKey:JSCPixelDataType];

    MutableOrderedDictionary * supportedPixelDataTypes = [[MutableOrderedDictionary alloc] init];
    for (int i = 0; i <= 8; i++) {
        [supportedPixelDataTypes addEntriesFromDictionary:[self getPixelDataTypeOptions:i]];
    };
    [readonly setObject:supportedPixelDataTypes forKey:JSCSupportedPixelDataTypes];
    
    [readwrite setObject:[NSString stringWithFormat:@"%@", @(functionalUnit.scaleFactor)] forKey:JSCScaleFactor];
    
    MutableOrderedDictionary * supportedBitDepths = [[MutableOrderedDictionary alloc] init];
    [functionalUnit.supportedBitDepths enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [supportedBitDepths addEntriesFromDictionary:[self getBitDepthOptions:idx]];
    }];
    [readonly setObject:supportedBitDepths forKey:JSCSupportedBitDepths];
    
    MutableOrderedDictionary * preferredResolutions = [[MutableOrderedDictionary alloc] init];
    [functionalUnit.preferredResolutions enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [preferredResolutions addEntriesFromDictionary:[self getResolutionOptions:idx]];
    }];
    [readonly setObject:preferredResolutions forKey:JSCPreferredResolutions];
    
    MutableOrderedDictionary * preferredScaleFactors = [[MutableOrderedDictionary alloc] init];
    [functionalUnit.preferredScaleFactors enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [preferredScaleFactors addEntriesFromDictionary:[self getScaleFactorOptions:idx]];
    }];
    [readonly setObject:preferredScaleFactors forKey:JSCPreferredScaleFactors];
    
    MutableOrderedDictionary * supportedMeasurementUnits = [[MutableOrderedDictionary alloc] init];
    [functionalUnit.supportedMeasurementUnits enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [supportedMeasurementUnits addEntriesFromDictionary:[self getMeasurementUnitOptions:idx]];
    }];
    [readonly setObject:supportedMeasurementUnits forKey:JSCSupportedMeasurementUnits];
    
    NSRect scanArea = functionalUnit.scanArea;
    [readwrite setObject:[self getRectOptions:&scanArea] forKey:JSCScanArea];

    ICEXIFOrientationType scanAreaOrientation = functionalUnit.scanAreaOrientation;
    [readwrite setObject:[self getOrientationOptions:scanAreaOrientation] forKey:JSCScanAreaOrientation];
    
    if ((functionalUnit.scanInProgress == NO) && (functionalUnit.overviewScanInProgress == NO)) {
        
        if (functionalUnit.type == ICScannerFunctionalUnitTypeDocumentFeeder) {
            
            ICScannerFunctionalUnitDocumentFeeder* dfu = (ICScannerFunctionalUnitDocumentFeeder*)functionalUnit;
            
            [readonly setObject:[self getBoolString: dfu.documentLoaded] forKey:JSCIsDocumentLoaded];

            NSSize documentSize = dfu.documentSize;
            [readonly setObject:[self getSizeOptions:&documentSize] forKey:JSCDocumentSize];
            
            NSSize physicalSize = dfu.physicalSize;
            [readonly setObject:[self getSizeOptions:&physicalSize] forKey:JSCPhysicalSize];
            
            [readwrite setObject:[self getBoolString: dfu.duplexScanningEnabled] forKey:JSCIsDuplexScanningEnabled];
            
            [readonly setObject:[self getBoolString: dfu.reverseFeederPageOrder] forKey:JSCIsReverseFeederPageOrder];
            
            [readonly setObject:[self getBoolString: dfu.supportsDuplexScanning] forKey:JSCSupportsDuplexScanning];
            
            [readwrite setObject:[NSString stringWithFormat:@"%@", @(dfu.resolution)] forKey:JSCResolution];

            ICScannerDocumentType documentType = dfu.documentType;
            [readwrite setObject:[self getDocumentTypeOptions:documentType] forKey:JSCDocumentType];
            
            MutableOrderedDictionary * supportedDocumentTypes = [[MutableOrderedDictionary alloc] init];
            [dfu.supportedDocumentTypes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
                [supportedDocumentTypes addEntriesFromDictionary:[self getDocumentTypeOptions:idx]];
            }];
            [readonly setObject:supportedDocumentTypes forKey:JSCSupportedDocumentTypes];
            
            ICEXIFOrientationType evenPageOrientation = dfu.evenPageOrientation;
            [readwrite setObject:[self getOrientationOptions:evenPageOrientation] forKey:JSCEvenPageOrientation];

            ICEXIFOrientationType oddPageOrientation = dfu.oddPageOrientation;
            [readwrite setObject:[self getOrientationOptions:oddPageOrientation] forKey:JSCOddPageOrientation];

        }
        
    }
    
    [d setObject:@"settings" forKey:@"response"];
    [d setObject:readonly forKey:@"read-only-settings"];
    [d setObject:readwrite forKey:@"read-write-settings"];
    
    return d;
    
}

@end