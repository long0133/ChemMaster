//
//  CYLNameReaCell.h
//  ChemMaster
//
//  Created by GARY on 16/7/24.
//  Copyright © 2016年 GARY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CYLDetaileCell : UITableViewCell

@property (nonatomic, strong) NSDictionary *model;
//@property (nonatomic, strong) NSData *htmlData;
@property (nonatomic, strong) NSString *ModeIdentifier;


//传入模块id进行初始化
+ (instancetype)CellWithModeIdentifier:(NSString*)ModeID CellStyle:(UITableViewCellStyle)style andCellIdentifier:(NSString*)CellID CellName:(NSString*)cellName;

@end
