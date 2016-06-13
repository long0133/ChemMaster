//
//  CYLTabBarController.m
//  ChemMaster
//
//  Created by GARY on 16/6/12.
//  Copyright © 2016年 GARY. All rights reserved.
//

#import "CYLTabBarController.h"
#import "CYLMainViewController.h"
#import "CYLSearchViewController.h"
#import "CYLDrawViewController.h"
#import "CYLMineViewController.h"
#import "CYLNaviViewController.h"
#import "CYLTabBar.h"

@interface CYLTabBarController ()<CYLTabBarDelegate>
@property (nonatomic, strong) NSMutableArray *tabBarItemArray;

@end

@implementation CYLTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpAllViewContoller];
    
    [self setTabBar];
}

- (void)setTabBar
{
    CYLTabBar *tabBar = [[CYLTabBar alloc] init];
    tabBar.frame = self.tabBar.bounds;
    
    tabBar.delegate =self;
    
    tabBar.tabBarItemArray = self.tabBarItemArray;
    
    [self.tabBar addSubview:tabBar];
}

#pragma mark - 删除系统的Tabbar
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    for (UIView *view in self.tabBar.subviews) {
        
        if (![view isKindOfClass:[CYLTabBar class]]) {
            
            [view removeFromSuperview];
        }
    }
}

- (void)setUpAllViewContoller
{
    CYLMainViewController *mainVC = [[CYLMainViewController alloc] init];
    [self setUpOneViewController:mainVC withImage:[UIImage imageNamed:@"house"] selectedImage:[UIImage imageNamed:@"sel_house"] andTitle:@"首页"];
    
    CYLSearchViewController *searchVC = [[CYLSearchViewController alloc] init];
    [self setUpOneViewController:searchVC withImage:[UIImage imageNamed:@"searching"] selectedImage:[UIImage imageNamed:@"sel_searching"] andTitle:@"搜索"];
    
    CYLDrawViewController *drawVC = [[CYLDrawViewController alloc] init];
    [self setUpOneViewController:drawVC withImage:[UIImage imageNamed:@"drawing"] selectedImage:[UIImage imageNamed:@"sel_draw"] andTitle:@"绘制"];
    
    CYLMineViewController *mineVC = [[CYLMineViewController alloc] init];
    [self setUpOneViewController:mineVC withImage:[UIImage imageNamed:@"user"] selectedImage:[UIImage imageNamed:@"sel_user"] andTitle:@"用户"];
    
}


- (void)setUpOneViewController:(UIViewController*)viewController withImage:(UIImage*)image selectedImage:(UIImage *)selectedImage andTitle:(NSString*)title
{
    CYLNaviViewController *navVC = [[CYLNaviViewController alloc] initWithRootViewController:viewController];
    
    viewController.title = title;
    
    navVC.tabBarItem.selectedImage = selectedImage;
    navVC.tabBarItem.image = image;
    navVC.tabBarItem.title = title;
    
    [self.tabBarItemArray addObject:navVC.tabBarItem];
    
    [self addChildViewController:navVC];
}

#pragma mark - CYLTabBarDelegate
- (void)tabBar:(CYLTabBar *)tabBar DidClickButton:(UIButton *)button
{
    
    self.selectedIndex = button.tag;
    
    
}

#pragma mark - 懒加载
- (NSMutableArray *)tabBarItemArray
{
    if (_tabBarItemArray == nil) {
        _tabBarItemArray = [NSMutableArray array];
    }
    return _tabBarItemArray;
}




@end
