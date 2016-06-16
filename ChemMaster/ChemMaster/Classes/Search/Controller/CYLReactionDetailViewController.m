//
//  CYLReactionDetailViewController.m
//  ChemMaster
//
//  Created by GARY on 16/6/16.
//  Copyright © 2016年 GARY. All rights reserved.
//

#import "CYLReactionDetailViewController.h"

@interface CYLReactionDetailViewController ()

@property (nonatomic, strong) UIScrollView *contentScrollView;

@end

@implementation CYLReactionDetailViewController

- (UIScrollView *)contentScrollView
{
    if (_contentScrollView == nil) {
        _contentScrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    }
    return _contentScrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - 计算scrollview的ContentSize
- (NSInteger)caculateContentSizeForScrollView
{
//    //取出内容数组
//    NSArray *contentArray = self.detailModel.contentArray;
//    
//    CGFloat H = 0;
//    
//    for (NSString *content in contentArray) {
//        
//        if (<#condition#>)
//        {
//            //如果是文本
//            <#statements#>
//        }
//        else if (<#expression#>)
//        {
//            //如果是图片
//        }
//        else if (<#expression#>)
//        {
//            //如果是lecture
//        }
//        
//    }
    return 0;
}


- (instancetype)initWithDetailModel:(CYLDetailModel *)model
{
    self.detailModel = model;
    return [[CYLReactionDetailViewController alloc] init];
}

@end
