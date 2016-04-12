#import <Cocoa/Cocoa.h>
#import <ImageCaptureCore/ImageCaptureCore.h>

#import "OrderedDictionary.h"

@interface JsonConfiguration : NSObject

@property (strong) NSDictionary *action;

- (void)parseJSON:(NSString*)jsonString;
- (NSString*)serializeJSON:(NSDictionary*)dictionary;
- (NSString*)getScannerOptions:(ICScannerFunctionalUnit*)functionalUnit;
- (NSDictionary*)getSizeOptions:(NSSize*)size;

@end
