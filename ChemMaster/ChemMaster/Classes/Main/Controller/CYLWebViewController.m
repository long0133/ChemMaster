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
        goBackImage = [UIImage imageCompressForSize:goBackImage targetSize:CGSizeMake(30, 30)];
        UIBarButtonItem *goBack = [[UIBarButtonItem alloc] initWithImage:goBackImage style:UIBarButtonItemStyleDone target:self action:@selector(Back)];
        
        UIImage *forwardImage = [UIImage imageNamed:@"Arrows-Forward-icon"];
        forwardImage = [UIImage imageCompressForSize:forwardImage targetSize:CGSizeMake(30, 30)];
        UIBarButtonItem *forward = [[UIBarButtonItem alloc] initWithImage:forwardImage style:UIBarButtonItemStyleDone target:self action:@selector(Forward)];
        
        UIBarButtonItem *spacing = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        UIImage *refreshImage = [UIImage imageNamed:@"Refresh-icon"];
        refreshImage = [UIImage imageCompressForSize:refreshImage targetSize:CGSizeMake(30, 30)];
        UIBarButtonItem *refresh = [[UIBarButtonItem alloc] initWithImage:refreshImage style:UIBarButtonItemStyleDone target:self action:@selector(refresh)];
        
        UIImage *cancleImage = [UIImage imageNamed:@"Cancel-icon"];
        cancleImage = [UIImage imageCompressForSize:cancleImage targetSize:CGSizeMake(30, 30)];
        UIBarButtonItem *cancle = [[UIBarButtonItem alloc] initWithImage:cancleImage style:UIBarButtonItemStyleDone target:self action:@selector(returnToMain)];
        
        _toolBar.items = @[goBack, forward, spacing, refresh, cancle];
        
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
