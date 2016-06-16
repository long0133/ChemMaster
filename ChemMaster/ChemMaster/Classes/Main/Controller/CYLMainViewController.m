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



@interface CYLMainViewController ()<CYLHeaderReusableViewDelegate,CYLHightLightCellDelegate>
@property (nonatomic, strong) NSArray *headerModelArray;

@property (nonatomic , strong) NSArray *highLightArray;

@property (nonatomic,strong) CYLWebViewController *webVC;
@end

@implementation CYLMainViewController

static NSString * const reuseIdentifier = @"Cell";

- (instancetype)init
{
    UICollectionViewFlowLayout *flowLayOut = [[UICollectionViewFlowLayout alloc] init];
    
    flowLayOut.headerReferenceSize = CGSizeMake(ScreenW, 200);
    
    flowLayOut.itemSize = CGSizeMake(150, 150);
    
    flowLayOut.minimumLineSpacing = 20;
    
    return [super initWithCollectionViewLayout:flowLayOut];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];

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
    
    cell.backgroundColor = randomColor;
    
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
    
    return view;
}

#pragma CYLHeaderReusableViewDelegate
#warning 点击推荐显示详情未完成
//显示webView
- (void)HeaderReusableView:(CYLHeaderReusableView *)View didChoiceEditorModel:(CYLEditorChociseModel *)model
{
    self.webVC = nil;
    [self.webVC setUrl:[NSURL URLWithString:[NSString stringWithFormat:@"http://pubs.acs.org/doi/full/%@",model.doi]]];
    [self.navigationController presentViewController:_webVC animated:YES completion:nil];
}


#pragma mark - CYLHightLightCellDelegate 点击跳转到网页
- (void)HightLightCellDidClickButton:(UIButton *)btn
{
    if ([btn.titleLabel.text isEqualToString:@"acs"]) {
        
        self.webVC = nil;
        [self.webVC setUrl:[NSURL URLWithString:@"http://pubs.acs.org/"]];
        
        
    }
    else if ([btn.titleLabel.text isEqualToString:@"wiley"])
    {
        self.webVC = nil;
        [self.webVC setUrl:[NSURL URLWithString:@"http://onlinelibrary.wiley.com/"]];
    }
    else
    {
        self.webVC = nil;
        [self.webVC setUrl:[NSURL URLWithString:@"http://www.rsc.org/"]];
    }
    
    [self.navigationController presentViewController:_webVC animated:YES completion:nil];
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

-(CYLWebViewController *)webVC
{
    if (_webVC == nil) {
        _webVC = [[CYLWebViewController alloc] init];
    }
    return _webVC;
}

@end
