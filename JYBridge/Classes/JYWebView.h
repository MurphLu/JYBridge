//
//  JYWebView.h
//  JYBridge
//
//  Created by Murph on 2022/6/10.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import "JYDefines.h"
#import "JYWebBridgeMessageHandler.h"

NS_ASSUME_NONNULL_BEGIN

@interface JYWebView : NSObject

@property(strong, nonatomic) WKWebView* webView;

- (instancetype)initWithMessageHandler:(JYWebBridgeMessageHandler *) handler;

- (void) loadUrl:(NSURL *)url;
- (void) loadFile: (NSString*) path;

- (void) execBridge: (NSString *) name data:(NSDictionary*) data;

@end

NS_ASSUME_NONNULL_END
