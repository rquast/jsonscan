#import <Cocoa/Cocoa.h>
#import <ImageCaptureCore/ImageCaptureCore.h>

#import "OrderedDictionary.h"

static NSString * const JSCOptionCanUseBlackWhiteThreshold = @"can-use-black-white-threshold";
static NSString * const JSCOptionUseBlackWhiteThreshold = @"use-back-white-threshold";
static NSString * const JSCOptionDefaultBlackWhiteThreshold = @"default-black-and-white-threshold";
static NSString * const JSCOptionThresholdForBlackAndWhiteScanning = @"threshold-for-black-and-white-scanning";

@interface JsonConfiguration : NSObject

@property (strong) NSDictionary *action;
@property (strong) NSDictionary *options;

- (void)parseJSON:(NSString*)jsonString;
- (NSString*)serializeJSON:(NSDictionary*)dictionary;
- (NSString*)getScannerOptions:(ICScannerFunctionalUnit*)functionalUnit;
- (NSDictionary*)getSizeOptions:(NSSize*)size;

@end
