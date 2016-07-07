//
//  CYLToolBarView.m
//  ChemMaster
//
//  Created by GARY on 16/6/18.
//  Copyright © 2016年 GARY. All rights reserved.
//

#import "CYLToolBarView.h"
#import "CYLAngleBtn.h"

#define BtnTitleFont 25
#define BackGroundColor @"bbd8cd"
#define selectedBackGroudColor @"66f0bc"
#define NColor @"0000FF"
#define OColor @"DC143C"
#define HColor @"6495ED"
#define ClColor @"f0d666"
#define BrColor @"cb7a1a"
#define FColor @"a0cb1a"
#define SColor @"708334"
@interface CYLToolBarView ()

@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, strong) UIButton *DrawBtn;
@property (nonatomic, strong) UIButton *doubleBondBtn;
@property (nonatomic, strong) UIButton *TripleBondBtn;
@property (nonatomic,strong) UIButton *redo;
@property (nonatomic,strong) UIButton *clearAll;
@property (nonatomic,strong) UIButton *Save;
@property (nonatomic,strong) CYLAngleBtn *OtherAtom;
@property (nonatomic, strong) UIButton *selectedBtn;
//其他原子选着按钮
@property (nonatomic, strong) UIButton *NitroBtn;
@property (nonatomic, strong) UIButton *OxygenBtn;
@property (nonatomic, strong) UIButton *HydrogenBtn;
@property (nonatomic, strong) UIButton *ChlorineBtn;
@property (nonatomic, strong) UIButton *BromineBtn;
@property (nonatomic, strong) UIButton *FlourineBtn;
@property (nonatomic, strong) UIButton *SulferBtn;

@end

@implementation CYLToolBarView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self setUpUI];
        
        [self addObserverForBtns];
    }
    
    return self;
}


- (void)setUpUI
{
    _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectBtn.backgroundColor = [UIColor getColor:BackGroundColor];
    [_selectBtn setBackgroundImage:[UIImage imageNamed:@"RetroErasor"] forState:UIControlStateNormal];
    [_selectBtn addTarget:self action:@selector(Select) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_selectBtn];
    
    _DrawBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _DrawBtn.backgroundColor = [UIColor getColor:BackGroundColor];
    [_DrawBtn setBackgroundImage:[UIImage imageNamed:@"BondOne"] forState:UIControlStateNormal];
    [_DrawBtn addTarget:self action:@selector(draw) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_DrawBtn];
    
    _doubleBondBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _doubleBondBtn.backgroundColor = [UIColor getColor:BackGroundColor];
    [_doubleBondBtn setBackgroundImage:[UIImage imageNamed:@"BondTwo"] forState:UIControlStateNormal];
    [_doubleBondBtn addTarget:self action:@selector(DoubleBond) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_doubleBondBtn];
    
    _TripleBondBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _TripleBondBtn.backgroundColor = [UIColor getColor:BackGroundColor];
    [_TripleBondBtn setBackgroundImage:[UIImage imageNamed:@"BondThree"] forState:UIControlStateNormal];
    [_TripleBondBtn addTarget:self action:@selector(TripleBond) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_TripleBondBtn];
    
    _redo = [UIButton buttonWithType:UIButtonTypeCustom];
    _redo.backgroundColor = [UIColor getColor:BackGroundColor];
    [_redo setBackgroundImage:[UIImage imageNamed:@"MainUndo"] forState:UIControlStateNormal];
    [_redo addTarget:self action:@selector(retract) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_redo];
    
    _clearAll = [UIButton buttonWithType:UIButtonTypeCustom];
    _clearAll.backgroundColor = [UIColor getColor:BackGroundColor];
    [_clearAll setBackgroundImage:[UIImage imageNamed:@"MainDelete"] forState:UIControlStateNormal];
    [_clearAll addTarget:self action:@selector(clearAllPic) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_clearAll];
    
//    _Save = [UIButton buttonWithType:UIButtonTypeCustom];
//    _Save.backgroundColor = randomColor;
//    [_Save setTitle:@"redo" forState:UIControlStateNormal];
//    [_Save addTarget:self action:@selector(SavePic) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:_Save];
    
    _OtherAtom = [CYLAngleBtn buttonWithType:UIButtonTypeCustom];
    _OtherAtom.backgroundColor = [UIColor getColor:BackGroundColor];
    [_OtherAtom setTitle:@"A" forState:UIControlStateNormal];
    [_OtherAtom setImage:[UIImage imageNamed:@"triangle_down_55.095652173913px_1189852_easyicon.net"] forState:UIControlStateNormal];
    _OtherAtom.tag = 0;
    _OtherAtom.titleLabel.font = [UIFont systemFontOfSize:30];
    [_OtherAtom addTarget:self action:@selector(AddOtherAtom) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_OtherAtom];
    
    
    /***************************其它原子******************************/
    _NitroBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_NitroBtn setTitle:@"N" forState:UIControlStateNormal];
    _NitroBtn.backgroundColor = [UIColor getColor:BackGroundColor];
    [_NitroBtn setTitleColor:[UIColor getColor:NColor] forState:UIControlStateNormal];
    _NitroBtn.titleLabel.font = [UIFont systemFontOfSize:BtnTitleFont];
    [_NitroBtn addTarget:self action:@selector(otherAtomSeleced:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_NitroBtn];
    
    _OxygenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_OxygenBtn setTitle:@"O" forState:UIControlStateNormal];
    _OxygenBtn.backgroundColor = [UIColor getColor:BackGroundColor];
    [_OxygenBtn setTitleColor:[UIColor getColor:OColor] forState:UIControlStateNormal];
    _OxygenBtn.titleLabel.font = [UIFont systemFontOfSize:BtnTitleFont];
    [_OxygenBtn addTarget:self action:@selector(otherAtomSeleced:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_OxygenBtn];
    
    _HydrogenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_HydrogenBtn setTitle:@"H" forState:UIControlStateNormal];
    _HydrogenBtn.backgroundColor = [UIColor getColor:BackGroundColor];
    [_HydrogenBtn setTitleColor:[UIColor getColor:HColor] forState:UIControlStateNormal];
    _HydrogenBtn.titleLabel.font = [UIFont systemFontOfSize:BtnTitleFont];
    [_HydrogenBtn addTarget:self action:@selector(otherAtomSeleced:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_HydrogenBtn];
    
    _ChlorineBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_ChlorineBtn setTitle:@"Cl" forState:UIControlStateNormal];
    _ChlorineBtn.backgroundColor = [UIColor getColor:BackGroundColor];
    [_ChlorineBtn setTitleColor:[UIColor getColor:ClColor] forState:UIControlStateNormal];
    _ChlorineBtn.titleLabel.font = [UIFont systemFontOfSize:BtnTitleFont];
    [_ChlorineBtn addTarget:self action:@selector(otherAtomSeleced:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_ChlorineBtn];
    
    _BromineBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_BromineBtn setTitle:@"Br" forState:UIControlStateNormal];
    _BromineBtn.backgroundColor = [UIColor getColor:BackGroundColor];
    [_BromineBtn setTitleColor:[UIColor getColor:BrColor] forState:UIControlStateNormal];
    _BromineBtn.titleLabel.font = [UIFont systemFontOfSize:BtnTitleFont];
    [_BromineBtn addTarget:self action:@selector(otherAtomSeleced:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_BromineBtn];
    
    _FlourineBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_FlourineBtn setTitle:@"F" forState:UIControlStateNormal];
    _FlourineBtn.backgroundColor = [UIColor getColor:BackGroundColor];
    [_FlourineBtn setTitleColor:[UIColor getColor:FColor] forState:UIControlStateNormal];
    _FlourineBtn.titleLabel.font = [UIFont systemFontOfSize:BtnTitleFont];
    [_FlourineBtn addTarget:self action:@selector(otherAtomSeleced:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_FlourineBtn];
    
    _SulferBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_SulferBtn setTitle:@"S" forState:UIControlStateNormal];
    _SulferBtn.backgroundColor = [UIColor getColor:BackGroundColor];
    [_SulferBtn setTitleColor:[UIColor getColor:SColor] forState:UIControlStateNormal];
    _SulferBtn.titleLabel.font = [UIFont systemFontOfSize:BtnTitleFont];
    [_SulferBtn addTarget:self action:@selector(otherAtomSeleced:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_SulferBtn];

}

- (void)layoutSubviews
{
    [_DrawBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-5);
        make.left.equalTo(self).offset(3);
        make.width.height.mas_equalTo(44);
    }];
    
    [_selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-5);
        make.left.equalTo(self.DrawBtn.mas_right).offset(10);
        make.width.height.equalTo(self.DrawBtn);
    }];
    
    [_doubleBondBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-5);
        make.left.equalTo(self.selectBtn.mas_right).offset(10);
        make.width.height.equalTo(self.DrawBtn);
    }];
    
    [_TripleBondBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-5);
        make.left.equalTo(self.doubleBondBtn.mas_right).offset(10);
        make.width.height.equalTo(self.DrawBtn);
    }];
    
    [_OtherAtom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-5);
        make.left.equalTo(self.TripleBondBtn.mas_right).offset(10);
        make.width.height.equalTo(self.DrawBtn);
    }];
    
    [_redo  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-5);
        make.left.equalTo(self.OtherAtom.mas_right).offset(10);
        make.width.height.equalTo(self.DrawBtn);
    }];
    
    [_clearAll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-5);
        make.left.equalTo(self.redo.mas_right).offset(10);
        make.width.height.equalTo(self.DrawBtn);
    }];
    
    /***************************其它原子******************************/
    
    [_NitroBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.DrawBtn.mas_top).offset(-10);
        make.centerX.equalTo(self.DrawBtn.mas_centerX);
        make.width.height.mas_equalTo(44);
    }];
    
    [_OxygenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.NitroBtn.mas_right).offset(10);
        make.centerY.equalTo(self.NitroBtn.mas_centerY);
        make.width.height.equalTo(self.NitroBtn);
    }];
    
    [_HydrogenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.OxygenBtn.mas_right).offset(10);
        make.centerY.equalTo(self.NitroBtn.mas_centerY);
        make.width.height.equalTo(self.NitroBtn);
    }];
    
    [_ChlorineBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.HydrogenBtn.mas_right).offset(10);
        make.centerY.equalTo(self.NitroBtn.mas_centerY);
        make.width.height.equalTo(self.NitroBtn);
    }];
    
    [_BromineBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.ChlorineBtn.mas_right).offset(10);
        make.centerY.equalTo(self.NitroBtn.mas_centerY);
        make.width.height.equalTo(self.NitroBtn);
    }];
    
    [_FlourineBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.BromineBtn.mas_right).offset(10);
        make.centerY.equalTo(self.NitroBtn.mas_centerY);
        make.width.height.equalTo(self.NitroBtn);
    }];
    
    [_SulferBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.FlourineBtn.mas_right).offset(10);
        make.centerY.equalTo(self.NitroBtn.mas_centerY);
        make.width.height.equalTo(self.NitroBtn);
    }];
}

/**
 *  监听按钮的selected
 */
- (void)addObserverForBtns
{
    for (UIButton *btn in self.subviews) {
        
        [btn addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew context:nil];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(UIButton*)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if (object.selected == 1) {
        object.backgroundColor = [UIColor getColor:selectedBackGroudColor];
        
        for (UIButton *btn in self.subviews) {
            
            if (btn != object) {
                
                btn.selected = NO;
                
            }
            
        }
        
    }
    else
    {
        object.backgroundColor = [UIColor getColor:BackGroundColor];
    }
}

#pragma mark - 按钮店家方法
- (void)Select
{
    _selectedBtn = _selectBtn;
    _selectedBtn.selected = YES;
    if ([self.delegate respondsToSelector:@selector(toolBarDidClickSelectBtn)]) {
        [self.delegate toolBarDidClickSelectBtn];
    }
}

- (void)draw
{
    _selectedBtn = _DrawBtn;
    _selectedBtn.selected = YES;
    if ([self.delegate respondsToSelector:@selector(toolBarDidClickDrawBtn)]) {
        [self.delegate toolBarDidClickDrawBtn];
    }
    
}

- (void)DoubleBond
{
    _selectedBtn = _doubleBondBtn;
    _selectedBtn.selected = YES;
    
    if ([self.delegate respondsToSelector:@selector(toolBarDidClickDoubleBondBtn)]) {
        [self.delegate toolBarDidClickDoubleBondBtn];
    }
}

- (void)TripleBond
{
    _selectedBtn = _TripleBondBtn;
    _selectedBtn.selected = YES;
    
    if ([self.delegate respondsToSelector:@selector(toolBarDidClickTripleBondBtn)]) {
        [self.delegate toolBarDidClickTripleBondBtn];
    }
}

- (void)AddOtherAtom
{
    _selectedBtn = _OtherAtom;
    
    
    if (self.OtherAtom.tag == 0)
    {
        [self.OtherAtom setImage:[UIImage imageNamed:@"triangle_up_55.859649122807px_1189855_easyicon.net"] forState:UIControlStateNormal];
        
        self.OtherAtom.tag = 1;
    }
    else
    {
        [self.OtherAtom setImage:[UIImage imageNamed:@"triangle_down_55.095652173913px_1189852_easyicon.net"] forState:UIControlStateNormal];
        
        self.OtherAtom.tag = 0;
    }
    
    if ([self.delegate respondsToSelector:@selector(toolBarChoseOtherAtom)]) {
        [self.delegate toolBarChoseOtherAtom];
    }
    
}

- (void)retract
{
    _selectedBtn = _redo;
    
    if ([self.delegate respondsToSelector:@selector(toolBarDidClickReDoBtn)]) {
        [self.delegate toolBarDidClickReDoBtn];
    }
}

- (void)clearAllPic
{
    _selectedBtn = _clearAll;
    
    if ([self.delegate respondsToSelector:@selector(toolBarDidClickClearAllBtn)]) {
        [self.delegate toolBarDidClickClearAllBtn];
    }
}

- (void)otherAtomSeleced:(UIButton*)btn
{
    _selectedBtn = _OtherAtom;
    btn.selected = YES;
    
    if ([self.delegate respondsToSelector:@selector(toolBarDidClickAtomBtnWithAtomName: withColor:)]) {
        [self.delegate toolBarDidClickAtomBtnWithAtomName:btn.titleLabel.text withColor:btn.currentTitleColor];
    }
}

@end
