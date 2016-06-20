//
//  CYLCarbonAtom.h
//  ChemMaster
//
//  Created by GARY on 16/6/19.
//  Copyright © 2016年 GARY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CYLCarbonAtom : NSObject

@property (nonatomic, assign) NSInteger attachBondNum;
@property (nonatomic, assign) NSInteger maxBond;

//原子所在位置为线段的端点
@property (nonatomic, assign) CGPoint atomPoint;

@end
