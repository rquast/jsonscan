#import "AppController.h"

#define NSLog(FORMAT, ...) printf("%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

@implementation AppController

@synthesize scanners = mScanners;

- (void)exec:(NSString*)inputString
{
    
    [self parseJSON:inputString];
    
    if (_configuration == nil) {
        return;
    }
    
    mScanners = [[NSMutableArray alloc] initWithCapacity:0];
    
    mDeviceBrowser = [[ICDeviceBrowser alloc] init];
    mDeviceBrowser.delegate = self;
    mDeviceBrowser.browsedDeviceTypeMask = ICDeviceLocationTypeMaskBonjour | ICDeviceLocationTypeMaskShared | ICDeviceLocationTypeMaskLocal |ICDeviceLocationTypeMaskRemote | ICDeviceTypeMaskScanner;
    
    [mDeviceBrowser start];

    mDeviceTimer = [NSTimer scheduledTimerWithTimeInterval:20.0 target:self selector:@selector(noDevicesFound:) userInfo:nil repeats:NO];
    
    CFRunLoopRun();
    
}

- (void)parseJSON:(NSString*)jsonString
{

    NSData * jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError * error = nil;
    _configuration = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    
    if (_configuration == nil) {
        NSLog(@"{\"repsonse\": \"%@\", \"error\": \"true\"}", [error localizedDescription]);
        [self exit];
    }
    
}

- (NSString*)serializeJSON:(NSDictionary*)dictionary
{
    NSError * error = nil;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&error];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

- (void)noDevicesFound:(NSTimer*)theTimer
{
    NSLog(@"{\"repsonse\": \"No scanners found.\", \"error\": \"true\"}");
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
        NSLog(@"%@", [addedDevice capabilities]);
    }
    
    if (!moreComing) {
        NSLog(@"All devices have been added.");
        if ([_configuration[@"action"] isEqualToString:@"list"]) {
            [self exit];
        } else {
            [self openCloseSession:nil];
        }
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
    // TODO: pick the right scanner via name in _configuration.
    for (ICScannerDevice *scanner in mScanners) {
        
        // if [scanner name] isEqualToString ....
        return scanner; // TODO: don't pick the first one in future.
        
    }

    [self exit];
    return nil;
}

- (void)didRemoveDevice:(ICDevice*)removedDevice
{
    
}

- (void)deviceDidBecomeReady:(ICScannerDevice*)scanner
{
}

- (void)device:(ICDevice*)device didCloseSessionWithError:(NSError*)error
{
    NSLog(@"device:didCloseSessionWithError: %@\n", [error localizedDescription]);
}

- (void)deviceDidChangeName:(ICDevice*)device;
{
}

- (void)deviceDidChangeSharingState:(ICDevice*)device
{
}

- (void)device:(ICDevice*)device didReceiveStatusInformation:(NSDictionary*)status
{
    NSLog( @"device: \n%@\ndidReceiveStatusInformation: \n%@\n", device, status );
    
    if ( [[status objectForKey:ICStatusNotificationKey] isEqualToString:ICScannerStatusWarmingUp] )
    {
        NSLog(@"Scanner warming up...");
    }
    else if ( [[status objectForKey:ICStatusNotificationKey] isEqualToString:ICScannerStatusWarmUpDone] )
    {
        NSLog(@"Scanner done warming up.");
    }
}

- (void)device:(ICDevice*)device didEncounterError:(NSError*)error
{
    NSLog( @"device: \n%@\ndidEncounterError: \n%@\n", device, error );
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
    
    // TODO: research this one.. selecting the right document feeder or flatbed.. often problematic with certain scanners.
    
    // TODO: only proceed if correct.
    
    /*
    BOOL correctFunctionalUnit = (configuration.config[ScanlineConfigOptionFlatbed] && scanner.selectedFunctionalUnit.type == ICScannerFunctionalUnitTypeFlatbed) || (!(configuration.config[ScanlineConfigOptionFlatbed]) && scanner.selectedFunctionalUnit.type == ICScannerFunctionalUnitTypeDocumentFeeder);
    if (correctFunctionalUnit && error == NULL) {
        DDLogInfo(@"Starting scan...");
        [self startScan:self];
    } else {
        DDLogVerbose( @"  error:          %@\n", error );
        [self selectFunctionalUnit:self];
    }
     */
    
    [self startScan:self];
    
}

- (void)scannerDevice:(ICScannerDevice*)scanner didCompleteOverviewScanWithError:(NSError*)error;
{
}

- (void)scannerDevice:(ICScannerDevice*)scanner didCompleteScanWithError:(NSError*)error;
{
    
    // TODO: implement this with json.
    
    /*
    if (configuration.config[ScanlineConfigOptionBatch]) {
        DDLogInfo(@"Press RETURN to scan next page or S to stop");
        int userInput;
        userInput = getchar();
        if (userInput != 's' && userInput != 'S')
        {
            [self startScan:self];
            return;
        }
    }
    
    
    if (configuration.config[ScanlineConfigOptionJPEG]) {
        // need to loop through all the scanned jpegs and output each of them
        for (NSURL* scannedFile in mScannedDestinationURLs) {
            [self outputAndTagFile:scannedFile];
        }
    } else {
        // Combine the JPEGs into a single PDF
        NSURL* scannedDestinationURL = [self combinedScanDestinations];
        [self outputAndTagFile:scannedDestinationURL];
    }
     */

    [self exit];
    
}

- (void)deviceBrowser:(ICDeviceBrowser*)browser deviceDidChangeName:(ICDevice*)device;
{
}

- (void)deviceBrowser:(ICDeviceBrowser*)browser deviceDidChangeSharingState:(ICDevice*)device;
{
}

- (void)device:(ICDevice*)device didOpenSessionWithError:(NSError*)error
{
    NSLog( @"device:didOpenSessionWithError: %@\n", error );
    [self selectFunctionalUnit:0];
}

- (void)scannerDevice:(ICScannerDevice*)scanner didScanToURL:(NSURL*)url data:(NSData*)data
{
    NSLog(@"Scan complete.");
    [mScannedDestinationURLs addObject:url];
}

- (IBAction)selectFunctionalUnit:(id)sender
{

    ICScannerDevice* scanner = [mScanners objectAtIndex:0];

    // TODO: change the false to a lookup in the config of ifUseFlatbed
    [scanner requestSelectFunctionalUnit:(ICScannerFunctionalUnitType) (false ? ICScannerFunctionalUnitTypeFlatbed : ICScannerFunctionalUnitTypeDocumentFeeder) ];

}

- (IBAction)startScan:(id)sender
{
    
    ICScannerDevice * scanner = [self selectedScanner];
    ICScannerFunctionalUnit * fu = scanner.selectedFunctionalUnit;

    if ([_configuration[@"action"] isEqualToString:@"list"]) return;
    
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
        scanner.documentUTI             = (id)kUTTypeJPEG;
        
        [scanner requestScan];
        
    } else {
        
        [scanner cancelScan];
        
    }
}

@end