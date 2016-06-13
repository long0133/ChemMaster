//
//  UpImageDownTitle.m
//  LoveFreshBeen山寨
//
//  Created by GARY on 16/4/30.
//  Copyright © 2016年 GARY. All rights reserved.
//

#import "UpImageDownTitleButton.h"


@implementation UpImageDownTitleButton


- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGRect imageViewFrame = self.imageView.frame;
    
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    //设置title位置
     CGRect frame = CGRectMake(0, CGRectGetMaxY(imageViewFrame), self.frame.size.width, self.frame.size.height - imageViewFrame.size.height);

    return frame;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{

    //设置图片位置
    CGFloat ImageX = (self.frame.size.width - _ImageWidth) / 2;
    CGRect frame = CGRectMake(ImageX, _imageTopMargin, _ImageWidth ,_ImageWidth);
    return frame;
}

+ (instancetype)ButtonWithImage:(UIImage *)image andTitle:(NSString *)title
{
    UpImageDownTitleButton *btn = [self buttonWithType:UIButtonTypeCustom];
    
//    btn.imageView.backgroundColor = [UIColor greenColor];
    
    NSLog(@"%@",image);
    
    [btn setImage:image forState:UIControlStateNormal];
    
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    btn.titleLabel.font = [UIFont systemFontOfSize:11];

    
    return btn;
    
}

@end
