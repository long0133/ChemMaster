//
//  CYLAssistanceView.m
//  ChemMaster
//
//  Created by GARY on 16/7/5.
//  Copyright © 2016年 GARY. All rights reserved.
//

#import "CYLAssistanceView.h"

@interface CYLAssistanceView ()


//截屏按钮
@property (nonatomic, strong) UIButton *clipScreenBtn;

@end

@implementation CYLAssistanceView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self clipScreenBtn];
    }
    return self;
}

- (UIButton *)clipScreenBtn
{
    if (_clipScreenBtn == nil) {
        _clipScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _clipScreenBtn.frame = CGRectMake(0, 0, 33, 33);
        [_clipScreenBtn setBackgroundImage:[UIImage imageNamed:@"Camera-2-icon"] forState:UIControlStateNormal];
        [_clipScreenBtn addTarget:self action:@selector(clipScreen) forControlEvents:UIControlEventTouchUpInside];
        _clipScreenBtn.alpha = .3;
        [self addSubview:_clipScreenBtn];
    }
    return _clipScreenBtn;
}


//截屏方法
- (void)clipScreen
{
    if ([self.delegate respondsToSelector:@selector(assistanceViewDidClickClipScrennBtn:)]) {
        [self.delegate assistanceViewDidClickClipScrennBtn:self.clipScreenBtn];
    }
}


@end
