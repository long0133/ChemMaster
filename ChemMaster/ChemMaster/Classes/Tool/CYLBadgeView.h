//
//  CYLBadgeView.h
//  LoveFreshBeen山寨
//
//  Created by GARY on 16/6/8.
//  Copyright © 2016年 GARY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CYLBadgeView : UIButton

@property (nonatomic, assign) NSInteger badgeValue;

+ (instancetype)badgeViewWithBadgeValue:(NSInteger)badgeValue inSuperView:(UIView*)superView withRect:(CGRect)rect;
@end
