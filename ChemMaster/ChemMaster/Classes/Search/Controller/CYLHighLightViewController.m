//
//  CYLHighLightViewController.m
//  ChemMaster
//
//  Created by GARY on 16/6/23.
//  Copyright © 2016年 GARY. All rights reserved.
//

#import "CYLHighLightViewController.h"
#import "CYLHighLightMonthViewController.h"


@interface CYLHighLightViewController ()
@property (nonatomic, strong) NSMutableArray *yearListArray;
@end

@implementation CYLHighLightViewController

- (NSMutableArray *)yearListArray
{
    if (_yearListArray == nil) {
        _yearListArray = [NSMutableArray array];
    }
    return _yearListArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark -  tableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.yearListArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
    }
    
    cell.textLabel.text = self.yearListArray[indexPath.row][TakeYear];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *urlString = self.yearListArray[indexPath.row][Takelink];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    [SVProgressHUD show];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
       
        NSString *urlPrefix = [urlString stringByDeletingLastPathComponent];
        
        CYLHighLightMonthViewController *hmVC = [CYLHighLightMonthViewController HighLightMonthViewControllerWithURL:url andURLPrefixSet:urlPrefix];
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            [SVProgressHUD dismiss];
            
            [self.navigationController pushViewController:hmVC animated:YES];
            
        });
        
    });
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *lable = [[UILabel alloc] init];
    lable.text = @"Years Order:";
    lable.textColor = [UIColor whiteColor];
    lable.backgroundColor = [UIColor blackColor];
    lable.alpha = 0.7;
    return lable;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

#pragma mark - 自定义方法
+ (instancetype)highLightViewController
{
    CYLHighLightViewController *hvc = [[CYLHighLightViewController alloc] initWithStyle:UITableViewStylePlain];
   
    hvc.yearListArray = [NSMutableArray arrayWithContentsOfFile:[cachePath stringByAppendingString:@"yearList"]];
    
    if (hvc.yearListArray.count) {
        return hvc;
    }
    else
    {
        NSData *htmlData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://www.organic-chemistry.org/Highlights/"]];
        
        TFHpple *years = [[TFHpple alloc] initWithHTMLData:htmlData];
        
        NSArray *yearArray = [years searchWithXPathQuery:@"//a"];
        
        
        
        for (TFHppleElement *element in yearArray) {
            
            if ([element.raw containsString:@"index"]) {
                
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                
                NSRange hrefRangr = [element.raw rangeOfString:@"href"];
                NSRange shtmRangr = [element.raw rangeOfString:@"shtm"];
                NSString *subPath = [element.raw substringWithRange:NSMakeRange((hrefRangr.length + hrefRangr.location + 2),((shtmRangr.length + shtmRangr.location) - (hrefRangr.length + hrefRangr.location) - 2))];
                NSString *link = [NSString stringWithFormat:@"http://www.organic-chemistry.org/Highlights/%@", subPath];
                
                dict[Takelink] = link;
                dict[TakeYear] = [subPath stringByDeletingLastPathComponent];
                
                [hvc.yearListArray addObject:dict];
            }
        }
    }
    
    [hvc.yearListArray writeToFile:[cachePath stringByAppendingString:@"yearList"] atomically:YES];
    

    return hvc;
}

@end
