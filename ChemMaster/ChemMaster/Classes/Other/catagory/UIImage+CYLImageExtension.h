//
//  UIImage+CYLImageExtension.h
//  ChemMaster
//
//  Created by GARY on 16/6/15.
//  Copyright © 2016年 GARY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (CYLImageExtension)

//按比例缩放,size 是你要把图显示到 多大区域 CGSizeMake(300, 140)
+ (UIImage *)imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size;

@end
