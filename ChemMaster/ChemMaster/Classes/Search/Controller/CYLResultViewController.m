//
//  CYLResultViewController.m
//  ChemMaster
//
//  Created by GARY on 16/6/15.
//  Copyright © 2016年 GARY. All rights reserved.
//

#import "CYLResultViewController.h"
#import "CYLResultModel.h"
#import "CYLDetailModel.h"
#import "CYLReactionDetailViewController.h"
#import <SVProgressHUD.h>
#import <TFHpple.h>
@interface CYLResultViewController ()

@property (nonatomic, strong) NSArray *resultArray;
@property (nonatomic, strong) NSData *htmlData;
@end

static NSString *ID = @"cell";
@implementation CYLResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ID];
}

+ (instancetype)ResultViewControllerWithResultArray:(NSArray*)array andHtmlData:(NSData*)data;
{
    CYLResultViewController *resultVC = [[CYLResultViewController alloc] init];
    resultVC.htmlData = data;
    resultVC.resultArray = array;
    return resultVC;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.resultArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    
    cell.textLabel.text = [self.resultArray[indexPath.row] resultName];
    
    cell.textLabel.textColor = [UIColor blackColor];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - 点击相应结果，发送请求 解析相应 包装成模型 显示在detailView
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [SVProgressHUD show];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        //cell的模型
        CYLResultModel *cellModel = self.resultArray[indexPath.row];
        
        CYLReactionDetailViewController *RVC = [CYLReactionDetailViewController DetailViewControllerWithURL:[NSURL URLWithString:cellModel.urlString] andUrlSetString:@"http://www.organic-chemistry.org/namedreactions/"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //弹出内容显示界面
            [self.navigationController presentViewController:RVC animated:YES completion:^{
            }];
            
            [SVProgressHUD dismiss];
            
        });
  
    });
  
}

//header
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *header = [[UILabel alloc] init];
    header.text = @"Search Resoult:";
    header.font = [UIFont systemFontOfSize:14];
    header.backgroundColor = [UIColor blackColor];
    header.alpha = 0.8;
    header.textColor = [UIColor whiteColor];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

-(BOOL)prefersStatusBarHidden
{
    return  YES;
}
@end
