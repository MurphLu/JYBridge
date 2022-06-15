//
//  JYLog.m
//  JYBridge
//
//  Created by Murph on 2022/6/13.
//

#import "JYLog.h"

@implementation JYLog

typedef NS_ENUM(NSInteger, JYLogType) {
    LOG_INFO    = 0,
    LOG_ERROR   = 1,
};

NSString *infoHeader = @"---------------------INFO START---------------------";
NSString *infoFooter = @"---------------------INFO  END ---------------------";

NSString *errorHeader = @"!!!!!!!!!!!!!!!!!!!! ERROR START !!!!!!!!!!!!!!!!!!!!";
NSString *errorFooter = @"!!!!!!!!!!!!!!!!!!!! ERROR  END  !!!!!!!!!!!!!!!!!!!!";
+(instancetype) shared{
    static JYLog *shareLog = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        shareLog = [[self alloc] init];
    });
    return shareLog;
}

- (void)logInfoWithFormat:(NSString *)format, ... {
    NSString *message = @"";
    va_list args;
    if (format) {
        va_start(args, format);
        message = [[NSString alloc] initWithFormat:format arguments:args];
        va_end(args);
    }
    [self log:message type:LOG_INFO];
}


- (void)logErrorWithFormat:(NSString *)format, ... {
    NSString *message = @"";
    va_list args;
    if (format) {
        va_start(args, format);
        message = [[NSString alloc] initWithFormat:format arguments:args];
        va_end(args);
        va_start(args, format);
        va_end(args);
    }
    [self log:message type:LOG_ERROR];
}

- (void) log:(NSString*)log type:(JYLogType) type {
#ifdef DEBUG
    NSString* header = @"";
    NSString* footer = @"";
    switch (type) {
        case LOG_INFO:
            header = infoHeader;
            footer = infoFooter;
            break;
        case LOG_ERROR:
            header = errorHeader;
            footer = errorFooter;
        default:
            break;
    }
    NSLog(@"\n %@ \n %@ \n %@", header, log, footer);
#endif
}
@end
