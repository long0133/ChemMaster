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
@property (nonatomic, assign) NSInteger maxWidth;

@property (nonatomic, strong) UIView *CoverView;

@property (nonatomic, strong) UIImageView *bigImageView;

@property (nonatomic, strong) NSMutableArray *imageCache;

@property (nonatomic, strong) NSMutableArray *contentAfterTreatment;

@end

@implementation CYLReactionDetailViewController

- (NSMutableArray *)contentAfterTreatment
{
    if (_contentAfterTreatment == nil) {
        _contentAfterTreatment = [NSMutableArray array];
        
        [self contentsTreatment];
    }
    return _contentAfterTreatment;
}

- (NSMutableArray *)imageCache
{
    if (_imageCache == nil) {
        _imageCache = [NSMutableArray array];
    }
    return _imageCache;
}

- (UIScrollView *)contentScrollView
{
    if (_contentScrollView == nil) {
        
        _contentScrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
        
        _contentScrollView.backgroundColor = [UIColor whiteColor];
        
        [_contentScrollView setContentSize:CGSizeMake(_maxWidth, [self caculateHightForContentScrollViw])];
        NSLog(@"%ld", _maxWidth);
    }
    return _contentScrollView;
}

- (NSMutableArray *)scrollSubViewsArray
{
    if (_scrollSubViewsArray == nil) {
        _scrollSubViewsArray = [NSMutableArray array];
    }
    return _scrollSubViewsArray;
}

- (void)loadView
{
    [super loadView];
    
    self.view = self.contentScrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _cancleBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW - 44, ScreenH - 44, 33, 33)];
    [_cancleBtn setImage:[UIImage imageNamed:@"Cancel-icon"] forState:UIControlStateNormal];
    [_cancleBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [KWindow addSubview:_cancleBtn];
    
    NSLog(@"%@",self.scrollSubViewsArray);
}


#pragma mark - 获得处理后字符串计算高度 与布局
- (NSInteger)caculateHightForContentScrollViw
{
    _CurrentH = 0;
    _maxWidth = ScreenW;
    
    for (NSString *content in self.contentAfterTreatment) {
        
        if ([content containsString:@"http"])
        {
            //图片

            
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:content]]];

            CGFloat Scale = 1;
            
            if (image.size.width > ScreenW) {
                
               Scale = ScreenW / image.size.width;
            }

            
            UIButton *imageBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, _CurrentH, image.size.width * Scale, image.size.height * Scale)];
            
            [imageBtn setBackgroundImage:image forState:UIControlStateNormal];
        
            [imageBtn addTarget:self action:@selector(ShowBigImage:) forControlEvents:UIControlEventTouchUpInside];


            if (_maxWidth <= image.size.width) {
                _maxWidth = image.size.width;
            }
            
            [self.contentScrollView addSubview:imageBtn];
            
            _CurrentH += imageBtn.frame.size.height + 10;
            
        }
        else
        {
            //文字
            NSMutableDictionary *attr = [NSMutableDictionary dictionary];
            attr[NSFontAttributeName] = [UIFont systemFontOfSize:14];
            
            CGRect rect = [content boundingRectWithSize:CGSizeMake(ScreenW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil];
            
            UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, _CurrentH, rect.size.width, rect.size.height)];
            lable.numberOfLines = 0;
            lable.font = attr[NSFontAttributeName];
            lable.text = content;
            
            [self.contentScrollView addSubview:lable];
            
            _CurrentH += lable.frame.size.height + 10;
        }
    }

    return _CurrentH;
}


#pragma mark - 处理html解析获得的字符串
- (NSInteger)contentsTreatment
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
    
    NSLog(@"%@",self.contentAfterTreatment);
    
    return _CurrentH;
}
#pragma mark - contentArray中的text String 的处理
- (void)textStringTreatmentFromContentString:(NSString*)contentString
{

    contentString = [self flattenHTML:contentString trimWhiteSpace:NO];
    contentString = [contentString stringByReplacingOccurrencesOfString:@"\n" withString:@""];

    
    //取得文本内容
    NSString *textString = [contentString stringByReplacingOccurrencesOfString:@";" withString:@" "];
    
    [self.contentAfterTreatment addObject:textString];
}


#pragma mark - contentArray中的Img String 的处理
- (void)imageStringTreatmentFromContentString:(NSString*)contentString
{
    //如果是图片
    
    NSRange ScrRange = NSMakeRange(0, 0);
    NSRange gifRange = NSMakeRange(0, 0);
    NSString *imageURL = nil;

    if ([contentString containsString:@"href"]) {//去除lecture内容
        return;
    }
    
    if ([contentString containsString:@"gif"]) {
        //img含.gif
        ScrRange = [contentString rangeOfString:@"src="""];
        gifRange = [contentString rangeOfString:@".gif"];
  
    }
    else
    {  //img含有.GIF
        ScrRange = [contentString rangeOfString:@"src="""];
        gifRange = [contentString rangeOfString:@".GIF"];
    }
    
    NSInteger startPoint = (ScrRange.location + ScrRange.length + 1);
    NSInteger length = ((gifRange.location + gifRange.length) - (ScrRange.location + ScrRange.length) - 1);
    
    NSRange currectRange = NSMakeRange(startPoint,length);
    
    NSString *subString = [contentString substringWithRange:currectRange];
    
    imageURL = [NSString stringWithFormat:@"http://www.organic-chemistry.org/namedreactions/%@",subString];
    
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
    
    [self.contentAfterTreatment addObject:imageURL];

}



- (void)ShowBigImage:(UIButton*)btn
{
    
    [self CoverView];
    
    _bigImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/3, ScreenW,self.view.frame.size.height/3)];
    _bigImageView.contentMode = UIViewContentModeScaleAspectFit;
    [KWindow addSubview:_bigImageView];
    
    _bigImageView.image = btn.currentBackgroundImage;
}

//懒加载
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


//去除html所有标签
- (NSString *)flattenHTML:(NSString *)html trimWhiteSpace:(BOOL)trim
{
    NSScanner *theScanner = [NSScanner scannerWithString:html];
    NSString *text = nil;
    
    while ([theScanner isAtEnd] == NO) {
        // find start of tag
        [theScanner scanUpToString:@"<" intoString:NULL] ;
        // find end of tag
        [theScanner scanUpToString:@">" intoString:&text] ;
        // replace the found tag with a space
        //(you can filter multi-spaces out later if you wish)
        html = [html stringByReplacingOccurrencesOfString:
                [ NSString stringWithFormat:@"%@>", text]
                                               withString:@""];
    }
    
    return trim ? [html stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] : html;
}

#pragma mark - 初始化方法
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
