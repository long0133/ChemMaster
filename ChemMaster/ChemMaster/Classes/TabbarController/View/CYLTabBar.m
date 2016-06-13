//
//  CYLTabBar.m
//  ChemMaster
//
//  Created by GARY on 16/6/12.
//  Copyright © 2016年 GARY. All rights reserved.
//

#import "CYLTabBar.h"
#import "CYLTabBarButton.h"
#import "UpImageDownTitleButton.h"

@interface CYLTabBar ()
@property (nonatomic ,strong) UIButton *lastSelectedBtn;
@end

@implementation CYLTabBar

- (void)setTabBarItemArray:(NSArray *)tabBarItemArray
{
        _tabBarItemArray = tabBarItemArray;
    
    for (NSInteger i = 0; i < tabBarItemArray.count; i ++) {
        
        UITabBarItem *item = tabBarItemArray[i];
        
        CYLTabBarButton  *btn = [CYLTabBarButton buttonWithType:UIButtonTypeCustom];
        
        [btn setImage:item.image forState:UIControlStateNormal];
        [btn setImage:item.selectedImage forState:UIControlStateSelected];
        [btn setTitle:item.title forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:11];
        
        btn.transform = CGAffineTransformMakeScale(0.9, 0.9);
        
        [btn addTarget:self action:@selector(ButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:btn];
        
        if (i == 0) {
            
            btn.selected = YES;
            _lastSelectedBtn = btn;
            
        }
    }
}

- (void)layoutSubviews
{
    CGFloat btnW = ScreenW / _tabBarItemArray.count;
    CGFloat btnH = self.frame.size.height;
    
    NSInteger count = self.subviews.count;
    
    for (NSInteger i = 0; i < count; i ++) {
        
        UIButton *btn = self.subviews[i];
        
        btn.tag = i;
        
        btn.frame = CGRectMake(i * btnW, 0, btnW, btnH);
    }
}

- (void)ButtonClicked:(UIButton *)btn
{
    _lastSelectedBtn.selected = NO;
    
    [self AnimationWithBtn:btn];
    
    if ([self.delegate respondsToSelector:@selector(tabBar:DidClickButton:)]) {
        [self.delegate tabBar:self DidClickButton:btn];
    }
    
    btn.selected =YES;
    _lastSelectedBtn = btn;
    
}

- (void)AnimationWithBtn:(UIButton*)btn
{
    //button动画效果
    CAKeyframeAnimation *keyAnim = [CAKeyframeAnimation animation];
    
    keyAnim.keyPath = @"transform.scale";
    
    keyAnim.values = @[@1.2, @0.8, @1.1, @0.9, @1.0];
    
    keyAnim.repeatCount = 1;
    
    keyAnim.repeatDuration = 2.0;
    
    keyAnim.removedOnCompletion = YES;
    
    keyAnim.fillMode = kCAFillModeBackwards;
    
    [btn.imageView.layer addAnimation:keyAnim forKey:nil];
}
@end
