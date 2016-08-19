//
//  CYLFlowLayOut.m
//  ChemMaster
//
//  Created by GARY on 16/8/18.
//  Copyright © 2016年 GARY. All rights reserved.
//

#import "CYLFlowLayOut.h"

#define headerTwoHeight 0

@interface CYLFlowLayOut ()

//sectionOne 的最大高度
@property (nonatomic, assign) NSInteger maxHeight;

@end

@implementation CYLFlowLayOut

//设置header的布局
- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:indexPath];
    
    if (elementKind == UICollectionElementKindSectionHeader) {
        
        if (indexPath.section == 0) {
            
            attr.frame = CGRectMake(0, 0, ScreenW, 200);
            
        }
        else if (indexPath.section == 1)
        {
            
//            attr.frame = CGRectMake(0, 500, ScreenW, headerTwoHeight);
        }
    }
    
    return attr;
}

//设置cell的layout
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    
    if (indexPath.section == 0)
    {
        attr = [super layoutAttributesForItemAtIndexPath:indexPath];
        
        if (indexPath.item == count - 1) {
            _maxHeight = CGRectGetMaxY(attr.frame) + 20 + headerTwoHeight;
        }
        
    }
    else if (indexPath.section == 1)
    {
        attr.frame = CGRectMake(10, _maxHeight, (ScreenW - 20), 400);
        
        _maxHeight = CGRectGetMaxY(attr.frame) + 10;
        
    }
    
    return attr;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSInteger sectionOneItems = [self.collectionView numberOfItemsInSection:0];
    NSInteger sectionTwoItem = [self.collectionView numberOfItemsInSection:1];
    
    NSMutableArray *attrArray = [NSMutableArray array];
    
    //sectionOne的cell布局
    for (int i = 0; i < sectionOneItems; i ++) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        
        UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:indexPath];
        
        [attrArray addObject:attr];
    }
    
    NSIndexPath *indexPathOne = [NSIndexPath indexPathForItem:0 inSection:0];
    //显示sectionone 的header 的view
    [attrArray addObject:[self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPathOne]];
    
    
    //sectionTwo的cell布局
    for (int i = 0; i < sectionTwoItem; i ++) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:1];
        
        UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:indexPath];
        
        [attrArray addObject:attr];
    }
#warning 设置sectionTwo的header的flowlayout
    NSIndexPath *indexPathSectionTwo = [NSIndexPath indexPathForItem:0 inSection:1];
    [attrArray addObject:[self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPathSectionTwo]];
    
    
    return attrArray;
}

- (CGSize)collectionViewContentSize
{
    return CGSizeMake(ScreenW, _maxHeight);
}

@end
