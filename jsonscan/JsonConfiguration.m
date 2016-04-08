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

- (NSString*)getScannerOptions:(ICScannerFunctionalUnit*)functionalUnit
{
    
    NSMutableDictionary * dictionary = [[NSMutableDictionary alloc] init];

    [dictionary setObject:functionalUnit.acceptsThresholdForBlackAndWhiteScanning ? @"true": @"false" forKey:@"can-use-black-white-threshold"];
    [dictionary setObject:functionalUnit.canPerformOverviewScan ? @"true": @"false" forKey:@"can-perform-overview-scan"];
    
    [dictionary setObject:functionalUnit.usesThresholdForBlackAndWhiteScanning ? @"true": @"false" forKey:@"use-back-white-threshold"];
    
    // [dictionary setObject:functionalUnit.bitDepth forKey:@"bit-depth"];
    
    if ( ( functionalUnit.scanInProgress == NO ) && ( functionalUnit.overviewScanInProgress == NO ) )
    {
        if ( functionalUnit.type == ICScannerFunctionalUnitTypeDocumentFeeder )
        {
            ICScannerFunctionalUnitDocumentFeeder* dfu = (ICScannerFunctionalUnitDocumentFeeder*)functionalUnit;
            
            [dictionary setObject:dfu.documentLoaded ? @"true": @"false" forKey:@"is-document-loaded"];
            
            [dictionary setObject:[NSString stringWithFormat:@"%f x %f", dfu.documentSize.width, dfu.documentSize.height] forKey:@"document-size"];
            
            [dictionary setObject:dfu.duplexScanningEnabled ? @"true": @"false" forKey:@"is-duplex-scanning-enabled"];
            
            [dictionary setObject:dfu.reverseFeederPageOrder ? @"true": @"false" forKey:@"is-reverse-feeder-page-order"];
            
            [dictionary setObject:dfu.supportsDuplexScanning ? @"true": @"false" forKey:@"supports-duplex-scanning"];
            
            [dictionary setObject:[NSString stringWithFormat:@"%@", @(dfu.resolution)] forKey:@"resolution"];

        }
    }
    
    return [self serializeJSON:(NSDictionary*)dictionary];
}

@end