//
//  CYLDrawView.m
//  ChemMaster
//
//  Created by GARY on 16/6/18.
//  Copyright © 2016年 GARY. All rights reserved.
//

#import "CYLDrawView.h"
#import "CYLDoubleBond.h"
#import "CYLTripleBond.h"
#import "CYLAssistanceView.h"

#define toolBarViewCololr @"FDF5E6"
//highlightView 和 AttachView的半径
#define CTLRadius 20.0
//距离点多远时显示AttachView
#define CYLSuggestDistance 30
//建议的化学键键长
#define CYLSuggestBondLength 40
#define CYLAttachAtomBondLength 30
//化学键线宽
#define BondLineWidth 2
//选中范围的半径
#define selectRadius 20
//双键间隔
#define marginOfBonds 3
//toolbar的高度
#define toolBarViewH 105
//第一排按钮的高度
#define firstLineBtnH 55

#define atomRadius 27

@interface CYLDrawView ()<UIGestureRecognizerDelegate, CYLAssistanceViewDelegate>

//当前正在画的化学键
@property (nonatomic, strong) CYLChemicalBond *bond;

@property (nonatomic, strong) CYLChemicalBond *lastBond;

@property (nonatomic, strong) UIPanGestureRecognizer *pan;
@property (nonatomic, strong) UITapGestureRecognizer *tap;

@property (nonatomic,strong) CYLAssistanceView *assistanceView;

/////////////////////////缓存相关//////////////////////////////
@property (nonatomic, strong) NSMutableArray *BondArray;
//存储每条线的双端点
@property (nonatomic, strong) NSMutableArray *pointArray;

@property (nonatomic, strong) NSMutableArray *atomArray;

//用于存储所有的操作 用于撤回时使用
@property (nonatomic, strong) NSMutableArray *operationArray;

/////////////////////////便于识别view//////////////////////////////
//方便识别那一个点目前被选到
@property (nonatomic,strong) UIView *HighLightView;
//方便识别线段端点将会依附在哪一个点上
@property (nonatomic,strong) UIView *AttachView;
//方便识别哪些点被选中了
@property (nonatomic, strong)NSMutableArray *selectedViewArray;
@property (nonatomic,strong) UIBezierPath *selectPath;
//存储被选中的点
@property (nonatomic, strong) NSMutableArray *selPointArray;
//存储其他原子
@property (nonatomic, strong) NSMutableArray *otherAtomArray;

/////////////////////////给出建议线条//////////////////////////////
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
/////////////////////////给出建议线条//////////////////////////////////////////
//存入字典--》每个键对应一个字典 {startP：  endP:  status: }
@property (nonatomic, strong) NSMutableSet *saveArray;
@end

@implementation CYLDrawView
- (void)drawRect:(CGRect)rect {
    
    //画出实时的线条
    self.bond.bezierPath.lineWidth = BondLineWidth;
    self.bond.bezierPath.lineCapStyle = kCGLineCapRound;
    [self.bond.bezierPath stroke];
    
    //画出辅助线条
    for (UIBezierPath *path in self.suggestPathArray) {
        path.lineJoinStyle = kCGLineCapRound;
        [path stroke];
    }
    
    [self.selectPath stroke];
    
    //画出历史的线条
    for (CYLChemicalBond *bond in self.BondArray) {
        
        if ([bond isKindOfClass:[CYLDoubleBond class]]) { //画出双键
            
            typeof(CYLDoubleBond*) DoubleBond = (CYLDoubleBond*)bond;
            DoubleBond.bezierPath.lineWidth = BondLineWidth;
            DoubleBond.bezierPathTwo.lineWidth = BondLineWidth;
            
            DoubleBond.bezierPath.lineCapStyle = kCGLineCapRound;
            DoubleBond.bezierPathTwo.lineCapStyle = kCGLineCapRound;
            
            [DoubleBond.bezierPath stroke];
            [DoubleBond.bezierPathTwo stroke];
        }
        
        if ([bond isKindOfClass:[CYLTripleBond class]]) { //画出三键
            
            typeof (CYLTripleBond*)tripleBond = (CYLTripleBond*)bond;
            
            tripleBond.bezierPath.lineWidth = BondLineWidth;
            tripleBond.bezierPathTwo.lineWidth = BondLineWidth;
            tripleBond.bezierPathThree.lineWidth = BondLineWidth;
            
            tripleBond.bezierPath.lineCapStyle = kCGLineCapRound;
            tripleBond.bezierPathTwo.lineCapStyle = kCGLineCapRound;
            tripleBond.bezierPathThree.lineCapStyle = kCGLineCapRound;
            
            [tripleBond.bezierPath stroke];
            [tripleBond.bezierPathTwo stroke];
            [tripleBond.bezierPathThree stroke];
        }
        
        //画出单键
        bond.bezierPath.lineWidth = BondLineWidth;
        bond.bezierPath.lineCapStyle = kCGLineCapRound;
        [bond.bezierPath stroke];
        
        [self saveBondInArray:bond];
        
    }
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.tap = [[UITapGestureRecognizer alloc] init];
        [self addGestureRecognizer:self.tap];
        self.tap.delegate = self;
        self.pan = [[UIPanGestureRecognizer alloc] init];
        [self addGestureRecognizer:self.pan];
        self.pan.delegate = self;
        
        [self tooBarView];
        
        [self assistanceView];
    }
    return self;
}

#pragma mark -ToolBar的按钮控制
- (void)setIsDraw:(BOOL)isDraw
{
    _isDraw = isDraw;
    
    if (isDraw) {
        [self dismissAllSelView];
        
        [self.pan addTarget:self action:@selector(pan:)];
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

//绘制双键
-(void)setIsGoDoubleBond:(BOOL)isGoDoubleBond
{
    
    _isGoDoubleBond = isGoDoubleBond;
    
    if (isGoDoubleBond) {
        
        [self.tap addTarget:self action:@selector(tap:)];
        
    }
    else
    {
        [self.tap removeTarget:self action:@selector(tap:)];
    }
    
}

//绘制三键
- (void)setIsGoTrinpleBond:(BOOL)isGoTrinpleBond
{
    _isGoTrinpleBond = isGoTrinpleBond;
    
    if (isGoTrinpleBond) {
        
        [self.tap addTarget:self action:@selector(tap:)];
        
    }
    else
    {
        [self.tap removeTarget:self action:@selector(tap:)];
    }
}

//撤销功能
- (void)setIsRedo:(BOOL)isRedo
{
    _isRedo = isRedo;
    
    id obj = self.operationArray.lastObject;
    
    if ([obj isKindOfClass:[CYLChemicalBond class]]) {
        
        CYLChemicalBond *lastBond = [self.operationArray lastObject];
        
        [self.operationArray removeLastObject];
        
        //移除正在画的实时线条
        _bond.bezierPath = nil;
        
        [self.BondArray removeLastObject];
        
        //移除点
        [self.pointArray removeObject:[NSValue valueWithCGPoint:lastBond.endP]];
        
        [self setNeedsDisplay];
        
    }
    else if ([obj isKindOfClass:[UIButton class]])
    {
        
        UIButton *btn = self.operationArray.lastObject;
        
        [self.operationArray removeLastObject];
        
        [btn removeFromSuperview];
        
        btn = nil;
    }
    
}

//清屏功能
- (void)setIsClear:(BOOL)isClear
{
    _isClear = isClear;
    
    [self.BondArray removeAllObjects];
    [self.pointArray removeAllObjects];
    [self.selectedViewArray removeAllObjects];
    
    for (__strong UIButton *btn in self.otherAtomArray) {
        [btn removeFromSuperview];
        btn = nil;
    }
    
    self.bond = nil;
    [self setNeedsDisplay];
}

//显示出其他原子的显示界面
- (void)setIsShowOtherAtom:(BOOL)isShowOtherAtom
{
    _isShowOtherAtom = isShowOtherAtom;
    
    if (isShowOtherAtom) {
        
        self.tooBarView.frame = CGRectMake(0, 65, ScreenW, toolBarViewH);
        
    }
    else
    {
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
            
            self.tooBarView.frame = CGRectMake(0, 65, ScreenW, firstLineBtnH);
            
        } completion:nil];
    }
}

//点击屏幕处显示出所选的原子
- (void)setIsChoseOneAtom:(BOOL)isChoseOneAtom
{
    _isChoseOneAtom = isChoseOneAtom;
    
    if (isChoseOneAtom) {
        [self.tap addTarget:self action:@selector(tapToAttachAtom:)];
    }
    else
    {
        [self.tap removeTarget:self action:@selector(tapToAttachAtom:)];
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
        
        
        [self dismissHightLightView];
        [self dismissAttachView];
        
        //移除辅助线条的无用
        self.SuggestPointArray = nil;
        
        //撤销辅助线条
        [self.suggestPathArray removeAllObjects];
        
        //存储每条线的双端
        [self.pointArray addObject:[NSValue valueWithCGPoint:_bond.endP]];
        [self.pointArray addObject:[NSValue valueWithCGPoint:_bond.startP]];
        
        //设置中点便于选中对应的化学键
        _bond.midPoint = CGPointMake((_bond.startP.x + _bond.endP.x)/2, (_bond.startP.y + _bond.endP.y)/2);
        
        //缓存画好的bond
        [self.BondArray addObject:_bond];
        [self.operationArray addObject:_bond];
        
        [self setNeedsDisplay];
        
    }
    
}

#pragma mark - pan手势功能集合 :选择已存在的点删除
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
                
                //将备选到的点不重复的添加进数组
                if (![self.selPointArray containsObject:value]) {
                    
                    [self.selPointArray addObject:value];
                }
                else
                {
                    continue;
                }
            }
            
        }
        
    }
    else if (panToSelect.state == UIGestureRecognizerStateEnded)
    {
        self.selectPath = nil;
        
        
        NSMutableArray *bondPrepareToDeleteA = [NSMutableArray array];
        NSMutableArray *OtherAtomPrepareToDeleteA = [NSMutableArray array];
        
        for (NSValue *value in self.selPointArray)
        {
            CGPoint point = value.CGPointValue;
            
            for (CYLChemicalBond *bond in self.BondArray)
            {
                
                if (CGPointEqualToPoint(bond.startP, point) || CGPointEqualToPoint(bond.endP, point)) {
                    
                    [bondPrepareToDeleteA addObject:bond];
                    
                }
                
            }
            
            for (UIButton *btn  in self.otherAtomArray) {
                
                if (CGPointEqualToPoint(btn.center,point)) {
                    
                    [OtherAtomPrepareToDeleteA addObject:btn];
                    [btn removeFromSuperview];
                }
                
            }
            
        }
        
        
        //删除化学键
        self.bond = nil;
        [self.BondArray removeObjectsInArray:bondPrepareToDeleteA];
        [self.pointArray removeObjectsInArray:self.selPointArray];
        
        //删除selectedView
        for (UIView *view in self.selectedViewArray) {
            [view removeFromSuperview];
        }
        
        //删除其它原子btn
        [self.otherAtomArray removeObjectsInArray:OtherAtomPrepareToDeleteA];
        
        [self.selectedViewArray removeAllObjects];
        [self.selPointArray removeAllObjects];
    }
    
    
    
    [self setNeedsDisplay];
}

#pragma mark - 点击创建双键，三键
- (void)tap:(UITapGestureRecognizer*)tap
{
    CGPoint tapPoint = [tap locationInView:self];
    
    /**************************需要创建双键，三键时*****************************/
    if (_isGoDoubleBond || _isGoTrinpleBond) {
        
        CYLChemicalBond *bondPrepareToRemove = nil;
        
        if (self.isGoDoubleBond)
        {//想添加/改变双键时
            
            //初始化第二条线段的双端
            CGFloat spX = 0;
            CGFloat spY = 0;
            CGFloat epX = 0;
            CGFloat epY = 0;
            CGPoint startTwo = CGPointMake(spX, spY);
            CGPoint endTwo = CGPointMake(epX, epY);
            
            CYLDoubleBond *doubleBond = [CYLDoubleBond CreatChemicalBondWithCarbon];
            
            for (CYLChemicalBond *bond in self.BondArray)
            {
                
                //想要添加双键
                if (![bond isKindOfClass:[CYLDoubleBond class]])
                {//如果不是双键的话
                    
                    if ([self isStartPoint:tapPoint aroundPoint:bond.midPoint WithRadius:(CYLSuggestBondLength/2)])
                    {//找到待转变的化学键
                        
//                        NSLog(@"%d", bond.isAttached);
                        
                        doubleBond.startP = bond.startP;
                        doubleBond.endP = bond.endP;
                        doubleBond.midPoint = bond.midPoint;
                        doubleBond.bezierPath =bond.bezierPath;
                        bondPrepareToRemove = bond;
                        
                        //计算斜率角度
                        CGFloat angle = atan((bond.endP.y - bond.startP.y)/(bond.endP.x - bond.startP.x));
                        NSInteger distance = CYLSuggestBondLength/5 * 2;
                        
                        if (angle < 0)
                        {//斜率大于九十度时
                            
                            /************************1.绘制另一条与原键平行的等长的先***********************/
                            
                            
                            spX = bond.startP.x + marginOfBonds * sin((M_PI - angle));
                            spY = bond.startP.y + marginOfBonds * cos((M_PI - angle));
                            
                            epX = bond.endP.x + marginOfBonds * sin((M_PI - angle));
                            epY = bond.endP.y + marginOfBonds * cos((M_PI - angle));
                            
                            /************************2.将此条线缩短一定距离***********************/
                            //新线段的中心点
                            CGPoint center = CGPointMake((spX + epX)/2, (spY + epY)/2);
                            
                            epX = center.x - distance * cos(M_PI - angle);
                            epY = center.y + distance * sin(M_PI - angle);
                            
                            spX = center.x + distance * cos(M_PI - angle);
                            spY = center.y - distance * sin(M_PI - angle);
                            
                            
                            startTwo = CGPointMake(spX, spY);
                            endTwo = CGPointMake(epX, epY);
                            
                        }
                        else
                        {
                            //斜率小于90
                            CGFloat spX = bond.startP.x + marginOfBonds * sin((angle));
                            CGFloat spY = bond.startP.y - marginOfBonds * cos((angle));
                            
                            CGFloat epX = bond.endP.x + marginOfBonds * sin((angle));
                            CGFloat epY = bond.endP.y - marginOfBonds * cos((angle));
                            
                            
                            //新线段的中心点
                            CGPoint center = CGPointMake((spX + epX)/2, (spY + epY)/2);
                            
                            epX = center.x - distance * cos(angle);
                            epY = center.y - distance * sin(angle);
                            
                            spX = center.x + distance * cos(angle);
                            spY = center.y + distance * sin(angle);
                            
                            endTwo = CGPointMake(epX, epY);
                            startTwo = CGPointMake(spX, spY);
                            
                        }
                        
                        doubleBond.startPTwo = startTwo;
                        doubleBond.endPTwo = endTwo;
                        
                        doubleBond.bezierPathTwo = [UIBezierPath bezierPath];
                        [doubleBond.bezierPathTwo moveToPoint:startTwo];
                        [doubleBond.bezierPathTwo addLineToPoint:endTwo];
                    }
                    
                }
                
                /*********************************点击双键想要改变双键的方向********************************/
                if ([bond isKindOfClass:[CYLDoubleBond class]]) {
                    
                   CYLDoubleBond* doublebondChange = (CYLDoubleBond*)bond;
                    
                     //找到点击的双键
                    if ([self isStartPoint:tapPoint aroundPoint:bond.midPoint WithRadius:CYLSuggestBondLength/2]) {
                        
                        //计算斜率角度
                        CGFloat angle = atan((bond.endP.y - bond.startP.y)/(bond.endP.x - bond.startP.x));
                        NSInteger distance = CYLSuggestBondLength/5 * 2;
                        
                        if (angle < 0)
                        {
                            if (doublebondChange.bondDirectionTag == 0)
                            {
                                /************************1.绘制另一条与原键平行的等长的先***********************/
                                
                                
                                spX = bond.startP.x - marginOfBonds * sin((M_PI - angle));
                                spY = bond.startP.y - marginOfBonds * cos((M_PI - angle));
                                
                                epX = bond.endP.x - marginOfBonds * sin((M_PI - angle));
                                epY = bond.endP.y - marginOfBonds * cos((M_PI - angle));
                                
                                /************************2.将此条线缩短一定距离***********************/
                                //新线段的中心点
                                CGPoint center = CGPointMake((spX + epX)/2, (spY + epY)/2);
                                
                                epX = center.x - distance * cos(M_PI - angle);
                                epY = center.y + distance * sin(M_PI - angle);
                                
                                spX = center.x + distance * cos(M_PI - angle);
                                spY = center.y - distance * sin(M_PI - angle);
                                
                                
                                startTwo = CGPointMake(spX, spY);
                                endTwo = CGPointMake(epX, epY);
                                
                                doublebondChange.bondDirectionTag = 1;
                            }
                            
                            else if (doublebondChange.bondDirectionTag == 1)
                            {
                                /************************1.绘制另一条与原键平行的等长的先***********************/
                                
                                
                                spX = bond.startP.x + marginOfBonds * sin((M_PI - angle));
                                spY = bond.startP.y + marginOfBonds * cos((M_PI - angle));
                                
                                epX = bond.endP.x + marginOfBonds * sin((M_PI - angle));
                                epY = bond.endP.y + marginOfBonds * cos((M_PI - angle));
                                
                                /************************2.将此条线缩短一定距离***********************/
                                //新线段的中心点
                                CGPoint center = CGPointMake((spX + epX)/2, (spY + epY)/2);
                                
                                epX = center.x - distance * cos(M_PI - angle);
                                epY = center.y + distance * sin(M_PI - angle);
                                
                                spX = center.x + distance * cos(M_PI - angle);
                                spY = center.y - distance * sin(M_PI - angle);
                                
                                
                                startTwo = CGPointMake(spX, spY);
                                endTwo = CGPointMake(epX, epY);
                                
                                doublebondChange.bondDirectionTag = 0;
                            }
                            
                            doublebondChange.startPTwo = startTwo;
                            doublebondChange.endPTwo = endTwo;
                            
                            doublebondChange.bezierPathTwo = [UIBezierPath bezierPath];
                            [doublebondChange.bezierPathTwo moveToPoint:startTwo];
                            [doublebondChange.bezierPathTwo addLineToPoint:endTwo];
                            
                        }//if
                        
                        else//斜率小于90
                        {
                            if (doublebondChange.bondDirectionTag == 0) {
                                
                                CGFloat spX = bond.startP.x - marginOfBonds * sin((angle));
                                CGFloat spY = bond.startP.y + marginOfBonds * cos((angle));
                                
                                CGFloat epX = bond.endP.x - marginOfBonds * sin((angle));
                                CGFloat epY = bond.endP.y + marginOfBonds * cos((angle));
                                
                                
                                //新线段的中心点
                                CGPoint center = CGPointMake((spX + epX)/2, (spY + epY)/2);
                                
                                epX = center.x - distance * cos(angle);
                                epY = center.y - distance * sin(angle);
                                
                                spX = center.x + distance * cos(angle);
                                spY = center.y + distance * sin(angle);
                                
                                CGPoint endTwo = CGPointMake(epX, epY);
                                CGPoint startTwo = CGPointMake(spX, spY);
                                
                                doublebondChange.startPTwo = startTwo;
                                doublebondChange.endPTwo = endTwo;
                                
                                doublebondChange.bezierPathTwo = [UIBezierPath bezierPath];
                                [doublebondChange.bezierPathTwo moveToPoint:startTwo];
                                [doublebondChange.bezierPathTwo addLineToPoint:endTwo];
                                
                                doublebondChange.bondDirectionTag = 1;
                                
                            }
                            else
                            {
                                //斜率小于90
                                CGFloat spX = bond.startP.x + marginOfBonds * sin((angle));
                                CGFloat spY = bond.startP.y - marginOfBonds * cos((angle));
                                
                                CGFloat epX = bond.endP.x + marginOfBonds * sin((angle));
                                CGFloat epY = bond.endP.y - marginOfBonds * cos((angle));
                                
                                
                                //新线段的中心点
                                CGPoint center = CGPointMake((spX + epX)/2, (spY + epY)/2);
                                
                                epX = center.x - distance * cos(angle);
                                epY = center.y - distance * sin(angle);
                                
                                spX = center.x + distance * cos(angle);
                                spY = center.y + distance * sin(angle);
                                
                                CGPoint endTwo = CGPointMake(epX, epY);
                                CGPoint startTwo = CGPointMake(spX, spY);
                                
                                doublebondChange.startPTwo = startTwo;
                                doublebondChange.endPTwo = endTwo;
                                
                                doublebondChange.bezierPathTwo = [UIBezierPath bezierPath];
                                [doublebondChange.bezierPathTwo moveToPoint:startTwo];
                                [doublebondChange.bezierPathTwo addLineToPoint:endTwo];
                                
                                doublebondChange.bondDirectionTag = 0;
                            }
                        }
                        
                    }
                    
                }
            }
            
            if (doubleBond.bezierPathTwo != nil) {
                [self.BondArray addObject:doubleBond];
                [self.operationArray addObject:doubleBond];
            }
            
        }//if（isGoDoubleBone）
        else if (self.isGoTrinpleBond)
        {
            //想添加三键时
            CYLTripleBond *tripleBond = [CYLTripleBond CreatChemicalBondWithCarbon];
            
            for (CYLChemicalBond *bond in self.BondArray) {
                
                if (![bond isKindOfClass:[CYLTripleBond class]]) {
                    
                    
                    if ([self isStartPoint:tapPoint aroundPoint:bond.midPoint WithRadius:CYLSuggestBondLength/2]) {
                        
                        bondPrepareToRemove = bond;
                        tripleBond.startP = bond.startP;
                        tripleBond.endP = bond.endP;
                        tripleBond.midPoint = bond.midPoint;
                        tripleBond.bezierPath = bond.bezierPath;
                        
                        //计算斜率角度
                        CGFloat angle = atan((bond.endP.y - bond.startP.y)/(bond.endP.x - bond.startP.x));
                        
                        if (angle < 0)
                        {//斜率大于九十度时
                            
                            //第2条
                            CGFloat spX = bond.startP.x + marginOfBonds * sin((M_PI - angle));
                            CGFloat spY = bond.startP.y + marginOfBonds * cos((M_PI - angle));
                            CGPoint startTwo = CGPointMake(spX, spY);
                            
                            CGFloat epX = bond.endP.x + marginOfBonds * sin((M_PI - angle));
                            CGFloat epY = bond.endP.y + marginOfBonds * cos((M_PI - angle));
                            CGPoint endTwo = CGPointMake(epX, epY);
                            
                            tripleBond.startPTwo = startTwo;
                            tripleBond.endPTwo = endTwo;
                            
                            tripleBond.bezierPathTwo = [UIBezierPath bezierPath];
                            [tripleBond.bezierPathTwo moveToPoint:startTwo];
                            [tripleBond.bezierPathTwo addLineToPoint:endTwo];
                            
                            //第三条
                            CGFloat spXTwo = bond.startP.x - marginOfBonds * sin((M_PI - angle));
                            CGFloat spYTwo = bond.startP.y - marginOfBonds * cos((M_PI - angle));
                            CGPoint startThree = CGPointMake(spXTwo, spYTwo);
                            
                            CGFloat epXTwo = bond.endP.x - marginOfBonds * sin((M_PI - angle));
                            CGFloat epYTwo = bond.endP.y - marginOfBonds * cos((M_PI - angle));
                            CGPoint endThree = CGPointMake(epXTwo, epYTwo);
                            
                            tripleBond.startPThree = startThree;
                            tripleBond.endPThree = endThree;
                            
                            tripleBond.bezierPathThree = [UIBezierPath bezierPath];
                            [tripleBond.bezierPathThree moveToPoint:startThree];
                            [tripleBond.bezierPathThree addLineToPoint:endThree];
                            
                        }
                        else
                        {
                            //斜率小于90
                            //第2条
                            CGFloat spX = bond.startP.x - marginOfBonds * sin((angle));
                            CGFloat spY = bond.startP.y + marginOfBonds * cos((angle));
                            CGPoint startTwo = CGPointMake(spX, spY);
                            
                            CGFloat epX = bond.endP.x - marginOfBonds * sin((angle));
                            CGFloat epY = bond.endP.y + marginOfBonds * cos((angle));
                            CGPoint endTwo = CGPointMake(epX, epY);
                            
                            tripleBond.startPTwo = startTwo;
                            tripleBond.endPTwo = endTwo;
                            
                            tripleBond.bezierPathTwo = [UIBezierPath bezierPath];
                            [tripleBond.bezierPathTwo moveToPoint:startTwo];
                            [tripleBond.bezierPathTwo addLineToPoint:endTwo];
                            
                            //第三条
                            CGFloat spXTwo = bond.startP.x + marginOfBonds * sin((angle));
                            CGFloat spYTwo = bond.startP.y - marginOfBonds * cos((angle));
                            CGPoint startThree = CGPointMake(spXTwo, spYTwo);
                            
                            CGFloat epXTwo = bond.endP.x + marginOfBonds * sin((angle));
                            CGFloat epYTwo = bond.endP.y - marginOfBonds * cos((angle));
                            CGPoint endThree = CGPointMake(epXTwo, epYTwo);
                            
                            tripleBond.startPThree = startThree;
                            tripleBond.endPThree = endThree;
                            
                            tripleBond.bezierPathThree = [UIBezierPath bezierPath];
                            [tripleBond.bezierPathThree moveToPoint:startThree];
                            [tripleBond.bezierPathThree addLineToPoint:endThree];
                            
                            
                        }
                        
                        
                    }
                    
                }
                
            }
            
            if (tripleBond.bezierPathTwo != nil) {
                [self.BondArray addObject:tripleBond];
                [self.operationArray addObject:tripleBond];
            }
        }
        
        
        if (bondPrepareToRemove != nil)
        {
            //删除当前化学键
            [self.BondArray removeObject:bondPrepareToRemove];
            
        }
        
        [self setNeedsDisplay];
    }
}

#pragma mark - 点击创建各种原子
- (void)tapToAttachAtom:(UITapGestureRecognizer*)tap
{
    CGPoint tapPoint = [tap locationInView:self];
    NSInteger count = 0;
    //显示原子的btn
    UIButton *atom = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, atomRadius, atomRadius)];
    atom.layer.cornerRadius = atom.frame.size.width/2;
    atom.backgroundColor = [UIColor whiteColor];
    atom.userInteractionEnabled = NO;
    [atom setTitleColor:self.atomColor forState:UIControlStateNormal];
    
    for (NSValue *value in self.pointArray) {
        
        CGPoint point = value.CGPointValue;
        
        //点击处的店是否在记录中
        if ([self isStartPoint:tapPoint aroundPoint:point WithRadius:CTLRadius])
        {
            
            //点击处有其他原子时，则删除原来的
            for (__strong UIButton *atomBtn in self.otherAtomArray) {
                
                if (CGPointEqualToPoint(atomBtn.center, point)) {
                    
                    [self.operationArray removeObject:atomBtn];
                    
                    [atomBtn removeFromSuperview];
                    atomBtn = nil;
                }
            }
            
            atom.center = point;
            
            if ([self.atomName isEqualToString:@"N"]) {
                atom.titleLabel.font = [UIFont systemFontOfSize:13];
            }
            else atom.titleLabel.font = [UIFont systemFontOfSize:17];
            
            [self addSubview:atom];
            
            //根据化学键的不同设置原子的不同显示形式
            for (CYLChemicalBond *bond in self.BondArray)
            {
                
                // 判断此点处的键是双键还是单键
                if (CGPointEqualToPoint(bond.startP, point) || CGPointEqualToPoint(bond.endP, point) )
                {
                    count += 1;
                    
                    if ([bond isKindOfClass:[CYLChemicalBond class]])
                    {
                        //三键
                        if ([bond isKindOfClass:[CYLTripleBond class]]) {
                            
                            [atom setTitle:self.atomName forState:UIControlStateNormal];
                            
                        }
                        else if ([bond isKindOfClass:[CYLDoubleBond class]])
                        {//双键
                            
                            if ([self.atomName isEqualToString:@"N"]) {
                                
                                if (count == 4 || count == 9) {
                                    
                                    [atom setTitle:@"N" forState:UIControlStateNormal];
                                }
                                else [atom setTitle:@"NH" forState:UIControlStateNormal];
                            }
                            else [atom setTitle:self.atomName forState:UIControlStateNormal];
                        }
                        else
                        {//单键
                            //计算有多少的单键与原子相连
                            
                            if (count == 1) {//一个单键
                                
                                if ([self.atomName isEqualToString:@"O"]) { //单键的话，O S N 需要变形
                                    [atom setTitle:@"OH" forState:UIControlStateNormal];
                                }
                                else if ([self.atomName isEqualToString:@"S"])
                                {
                                    [atom setTitle:@"SH" forState:UIControlStateNormal];
                                }
                                else if ([self.atomName isEqualToString:@"N"])
                                {
                                    [atom setTitle:@"NH2" forState:UIControlStateNormal];
                                    
                                }
                                else [atom setTitle:self.atomName forState:UIControlStateNormal];
                            }
                            else if (count == 4)//两个单键
                            {
                                
                                if ([self.atomName isEqualToString:@"O"]) {
                                    [atom setTitle:@"O" forState:UIControlStateNormal];
                                }
                                else if ([self.atomName isEqualToString:@"S"])
                                {
                                    [atom setTitle:@"S" forState:UIControlStateNormal];
                                }
                                else if ([self.atomName isEqualToString:@"N"])
                                {
                                    [atom setTitle:@"NH" forState:UIControlStateNormal];
                                    
                                }
                                else [atom setTitle:self.atomName forState:UIControlStateNormal];
                            }
                            else if (count == 9)//三个单键
                            {
                                
                                if ([self.atomName isEqualToString:@"N"])
                                {
                                    [atom setTitle:@"N" forState:UIControlStateNormal];
                                    
                                }
                                else [atom setTitle:self.atomName forState:UIControlStateNormal];
                            }
                            else
                            {
                                
                                [atom setTitle:self.atomName forState:UIControlStateNormal];
                            }
                            
                            
                        }
                        
                    }
                    
                    
                }//if
            }//for
            
//            [self reDrawBondWithPoint:point];
        }
        
    }
    [self.otherAtomArray addObject:atom];
    [self.operationArray addObject:atom];
    
}

////添加原子时，重新绘制化学键
//- (void)reDrawBondWithPoint:(CGPoint)point
//{
//    NSMutableSet *reDrawArray = [NSMutableSet set];
//    
//    //获得原子所在点相连接的化学键
//    for (CYLChemicalBond *bond in self.BondArray) {
//        
//        if ([self isStartPoint:bond.midPoint aroundPoint:point WithRadius:CYLSuggestBondLength/2 + 3])
//        {
//            [reDrawArray addObject:bond];
//        }
//    }
//    
//    
//    for (CYLChemicalBond *bond in reDrawArray)
//    {
//        
//        CGFloat distance = CYLSuggestBondLength/2 - atomRadius;
//        CGFloat Spx = 0;
//        CGFloat Spy = 0;
//        CGFloat Epx = 0;
//        CGFloat Epy = 0;
//        
//        //计算斜率角度
//        CGFloat angle = atan((bond.endP.y - bond.startP.y)/(bond.endP.x - bond.startP.x));
//        
//        if (angle < 0)
//        {
//            if ([bond isKindOfClass:[CYLTripleBond class]])
//            {
//                
//                continue;
//            }
//            else if ([bond isKindOfClass:[CYLDoubleBond class]])
//            {
//                
//                continue;
//            }
//            else
//            {
//                if (CGPointEqualToPoint(bond.startP, point)) {
//                    
//                    Spx = bond.midPoint.x + distance * cos(angle);
//                    Spy = bond.midPoint.y - distance *sin(angle);
//                    bond.startP = CGPointMake(Spx, Spy);
//
//                }
//                else
//                {
//                    
//                    Epx = bond.midPoint.x - distance * cos(angle);
//                    Epy = bond.midPoint.y + distance * sin(angle);
//                    bond.endP = CGPointMake(Epx, Epy);
//                }
//                
//                
//                
//                
//                [bond.bezierPath moveToPoint:bond.startP];
//                [bond.bezierPath addLineToPoint:bond.endP];
//                continue;
//            }
//        }
//        else
//        {
//            if ([bond isKindOfClass:[CYLTripleBond class]])
//            {
//                
//                continue;
//            }
//            else if ([bond isKindOfClass:[CYLDoubleBond class]])
//            {
//                
//                continue;
//            }
//            else
//            {
//             
//                
//                continue;
//            }
//        }
//    }
//    
//    [self setNeedsDisplay];
//    
//}
//
#pragma mark - 懒加载
- (NSMutableSet *)saveArray
{
    if (_saveArray == nil) {
        _saveArray = [NSMutableSet set];
    }
    return _saveArray;
}

- (CYLToolBarView *)tooBarView
{
    if (_tooBarView == nil) {
        
        _tooBarView = [[CYLToolBarView alloc] initWithFrame:CGRectMake(0, 65, self.frame.size.width,firstLineBtnH)];
        
        [self addSubview:_tooBarView];
        _tooBarView.backgroundColor = [UIColor getColor:toolBarViewCololr];
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

- (NSMutableArray *)otherAtomArray
{
    if (_otherAtomArray == nil) {
        _otherAtomArray = [NSMutableArray array];
    }
    return _otherAtomArray;
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

- (NSMutableArray *)operationArray
{
    if (_operationArray == nil) {
        _operationArray = [NSMutableArray array];
    }
    return _operationArray;
}

- (NSMutableArray *)selPointArray
{
    if (_selPointArray == nil) {
        _selPointArray = [NSMutableArray array];
    }
    return _selPointArray;
}

- (UIView *)assistanceView
{
    if (_assistanceView == nil) {
        _assistanceView = [[CYLAssistanceView alloc] initWithFrame:CGRectMake(0, 500, 33, 66)];
        _assistanceView.delegate = self;
        [_assistanceView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragToMove:)]];
        [self addSubview:_assistanceView];
    }
    return _assistanceView;
}

#pragma mark - assistanceView的拖拽功能
- (void)dragToMove:(UIPanGestureRecognizer*)pan
{
    CGPoint curP = [pan locationInView:self];
    
    CGFloat assistancW = self.assistanceView.frame.size.width;
    
    
    if (pan.state == UIGestureRecognizerStateBegan)
    {
        self.pan.enabled = NO;
        [self.suggestPathArray removeAllObjects];
    }
    else if (pan.state == UIGestureRecognizerStateChanged) {
        
        self.assistanceView.center = curP;
    }
    else if (pan.state == UIGestureRecognizerStateEnded)
    {
        if (curP.x >= self.center.x) {
            
            [UIView animateWithDuration:.5 animations:^{
                self.assistanceView.center = CGPointMake(375 - assistancW/2, curP.y);
            }];
        }
        else
        {
            [UIView animateWithDuration:.5 animations:^{
                self.assistanceView.center = CGPointMake(assistancW/2, curP.y);
            }];
        }
        
        self.pan.enabled = YES;
    }
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
//在所给点出显示selView
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

- (BOOL)isPoint:(CGPoint)point InArray:(NSArray*)array
{
    for (NSValue *value in array) {
        
        CGPoint pointInArray = value.CGPointValue;
        
        if (CGPointEqualToPoint(point, pointInArray)) {
            
            return YES;
        }
    }
    
    return NO;
}

#warning 数组存储问题待解决
//传入bong存入saveArrray
- (void)saveBondInArray:(CYLChemicalBond*)bond
{
    NSData *bondData = [NSKeyedArchiver archivedDataWithRootObject:bond];
    
    [self.saveArray addObject:bondData];
}

//存储分子结构
- (void)assistanceViewDidClickSaveBtn:(UIButton *)btn
{
    NSMutableArray *arr = [NSMutableArray array];
    
    for (NSDictionary *dict in self.saveArray) {
        
        [arr addObject:dict];
        
    }
    
    if ([self.delegate respondsToSelector:@selector(DrawViewShowAlertControllerWithSaveArray:)]) {
        [self.delegate DrawViewShowAlertControllerWithSaveArray:arr];
    }
}

#pragma mark - 辅助view的代理 点击截屏
- (void)assistanceViewDidClickClipScrennBtn:(UIButton*)btn
{
    
    CGRect frame = self.assistanceView.frame;
    
    //点击按钮时 先显示动画
    [UIView animateWithDuration:.25 animations:^{
        
        
        if (self.assistanceView.center.x <= self.center.x) {
            _assistanceView.frame = CGRectMake(-frame.size.width, frame.origin.y, frame.size.width, frame.size.height);
        }
        else if (self.assistanceView.center.x > self.center.x)
        {
            _assistanceView.frame = CGRectMake(ScreenW + frame.size.width, frame.origin.y, frame.size.width, frame.size.height);
        }
        
        
    } completion:^(BOOL finished) {
        
        self.tooBarView.hidden = YES;
        
        UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0);
        
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
        
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        
        self.tooBarView.hidden = NO;
        
        [UIView animateWithDuration:.25 animations:^{
            _assistanceView.frame = frame;
        }];
        
    }];
}



- (void) image: (UIImage *)image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo;
{
    [UIView animateWithDuration:0.25 animations:^{
        
        self.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        self.alpha = 1.0;
    }];
}

#pragma mark - 手势delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
@end
