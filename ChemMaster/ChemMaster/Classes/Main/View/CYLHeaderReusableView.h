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
- (void)HeaderReusableView:(CYLHeaderReusableView*)View didChoiceEditorModel:(CYLEditorChociseModel*)model andSubviews:(NSMutableArray*)subViews andCurrentPage:(NSInteger)currentPage;
@end


@interface CYLHeaderReusableView : UICollectionReusableView

@property (nonatomic, weak) id<CYLHeaderReusableViewDelegate> delegate;

@property (nonatomic, strong) UIImage *currentImage;

@property (nonatomic, assign) NSInteger currentPage;

- (void)HeaderScrollViewWithModelArray:(NSArray*)modelArray;

- (NSMutableArray*)getScrollViewSubviews;
@end
