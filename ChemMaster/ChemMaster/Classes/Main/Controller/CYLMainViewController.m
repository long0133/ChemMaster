//
//  CYLMainViewController.m
//  ChemMaster
//
//  Created by GARY on 16/6/12.
//  Copyright © 2016年 GARY. All rights reserved.
//
#import <WebKit/WebKit.h>
#import "CYLMainViewController.h"
#import "CYLHeaderReusableView.h"
#import "CYLEditorChociseModel.h"
#import "CYLHightLightCell.h"
#import "CYLHightLightModel.h"
#import "CYLWebViewController.h"
#import "CYLGoToStore.h"
#import "CYLTextView.h"
#import "CYLFlowLayOut.h"
#import "CYLSectonTwoReusableView.h"
#import "CYLSectionTwoCardCell.h"


#define animationDuration .7
static CGFloat lastOffSetY;

@interface CYLMainViewController ()<CYLHeaderReusableViewDelegate,CYLHightLightCellDelegate>
@property (nonatomic, strong) NSArray *headerModelArray;

@property (nonatomic , strong) NSArray *highLightArray;

@property (nonatomic,strong) UIView *coverView;

@property (nonatomic, strong)CYLHeaderReusableView *headerView;

@property (nonatomic, strong) CYLSectonTwoReusableView *sectionTwoHeader;


@property (nonatomic,strong) CYLWebViewController *webVC;

@property (nonatomic, strong) NSMutableArray *coverViewSubviews;

@end

@implementation CYLMainViewController

static NSString * const reuseIdentifier = @"Cell";
static NSString * const reuseIdentifierTwo = @"CellTwo";

- (instancetype)init
{
    CYLFlowLayOut *flowLayOut = [[CYLFlowLayOut alloc] init];
    
    flowLayOut.headerReferenceSize = CGSizeMake(ScreenW, 200);
    
    flowLayOut.itemSize = CGSizeMake(ScreenW - 10, 90);
    
    flowLayOut.minimumLineSpacing = 10;
    
    return [super initWithCollectionViewLayout:flowLayOut];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = [UIColor getColor:@"DCDCDC"];

    [self.collectionView registerClass:[CYLHightLightCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.collectionView registerClass:[CYLSectionTwoCardCell class] forCellWithReuseIdentifier:reuseIdentifierTwo];
    
    [self.collectionView registerClass:[CYLHeaderReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    
    [self.collectionView registerClass:[CYLSectonTwoReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"sectionTwo"];
    
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];

    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    CYLGoToStore *gotoStore = [[CYLGoToStore alloc] init];
    gotoStore.appID = @"1132955664";
    [gotoStore goToAppleStore:self];
    
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    if (section == 0)
    {
        return self.highLightArray.count;
    }
    else if (section == 1)
    {
        return 3;
    }
    
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CYLHightLightCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    CYLSectionTwoCardCell *cellSectionTwo = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierTwo forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        
        cell.model = self.highLightArray[indexPath.row];
        
        cell.delegate = self;
        
        return cell;
        
    }
    else if (indexPath.section == 1)
    {
        
        if (indexPath.row == 0) {
            
            //功能1
            cellSectionTwo.backgroundColor = [UIColor grayColor];
        }
        else if (indexPath.row == 1)
        {
            //功能2
            cellSectionTwo.backgroundColor = [UIColor blueColor];
        }
        else
        {
            //功能3
            cellSectionTwo.backgroundColor = [UIColor orangeColor];
        }
        
        return cellSectionTwo;
    }
    
    return nil;
}

- (UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    self.headerView = nil;
    self.sectionTwoHeader = nil;
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        self.headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        
        self.sectionTwoHeader = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"sectionTwo" forIndexPath:indexPath];
        
        if (indexPath.section == 0) {
            
//            [self.headerView  HeaderScrollViewWithModelArray:self.headerModelArray];
            
            self.headerView.delegate = self;
            
            return self.headerView;
        }
        else if(indexPath.section == 1)
        {
            [self.sectionTwoHeader setSectionTwoReusableView];
            
            return self.sectionTwoHeader;
        }
    }
    else
    {
        self.headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer" forIndexPath:indexPath];
    }
    
    return nil;
}


- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat X = cell.frame.origin.x;
    CGFloat Y = cell.frame.origin.y;
    
    CGFloat offSetY = collectionView.contentOffset.y;

    if (indexPath.section == 1) {
       
        if (lastOffSetY <= offSetY) {
            
            cell.transform = CGAffineTransformMakeTranslation(X, Y + 10);
            
            [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                
                cell.transform = CGAffineTransformIdentity;
                
            } completion:^(BOOL finished) {
                
                
            }];
            
        }

        lastOffSetY = offSetY;
    }
    
//    NSInteger cellCount = [collectionView numberOfItemsInSection:1];
//    
//    if (indexPath.row == cellCount - 1) {
//        lastOffSetY = 0;
//    }
    
}

#pragma CYLHeaderReusableViewDelegate
//显示webView
- (void)HeaderReusableView:(CYLHeaderReusableView *)View didChoiceEditorModel:(CYLEditorChociseModel *)model
{

    self.coverView = nil;
    
    [self coverView];
    
    [self showDetailLableWithModel:model];
    
}


#pragma mark - CYLHightLightCellDelegate 点击跳转到网页
- (void)HightLightCellDidClickButton:(UIButton *)btn
{
    self.webVC = nil;
    
    if ([btn.titleLabel.text isEqualToString:@"acs"]) {
        
        [self.webVC setUrl:[NSURL URLWithString:@"http://pubs.acs.org/"]];
        
        
    }
    else if ([btn.titleLabel.text isEqualToString:@"wiley"])
    {
        
        [self.webVC setUrl:[NSURL URLWithString:@"http://onlinelibrary.wiley.com/"]];
    }
    else if ([btn.titleLabel.text isEqualToString:@"rsc"])
    {
        
        [self.webVC setUrl:[NSURL URLWithString:@"http://www.rsc.org/"]];
    }
    else if ([btn.titleLabel.text isEqualToString:@"scifinder"])
    {
        [self.webVC setUrl:[NSURL URLWithString:@"https://scifinder.cas.org/scifinder/login?TYPE=33554433&REALMOID=06-b7b15cf0-642b-1005-963a-830c809fff21&GUID=&SMAUTHREASON=0&METHOD=GET&SMAGENTNAME=-SM-FHxmv6Blb2O%2b68n7uQIlYwcPj%2b%2fjdayUkPrBmlztjSCocFf%2f%2bxVhofBIIzNCuD49&TARGET=-SM-http%3a%2f%2fscifinder%2ecas%2eorg%3a443%2fscifinder%2f"]];
    }
    else
    {
        [self.webVC setUrl:[NSURL URLWithString:@"https://www.baidu.com/link?url=f8dGIsoNDNrRmY82CiGuFvLV4uqVYDmUo-ipUj0lx4S&wd=&eqid=c5e444f8000210e30000000357654058"]];
    }
    
    [self.navigationController presentViewController:_webVC animated:YES completion:nil];
}

#pragma 自定义方法
- (void)showDetailLableWithModel:(CYLEditorChociseModel*)model
{
    self.coverViewSubviews = [NSMutableArray array];
#warning 下弹框的图片不显示问题待解决
    //image
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, ScreenW, ScreenH/2)];
    imageV.contentMode = UIViewContentModeScaleAspectFit;
    UIButton *imageBtn = (UIButton*)[[self.headerView getScrollView] subviews][self.headerView.currentPage] ;
    imageV.image = imageBtn.currentImage;
    
    //动画
    imageV.contentMode = UIViewContentModeScaleAspectFit;
    
    [self setAnimationOnView:imageV];
    
    [KWindow addSubview:imageV];
    [self.coverViewSubviews addObject:imageV];
    
    //text
    CGFloat Y = CGRectGetMaxY(imageV.frame);
    CYLTextView *textView = [[CYLTextView alloc] initWithFrame:CGRectMake(0, Y, ScreenW, ScreenH - Y - 60)];
    textView.font = [UIFont systemFontOfSize:17];
    textView.backgroundColor = [UIColor getColor:@"edef9a"];
    
    //内容
    NSString *content = model.articleAbstract;
    content = [content flattenHTML:content trimWhiteSpace:NO];
    content = [content stringByReplacingOccurrencesOfString:@"&#x" withString:@""];
    textView.text = content;
    
    //动画
    [self setAnimationOnView:textView];
    
    [self.coverViewSubviews addObject:textView];
    [KWindow addSubview:textView];
    
    //按钮
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(self.view.center.x - 80, CGRectGetMaxY(textView.frame) + 10, 44, 44);
    
    [cancelBtn setImage:[UIImage imageNamed:@"Cancel_64px_1194741_easyicon.net"] forState:UIControlStateNormal];
    [self setAnimationOnView:cancelBtn];
    
    [cancelBtn addTarget:self action:@selector(CancelBtn) forControlEvents:UIControlEventTouchUpInside];
    
    [KWindow insertSubview:cancelBtn aboveSubview:self.coverView];
    [self.coverViewSubviews addObject:cancelBtn];
    
    UIButton *goToWebBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    goToWebBtn.frame = CGRectMake(self.view.center.x + 36, CGRectGetMaxY(textView.frame) + 10, 44, 44);
    [goToWebBtn setImage:[UIImage imageNamed:@"Success_64px_1194837_easyicon.net"] forState:UIControlStateNormal];
    
    //利用title传递连接
    [goToWebBtn setTitle:model.doi forState:UIControlStateNormal];
    [goToWebBtn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    
    [self setAnimationOnView:goToWebBtn];
    
    [goToWebBtn addTarget:self action:@selector(goToWeb:) forControlEvents:UIControlEventTouchUpInside];
    
    [KWindow insertSubview:goToWebBtn aboveSubview:self.coverView];
    [self.coverViewSubviews addObject:goToWebBtn];
    
    
    [self.coverViewSubviews addObject:_coverView];
}


- (void)CancelBtn
{
     //动画消失效果
    
    for (UIView *view in self.coverViewSubviews) {
        
        [UIView animateWithDuration:animationDuration delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            view.transform = CGAffineTransformMakeTranslation(0, -ScreenH);
            
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
        
    }
}

- (void)goToWeb:(UIButton*)btn
{
    [self CancelBtn];
    
    self.webVC = nil;
    [self.webVC setUrl:[NSURL URLWithString:[NSString stringWithFormat:@"http://pubs.acs.org/doi/full/%@",btn.currentTitle]]];
    [self.navigationController presentViewController:_webVC animated:YES completion:nil];
}

- (void)setAnimationOnView:(UIView*)view
{
    view.transform = CGAffineTransformMakeTranslation(0, - ScreenH);
    
    [UIView animateWithDuration:animationDuration animations:^{
        view.transform = CGAffineTransformMakeTranslation(0, 0);
    }];
}

#pragma mark - 懒加载

- (UIView *)coverView
{
    if (_coverView == nil) {
        _coverView = [[UIView alloc] initWithFrame:self.view.frame];
        _coverView.backgroundColor = [UIColor blackColor];
        _coverView.alpha = .7;
        
        [KWindow addSubview:_coverView];
        
        //设置CoverViewde动画
        _coverView.transform = CGAffineTransformMakeTranslation(0, -ScreenH);
        
        [UIView animateWithDuration:animationDuration animations:^{
            _coverView.transform = CGAffineTransformMakeTranslation(0, 0);
        }];
    }
    return _coverView;
}

- (NSArray *)headerModelArray
{
    if (_headerModelArray == nil) {
        _headerModelArray = [CYLEditorChociseModel modelArray];
    }
    return _headerModelArray;
}

-(NSArray *)highLightArray
{
    if (_highLightArray == nil) {
        _highLightArray = [CYLHightLightModel highLightModelArray];
    }
    return _highLightArray;
}

-(CYLWebViewController *)webVC
{
    if (_webVC == nil) {
        _webVC = [[CYLWebViewController alloc] init];
    }
    return _webVC;
}


@end
