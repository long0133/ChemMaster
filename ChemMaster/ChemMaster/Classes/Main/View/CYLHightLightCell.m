//
//  CYLHightLightCell.m
//  ChemMaster
//
//  Created by GARY on 16/6/14.
//  Copyright © 2016年 GARY. All rights reserved.
//

#import "CYLHightLightCell.h"

@interface CYLHightLightCell ()

@property (nonatomic, strong) UIButton *btn;

@end

@implementation CYLHightLightCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark - 懒加载
- (UIButton *)btn
{
    if (_btn == nil) {
        
       _btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height)];
        [_btn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [_btn addTarget:self action:@selector(didClickBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:_btn];
    }
    return _btn;
}

- (void)setModel:(CYLHightLightModel *)model
{
    _model = model;

    [self.btn setBackgroundImage:model.img forState:UIControlStateNormal];
    [self.btn setTitle:model.journalName forState:UIControlStateNormal];
    
}

-(void)didClickBtn:(UIButton*)btn
{
    if ([self.delegate respondsToSelector:@selector(HightLightCellDidClickButton:)]) {
        [self.delegate HightLightCellDidClickButton:btn];
    }
}
@end
