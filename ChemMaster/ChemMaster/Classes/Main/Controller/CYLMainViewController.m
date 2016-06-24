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
    
    flowLayOut.itemSize = CGSizeMake(ScreenW, 80);
    
    flowLayOut.minimumLineSpacing = 10;
    
    return [super initWithCollectionViewLayout:flowLayOut];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = [UIColor getColor:@"DCDCDC"];

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
            view.backgroundColor = barColor;
        }
        
        
    }
    else
    {
        view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer" forIndexPath:indexPath];
    }
    
    return view;
}

#pragma CYLHeaderReusableViewDelegate
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
