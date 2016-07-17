//
//  CYLDetailViewFromSaveViewController.m
//  ChemMaster
//
//  Created by GARY on 16/7/4.
//  Copyright © 2016年 GARY. All rights reserved.
//

#import "CYLDetailViewFromSaveViewController.h"

@interface CYLDetailViewFromSaveViewController ()
//存储图片data 以及 字符串
@property (nonatomic, strong) NSArray *contentArrayFromCache;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, assign) NSInteger ScrollViewHeight;

@property (nonatomic, strong) UIButton *dismissBtn;

@property (nonatomic, strong) UIView *CoverView;

@property (nonatomic, strong) UIImageView *bigImageView;
@end

@implementation CYLDetailViewFromSaveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [_scrollView setContentSize:CGSizeMake(ScreenW, _ScrollViewHeight)];
    _scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_scrollView];
    
    _dismissBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW - 44, ScreenH - 44, 33, 33)];
    [_dismissBtn setImage:[UIImage imageNamed:@"Cancel-icon"] forState:UIControlStateNormal];
    [_dismissBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [KWindow addSubview:_dismissBtn];
}

- (void)setContent
{
    
    NSInteger CurrnetH = 0;
    
    for (id obj in self.contentArrayFromCache) {
        
        if ([obj isKindOfClass:[NSData class]])
        {
            
            UIImage *image = [UIImage imageWithData:obj];
            
            CGFloat Scale = 1;
            
            if (image.size.width > ScreenW) {
                
                Scale = ScreenW / image.size.width;
            }
            
            
            UIButton *imageBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, CurrnetH, image.size.width * Scale, image.size.height * Scale)];
            
            [imageBtn setBackgroundImage:image forState:UIControlStateNormal];
            
            [imageBtn addTarget:self action:@selector(ShowBigImage:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.scrollView addSubview:imageBtn];
            
            CurrnetH += imageBtn.frame.size.height + 10;
        }
        else if ([obj isKindOfClass:[NSString class]])
        {
            NSMutableDictionary *attr = [NSMutableDictionary dictionary];
            attr[NSFontAttributeName] = [UIFont systemFontOfSize:14];
            
            CGRect rect = [obj boundingRectWithSize:CGSizeMake(ScreenW - 5, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil];
            
            UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(5, CurrnetH, rect.size.width, rect.size.height)];
            lable.numberOfLines = 0;
            lable.font = attr[NSFontAttributeName];
            lable.text = obj;
            
            if ([obj containsString:@"Recent Literature"]) {
                
                lable.frame = CGRectMake(0, CurrnetH, ScreenW, 30);
                lable.textAlignment = NSTextAlignmentLeft;
                lable.font = [UIFont systemFontOfSize:20];
                
            }
            
            [self.scrollView addSubview:lable];
            
            CurrnetH += lable.frame.size.height + 10;
        }
    }
    
    _ScrollViewHeight = CurrnetH;
}

#pragma mark - 懒加载
- (UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
    }
    return _scrollView;
}

- (NSArray *)contentArrayFromCache
{
    if (_contentArrayFromCache == nil) {
        
        _contentArrayFromCache = [NSArray array];
        
    }
    return _contentArrayFromCache;
}

- (UIView *)CoverView
{
    if (_CoverView == nil) {
        _CoverView = [[UIView alloc] initWithFrame:self.view.frame];
        [KWindow addSubview:_CoverView];
        _CoverView.backgroundColor = [UIColor blackColor];
        _CoverView.alpha = 0.7;
        
        [_CoverView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeCover)]];
    }
    return _CoverView;
}


#pragma mark - 自定义方法
- (void)dismiss
{
    [self.dismissBtn removeFromSuperview];
    self.dismissBtn = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)ShowBigImage:(UIButton*)btn
{
    [self CoverView];
    
    _bigImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/3, ScreenW,self.view.frame.size.height/3)];
    _bigImageView.contentMode = UIViewContentModeScaleAspectFit;
    [KWindow addSubview:_bigImageView];
    
    _bigImageView.image = btn.currentBackgroundImage;

}

- (void)closeCover
{
    [_bigImageView removeFromSuperview];
    _bigImageView = nil;
    
    [self.CoverView removeFromSuperview];
    self.CoverView = nil;
}

+ (instancetype)detaileViewWithcontentArrayFromCache:(NSArray *)Array
{
    CYLDetailViewFromSaveViewController *detailVC = [[CYLDetailViewFromSaveViewController alloc] init];
    
    detailVC.contentArrayFromCache = Array;
    
    [detailVC setContent];
    
    return detailVC;
}

- (BOOL)prefersStatusBarHidden
{
   return YES;
}
@end
