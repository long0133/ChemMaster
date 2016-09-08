//
//  CYLTools.m
//  ChemMaster
//
//  Created by GARY on 16/9/7.
//  Copyright © 2016年 GARY. All rights reserved.
//

#import "CYLTools.h"

@implementation CYLTools

+ (NSArray *)arrayFromSet:(NSSet *)set
{
    NSMutableArray *array = [NSMutableArray array];
    
    for (id obj in set) {
        [array addObject:obj];
    }
    
    return array;
}

+ (NSMutableArray *)mutableArrayFromSet:(NSSet *)set
{
    NSMutableArray *array = [NSMutableArray array];
    
    for (id obj in set) {
        [array addObject:obj];
    }
    
    return array;
}

@end
