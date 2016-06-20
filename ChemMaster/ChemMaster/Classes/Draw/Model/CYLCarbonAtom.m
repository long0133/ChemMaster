//
//  CYLCarbonAtom.m
//  ChemMaster
//
//  Created by GARY on 16/6/19.
//  Copyright © 2016年 GARY. All rights reserved.
//

#import "CYLCarbonAtom.h"

@implementation CYLCarbonAtom

- (instancetype)init
{
    if (self = [super init]) {
    
        self.attachBondNum = 1;
        self.maxBond = 4;
    }
    
    return self;
}

@end
