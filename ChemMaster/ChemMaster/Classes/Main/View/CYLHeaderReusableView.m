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
#import <UIButton+WebCache.h>
#import <UIImageView+WebCache.h>
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

@property (nonatomic, strong) UIButton *lastImgBtn;

//首页推荐文章的概述
@property (nonatomic,strong) UILabel *descLable;
//首页推荐文章的所属期刊
@property (nonatomic, strong) UILabel *journalLable;

@property (nonatomic ,assign) CGPoint lastContentOffSet;

@property (nonatomic,strong) NSArray *modelArray;

@property (nonatomic,strong) CYLEditorChociseModel *currentModel;

@property (nonatomic, strong) NSArray *sortedArray;

@end


@implementation CYLHeaderReusableView

- (instancetype)initWithFrame:(CGRect)frame
{
    NSTimer *timer = [NSTimer timerWithTimeInterval:4 target:self selector:@selector(rollTheImage) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
   return [super initWithFrame:frame];
}

- (void)rollTheImage
{
    CGPoint offSet = self.scrollView.contentOffset;
    
    offSet.x += ScreenW;
    
    [self.scrollView setContentOffset:offSet animated:YES];
    self.pageControll.currentPage = offSet.x / ScreenW;
    [self showAbstractWithIndex:_pageControll.currentPage];
    
    if (self.scrollView.contentOffset.x >= self.scrollView.contentSize.width - ScreenW) {
        [self.scrollView setContentOffset:CGPointZero animated:YES];
        self.pageControll.currentPage = 0;
        [self showAbstractWithIndex:_pageControll.currentPage];
    }
    
    _currentPage = offSet.x / ScreenW - 1;
    
}

- (void)HeaderScrollViewWithModelArray:(NSArray *)modelArray
{
    _modelArray = modelArray;
    
    [self setUpScrollView];
    
    [self setUpCoverView];
    
    [self setUpPageControll];

    [self showAbstractWithIndex:0];
}

#pragma mark - 获取json数据
//设置scrollview
- (void)setUpScrollView
{
    
    [self scrollView];
    
    NSInteger count = _modelArray.count;
    
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
            
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
            
               UIButton *imageBtn = [[UIButton alloc] initWithFrame:CGRectMake(i * ScreenW, 0, ScreenW, self.scrollView.frame.size.height)];

                imageBtn.tag = i;
                
                NSString *imageUrl = [NSString stringWithFormat:@"http://pubs.acs.org/editorschoice/%@",picPath];
                
                [imageBtn sd_setImageWithURL:[NSURL URLWithString:imageUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placehoder"]];
                
                [imageBtn addTarget:self action:@selector(imageBtnDIdClick:) forControlEvents:UIControlEventTouchUpInside];
                
                imageBtn.backgroundColor = [UIColor whiteColor];
                
                [self.scrollViewBtnArray addObject:imageBtn];
                
                //排序子控件
                self.sortedArray = [self.scrollViewBtnArray sortedArrayWithOptions:NSSortStable usingComparator:^NSComparisonResult(UIButton *  _Nonnull obj1, UIButton *  _Nonnull obj2) {
                    
                    if (obj1.tag > obj2.tag) {
                        return NSOrderedDescending;
                    }
                    return NSOrderedAscending;
                }];
                
                //确保imagebtn在scrollView的subviews里只有一份
                
                if (self.sortedArray.count == editorsChoiceNum) {
                    
                    for (UIButton *btn in self.sortedArray) {
                      
                        [self.scrollView addSubview:btn];
                        
                    }
                }
            });
        });
    }
}

//设置pageControll
- (void)setUpPageControll
{
    [self pageControll];
}

//设置coverview
- (void)setUpCoverView
{
    [self coverView];
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
        make.top.right.equalTo(self.coverView);
        make.left.equalTo(self.coverView).offset(5);
        make.height.mas_equalTo(20);
    }];
    
    [_descLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(_coverView).offset(15);
        make.bottom.equalTo(_pageControll.mas_top).offset(12);
    }];
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / ScreenW;
    
    [self showAbstractWithIndex:index];
    
    _pageControll.currentPage = index;
    
    _currentPage = index;
    
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self scrollViewDidEndDecelerating:scrollView];
}

//scrollview显示对应推荐model的概述
- (void)showAbstractWithIndex:(NSInteger)index
{
    
    if (index < 7) {
        
        CYLEditorChociseModel *model = _modelArray[index];
        
        self.journalLable.text = model.journal[@"abbrevJournalTitle"];
        
        //处理概述文字
        NSString *descString = [model.articleAbstract stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
        
        descString = [descString stringByReplacingOccurrencesOfString:@"\t" withString:@" "];
        descString = [descString stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
        descString = [descString stringByReplacingOccurrencesOfString:@"&#x" withString:@" "];
        descString = [descString stringByReplacingOccurrencesOfString:@";" withString:@" "];
        descString = [NSString stringWithFormat:@"\t%@",descString];
        descString = [descString flattenHTML:descString trimWhiteSpace:NO];
        
        model.articleAbstract = descString;
        
        //显示论文标题
        model.title = [model.title flattenHTML:model.title trimWhiteSpace:NO];
        self.descLable.text = model.title;
    }
    
}


#pragma mark - 点击scrollView推荐按钮后
- (void)imageBtnDIdClick:(UIButton*)btn
{
    CYLEditorChociseModel *model = self.modelArray[btn.tag];
    
    btn.userInteractionEnabled = NO;
    
    if ([self.delegate respondsToSelector:@selector(HeaderReusableView:didChoiceEditorModel:andSubviews:andCurrentPage:)]) {
        [self.delegate HeaderReusableView:self didChoiceEditorModel:model andSubviews:self.scrollView.subviews andCurrentPage:btn.tag];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        btn.userInteractionEnabled = YES;
    });
}

- (NSMutableArray *)getScrollViewSubviews
{
    
    return self.scrollViewBtnArray;
}

#pragma mark - 懒加载

- (UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        
        NSInteger count = _modelArray.count;
        
        _scrollView.showsHorizontalScrollIndicator = NO;
        
        _scrollView.showsVerticalScrollIndicator = NO;
        
        _scrollView.pagingEnabled = YES;
        
        _scrollView.delegate = self;
        
        _scrollView.contentSize = CGSizeMake(count * self.frame.size.width, _scrollView.frame.size.height);
        
        [self addSubview:_scrollView];
        
    }
    return _scrollView;
}

- (UIPageControl *)pageControll
{
    if (_pageControll == nil) {
        
        NSInteger count = _modelArray.count;
        
        _pageControll = [[UIPageControl alloc] init];
        
        _pageControll.numberOfPages = count;
        
        _pageControll.currentPageIndicatorTintColor = [UIColor yellowColor];
        
        _pageControll.pageIndicatorTintColor = [UIColor whiteColor];
        
        [self addSubview:_pageControll];
        
    }
    return _pageControll;
}

- (UIView *)coverView
{
    if (_coverView == nil)
    {
        _coverView = [[UIView alloc] init];
        [self addSubview:_coverView];
        _coverView.backgroundColor = [UIColor blackColor];
        _coverView.alpha = 0.8;
        
    }
    return _coverView;
}

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

@end









