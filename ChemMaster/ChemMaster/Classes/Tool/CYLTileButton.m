//
//  CYLTileButton.m
//  ChemMaster
//
//  Created by GARY on 16/9/12.
//  Copyright © 2016年 GARY. All rights reserved.
//

#import "CYLTileButton.h"

//九宫格
static int NinePathX[] = {0,-1,-1,-1,0,1,1,1};
static int NinePathY[] = {-1,-1,0,1,1,1,0,-1};
//十二格
static int twelvePathX[] = {-1,0,1,2,2,2,2,1,0,2,1,-1};
static int twelvePathY[] = {-1,-1,-1,-1,0,1,2,2,2,0,0,0};

static CGFloat width = 0;
static int count;


@interface CYLTileButton ()

@property (nonatomic, strong) NSMutableArray *btnArray;

@property (nonatomic, strong) UIView *superView;

@property (nonatomic, assign) CGRect originFrame;

@end

@implementation CYLTileButton

#pragma mark - 显示动画，生成cell
- (void)showAnimationAtPoint:(CGPoint)point onView:(UIView *)view
{
    [self.layer removeAllAnimations];
    
    _originFrame = self.frame;
    width = self.frame.size.width;
    _superView = view;
    count = 0;
    
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"position"];
    anim.toValue = [NSValue valueWithCGPoint:point];
    anim.duration = .5;
    anim.removedOnCompletion = NO;
    anim.fillMode = kCAFillModeForwards;
    anim.delegate = self;
    [self.layer addAnimation:anim forKey:@"position"];
    
    [self addContentBtn];
}

- (void)addContentBtn
{
    CGFloat height = (_superView.frame.size.height - self.frame.size.height)/2;
    
    //添加内容btn
    for (NSInteger i = 0; i < self.contentArray.count; i++) {
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(width/2, width/2, height, height)];
        btn.tag = i;
        btn.backgroundColor = randomColor;
        [self addSubview:btn];
        
        [self setButtonAnimation:btn];
    }
}

//内容按钮从中间出来的动画
- (void)setButtonAnimation:(UIButton*)btn
{
    CGPoint basePoint = CGPointMake(0,0);
    
    CGFloat height = (_superView.frame.size.height - self.frame.size.height)/2;
    
    CGFloat x = basePoint.x + twelvePathX[btn.tag] * height;
    CGFloat y = basePoint.y + twelvePathY[btn.tag] * height;
    
    [UIView animateWithDuration:.5 animations:^{
        btn.frame = CGRectMake(x, y, height, height);
    } completion:^(BOOL finished) {
        
    }];

}

#pragma mark - 大按钮复位，回收congtentBtn
- (void)backToOrigin
{
    //回收contentBtn
    [self takeBackAllContentBtn];
    
    [self.layer removeAllAnimations];
    CABasicAnimation *anim = [CABasicAnimation animation];
    anim.keyPath = @"position";
    CGPoint center = CGPointMake(_originFrame.origin.x + width/2, _originFrame.origin.y + width/2);
    anim.toValue = [NSValue valueWithCGPoint:center];
    anim.duration = .5;
    anim.delegate = self;
    anim.fillMode = kCAFillModeForwards;
    anim.removedOnCompletion = NO;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.layer addAnimation:anim forKey:@"position"];
    });

}

- (void)takeBackAllContentBtn
{
    for (UIButton *btn in self.subviews) {
        
        CABasicAnimation *anim = [CABasicAnimation animation];
        anim.keyPath = @"position";
        anim.toValue = [NSValue valueWithCGPoint:CGPointMake(width/2, width/2)];
        anim.fillMode = kCAFillModeForwards;
        anim.removedOnCompletion = NO;
        anim.duration = .5;
        [btn.layer addAnimation:anim forKey:@"position"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [btn removeFromSuperview];
        });

    }
}


#pragma mark - 懒加载
-(NSArray *)contentArray
{
    if (_contentArray == nil) {
        _contentArray = @[@"A",@"A",@"s",@"a",@"s",@"s",@"s",@"s",@"s",@"s"];
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

#pragma mark - delegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    
    if (count) {
        
        //动画到页面中间
        self.frame = CGRectMake(_originFrame.origin.x, _originFrame.origin.y, width, width);
    }
    else if(count == 0)
    {
        count = 1;
        self.frame = CGRectMake(width/2, width/2 , width, width);
        
        
    }
}
@end
