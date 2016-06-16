//
//  CYLWebViewController.h
//  ChemMaster
//
//  Created by GARY on 16/6/15.
//  Copyright © 2016年 GARY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CYLWebViewController : UIViewController
@property (nonatomic, strong) NSURL *url;


+ (instancetype)initWithURL:(NSURL*)url;

@end
