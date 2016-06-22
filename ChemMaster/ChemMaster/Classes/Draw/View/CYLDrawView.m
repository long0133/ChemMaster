//
//  CYLDrawView.m
//  ChemMaster
//
//  Created by GARY on 16/6/18.
//  Copyright © 2016年 GARY. All rights reserved.
//

#import "CYLDrawView.h"
#import "CYLToolBarView.h"
#import "CYLChemicalBond.h"

//highlightView 和 AttachView的半径
#define CTLRadius 20.0
//距离点多远时显示AttachView
#define CYLSuggestDistance 30
//建议的化学键键长
#define CYLSuggestBondLength 60



@interface CYLDrawView ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) CYLToolBarView *tooBarView;

@property (nonatomic, strong) CYLChemicalBond *bond;

@property (nonatomic, strong) CYLChemicalBond *lastBond;

@property (nonatomic, assign) CGContextRef ContextRef;

@property (nonatomic, strong) UIPanGestureRecognizer *pan;
@property (nonatomic, strong) UITapGestureRecognizer *tap;

@property (nonatomic, strong) NSMutableArray *BondArray;
//存储每条线的双端点
@property (nonatomic, strong) NSMutableArray *pointArray;

@property (nonatomic, strong) NSMutableArray *atomArray;

//方便识别那一个点目前被选到
@property (nonatomic,strong) UIView *HighLightView;
//方便识别线段端点将会依附在哪一个点上
@property (nonatomic,strong) UIView *AttachView;

//给出建议化学键的方向线段
@property (nonatomic, strong) UIBezierPath *suggestPath;

@property (nonatomic, strong) NSMutableArray *beArray;

@end

@implementation CYLDrawView
- (void)drawRect:(CGRect)rect {
    
    self.ContextRef = UIGraphicsGetCurrentContext();
    
    //画出实时的线条
    self.bond.bezierPath.lineWidth = 4;
    [self.bond.bezierPath stroke];
    
    //画出历史的线条
    for (CYLChemicalBond *bond in self.BondArray) {
        
        bond.bezierPath.lineWidth = 4;
        [bond.bezierPath stroke];
        
    }
    
    [self.suggestPath fill];
    
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
//    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    
    self.tap.delegate = self;
    self.pan.delegate = self;
    
    [self addGestureRecognizer:self.pan];
//    [self addGestureRecognizer:self.tap];
}

-(NSMutableArray *)beArray
{
    if (_beArray == nil) {
        _beArray = [NSMutableArray array];
    }
    return _beArray;
}
#pragma mark - tap手势 单击某一个原子时，自动画出合适长度，合适角度的化学键
#if 0
- (void)tap:(UITapGestureRecognizer*)tap
{
     //单击某一个原子时，自动画出合适长度，合适角度的化学键
    CGPoint tapPoint = [tap locationInView:self];
    
    //新创建的化学键
    CYLChemicalBond *NewBond = nil;
    CGFloat assitanceX = 0;
    CGFloat assistanceY = 0;
    CGFloat assistancAngle = 0;
    CGFloat wantedAngle = 0;
    CGFloat wangtedX = 0;
    CGFloat wangtedY = 0;
    CGFloat L = 0;
    
    
    for (CYLChemicalBond *bond in self.BondArray) {
        
        //tap点击住够近时，修正tap点的位置
        if ([self isStartPoint:tapPoint aroundPoint:bond.startP WithRadius:CTLRadius])
        {
            tapPoint = bond.startP;
        }
        else if ([self isStartPoint:tapPoint aroundPoint:bond.endP WithRadius:CTLRadius])
        {
            tapPoint = bond.endP;
        }
        else
        {
            tapPoint = [tap locationInView:self];
        }
        
        if (CGPointEqualToPoint(bond.startP, tapPoint)) { //点击了startPoint
            
            L = sqrt(pow((bond.startP.x - bond.endP.x), 2) + pow((bond.startP.y - bond.endP.y), 2));
            assitanceX = 2 * bond.startP.x - bond.endP.x;
            assistanceY = 2 * bond.startP.y - bond.endP.y;
            
            if (bond.startP.x <= bond.endP.x) {
                
                if (bond.startP.y <= bond.endP.y) {
                    
                    NSLog(@" < < sp ");
                    // spx < epx spy < epy 点击了sp
                    NewBond = [CYLChemicalBond CreatChemicalBondWithCarbon];
                    
                    assistancAngle = atan(ABS(assistanceY - bond.startP.y) / ABS(assitanceX - bond.startP.x));
                    wantedAngle = M_PI / 6 - assistancAngle;
                    
                    wangtedX = bond.startP.x - (L * sin(wantedAngle));
                    wangtedY = bond.startP.y - (L * cos(wantedAngle));
                    
                    NSLog(@"(%f %f) \n (%f %f) \n (%f %f) \n %f %f %f %f %f",bond.startP.x, bond.startP.y,bond.endP.x, bond.endP.y ,assitanceX, assistanceY, assistancAngle * 180.0 / M_PI, wantedAngle * 180.0 / M_PI, wangtedX, wangtedY, L);
                }
                else
                {
                    // spx < epx spy > epy 点击了sp
                    NewBond = [CYLChemicalBond CreatChemicalBondWithCarbon];
                    NSLog(@" < > sp ");
                    
                    assistancAngle = atan(ABS(assistanceY - bond.startP.y) / ABS(assitanceX - bond.startP.x));
                    
                    wantedAngle = M_PI * 2 / 3 - assistancAngle;
                    
                    wangtedX = bond.startP.x + L * cos(wantedAngle * 180.0 / M_PI);
                    wangtedY = bond.startP.y + L * sin(wantedAngle * 180.0 / M_PI);
                }
            }
            else
            {
  
                if (bond.startP.y < bond.endP.y)
                {
                    
                    // spx > epx spy < epy 点击了sp
                    NewBond = [CYLChemicalBond CreatChemicalBondWithCarbon];
                    NSLog(@" > < sp ");
                    
                    assistancAngle = atan(ABS(assitanceX - bond.startP.x) / ABS(assistanceY - bond.startP.y));
                    
                    wantedAngle = M_PI * 2 / 3 - assistancAngle;
                    
                    wangtedX = bond.startP.x + L * sin(wantedAngle * 180.0 / M_PI);
                    wangtedY = bond.startP.y + L * cos(wantedAngle * 180.0 / M_PI);
                    
                }
                else
                {
                    // spx > epx spy > epy 点击了sp
                    NewBond = [CYLChemicalBond CreatChemicalBondWithCarbon];
                    
                    NSLog(@" > > sp ");
                    assistancAngle = atan( ABS(assistanceY - bond.startP.y) / ABS(assitanceX - bond.startP.x));
                    wantedAngle = M_PI/6 - assistancAngle;
                    
                    wangtedX = bond.startP.x + L * sin(wantedAngle * 180.0 / M_PI);
                    wangtedY = bond.startP.y + L * cos(wantedAngle * 180.0 / M_PI);
                    
                }
                
            }

        }
        else if (CGPointEqualToPoint(bond.endP, tapPoint))
        {
            
            L = sqrt(pow((bond.startP.x - bond.endP.x), 2) + pow((bond.startP.y - bond.endP.y), 2));
            assitanceX = 2 * bond.endP.x - bond.startP.x;
            assistanceY = 2 * bond.endP.y - bond.startP.y;
            
            if (bond.startP.x >= bond.endP.x) {
                
                if (bond.startP.y >= bond.endP.y)
                {
                    // spx > epx spy > epy 点击了ep
                    NewBond = [CYLChemicalBond CreatChemicalBondWithCarbon];
                    NSLog(@" > > ep ");

                }
                else
                {
                    // spx > epx spy < epy 点击了ep
                    NewBond = [CYLChemicalBond CreatChemicalBondWithCarbon];
                    NSLog(@" > < ep ");
                    
                    assistancAngle = atan( ABS(assistanceY - bond.endP.y) / ABS(assitanceX - bond.endP.x));
                    
                    wantedAngle = M_PI/6 - assistancAngle;
                    
                    wangtedX = bond.endP.x - L * sin(wantedAngle * 180.0 / M_PI);
                    wangtedY = bond.endP.y + L * cos(wantedAngle * 180.0 / M_PI);
                }
                
            }
            else
            {
                if (bond.startP.y > bond.endP.y)
                {
                    // spx < epx spy > epy 点击了ep
                    NewBond = [CYLChemicalBond CreatChemicalBondWithCarbon];
                    
                    NSLog(@" < > ep ");
                    
                    assistancAngle = atan(ABS(assitanceX - bond.startP.x) / ABS(assistanceY - bond.startP.x));
                    
                    wantedAngle = M_PI * 2 / 3 - assistancAngle;
                    
                    wangtedX = bond.endP.x + L * cos(wantedAngle * 180.0 / M_PI);
                    wangtedY = bond.endP.y + L * sin(wantedAngle * 180.0 / M_PI);
                    
                }
                else
                {
                    // spx < epx spy < epy 点击了ep
                    NewBond = [CYLChemicalBond CreatChemicalBondWithCarbon];
                    
                    NSLog(@" < < ep ");
                    
                    assistancAngle = atan( ABS(assistanceY - bond.endP.y) / ABS(assitanceX - bond.endP.x));
                    wantedAngle = M_PI/6 - assistancAngle;
                    
                    wangtedX = bond.endP.x + L * sin(wantedAngle * 180.0 / M_PI);
                    wangtedY = bond.endP.y + L * cos(wantedAngle * 180.0 / M_PI);
                }
            }
            
        }
    }
    
    
    if ( NewBond == nil) {
        return;
    }
    
    NewBond.startP = tapPoint;
    NewBond.endP = CGPointMake(wangtedY, wangtedY);
    NewBond.bezierPath = [UIBezierPath bezierPath];
    [NewBond.bezierPath moveToPoint:NewBond.startP];
    [NewBond.bezierPath addLineToPoint:NewBond.endP];
    
    [self.atomArray addObject:NewBond.Atom];
    [self.BondArray addObject:NewBond];
    
    
    //tappoint位置的原子化学键加1
    for (CYLCarbonAtom *atom in self.atomArray) {
        
        if (CGPointEqualToPoint(atom.atomPoint, tapPoint)) {
            
            atom.attachBondNum += 1;
        }
        
    }
    
    
    [self setNeedsDisplay];
}
#endif


#pragma mark - pan手势
- (void)pan:(UIPanGestureRecognizer*)pan
{
    CGPoint curP = [pan locationInView:self];

    if (_pan.state == UIGestureRecognizerStateBegan) {
        
        //初始化时，化学键为1
        _bond = [CYLChemicalBond CreatChemicalBondWithCarbon];

        _bond.startP = curP;
        
        //判断起点与任意一条线的双端是否住够近 选出起点
        for (NSValue *value in self.pointArray)
        {
            CGPoint point = value.CGPointValue;
            
            if ([self isStartPoint:_bond.startP aroundPoint:point WithRadius:CTLRadius])
            {    
                //如果与某个点很近 则显示高亮图片 并以此为起点
                [self showHightViewOnPoint:point];
                
                _bond.startP = point;
                
                //修正这个点的原子的化学键的个数
                CYLCarbonAtom *atom = [self atomAtPoint:point];
                
                atom.attachBondNum += 1;
            }
        }
    }
    else if (_pan.state == UIGestureRecognizerStateChanged)
    {

//        for (CYLChemicalBond *ExitBond in self.BondArray) {
//            
//            if (CGPointEqualToPoint(_bond.startP, ExitBond.startP)) {
//
//            }
//            
//        }
        
        _bond.bezierPath = [UIBezierPath bezierPath];
        
        [_bond.bezierPath moveToPoint:_bond.startP];
        [_bond.bezierPath addLineToPoint:curP];
        
        //当前点与某一个点足够近且此点非起点时，显示attachView
        for (NSValue *value  in self.pointArray) {
            
            CGPoint point = value.CGPointValue;
            
            if ([self isStartPoint:curP aroundPoint:point WithRadius:CTLRadius] && !CGPointEqualToPoint(point, _bond.startP)) {

                [self showAttachViewOnPoint:point];
                
                _bond.AttachPoint = point;
            }
            else if (![self isStartPoint:curP aroundPoint:_bond.AttachPoint WithRadius:CTLRadius])
            {
                //如果移开 则移除attachview 并且attachPoint = (0,0)
                [self dismissAttachView];
                _bond.AttachPoint = CGPointZero;
            }
        }
        
        [self setNeedsDisplay];
    }
    else if (pan.state == UIGestureRecognizerStateEnded)
    {
        _bond.endP = curP;
        
        //松手后判断是否连接到attachPoint上
        if (!CGPointEqualToPoint(_bond.AttachPoint, CGPointZero)) {
            
            //释放原来path 创建新的path
            _bond.bezierPath = nil;
            _bond.bezierPath = [UIBezierPath bezierPath];
            
            //修正更改后线段的端点
            _bond.endP = _bond.AttachPoint;
            
            [_bond.bezierPath moveToPoint:_bond.startP];
            [_bond.bezierPath addLineToPoint:_bond.AttachPoint];
            
            //修正此点化学键个数
            CYLCarbonAtom *atom = [self atomAtPoint:_bond.AttachPoint];
            
            if (atom == nil) { //形成环路时，在环头添加一个原子
                atom = [[CYLCarbonAtom alloc] init];
                atom.atomPoint = _bond.AttachPoint;
                [self.atomArray addObject:atom];
            }
            
            atom.attachBondNum += 1;
        }
        else
        {
            //没有attachPoint时 才缓存自己的atom
            [self.atomArray addObject:_bond.Atom];
        }

        //缓存画好的bond
        [self.BondArray addObject:_bond];

        //存储每条线的双端
        [self.pointArray addObject:[NSValue valueWithCGPoint:_bond.endP]];
        [self.pointArray addObject:[NSValue valueWithCGPoint:_bond.startP]];
        
        [self dismissHightLightView];
        [self dismissAttachView];
        

        [self setNeedsDisplay];

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

- (NSMutableArray *)BondArray
{
    if (_BondArray == nil) {
        _BondArray = [NSMutableArray array];
    }
    return _BondArray;
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

- (CYLChemicalBond *)lastBond
{
    if (self.BondArray.count) {
        
        _lastBond = self.BondArray.firstObject;
    }
    return _lastBond;
}

- (NSMutableArray *)atomArray
{
    if (_atomArray == nil) {
        _atomArray = [NSMutableArray array];
    }
    return _atomArray;
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

- (CYLCarbonAtom*)atomAtPoint:(CGPoint)point
{
    for (CYLCarbonAtom *atom in self.atomArray) {
        
        if (CGPointEqualToPoint(atom.atomPoint, point)) {
            return atom;
        }
    }
    return nil;
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

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
@end
