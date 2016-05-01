#import <Cocoa/Cocoa.h>
#import <ImageCaptureCore/ImageCaptureCore.h>

#import "OrderedDictionary.h"

static NSString * const JSCOptionCanUseBlackWhiteThreshold = @"can-use-black-white-threshold";
static NSString * const JSCOptionUseBlackWhiteThreshold = @"use-back-white-threshold";
static NSString * const JSCOptionDefaultBlackWhiteThreshold = @"default-black-and-white-threshold";
static NSString * const JSCOptionThresholdForBlackAndWhiteScanning = @"threshold-for-black-and-white-scanning";
static NSString * const JSCCanPerformOverviewScan = @"can-perform-overview-scan";
static NSString * const JSCOverviewResolution = @"overview-resolution";
static NSString * const JSCBitDepth = @"bit-depth";
static NSString * const JSCMeasurementUnit = @"measurement-unit";
static NSString * const JSCNativeXResolution = @"native-x-resolution";
static NSString * const JSCNativeYResolution = @"native-y-resolution";
static NSString * const JSCPixelDataType = @"pixel-data-type";
static NSString * const JSCSupportedPixelDataTypes = @"supported-pixel-data-types";
static NSString * const JSCScaleFactor = @"scale-factor";
static NSString * const JSCSupportedBitDepths = @"supported-bit-depths";
static NSString * const JSCPreferredResolutions = @"preferred-resolutions";
static NSString * const JSCPreferredScaleFactors = @"preferred-scale-factors";
static NSString * const JSCSupportedMeasurementUnits = @"supported-measurement-units";
static NSString * const JSCScanArea = @"scan-area";
static NSString * const JSCScanAreaOrientation = @"scan-area-orientation";
static NSString * const JSCIsDocumentLoaded = @"is-document-loaded";
static NSString * const JSCDocumentSize = @"document-size";
static NSString * const JSCPhysicalSize = @"physical-size";
static NSString * const JSCIsDuplexScanningEnabled = @"is-duplex-scanning-enabled";
static NSString * const JSCIsReverseFeederPageOrder = @"is-reverse-feeder-page-order";
static NSString * const JSCSupportsDuplexScanning = @"supports-duplex-scanning";
static NSString * const JSCResolution = @"resolution";
static NSString * const JSCDocumentType = @"document-type";
static NSString * const JSCSupportedDocumentTypes = @"supported-document-types";
static NSString * const JSCEvenPageOrientation = @"even-page-orientation";
static NSString * const JSCOddPageOrientation = @"odd-page-orientation";

@interface JsonConfiguration : NSObject

@property (strong) NSDictionary *action;
@property (strong) NSDictionary *options;

- (void)parseJSON:(NSString*)jsonString;
- (NSString*)serializeJSON:(NSDictionary*)dictionary;
- (MutableOrderedDictionary*)getScannerOptions:(ICScannerFunctionalUnit*)functionalUnit scannerName:(NSString*)scannerName;
- (void)setScannerOptions:(NSDictionary*)scannerOptions functionalUnit:(ICScannerFunctionalUnit*)functionalUnit;
- (NSDictionary*)getSizeOptions:(NSSize*)size;
+ (NSDictionary*)getOptions;

@end
