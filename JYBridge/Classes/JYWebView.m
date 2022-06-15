//
//  JYWebView.m
//  JYBridge
//
//  Created by Murph on 2022/6/10.
//

#import "JYWebView.h"
#import "JYWebBridgeMessageHandler.h"
#import "JYLog.h"
#import "JYMessage.h"
#import "NSDictionary+Extension.h"

@interface JYWebView ()<WKScriptMessageHandler, WKUIDelegate, WKNavigationDelegate, UIScrollViewDelegate>

@property(nonatomic, strong) JYWebBridgeMessageHandler* proxyObj;

@end

@implementation JYWebView
static NSString* bridgeId = @"_JYBridge";

- (instancetype)initWithProxyObj:(id) obj
{
    self = [super init];
    if (self) {
        self.proxyObj = obj;
        [self setupConfig];
        [self setupDelegate];
        [self setupWebView];
    }
    return self;
}

// - MARK: - Public Methods
-(void) loadUrl:(NSURL *)url
{
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void) loadFile:(NSString *)path {
    NSURL * url = [NSURL fileURLWithPath:path];
    [self.webView loadFileURL:url allowingReadAccessToURL:url];
}

- (void) execBridge: (NSString *) name data:(NSDictionary*) data
{
    NSString* dataString = [data toString];
    NSString* payload = [NSString stringWithFormat: @"{bridgeName: '%@', data: '%@'}", name, dataString];
    [self execJS:@"execBridge" payload:payload isBridge:YES];
}

// - MARK: - Private Methods
- (void) setupConfig
{
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    [config.userContentController addScriptMessageHandler:self name: bridgeId];
    self.webView = [[WKWebView alloc] initWithFrame:UIScreen.mainScreen.bounds configuration: config];
}

- (void) setupDelegate
{
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    self.webView.scrollView.delegate = self;
}

- (void) setupWebView
{
    self.webView.backgroundColor = [UIColor clearColor];
    self.webView.opaque = false;
}

- (void) invokeSelAsync:(SEL) aSelector message:(JYMessage *)message
{
    IMP imp = [self.proxyObj methodForSelector:aSelector];
    NSDictionary * (*func)(id, SEL, NSDictionary *, JYBridgeCallback) = (void *) imp;
    
    __weak typeof(self) weakSelf = self;
    func(self.proxyObj, aSelector, message.data, ^(NSDictionary * result){
        [JYLog.shared logInfoWithFormat:@"Call Async Handler: %@ \n With Params: %@ \n CallBackId: %@ \n CallBackResult: %@", message.handlerName, message.data, message.callback, result];
        if(message.callback) {
            [weakSelf execCallback: message.callback data: result];
        }
    });
}

- (void) execCallback: (NSString*) name data:(NSDictionary*) data
{
    NSString* dataString = [data toString];

    NSString* payload = [NSString stringWithFormat: @"{callbackId: '%@', data: '%@'}", name, dataString];
    [self execJS:@"execCallback" payload:payload isBridge:YES];
}

- (void) execJS: (NSString*)name payload:(NSString*)payload isBridge:(BOOL) isbridge
{
    NSString* nameSpace = isbridge ? [NSString stringWithFormat:@"window.%@", bridgeId] : @"window";
    NSString* jsString = [NSString stringWithFormat: @"%@['%@'](%@)", nameSpace, name, payload];
    [JYLog.shared logInfoWithFormat: @"Exec JS \n NameSpace: %@ \n name: %@ \n payload: %@", nameSpace, name, payload];

    [self.webView evaluateJavaScript:jsString completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
        if(error) {
            [JYLog.shared logInfoWithFormat: @"Exec JS \n NameSpace: %@ \n name: %@ \n payload: %@ \n FinishWith Error: %@", nameSpace, name, payload, error.localizedDescription];

            [JYLog.shared logInfoWithFormat: @"Completion With Error: %@", error.localizedDescription];
        } else {
            [JYLog.shared logInfoWithFormat: @"Exec JS \n NameSpace: %@ \n name: %@ \n payload: %@ \n Success With Result: %@", nameSpace, name, payload, obj];
        }
    }];
}

- (NSDictionary*) invokeSel:(SEL) aSelector data:(NSDictionary *)data
{
    IMP imp = [self.proxyObj methodForSelector:aSelector];
    NSDictionary * (*func)(id, SEL, NSDictionary *) = (void *) imp;
    NSDictionary* result = func(self.proxyObj, aSelector, data);
    return result;
}

- (NSString *) handleBridgeCallWithMessage:(JYMessage*)message async:(BOOL)async {
    NSDictionary *result = @{};
    NSString * selName = [NSString stringWithFormat: @"%@:%@", message.handlerName, async ? @"callback:" : @""];
    SEL sel = NSSelectorFromString(selName);
    if([self.proxyObj respondsToSelector:sel]) {
        if(async) {
            [self invokeSelAsync:sel message:message];
        } else {
            result = [self invokeSel:sel data:message.data];
        }
    } else {
        [JYLog.shared logErrorWithFormat: @"Class: %@ Have No Impl For Selector: %@", [self.proxyObj class], selName];
    }
    
    return [result toString];
}

// - MARK: - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    if(![message.name isEqual: bridgeId]) { return; }
    if(![message.body isKindOfClass:[NSDictionary class]]) { return; }
    JYMessage *messageBody = [[JYMessage alloc] initWithDict:(NSDictionary *) message.body];
    if(messageBody) {
        [JYLog.shared logInfoWithFormat:@"Call Async Handler: %@ \n With Params: %@ \n CallBackId: %@", messageBody.handlerName, messageBody.data, messageBody.callback];
        [self handleBridgeCallWithMessage:messageBody async:YES];
    } else {
        [JYLog.shared logErrorWithFormat: @"Parse Message Body Failed messageBody: %@ ", message.body];
    }
}

// - MARK: - WKUIDelegate
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    completionHandler();
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler
{
    completionHandler(NO);
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable result))completionHandler
{
    if([prompt hasPrefix: bridgeId]){
        NSString* handlerName = [prompt substringFromIndex: bridgeId.length];
        NSDictionary * data = [NSDictionary fromJsonString: defaultText];
        JYMessage *message = [[JYMessage alloc] initWithHandlerName:handlerName data: data callback:nil];
        [JYLog.shared logInfoWithFormat: @"Call Sync Handler: %@ \n With Params: %@ \n", handlerName, data];
        NSString *result = [self handleBridgeCallWithMessage:message async:NO];
        [JYLog.shared logInfoWithFormat: @"Call Sync Handler: %@ \n With Params: %@ \n Success With Result: %@", handlerName, data, result];
        completionHandler(result);
        return;
    }
    completionHandler(@"");
}

// - MARK: - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    if(![navigationResponse isKindOfClass:[NSHTTPURLResponse class]]) {
        decisionHandler(WKNavigationResponsePolicyAllow);
        return;
    }
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler
{
    completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
}
// - MARK: - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}
@end

