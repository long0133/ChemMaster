//
//  CYLSectionTwoCardCell.m
//  ChemMaster
//
//  Created by GARY on 16/8/18.
//  Copyright © 2016年 GARY. All rights reserved.
//

#import "CYLSectionTwoCardCell.h"
#import "CYLTileButton.h"
#define animationDuration .3
static NSInteger lastBtnTag = 99999;

typedef NS_ENUM(NSUInteger, ProtectedGroupType) {
    ProtectedGroupAmino,
    ProtectedGroupCarbonyl,
    ProtectedGroupCarboxyl,
    ProtectedGroupHydroxyl
};

@interface CYLSectionTwoCardCell ()<CYLTileButtonDelegate>

@property (nonatomic, strong) CYLTileButton *AminoBtn;
@property (nonatomic, strong) CYLTileButton *CarbonylBtn;
@property (nonatomic, strong) CYLTileButton *CarboxylBtn;
@property (nonatomic, strong) CYLTileButton *HydroxylBtn;

@end

@implementation CYLSectionTwoCardCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self setUpView];
        
    }
    return self;
}

- (void)setUpView
{
    _AminoBtn = [[CYLTileButton alloc] init];
    _CarbonylBtn = [[CYLTileButton alloc] init];
    _CarboxylBtn = [[CYLTileButton alloc] init];
    _HydroxylBtn = [[CYLTileButton alloc] init];
    
    _AminoBtn.tag = ProtectedGroupAmino;
    _CarbonylBtn.tag = ProtectedGroupCarbonyl;
    _CarboxylBtn.tag = ProtectedGroupCarboxyl;
    _HydroxylBtn.tag = ProtectedGroupHydroxyl;
    
    [_AminoBtn addTarget:self action:@selector(DidClickButton:) forControlEvents:UIControlEventTouchUpInside];
    [_CarboxylBtn addTarget:self action:@selector(DidClickButton:) forControlEvents:UIControlEventTouchUpInside];
    [_CarbonylBtn addTarget:self action:@selector(DidClickButton:) forControlEvents:UIControlEventTouchUpInside];
    [_HydroxylBtn addTarget:self action:@selector(DidClickButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [_AminoBtn setTitle:@"Amino_Stability" forState:UIControlStateNormal];
    [_CarbonylBtn setTitle:@"Carbonyl_Stability" forState:UIControlStateNormal];
    [_CarboxylBtn setTitle:@"Carboxyl_Stability" forState:UIControlStateNormal];
    [_HydroxylBtn setTitle:@"Hydroxyl_Stability" forState:UIControlStateNormal];
    
    [_AminoBtn setBackgroundColor:[UIColor getColor:@"54A271"]];
    [_CarbonylBtn setBackgroundColor:[UIColor getColor:@"45ADA8"]];
    [_CarboxylBtn setBackgroundColor:[UIColor getColor:@"3280B7"]];
    [_HydroxylBtn setBackgroundColor:[UIColor getColor:@"814F14"]];
    
    [self.contentView addSubview:_AminoBtn];
    [self.contentView addSubview:_CarboxylBtn];
    [self.contentView addSubview:_CarbonylBtn];
    [self.contentView addSubview:_HydroxylBtn];
    
    _AminoBtn.delegate = self;
    _CarbonylBtn.delegate = self;
    _CarboxylBtn.delegate = self;
    _HydroxylBtn.delegate = self;
}

- (void)layoutSubviews
{
    [_AminoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.equalTo(self);
        make.height.width.mas_equalTo(self.frame.size.width/2);
        
    }];
    
    [_CarbonylBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.AminoBtn.mas_right);
        make.top.equalTo(self);
        make.height.width.equalTo(self.AminoBtn);
        
    }];
    
    [_CarboxylBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self.AminoBtn.mas_bottom);
        make.height.width.equalTo(self.AminoBtn);
        
    }];
    
    [_HydroxylBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.CarboxylBtn.mas_right);
        make.top.equalTo(self.CarboxylBtn);
        make.height.width.equalTo(self.AminoBtn);
        
    }];
}



#pragma mark - 设置按钮单击后的动画效果
- (void)DidClickButton:(CYLTileButton*)btn
{
    
    switch (btn.tag) {
        case ProtectedGroupAmino:
        {
            NSBundle *aminoBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"Amino" ofType:@"bundle"]];
            btn.contentBundle = aminoBundle;
        }
            break;
            
        case ProtectedGroupCarbonyl:
        {
            NSBundle *carbonlyBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"Carbonyl" ofType:@"bundle"]];
            btn.contentBundle = carbonlyBundle;
        }
            break;
            
        case ProtectedGroupCarboxyl:
        {
            NSBundle *carboxylBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"Carboxyl" ofType:@"bundle"]];
            btn.contentBundle = carboxylBundle;
        }
            break;
            
        case ProtectedGroupHydroxyl:
        {
            NSBundle *HydroxylBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"Hydroxyl" ofType:@"bundle"]];
            btn.contentBundle = HydroxylBundle;
        }
            break;
            
        default:
            break;
    }
    
    [self setBtnAnimation:btn];
}

- (void)setBtnAnimation:(CYLTileButton*)btn
{
    btn.userInteractionEnabled = NO;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(animationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        btn.userInteractionEnabled = YES;
    });
    
    for (CYLTileButton *button in self.contentView.subviews) {
        
        if (btn != button) {
            
            [UIView animateWithDuration:animationDuration animations:^{
                button.alpha = 0;
            }];
        }
        
        [self.contentView insertSubview:btn atIndex:(self.contentView.subviews.count - 1)];
        
        CGPoint center = CGPointMake(self.frame.size.width/2, self.frame.size.width/2);
        [btn showAnimationAtPoint:center onView:self.contentView andDelay:animationDuration];
        
//        lastBtnTag = btn.tag;
    }
    
    [btn setTitle:btn.currentTitle forState:UIControlStateNormal];
    
}
#pragma mark - CYLTileButtonDelegate
- (void)tileBtnDidClickBackBtn
{
    for (CYLTileButton *botton in self.contentView.subviews) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(animationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:1 animations:^{
                
                botton.alpha = 1;
            }];
        });
    }
}

@end
