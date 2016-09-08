//
//  CYLTools.h
//  ChemMaster
//
//  Created by GARY on 16/9/7.
//  Copyright © 2016年 GARY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CYLTools : NSObject

//将set转化为array
+ (NSArray*)arrayFromSet:(NSSet*)set;
+ (NSMutableArray*)mutableArrayFromSet:(NSSet*)set;

@end
