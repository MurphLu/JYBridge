//
//  JYWebBridgeMessageHandler.h
//  JYBridge
//
//  Created by Murph on 2022/6/10.
//

#import <Foundation/Foundation.h>
#import "JYDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface JYWebBridgeMessageHandler : NSObject

/// handler for sync func
/// @param name handler name
/// @param data params with dictionary format
- (NSDictionary*) handle:(NSString*) name data: (NSDictionary*)data;


/// handler for async func
/// @param name handler name
/// @param data params with dictionary format
/// @param callback callback for async func
- (void) handleAsync:(NSString*) name data: (NSDictionary*)data callback:(JYBridgeCallback) callback;
@end

NS_ASSUME_NONNULL_END
