#import "AppController.h"

#define NSLog(FORMAT, ...) printf("%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

@implementation AppController

@synthesize scanners = mScanners;

- (void)exec:(NSString*)inputString
{
    
    [self parseJSON:inputString];
    
    mScanners = [[NSMutableArray alloc] initWithCapacity:0];
    
    mDeviceBrowser = [[ICDeviceBrowser alloc] init];
    mDeviceBrowser.delegate = self;
    mDeviceBrowser.browsedDeviceTypeMask = ICDeviceLocationTypeMaskBonjour | ICDeviceLocationTypeMaskShared | ICDeviceLocationTypeMaskLocal |ICDeviceLocationTypeMaskRemote | ICDeviceTypeMaskScanner;
    
    NSLog(@"Available scanners:");
    
    [mDeviceBrowser start];

    mDeviceTimer = [NSTimer scheduledTimerWithTimeInterval:20.0 target:self selector:@selector(noDevicesFound:) userInfo:nil repeats:NO];
    
}

- (void)parseJSON:(NSString*)jsonString
{

    NSData * jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError * error = nil;
    _configuration = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    
    if (_configuration != nil) {
        NSLog(@"ACTION: %@", _configuration[@"action"]);
    } else {
        NSLog(@"%@", [error localizedDescription]);
    }
    
}

- (void)noDevicesFound:(NSTimer*)theTimer
{
    NSLog(@"No scanners found.");
    [self exit];
}

- (void)exit
{
    CFRunLoopStop(CFRunLoopGetCurrent());
}

- (void)deviceBrowser:(ICDeviceBrowser*)browser didAddDevice:(ICDevice*)addedDevice moreComing:(BOOL)moreComing
{
    
    if ( (addedDevice.type & ICDeviceTypeMaskScanner) == ICDeviceTypeScanner )
    {
        if (mDeviceTimer) {
            [mDeviceTimer invalidate];
            mDeviceTimer = nil;
        }
        [mScanners addObject:addedDevice];
        addedDevice.delegate = self;
        NSLog(@"%@", [addedDevice name]);
        
    }
    
    if (!moreComing) {
        NSLog(@"All devices have been added.");
        [self exit];
    }
    
}

- (void)deviceBrowser:(ICDeviceBrowser*)browser didRemoveDevice:(ICDevice*)removedDevice moreGoing:(BOOL)moreGoing;
{
    
    
}

- (void)didRemoveDevice:(ICDevice*)removedDevice
{
    
}

@end