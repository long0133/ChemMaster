//
//  CYLReactionDetailViewController.m
//  ChemMaster
//
//  Created by GARY on 16/6/16.
//  Copyright © 2016年 GARY. All rights reserved.
//

#import "CYLReactionDetailViewController.h"
#import <TFHpple.h>
#import <SVProgressHUD.h>
#import <UIImageView+WebCache.h>
#import <UIButton+WebCache.h>



static NSInteger literatureLength = 0;
#define deleteNumber 120

@interface CYLReactionDetailViewController ()

@property (nonatomic, strong) UIScrollView *contentScrollView;

@property (nonatomic, strong) NSMutableArray *scrollSubViewsArray;

@property (nonatomic, strong) UIButton *cancleBtn;

@property (nonatomic, assign) NSInteger CurrentH;
@property (nonatomic, assign) NSInteger maxWidth;

//显示图片时的遮板
@property (nonatomic, strong) UIView *CoverView;

@property (nonatomic, strong) UIImageView *bigImageView;

//  http://urlsetString/imageUrl
@property (nonatomic, strong) NSString *urlSetString;

@property (nonatomic, strong) NSMutableArray *contentAfterTreatment;

@property (nonatomic, strong) NSMutableArray *literatureContentAray;

@property (nonatomic, strong) UIButton *showLiteratureBtn;

@property (nonatomic, strong) UIButton *saveBtn;

//toolbarView 让按钮显眼
@property (nonatomic, strong) UIView *toolBarView;

@property (nonatomic, strong) NSMutableArray *saveArray;

@end

@implementation CYLReactionDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
     self.view = self.contentScrollView;
    
    _cancleBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW - 44, ScreenH - 40, 33, 33)];
    [_cancleBtn setImage:[UIImage imageNamed:@"Cancel-icon"] forState:UIControlStateNormal];
    [_cancleBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [KWindow addSubview:_cancleBtn];
    
    [self saveBtn];
    
    [self toolBarView];
}


#pragma mark - 获得处理后字符串计算高度与布局子控件
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
            
            imageBtn.center = CGPointMake(self.view.center.x, _CurrentH + imageBtn.frame.size.height/2);
            
            [imageBtn setBackgroundImage:image forState:UIControlStateNormal];
        
            [imageBtn addTarget:self action:@selector(ShowBigImage:) forControlEvents:UIControlEventTouchUpInside];


            if (_maxWidth <= image.size.width) {
                _maxWidth = image.size.width;
            }
            
            //将图片转为PNGdata以便存储
            NSData *imgData = UIImagePNGRepresentation(image);
            
            if (imgData != nil) {
                
                [self.saveArray addObject:imgData];
            }
            
            [self.contentScrollView addSubview:imageBtn];
            
            _CurrentH += imageBtn.frame.size.height + 10;
            
        }
        else
        {
            //文字
            NSMutableDictionary *attr = [NSMutableDictionary dictionary];
            attr[NSFontAttributeName] = [UIFont systemFontOfSize:14];
            
            CGRect rect = [content boundingRectWithSize:CGSizeMake(ScreenW - 5, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil];
            
            UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(5, _CurrentH, rect.size.width, rect.size.height)];
            lable.numberOfLines = 0;
            lable.font = attr[NSFontAttributeName];
            lable.text = content;
            
            if ([content containsString:@"Recent Literature"]) {
                
                lable.frame = CGRectMake(0, _CurrentH, ScreenW, 30);
                lable.textAlignment = NSTextAlignmentLeft;
                lable.font = [UIFont systemFontOfSize:20];
                
            }
            
            [self.saveArray addObject:lable.text];
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
    
    _literatureContentAray = [NSMutableArray array];
    
    for (__strong NSString *contentString in contentArray) {
        
        if (i <= 1) { //跳过前两个元素
            
            i += 1;
            
            continue;
        }
        //leterature部分的截串需要先于img属性
        if ([contentString containsString:@"abstracts"])
        {
            //如果是lecture
           NSString *string = [self literatureStringTreatmentFromContentString:contentString];
            
            NSArray *array = [string componentsSeparatedByString:@"__"];
            
            if (array.count == 2) {
                [self.contentAfterTreatment addObject:array.firstObject];
                [self.contentAfterTreatment addObject:array.lastObject];
            }
            
        }
        if ([contentString containsString:@"img"])
        {
//            没有literature部分的img标签
            if (![contentString containsString:@"abstracts"] || ![contentString containsString:@"href"]) {
                
               NSString *imageUrl = [self imageStringTreatmentFromContentString:contentString];
                
                imageUrl = [NSString stringWithFormat:@"%@%@",self.urlSetString,imageUrl];
                
                NSLog(@"%@",imageUrl);
                
                [self.contentAfterTreatment addObject:imageUrl];
            }
        }
        else
        {
            //如果是文本
           NSString *textString = [self textStringTreatmentFromContentString:contentString];
            
           [self.contentAfterTreatment addObject:textString];
        }
    }
    
    return _CurrentH;
}

#pragma mark - contentArray中的literature String 的处理
- (NSString*)literatureStringTreatmentFromContentString:(NSString*)contentString
{
    
    NSString *imageUrl = @"";
    
    if ([contentString containsString:@"gif"] || [contentString containsString:@"GIF"]) {
        
        //获取imageURL
        imageUrl = [self imageStringTreatmentFromContentString:contentString];
        imageUrl = [imageUrl stringByReplacingOccurrencesOfString:@".." withString:@""];
        imageUrl = [NSString stringWithFormat:@"http://www.organic-chemistry.org%@", imageUrl];
    }
    
    
    //获取文献相关信息
    NSArray *abstractA = [contentString componentsSeparatedByString:@"</a>"];
    
    NSString *abstractString = abstractA.lastObject;
    abstractString = [self flattenHTML:abstractString trimWhiteSpace:NO];
    abstractString = [abstractString stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    abstractString = [NSString stringWithFormat:@"  Referance : %@", abstractString];
    abstractString = [abstractString stringByReplacingOccurrencesOfString:@";" withString:@""];

    return [NSString stringWithFormat:@"%@__%@",imageUrl,abstractString];

    return nil;
}

#pragma mark - contentArray中的text String 的处理
- (NSString*)textStringTreatmentFromContentString:(NSString*)contentString
{

    contentString = [self flattenHTML:contentString trimWhiteSpace:NO];
    contentString = [contentString stringByReplacingOccurrencesOfString:@"\n" withString:@""];

    
    //取得文本内容
    NSString *textString = [contentString stringByReplacingOccurrencesOfString:@";" withString:@" "];
    textString = [NSString stringWithFormat:@"  %@",textString];
    return textString;
}


#pragma mark - contentArray中的Img String 的处理
- (NSString*)imageStringTreatmentFromContentString:(NSString*)contentString
{
    //如果是图片
    NSRange ScrRange = NSMakeRange(0, 0);
    NSRange gifRange = NSMakeRange(0, 0);
    NSString *imageURL = nil;
    
    if ([contentString containsString:@"gif"]) {
        //img含.gif
        ScrRange = [contentString rangeOfString:@"src="""];
        gifRange = [contentString rangeOfString:@".gif"];
  
    }
    else if ([contentString containsString:@"GIF"])
    {  //img含有.GIF
        ScrRange = [contentString rangeOfString:@"src="""];
        gifRange = [contentString rangeOfString:@".GIF"];
    }
    
    NSInteger startPoint = (ScrRange.location + ScrRange.length + 1);
    NSInteger length = ((gifRange.location + gifRange.length) - (ScrRange.location + ScrRange.length) - 1);
    
    NSRange currectRange = NSMakeRange(startPoint,length);
    
    NSString *subString = [contentString substringWithRange:currectRange];
    
    imageURL = [NSString stringWithFormat:@"%@",subString];
    
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
    return imageURL;
}



- (void)ShowBigImage:(UIButton*)btn
{
    
    [self CoverView];
    
    _bigImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/3, ScreenW,self.view.frame.size.height/3)];
    _bigImageView.contentMode = UIViewContentModeScaleAspectFit;
    [KWindow addSubview:_bigImageView];
    
    _bigImageView.image = btn.currentBackgroundImage;
}

#pragma mark - 懒加载
- (UIView *)toolBarView
{
    if (_toolBarView == nil) {
        _toolBarView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenH - 44, ScreenW, 44)];
        _toolBarView.backgroundColor = [UIColor getColor:barColor];
        [KWindow insertSubview:_toolBarView belowSubview:self.cancleBtn];
    }
    return _toolBarView;
}

- (UIButton *)saveBtn
{
    if (_saveBtn == nil) {
        _saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, ScreenH - 40, 33, 33)];
        [_saveBtn setBackgroundImage:[UIImage imageNamed:@"Save-icon"] forState:UIControlStateNormal];
        [_saveBtn addTarget: self action:@selector(saveInCache) forControlEvents:UIControlEventTouchUpInside];
        [KWindow addSubview:_saveBtn];
    }
    return _saveBtn;
}

- (UIButton *)showLiteratureBtn
{
    if (_showLiteratureBtn == nil) {
        _showLiteratureBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.contentScrollView.contentSize.height - 44, ScreenW, 44)];
        _showLiteratureBtn.backgroundColor = [UIColor greenColor];
        _showLiteratureBtn.tag = 0;
        [self.contentScrollView addSubview:_showLiteratureBtn];
        [_showLiteratureBtn addTarget:self action:@selector(showLiterature:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _showLiteratureBtn;
}

- (NSMutableArray *)contentAfterTreatment
{
    if (_contentAfterTreatment == nil) {
        _contentAfterTreatment = [NSMutableArray array];
        
        [self contentsTreatment];
    }
    return _contentAfterTreatment;
}

//- (NSMutableArray *)imageCache
//{
//    if (_imageCache == nil) {
//        _imageCache = [NSMutableArray array];
//    }
//    return _imageCache;
//}

- (UIScrollView *)contentScrollView
{
    if (_contentScrollView == nil) {
        
        _contentScrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
        
        _contentScrollView.backgroundColor = [UIColor whiteColor];
        
        //44为按钮的高度
        [_contentScrollView setContentSize:CGSizeMake(_maxWidth, [self caculateHightForContentScrollViw] + 44)];
        
//        [self showLiteratureBtn];
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
    
    [_saveBtn removeFromSuperview];
    _saveBtn = nil;
    
    [_toolBarView removeFromSuperview];
    _toolBarView = nil;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSMutableArray *)saveArray
{
    if (_saveArray == nil) {
        _saveArray = [NSMutableArray array];
    }
    return _saveArray;
}

#pragma mark - 存储方法
- (void)saveInCache
{
    NSString *fileName = self.title;
    NSString *filePath = [cachePath stringByAppendingPathComponent:fileName];
    [self.saveArray writeToFile:filePath atomically:YES];
    
    UIAlertController *alertC = nil;
    
    if ([self.title containsString:NameReactionCategory]) {
        alertC = [UIAlertController alertControllerWithTitle:@"成功" message:@"请到我的反应查看" preferredStyle:UIAlertControllerStyleActionSheet];
    }
    else if([self.title containsString:TotalSynthesisCategory])
    {
        alertC = [UIAlertController alertControllerWithTitle:@"成功" message:@"请到我的全合成查看" preferredStyle:UIAlertControllerStyleActionSheet];
    }
    else if ([self.title containsString:HightLightCategory])
    {
        alertC = [UIAlertController alertControllerWithTitle:@"成功" message:@"请到我的收藏查看" preferredStyle:UIAlertControllerStyleActionSheet];
    }
    
    
    UIAlertAction *OkAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil];
    
    [alertC addAction:OkAction];
    
    [self presentViewController:alertC animated:YES completion:nil];
}

#pragma mark - 自定义方法
//点击按钮加载literature内容
- (void)showLiterature:(UIButton*)btn
{
    if (btn.tag == 0) {
        
        //显示内容
        CGFloat currentH = self.contentScrollView.contentSize.height + 10;
        
        for (NSString *string in self.literatureContentAray) {
            
            if ([string containsString:@"//"]) {
                       
               UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:string]]];
                CGFloat scale = ScreenW / image.size.width;
                
                
                UIButton *imgBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, currentH, image.size.width * scale, image.size.height * scale)];
                [imgBtn setBackgroundImage:image forState:UIControlStateNormal];
                [imgBtn addTarget:self action:@selector(ShowBigImage:) forControlEvents:UIControlEventTouchUpInside];
                imgBtn.tag = deleteNumber;
                
                [self.contentScrollView addSubview:imgBtn];
                
                literatureLength += imgBtn.frame.size.height + 10;
                
                currentH += imgBtn.frame.size.height + 10;
            }
            else
            {
                NSMutableDictionary *attr = [NSMutableDictionary dictionary];
                attr[NSFontAttributeName] = [UIFont systemFontOfSize:14];
                
                CGRect rect = [string boundingRectWithSize:CGSizeMake(ScreenW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil];
                
                UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, currentH, rect.size.width, rect.size.height)];
                lable.numberOfLines = 0;
                lable.font = attr[NSFontAttributeName];
                lable.text = string;
                lable.tag = deleteNumber;
                [self.contentScrollView addSubview:lable];
                
                literatureLength += lable.frame.size.height + 10;
                currentH += lable.frame.size.height + 10;
            }
        }
        
        [self.contentScrollView setContentSize:CGSizeMake(ScreenW, self.contentScrollView.contentSize.height + literatureLength)];
        
        btn.tag = 1;
    }
    else
    {
        for (__strong UIView *obj in self.contentScrollView.subviews) {
            
            if (obj.tag == deleteNumber) {
                
                [obj removeFromSuperview];
                obj = nil;
            }
        }
        
        [self.contentScrollView setContentSize:CGSizeMake(ScreenW, self.contentScrollView.contentSize.height - literatureLength)];
        
        btn.tag = 0;
    }
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

/**
 *  传入请求的Url 以及图片的域名前缀UrlSet 返回一个具有自动显示所有内容的view的viewController
 *
 *  @param url          请求地址
 *  @param urlsetString 图片域名前缀
 *
 *  @return viewController
 */
+ (instancetype)DetailViewControllerWithURL:(NSURL *)url andUrlSetString:(NSString*)urlsetString
{
    
    CYLReactionDetailViewController *rVC = [[CYLReactionDetailViewController alloc] init];
    
    rVC.urlSetString = urlsetString;
    
    //detail的模型
    CYLDetailModel *detailModel = [[CYLDetailModel alloc] init];
    
    //解析html
    NSData *htmlData = [NSData dataWithContentsOfURL:url];
    
    TFHpple *parser = [[TFHpple alloc] initWithHTMLData:htmlData];
    
    
    //获得更对信息 以及相关反应内容
    NSArray *array = [parser searchWithXPathQuery:@"//div[@id='references']"];
    for (TFHppleElement *element in array) {
        //获取更多信息的链接
        NSString *FutherMoreSubUrl = [element.firstChild.children[3] objectForKey:@"href"];
        
        detailModel.FIURL_string = [NSString stringWithFormat:@"http://www.organic-chemistry.org%@",FutherMoreSubUrl];
        
        for (TFHppleElement *subElement in [element.children[1] children]) {
            
            //获取相关反应的链接
            NSString *RRURL = [subElement objectForKey:@"href"];
            
            if (RRURL != NULL) {
                NSString *fullPath = [NSString stringWithFormat:@"http://www.organic-chemistry.org/namedreactions/%@", [subElement objectForKey:@"href"]];
                
                [detailModel.RRURL_stringArray addObject:fullPath];
            }
        }
    }
    
    //获得概述内容
    NSArray *pElements = [parser searchWithXPathQuery:@"//p"];
    
    for (TFHppleElement *pElement in pElements) {
        
        NSString *raw = [pElement.raw stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
        raw = [raw stringByReplacingOccurrencesOfString:@"</p>" withString:@""];
        raw = [raw stringByReplacingOccurrencesOfString:@"<b>" withString:@""];
        raw = [raw stringByReplacingOccurrencesOfString:@"</b>" withString:@""];
        raw = [raw stringByReplacingOccurrencesOfString:@"<br/>" withString:@" "];
        raw = [raw stringByReplacingOccurrencesOfString:@"&#13" withString:@""];
        
        if (raw != NULL) {
            [detailModel.contentArray addObject:raw];
        }
    }

    rVC.detailModel = detailModel;
    
    return rVC;
    
}

//传入已处理完毕的array 让其直接显示
+ (instancetype)DetailViewControllerWithContentArray:(NSMutableArray *)contentArray
{
      CYLReactionDetailViewController *rVC = [[CYLReactionDetailViewController alloc] init];
    
    rVC.contentAfterTreatment = contentArray;
    
    return rVC;
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}


@end
