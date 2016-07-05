//
//  CYLShowSaveFileController.m
//  ChemMaster
//
//  Created by GARY on 16/7/4.
//  Copyright © 2016年 GARY. All rights reserved.
//

#import "CYLShowSaveFileController.h"
#import "CYLDetailViewFromSaveViewController.h"
@interface CYLShowSaveFileController ()
@property (nonatomic, strong) NSArray *PathArray;
@end

@implementation CYLShowSaveFileController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.PathArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    NSString *name = [self.PathArray[indexPath.row] lastPathComponent];
    
    if ([name containsString:NameReactionCategory]) {
        name = [name stringByReplacingOccurrencesOfString:NameReactionCategory withString:@""];
    }
    else if ([name containsString:TotalSynthesisCategory])
    {
        name = [name stringByReplacingOccurrencesOfString:TotalSynthesisCategory withString:@""];
    }
    else
    {
        name = [name stringByReplacingOccurrencesOfString:HightLightCategory withString:@""];
    }
    
    cell.textLabel.text = name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //传入cache中存储的文件让detailView无需加载直接显示
    NSArray *array = [NSArray arrayWithContentsOfFile:self.PathArray[indexPath.row]];
    
    CYLDetailViewFromSaveViewController *detialVC = [CYLDetailViewFromSaveViewController detaileViewWithcontentArrayFromCache:array];
    
    [self.navigationController presentViewController:detialVC animated:YES completion:nil];

}


+ (instancetype)showSaveFileWithContentPathArray:(NSArray *)array
{
    CYLShowSaveFileController *SaveVC = [[CYLShowSaveFileController alloc] init];
    SaveVC.PathArray = array;
    return SaveVC;
}

@end
