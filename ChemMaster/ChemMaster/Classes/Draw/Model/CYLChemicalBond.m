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
    chemBond.midPoint = CGPointZero;
    
    chemBond.AttachPoint = CGPointZero;
    chemBond.bondPath = NULL;
    
    chemBond.Atom = [[CYLCarbonAtom alloc] init];
    chemBond.Atom.attachBondNum = 1;

    chemBond.Atom.atomPoint = chemBond.endP;
    
    return chemBond;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    if (self = [super init]) {
        
        self.startP = [(NSValue*)[coder decodeObjectForKey:startPointDV] CGPointValue];
        self.endP = [(NSValue*)[coder decodeObjectForKey:endPointDV] CGPointValue];
        self.BondClass = [coder decodeObjectForKey:bondClassDV];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:[NSValue valueWithCGPoint:self.startP] forKey:startPointDV];
    [coder encodeObject:[NSValue valueWithCGPoint:self.endP] forKey:endPointDV];
    [coder encodeObject:self.BondClass forKey:bondClassDV];
}


@end
