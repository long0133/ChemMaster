//
//  CYLAngleBtn.m
//  ChemMaster
//
//  Created by GARY on 16/7/7.
//  Copyright © 2016年 GARY. All rights reserved.
//

#import "CYLAngleBtn.h"

@implementation CYLAngleBtn

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGRect rect = CGRectZero;
    
    CGFloat H = self.frame.size.height/5;
    CGFloat W = self.frame.size.width/5;
    
    rect = CGRectMake(self.frame.size.width - W, self.frame.size.height - H, W, H);
    
    return rect;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    
    CGRect rect = CGRectZero;

    rect = CGRectMake(0, self.frame.size.height/8, self.frame.size.width, self.frame.size.height/5 * 4);
    
    return rect;
}

@end
