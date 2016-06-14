//
//  CYLEditorChoiseScrollView.m
//  ChemMaster
//
//  Created by GARY on 16/6/13.
//  Copyright © 2016年 GARY. All rights reserved.
//

#import "CYLHeaderReusableView.h"
#import "CYLEditorChociseModel.h"
#import <Masonry.h>
typedef NS_ENUM(NSInteger, CYLFont)
{
    CYLFontExtraSmall = 10,
    CYLFontsmall = 12,
    CYLFontNormal = 14,
    CYLFontSystem = 17,
    CYLFontLarge = 19,
};

@interface CYLHeaderReusableView ()<UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) UIPageControl *pageControll;

@property (nonatomic, strong) UIView *coverView;

@property (nonatomic, strong) NSMutableArray *scrollViewBtnArray;

//首页推荐文章的概述
@property (nonatomic,strong) UILabel *descLable;
//首页推荐文章的所属期刊
@property (nonatomic, strong) UILabel *journalLable;

@property (nonatomic ,assign) CGPoint lastContentOffSet;

@property (nonatomic,strong) NSArray *modelArray;

@property (nonatomic,strong) CYLEditorChociseModel *currentModel;

@end


@implementation CYLHeaderReusableView

#pragma mark - 懒加载
- (NSMutableArray *)scrollViewBtnArray
{
    if (_scrollViewBtnArray == nil) {
        _scrollViewBtnArray = [NSMutableArray array];
    }
    return _scrollViewBtnArray;
}

-(UILabel *)descLable
{
    if (_descLable == nil) {
        
        _descLable = [[UILabel alloc] init];
        _descLable.numberOfLines = 2;
        _descLable.textColor = [UIColor whiteColor];
        _descLable.font = [UIFont systemFontOfSize:CYLFontsmall];
        
        [self addSubview:_descLable];
    }
    return _descLable;
}

- (UILabel *)journalLable
{
    if (_journalLable == nil) {
        _journalLable = [[UILabel alloc] init];
        _journalLable.textColor = [UIColor yellowColor];
        _journalLable.font = [UIFont systemFontOfSize:CYLFontsmall];
        
        [self addSubview:_journalLable];
    }
    return _journalLable;
}

- (void)HeaderScrollViewWithModelArray:(NSArray *)modelArray
{
    _modelArray = modelArray;
    
    [self setUpScrollView];
    
    [self setUpCoverView];
    
    [self setUpPageControll];

    [self showAbstractWithIndex:0];
}

//设置scrollview
- (void)setUpScrollView
{
    _scrollView = [[UIScrollView alloc] init];
    
    NSInteger count = _modelArray.count;
    
    _scrollView.showsHorizontalScrollIndicator = NO;
    
    _scrollView.showsVerticalScrollIndicator = NO;
    
    _scrollView.pagingEnabled = YES;
    
    _scrollView.delegate = self;
    
    _scrollView.contentSize = CGSizeMake(count * self.frame.size.width, _scrollView.frame.size.height);
    
    [self addSubview:_scrollView];
    
    //设置srollview显示内容
    
    for (NSInteger i = 0; i < count; i ++) {
        
        CYLEditorChociseModel *model = _modelArray[i];
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            NSString *picPath = nil;
            
            //取出图片编号为0，既首页图片的路径
            for (NSDictionary *dict in model.tocGraphics) {
                
                if ([dict[@"imageOrder"] isEqual:[NSNumber numberWithInteger:0]]) {
                    picPath = dict[@"imageHighResRelativeURL"];
                }
            }
            
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://pubs.acs.org/editorschoice/%@",picPath]]];
        
           dispatch_async(dispatch_get_main_queue(), ^{
              
               UIButton *imageBtn = [[UIButton alloc] initWithFrame:CGRectMake(i * ScreenW, 0, ScreenW, self.scrollView.frame.size.height)];
               
               imageBtn.tag = i;
               
               [imageBtn setImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
               
               [imageBtn addTarget:self action:@selector(imageBtnDIdClick:) forControlEvents:UIControlEventTouchUpInside];
               
               [self.scrollView addSubview:imageBtn];
               
               [self.scrollViewBtnArray addObject:imageBtn];
           });
        });
    }
}

//设置pageControll
- (void)setUpPageControll
{
    NSInteger count = _modelArray.count;
    
    _pageControll = [[UIPageControl alloc] init];
    
    _pageControll.numberOfPages = count;
    
    _pageControll.currentPageIndicatorTintColor = [UIColor yellowColor];
    
    _pageControll.pageIndicatorTintColor = [UIColor lightGrayColor];
    
    [self addSubview:_pageControll];
}

//设置coverview
- (void)setUpCoverView
{
    _coverView = [[UIView alloc] init];
    [self addSubview:_coverView];
    _coverView.backgroundColor = [UIColor blackColor];
    _coverView.alpha = 0.8;
}

- (void)layoutSubviews
{
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(200);
    }];
    
    CGSize pageSize = [_pageControll sizeForNumberOfPages:_pageControll.numberOfPages];
    [_pageControll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_scrollView);
        make.width.mas_equalTo(pageSize.width);
        make.height.mas_equalTo(pageSize.height);
        make.bottom.equalTo(self.mas_bottom).offset(10);
    }];
    
    [_coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(60);
    }];
    
    [_journalLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.coverView);
        make.height.mas_equalTo(20);
    }];
    
//    [_descLable mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(self);
//        make.top.equalTo(_coverView).offset(2);
//        make.bottom.equalTo(_pageControll.mas_top).offset(12);
//    }];
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / ScreenW;
    
    [self showAbstractWithIndex:index];
    
    _pageControll.currentPage = index;
}

//scrollview显示对应推荐model的概述
- (void)showAbstractWithIndex:(NSInteger)index
{
    CYLEditorChociseModel *model = _modelArray[index];
    
    NSMutableDictionary *attribute = [NSMutableDictionary dictionary];
    
    attribute[NSFontAttributeName] = [UIFont systemFontOfSize:CYLFontsmall];
    
    CGRect rect = [model.articleAbstract boundingRectWithSize:CGSizeMake(ScreenW, _coverView.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil];
    
    self.journalLable.text = model.journal[@"abbrevJournalTitle"];
    
    self.descLable.frame = CGRectMake(0, _coverView.frame.origin.y + 5, rect.size.width, rect.size.height);
    
    self.descLable.text = model.articleAbstract;
    
}


#pragma mark - 点击scrollView推荐按钮后
- (void)imageBtnDIdClick:(UIButton*)btn
{
    CYLEditorChociseModel *model = self.modelArray[btn.tag];
    
    if ([self.delegate respondsToSelector:@selector(HeaderReusableView:didChoiceEditorModel:)]) {
        [self.delegate HeaderReusableView:self didChoiceEditorModel:model];
    }
}

@end









