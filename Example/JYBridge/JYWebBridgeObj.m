//
//  JYWebBridgeObj.m
//  JYBridge_Example
//
//  Created by Murph on 2022/6/14.
//  Copyright © 2022 10580021. All rights reserved.
//

#import "JYWebBridgeObj.h"

@implementation JYWebBridgeObj
-(NSString *) test:(NSDictionary*)data callback:(NSString *) str{
    return @"aaa";
}

-(NSDictionary *) test:(NSDictionary*)data{
    return @{@"aaa": @"bbb"};
}

-(void) testAsync: (NSDictionary*) data callback:(JYBridgeCallback)callback aa:(NSString *) aa {
    callback(data);
}
@end
