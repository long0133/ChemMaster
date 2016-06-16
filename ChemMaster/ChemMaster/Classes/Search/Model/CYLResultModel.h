//
//  CYLResultModel.h
//  ChemMaster
//
//  Created by GARY on 16/6/15.
//  Copyright © 2016年 GARY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CYLResultModel : NSObject
@property (nonatomic, assign) BOOL isNameReaction;

@property (nonatomic, strong) NSString *urlString;

/**name*/
@property (nonatomic ,copy) NSString *resultName;
@end
