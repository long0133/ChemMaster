//
//  CYLReactionDetailViewController.h
//  ChemMaster
//
//  Created by GARY on 16/6/16.
//  Copyright © 2016年 GARY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CYLDetailModel.h"
@interface CYLReactionDetailViewController : UIViewController
@property (nonatomic , strong) CYLDetailModel *detailModel;

+ (instancetype)DetailViewControllerWithDetailModel:(CYLDetailModel*)model;
+ (instancetype)DetailViewControllerWithURL:(NSURL *)url andUrlSetString:(NSString*)urlsetString;
+ (instancetype)DetailViewControllerWithContentArray:(NSArray*)contentArray;
@end
