//
//  CYLEditorChociseModel.h
//  ChemMaster
//
//  Created by GARY on 16/6/13.
//  Copyright © 2016年 GARY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CYLEditorChociseModel : NSObject
/**authors*/
@property (nonatomic ,copy) NSString *authors;
/**title*/
@property (nonatomic ,copy) NSString *title;
/**abstract*/
@property (nonatomic ,copy) NSString *articleAbstract;
/**doi*/
@property (nonatomic ,copy) NSString *doi;
/**journal*/
@property (nonatomic , strong) NSDictionary *journal;
/**picture  tocGraphics[0] is the url of pic*/
@property (nonatomic, strong) NSArray *tocGraphics;

+ (NSMutableArray*)modelArray;
@end
