//
//  CYLTabBar.h
//  ChemMaster
//
//  Created by GARY on 16/6/12.
//  Copyright © 2016年 GARY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CYLTabBar;

@protocol CYLTabBarDelegate <NSObject>

- (void)tabBar:(CYLTabBar*)tabBar DidClickButton:(UIButton*)button;

@end

@interface CYLTabBar : UIView
@property (nonatomic , strong) NSArray *tabBarItemArray;

@property (nonatomic, strong) id<CYLTabBarDelegate> delegate;
@end
