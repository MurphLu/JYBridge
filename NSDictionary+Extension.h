//
//  NSDictionary+Extension.h
//  JYBridge
//
//  Created by Murph on 2022/6/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (Extension)
+ (instancetype) fromJsonString: (NSString*) string;

- (NSString *) toString;
@end

NS_ASSUME_NONNULL_END
