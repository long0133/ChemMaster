//
//  CYLHightLightModel.m
//  ChemMaster
//
//  Created by GARY on 16/6/14.
//  Copyright © 2016年 GARY. All rights reserved.
//

#import "CYLHightLightModel.h"

@implementation CYLHightLightModel

+(NSArray *)highLightModelArray
{
    CYLHightLightModel *acs = [self modelWithImage:[UIImage imageCompressForSize:[UIImage imageNamed:@"acs"] targetSize:CGSizeMake(150, 150)] andName:@"acs"];
    
     CYLHightLightModel *wiley = [self modelWithImage:[UIImage imageCompressForSize:[UIImage imageNamed:@"wiley"] targetSize:CGSizeMake(150, 150)] andName:@"wiley"];
    
     CYLHightLightModel *rsc = [self modelWithImage:[UIImage imageCompressForSize:[UIImage imageNamed:@"rsc"] targetSize:CGSizeMake(150, 150)] andName:@"rsc"];
    
    NSArray *modelArray = @[acs,wiley,rsc];
    
    return modelArray;
}


+ (instancetype)modelWithImage:(UIImage*)image andName:(NSString*)name
{
    CYLHightLightModel *model = [[CYLHightLightModel alloc] init];
    
    model.img = image;
    
    model.journalName = name;
    
    return model;
}
@end
