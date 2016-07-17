//
//  CYLDoubleBond.m
//  ChemMaster
//
//  Created by GARY on 16/6/24.
//  Copyright © 2016年 GARY. All rights reserved.
//

#import "CYLDoubleBond.h"

@implementation CYLDoubleBond

+ (instancetype)CreatChemicalBondWithCarbon
{
    CYLDoubleBond *chemBond = [[CYLDoubleBond alloc] init];
    
    //初始化ChemicalBond
    chemBond.startP = CGPointZero;
    chemBond.endP = CGPointZero;
    chemBond.startPTwo = CGPointZero;
    chemBond.endPTwo = CGPointZero;
    
    chemBond.AttachPoint = CGPointZero;
    chemBond.bondPath = NULL;
    
    chemBond.Atom = [[CYLCarbonAtom alloc] init];
    chemBond.Atom.attachBondNum = 1;
    
    chemBond.Atom.atomPoint = chemBond.endP;
    
    chemBond.bondDirectionTag = 0;
    
    return chemBond;
}

@end
