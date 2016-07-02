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
@optional
- (void)toolBarDidClickSelectBtn;
- (void)toolBarDidClickDrawBtn;
- (void)toolBarDidClickDoubleBondBtn;
- (void)toolBarDidClickTripleBondBtn;
- (void)toolBarDidClickReDoBtn;
- (void)toolBarDidClickOtherAtomBtn;
- (void)toolBarDidClickClearAllBtn;
- (void)toolBarChoseOtherAtom;
- (void)toolBarDidClickAtomBtnWithAtomName:(NSString*)name withColor:(UIColor*)color;

@end

@interface CYLToolBarView : UIView

@property (nonatomic,strong) id<CYLToolBarViewDelegate> delegate;

@end
