//
//  CYLHightLightCell.h
//  ChemMaster
//
//  Created by GARY on 16/6/14.
//  Copyright © 2016年 GARY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CYLHightLightModel.h"
@class CYLHightLightCell;
@protocol CYLHightLightCellDelegate <NSObject>

- (void)HightLightCellDidClickButton:(UIButton*)btn;

@end

@interface CYLHightLightCell : UICollectionViewCell
@property (nonatomic , strong) CYLHightLightModel *model;

@property (nonatomic, weak) id<CYLHightLightCellDelegate> delegate;
@end
