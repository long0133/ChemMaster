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

@end
