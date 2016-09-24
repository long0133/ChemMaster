//
//  CYLSectionSecondTwoCell.m
//  ChemMaster
//
//  Created by GARY on 16/9/12.
//  Copyright © 2016年 GARY. All rights reserved.
//

#import "CYLSectionSecondTwoCell.h"

@interface CYLSectionSecondTwoCell ()

@property(nonatomic, strong)UILabel *titleLable;

@property (nonatomic, strong) NSMutableArray *selectArray;

@property (nonatomic, strong) UIScrollView *contentScrollView;

@end

@implementation CYLSectionSecondTwoCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self setUpCell];
        
    }
    return self;
}

- (void)setUpCell
{
    self.backgroundColor = [UIColor grayColor];
    
    self.titleLable.text = @"Recent Hightlight";
    
    [self setUpScrollContent];
}

- (void)setUpScrollContent
{
    //子线程网络中获取信息，下载过程中显示动画
    
    
    //加载内容
}

- (void)layoutSubviews
{
    [_titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.mas_equalTo(40);
    }];
    
    [_contentScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLable.mas_bottom).offset(10);
        make.left.right.bottom.equalTo(self);
    }];
}


#pragma mark - 懒加载
- (UIScrollView *)contentScrollView
{
    if (_contentScrollView == nil) {
        _contentScrollView = [[UIScrollView alloc] init];
        [self addSubview:_contentScrollView];
    }
    return _contentScrollView;
}

- (UILabel *)titleLable
{
    if (_titleLable == nil) {
        _titleLable = [[UILabel alloc] init];
        _titleLable.textColor = [UIColor whiteColor];
        _titleLable.backgroundColor = [UIColor getColor:@"4C9459"];
        _titleLable.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_titleLable];
    }
    
    return _titleLable;
}

- (NSMutableArray *)selectArray
{
    if (_selectArray == nil) {
        _selectArray = [NSMutableArray array];
    }
    return _selectArray;
}
@end
