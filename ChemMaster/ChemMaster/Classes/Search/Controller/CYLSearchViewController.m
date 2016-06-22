//
//  CYLSearchViewController.m
//  ChemMaster
//
//  Created by GARY on 16/6/12.
//  Copyright © 2016年 GARY. All rights reserved.
//

#import "CYLSearchViewController.h"
#import "CYLResultModel.h"
#import "CYLResultViewController.h"
#import "CYLWebViewController.h"
#import "CYLnameReactionListViewController.h"
#import "CYLTotalSythesisListViewController.h"
#import <SVProgressHUD.h>
#import <Masonry.h>
#import <TFHpple.h>

@interface CYLSearchViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong) UIImageView *logoView;

@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic , assign) BOOL selectBtnStatus;
@property (nonatomic ,strong) UIPickerView *selPicker;

@property (nonatomic, strong) NSString *selectedPickerString;

@property (nonatomic, strong) UITextField *TextField;
@property (nonatomic, strong) UIButton *NRSearchBtn;

@property (nonatomic ,strong) CYLResultViewController* resultVC;
@property (nonatomic, strong) NSMutableArray *resultArray;
@property (nonatomic, strong) NSData *htmlData;

@property (nonatomic, strong) UIButton *nameReactionListBtn;
@property (nonatomic, strong) UIButton *TotalSynthesisListBtn;

@end

@implementation CYLSearchViewController
- (CYLResultViewController *)resultVC
{
    if (_resultVC == nil) {
        _resultVC = [CYLResultViewController ResultViewControllerWithResultArray:self.resultArray andHtmlData:self.htmlData];
        _resultVC.hidesBottomBarWhenPushed = YES;
        _resultVC.title = @"搜索结果";
        
    }
    return _resultVC;
}

- (NSMutableArray *)resultArray
{
    if (_resultArray == nil) {
        _resultArray = [NSMutableArray array];
    }
    return _resultArray;
}

- (UIPickerView *)selPicker
{
    if (_selPicker == nil) {
        _selPicker = [[UIPickerView alloc] init];
        _selPicker.hidden = YES;
        _selPicker.delegate = self;
        _selPicker.dataSource = self;
        [self.view addSubview:_selPicker];
    }
    return _selPicker;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];

    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyBoard)]];
    
    [self setUpUI];

}

- (void)resignKeyBoard
{
    [self.TextField resignFirstResponder];
}

- (void)setUpUI
{
    _logoView = [[UIImageView alloc] init];
    _logoView.image = [UIImage imageNamed:@"LOGO"];
    [self.view addSubview:_logoView];
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    [attributes setValue:[NSNumber numberWithInteger:-3] forKey:NSStrokeWidthAttributeName];
    
    
    _TextField = [[UITextField alloc] init];
    _TextField.borderStyle = UITextBorderStyleRoundedRect;
    self.TextField.font = [UIFont systemFontOfSize:10];
    _TextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.TextField.placeholder = @"请输入反应名称 如:Claisen";
    [self.view addSubview:_TextField];
    
    _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_selectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_selectBtn setTitle:@"Name Reaction:" forState:UIControlStateNormal];
    [_selectBtn setImage:[UIImage imageCompressForSize:[UIImage imageNamed:@"arrow-down"] targetSize:CGSizeMake(10, 10)] forState:UIControlStateNormal];
    [_selectBtn addTarget:self action:@selector(selectBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_selectBtn];
    
    _NRSearchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_NRSearchBtn setImage:[UIImage imageCompressForSize:[UIImage imageNamed:@"search49"] targetSize:CGSizeMake(70, 70)] forState:UIControlStateNormal];
    [_NRSearchBtn addTarget:self action:@selector(searchBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_NRSearchBtn];
    
    _nameReactionListBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_nameReactionListBtn addTarget:self action:@selector(ShowNameReactionList) forControlEvents:UIControlEventTouchUpInside];
    [_nameReactionListBtn setTitle:@"Name Reaction" forState:UIControlStateNormal];
    [_nameReactionListBtn.titleLabel setFont:[UIFont systemFontOfSize:20]];
    _nameReactionListBtn.backgroundColor = [UIColor getColor:@"00CDCD"];
    [self.view addSubview:_nameReactionListBtn];
    
    _TotalSynthesisListBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_TotalSynthesisListBtn addTarget:self action:@selector(showTotalSynthesisList) forControlEvents:UIControlEventTouchUpInside];
    [_TotalSynthesisListBtn setTitle:@"Total Synthesis" forState:UIControlStateNormal];
    [_TotalSynthesisListBtn.titleLabel setFont:[UIFont systemFontOfSize:20]];
    _TotalSynthesisListBtn.backgroundColor = [UIColor getColor:@"4EEE94"];
    [self.view addSubview:_TotalSynthesisListBtn];
}

- (void)viewWillLayoutSubviews
{
    [_logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(64);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(275);
        make.height.mas_equalTo(55);
    }];
    
    [_selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logoView.mas_bottom).offset(40);
        make.left.equalTo(self.view).offset(20);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(120);
    }];

    [self.selPicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.selectBtn.mas_bottom);
        make.centerX.equalTo(self.selectBtn.mas_centerX);
        make.width.equalTo(self.selectBtn);
        make.height.mas_equalTo(50);
    }];
    
    [_TextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.selectBtn.mas_right);
        make.centerY.equalTo(self.selectBtn.mas_centerY);
        make.width.mas_equalTo(ScreenW/5 * 2);
    }];

    [_NRSearchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.TextField.mas_right).offset(10);
        make.centerY.equalTo(self.TextField.mas_centerY);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];
    
    [_nameReactionListBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.view).offset(20);
        make.top.equalTo(self.selPicker.mas_bottom).offset(20);
        make.width.height.mas_equalTo(150);
    }];
    
    [_TotalSynthesisListBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.width.height.equalTo(self.nameReactionListBtn);
        make.right.equalTo(self.view).offset(-20);
        make.top.equalTo(self.nameReactionListBtn);
        
    }];
}

- (void)selectBtnClicked
{
    //修改btn的图标
    if (_selectBtnStatus) {
        [_selectBtn setImage:[UIImage imageCompressForSize:[UIImage imageNamed:@"arrow-down"] targetSize:CGSizeMake(10, 10)] forState:UIControlStateNormal];
    }
    else
    {
        [_selectBtn setImage:[UIImage imageCompressForSize:[UIImage imageNamed:@"Arrows-Up-4-icon"] targetSize:CGSizeMake(10, 10)] forState:UIControlStateNormal];
    }
    
    _selectBtnStatus = !_selectBtnStatus;
    
    self.selPicker.hidden = !self.selPicker.hidden;
}

#pragma mark - 点击搜索按钮 解析html 获得结果模型组
- (void)searchBtnClicked
{
    if ([self.selPicker selectedRowInComponent:0] == 0) { //选中人名反应时
        
        [self resignKeyBoard];
        
        [SVProgressHUD show];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        
        self.NRSearchBtn.enabled = NO;
        self.TextField.enabled = NO;
        
        [self.resultArray removeAllObjects];
        
        NSString *ResultUrlString = [NSString stringWithFormat:@"http://www.organic-chemistry.org/search/search.cgi?zoom_sort=0&zoom_query=%@",self.TextField.text];
        
        //处理字符串 不能含有空格
        if ([ResultUrlString containsString:@" "]) {
            
           ResultUrlString = [ResultUrlString stringByReplacingOccurrencesOfString:@" " withString:@""];
        }
        
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            
            _htmlData = [NSData dataWithContentsOfURL:[NSURL URLWithString:ResultUrlString]];
            
            TFHpple *parser = [[TFHpple alloc] initWithHTMLData:_htmlData];
            
            NSArray *dataArray = [parser searchWithXPathQuery:@"//div"];
            
            for (TFHppleElement *element in dataArray) {
                
                if ([[element objectForKey:@"class"] isEqualToString:@"infoline"] ) {
                    
                    NSString *subString = [element.raw substringFromIndex:27];
                    
                    NSString *urlString = [subString stringByReplacingOccurrencesOfString:@"</div>" withString:@""];
                    
                    BOOL isNameReaction = [urlString containsString:@"namedreactions"];
                    
                    NSString *resultName = [urlString lastPathComponent];
                    
                    resultName = [resultName stringByDeletingPathExtension];
                    
                    CYLResultModel *resultModel = [[CYLResultModel alloc] init];
                    
                    if (isNameReaction) {//时人名反应类别则存入数组
                        resultModel.resultName = resultName;
                        resultModel.urlString = urlString;
                        resultModel.isNameReaction = isNameReaction;
                        [self.resultArray addObject:resultModel];
                    }//if
                }
            }
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                NSLog(@"%@",self.resultArray);
                [self.navigationController pushViewController:self.resultVC animated:YES];
                [self.resultVC.tableView reloadData];
                
                
                [SVProgressHUD dismiss];
                self.NRSearchBtn.enabled = YES;
                self.TextField.enabled = YES;
            });
        });
    }//if
    else
    {
        //选中化合物查询时
        NSString *ComponendUrl = [NSString stringWithFormat:@"http://pubchem.ncbi.nlm.nih.gov/search/#collection=compounds&query_type=text&query=%%22%@%%22",self.TextField.text];
        
        CYLWebViewController *wenVC = [CYLWebViewController initWithURL:[NSURL URLWithString:ComponendUrl]];
        [self.navigationController presentViewController:wenVC animated:YES completion:nil];
        
    }
}

#pragma mark - 显示NameReaction / TotalSynthesis listButton
- (void)ShowNameReactionList
{
    CYLnameReactionListViewController *nameListVC = [CYLnameReactionListViewController listViewController];
    nameListVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:nameListVC animated:YES];
}

- (void)showTotalSynthesisList
{
    CYLTotalSythesisListViewController *Tvc = [[CYLTotalSythesisListViewController alloc] initWithStyle:UITableViewStylePlain];
    
    [self.navigationController pushViewController:Tvc animated:YES];
}

#pragma mark - pickerView
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 2;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    lable.font = [UIFont systemFontOfSize:14];
    if (row == 0) {
        lable.text = @"Name Reaction";
    }
    else
    {
        lable.text = @"Component";
    }
    return lable;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (row == 0) {
        [self.selectBtn setTitle:@"Name Reaction:" forState:UIControlStateNormal];
        self.TextField.font = [UIFont systemFontOfSize:10];
        self.TextField.placeholder = @"请输入反应名称 如:Claisen";
    }
    else
    {
        [self.selectBtn setTitle:@"Component:" forState:UIControlStateNormal];
        self.TextField.font = [UIFont systemFontOfSize:10];
        self.TextField.placeholder = @"请输入化合物名称,CAS";
    }
    self.TextField.text = nil;
}
@end
