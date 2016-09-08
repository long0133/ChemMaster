//
//  CYLButton.h
//  ChemMaster
//
//  Created by GARY on 16/9/8.
//  Copyright © 2016年 GARY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CYLButton : UIButton<NSCoding>

@property (nonatomic, assign) CGPoint BtnPoint;
@property (nonatomic, assign) CGSize Size;
@property (nonatomic, copy) NSString *atomName;
@property (nonatomic, strong) UIColor *atomColor;


- (instancetype)initWithCoder:(NSCoder *)aDecoder;
-(void)encodeWithCoder:(NSCoder *)aCoder;

@end
