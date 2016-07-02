//
//  NSString+CYLNsstring.h
//  ChemMaster
//
//  Created by GARY on 16/6/22.
//  Copyright © 2016年 GARY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CYLNsstring)

- (NSString *)flattenHTML:(NSString *)html trimWhiteSpace:(BOOL)trim;

+ (NSDate*)dateFromString:(NSString*)string WithDateFormat:(NSString*)dateFormat;

+ (NSString*)stringFromDate:(NSDate*)date WithDateFormat:(NSString*)dateFormat;
@end
