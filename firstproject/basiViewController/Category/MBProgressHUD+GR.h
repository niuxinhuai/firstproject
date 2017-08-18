//
//  MBProgressHUD+MJ.h
//
//  Created by mj on 13-4-18.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MBProgressHUD.h"

typedef void(^ComplicationOption)();
@interface MBProgressHUD (GR)

+ (void)showSuccess:(NSString *)success toView:(UIView *)view complication:(ComplicationOption)option;
+ (void)showError:(NSString *)error toView:(UIView *)view complication:(ComplicationOption)option;

+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view complication:(ComplicationOption)option;

+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;

+ (void)hideHUDForView:(UIView *)view;
/**
 *  显示网络指示器
 */
+ (void)showIndicatorWithView:(UIView *)view;

+ (void)showIndicatorWithView:(UIView *)view showMessage:(NSString *)message;
@end
