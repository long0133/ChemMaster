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
//cache文件后缀
#define fileNamesulffix @"topicModelArchiveDataArray"

@implementation CYLEditorChociseModel

+ (NSMutableArray *)modelArray
{
    NSMutableArray *modelArray = [NSMutableArray array];
    NSMutableArray *archiveDataArray = [NSMutableArray array];
    
    //取出缓存data的数组文件
    NSFileManager *mgr = [NSFileManager defaultManager];
    
    NSArray *subPathArray = [mgr subpathsAtPath:cachePath];
    
    for (NSString *subPathString in subPathArray) {
        
        //当缓存中有缓存data时
        if ([subPathString containsString:fileNamesulffix]) {
            
            NSString *dateString = [subPathString stringByReplacingOccurrencesOfString:fileNamesulffix withString:@""];
            
            NSDate *shouldReLoadDate = [NSString dateFromString:dateString WithDateFormat:dateFormatString];
            
            if ([currentDate compare:shouldReLoadDate] == NSOrderedDescending || NSOrderedSame) {
                //若是目前的date超过了预定的reloaddate则重新下载
                archiveDataArray = [self downLoadArchiveDataArrayToCache];
                
                modelArray = [self modelArrayFromArchiveDataArray:archiveDataArray];
            }
            else
            {
                //未到reload日期 则直接取出cache中的文件转为modelarray
                archiveDataArray = [NSMutableArray arrayWithContentsOfFile:[cachePath stringByAppendingPathComponent:subPathString]];
                modelArray = [self modelArrayFromArchiveDataArray:archiveDataArray];
            }
            
        }
        
    }
    
    //若是cache中无缓存文件则下载
    if (modelArray.count == 0) {
        
        archiveDataArray = [self downLoadArchiveDataArrayToCache];
        
        modelArray = [self modelArrayFromArchiveDataArray:archiveDataArray];
        
    }
    
    return modelArray;
}

/**
 *  下载data转成且归档成为自定义模型的archivDataArray存储在cache中
 *
 *  @return
 */
+ (NSMutableArray*)downLoadArchiveDataArrayToCache
{
    NSMutableArray *archiveDataArray = [NSMutableArray array];
    
    //获取历史推荐库
    NSData *pathData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://pubs.acs.org/editorschoice/manuscripts.json?format=lite"]];
    NSArray *dataArray = [NSJSONSerialization JSONObjectWithData:pathData options:kNilOptions error:nil];
    
    //从历史推荐库中取出本期推荐model
    NSMutableArray *editorArray = [NSMutableArray array];
    
    for (NSUInteger i = 0; i < NewEditorChoiceCount; i ++) {
        
        [editorArray addObject:dataArray[i]];
    }
    
    //拼接路径
    NSString *URL = [CYLEditorChociseModel subPathWithModelArray:editorArray];
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:URL]];
    
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
   NSMutableArray *modelArray = [CYLEditorChociseModel mj_objectArrayWithKeyValuesArray:array];
    
    /******************************将自定义模型转化成data便于存储******************************/
    for (CYLEditorChociseModel *model in modelArray) {
        
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
        
        [archiveDataArray addObject:data];
    }
    
    //移除原有的文件
    NSArray *subA = [fileManager subpathsAtPath:cachePath];
    
    for (NSString *sub in subA) {
        
        if ([sub containsString:fileNamesulffix]) {
            [fileManager removeItemAtPath:[cachePath stringByAppendingPathComponent:sub] error:nil];
        }
    }
    
    //偏移一定时间作为文件名
    NSDate *fileNameDate = [NSDate dateWithTimeInterval:secondsOfTwoDay sinceDate:currentDate];
    
    NSString *fileName = [NSString stringFromDate:fileNameDate WithDateFormat:dateFormatString];
    fileName = [fileName stringByAppendingString:fileNamesulffix];
    
    NSString *filePath = [cachePath stringByAppendingPathComponent:fileName];
    
    [archiveDataArray writeToFile:filePath atomically:YES];
    
    return archiveDataArray;
}

//解档并转成模型数组
+ (NSMutableArray*)modelArrayFromArchiveDataArray:(NSMutableArray*)archiveArray
{
    NSMutableArray *modelArray = [NSMutableArray array];
    
    for (NSData *data in archiveArray) {
        
        CYLEditorChociseModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        [modelArray addObject:model];
    }
    
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




#pragma mark - NSCoding
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init] ) {
        
        self.authors = [aDecoder decodeObjectForKey:@"auther"];
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.articleAbstract = [aDecoder decodeObjectForKey:@"articleAbstract"];
        self.doi = [aDecoder decodeObjectForKey:@"doi"];
        self.journal = [aDecoder decodeObjectForKey:@"journal"];
        self.tocGraphics = [aDecoder decodeObjectForKey:@"tocGraphics"];
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.authors forKey:@"auther"];
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.articleAbstract forKey:@"articleAbstract"];
    [aCoder encodeObject:self.doi forKey:@"doi"];
    [aCoder encodeObject:self.journal forKey:@"journal"];
    [aCoder encodeObject:self.tocGraphics forKey:@"tocGraphics"];
}
@end
