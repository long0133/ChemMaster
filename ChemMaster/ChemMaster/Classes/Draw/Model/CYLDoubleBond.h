//
//  CYLDoubleBond.h
//  ChemMaster
//
//  Created by GARY on 16/6/24.
//  Copyright © 2016年 GARY. All rights reserved.
//

#import "CYLChemicalBond.h"

@interface CYLDoubleBond : CYLChemicalBond

@property (nonatomic, strong) UIBezierPath *bezierPathTwo;

@property (nonatomic, assign) CGPoint startPTwo;
@property (nonatomic, assign) CGPoint endPTwo;

@end
