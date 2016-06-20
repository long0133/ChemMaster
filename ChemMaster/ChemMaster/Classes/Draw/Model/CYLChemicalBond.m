//
//  CYLChemicalBond.m
//  ChemMaster
//
//  Created by GARY on 16/6/19.
//  Copyright © 2016年 GARY. All rights reserved.
//

#import "CYLChemicalBond.h"

@interface CYLChemicalBond ()

@end

@implementation CYLChemicalBond

+ (instancetype)CreatChemicalBondWithCarbon
{
    CYLChemicalBond *chemBond = [[CYLChemicalBond alloc] init];
    
    //初始化ChemicalBond
    chemBond.startP = CGPointZero;
    chemBond.endP = CGPointZero;
    
    chemBond.AttachPoint = CGPointZero;
    chemBond.bondPath = NULL;
    
    chemBond.Atom = [[CYLCarbonAtom alloc] init];
    chemBond.Atom.attachBondNum = 1;

    chemBond.Atom.atomPoint = chemBond.endP;
    
    return chemBond;
}


@end
