//
//  CYLWebViewController.m
//  ChemMaster
//
//  Created by GARY on 16/6/15.
//  Copyright © 2016年 GARY. All rights reserved.
//

#import "CYLWebViewController.h"
#import <WebKit/WebKit.h>

@interface CYLWebViewController ()<WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, strong) UIToolbar *toolBar;

@property (nonatomic,strong) UIProgressView *progressView;

@end

@implementation CYLWebViewController

- (WKWebView *)webView
{
    if (_webView == nil) {
        
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
        
        _webView.allowsBackForwardNavigationGestures = YES;
        
        _webView.navigationDelegate = self;
        
        //添加观察者
        [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        
        [self.view addSubview:_webView];
    }
    return _webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.webView loadRequest:[NSURLRequest requestWithURL:_url]];
  
    [self setUpUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.webView reload];
        NSLog(@"%@",self.webView.URL);
}

- (void)setUpUI
{
    self.toolBar.backgroundColor = [UIColor lightGrayColor];
}


#pragma mark - webView操作
- (void)Back
{
    if (self.webView.canGoBack) {
        [self.webView goBack];
    }
}

- (void)Forward
{
    if (self.webView.canGoForward) {
        [self.webView goForward];
    }
}

- (void)refresh
{
    [self.webView reload];
}

- (void)returnToMain
{
    //移除观察着
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - kvo 观察progress变化
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        
        self.progressView.progress = self.webView.estimatedProgress;
        
        if (self.webView.estimatedProgress == 1) {
            [self.progressView removeFromSuperview];
            self.progressView = nil;
        }
        
    }
}

#pragma mark - 懒加载
- (UIToolbar *)toolBar
{
    if (_toolBar == nil) {
        _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, ScreenH - 44, ScreenW, 44)];
        
        //设置按钮
        UIImage *goBackImage = [UIImage imageNamed:@"Arrows-Back-icon"];
        UIButton *GoBanckBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
        [GoBanckBtn setImage:goBackImage forState:UIControlStateNormal];
        [GoBanckBtn addTarget:self action:@selector(Back) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *goBack = [[UIBarButtonItem alloc] initWithCustomView:GoBanckBtn];
        
        UIImage *forwardImage = [UIImage imageNamed:@"Arrows-Forward-icon"];
        UIButton *forwardBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
        [forwardBtn setImage:forwardImage forState:UIControlStateNormal];
        [forwardBtn addTarget:self action:@selector(Forward) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *forwar = [[UIBarButtonItem alloc] initWithCustomView:forwardBtn];
        
        
        UIBarButtonItem *spacing = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        UIImage *RefeshImage = [UIImage imageNamed:@"Refresh-icon"];
        UIButton *refeshBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
        [refeshBtn setImage:RefeshImage forState:UIControlStateNormal];
        [refeshBtn addTarget:self action:@selector(refresh) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *refesh = [[UIBarButtonItem alloc] initWithCustomView:refeshBtn];
        
        UIImage *closeImage = [UIImage imageNamed:@"Cancel-icon"];
        UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
        [closeBtn setImage:closeImage forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(returnToMain) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *close = [[UIBarButtonItem alloc] initWithCustomView:closeBtn];
        
        _toolBar.items = @[goBack, forwar, spacing, refesh, close];
        
        _toolBar.backgroundColor = randomColor;
        
        [self.webView addSubview:_toolBar];
    }
    return _toolBar;
}

-(UIProgressView *)progressView
{
    if (_progressView == nil) {
        _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
        _progressView.frame = CGRectMake(0, 0, ScreenW, 10);
        [self.view addSubview:_progressView];
    }
    return _progressView;
}


+(instancetype)initWithURL:(NSURL *)url
{
    CYLWebViewController *webVC = [[CYLWebViewController alloc] init];
    
    webVC.url = url;
    
    return webVC;
}


-(BOOL)prefersStatusBarHidden
{
    return YES;
}
@end
