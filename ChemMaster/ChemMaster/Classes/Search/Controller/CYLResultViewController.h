//
//  CYLResultViewController.h
//  ChemMaster
//
//  Created by GARY on 16/6/15.
//  Copyright © 2016年 GARY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CYLResultViewController : UITableViewController

+ (instancetype)ResultViewControllerWithResultArray:(NSArray*)array andHtmlData:(NSData*)data;
@end
