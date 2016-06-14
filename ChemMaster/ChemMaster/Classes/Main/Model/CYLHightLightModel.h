//
//  CYLHightLightModel.h
//  ChemMaster
//
//  Created by GARY on 16/6/14.
//  Copyright © 2016年 GARY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CYLHightLightModel : NSObject
/**img*/
@property (nonatomic ,strong) UIImage *img;

/**name*/
@property (nonatomic ,copy) NSString *journalName;

+ (NSArray*)highLightModelArray;
@end
