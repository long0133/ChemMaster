//
//  CYLResourceViewController.m
//  ChemMaster
//
//  Created by GARY on 16/6/24.
//  Copyright © 2016年 GARY. All rights reserved.
//

#import "CYLResourceViewController.h"
#import "CYLSpecificResourceViewController.h"
#define ResouceFileNameInCache @"Chem Resouce"
static NSString *reuse = @"reuse";

@interface CYLResourceViewController ()
@property (nonatomic, strong) NSMutableArray *contentArray;
@end

@implementation CYLResourceViewController
- (NSMutableArray *)contentArray
{
    if (_contentArray == nil) {
        _contentArray = [NSMutableArray array];
    }
    return _contentArray;
}


#pragma mark - tableviewDataSouce
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.contentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
    }
    
    cell.textLabel.text = self.contentArray[indexPath.row][TakeName];
    
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  dispatch_async(dispatch_get_global_queue(0, 0), ^{
     
      [SVProgressHUD show];
      [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
      
      NSString *urlString = self.contentArray[indexPath.row][Takelink];
      
      NSString *title = self.contentArray[indexPath.row][TakeName];
      
      CYLSpecificResourceViewController *sVC = [CYLSpecificResourceViewController SpecificResourceViewControllerWithUrl:[NSURL URLWithString:urlString] withTitle:title];
      
      sVC.hidesBottomBarWhenPushed = YES;
      
      dispatch_async(dispatch_get_main_queue(), ^{
         
          [SVProgressHUD dismiss];
          
          [self.navigationController pushViewController:sVC animated:YES];

          
      });
  });
    
}

+ (instancetype)resouceViewController
{
    CYLResourceViewController *RVC = [[CYLResourceViewController alloc] initWithStyle:UITableViewStylePlain];
    
    RVC.contentArray = [NSMutableArray arrayWithContentsOfFile:[cachePath stringByAppendingPathComponent:ResouceFileNameInCache]];
    
    if (RVC.contentArray.count) {
        return RVC;
    }
    else
    {
        NSData *htmlData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://www.organic-chemistry.org/info/chemistry/topics.shtm"]];
        
        TFHpple *hpple = [[TFHpple alloc] initWithHTMLData:htmlData];
        
        NSArray *array = [hpple searchWithXPathQuery:@"//a[@href]"];
        
        for (TFHppleElement *element in array) {
            
            if ([element.raw containsString:@"shtm"] && ![element.raw containsString:@"links"]) {
                
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                
                NSRange hrefRange = [element.raw rangeOfString:@"href"];
                NSRange shtmRange = [element.raw rangeOfString:@"shtm"];
                CGFloat length = (shtmRange.location + shtmRange.length) - (hrefRange.location + hrefRange.length);
                NSString *link = [element.raw substringWithRange:NSMakeRange((hrefRange.location + hrefRange.length + 2), length - 2)];
                
                link = [NSString stringWithFormat:@"http://www.organic-chemistry.org/info/chemistry/%@",link];
                
                NSString *name = [element.raw flattenHTML:element.raw trimWhiteSpace:NO];
                
                dict[Takelink] = link;
                dict[TakeName] = name;
                
                [RVC.contentArray addObject:dict];
            }
        }
        
        [RVC.contentArray writeToFile:[cachePath stringByAppendingPathComponent:ResouceFileNameInCache] atomically:YES];
    }
    return RVC;
}

@end
