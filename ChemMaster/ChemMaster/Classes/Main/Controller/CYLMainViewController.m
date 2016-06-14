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


@interface CYLMainViewController ()<CYLHeaderReusableViewDelegate,CYLHightLightCellDelegate>
@property (nonatomic, strong) NSArray *headerModelArray;

@property (nonatomic, strong) WKWebView *WebView;

@property (nonatomic , strong) NSArray *highLightArray;
@end

@implementation CYLMainViewController

static NSString * const reuseIdentifier = @"Cell";

- (instancetype)init
{
    UICollectionViewFlowLayout *flowLayOut = [[UICollectionViewFlowLayout alloc] init];
    
    flowLayOut.headerReferenceSize = CGSizeMake(ScreenW, 200);
    
    flowLayOut.itemSize = CGSizeMake(ScreenW, 100);
    
    flowLayOut.minimumLineSpacing = 20;
    
    return [super initWithCollectionViewLayout:flowLayOut];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = [UIColor lightGrayColor];

    [self.collectionView registerClass:[CYLHightLightCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    [self.collectionView registerClass:[CYLHeaderReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.highLightArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CYLHightLightCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.model = self.highLightArray[indexPath.row];
    
    cell.delegate = self;
    
    return cell;
}

- (UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    CYLHeaderReusableView *view = nil;
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        
        if (indexPath.section == 0) {
    
            [view HeaderScrollViewWithModelArray:self.headerModelArray];
            
            view.delegate = self;
        }
        else
        {
            view.backgroundColor = randomColor;
        }
        
        
    }
    else
    {
        view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer" forIndexPath:indexPath];
    }
    
    view.backgroundColor = randomColor;
    
    return view;
}

#pragma CYLHeaderReusableViewDelegate
#warning 点击推荐显示详情未完成
//显示webView
- (void)HeaderReusableView:(CYLHeaderReusableView *)View didChoiceEditorModel:(CYLEditorChociseModel *)model
{
    
   
}


#pragma mark - CYLHightLightCellDelegate
#warning 返回功能，toolbar添加 未完成
- (void)HightLightCellDidClickButton:(UIButton *)btn
{
    if ([btn.titleLabel.text isEqualToString:@"acs"]) {
        
        [self.WebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://pubs.acs.org/"]]];
    }
    else if ([btn.titleLabel.text isEqualToString:@"angew"])
    {
        [self.WebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://onlinelibrary.wiley.com/"]]];
    }
    else
    {
        [self.WebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.rsc.org/"]]];
    }
}

#pragma mark - 懒加载
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

- (WKWebView *)WebView{
    if (_WebView == nil) {
        _WebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
        _WebView.allowsBackForwardNavigationGestures = YES;
        [KWindow addSubview:_WebView];
    }
    return _WebView;
}
@end
