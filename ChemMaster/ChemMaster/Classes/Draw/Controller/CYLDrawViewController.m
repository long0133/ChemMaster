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
@interface CYLDrawViewController ()<CYLToolBarViewDelegate,CYLDrawViewDelegate>

@property (nonatomic, strong) CYLDrawView *drawView;

@end

@implementation CYLDrawViewController

- (void)loadView
{
    self.drawView = [[CYLDrawView alloc] initWithFrame:CGRectMake(0, 55, ScreenW, ScreenH - 44)];
    self.drawView.tooBarView.delegate = self;
    self.drawView.delegate = self;
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

#pragma mark - DrawViewDelegate
/**
 *  点击save时，将弹出alert要求填入存储文件的名称
 *
 *  @param array 存储bond的集合
 */
- (void)DrawViewShowAlertControllerWithSaveArray:(NSMutableArray *)array
{
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"请输入化合物的名字" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    
    [alertC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        textField.placeholder = @"化合物名称";
        
    }];
    
    __block NSString *name = nil;
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        name = alertC.textFields.firstObject.text;
        
        
        if (array.count) {
            
            [array writeToFile:[cachePath stringByAppendingPathComponent:[name stringByAppendingString:DrawViewBondSaveArray]] atomically:YES];
        }
        
    }];
    
    [alertC addAction:action];
    
    [self presentViewController:alertC animated:YES completion:nil];
    
}
@end
