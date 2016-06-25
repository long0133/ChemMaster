//
//  CYLSpecificResourceViewController.m
//  ChemMaster
//
//  Created by GARY on 16/6/24.
//  Copyright © 2016年 GARY. All rights reserved.
//

#import "CYLSpecificResourceViewController.h"
#import "CYLWebViewController.h"
static NSString *reuse = @"reuse";

@interface CYLSpecificResourceViewController ()
@property (nonatomic, strong) NSMutableArray *contentArray;
@end

@implementation CYLSpecificResourceViewController
- (NSMutableArray *)contentArray
{
    if (_contentArray == nil) {
        _contentArray = [NSMutableArray array];
    }
    return  _contentArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.rowHeight = 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.contentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuse];
    }
    
    cell.textLabel.text = self.contentArray[indexPath.row][TakeName];
    
    cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    cell.detailTextLabel.numberOfLines = 0;
    cell.detailTextLabel.text = self.contentArray[indexPath.row][TakeAbstract];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *urlString = self.contentArray[indexPath.row][Takelink];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    CYLWebViewController *webView = [CYLWebViewController initWithURL:url];
    
    [self.navigationController presentViewController:webView animated:YES completion:nil];
}

#if 0
+ (instancetype)SpecificResourceViewControllerWithUrl:(NSURL *)url
{
    CYLSpecificResourceViewController *svc = [[CYLSpecificResourceViewController alloc] initWithStyle:UITableViewStylePlain];
    
    svc.contentArray = [NSMutableArray arrayWithContentsOfFile:[cachePath stringByAppendingPathComponent:svc.title]];
    
    if (svc.contentArray.count) {
        return svc;
    }
    else
    {
        NSData *htmlData = [NSData dataWithContentsOfURL:url];
        
        TFHpple *hpple = [[TFHpple alloc] initWithHTMLData:htmlData];
        
        NSArray *array = [hpple searchWithXPathQuery:@"//p"];
        
        for (TFHppleElement *element in array) {
            
            if ([element.raw containsString:@"http"]) {
                
                /*
                 <p>
                 <a target="_blank" href="http://www.expasy.ch/">Expasy</a>
                 <br>
                 Expert Protein Analysis System
                 </p>
                 
                 */
                
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                
                NSString *link = [element.children[1] objectForKey:@"href"];
                
                dict[Takelink] = link;
                
                NSString *name = [[[element.children[1] children] firstObject] content];
                
                name = [name stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                name = [name stringByReplacingOccurrencesOfString:@"\r" withString:@""];
                
                NSLog(@"%@",name);
            
                if (name == nil) {
                    continue;
                }
                
                dict[TakeName] = name;
                
                NSString *string = [element.raw flattenHTML:element.raw trimWhiteSpace:NO];
                
                NSString *abstract = [string stringByReplacingOccurrencesOfString:name withString:@""];
                abstract = [abstract stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                abstract = [abstract stringByReplacingOccurrencesOfString:@"&#13;" withString:@""];
                
                dict[TakeAbstract] = abstract;
                
                [svc.contentArray addObject:dict];
            }
        }
        
        NSLog(@"%@",[cachePath stringByAppendingPathComponent:svc.title]);
        
        [svc.contentArray writeToFile:[cachePath stringByAppendingPathComponent:svc.title] atomically:YES];
    }
    return svc;
    
}
#endif

+ (instancetype)SpecificResourceViewControllerWithUrl:(NSURL *)url withTitle:(NSString *)title
{
    CYLSpecificResourceViewController *svc = [[CYLSpecificResourceViewController alloc] initWithStyle:UITableViewStylePlain];
    
    svc.title = title;
    
    svc.contentArray = [NSMutableArray arrayWithContentsOfFile:[cachePath stringByAppendingPathComponent:svc.title]];
    
    if (svc.contentArray.count) {
        return svc;
    }
    else
    {
        NSData *htmlData = [NSData dataWithContentsOfURL:url];
        
        TFHpple *hpple = [[TFHpple alloc] initWithHTMLData:htmlData];
        
        NSArray *array = [hpple searchWithXPathQuery:@"//p"];
        
        for (TFHppleElement *element in array) {
            
            if ([element.raw containsString:@"http"]) {
                
                /*
                 <p>
                 <a target="_blank" href="http://www.expasy.ch/">Expasy</a>
                 <br>
                 Expert Protein Analysis System
                 </p>
                 
                 */
                
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                
                NSString *link = [element.children[1] objectForKey:@"href"];
                
                dict[Takelink] = link;
                
                NSString *name = [[[element.children[1] children] firstObject] content];
                
                name = [name stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                name = [name stringByReplacingOccurrencesOfString:@"\r" withString:@""];
                
                NSLog(@"%@",name);
                
                if (name == nil) {
                    continue;
                }
                
                dict[TakeName] = name;
                
                NSString *string = [element.raw flattenHTML:element.raw trimWhiteSpace:NO];
                
                NSString *abstract = [string stringByReplacingOccurrencesOfString:name withString:@""];
                abstract = [abstract stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                abstract = [abstract stringByReplacingOccurrencesOfString:@"&#13;" withString:@""];
                
                dict[TakeAbstract] = abstract;
                
                [svc.contentArray addObject:dict];
            }
        }
        
        NSLog(@"%@",[cachePath stringByAppendingPathComponent:svc.title]);
        
        [svc.contentArray writeToFile:[cachePath stringByAppendingPathComponent:svc.title] atomically:YES];
    }
    return svc;
}

@end
