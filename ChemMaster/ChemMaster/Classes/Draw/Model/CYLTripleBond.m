//
//  CYLTripleBond.m
//  ChemMaster
//
//  Created by GARY on 16/6/25.
//  Copyright © 2016年 GARY. All rights reserved.
//

#import "CYLTripleBond.h"

@implementation CYLTripleBond

+ (instancetype)CreatChemicalBondWithCarbon
{
    CYLTripleBond *chemBond = [[CYLTripleBond alloc] init];
    
    //初始化ChemicalBond
    chemBond.startP = CGPointZero;
    chemBond.endP = CGPointZero;
    chemBond.startPTwo = CGPointZero;
    chemBond.endPTwo = CGPointZero;
    chemBond.startPThree = CGPointZero;
    chemBond.endPThree = CGPointZero;
    
    chemBond.AttachPoint = CGPointZero;
    chemBond.bondPath = NULL;
    
    chemBond.Atom = [[CYLCarbonAtom alloc] init];
    chemBond.Atom.attachBondNum = 1;
    
    chemBond.Atom.atomPoint = chemBond.endP;
    
    return chemBond;
}

@end
