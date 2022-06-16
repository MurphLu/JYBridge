//
//  JYWebBridgeMessageHandler.m
//  JYBridge
//
//  Created by Murph on 2022/6/10.
//

#import "JYWebBridgeMessageHandler.h"
#import <objc/runtime.h>
#import "JYLog.h"
#import "JYMessage.h"

@implementation JYWebBridgeMessageHandler

- (NSDictionary*) handle:(NSString*) name data: (NSDictionary*)data {
    SEL sel = [self getSelectorWith:name async:NO];
    if(sel) {
        IMP imp = [self methodForSelector:sel];
        NSDictionary * (*func)(id, SEL, NSDictionary *) = (void *) imp;
        NSDictionary* result = func(self, sel, data);
        return result;
    } else {
        return nil;
    }
}

- (void) handleAsync:(NSString*) name data: (NSDictionary*)data callback:(JYBridgeCallback) callback {
    SEL sel = [self getSelectorWith:name async:NO];
    if(sel) {
        IMP imp = [self methodForSelector:sel];
        NSDictionary * (*func)(id, SEL, NSDictionary *, JYBridgeCallback) = (void *) imp;
        func(self, sel, data, callback);
    }
}

- (SEL) getSelectorWith:(NSString*) name async:(BOOL) async
{
    NSString * selName = [NSString stringWithFormat: @"%@:%@", name, async ? @"callback:" : @""];
    SEL sel = NSSelectorFromString(selName);
    if([self respondsToSelector:sel]) {
        return sel;
    } else {
        [JYLog.shared logErrorWithFormat: @"Class: %@ Have No Impl For Selector: %@", [self class], selName];
        return nil;
    }
}

@end
