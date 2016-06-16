//
//  CYLReactionDetailViewController.m
//  ChemMaster
//
//  Created by GARY on 16/6/16.
//  Copyright © 2016年 GARY. All rights reserved.
//

#import "CYLReactionDetailViewController.h"
#import <UIImageView+WebCache.h>
@interface CYLReactionDetailViewController ()

@property (nonatomic, strong) UIScrollView *contentScrollView;

@property (nonatomic, strong) NSMutableArray *scrollSubViewsArray;

@property (nonatomic, strong) UIButton *cancleBtn;

@property (nonatomic, assign) NSInteger CurrentH;

@end

@implementation CYLReactionDetailViewController

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
    NSArray *contentArray = self.detailModel.contentArray;
    
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
    //处理字符串 删除标签
    contentString = [contentString stringByReplacingOccurrencesOfString:@"<i>" withString:@""];
    contentString = [contentString stringByReplacingOccurrencesOfString:@"</i>" withString:@""];
    contentString = [contentString stringByReplacingOccurrencesOfString:@"</a>" withString:@""];
    contentString = [contentString stringByReplacingOccurrencesOfString:@"<a href=" withString:@""]
    ;
    contentString = [contentString stringByReplacingOccurrencesOfString:@".shtm" withString:@""];
    contentString = [contentString stringByReplacingOccurrencesOfString:@">" withString:@""];
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
    
    NSString *imageURL = nil;
    
    if ([contentString containsString:@"width"]) {
        
        //img含有宽高信息
        NSRange range = NSMakeRange(10, 11);
        
        NSString *subString = [contentString substringWithRange:range];
        
        imageURL = [NSString stringWithFormat:@"http://www.organic-chemistry.org/namedreactions/%@",subString];
    }
    else if ([contentString containsString:@"border"])
    { //截取的img不带图片宽高信息 但有border信息
        NSString *subString = [contentString substringFromIndex:21];
        subString = [subString substringToIndex:subString.length - 3];
        
        imageURL = [NSString stringWithFormat:@"http://www.organic-chemistry.org/namedreactions/%@",subString];
        imageURL = [imageURL stringByReplacingOccurrencesOfString:@"""" withString:@""];
        
    }
    else
    {
        //img不含任何属性
        NSString *subString = [contentString substringFromIndex:10];
        subString = [subString substringToIndex:subString.length - 3];
        
        imageURL = [NSString stringWithFormat:@"http://www.organic-chemistry.org/namedreactions/%@",subString];
        
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, _CurrentH, ScreenW, 70)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:imageURL]];
    
    [self.scrollSubViewsArray addObject:imageView];
    _CurrentH += imageView.frame.size.height;
    

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
