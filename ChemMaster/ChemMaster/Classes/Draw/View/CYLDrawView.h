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
@property (nonatomic, assign) BOOL isToSelect;
@property (nonatomic, assign) BOOL isDraw;
@property (nonatomic, assign) BOOL isGoDoubleBond;
@property (nonatomic, assign) BOOL isGoTrinpleBond;

@end
