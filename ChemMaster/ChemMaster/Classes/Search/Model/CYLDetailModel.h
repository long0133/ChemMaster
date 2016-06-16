//
//  CYLDetailModel.h
//  ChemMaster
//
//  Created by GARY on 16/6/16.
//  Copyright © 2016年 GARY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CYLDetailModel : NSObject

/**Further Information urlstring*/
@property (nonatomic ,copy) NSString *FIURL_string;

/**related reaction urlseting array*/
@property (nonatomic, strong) NSMutableArray *RRURL_stringArray;

@property (nonatomic, strong) NSMutableArray *contentArray;

@end
