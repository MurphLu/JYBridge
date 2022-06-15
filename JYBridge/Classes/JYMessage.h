//
//  JYMessage.h
//  JYBridge
//
//  Created by Murph on 2022/6/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JYMessage : NSObject
@property(nonatomic, copy) NSString* handlerName;
@property(nonatomic, copy) NSDictionary* data;
@property(nonatomic, copy) NSString* callback;

- (instancetype) initWithDict:(NSDictionary*)dict;
- (instancetype) initWithHandlerName: (nonnull NSString *) handler data: (nullable NSDictionary *) data callback: (nullable NSString *) callback;
@end

NS_ASSUME_NONNULL_END
