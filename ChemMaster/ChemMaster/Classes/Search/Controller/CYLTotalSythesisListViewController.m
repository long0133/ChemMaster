//
//  CYLTotalSythesisListViewController.m
//  ChemMaster
//
//  Created by GARY on 16/6/21.
//  Copyright © 2016年 GARY. All rights reserved.
//

#import "CYLTotalSythesisListViewController.h"
#import "CYLTotalSynDetailViewController.h"
#import <TFHpple.h>

@interface CYLTotalSythesisListViewController ()
@property (nonatomic, strong) NSMutableArray *alphabet;
@end

@implementation CYLTotalSythesisListViewController

-(NSMutableArray *)alphabet
{
    if (_alphabet == nil) {
        
        _alphabet = [NSMutableArray array];
        
        for (unichar c = 'A'; c <= 'Z'; c++) {
            [_alphabet addObject:[NSString stringWithCharacters:&c length:1]];
        }
    }
    return _alphabet;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"TotalSynthesis"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
 
    return self.alphabet.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TotalSynthesis" forIndexPath:indexPath];
    
    cell.textLabel.text = self.alphabet[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [SVProgressHUD show];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
   __block NSMutableArray *tempArray = [NSMutableArray array];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        //发送请求获得字母开头的化合物
        UITableViewCell *selCell = [tableView cellForRowAtIndexPath:indexPath];
        
        NSString *urlString = [NSString stringWithFormat:@"http://www.organic-chemistry.org/totalsynthesis/navi/%@.shtm", selCell.textLabel.text];
        urlString = [urlString lowercaseString];
        
        NSData *htmlData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
        TFHpple *htmlHpple = [[TFHpple alloc] initWithHTMLData:htmlData];
        
        NSArray *trArray = [htmlHpple searchWithXPathQuery:@"//tr"];
        
        
        /*
         <tr>
         <td>
         <a href="../totsyn04/ent-abudinol-b-mcdonald.shtm">ent-Abudinol B</a>
         </td>
         <td>2008</td>
         <td>McDonald</td>
         <td>Paul H. Docherty</td>
         </tr>
         */
        NSInteger i = 0;
        
        for (TFHppleElement *element in trArray)
        {
            
            if (i < 1)
            {
                
                i ++;
                continue;
            }
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            
            //获得链接和化合物名称
            NSString *raw = [element.children[1] raw];
            
            if ([raw containsString:@"href"] && [raw containsString:@"shtm"])
            {
                //<td>&#13; <a href="../totsyn04/ent-abudinol-b-mcdonald.shtm">ent-Abudinol B</a></td>
                raw = [raw stringByReplacingOccurrencesOfString:@"<td>&#13;\n" withString:@""];
                NSRange hrefRange = [raw rangeOfString:@"href"];
                NSRange shtmRange = [raw rangeOfString:@"shtm"];
                
                NSInteger length = (shtmRange.length + shtmRange.location)  - (hrefRange.location + hrefRange.length);
                NSString *url = [raw substringWithRange:NSMakeRange((hrefRange.location + hrefRange.length + 2),(length - 2))];
                url = [url stringByReplacingOccurrencesOfString:@"../" withString:@""];
                
                if ([url containsString:@"Highlights"]) {
                    
                    url = [NSString stringWithFormat:@"http://www.organic-chemistry.org/%@",url];
                }
                else
                {
                    url = [NSString stringWithFormat:@"http://www.organic-chemistry.org/totalsynthesis/%@",url];
                }
                
                dict[Takelink] = url;
                
                NSString *nameString = [raw flattenHTML:raw trimWhiteSpace:YES];
                nameString = [nameString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                nameString = [nameString stringByReplacingOccurrencesOfString:@"&#13;" withString:@""];
                nameString = [nameString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
                
                dict[TakeName] = nameString;
            }
            
            //获得年份 和 作者名
            
            NSString *year = [element.children[3] raw];
            year = [year flattenHTML:year trimWhiteSpace:YES];
            
            NSString *author = [element.children[5] raw];
            author = [author flattenHTML:author trimWhiteSpace:YES];
            
            dict[TakeYear] = year;
            dict[TakeAuthor] = author;
            
            [tempArray addObject:dict];
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            [SVProgressHUD dismiss];
            
            CYLTotalSynDetailViewController *detailVC = [CYLTotalSynDetailViewController detaileViewWithArray:tempArray];
            
            
            detailVC.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:detailVC animated:YES];
            
        });
       
        
    });
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    
    header.text = @"Alphabets Order:";
    
    header.textColor = [UIColor whiteColor];
    
    header.backgroundColor = [UIColor blackColor];
    
    header.alpha = 0.7;
    
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

@end
