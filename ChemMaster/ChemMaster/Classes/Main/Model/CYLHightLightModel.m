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
    CYLHightLightModel *acs = [self modelWithImage:[UIImage imageNamed:@"acs"] andName:@"acs"];
    
     CYLHightLightModel *wiley = [self modelWithImage:[UIImage imageNamed:@"wiley"] andName:@"wiley"];
    
     CYLHightLightModel *rsc = [self modelWithImage:[UIImage imageNamed:@"RSC"] andName:@"rsc"];
    
//    CYLHightLightModel *scifinder = [self modelWithImage:[UIImage imageNamed:@"scifinder"] andName:@"scifinder"];
//    
//    CYLHightLightModel *reaxys = [self modelWithImage:[UIImage imageNamed:@"reaxys"] andName:@"reaxys"];
    
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
