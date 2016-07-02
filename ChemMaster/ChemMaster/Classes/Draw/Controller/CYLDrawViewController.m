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
    self.drawView.isChoseOneAtom = NO;
    self.drawView.isToSelect = YES;
}

- (void)toolBarDidClickDrawBtn
{
    self.drawView.isGoDoubleBond = NO;
    self.drawView.isGoTrinpleBond = NO;
    self.drawView.isToSelect = NO;
    self.drawView.isChoseOneAtom = NO;
    self.drawView.isDraw = YES;
}

- (void)toolBarDidClickDoubleBondBtn
{
    self.drawView.isGoTrinpleBond = NO;
    self.drawView.isDraw = NO;
    self.drawView.isToSelect = NO;
    self.drawView.isChoseOneAtom = NO;
    self.drawView.isGoDoubleBond = YES;
}

- (void)toolBarDidClickTripleBondBtn
{
    self.drawView.isGoDoubleBond = NO;
    self.drawView.isDraw = NO;
    self.drawView.isToSelect = NO;
    self.drawView.isChoseOneAtom = NO;
    self.drawView.isGoTrinpleBond = YES;
}

- (void)toolBarDidClickAtomBtnWithAtomName:(NSString *)name withColor:(UIColor *)color
{
    //位置不可以调换
    self.drawView.atomName = name;
    self.drawView.atomColor = color;
    
    self.drawView.isGoDoubleBond = NO;
    self.drawView.isGoTrinpleBond = NO;
    self.drawView.isDraw = NO;
    self.drawView.isToSelect = NO;
    self.drawView.isChoseOneAtom = YES;
}

- (void)toolBarDidClickReDoBtn
{
    self.drawView.isRedo = YES;
}

- (void)toolBarDidClickClearAllBtn
{
    self.drawView.isClear = YES;
}

- (void)toolBarChoseOtherAtom
{
    self.drawView.isShowOtherAtom = !self.drawView.isShowOtherAtom;
}
@end
