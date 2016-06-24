//
//  CYLToolBarView.h
//  ChemMaster
//
//  Created by GARY on 16/6/18.
//  Copyright © 2016年 GARY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CYLToolBarView;
@protocol CYLToolBarViewDelegate <NSObject>

- (void)toolBarDidClickSelectBtn;
- (void)toolBarDidClickDrawBtn;
- (void)toolBarDidClickDoubleBondBtn;
- (void)toolBarDidClickTripleBondBtn;


@end

@interface CYLToolBarView : UIView

@property (nonatomic,strong) id<CYLToolBarViewDelegate> delegate;

@end
