//
//  CYLTileButton.m
//  ChemMaster
//
//  Created by GARY on 16/9/12.
//  Copyright © 2016年 GARY. All rights reserved.
//

#import "CYLTileButton.h"

#define contentBtnMargin 3
#define ContentBtnScale 6
#define notAllowDelete 9999
#define backGroudColor [UIColor getColor:@"558898"]
#define baseBtnColor [UIColor getColor:@"F2DCCF"]
#define contentBtnColor [UIColor getColor:@"FF847C"]
//九宫格
static int NinePathX[] = {0,-1,-1,-1,0,1,1,1};
static int NinePathY[] = {-1,-1,0,1,1,1,0,-1};
//十二格
static int twelvePathX[] = {-1,0,1,2,2,2,2,1,0,-1,-1,-1};
static int twelvePathY[] = {-1,-1,-1,-1,0,1,2,2,2,2,1,0};

static int twelvePathXType1[] = {0,0,0,0,1,2,3,3,3,3,2,1};
static int twelvePathYType1[] = {0,1,2,3,3,3,3,2,1,0,0,0};

static CGFloat width = 0;
static int count;


@interface CYLTileButton ()

@property (nonatomic, strong) NSMutableArray *btnArray;

@property (nonatomic, strong) UIView *superView;

@property (nonatomic, assign) CGRect originFrame;

@property (nonatomic, strong) UIColor *originColor;

@property (nonatomic, strong) NSMutableArray *nameArray;

@property (nonatomic, strong) UILabel *titleLable;

@property (nonatomic, strong) UIButton *BaseButton;

@property (nonatomic, copy) NSString *originText;

//在初始动画完成后，覆盖在self上，防止再次点击self
@property (nonatomic, strong) UIView *coverView;

@end

@implementation CYLTileButton

#pragma mark - 显示动画self移动到中间,动画完成后调用anim的delegate
- (void)showAnimationAtPoint:(CGPoint)point onView:(UIView *)view andDelay:(CGFloat)delay
{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.layer removeAllAnimations];
        
        _originFrame = self.frame;
        width = self.frame.size.width;
        _superView = view;
        _originColor = self.backgroundColor;
        _originText = self.titleLabel.text;
        count = 0;
        
        CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"position"];
        anim.toValue = [NSValue valueWithCGPoint:point];
        anim.duration = .3;
        anim.removedOnCompletion = NO;
        anim.fillMode = kCAFillModeForwards;
        anim.delegate = self;
        [self.layer addAnimation:anim forKey:@"position"];
    });
}

#pragma mark - 添加子按钮
- (void)addContentBtnWithBaseView:(UIView*)baseView
{
    CGFloat height = (_superView.frame.size.height - baseView.frame.size.height)/ContentBtnScale;
    
    
    //添加内容btn
    for (NSInteger i = 0; i < self.contentArray.count; i++) {
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(width/2 - height/2, width/2 - height/2, height - contentBtnMargin, height - contentBtnMargin)];
        
        [btn addTarget:self action:@selector(showDetail:) forControlEvents:UIControlEventTouchUpInside];
        
        [btn setTitle:_nameArray[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:7];
        btn.titleLabel.numberOfLines = 0;
        
        btn.contentMode = UIViewContentModeScaleAspectFit;
        
        btn.tag = i;
        btn.backgroundColor = contentBtnColor;
        
        [self.btnArray addObject:btn];
        [self addSubview:btn];
        
        [self setButtonAnimation:btn withbaseView:baseView];
    }
}

#pragma mark - 子按钮点击显示详细内容
- (void)showDetail:(UIButton*)btn
{
     NSLog(@"%s", __func__);
}

//内容按钮从中间出来的动画
- (void)setButtonAnimation:(UIButton*)btn withbaseView:(UIView*)baseView
{
    CGFloat height = (_superView.frame.size.height - baseView.frame.size.height)/ContentBtnScale;
    
    NSInteger amendX = twelvePathXType1[btn.tag];
    NSInteger amendY = twelvePathYType1[btn.tag];
    
    CGFloat x = amendX * height + contentBtnMargin;
    CGFloat y = amendY * height + contentBtnMargin;
    
    //修正位置 隔出空格
    y -= contentBtnMargin/2;

    x -= contentBtnMargin/2;

    [UIView animateWithDuration:.5 animations:^{
        btn.frame = CGRectMake(x, y, height - contentBtnMargin, height - contentBtnMargin);
    
    } completion:^(BOOL finished) {
        
        [btn addTarget:self action:@selector(showDetail:) forControlEvents:UIControlEventTouchUpInside];
        
    }];

}

#pragma mark - 大按钮复位，回收congtentBtn
- (void)backToOrigin
{
    //回收contentBtn
    [self takeBackAllContentBtn];
    
    [self.layer removeAllAnimations];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        [UIView animateWithDuration:.3 animations:^{
            
            //先缩放
            self.transform = CGAffineTransformMakeScale(1, 1);
            
            self.backgroundColor = _originColor;
            
            [self setTitle:_originText forState:UIControlStateNormal];
            
        } completion:^(BOOL finished) {
           
            [UIView animateWithDuration:.3 animations:^{
                
                //再回到原位
                self.frame = _originFrame;
                
            } completion:^(BOOL finished) {
                
                //动画完成后修正frame
                self.frame = _originFrame;
                
            }];
            
        }];
        
    });

}

- (void)takeBackAllContentBtn
{
    for (UIView *btn in self.subviews) {
        
        if (([btn isKindOfClass:[UIButton class]]) && (btn.tag != notAllowDelete)) {
            
            CABasicAnimation *anim = [CABasicAnimation animation];
            anim.keyPath = @"position";
            anim.toValue = [NSValue valueWithCGPoint:CGPointMake(width/2, width/2)];
            anim.fillMode = kCAFillModeForwards;
            anim.removedOnCompletion = NO;
            anim.duration = .3;
            
            [btn.layer addAnimation:anim forKey:@"position"];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [btn removeFromSuperview];
            });
        }
    }
}

- (void)setContentBundle:(NSBundle *)contentBundle
{
    _contentBundle = contentBundle;
    
    NSArray *paths = [contentBundle pathsForResourcesOfType:@"gif" inDirectory:nil];
    
    NSMutableArray *array = [NSMutableArray array];
    _nameArray = [NSMutableArray array];
    
    for (NSString *path in paths) {
        
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        
        [array addObject:image];
        
        NSString *name = path.lastPathComponent;
        
        name = [name stringByReplacingOccurrencesOfString:@".gif" withString:@""];
        
        [_nameArray addObject:name];
    }
    
    self.contentArray = array;
}


#pragma mark - 点击中心按钮后返回原位
- (void)clickBack
{
    [self.BaseButton removeFromSuperview];
    self.BaseButton = nil;
    
    [self.coverView removeFromSuperview];
    self.coverView = nil;
    
    if ([self.delegate respondsToSelector:@selector(tileBtnDidClickBackBtn)]) {
        [self.delegate tileBtnDidClickBackBtn];
    }
    
    [self backToOrigin];
}

#pragma mark - 懒加载
- (UIView *)coverView
{
    if (_coverView == nil) {
        _coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _superView.frame.size.width, _superView.frame.size.width)];
        [self insertSubview:_coverView atIndex:0];
    }
    return _coverView;
}

-(UIButton *)BaseButton
{
    if (_BaseButton == nil) {
        _BaseButton = [[UIButton alloc] init];
        _BaseButton.backgroundColor = baseBtnColor;
        _BaseButton.tag = notAllowDelete;
        [_BaseButton setTitle:@"Back" forState:UIControlStateNormal];
        _BaseButton.titleLabel.font = [UIFont systemFontOfSize:20];
        [_BaseButton addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_BaseButton];
    }
    return _BaseButton;
}

-(NSArray *)contentArray
{
    if (_contentArray == nil) {
        _contentArray = [NSArray array];
    }
    return _contentArray;
}

- (NSMutableArray *)btnArray
{
    if (_btnArray == nil) {
        _btnArray = [NSMutableArray array];
    }
    return _btnArray;
}

-(UILabel *)titleLable
{
    if (_titleLable == nil) {
        _titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.width/2, self.frame.size.width, 30)];
        [self addSubview:_titleLable];
    }
    return _titleLable;
}

#pragma mark - delegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    
    if (count && flag) {
        
        
    }
    else if(count == 0 && flag)  //移动到中间时
    {
        count = 1;
        
        [UIView animateWithDuration:.3 animations:^{
            
            //self放大至父控件大小
            CGFloat scale = _superView.frame.size.width / self.frame.size.width;
            self.transform = CGAffineTransformMakeScale(scale, scale);
            
            self.backgroundColor = backGroudColor;
            
        } completion:^(BOOL finished) {
    
            self.frame = _superView.frame;
            //完成动画后，添加coverview，且在self的中心添加按钮
            [self setTitle:nil forState:UIControlStateNormal];
            
            self.coverView.backgroundColor = [UIColor clearColor];
            
            self.BaseButton.frame = CGRectMake(width/4, width/4 , width/2 , width/2);
            
            [self addContentBtnWithBaseView:self.BaseButton];
            
        }];
        
    }
}

@end
