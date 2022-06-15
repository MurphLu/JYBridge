//
//  JYLog.h
//  JYBridge
//
//  Created by Murph on 2022/6/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JYLog : NSObject
+(instancetype) shared;

- (void) logInfo: (NSString *) info;
- (void) logError: (NSString *) error;

- (void) logInfoWithFormat: (NSString *) format, ... NS_FORMAT_FUNCTION(1, 2);
- (void) logErrorWithFormat:(NSString *) format, ... NS_FORMAT_FUNCTION(1, 2);
@end

NS_ASSUME_NONNULL_END
