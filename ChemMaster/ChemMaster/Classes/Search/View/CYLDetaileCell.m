//
//  CYLNameReaCell.m
//  ChemMaster
//
//  Created by GARY on 16/7/24.
//  Copyright © 2016年 GARY. All rights reserved.
//

#import "CYLDetaileCell.h"

@interface CYLDetaileCell ()
@property (nonatomic, strong) UILabel *nameLable;
@property (nonatomic, strong) UIImageView *preImageView;
@property (nonatomic, strong) UIImage *picture;
@property (nonatomic, assign) CGSize imageSize;
@end

@implementation CYLDetaileCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        
        [self setUpUI];
    }
    
    return self;
}

- (void)setUpUI
{
    
    //设置内容
    _nameLable = [[UILabel alloc] init];
    _nameLable.textAlignment = NSTextAlignmentCenter;
    _nameLable.font = [UIFont systemFontOfSize:14];
    _nameLable.backgroundColor = [UIColor getColor:@"FAEBD7"];
    [self addSubview:_nameLable];
    
    _preImageView = [[UIImageView alloc] init];
    [_preImageView setContentMode:UIViewContentModeScaleAspectFit];
    [self addSubview:_preImageView];
}

- (void)layoutSubviews
{
//    [_nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self).offset(3);
//        make.left.right.equalTo(self);
//        make.height.mas_equalTo(20);
//    }];
//    
//
//    [_preImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.nameLable.mas_bottom).offset(3);
//        make.left.right.equalTo(self);
//        make.bottom.equalTo(self);
//    }];

    
    _nameLable.frame = CGRectMake(0, 3, self.frame.size.width, 20);
    
    CGFloat Y = CGRectGetMaxY(_nameLable.frame) + 3;
    _preImageView.frame = CGRectMake(0, Y, ScreenW, self.frame.size.height - Y);
}

-(void)setModel:(NSDictionary *)model
{
    _model = model;
    
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        
//        self.htmlData = [NSData dataWithContentsOfURL:[NSURL URLWithString:model[Takelink]]];
//    });
    
    if ([self.ModeIdentifier isEqualToString:nameReactionList])
    {
        [self setUpNameReactionListCell];
    }
    else if ([self.ModeIdentifier isEqualToString:totalSynList])
    {
        [self setUpTotalSynList];
    }
    else if ([self.ModeIdentifier isEqualToString:hightLight])
    {
        
    }
}

- (void)setUpNameReactionListCell
{
    self.nameLable.text = [self.model[TakeName] stringByAppendingString:@""];
    
    //取出图片
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"NameListPicture" ofType:@"bundle"];
    
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    
    NSData *picData = [NSData dataWithContentsOfFile:[bundle pathForResource:self.model[TakeName] ofType:nil]];
    
    _picture = [UIImage imageWithData:picData];
    
    self.preImageView.image = _picture;
}

- (void)setUpTotalSynList
{
    self.nameLable.text = [self.model[TakeName] stringByAppendingString:@""];
    
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"TotalSynPic" ofType:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    
    NSString *picName = [NSString stringWithFormat:@"%@-%@-%@", self.model[TakeName],self.model[TakeYear],self.model[TakeAuthor]];
    
    NSData *picData = [NSData dataWithContentsOfFile:[bundle pathForResource:picName ofType:nil]];
    
    self.preImageView.image = [UIImage imageWithData:picData];
}

- (void)setUpHighLightList
{
    
}

#pragma mark - 初始化方法
+ (instancetype)CellWithModeIdentifier:(NSString *)ModeID CellStyle:(UITableViewCellStyle)style andCellIdentifier:(NSString *)CellID CellName:(NSString *)cellName
{
    CYLDetaileCell *cell = [[CYLDetaileCell alloc] initWithStyle:style reuseIdentifier:CellID];
    
    cell.ModeIdentifier = ModeID;
    
    cell.nameLable.text = cellName;
    
    return cell;
}

@end