//
//  CYLMineViewController.m
//  ChemMaster
//
//  Created by GARY on 16/7/4.
//  Copyright © 2016年 GARY. All rights reserved.
//

#import "CYLMineViewController.h"
#import "CYLShowSaveFileController.h"

@interface CYLMineViewController ()

@end

@implementation CYLMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    self.tableView.bounces = NO;
    
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
//    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    if (indexPath.section == 0) {
        cell.imageView.image = [UIImage imageNamed:@"laboratory-icon"];
        cell.textLabel.text = @"我的反应";
    }
    else if ( indexPath.section == 1)
    {
        cell.imageView.image = [UIImage imageNamed:@"molecule_47.031440638198px_1199723_easyicon.net"];
        cell.textLabel.text = @"我的全合成";
    }
    else
    {
        cell.imageView.image = [UIImage imageNamed:@"3D-Experiments-icon"];
        cell.textLabel.text = @"我的收藏";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *subPath = [NSArray array];
    subPath = [fileManager subpathsAtPath:cachePath];
    
    NSMutableArray *PathContentArray = [NSMutableArray array];
    
    if (indexPath.section == 0)
    {
        for (NSString *sub in subPath) {
            
            if ([sub containsString:NameReactionCategory]) {
                
                [PathContentArray addObject:[cachePath stringByAppendingPathComponent:sub]];
            }
            
        }
         
    }
    else if (indexPath.section == 1)
    {
        for (NSString *sub in subPath) {
            
            if ([sub containsString:TotalSynthesisCategory]) {
                
                [PathContentArray addObject:[cachePath stringByAppendingPathComponent:sub]];
            }
            
        }
    }
    else
    {
        for (NSString *sub in subPath) {
            
            if ([sub containsString:HightLightCategory]) {
                
                [PathContentArray addObject:[cachePath stringByAppendingPathComponent:sub]];
            }
            
        }
    }
    
    CYLShowSaveFileController *showVC = [CYLShowSaveFileController showSaveFileWithContentPathArray:PathContentArray];
    
    [self.navigationController pushViewController:showVC animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImageView *imageView = [[UIImageView alloc] init];
    if (section == 0) {
        imageView.image = [UIImage imageNamed:@"logo2"];
    }
    return imageView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 75;
    }
    return 20;
}

@end
