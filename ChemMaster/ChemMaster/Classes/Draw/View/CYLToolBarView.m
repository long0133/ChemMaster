//
//  CYLToolBarView.m
//  ChemMaster
//
//  Created by GARY on 16/6/18.
//  Copyright © 2016年 GARY. All rights reserved.
//

#import "CYLToolBarView.h"

@interface CYLToolBarView ()

@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, strong) UIButton *DrawBtn;
@property (nonatomic, strong) UIButton *doubleBondBtn;
@property (nonatomic, strong) UIButton *TripleBondBtn;

@end

@implementation CYLToolBarView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self setUpUI];
        
    }
    
    return self;
}

- (void)setUpUI
{
    _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectBtn.backgroundColor = randomColor;
    [_selectBtn setTitle:@"SEL" forState:UIControlStateNormal];
    [_selectBtn addTarget:self action:@selector(Select) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_selectBtn];
    
    _DrawBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _DrawBtn.backgroundColor = randomColor;
    [_DrawBtn setTitle:@"DRAW" forState:UIControlStateNormal];
    [_DrawBtn addTarget:self action:@selector(draw) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_DrawBtn];
    
    _doubleBondBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _doubleBondBtn.backgroundColor = randomColor;
    [_doubleBondBtn setTitle:@"double" forState:UIControlStateNormal];
    [_doubleBondBtn addTarget:self action:@selector(DoubleBond) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_doubleBondBtn];
    
    _TripleBondBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _TripleBondBtn.backgroundColor = randomColor;
    [_TripleBondBtn setTitle:@"triple" forState:UIControlStateNormal];
    [_TripleBondBtn addTarget:self action:@selector(TripleBond) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_TripleBondBtn];
    
}

- (void)layoutSubviews
{
    [_DrawBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self).offset(10);
        make.width.height.mas_equalTo(44);
    }];
    
    [_selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.left.equalTo(self.DrawBtn.mas_right).offset(10);
        make.width.height.equalTo(self.DrawBtn);
    }];
    
    [_doubleBondBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.left.equalTo(self.selectBtn.mas_right).offset(10);
        make.width.height.equalTo(self.DrawBtn);
    }];
    
    [_TripleBondBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.left.equalTo(self.doubleBondBtn.mas_right).offset(10);
        make.width.height.equalTo(self.DrawBtn);
    }];
}

#pragma mark - 按钮店家方法
- (void)Select
{
    if ([self.delegate respondsToSelector:@selector(toolBarDidClickSelectBtn)]) {
        [self.delegate toolBarDidClickSelectBtn];
    }
}

- (void)draw
{
    if ([self.delegate respondsToSelector:@selector(toolBarDidClickDrawBtn)]) {
        [self.delegate toolBarDidClickDrawBtn];
    }
    
}

- (void)DoubleBond
{
    if ([self.delegate respondsToSelector:@selector(toolBarDidClickDoubleBondBtn)]) {
        [self.delegate toolBarDidClickDoubleBondBtn];
    }
}

- (void)TripleBond
{
    if ([self.delegate respondsToSelector:@selector(toolBarDidClickTripleBondBtn)]) {
        [self.delegate toolBarDidClickTripleBondBtn];
    }
}
@end
