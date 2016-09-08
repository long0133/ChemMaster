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
#import "CYLStructureSelectView.h"
#define SelViewWidth ScreenW * 2 / 3


@interface CYLDrawViewController ()<CYLToolBarViewDelegate,CYLDrawViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) CYLDrawView *drawView;

//隐藏在drawview下，点击读取时显示，选择数据读取进drawView
@property (nonatomic, strong) CYLStructureSelectView *StructureSelectView;

@end

@implementation CYLDrawViewController

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpDrawView];
    [self setUpSelectView];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"读取" style:UIBarButtonItemStyleDone target:self action:@selector(readFromCacheAnimation)];
}

- (void)setUpDrawView
{
    self.drawView = [[CYLDrawView alloc] initWithFrame:CGRectMake(0,0, ScreenW, ScreenH)];
    self.drawView.tooBarView.delegate = self;
    self.drawView.delegate = self;
    [self setShadowForView];
    [self.view addSubview:self.drawView];
    
    //手势
//    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(Pan:)];
//    [self.drawView addGestureRecognizer:pan];
}

//设置SelectView
- (void)setUpSelectView
{
   NSMutableArray *modelArray = [self ModelArrayFromCache];

    self.StructureSelectView = [CYLStructureSelectView SetUpStructureSelectViewWithModelArray:modelArray];
    
    self.StructureSelectView.delegate = self;
    self.StructureSelectView.dataSource = self;
    
    self.StructureSelectView.frame = CGRectMake(0, 0, SelViewWidth, ScreenH);
    
    [self.view insertSubview:self.StructureSelectView belowSubview:self.drawView];
}

/**
 *  从cache中获取具有特定尾缀的data文件
 */
- (NSMutableArray*)ModelArrayFromCache
{
    NSArray *array = [fileManager subpathsAtPath:cachePath];
    
    NSMutableArray *modelArray = [NSMutableArray array];
    
    for (NSString *fileName in array) {
        
        if ([fileName containsString:DrawViewBondSaveArray]) {
            [modelArray addObject:fileName];
        }
    }
    
    return modelArray;
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
- (void)DrawViewShowAlertControllerWithSaveArray:(NSMutableArray *)array andAtomArray:(NSMutableArray *)atomArray
{
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"请输入化合物的名字" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    
    [alertC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        textField.placeholder = @"化合物名称";
        
    }];
    
    __block NSString *name = nil;
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        name = alertC.textFields.firstObject.text;
        
        if (array.count) {
            
            //存储数组写入cache
            [array writeToFile:[cachePath stringByAppendingPathComponent:[name stringByAppendingString:DrawViewBondSaveArray]] atomically:YES];
            [atomArray writeToFile:[cachePath stringByAppendingPathComponent:[name stringByAppendingString:DrawViewAtomSaveArray]] atomically:YES];
            //添加新的内容
            self.StructureSelectView.ModelArray = [self ModelArrayFromCache];
        }
        
    }];
    
    [alertC addAction:action];
    
    [self presentViewController:alertC animated:YES completion:nil];
}

//从cache中读取data转为分子式
- (void)readFromCacheAnimation
{
    if (self.drawView.frame.origin.x == 0) {
        
        [UIView animateWithDuration:.5 animations:^{
            self.drawView.transform = CGAffineTransformMakeTranslation(ScreenW - (ScreenW - SelViewWidth), 0);
        }];
        
    }
    else
    {
        [UIView animateWithDuration:.5 animations:^{
            self.drawView.transform = CGAffineTransformMakeTranslation(0, 0);
        }];
    }
}

- (void)setShadowForView
{
    [self.drawView.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.drawView.layer setShadowOffset:CGSizeMake(-10, 0)];
    [self.drawView.layer setShadowOpacity:0.4];
    [self.drawView.layer setShadowRadius:5];
    
}

#pragma mark - tableview的代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.StructureSelectView.ModelArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuse"];
    }
    
    NSString *name = self.StructureSelectView.ModelArray[indexPath.row];
    
    name = [name stringByReplacingOccurrencesOfString:DrawViewBondSaveArray withString:@""];
    
    cell.textLabel.text = name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *filePathStructure = [cachePath stringByAppendingPathComponent:[cell.textLabel.text stringByAppendingString:DrawViewBondSaveArray]];
    NSString *filePathAtom = [cachePath stringByAppendingPathComponent:[cell.textLabel.text stringByAppendingString:DrawViewAtomSaveArray]];
    
    NSArray *array = [NSArray arrayWithContentsOfFile:filePathStructure];
    NSArray *atomA = [NSArray arrayWithContentsOfFile:filePathAtom];
    
    self.drawView.StructureArray = array;
    self.drawView.AtomUnArchiveArray = atomA;
    
    [self readFromCacheAnimation];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSString *filePathStructure = [cachePath stringByAppendingPathComponent:[cell.textLabel.text stringByAppendingString:DrawViewBondSaveArray]];
    NSString *filePathAtom = [cachePath stringByAppendingPathComponent:[cell.textLabel.text stringByAppendingString:DrawViewAtomSaveArray]];
    
    [fileManager removeItemAtPath:filePathStructure error:nil];
    [fileManager removeItemAtPath:filePathAtom error:nil];
    
    [self.StructureSelectView.ModelArray removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *lable = [[UILabel alloc] init];
    lable.text = @"分子结构";
    lable.alpha = .7;
    lable.textColor = [UIColor whiteColor];
    lable.backgroundColor = [UIColor blackColor];
    return lable;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

@end
