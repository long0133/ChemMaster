//
//  CYLTotalSynDetailViewController.m
//  ChemMaster
//
//  Created by GARY on 16/6/22.
//  Copyright © 2016年 GARY. All rights reserved.
//

#import "CYLTotalSynDetailViewController.h"
#import "CYLReactionDetailViewController.h"
//存储在cache中的后缀
#define fileNameForDetailVieSulffix @"ATotalSynthesis"
@interface CYLTotalSynDetailViewController ()

@property (nonatomic, strong) NSArray *detailListArray;

@end
static NSString *reuse = @"totalSyn";
@implementation CYLTotalSynDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.rowHeight = 44;
}

#pragma mark - data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.detailListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuse];
        
    }
    
    NSDictionary *model = self.detailListArray[indexPath.row];
    
    cell.textLabel.text = model[TakeName];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Year:%@   Author:%@", model[TakeYear], model[TakeAuthor]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [SVProgressHUD show];
    
    NSString *urlString = self.detailListArray[indexPath.row][Takelink];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSString *urlSet = [urlString stringByDeletingLastPathComponent];
    urlSet = [NSString stringWithFormat:@"%@/",urlSet];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        CYLReactionDetailViewController *DetailVC = [CYLReactionDetailViewController DetailViewControllerWithURL:url andUrlSetString:urlSet];
        DetailVC.title = [self.detailListArray[indexPath.row][TakeName] stringByAppendingString:fileNameForDetailVieSulffix];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [SVProgressHUD dismiss];
            [self.navigationController presentViewController:DetailVC animated:YES completion:nil];
        });
    });
    
}

#pragma mark - 懒加载
- (NSArray *)detailListArray
{
    if (_detailListArray == nil) {
        _detailListArray = [NSArray array];
    }
    return _detailListArray;
}


+ (instancetype)detaileViewWithArray:(NSArray *)listArray
{
    CYLTotalSynDetailViewController *detailVC = [[CYLTotalSynDetailViewController alloc] initWithStyle:UITableViewStylePlain];
    
    detailVC.detailListArray = listArray;
    
    return detailVC;
}
@end
