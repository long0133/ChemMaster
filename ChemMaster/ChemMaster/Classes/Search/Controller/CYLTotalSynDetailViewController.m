//
//  CYLTotalSynDetailViewController.m
//  ChemMaster
//
//  Created by GARY on 16/6/22.
//  Copyright © 2016年 GARY. All rights reserved.
//

#import "CYLTotalSynDetailViewController.h"
#import "CYLReactionDetailViewController.h"
#import "CYLDetaileCell.h"
//存储在cache中的后缀
#define fileNameForDetailVieSulffix @"ATotalSynthesis"
@interface CYLTotalSynDetailViewController ()

@property (nonatomic, strong) NSArray *detailListArray;

@property (nonatomic, assign) NSInteger selSection;

@end
static NSString *reuse = @"totalSyn";
@implementation CYLTotalSynDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.detailListArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return self.detailListArray.count;
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CYLDetaileCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    
    if (cell == nil) {
        
        cell = [CYLDetaileCell CellWithModeIdentifier:totalSynList CellStyle:UITableViewCellStyleDefault andCellIdentifier:reuse CellName:nil];
        
    }
    
    NSDictionary *model = self.detailListArray[indexPath.section];
    
//    cell.textLabel.text = model[TakeName];
    
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"Year:%@   Author:%@", model[TakeYear], model[TakeAuthor]];
    
    cell.model = model;
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *headerLable = [[UILabel alloc] init];
    headerLable.numberOfLines = 0;
    headerLable.font = [UIFont systemFontOfSize:14];
    headerLable.textColor = [UIColor blackColor];
    headerLable.backgroundColor = [UIColor getColor:@"F0F0F0"];
    headerLable.tag = section;
    headerLable.userInteractionEnabled = YES;
    [headerLable addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSection:)]];
    

    
    NSDictionary *DictModel = self.detailListArray[section];
    headerLable.text = [NSString stringWithFormat:@"Name:%@\nYear:%@ Author:%@",DictModel[TakeName], DictModel[TakeYear],DictModel[TakeAuthor]];
    
    return headerLable;
}

//点击sectionHeader显示Cell
- (void)tapSection:(UITapGestureRecognizer*)tap
{
    _selSection = tap.view.tag;
    
    [self.tableView reloadData];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *modelDict = self.detailListArray[indexPath.section];
    
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"TotalSynPic" ofType:@"bundle"];
    
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    
    NSString *picName = [NSString stringWithFormat:@"%@-%@-%@",modelDict[TakeName],modelDict[TakeYear],modelDict[TakeAuthor]];
    
    NSData *picData = [NSData dataWithContentsOfFile:[bundle pathForResource:picName ofType:nil]];
    
    UIImage *image = [UIImage imageWithData:picData];
    
    //30 为cell的lable高度
    if (indexPath.section == _selSection)
    {
        return image.size.height + 30;
    }
    else return 2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [SVProgressHUD show];
    
    NSString *urlString = self.detailListArray[indexPath.section][Takelink];
    
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

//添加cell的动画
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //设置x和y的初始值为0.1；
    cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1);
    //x和y的最终值为1
    [UIView animateWithDuration:.3 animations:^{
        cell.layer.transform = CATransform3DMakeScale(1, 1, 1);
    }];
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
