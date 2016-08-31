//
//  CYLDrawView.h
//  ChemMaster
//
//  Created by GARY on 16/6/18.
//  Copyright © 2016年 GARY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CYLToolBarView.h"
#import "CYLChemicalBond.h"

@protocol CYLDrawViewDelegate <NSObject>

- (void)DrawViewShowAlertControllerWithSaveArray:(NSMutableArray*)array;

@end

@interface CYLDrawView : UIView

@property (nonatomic, strong) CYLToolBarView *tooBarView;

/*设置bool值便于控制多重手势*/
//是否想用选中功能
@property (nonatomic, assign) BOOL isToSelect;
//是否想绘制基本碳骨架
@property (nonatomic, assign) BOOL isDraw;
//是否想变单键为双键
@property (nonatomic, assign) BOOL isGoDoubleBond;
//是否想变单键为三键
@property (nonatomic, assign) BOOL isGoTrinpleBond;
//是否要撤销
@property (nonatomic, assign) BOOL isRedo;
//是否clear
@property (nonatomic, assign) BOOL isClear;
//显示出其他原子的界面
@property (nonatomic,assign) BOOL isShowOtherAtom;
//是否选中的其他原子
@property (nonatomic, assign) BOOL isChoseOneAtom;
//选中的原子
@property (nonatomic, strong) NSString *atomName;
@property (nonatomic, strong) UIColor *atomColor;

@property (nonatomic, strong) id<CYLDrawViewDelegate> delegate;
@end
