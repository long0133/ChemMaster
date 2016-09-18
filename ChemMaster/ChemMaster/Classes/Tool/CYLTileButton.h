//
//  CYLTileButton.h
//  ChemMaster
//
//  Created by GARY on 16/9/12.
//  Copyright © 2016年 GARY. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CYLTileButtonDelegate <NSObject>

- (void)tileBtnDidClickBackBtn;

@end

@interface CYLTileButton : UIButton
@property (nonatomic, strong) NSArray *contentArray;
@property (nonatomic, strong) NSBundle *contentBundle;
@property (nonatomic,weak) id<CYLTileButtonDelegate> delegate;

- (void)showAnimationAtPoint:(CGPoint)point onView:(UIView*)view andDelay:(CGFloat)delay;
- (void)backToOrigin;

@end
