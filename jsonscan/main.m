#import <Foundation/Foundation.h>
#import "AppController.h"
#import "JsonConfiguration.h"

int main (int argc, const char * argv[])
{
    
    @autoreleasepool {
        
        AppController* appController = [[AppController alloc] init];
        
        if (argc < 2) {
            
            // TODO: display basic usage
            
        } else {
            
            NSString *inputString;
            
            if (argc == 2 && [[NSString stringWithCString:argv[1] encoding:NSUTF8StringEncoding] isEqualToString:@"-h"]) {

                NSDictionary * options = [JsonConfiguration getOptions];
                
                // TODO: display options usage.
                
            } else if (argc == 2 && [[NSString stringWithCString:argv[1] encoding:NSUTF8StringEncoding] isEqualToString:@"-l"]) {
                inputString = @"{\"action\": \"list\"}";
            } else if (argc == 2 && [[NSString stringWithCString:argv[1] encoding:NSUTF8StringEncoding] isEqualToString:@"-c"]) {
                NSFileHandle *input = [NSFileHandle fileHandleWithStandardInput];
                NSData *inputData = [NSData dataWithData:[input readDataToEndOfFile]];
                inputString = [[NSString alloc] initWithData:inputData encoding:NSUTF8StringEncoding];
            } else if (argc == 2 && [[NSString stringWithCString:argv[1] encoding:NSUTF8StringEncoding] isEqualToString:@"-s"]) {
                inputString = @"{\"action\": \"scan\"}";
            }
            
            [appController exec:inputString];
            
        }
        
    }
    
    return 0;
    
}