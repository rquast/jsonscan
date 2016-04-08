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
    NSLog(@"{\"repsonse\": \"status\", \"message\": \"No scanners found.\"}");
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
            NSLog(@"{\"repsonse\": \"found\", \"name\": \"%@\"}", [addedDevice name]);
        }
    }
    
    if (!moreComing) {
        if ([mConfiguration.action[@"action"] isEqualToString:@"list"]) {
            NSLog(@"{\"repsonse\": \"status\", \"message\": \"All devices have been listed.\"}");
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
    NSLog(@"{\"repsonse\": \"status\", \"message\": \"Removed: %@\"}", [removedDevice name]);
}

- (void)deviceDidBecomeReady:(ICScannerDevice*)scanner
{
    NSLog(@"{\"repsonse\": \"status\", \"message\": \"Scanner Ready: %@\"}", [scanner name]);
}

- (void)device:(ICDevice*)device didCloseSessionWithError:(NSError*)error
{
    if (error != nil) {
        NSLog(@"{\"repsonse\": \"error\", \"message\": \"%@\"}", [error localizedDescription]);
    }
}

- (void)deviceDidChangeName:(ICDevice*)device;
{
    NSLog(@"{\"repsonse\": \"status\", \"message\": \"Changed Name: %@\"}", [device name]);
}

- (void)deviceDidChangeSharingState:(ICDevice*)device
{
}

- (void)device:(ICDevice*)device didReceiveStatusInformation:(NSDictionary*)status
{
    if ( [[status objectForKey:ICStatusNotificationKey] isEqualToString:ICScannerStatusWarmingUp] ) {
        NSLog(@"{\"repsonse\": \"status\", \"message\": \"Scanner warming up...\"}");
    } else if ( [[status objectForKey:ICStatusNotificationKey] isEqualToString:ICScannerStatusWarmUpDone] ) {
        NSLog(@"{\"repsonse\": \"status\", \"message\": \"Scanner done warming up.\"}");
    }
}

- (void)device:(ICDevice*)device didEncounterError:(NSError*)error
{
    NSLog(@"{\"repsonse\": \"error\", \"message\": \"%@\"}", [error localizedDescription]);
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
        NSString * scannerOptionsJson = [mConfiguration getScannerOptions:fu];
        NSLog(@"%@", scannerOptionsJson);
        
        [self exit];
        
    } else {
        
        [self startScan:self];
        
    }
    
}

- (void)scannerDevice:(ICScannerDevice*)scanner didCompleteOverviewScanWithError:(NSError*)error;
{
    
    if (error != nil) {
        NSLog(@"{\"repsonse\": \"error\", \"message\": \"%@\"}", [error localizedDescription]);
    }
    
    [self exit];
    
}

- (void)scannerDevice:(ICScannerDevice*)scanner didCompleteScanWithError:(NSError*)error;
{

    if (error != nil) {
        NSLog(@"{\"repsonse\": \"error\", \"message\": \"%@\"}", [error localizedDescription]);
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
        NSLog(@"{\"repsonse\": \"error\", \"message\": \"%@\"}", [error localizedDescription]);
    }
}

- (void)scannerDevice:(ICScannerDevice*)scanner didScanToURL:(NSURL*)url data:(NSData*)data
{
    
    NSString *timestamp = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString* destinationFile = [NSString stringWithFormat:@"%@/Desktop/scan_%@.png", NSHomeDirectory(), timestamp];
    [fm copyItemAtURL:url toURL:[NSURL fileURLWithPath:destinationFile] error:nil];
    NSLog(@"{\"repsonse\": \"status\", \"message\": \"Page scanned.\", \"file\": \"%@\"}", destinationFile);
    
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
    
    if ( ( fu.scanInProgress == NO ) && ( fu.overviewScanInProgress == NO ) )
    {
        if ( fu.type == ICScannerFunctionalUnitTypeDocumentFeeder )
        {
            // ICScannerFunctionalUnitDocumentFeeder* dfu = (ICScannerFunctionalUnitDocumentFeeder*)fu;
            
            // TODO: set the following options via json
            // dfu.documentType = (configuration.config[ScanlineConfigOptionLegal]) ? ICScannerDocumentTypeUSLegal : ICScannerDocumentTypeUSLetter;
            // dfu.duplexScanningEnabled = (BOOL)configuration.config[ScanlineConfigOptionDuplex];
        }
        else
        {
            NSSize s;
            
            fu.measurementUnit  = ICScannerMeasurementUnitInches;
            if ( fu.type == ICScannerFunctionalUnitTypeFlatbed )
                s = ((ICScannerFunctionalUnitFlatbed*)fu).physicalSize;
            else if ( fu.type == ICScannerFunctionalUnitTypePositiveTransparency )
                s = ((ICScannerFunctionalUnitPositiveTransparency*)fu).physicalSize;
            else
                s = ((ICScannerFunctionalUnitNegativeTransparency*)fu).physicalSize;
            fu.scanArea         = NSMakeRect( 0.0, 0.0, s.width, s.height );
        }
        
        // TODO: use _configuration
        fu.resolution = 300;
        
        // TODO: use _configuration
        if (true) {
            fu.pixelDataType = ICScannerPixelDataTypeBW;
            fu.bitDepth = ICScannerBitDepth1Bit;
        } else {
            fu.pixelDataType                = ICScannerPixelDataTypeRGB;
            fu.bitDepth                     = ICScannerBitDepth8Bits;
        }
        
        scanner.transferMode            = ICScannerTransferModeFileBased;
        scanner.downloadsDirectory      = [NSURL fileURLWithPath:NSTemporaryDirectory()];
        scanner.documentName            = @"Scan";
        scanner.documentUTI             = (id)kUTTypePNG;
        
        [scanner requestScan];
        
    } else {
        
        [scanner cancelScan];
        
    }
}

@end