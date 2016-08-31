//
//  CYLAssistanceView.h
//  ChemMaster
//
//  Created by GARY on 16/7/5.
//  Copyright © 2016年 GARY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CYLAssistanceView;

@protocol CYLAssistanceViewDelegate  <NSObject>

- (void)assistanceViewDidClickClipScrennBtn:(UIButton*)btn;
- (void)assistanceViewDidClickSaveBtn:(UIButton*)btn;

@end

@interface CYLAssistanceView : UIView

@property (nonatomic, weak) id<CYLAssistanceViewDelegate> delegate;

@end
