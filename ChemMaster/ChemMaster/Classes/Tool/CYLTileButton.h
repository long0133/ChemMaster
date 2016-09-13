//
//  CYLTileButton.h
//  ChemMaster
//
//  Created by GARY on 16/9/12.
//  Copyright © 2016年 GARY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CYLTileButton : UIButton

@property (nonatomic, strong) NSArray *contentArray;

- (void)showAnimationAtPoint:(CGPoint)point onView:(UIView*)view andDelay:(CGFloat)delay;
- (void)backToOrigin;

@end
