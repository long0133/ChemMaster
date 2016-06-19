//
//  CYLDrawView.m
//  ChemMaster
//
//  Created by GARY on 16/6/18.
//  Copyright © 2016年 GARY. All rights reserved.
//

#import "CYLDrawView.h"
#import "CYLToolBarView.h"

#define CTLRadius 25.0
#define CYLSuggestLength 50
@interface CYLDrawView ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) CYLToolBarView *tooBarView;

@property (nonatomic, assign) CGMutablePathRef path;

@property (nonatomic, strong) NSMutableArray *pathArray;

@property (nonatomic, assign) CGContextRef ContextRef;

@property (nonatomic, strong) UIPanGestureRecognizer *pan;

@property (nonatomic, assign) CGPoint startP;
@property (nonatomic, assign) CGPoint endP;

//存储每条线的双端点
@property (nonatomic, strong) NSMutableArray *pointArray;

//方便识别那一个点目前被选到
@property (nonatomic,strong) UIView *HighLightView;
//方便识别线段端点将会依附在哪一个点上
@property (nonatomic,strong) UIView *AttachView;
@property (nonatomic,assign) CGPoint AttachPoint;

//给出建议化学键的方向线段
@property (nonatomic, assign) CGMutablePathRef suggestBondPath;

@end

@implementation CYLDrawView
- (void)drawRect:(CGRect)rect {
    
    self.ContextRef = UIGraphicsGetCurrentContext();
    
    CGContextAddPath(self.ContextRef, self.path);
    
    //画出建议的化学键
//    CGContextAddPath(self.ContextRef, self.suggestBondPath);
    
    if (self.pathArray.count) {
        
        for (NSInteger i = 0;  i < self.pathArray.count; i ++) {
            
            CGContextAddPath(self.ContextRef, (__bridge CGMutablePathRef)self.pathArray[i]);
        }
    }
    CGContextSetLineWidth(self.ContextRef, 3);
    
    CGContextStrokePath(self.ContextRef);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self tooBarView];
        [self setUpFunction];
    }
    return self;
}

-(void)setUpFunction
{
    self.pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    
    self.pan.delegate = self;
    
    [self addGestureRecognizer:self.pan];
}

#pragma mark - pan手势
- (void)pan:(UIPanGestureRecognizer*)pan
{
    CGPoint curP = [pan locationInView:self];
    

    if (_pan.state == UIGestureRecognizerStateBegan) {
        
        //初始化attachPoint
        _AttachPoint = CGPointZero;
        _path = NULL;
        
        _startP = curP;
        
        //判断起点与任意一条线的双端是否住够近 选出起点
        for (NSValue *value in self.pointArray) {
            
            CGPoint point = value.CGPointValue;
            
            if ([self isStartPoint:_startP aroundPoint:point WithRadius:CTLRadius]) {
                
                //如果与某个点很近 则显示高亮图片 并以此为起点
                [self showHightViewOnPoint:point];
                
                _startP = point;
            }
        }
        
        //遍历每个点，给出建议化学键的线条
//        for (NSValue *value in self.pointArray) {
//            
//            CGPoint point = value.CGPointValue;
//            
//            //如果此起点与另外一个点在建议距离内，则显示建议化学键Path所画的线条
//            if ([self isStartPoint:_startP aroundPoint:point WithRadius:CYLSuggestLength]) {
//
//                self.suggestBondPath = CGPathCreateMutable();
//                
//                CGPathMoveToPoint(self.suggestBondPath, nil, _startP.x, _startP.y);
//                CGPathAddLineToPoint(self.suggestBondPath, nil, point.x, point.y);
//                
//                [self setNeedsDisplay];
//            }
//            
//        }
    }
    else if (_pan.state == UIGestureRecognizerStateChanged)
    {
        
        //创建负责释放的指针
        CGMutablePathRef OldPath = _path;
        
        if (OldPath != NULL) {
            
            CGPathRelease(OldPath);
            
        }
        
        //当前操作的线条
        _path = CGPathCreateMutable();
        
        CGPathMoveToPoint(_path, nil, _startP.x, _startP.y);
        CGPathAddLineToPoint(_path, nil, curP.x, curP.y);
        
        
        //当前点与某一个点足够近且此点非起点时，显示attachView
        for (NSValue *value  in self.pointArray) {
            
            CGPoint point = value.CGPointValue;
            
            if ([self isStartPoint:curP aroundPoint:point WithRadius:CTLRadius] && !CGPointEqualToPoint(point, _startP)) {
            
                [self showAttachViewOnPoint:point];
                
                self.AttachPoint = point;
            }
            else if (![self isStartPoint:curP aroundPoint:self.AttachPoint WithRadius:CTLRadius])
            {
                //如果移开 则移除attachview 并且attachPoint = (0,0)
                [self dismissAttachView];
                self.AttachPoint = CGPointZero;
            }
        }
        
        [self setNeedsDisplay];
    }
    else if (pan.state == UIGestureRecognizerStateEnded)
    {
        _endP = curP;
        
        //松手后判断是否连接到attachPoint上
        if (!CGPointEqualToPoint(_AttachPoint, CGPointZero)) {
            
            //释放原来path 创建新的path
            CGPathRelease(_path);
            _path = CGPathCreateMutable();
            
            //修正更改后线段的端点
            _endP = _AttachPoint;
            
            CGPathMoveToPoint(_path, nil, _startP.x, _startP.y);
            CGPathAddLineToPoint(_path, nil, _AttachPoint.x, _AttachPoint.y);
        }

            //缓存画好的path
            [self.pathArray addObject:(__bridge id _Nonnull)(_path)];
        
        
        //存储每条线的双端
        [self.pointArray addObject:[NSValue valueWithCGPoint:_endP]];
        [self.pointArray addObject:[NSValue valueWithCGPoint:_startP]];
        
        [self dismissHightLightView];
        [self dismissAttachView];
        
        //松手后，建议线条消失

        [self setNeedsDisplay];
//        CGPathRelease(self.suggestBondPath);
        CGPathRelease(self.path);
    }
    
}


#pragma mark - 懒加载
- (CYLToolBarView *)tooBarView
{
    if (_tooBarView == nil) {
        _tooBarView = [[CYLToolBarView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width / 4, self.frame.size.height)];
        [self addSubview:_tooBarView];
        _tooBarView.backgroundColor = [UIColor lightGrayColor];
    }
    return _tooBarView;
}

- (NSMutableArray *)pathArray
{
    if (_pathArray == nil) {
        _pathArray = [NSMutableArray array];
    }
    return _pathArray;
}

- (UIView *)HighLightView
{
    if (_HighLightView == nil) {
        _HighLightView = [[UIView alloc] init];
        _HighLightView.backgroundColor = [UIColor yellowColor];
        _HighLightView.layer.cornerRadius = CTLRadius / 2;
        [self addSubview:_HighLightView];
    }
    return _HighLightView;
}

- (NSMutableArray *)pointArray
{
    if (_pointArray == nil) {
        _pointArray = [NSMutableArray array];
    }
    return _pointArray;
}

- (UIView *)AttachView
{
    if (_AttachView == nil) {
        _AttachView = [[UIView alloc] init];
        _AttachView.backgroundColor = [UIColor orangeColor];
        _AttachView.layer.cornerRadius = CTLRadius / 2;
        [self addSubview:_AttachView];
    }
    return _AttachView;
}

#pragma mark - 自定义function
- (BOOL)isStartPoint:(CGPoint)Startpoint aroundPoint:(CGPoint)point WithRadius:(CGFloat)radius
{
    CGFloat SPx = Startpoint.x;
    CGFloat SPy = Startpoint.y;
    
    CGFloat Px = point.x;
    CGFloat Py = point.y;
    
    CGFloat distance = sqrt(pow((SPx - Px), 2) + pow((SPy - Py), 2));
    
    return distance <= radius ? YES : NO;
}

- (void)showHightViewOnPoint:(CGPoint)point
{
    self.HighLightView.frame = CGRectMake(0, 0, CTLRadius,CTLRadius);
    self.HighLightView.center = point;
}

- (void)dismissHightLightView
{
    [self.HighLightView removeFromSuperview];
    self.HighLightView = nil;
}

- (void)showAttachViewOnPoint:(CGPoint)point
{
    self.AttachView.frame = CGRectMake(0, 0, CTLRadius,CTLRadius);
    self.AttachView.center = point;
}

- (void)dismissAttachView
{
    [self.AttachView removeFromSuperview];
    self.AttachView = nil;
}

@end
