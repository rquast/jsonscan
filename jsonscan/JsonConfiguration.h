#import <Foundation/Foundation.h>

@interface JsonConfiguration : NSObject

@property (strong) NSDictionary *action;

- (void)parseJSON:(NSString*)jsonString;
- (NSString*)serializeJSON:(NSDictionary*)dictionary;

@end
