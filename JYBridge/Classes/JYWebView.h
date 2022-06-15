//
//  JYWebView.h
//  JYBridge
//
//  Created by Murph on 2022/6/10.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^JYBridgeCallback)(NSDictionary *);

@interface JYWebView : NSObject

@property(strong, nonatomic) WKWebView* webView;

- (instancetype)initWithProxyObj:(id) obj;

- (void) loadUrl:(NSURL *)url;
- (void) loadFile: (NSString*) path;

- (void) execBridge: (NSString *) name data:(NSDictionary*) data;

@end

NS_ASSUME_NONNULL_END
