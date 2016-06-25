//
//  CYLDrawViewController.m
//  ChemMaster
//
//  Created by GARY on 16/6/12.
//  Copyright © 2016年 GARY. All rights reserved.
//

#import "CYLDrawViewController.h"
#import "CYLDrawView.h"
#import "CYLToolBarView.h"
#import <objc/runtime.h>
@interface CYLDrawViewController ()<CYLToolBarViewDelegate>

@property (nonatomic, strong) CYLDrawView *drawView;

@end

@implementation CYLDrawViewController

- (void)loadView
{
    self.drawView = [[CYLDrawView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.drawView.tooBarView.delegate = self;
    self.view = self.drawView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}



#pragma mark - toolBar delegate
- (void)toolBarDidClickSelectBtn
{
    self.drawView.isGoDoubleBond = NO;
    self.drawView.isGoTrinpleBond = NO;
    self.drawView.isDraw = NO;
    self.drawView.isToSelect = !self.drawView.isToSelect;
}

- (void)toolBarDidClickDrawBtn
{
    self.drawView.isGoDoubleBond = NO;
    self.drawView.isGoTrinpleBond = NO;
    self.drawView.isToSelect = NO;
    self.drawView.isDraw = !self.drawView.isDraw;
}

- (void)toolBarDidClickDoubleBondBtn
{
    self.drawView.isGoTrinpleBond = NO;
    self.drawView.isDraw = NO;
    self.drawView.isToSelect = NO;
    self.drawView.isGoDoubleBond = !self.drawView.isGoDoubleBond;
}

- (void)toolBarDidClickTripleBondBtn
{
    self.drawView.isGoDoubleBond = NO;
    self.drawView.isDraw = NO;
    self.drawView.isToSelect = NO;
    self.drawView.isGoTrinpleBond = !self.drawView.isGoTrinpleBond;
}

@end
