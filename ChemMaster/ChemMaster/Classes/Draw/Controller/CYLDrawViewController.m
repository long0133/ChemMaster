//
//  CYLDrawViewController.m
//  ChemMaster
//
//  Created by GARY on 16/6/12.
//  Copyright © 2016年 GARY. All rights reserved.
//

#import "CYLDrawViewController.h"
#import "CYLDrawView.h"
@interface CYLDrawViewController ()

@end

@implementation CYLDrawViewController

- (void)loadView
{
    self.view = [[CYLDrawView alloc] initWithFrame:[UIScreen mainScreen].bounds];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

@end
