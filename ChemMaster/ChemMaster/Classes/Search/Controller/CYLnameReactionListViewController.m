//
//  CYLnameReactionListViewController.m
//  ChemMaster
//
//  Created by GARY on 16/6/21.
//  Copyright © 2016年 GARY. All rights reserved.
//

#import "CYLnameReactionListViewController.h"
#import "CYLReactionDetailViewController.h"
#import <SVProgressHUD.h>
#import <TFHpple.h>
#define  fileNameSulffix @"NameReactionList"

static NSString *reuse = @"reuse";

@interface CYLnameReactionListViewController ()

@property (nonatomic, strong) NSMutableArray *listArray;

@end

@implementation CYLnameReactionListViewController

- (NSMutableArray *)listArray
{
    if (_listArray == nil) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
    }
    
    cell.textLabel.text = self.listArray[indexPath.row][TakeName];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *linkString = self.listArray[indexPath.row][Takelink];

    [SVProgressHUD show];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
       
        CYLReactionDetailViewController *rvc = [CYLReactionDetailViewController DetailViewControllerWithURL:[NSURL URLWithString:linkString] andUrlSetString:@"http://www.organic-chemistry.org/namedreactions/"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            [SVProgressHUD dismiss];
            
            [self.navigationController presentViewController:rvc animated:YES completion:nil];
    
        });
        
    });
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *lable = [[UILabel alloc] init];
    lable.text = @"Alphabet Order:";
    lable.textColor = [UIColor whiteColor];
    lable.backgroundColor = [UIColor blackColor];
    lable.alpha = .7;
    return lable;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

#pragma mark - 初始化方法
+ (instancetype)listViewController
{
    CYLnameReactionListViewController *listVC = [[CYLnameReactionListViewController alloc] initWithStyle:UITableViewStylePlain];
    
    //查看caches是否有list的存档 //每月更新一次
    NSString *shouldReloadFileName  = [[NSString stringFromDate:[currentDate dateByAddingTimeInterval:secondOfMonth] WithDateFormat:dateFormatString] stringByAppendingString:fileNameSulffix];
    
    NSString *listPath = nil;
    NSString *fileNameInCache = nil;
    
    NSArray *subPathArray = [fileManager subpathsAtPath:cachePath];
    
    for (NSString *subPath in subPathArray) {
        
        if ([subPath containsString:fileNameSulffix]) {
            
            listPath = [cachePath stringByAppendingPathComponent:subPath];
            fileNameInCache = subPath;
        }
        
    }
    
    NSData *data = [NSData dataWithContentsOfFile:listPath];
    
    if (data)
    {
        NSDate *shouldLoadDate = [NSString dateFromString:[fileNameInCache stringByReplacingOccurrencesOfString:fileNameSulffix withString:@""] WithDateFormat:dateFormatString];
        
        //判断是否超出一周的时间
        if ([currentDate compare:shouldLoadDate] == NSOrderedDescending ||NSOrderedSame)
        {
            [self listArrayFromUrl:[NSURL URLWithString:@"http://www.organic-chemistry.org/namedreactions/"] withViewController:listVC];
            
            //删除原有的文件
            [fileManager removeItemAtPath:listPath error:nil];
            
            //添加新下载的文件
            [listVC.listArray writeToFile:[cachePath stringByAppendingPathComponent:shouldReloadFileName] atomically:YES];
            
        }
        else
        {
            listVC.listArray = [NSMutableArray arrayWithContentsOfFile:listPath];
        }
    }
    else
    {
        [self listArrayFromUrl:[NSURL URLWithString:@"http://www.organic-chemistry.org/namedreactions/"] withViewController:listVC];
        
        [listVC.listArray writeToFile:[cachePath stringByAppendingPathComponent:shouldReloadFileName] atomically:YES];
    }
    return listVC;
}

//[NSURL URLWithString:@"http://www.organic-chemistry.org/namedreactions/"]

//通过url获取list
+ (NSMutableArray *)listArrayFromUrl:(NSURL*)url withViewController:(CYLnameReactionListViewController*)listVC
{
    
    TFHpple *nameListHpple = [[TFHpple alloc] initWithHTMLData:[NSData dataWithContentsOfURL:url]];
    
    NSArray *listArray = [nameListHpple searchWithXPathQuery:@"//p"];
    
    NSMutableArray *tempArray = [NSMutableArray array];
    
    for (TFHppleElement *element in listArray) {
        
        if ([element.raw containsString:@"href"] && [element.raw containsString:@"shtm"]) {
            
            [tempArray addObject:element.raw];
        }
    }
    
    for (NSString *string in tempArray) {
        
        //处理获得链接 + 名称 的字典
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        
        //获取链接
        NSRange hrefRange = [string rangeOfString:@"href"];
        
        NSRange shtmRang = [string rangeOfString:@"shtm"];
        
        NSInteger length = (shtmRang.location + shtmRang.length) - (hrefRange.location + hrefRange.length);
        
        NSRange rangeOfLinke = NSMakeRange((hrefRange.location + hrefRange.length),length);
        
        NSString *linkstring = [string substringWithRange:rangeOfLinke];
        
        NSRange linkrange = [linkstring rangeOfString:linkstring];
        
        linkstring = [linkstring substringWithRange:NSMakeRange(linkrange.location + 2, linkrange.length - 2)];
        
        linkstring = [NSString stringWithFormat:@"http://www.organic-chemistry.org/namedreactions/%@",linkstring];
        
        dict[Takelink] = linkstring;
        
        //获取反应名称
        NSString *nameString = [string copy];
        nameString = [nameString stringByReplacingOccurrencesOfString:@"&#13;" withString:@""];
        nameString = [nameString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        
        NSScanner *scanner = [NSScanner scannerWithString:nameString];
        NSString *text = nil;
        
        while ([scanner isAtEnd] == NO) {
            
            [scanner scanUpToString:@"<" intoString:NULL];
            
            [scanner scanUpToString:@">" intoString:&text];
            
            nameString = [nameString stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", text] withString:@""];
        }
        
        dict[TakeName] = nameString;
        
        [listVC.listArray addObject:dict];
  }//forin
    
    return listVC.listArray;
}












@end
