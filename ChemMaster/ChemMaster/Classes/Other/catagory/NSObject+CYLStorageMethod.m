//
//  NSObject+CYLStorageMethod.m
//  ChemMaster
//
//  Created by GARY on 16/6/24.
//  Copyright © 2016年 GARY. All rights reserved.
//

#import "NSObject+CYLStorageMethod.h"

@implementation NSObject (CYLStorageMethod)

//- (void)writeToCache:(id)obj withFileName:(NSString *)fileName
//{
//    NSString *cachepath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
//    
//    NSString *filePath = [cachepath stringByAppendingPathComponent:fileName];
//    
//    [obj writeToFile:filePath options:NSDataWritingAtomic error:nil];
//}
//
//- (NSData *)readFromCache:(NSString *)fileName
//{
//    NSString *cachepath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
//    
//    NSString *filePath = [cachepath stringByAppendingPathComponent:fileName];
//    
//    NSData *data = [NSData dataWithContentsOfFile:filePath];
//    
//    return data;
//}
@end
