//
//  CYLnameReactionListViewController.m
//  ChemMaster
//
//  Created by GARY on 16/6/21.
//  Copyright © 2016年 GARY. All rights reserved.
//

/*
 Section 的Header点击会显示出Cell，因此在模型数组中取出模型时，应当用section 而非Row
 */

#import "CYLnameReactionListViewController.h"
#import "CYLReactionDetailViewController.h"
#import "CYLDetaileCell.h"
#import <SVProgressHUD.h>
#import <TFHpple.h>
//存储list时的文件后缀
#define  fileNameSulffix @"NameReactionList"

//传给result detailView的文件后缀
#define fileNameForDetailViewSulffix @"ANameReaction"
static NSString *reuse = @"reuse";

@interface CYLnameReactionListViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) NSMutableArray *listArray;
@property (nonatomic, strong) NSMutableArray *filtedListArray;
@property (nonatomic, strong) UITextField *searchTextFiled;

@property (nonatomic,assign) NSInteger selSection;
@end

@implementation CYLnameReactionListViewController

- (NSMutableArray *)listArray
{
    if (_listArray == nil) {
        _listArray = [NSMutableArray array];        
    }
    return _listArray;
}

- (NSMutableArray *)filtedListArray
{
    if (_filtedListArray == nil) {
        
        _filtedListArray = [self.listArray mutableCopy];
    }
    return _filtedListArray;
}

- (UITextField *)searchTextFiled
{
    if (_searchTextFiled == nil) {
        
        _searchTextFiled = [[UITextField alloc] initWithFrame:CGRectMake(0, 64, ScreenW, 30)];
        _searchTextFiled.backgroundColor = [UIColor getColor:@"FAEBD7"];
        _searchTextFiled.borderStyle = UITextBorderStyleLine;
        _searchTextFiled.hidden = YES;
        _searchTextFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
        _searchTextFiled.delegate = self;
        
        //监听键盘输入，显示相关内容
        [_searchTextFiled addTarget:self action:@selector(showFilterResulte) forControlEvents:UIControlEventEditingChanged];
        [KWindow addSubview:_searchTextFiled];
        
    }
    return _searchTextFiled;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavVC];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)setNavVC
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageCompressForSize:[UIImage imageNamed:@"search49"] targetSize:CGSizeMake(25, 25)] style:UIBarButtonItemStyleDone target:self action:@selector(searchBtnClicked)];
}

#pragma mark - search功能
- (void)searchBtnClicked
{
    self.searchTextFiled.hidden = !self.searchTextFiled.hidden;
    
    if (!_searchTextFiled.hidden)
    {
        [self.searchTextFiled becomeFirstResponder];
        self.tableView.frame = CGRectMake(0,self.searchTextFiled.frame.size.height, ScreenW, ScreenH);
        [self showFilterResulte];
    }
    else
    {
        self.tableView.frame = CGRectMake(0, 0, ScreenW, ScreenH);
        [self.searchTextFiled resignFirstResponder];
    }
}


- (void)showFilterResulte
{
    NSString *text = [self.searchTextFiled.text uppercaseStringWithLocale:[NSLocale currentLocale]];
    
    text = [text capitalizedStringWithLocale:[NSLocale currentLocale]];
    
    [self.filtedListArray removeAllObjects];
    
    //输入时，cell默认选择第一个
    _selSection = 0;
    
    //遍历FiltedListArray获得带有text前缀的模型数组
    for (NSDictionary *modelDict in self.listArray)
    {
        
        NSString *name = modelDict[TakeName];
        
        if ([name hasPrefix:text])
        {
            
            [self.filtedListArray addObject:modelDict];
            
        }
    }
    
    //如果遍历完无结果
    if (self.filtedListArray.count == 0 && [text isEqualToString:@""]) {
        self.filtedListArray = [self.listArray mutableCopy];
    }
    
    [self.tableView reloadData];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.searchTextFiled removeFromSuperview];
    self.searchTextFiled = nil;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    
    return self.filtedListArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CYLDetaileCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    
    NSDictionary *modelDict = self.filtedListArray[indexPath.section];
    
    if (cell == nil) {
        
        cell = [CYLDetaileCell CellWithModeIdentifier:nameReactionList CellStyle:UITableViewCellStyleDefault andCellIdentifier:reuse CellName:modelDict[TakeName]];
    }
    
    cell.model = modelDict;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *linkString = self.filtedListArray[indexPath.section][Takelink];
    
    [self.searchTextFiled resignFirstResponder];

    [SVProgressHUD show];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
       
        CYLReactionDetailViewController *rvc = [CYLReactionDetailViewController DetailViewControllerWithURL:[NSURL URLWithString:linkString] andUrlSetString:@"http://www.organic-chemistry.org/namedreactions/"];
        rvc.title = [self.listArray[indexPath.section][TakeName] stringByAppendingString:fileNameForDetailViewSulffix];
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            [SVProgressHUD dismiss];
            
            self.searchTextFiled.hidden = YES;
            
            [self.navigationController presentViewController:rvc animated:YES completion:nil];
    
        });
        
    });
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *lable = [[UILabel alloc] init];
    lable.textColor = [UIColor blackColor];
    lable.backgroundColor = [UIColor getColor:@"F0F0F0"];
    lable.tag = section;
    lable.userInteractionEnabled = YES;
    [lable addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSection:)]];

    lable.text = [NSString stringWithFormat:@"  %@",self.filtedListArray[section][TakeName]];
    
    return lable;
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
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"NameListPicture" ofType:@"bundle"];
    
   NSData *picData = [NSData dataWithContentsOfFile:[bundlePath stringByAppendingPathComponent:self.filtedListArray[indexPath.section][TakeName]]];
    
    
    UIImage *image = [UIImage imageWithData:picData];
    
    //30 为cell的lable高度
    if (indexPath.section == _selSection)
    {
        return image.size.height + 30;
    }
    else return 1;
    
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


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.searchTextFiled) {
        
        [self.searchTextFiled resignFirstResponder];
        
    }
    
    return YES;
}









@end
