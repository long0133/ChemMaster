//
//  CYLDrawView.m
//  ChemMaster
//
//  Created by GARY on 16/6/18.
//  Copyright © 2016年 GARY. All rights reserved.
//

#import "CYLDrawView.h"


//highlightView 和 AttachView的半径
#define CTLRadius 20.0
//距离点多远时显示AttachView
#define CYLSuggestDistance 30
//建议的化学键键长
#define CYLSuggestBondLength 40
//化学键线宽
#define BondLineWidth 3
//选中范围的半径
#define selectRadius 20


@interface CYLDrawView ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) CYLChemicalBond *bond;

@property (nonatomic, strong) CYLChemicalBond *lastBond;

@property (nonatomic, assign) CGContextRef ContextRef;

@property (nonatomic, strong) UIPanGestureRecognizer *pan;

@property (nonatomic, strong) NSMutableArray *BondArray;
//存储每条线的双端点
@property (nonatomic, strong) NSMutableArray *pointArray;

@property (nonatomic, strong) NSMutableArray *atomArray;

//方便识别那一个点目前被选到
@property (nonatomic,strong) UIView *HighLightView;
//方便识别线段端点将会依附在哪一个点上
@property (nonatomic,strong) UIView *AttachView;
//方便识别哪些点被选中了
@property (nonatomic, strong)NSMutableArray *selectedViewArray;
@property (nonatomic,strong) UIBezierPath *selectPath;
//存储被选中的点
@property (nonatomic, strong) NSMutableArray *selPointArray;
/////////////////////////给出建议线条//////////////////////////////////////////
//给出建议化学键的方向线段的数组
@property (nonatomic, strong) NSMutableArray *suggestPathArray;
//path终点的数组
@property (nonatomic, strong) NSArray *SuggestPointArray;
@property (nonatomic, strong) UIBezierPath *suggstLine1;
@property (nonatomic, strong) UIBezierPath *suggstLine2;
@property (nonatomic, strong) UIBezierPath *suggstLine3;
@property (nonatomic, strong) UIBezierPath *suggstLine4;
@property (nonatomic, strong) UIBezierPath *suggstLine5;
@property (nonatomic, strong) UIBezierPath *suggstLine6;

@property (nonatomic, assign) CGPoint point1;
@property (nonatomic, assign) CGPoint point2;
@property (nonatomic, assign) CGPoint point3;
@property (nonatomic, assign) CGPoint point4;
@property (nonatomic, assign) CGPoint point5;
@property (nonatomic, assign) CGPoint point6;

@end

@implementation CYLDrawView
- (void)drawRect:(CGRect)rect {
    
    self.ContextRef = UIGraphicsGetCurrentContext();
    
    //画出实时的线条
    self.bond.bezierPath.lineWidth = BondLineWidth;
    [self.bond.bezierPath stroke];
    
    //画出辅助线条
    for (UIBezierPath *path in self.suggestPathArray) {
        [path stroke];
    }
   
    [self.selectPath stroke];
    
    //画出历史的线条
    for (CYLChemicalBond *bond in self.BondArray) {
        
        bond.bezierPath.lineWidth = BondLineWidth;
        
        [bond.bezierPath stroke];
        
    }
    
    CGContextSetLineWidth(self.ContextRef, 3);
    
    CGContextStrokePath(self.ContextRef);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.isDraw = YES;
        
        [self tooBarView];
    }
    return self;
}

#pragma mark - tap手势 单击某一个原子时，自动画出合适长度，合适角度的化学键
#if 1
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



#pragma ToolBar的按钮控制
- (void)setIsDraw:(BOOL)isDraw
{
    _isDraw = isDraw;
    
    if (isDraw) {
        [self dismissAllSelView];
        
        self.pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        self.pan.delegate = self;
        [self addGestureRecognizer:self.pan];
    }
    else
    {
        [self.pan removeTarget:self action:@selector(pan:)];
    }
}

- (void)setIsToSelect:(BOOL)isToSelect
{
    _isToSelect = isToSelect;
    
    if (isToSelect) {
        
        [self.pan addTarget:self action:@selector(panToSelect:)];
    }
    else
    {
        [self.pan removeTarget:self action:@selector(panToSelect:)];
    }
    
}

#pragma mark - pan手势功能集合 :绘制基本碳骨架
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
        
        //显示辅助线条
        [self drawAssitanceLine];
    }
    else if (_pan.state == UIGestureRecognizerStateChanged)
    {
        
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
        
        //显示辅助点的attachView
        for (NSValue *value  in self.SuggestPointArray) {
            
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
        
        
        [self dismissHightLightView];
        [self dismissAttachView];
        
        //移除辅助线条的无用
        self.SuggestPointArray = nil;
        
        //撤销辅助线条
        [self.suggestPathArray removeAllObjects];
        
        //存储每条线的双端
        [self.pointArray addObject:[NSValue valueWithCGPoint:_bond.endP]];
        [self.pointArray addObject:[NSValue valueWithCGPoint:_bond.startP]];
        
        NSLog(@"%@",[NSValue valueWithCGPoint:_bond.startP]);
        NSLog(@"%@",[NSValue valueWithCGPoint:_bond.endP]);
        NSLog(@"%@",self.pointArray);
        
        [self setNeedsDisplay];
        
    }
    
}

#pragma mark - pan手势功能集合 :选择已存在的点
- (void)panToSelect:(UIPanGestureRecognizer*)panToSelect
{
    CGPoint curP = [panToSelect locationInView:self];
    
    if (panToSelect.state == UIGestureRecognizerStateChanged) {
        
        //显示划过的路径
        self.selectPath = [UIBezierPath bezierPathWithArcCenter:curP radius:selectRadius startAngle:0 endAngle:2*M_PI clockwise:YES];
        
        for (NSValue *value in self.pointArray) {
            
            CGPoint point = value.CGPointValue;
            
            if ([self isStartPoint:point aroundPoint:curP WithRadius:selectRadius]) {
                
               UIView *selectedView = [self showSelectViewOnPoint:point];
                
                [self.selectedViewArray addObject:selectedView];
            }
            
        }
        
    }
    else if (panToSelect.state == UIGestureRecognizerStateEnded)
    {
        self.selectPath = nil;
    }
    
    [self setNeedsDisplay];
}



#pragma mark - 懒加载
- (CYLToolBarView *)tooBarView
{
    if (_tooBarView == nil) {
        _tooBarView = [[CYLToolBarView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 150, self.frame.size.width,150)];
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

- (NSMutableArray *)selectedViewArray
{
    if (_selectedViewArray == nil) {
        _selectedViewArray = [NSMutableArray array];
    }
    return _selectedViewArray;
}

- (NSMutableArray *)atomArray
{
    if (_atomArray == nil) {
        _atomArray = [NSMutableArray array];
    }
    return _atomArray;
}

- (NSMutableArray *)suggestPathArray
{
    if (_suggestPathArray == nil) {
        _suggestPathArray = [NSMutableArray array];
    }
    return _suggestPathArray;
}

-(NSArray *)SuggestPointArray
{
    if (_SuggestPointArray == nil) {
        _SuggestPointArray = @[[NSValue valueWithCGPoint:_point1],
                               [NSValue valueWithCGPoint:_point2],
                               [NSValue valueWithCGPoint:_point3],
                               [NSValue valueWithCGPoint:_point4],
                               [NSValue valueWithCGPoint:_point5],
                               [NSValue valueWithCGPoint:_point6],
                               ];
    }
    return _SuggestPointArray;
}
#pragma mark - 自定义function
//一个点是否在另一个点的附近
- (BOOL)isStartPoint:(CGPoint)Startpoint aroundPoint:(CGPoint)point WithRadius:(CGFloat)radius
{
    CGFloat SPx = Startpoint.x;
    CGFloat SPy = Startpoint.y;
    
    CGFloat Px = point.x;
    CGFloat Py = point.y;
    
    CGFloat distance = sqrt(pow((SPx - Px), 2) + pow((SPy - Py), 2));
    
    return distance <= radius ? YES : NO;
}

//取出在point上的atom
- (CYLCarbonAtom*)atomAtPoint:(CGPoint)point
{
    for (CYLCarbonAtom *atom in self.atomArray) {
        
        if (CGPointEqualToPoint(atom.atomPoint, point)) {
            return atom;
        }
    }
    return nil;
}

//显示、撤销高亮view 和 建议view
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

- (UIView*)showSelectViewOnPoint:(CGPoint)point
{
    UIView *selectView = [[UIView alloc] init];
    selectView.backgroundColor = [UIColor getColor:@"458B74"];
    selectView.layer.cornerRadius = CTLRadius / 2;
    selectView.frame = CGRectMake(0, 0, CTLRadius,CTLRadius);
    selectView.center = point;
    [self addSubview:selectView];
    return selectView;
}

- (void)dismissAllSelView
{
    for (__strong UIView *view in self.selectedViewArray) {
        
        [view removeFromSuperview];
        view = nil;
    }
}

//绘制辅助作图线条
- (void)drawAssitanceLine
{
    //拖拽时显示辅助作图线
    //suggstLine1 左上
    CGFloat lineOneX = _bond.startP.x - CYLSuggestBondLength * cos(M_PI/6);
    CGFloat lineOneY = _bond.startP.y - CYLSuggestBondLength * sin(M_PI/6);
    _point1 = CGPointMake(lineOneX, lineOneY);
    //suggstLine2 右上
    CGFloat lineTwoX = _bond.startP.x + CYLSuggestBondLength * cos(M_PI/6);
    CGFloat lineTwoY = _bond.startP.y - CYLSuggestBondLength * sin(M_PI/6);
     _point2 = CGPointMake(lineTwoX, lineTwoY);
    //suggstLine3 下
    CGFloat lineThreeX = _bond.startP.x;
    CGFloat lineThreeY = _bond.startP.y + CYLSuggestBondLength;
    _point3 = CGPointMake(lineThreeX, lineThreeY);
    //suggstLine4 左下
    CGFloat lineFourX = _bond.startP.x - CYLSuggestBondLength * cos(M_PI/6);
    CGFloat lineFourY = _bond.startP.y + CYLSuggestBondLength * sin(M_PI/6);
   _point4 = CGPointMake(lineFourX, lineFourY);
    //suggstLine5 右下
    CGFloat lineFiveX = _bond.startP.x + CYLSuggestBondLength * cos(M_PI/6);
    CGFloat lineFiveY = _bond.startP.y + CYLSuggestBondLength * sin(M_PI/6);
    _point5 = CGPointMake(lineFiveX, lineFiveY);
    //suggstLine6 上
    CGFloat lineSixX = _bond.startP.x;
    CGFloat lineSixY = _bond.startP.y - CYLSuggestBondLength;
    _point6 = CGPointMake(lineSixX, lineSixY);
    
    _suggstLine1 = [UIBezierPath bezierPath];
    [_suggstLine1 moveToPoint:CGPointMake(_bond.startP.x, _bond.startP.y)];
    [_suggstLine1 addLineToPoint:_point1];
    
    _suggstLine2 = [UIBezierPath bezierPath];
    [_suggstLine2 moveToPoint:CGPointMake(_bond.startP.x, _bond.startP.y)];
    [_suggstLine2 addLineToPoint:_point2];
    
    _suggstLine3 = [UIBezierPath bezierPath];
    [_suggstLine3 moveToPoint:CGPointMake(_bond.startP.x, _bond.startP.y)];
    [_suggstLine3 addLineToPoint:_point3];
    
    _suggstLine4 = [UIBezierPath bezierPath];
    [_suggstLine4 moveToPoint:CGPointMake(_bond.startP.x, _bond.startP.y)];
    [_suggstLine4 addLineToPoint:_point4];
    
    _suggstLine5 = [UIBezierPath bezierPath];
    [_suggstLine5 moveToPoint:CGPointMake(_bond.startP.x, _bond.startP.y)];
    [_suggstLine5 addLineToPoint:_point5];
    
    _suggstLine6 = [UIBezierPath bezierPath];
    [_suggstLine6 moveToPoint:CGPointMake(_bond.startP.x, _bond.startP.y)];
    [_suggstLine6 addLineToPoint:_point6];
    
    [self.suggestPathArray addObject:_suggstLine1];
    [self.suggestPathArray addObject:_suggstLine2];
    [self.suggestPathArray addObject:_suggstLine3];
    [self.suggestPathArray addObject:_suggstLine4];
    [self.suggestPathArray addObject:_suggstLine5];
    [self.suggestPathArray addObject:_suggstLine6];
    
//    [self.pointArray addObjectsFromArray:self.SuggestPointArray];
}
@end
