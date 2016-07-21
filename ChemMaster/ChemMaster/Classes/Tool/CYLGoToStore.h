//
//  CYLGoToStore.h
//  ChemMaster
//
//  Created by GARY on 16/7/21.
//  Copyright © 2016年 GARY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
@interface CYLGoToStore : NSObject <SKStoreProductViewControllerDelegate>

@property (nonatomic, strong) NSString *appID;

- (void)goToAppleStore:(UIViewController*)vc;

@end
