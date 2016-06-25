//
//  CYLTripleBond.h
//  ChemMaster
//
//  Created by GARY on 16/6/25.
//  Copyright © 2016年 GARY. All rights reserved.
//

#import "CYLChemicalBond.h"

@interface CYLTripleBond : CYLChemicalBond
@property (nonatomic, strong) UIBezierPath *bezierPathTwo;

@property (nonatomic, assign) CGPoint startPTwo;
@property (nonatomic, assign) CGPoint endPTwo;

@property (nonatomic, strong) UIBezierPath *bezierPathThree;

@property (nonatomic, assign) CGPoint startPThree;
@property (nonatomic, assign) CGPoint endPThree;
@end
