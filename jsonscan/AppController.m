#import "AppController.h"

#define NSLog(FORMAT, ...) printf("%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

@implementation AppController

- (void)exec:(NSString*)inputString
{
    
    mConfiguration = [[JsonConfiguration alloc] init];
    
    [mConfiguration parseJSON:inputString];
    
    if (mConfiguration.action == nil) {
        [self exit];
        return;
    }
    
    mScanners = [[NSMutableArray alloc] initWithCapacity:0];
    
    mDeviceBrowser = [[ICDeviceBrowser alloc] init];
    mDeviceBrowser.delegate = self;
    mDeviceBrowser.browsedDeviceTypeMask = ICDeviceLocationTypeMaskBonjour | ICDeviceLocationTypeMaskShared | ICDeviceLocationTypeMaskLocal | ICDeviceLocationTypeMaskRemote | ICDeviceLocationTypeMaskBluetooth | ICDeviceTypeMaskScanner;
    
    [mDeviceBrowser start];

    mDeviceTimer = [NSTimer scheduledTimerWithTimeInterval:20.0 target:self selector:@selector(noDevicesFound:) userInfo:nil repeats:NO];
    
    CFRunLoopRun();
    
}

- (void)noDevicesFound:(NSTimer*)theTimer
{
    NSLog(@"{\"response\": \"status\", \"message\": \"No scanners found.\"}");
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
        if ([mConfiguration.action[@"action"] isEqualToString:@"list"]) {
            NSLog(@"{\"response\": \"found\", \"name\": \"%@\"}", [addedDevice name]);
        }
    }
    
    if (!moreComing) {
        if ([mConfiguration.action[@"action"] isEqualToString:@"list"]) {
            NSLog(@"{\"response\": \"status\", \"message\": \"All devices have been listed.\"}");
        }
        [self openCloseSession:nil];
    }
    
}

- (void)deviceBrowser:(ICDeviceBrowser*)browser didRemoveDevice:(ICDevice*)removedDevice moreGoing:(BOOL)moreGoing;
{
}

- (IBAction)openCloseSession:(id)sender
{
    if ( [self selectedScanner].hasOpenSession )
        [[self selectedScanner] requestCloseSession];
    else
        [[self selectedScanner] requestOpenSession];
}

- (ICScannerDevice*)selectedScanner
{

    for (ICScannerDevice *scanner in mScanners) {
        
        if (![[mConfiguration.action allKeys] containsObject:@"device-name"]) {
            return scanner;
        } else if ([mConfiguration.action[@"device-name"] isEqualToString:[scanner name]]) {
            return scanner;
        }
        
    }

    [self exit];
    return nil;
    
}

- (void)didRemoveDevice:(ICDevice*)removedDevice
{
    NSLog(@"{\"response\": \"status\", \"message\": \"Removed: %@\"}", [removedDevice name]);
}

- (void)deviceDidBecomeReady:(ICScannerDevice*)scanner
{
    NSLog(@"{\"response\": \"status\", \"message\": \"Scanner Ready: %@\"}", [scanner name]);
}

- (void)device:(ICDevice*)device didCloseSessionWithError:(NSError*)error
{
    if (error != nil) {
        NSLog(@"{\"response\": \"error\", \"message\": \"%@\"}", [error localizedDescription]);
    }
}

- (void)deviceDidChangeName:(ICDevice*)device;
{
    NSLog(@"{\"response\": \"status\", \"message\": \"Changed Name: %@\"}", [device name]);
}

- (void)deviceDidChangeSharingState:(ICDevice*)device
{
}

- (void)device:(ICDevice*)device didReceiveStatusInformation:(NSDictionary*)status
{
    if ( [[status objectForKey:ICStatusNotificationKey] isEqualToString:ICScannerStatusWarmingUp] ) {
        NSLog(@"{\"response\": \"status\", \"message\": \"Scanner warming up...\"}");
    } else if ( [[status objectForKey:ICStatusNotificationKey] isEqualToString:ICScannerStatusWarmUpDone] ) {
        NSLog(@"{\"response\": \"status\", \"message\": \"Scanner done warming up.\"}");
    }
}

- (void)device:(ICDevice*)device didEncounterError:(NSError*)error
{
    NSLog(@"{\"response\": \"error\", \"message\": \"%@\"}", [error localizedDescription]);
    [self exit];
}

- (void)device:(ICDevice*)device didReceiveButtonPress:(NSString*)button
{
}

- (void)scannerDeviceDidBecomeAvailable:(ICScannerDevice*)scanner;
{
    [scanner requestOpenSession];
}

- (void)deviceBrowser:(ICDeviceBrowser*)browser requestsSelectDevice:(ICDevice*)device
{
}

- (void)scannerDevice:(ICScannerDevice*)scanner didSelectFunctionalUnit:(ICScannerFunctionalUnit*)functionalUnit error:(NSError*)error
{
    
    if ([mConfiguration.action[@"action"] isEqualToString:@"list"]) {
        
        ICScannerDevice * scanner = [self selectedScanner];
        ICScannerFunctionalUnit * fu = scanner.selectedFunctionalUnit;
        NSString * scannerOptionsJson = [mConfiguration serializeJSON:[mConfiguration getScannerOptions:fu scannerName:[scanner name]]];
        NSLog(@"%@", scannerOptionsJson);
        
        [self exit];
        
    } else {
        
        [self startScan:self];
        
    }
    
}

- (void)scannerDevice:(ICScannerDevice*)scanner didCompleteOverviewScanWithError:(NSError*)error;
{
    
    if (error != nil) {
        NSLog(@"{\"response\": \"error\", \"message\": \"%@\"}", [error localizedDescription]);
    }
    
    [self exit];
    
}

- (void)scannerDevice:(ICScannerDevice*)scanner didCompleteScanWithError:(NSError*)error;
{

    if (error != nil) {
        NSLog(@"{\"response\": \"error\", \"message\": \"%@\"}", [error localizedDescription]);
    }
    
    [self exit];
    
}

- (void)deviceBrowser:(ICDeviceBrowser*)browser deviceDidChangeName:(ICDevice*)device
{
}

- (void)deviceBrowser:(ICDeviceBrowser*)browser deviceDidChangeSharingState:(ICDevice*)device
{
}

- (void)device:(ICDevice*)device didOpenSessionWithError:(NSError*)error
{
    if (error != nil) {
        NSLog(@"{\"response\": \"error\", \"message\": \"%@\"}", [error localizedDescription]);
    }
}

- (void)scannerDevice:(ICScannerDevice*)scanner didScanToURL:(NSURL*)url data:(NSData*)data
{
    
    NSString *timestamp = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString* destinationFile = [NSString stringWithFormat:@"%@/Desktop/scan_%@.png", NSHomeDirectory(), timestamp];
    [fm copyItemAtURL:url toURL:[NSURL fileURLWithPath:destinationFile] error:nil];
    NSLog(@"{\"response\": \"acquired\", \"file\": \"%@\"}", destinationFile);
    
}

- (IBAction)selectFunctionalUnit:(id)sender
{

    // TODO: choose either flatbed or document feeder from config.
    for (ICScannerDevice *scanner in mScanners) {
        
        if (![[mConfiguration.action allKeys] containsObject:@"device-name"]) {
            [scanner requestSelectFunctionalUnit:(ICScannerFunctionalUnitType) ICScannerFunctionalUnitTypeDocumentFeeder];
            return;
        } else if ([mConfiguration.action[@"device-name"] isEqualToString:[scanner name]]) {
            [scanner requestSelectFunctionalUnit:(ICScannerFunctionalUnitType) ICScannerFunctionalUnitTypeDocumentFeeder];
            return;
        }
        
    }

}

- (IBAction)startScan:(id)sender
{
    
    ICScannerDevice * scanner = [self selectedScanner];
    ICScannerFunctionalUnit * fu = scanner.selectedFunctionalUnit;
    
    [mConfiguration setScannerOptions:mConfiguration.action functionalUnit:fu];
    
    if ( ( fu.scanInProgress == NO ) && ( fu.overviewScanInProgress == NO ) ) {
        
        scanner.transferMode = ICScannerTransferModeFileBased;
        scanner.downloadsDirectory = [NSURL fileURLWithPath:NSTemporaryDirectory()];
        scanner.documentName = @"Scan";
        scanner.documentUTI = (id)kUTTypePNG;
        
        [scanner requestScan];
        
    } else {
        
        [scanner cancelScan];
        
    }
    
}

@end