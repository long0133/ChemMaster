//
//  CYLEditorChociseModel.m
//  ChemMaster
//
//  Created by GARY on 16/6/13.
//  Copyright © 2016年 GARY. All rights reserved.
//

#import "CYLEditorChociseModel.h"
#import <MJExtension.h>

//将显示多少推荐model
#define NewEditorChoiceCount 7

@implementation CYLEditorChociseModel

+ (NSMutableArray *)modelArray
{
    NSMutableArray *modelArray = [NSMutableArray array];
    
    //获取历史推荐库
    NSData *pathData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://pubs.acs.org/editorschoice/manuscripts.json?format=lite"]];
    NSArray *dataArray = [NSJSONSerialization JSONObjectWithData:pathData options:kNilOptions error:nil];
    
    //从历史推荐库中取出本期推荐model
    NSMutableArray *editorArray = [NSMutableArray array];
    
    for (NSUInteger i = 0; i < NewEditorChoiceCount; i ++) {
        
        [editorArray addObject:dataArray[i]];
    }
    
    //拼接路径
    NSString *URL = [self subPathWithModelArray:editorArray];
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:URL]];
    
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    modelArray = [CYLEditorChociseModel mj_objectArrayWithKeyValuesArray:array];
    return modelArray;
}


/**
 *  获取正确的路径
 *
 *  @param array 在历史存储数据中取出本期的推荐model
 */
+ (NSString*)subPathWithModelArray:(NSArray*)array
{
    NSMutableString *URL = [[NSMutableString alloc] initWithString:@"http://pubs.acs.org/editorschoice/manuscripts.json?find=ByDoiEquals"];
    
    for (NSInteger i = 0; i < array.count; i ++) {
        
        NSString *doi = array[i][@"doi"];
        
        doi = [doi stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"];
        
        NSString *subString = [NSString stringWithFormat:@"&doi%%5B%%5D=%@",doi];
        
        [URL appendString:subString];
        
    }
    
    return URL;
}

@end
