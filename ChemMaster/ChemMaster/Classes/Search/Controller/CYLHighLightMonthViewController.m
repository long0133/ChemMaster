//
//  CYLHighLightMonthViewController.m
//  ChemMaster
//
//  Created by GARY on 16/6/23.
//  Copyright © 2016年 GARY. All rights reserved.
//

#import "CYLHighLightMonthViewController.h"
#import "CYLReactionDetailViewController.h"

#define Jan @"January"
#define Feb @"February"
#define Mar @"March"
#define Apr @"April"
#define Jun @"June"
#define July @"July"
#define Aug @"August"
#define Sept @"September"
#define Oct @"October"
#define May @"May"
#define Nov @"November"
#define Dec @"December"
static NSString *reuse = @"reuseID";

@interface CYLHighLightMonthViewController ()

//@{key : NSArray[dict,dict{link, name}]}
/*
 eg:
 @{
    Feb : @[ @{takeLink : aLink, takeName : @"name"}, @{takeLink : aLink, takeName : @"name"}]
    }
 */
@property (nonatomic, strong) NSDictionary *contentDict;

@property (nonatomic, assign) NSInteger sectionCount;

@property (nonatomic, strong) NSArray *monthArray;

@end

@implementation CYLHighLightMonthViewController

- (NSDictionary *)contentDict
{
    if (_contentDict == nil) {
        
        _contentDict = @{Jan:[NSMutableArray array],
                         Feb:[NSMutableArray array],
                         Mar:[NSMutableArray array],
                         Apr:[NSMutableArray array],
                         May:[NSMutableArray array],
                         Jun:[NSMutableArray array],
                         July:[NSMutableArray array],
                         Aug:[NSMutableArray array],
                         Sept:[NSMutableArray array],
                         Oct:[NSMutableArray array],
                         Nov:[NSMutableArray array],
                         Dec:[NSMutableArray array]
                         };
    }
    return _contentDict;
}

- (NSArray *)monthArray
{
    if (_monthArray == nil) {
        _monthArray = @[Jan, Feb, Mar, Apr, May, Jun, July, Aug, Sept, Oct, Nov, Dec];
    }
    return _monthArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
}

#pragma mark - tableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger count = 0;
    
    NSArray *keys = [self.contentDict allKeys];
    
    for (NSString *key in keys) {
        
        if ([self.contentDict[key] count] > 0) {
            
            count += 1;
            
        }
    }
    
    _sectionCount = count;
    
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.contentDict[self.monthArray[section]] count];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //取出array
    NSArray *array = self.contentDict[self.monthArray[indexPath.section]];
    
    NSString *linkString = array[indexPath.row][Takelink];
    NSString *urlset = [linkString stringByDeletingLastPathComponent];
    urlset = [NSString stringWithFormat:@"%@/",urlset];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [SVProgressHUD show];
        
        CYLReactionDetailViewController *Rvc = [CYLReactionDetailViewController DetailViewControllerWithURL:[NSURL URLWithString:linkString] andUrlSetString:urlset];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [SVProgressHUD dismiss];
            
            [self.navigationController presentViewController:Rvc animated:YES completion:nil];
        });
    });
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
    }
    
    //取出模型array
    NSArray *array = self.contentDict[self.monthArray[indexPath.section]];
    
    cell.textLabel.text = array[indexPath.row][TakeName];
    
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *lable = [[UILabel alloc] init];
    
    lable.text = self.monthArray[section];
    lable.textColor = [UIColor whiteColor];
    
    lable.backgroundColor = [UIColor blackColor];
    lable.alpha = 0.7;
    
    return lable;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

#pragma mark - 自定义fangfa
+ (instancetype)HighLightMonthViewControllerWithURL:(NSURL *)url andURLPrefixSet:(NSString *)urlPrefix
{
    CYLHighLightMonthViewController *hmvc = [[CYLHighLightMonthViewController alloc] initWithStyle:UITableViewStylePlain];
    NSData *htmlData = [NSData dataWithContentsOfURL:url];
    
    TFHpple *monthList = [[TFHpple alloc] initWithHTMLData:htmlData];
    
    NSArray *monthListArray = [monthList searchWithXPathQuery:@"//a[@href]"];

    for (TFHppleElement *element in monthListArray) {
        
        NSString *monthKey = [hmvc MonthKeyTheContentBelonged:element.raw];
        
        if (monthKey.length) {
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            
            //link
            NSRange hrefRangr = [element.raw rangeOfString:@"href"];
            NSRange shtmRangr = [element.raw rangeOfString:@"shtm"];
            NSString *subPath = [element.raw substringWithRange:NSMakeRange((hrefRangr.length + hrefRangr.location + 2),((shtmRangr.length + shtmRangr.location) - (hrefRangr.length + hrefRangr.location) - 2))];
            NSString *link = [NSString stringWithFormat:@"%@/%@",urlPrefix, subPath];
            
            dict[Takelink] = link;
            
            NSString *name = [element.raw flattenHTML:element.raw trimWhiteSpace:NO];
            name = [name stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            name = [name stringByReplacingOccurrencesOfString:@"\t" withString:@""];
            name = [name stringByReplacingOccurrencesOfString:@"&#13;" withString:@""];
            
            dict[TakeName] = name;
            
            [hmvc.contentDict[monthKey] addObject:dict];
        }
    }
    
    return hmvc;
}

/**
 *  输入字符串查看链接属于哪一个月并返回对应的月份
 */
- (NSString*)MonthKeyTheContentBelonged:(NSString*)string
{
    NSArray *keys = [self.contentDict allKeys];
    
    for (NSString *month in keys) {
        
        if ([string containsString:month]) {
            
            return month;
        }
    }
    
    return nil;
}

@end
