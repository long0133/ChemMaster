//
//  CYLSpecificResourceViewController.h
//  ChemMaster
//
//  Created by GARY on 16/6/24.
//  Copyright © 2016年 GARY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CYLSpecificResourceViewController : UITableViewController

//+ (instancetype)SpecificResourceViewControllerWithUrl:(NSURL*)url;

+ (instancetype)SpecificResourceViewControllerWithUrl:(NSURL*)url withTitle:(NSString*)title;

@end
