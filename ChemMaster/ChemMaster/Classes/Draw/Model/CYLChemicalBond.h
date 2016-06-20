//
//  CYLChemicalBond.h
//  ChemMaster
//
//  Created by GARY on 16/6/19.
//  Copyright © 2016年 GARY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CYLCarbonAtom.h"

@interface CYLChemicalBond : NSObject

@property (nonatomic, assign) CGMutablePathRef bondPath;
@property (nonatomic, strong) UIBezierPath *bezierPath;

@property (nonatomic, assign) CGPoint startP;
@property (nonatomic, assign) CGPoint endP;

@property (nonatomic, strong) CYLCarbonAtom *Atom;

@property (nonatomic,assign) CGPoint AttachPoint;

//给出建议化学键的方向线段
@property (nonatomic, assign) CGMutablePathRef suggestBondPath;

+ (instancetype)CreatChemicalBondWithCarbon;

@end
