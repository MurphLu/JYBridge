//
//  JYViewController.m
//  JYBridge
//
//  Created by 10580021 on 06/10/2022.
//  Copyright (c) 2022 10580021. All rights reserved.
//

#import "JYViewController.h"
#import "JYBridge/JYBridge.h"
#import "JYWebBridgeObj.h"
#import "Masonry/Masonry.h"

@interface JYViewController ()
@property(nonatomic, strong) JYWebView* webView;
@property(nonatomic, weak) UIView* containerView;
@property(nonatomic, weak) UIButton * button;
@end

@implementation JYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self setupView];
    NSString* path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"html"];
    [self.webView loadFile:path];
}


- (void) setupView {
    self.webView = [[JYWebView alloc] initWithProxyObj:[[JYWebBridgeObj alloc] init]];
    [self.view addSubview: self.webView.webView];
    
    UIView *containerView = [[UIView alloc] initWithFrame: CGRectZero];
    [self.view addSubview:containerView];
    self.containerView = containerView;

    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@150);
    }];
    
    [self.webView.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.containerView.mas_top);
    }];
    
    UIButton * button = [self gengerateButton: @"Test"];
    [button addTarget:self action:@selector(tryJSFunc) forControlEvents:UIControlEventTouchUpInside];
    [self.containerView addSubview:button];
    self.button = button;
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.containerView);
        make.height.equalTo(@50);
        make.width.equalTo(@(UIScreen.mainScreen.bounds.size.width/4));
    }];
}

- (UIButton *) gengerateButton:(NSString*)title {
    UIButton * button = [[UIButton alloc] initWithFrame:CGRectZero];
    [button setTitle:@"title" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor grayColor];
    return button;
}

- (void) tryJSFunc {
    [self.webView execBridge:@"test" data: @{@"aaa":@"bbb"}];
}

@end
