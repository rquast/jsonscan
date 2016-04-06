#import <Cocoa/Cocoa.h>
#import <ImageCaptureCore/ImageCaptureCore.h>

@interface AppController : NSObject <ICDeviceBrowserDelegate, ICScannerDeviceDelegate>
{
    
    ICDeviceBrowser*                mDeviceBrowser;
    NSMutableArray*                 mScanners;
    NSMutableArray*                 mScannedDestinationURLs;
    
    NSTimer*                        mDeviceTimer;
}

@property(strong)                   NSMutableArray*     scanners;
@property(strong)                   NSDictionary*       configuration;

- (void)exec:(NSString*)inputString;
- (void)parseJSON:(NSString*)jsonString;

@end




