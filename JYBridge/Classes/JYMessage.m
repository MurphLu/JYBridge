//
//  JYMessage.m
//  JYBridge
//
//  Created by Murph on 2022/6/15.
//

#import "JYMessage.h"

@implementation JYMessage

- (instancetype) initWithDict:(NSDictionary*)dict {
    self = [super init];
    if (self) {
        NSString *name = dict[@"handlerName"];
        NSDictionary *data = dict[@"data"];
        NSString *callback = dict[@"callbackId"];
        if(!name) { return nil; }
        self.handlerName = name;
        self.data = data;
        self.callback = callback;
    }
    return self;
}

- (instancetype) initWithHandlerName: (nonnull NSString *) handler data: (nullable NSDictionary *) data callback: (nullable NSString *) callback {
    self = [super init];
    if (self) {
        if(!handler) { return nil; }
        self.handlerName = handler;
        self.data = data;
        self.callback = callback;
    }
    return self;
}
@end
