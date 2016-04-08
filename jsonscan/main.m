#import <Foundation/Foundation.h>
#import "AppController.h"

int main (int argc, const char * argv[])
{
    
    @autoreleasepool {

        NSString *inputString = @"{\"action\": \"list\"}";
        
        if (argc == 2 && [[NSString stringWithCString:argv[1] encoding:NSUTF8StringEncoding] isEqualToString:@"-c"]) {
            NSFileHandle *input = [NSFileHandle fileHandleWithStandardInput];
            NSData *inputData = [NSData dataWithData:[input readDataToEndOfFile]];
            inputString = [[NSString alloc] initWithData:inputData encoding:NSUTF8StringEncoding];
        } else if (argc == 2 && [[NSString stringWithCString:argv[1] encoding:NSUTF8StringEncoding] isEqualToString:@"-c"]) {
            inputString = @"{\"action\": \"scan\"}";
        }
        
        AppController* appController = [[AppController alloc] init];
        [appController exec:inputString];
        
    }
    
    return 0;
    
}