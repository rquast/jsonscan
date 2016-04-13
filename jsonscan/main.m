#import <Foundation/Foundation.h>
#import "AppController.h"
#import "JsonConfiguration.h"

#define NSLog(FORMAT, ...) printf("%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

int main (int argc, const char * argv[])
{
    
    @autoreleasepool {
        
        AppController* appController = [[AppController alloc] init];
        
        NSString *inputString;
        
        if (argc == 2 && [[NSString stringWithCString:argv[1] encoding:NSUTF8StringEncoding] isEqualToString:@"-h"]) {
            
            NSDictionary * options = [JsonConfiguration getOptions];
            NSArray * keys = [options allKeys];
            
            NSLog(@"All setting keys and descriptions for jsonscan:");
            NSLog(@"");
            
            for (id object in keys) {
                
                NSDictionary * setting = [options objectForKey:object];
                
                NSLog(@"----------------------------------------");
                NSLog(@"Setting: %@", object);
                NSLog(@"Description: %@", setting.description);
                NSString * setter = [setting objectForKey:@"setter"];
                if (setter) {
                    NSLog(@"Setter: %@", setter);
                }
                NSString * see = [setting objectForKey:@"see"];
                if (see) {
                    NSLog(@"See: %@", see);
                }
                
            }
            
        } else if (argc == 2 && [[NSString stringWithCString:argv[1] encoding:NSUTF8StringEncoding] isEqualToString:@"-l"]) {
            
            inputString = @"{\"action\": \"list\"}";
            [appController exec:inputString];
            
        } else if (argc == 2 && [[NSString stringWithCString:argv[1] encoding:NSUTF8StringEncoding] isEqualToString:@"-c"]) {
            
            NSFileHandle *input = [NSFileHandle fileHandleWithStandardInput];
            NSData *inputData = [NSData dataWithData:[input readDataToEndOfFile]];
            inputString = [[NSString alloc] initWithData:inputData encoding:NSUTF8StringEncoding];
            [appController exec:inputString];
            
        } else if (argc == 2 && [[NSString stringWithCString:argv[1] encoding:NSUTF8StringEncoding] isEqualToString:@"-s"]) {
            
            inputString = @"{\"action\": \"scan\"}";
            [appController exec:inputString];
            
        } else {
            
            NSLog(@"Usage: jsonscan [-option]");
            NSLog(@"");
            NSLog(@"-l : List all scanners and settings.");
            NSLog(@"");
            NSLog(@"-s : Perform a scan with the first available scanner.");
            NSLog(@"");
            NSLog(@"-c : Read JSON action from stdin. Example: jsonscan -c < action.json");
            NSLog(@"");
            NSLog(@"-h : List all setting keys and descriptions.");
            NSLog(@"");
            
        }
        
    }
    
    return 0;
    
}