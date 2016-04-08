#import <Foundation/Foundation.h>
#import "AppController.h"

int main (int argc, const char * argv[])
{
    
    @autoreleasepool {
        
        /*
        NSFileHandle *input = [NSFileHandle fileHandleWithStandardInput];
        NSData *inputData = [NSData dataWithData:[input readDataToEndOfFile]];
        NSString *inputString = [[NSString alloc] initWithData:inputData encoding:NSUTF8StringEncoding];
        */
        
        AppController* appController = [[AppController alloc] init];
        [appController exec:@"{\"action\": \"scan\"}"];
        
    }
    
    return 0;
    
}