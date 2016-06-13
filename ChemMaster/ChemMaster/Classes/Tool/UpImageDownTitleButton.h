//
//  UpImageDownTitle.h
//  LoveFreshBeen山寨
//
//  Created by GARY on 16/4/30.
//  Copyright © 2016年 GARY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpImageDownTitleButton : UIButton
//图片的边长
@property (nonatomic, assign) CGFloat ImageWidth;

//图片顶部距离父控件的距离
@property (nonatomic, assign) CGFloat imageTopMargin;

+ (instancetype)ButtonWithImage:(UIImage*)image andTitle:(NSString*)title;

@end
