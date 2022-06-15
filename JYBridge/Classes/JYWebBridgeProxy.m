//
//  JYWebBridgeProxy.m
//  JYBridge
//
//  Created by Murph on 2022/6/10.
//

#import "JYWebBridgeProxy.h"
#import <objc/runtime.h>
#import "JYLog.h"

@implementation JYWebBridgeProxy

- (void) debugInfo:(NSString*) info {
    [[JYLog shared] logInfo:info];
}

@end
