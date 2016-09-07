//
//  CYLStructureSelectView.m
//  ChemMaster
//
//  Created by GARY on 16/9/6.
//  Copyright © 2016年 GARY. All rights reserved.
//

#import "CYLStructureSelectView.h"
#define reuseID @"reuse"

@interface CYLStructureSelectView ()



@end

@implementation CYLStructureSelectView


#pragma mark - 自定义初始化方法

- (void)setModelArray:(NSMutableArray *)ModelArray
{
    _ModelArray = ModelArray;
    
    [self reloadData];
}

+ (instancetype)SetUpStructureSelectViewWithModelArray:(NSMutableArray *)modelArray
{
    CYLStructureSelectView *SSV = [[CYLStructureSelectView alloc] init];
    
    SSV.isShow = NO;
    
    SSV.ModelArray = modelArray;
    
    return SSV;
}
@end
