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
    
    cell.textLabel.textColor = [UIColor grayColor];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - 点击相应结果，发送请求 解析相应 包装成模型 显示在detailView
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [SVProgressHUD show];
    tableView.allowsSelection = NO;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        //cell的模型
        CYLResultModel *cellModel = self.resultArray[indexPath.row];
        
        //detail的模型
        CYLDetailModel *detailModel = [[CYLDetailModel alloc] init];
        
        //解析html
        NSData *htmlData = [NSData dataWithContentsOfURL:[NSURL URLWithString:cellModel.urlString]];
        
        TFHpple *parser = [[TFHpple alloc] initWithHTMLData:htmlData];
        
        
        //获得更对信息 以及相关反应内容
        NSArray *array = [parser searchWithXPathQuery:@"//div[@id='references']"];
        for (TFHppleElement *element in array) {
            //获取更多信息的链接
            NSString *FutherMoreSubUrl = [element.firstChild.children[3] objectForKey:@"href"];
            
            detailModel.FIURL_string = [NSString stringWithFormat:@"http://www.organic-chemistry.org%@",FutherMoreSubUrl];
            
            for (TFHppleElement *subElement in [element.children[1] children]) {
                
                //获取相关反应的链接
                NSString *RRURL = [subElement objectForKey:@"href"];
                
                if (RRURL != NULL) {
                    NSString *fullPath = [NSString stringWithFormat:@"http://www.organic-chemistry.org/namedreactions/%@", [subElement objectForKey:@"href"]];
                    
                    [detailModel.RRURL_stringArray addObject:fullPath];
                }
            }
        }
        
        //获得概述内容
        NSArray *pElements = [parser searchWithXPathQuery:@"//p"];
        
        for (TFHppleElement *pElement in pElements) {
            
            NSString *raw = [pElement.raw stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
            raw = [raw stringByReplacingOccurrencesOfString:@"</p>" withString:@""];
            raw = [raw stringByReplacingOccurrencesOfString:@"<b>" withString:@""];
            raw = [raw stringByReplacingOccurrencesOfString:@"</b>" withString:@""];
            raw = [raw stringByReplacingOccurrencesOfString:@"<br/>" withString:@" "];
            raw = [raw stringByReplacingOccurrencesOfString:@"&#13" withString:@""];
            
            if (raw != NULL) {
                [detailModel.contentArray addObject:raw];
            }
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //弹出内容显示界面
            CYLReactionDetailViewController *RVC = [CYLReactionDetailViewController DetailViewControllerWithDetailModel:detailModel];
            [self.navigationController presentViewController:RVC animated:YES completion:^{
            }];
            
            [SVProgressHUD dismiss];
            tableView.allowsSelection = YES;
            
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
