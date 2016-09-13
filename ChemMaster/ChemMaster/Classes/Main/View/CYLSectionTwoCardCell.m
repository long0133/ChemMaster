//
//  CYLSectionTwoCardCell.m
//  ChemMaster
//
//  Created by GARY on 16/8/18.
//  Copyright © 2016年 GARY. All rights reserved.
//

#import "CYLSectionTwoCardCell.h"
#import "CYLTileButton.h"
static NSInteger lastBtnTag = 99999;

@interface CYLSectionTwoCardCell ()

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
    
    _AminoBtn.tag = 0;
    _CarbonylBtn.tag = 1;
    _CarboxylBtn.tag = 2;
    _HydroxylBtn.tag = 3;
    
    [_AminoBtn addTarget:self action:@selector(DidClickButton:) forControlEvents:UIControlEventTouchUpInside];
    [_CarboxylBtn addTarget:self action:@selector(DidClickButton:) forControlEvents:UIControlEventTouchUpInside];
    [_CarbonylBtn addTarget:self action:@selector(DidClickButton:) forControlEvents:UIControlEventTouchUpInside];
    [_HydroxylBtn addTarget:self action:@selector(DidClickButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [_AminoBtn setBackgroundColor:randomColor];
    [_CarbonylBtn setBackgroundColor:randomColor];
    [_CarboxylBtn setBackgroundColor:randomColor];
    [_HydroxylBtn setBackgroundColor:randomColor];
    
    [self addSubview:_AminoBtn];
    [self addSubview:_CarboxylBtn];
    [self addSubview:_CarbonylBtn];
    [self addSubview:_HydroxylBtn];
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

- (void)setContentArray:(NSMutableArray *)ContentArray
{
    _ContentArray = ContentArray;
    
    _AminoBtn.contentArray = ContentArray[0];
    _CarbonylBtn.contentArray = ContentArray[1];
    _CarboxylBtn.contentArray = ContentArray[2];
    _HydroxylBtn.contentArray = ContentArray[3];
}

#pragma mark - 设置按钮单击后的动画效果
- (void)DidClickButton:(CYLTileButton*)btn
{
    btn.userInteractionEnabled = NO;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        btn.userInteractionEnabled = YES;
    });
    
    if (lastBtnTag == btn.tag) { //第2次点击此按钮
        
        for (CYLTileButton *botton in self.subviews) {
            
            [UIView animateWithDuration:.5 animations:^{
                
                if (botton.tag == lastBtnTag) {
                    
                    [btn backToOrigin];
                }
                
            }];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:1 animations:^{
                    
                    botton.alpha = 1;
                }];
            });
        }
        
        lastBtnTag = 9999;
        
    }
    else //第1次点击此按钮
    {
        for (CYLTileButton *button in self.subviews) {
            
            if (btn.tag != button.tag) {
                
                [UIView animateWithDuration:.5 animations:^{
                    button.alpha = 0;
                }];
            }
        }
        
        CGPoint center = CGPointMake(self.frame.size.width/2, self.frame.size.width/2);
        [btn showAnimationAtPoint:center onView:self andDelay:.5];
        
        lastBtnTag = btn.tag;
    }
    
}

@end
