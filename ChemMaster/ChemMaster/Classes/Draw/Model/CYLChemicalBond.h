//
//  CYLChemicalBond.h
//  ChemMaster
//
//  Created by GARY on 16/6/19.
//  Copyright © 2016年 GARY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CYLCarbonAtom.h"

@interface CYLChemicalBond : NSObject<NSCoding>

@property (nonatomic, assign) CGMutablePathRef bondPath;
@property (nonatomic, strong) UIBezierPath *bezierPath;

@property (nonatomic, assign) CGPoint startP;
@property (nonatomic, assign) CGPoint endP;
//设置中点便于选中对应的化学键
@property (nonatomic, assign) CGPoint midPoint;

@property (nonatomic, strong) CYLCarbonAtom *Atom;

@property (nonatomic,assign) CGPoint AttachPoint;

//是否与其他键相连
@property (nonatomic, assign) BOOL isAttached;

@property (nonatomic, copy) NSString *BondClass;


+ (instancetype)CreatChemicalBondWithCarbon;

- (instancetype)initWithCoder:(NSCoder *)aDecoder;
- (void)encodeWithCoder:(NSCoder *)aCoder;

@end
