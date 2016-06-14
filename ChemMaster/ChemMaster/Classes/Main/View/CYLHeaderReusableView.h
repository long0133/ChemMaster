//
//  CYLEditorChoiseScrollView.h
//  ChemMaster
//
//  Created by GARY on 16/6/13.
//  Copyright © 2016年 GARY. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CYLHeaderReusableView;
@class CYLEditorChociseModel;
@protocol CYLHeaderReusableViewDelegate <NSObject>
- (void)HeaderReusableView:(CYLHeaderReusableView*)View didChoiceEditorModel:(CYLEditorChociseModel*)model;
@end


@interface CYLHeaderReusableView : UICollectionReusableView

@property (nonatomic, weak) id<CYLHeaderReusableViewDelegate> delegate;

- (void)HeaderScrollViewWithModelArray:(NSArray*)modelArray;
@end
