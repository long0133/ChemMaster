//
//  CYLHightLightCell.m
//  ChemMaster
//
//  Created by GARY on 16/6/14.
//  Copyright © 2016年 GARY. All rights reserved.
//

#import "CYLHightLightCell.h"

@implementation CYLHightLightCell

- (void)setModel:(CYLHightLightModel *)model
{
    _model = model;
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ScreenW, self.frame.size.height)];
    
    [btn setImage:model.img forState:UIControlStateNormal];
    
    [btn setTitle:model.journalName forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(didClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:btn];
}

-(void)didClickBtn:(UIButton*)btn
{
    if ([self.delegate respondsToSelector:@selector(HightLightCellDidClickButton:)]) {
        [self.delegate HightLightCellDidClickButton:btn];
    }
}
@end
