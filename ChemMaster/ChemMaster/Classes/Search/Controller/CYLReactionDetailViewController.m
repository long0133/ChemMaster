//
//  CYLReactionDetailViewController.m
//  ChemMaster
//
//  Created by GARY on 16/6/16.
//  Copyright © 2016年 GARY. All rights reserved.
//

#import "CYLReactionDetailViewController.h"
#import <UIImageView+WebCache.h>
#import <UIButton+WebCache.h>
@interface CYLReactionDetailViewController ()

@property (nonatomic, strong) UIScrollView *contentScrollView;

@property (nonatomic, strong) NSMutableArray *scrollSubViewsArray;

@property (nonatomic, strong) UIButton *cancleBtn;

@property (nonatomic, assign) NSInteger CurrentH;

@property (nonatomic, strong) UIView *CoverView;

@property (nonatomic, strong) UIImageView *bigImageView;

@property (nonatomic, strong) NSMutableArray *imageCache;

@end

@implementation CYLReactionDetailViewController

- (NSMutableArray *)imageCache
{
    if (_imageCache == nil) {
        _imageCache = [NSMutableArray array];
    }
    return _imageCache;
}

-(NSMutableArray *)scrollSubViewsArray
{
    if (_scrollSubViewsArray == nil) {
        _scrollSubViewsArray = [NSMutableArray array];
    }
    return _scrollSubViewsArray;
}

- (UIScrollView *)contentScrollView
{
    if (_contentScrollView == nil) {
        _contentScrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
        
        _contentScrollView.contentSize = CGSizeMake(ScreenW, [self caculateContentSizeForScrollView]);
        
        //布局子控件
        for (id obj in self.scrollSubViewsArray) {
            
            [_contentScrollView addSubview:obj];
        }
    }
    return _contentScrollView;
}

- (void)loadView
{
    [super loadView];
    
    self.view = self.contentScrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.contentScrollView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.86 alpha:1];
    self.contentScrollView.backgroundColor = [UIColor lightGrayColor];
    
    _cancleBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW - 44, ScreenH - 44, 33, 33)];
    [_cancleBtn setImage:[UIImage imageNamed:@"Cancel-icon"] forState:UIControlStateNormal];
    [_cancleBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [KWindow addSubview:_cancleBtn];
}

#pragma mark - 计算scrollview的ContentSize
- (NSInteger)caculateContentSizeForScrollView
{
    //取出内容数组
    NSMutableArray *contentArray = self.detailModel.contentArray;
    [contentArray removeLastObject];
    
    NSInteger i = 0;
    
    _CurrentH = 0;
    
    for (__strong NSString *contentString in contentArray) {
        
        if (i <= 1) { //跳过前两个元素
            
            i += 1;
            
            continue;
        }
        //leterature部分的截串需要先与img属性
//        if ([contentString containsString:@"literature"])
//        {
//            //如果是lecture
//            NSLog(@"%@",contentString);
//            
//        }
        if ([contentString containsString:@"img"])
        {
//            没有literature部分的img标签
            if (![contentString containsString:@"abstracts"]) {
                [self imageStringTreatmentFromContentString:contentString];
            }
        }
        else
        {
            //如果是文本
            [self textStringTreatmentFromContentString:contentString];
        }
    }
    return _CurrentH;
}
#pragma mark - contentArray中的text String 的处理
- (void)textStringTreatmentFromContentString:(NSString*)contentString
{
//    NSArray *subStringArray = [contentString componentsSeparatedByString:@" "];
//    NSMutableArray *temp = [NSMutableArray array];
//    for (__strong NSString *subString in subStringArray) {
////        subString = [subString stringByReplacingOccurrencesOfString:@";\n" withString:@" "];
//        subString = [subString stringByReplacingOccurrencesOfString:@" " withString:@""];
//        [temp addObject:subString];
//    }
//    NSLog(@"%@",temp);
    
    
    //处理字符串 删除标签
    contentString = [contentString stringByReplacingOccurrencesOfString:@"<i>" withString:@""];
    contentString = [contentString stringByReplacingOccurrencesOfString:@"</i>" withString:@""];
    contentString = [contentString stringByReplacingOccurrencesOfString:@"</a>" withString:@""];
    contentString = [contentString stringByReplacingOccurrencesOfString:@"<a href=" withString:@""]
    ;
    contentString = [contentString stringByReplacingOccurrencesOfString:@".shtm" withString:@""];
    contentString = [contentString stringByReplacingOccurrencesOfString:@">" withString:@""];
    contentString = [NSString stringWithFormat:@"  %@",contentString];
    contentString = [contentString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    UILabel *lable = [[UILabel alloc] init];
    lable.font = [UIFont systemFontOfSize:13];
    lable.numberOfLines = 0;
    
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    attr[NSFontAttributeName] = [UIFont systemFontOfSize:13];
    
    CGRect rect = [contentString boundingRectWithSize:CGSizeMake(ScreenW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil];
    lable.frame = CGRectMake(0, _CurrentH, rect.size.width, rect.size.height);
    
    [self.scrollSubViewsArray addObject:lable];
    
    //取得文本内容
    NSString *textString = [contentString stringByReplacingOccurrencesOfString:@";" withString:@" "];
    
    lable.text = textString;
    
    _CurrentH += lable.frame.size.height;
    
}


#pragma mark - contentArray中的Img String 的处理
- (void)imageStringTreatmentFromContentString:(NSString*)contentString
{
    //如果是图片
    //图片URL
    NSLog(@"%@",contentString);
    if ([contentString containsString:@"href"]) {//去除lecture内容
        return;
    }
    contentString = [contentString stringByReplacingOccurrencesOfString:@"GIF" withString:@"gif"];
    NSString *imageURL = nil;
//    if ([contentString containsString:@"width"]) {
    
        //img含有宽高信息
        NSRange ScrRange = [contentString rangeOfString:@"src="""];
        NSRange gifRange = [contentString rangeOfString:@".gif"];
        
        NSInteger startPoint = (ScrRange.location + ScrRange.length + 1);
        NSInteger length = ((gifRange.location + gifRange.length) - (ScrRange.location + ScrRange.length) - 1);
        
        NSRange currectRange = NSMakeRange(startPoint,length);
        
        NSString *subString = [contentString substringWithRange:currectRange];
        
        imageURL = [NSString stringWithFormat:@"http://www.organic-chemistry.org/namedreactions/%@",subString];
//    }
//    else if ([contentString containsString:@"border"])
//    { //截取的img不带图片宽高信息 但有border信息
//        NSString *subString = [contentString substringFromIndex:21];
//        subString = [subString substringToIndex:subString.length - 3];
//        
//        imageURL = [NSString stringWithFormat:@"http://www.organic-chemistry.org/namedreactions/%@",subString];
//        imageURL = [imageURL stringByReplacingOccurrencesOfString:@"""" withString:@""];
//    }
//    else
//    {
//        //img不含任何属性
//        NSString *subString = [contentString substringFromIndex:10];
//        subString = [subString substringToIndex:subString.length - 3];
//        
//        imageURL = [NSString stringWithFormat:@"http://www.organic-chemistry.org/namedreactions/%@",subString];
//        
//    }
    
    //最终处理字符串URL使其不带无关尾巴
    if (!([[imageURL substringFromIndex:imageURL.length - 1] isEqualToString:@"f"] || [[imageURL substringFromIndex:imageURL.length - 1] isEqualToString:@"F"])) {
        
        NSRange range = NSMakeRange(0, 0);
        if ([imageURL containsString:@"gif"]) {
            range = [imageURL rangeOfString:@"gif"];
            imageURL = [imageURL substringToIndex:(range.location + range.length)];
        }
        else
        {
            range = [imageURL rangeOfString:@"GIF"];
            imageURL = [imageURL substringToIndex:(range.location + range.length)];
        }
        
    }
    
    UIButton *imageButton = [[UIButton alloc] initWithFrame:CGRectMake(0, _CurrentH, ScreenW, 70)];
    
    [imageButton setContentMode:UIViewContentModeScaleAspectFit];
    [imageButton sd_setBackgroundImageWithURL:[NSURL URLWithString:imageURL] forState:UIControlStateNormal];
    [imageButton addTarget:self action:@selector(ShowBigImage:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.scrollSubViewsArray addObject:imageButton];
    _CurrentH += imageButton.frame.size.height;

}

- (void)ShowBigImage:(UIButton*)btn
{
    
    [self CoverView];
    
    _bigImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/3, ScreenW,self.view.frame.size.height/3)];
    _bigImageView.contentMode = UIViewContentModeScaleAspectFit;
    [KWindow addSubview:_bigImageView];
    
    _bigImageView.image = btn.currentBackgroundImage;
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

- (void)closeCover
{
    [_bigImageView removeFromSuperview];
    _bigImageView = nil;
    
    [self.CoverView removeFromSuperview];
    self.CoverView = nil;
}

- (void)dismiss
{
    [_cancleBtn removeFromSuperview];
    _cancleBtn = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}

+ (instancetype)DetailViewControllerWithDetailModel:(CYLDetailModel *)model
{
    CYLReactionDetailViewController *rVC = [[CYLReactionDetailViewController alloc] init];
    
    rVC.detailModel = model;
    
    return rVC;
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
