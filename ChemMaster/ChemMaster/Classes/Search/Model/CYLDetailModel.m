//
//  CYLDetailModel.m
//  ChemMaster
//
//  Created by GARY on 16/6/16.
//  Copyright © 2016年 GARY. All rights reserved.
//

#import "CYLDetailModel.h"

@implementation CYLDetailModel

- (NSMutableArray *)RRURL_stringArray
{
    if (_RRURL_stringArray == nil) {
        _RRURL_stringArray = [NSMutableArray array];
    }
    return _RRURL_stringArray;
}

- (NSMutableArray *)contentArray
{
    if (_contentArray == nil) {
        _contentArray = [NSMutableArray array];
    }
    return _contentArray;
}
@end
