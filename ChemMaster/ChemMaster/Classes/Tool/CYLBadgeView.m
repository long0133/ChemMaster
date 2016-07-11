//
//  CYLBadgeView.m
//  LoveFreshBeen山寨
//
//  Created by GARY on 16/6/8.
//  Copyright © 2016年 GARY. All rights reserved.
//

#import "CYLBadgeView.h"

@implementation CYLBadgeView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.userInteractionEnabled = NO;
        
        self.layer.cornerRadius = self.frame.size.width * 0.5;
        self.layer.backgroundColor = [UIColor redColor].CGColor;
        
        self.titleLabel.font = [UIFont systemFontOfSize:11];
    }
    
    return self;
}

+ (instancetype)badgeViewWithBadgeValue:(NSInteger)badgeValue inSuperView:(UIView *)superView withRect:(CGRect)rect
{
    CYLBadgeView *badgeView = [[CYLBadgeView alloc] initWithFrame:rect];
    
    badgeView.badgeValue = badgeValue;
    
    [badgeView setTitle:[NSString stringWithFormat:@"%ld",(long)badgeValue] forState:UIControlStateNormal];
    
    [superView addSubview:badgeView];
    [superView bringSubviewToFront:badgeView];
    
    return badgeView;
}

- (void)setBadgeValue:(NSInteger)badgeValue
{
    _badgeValue = badgeValue;
    
    [self setTitle:[NSString stringWithFormat:@"%ld", badgeValue] forState:UIControlStateNormal];
}

@end
