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
#import <Masonry.h>
#import <TFHpple.h>

@interface CYLSearchViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong) UIImageView *logoView;

@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic ,strong) UIPickerView *selPicker;

@property (nonatomic, strong) NSString *selectedPickerString;

@property (nonatomic, strong) UITextField *TextField;
@property (nonatomic, strong) UIButton *NRSearchBtn;

@property (nonatomic ,strong) CYLResultViewController* resultVC;
@property (nonatomic, strong) NSMutableArray *resultArray;
@property (nonatomic, strong) NSData *htmlData;

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
    
//    [_resultVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.TextField.mas_bottom).offset(50);
//        make.left.right.equalTo(self.view);
//        make.bottom.equalTo(self.view).offset(-44);
//        make.width.equalTo(self.view);
//    }];
}

- (void)selectBtnClicked
{
    self.selPicker.hidden = !self.selPicker.hidden;
}

#pragma mark - 点击搜索按钮 解析html 获得结果模型组
#warning 解析html未完成
- (void)searchBtnClicked
{
    /*
     2016-06-16 00:14:45.718 ChemMaster[14498:453622] _BSMachError: (os/kern) invalid capability (20)
     2016-06-16 00:14:45.718 ChemMaster[14498:453845] _BSMachError: (os/kern) invalid name (15)
     */
    
    if ([self.selPicker selectedRowInComponent:0] == 0) { //选中人名反应时
        
        [self.resultArray removeAllObjects];
        
//        self.resultVC.view.hidden = NO;
        
        NSString *ResultUrlString = [NSString stringWithFormat:@"http://www.organic-chemistry.org/search/search.cgi?zoom_sort=0&zoom_query=%@",self.TextField.text];
        
        //处理字符串 不能含有空格
        if ([ResultUrlString containsString:@" "]) {
            
           ResultUrlString = [ResultUrlString stringByReplacingOccurrencesOfString:@" " withString:@""];
        }
        
        _htmlData = [NSData dataWithContentsOfURL:[NSURL URLWithString:ResultUrlString]];
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
        });
        
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
        
        [self.navigationController pushViewController:self.resultVC animated:YES];
        [self.resultVC.tableView reloadData];
        [self resignKeyBoard];
    }//if
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
        self.TextField.placeholder = @"请输入化合物名称";
    }
}
@end
