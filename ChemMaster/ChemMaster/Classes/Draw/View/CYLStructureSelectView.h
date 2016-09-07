//
//  CYLStructureSelectView.h
//  ChemMaster
//
//  Created by GARY on 16/9/6.
//  Copyright © 2016年 GARY. All rights reserved.
//

/**
 *  从cache中读取分子结构的Data，并显示PreView
 */
#import <UIKit/UIKit.h>

@interface CYLStructureSelectView : UITableView

@property (nonatomic, assign) BOOL isShow;
@property (nonatomic, strong) NSMutableArray *ModelArray;

+ (instancetype)SetUpStructureSelectViewWithModelArray:(NSMutableArray*)modelArray;

@end
