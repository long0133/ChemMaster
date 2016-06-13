//
//  CYLTabBarButton.m
//  LoveFreshBeen山寨
//
//  Created by GARY on 16/4/27.
//  Copyright © 2016年 GARY. All rights reserved.
//

#import "CYLTabBarButton.h"


@implementation CYLTabBarButton

//- (instancetype)initWithFrame:(CGRect)frame
//{
//    if (self = [super initWithFrame:frame]) {
//        
//        _badgeView = [CYLBadgeView badgeViewWithBadgeValue:0 inSuperView:self withRect:CGRectMake(45, 5, 15, 15)];
//        
//        _badgeView.hidden = YES;
//    }
//    return self;
//}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted
{
    
}


- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGRect imageViewFrame = self.imageView.frame;
    
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    //设置title位置
    CGRect frame = CGRectMake(0, CGRectGetMaxY(imageViewFrame) - 3, self.frame.size.width, self.frame.size.height - imageViewFrame.size.height);
    
    return frame;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    
    //设置图片位置
    CGFloat imageW = self.frame.size.width / 3;
    CGFloat ImageX = (self.frame.size.width - imageW) / 2;
    CGRect frame = CGRectMake(ImageX, 5, imageW ,imageW);
    return frame;
}

@end
