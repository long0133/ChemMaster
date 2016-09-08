//
//  CYLButton.m
//  ChemMaster
//
//  Created by GARY on 16/9/8.
//  Copyright © 2016年 GARY. All rights reserved.
//

#import "CYLButton.h"

#define BtnOrigin @"originPoint"
#define BtnSize @"size"
#define BtnName @"name"
#define BtnColor @"color"

@implementation CYLButton

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        
        self.BtnPoint = [(NSValue*)[aDecoder decodeObjectForKey:BtnOrigin] CGPointValue];
        self.Size = [[aDecoder decodeObjectForKey:BtnSize] CGSizeValue];
        self.atomName = [aDecoder decodeObjectForKey:BtnName];
        self.atomColor = [aDecoder decodeObjectForKey:BtnColor];
    }
    return self;
}


- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:[NSValue valueWithCGPoint:self.frame.origin] forKey:BtnOrigin];
    [aCoder encodeObject:[NSValue valueWithCGSize:self.frame.size] forKey:BtnSize];
    [aCoder encodeObject:self.currentTitle forKey:BtnName];
    [aCoder encodeObject:self.currentTitleColor forKey:BtnColor];
}
@end
