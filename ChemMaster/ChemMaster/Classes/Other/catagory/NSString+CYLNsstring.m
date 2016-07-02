//
//  NSString+CYLNsstring.m
//  ChemMaster
//
//  Created by GARY on 16/6/22.
//  Copyright © 2016年 GARY. All rights reserved.
//

#import "NSString+CYLNsstring.h"

@implementation NSString (CYLNsstring)


//去除html所有标签
- (NSString *)flattenHTML:(NSString *)html trimWhiteSpace:(BOOL)trim
{
    NSScanner *theScanner = [NSScanner scannerWithString:html];
    NSString *text = nil;
    
    while ([theScanner isAtEnd] == NO) {
        // find start of tag
        [theScanner scanUpToString:@"<" intoString:NULL] ;
        // find end of tag
        [theScanner scanUpToString:@">" intoString:&text] ;
        // replace the found tag with a space
        //(you can filter multi-spaces out later if you wish)
        html = [html stringByReplacingOccurrencesOfString:
                [ NSString stringWithFormat:@"%@>", text]
                                               withString:@""];
    }
    
    return trim ? [html stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] : html;
}

+ (NSDate *)dateFromString:(NSString *)string WithDateFormat:(NSString *)dateFormat
{
    //需要转换的字符串
    NSString *dateString = string;
    //设置转换格式
    NSDateFormatter*formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:dateFormat];
    //NSString转NSDate
    NSDate*date=[formatter dateFromString:dateString];
    return date;
}

+ (NSString *)stringFromDate:(NSDate *)date WithDateFormat:(NSString *)dateFormat
{

    //用于格式化NSDate对象
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    //设置格式：zzz表示时区
    [dateFormatter setDateFormat:dateFormat];
    //NSDate转NSString
    NSString *currentDateString=[dateFormatter stringFromDate:date];
    //输出currentDateString
    return currentDateString;
}
@end
