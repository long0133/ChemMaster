//
//  CYLScrollBtn.m
//  ChemMaster
//
//  Created by GARY on 16/7/27.
//  Copyright © 2016年 GARY. All rights reserved.
//

#import "CYLScrollBtn.h"

@implementation CYLScrollBtn

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    }
    return self;
}


- (void)setScrollImage:(UIImage *)ScrollImage
{
    _ScrollImage = ScrollImage;
    
    UIImageView *imageV = [[UIImageView alloc] initWithImage:ScrollImage];
    
    imageV.frame = CGRectMake(0, 0, ScrollImage.size.width, ScrollImage.size.height);
    
    self.scrollView.contentSize = CGSizeMake(ScrollImage.size.width , ScrollImage.size.height);
    
    [self.scrollView addSubview:imageV];
    
}
@end
