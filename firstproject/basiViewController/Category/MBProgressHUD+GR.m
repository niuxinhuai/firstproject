//
//  MBProgressHUD+MJ.m
//
//  Created by mj on 13-4-18.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MBProgressHUD+GR.h"

#define kopacity    0.7

#define kContentColor [UIColor colorWithWhite:1.f alpha:1.f]

#define kContentBackFroundColor [UIColor colorWithWhite:0.f alpha:1]

@implementation MBProgressHUD (GR)
#pragma mark 显示信息
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view complication:(ComplicationOption)option
{
    if (view == nil) {
        return;
    }
	
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
	hud.completionBlock = option;
	hud.contentColor = kContentColor;
	hud.bezelView.backgroundColor = kContentBackFroundColor;
    hud.label.text = text;
	hud.label.numberOfLines = 0;
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
	
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 1.5秒之后再消失
    [hud hideAnimated:YES afterDelay:1.5f];
}

#pragma mark 显示错误信息
+ (void)showError:(NSString *)error toView:(UIView *)view complication:(ComplicationOption)option{
    [self show:error icon:@"error.png" view:view complication:option];
}

+ (void)showSuccess:(NSString *)success toView:(UIView *)view complication:(ComplicationOption)option
{
    [self show:success icon:@"success.png" view:view complication:option];
}

+ (void)showIndicatorWithView:(UIView *)view
{
    if (view == nil) {
        return;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
	hud.mode = MBProgressHUDModeAnnularDeterminate;
	hud.progress = 0.1f;
	for (UIView *subView in hud.bezelView.subviews) {
		if ([subView isMemberOfClass:[MBRoundProgressView class]]) {
			[self startAnimationWithView:subView hud:hud];
			break;
		}
	}
	hud.contentColor = kContentColor;
	hud.bezelView.backgroundColor = kContentBackFroundColor;
    hud.backgroundView.alpha = 0;
    hud.removeFromSuperViewOnHide = YES;
}

+ (void)showIndicatorWithView:(UIView *)view showMessage:(NSString *)message {
	if (view == nil) {
		return;
	}
	MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
	hud.mode = MBProgressHUDModeAnnularDeterminate;
	hud.progress = 0.1f;
	for (UIView *subView in hud.bezelView.subviews) {
		if ([subView isMemberOfClass:[MBRoundProgressView class]]) {
			[self startAnimationWithView:subView hud:hud];
			break;
		}
	}
	hud.contentColor = kContentColor;
	hud.bezelView.backgroundColor = kContentBackFroundColor;
	hud.backgroundView.alpha = 0;
	hud.label.text = message;
	hud.label.numberOfLines = 0;
	hud.removeFromSuperViewOnHide = YES;
}

+ (void)startAnimationWithView:(UIView *)view hud:(MBProgressHUD *)hud {
	[UIView animateWithDuration:1.f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
		view.transform = CGAffineTransformRotate(view.transform, M_PI);
	} completion:^(BOOL finished) {
		//if (!hud.) {
			[self startAnimationWithView:view hud:hud];
		//}
	}];
}

+ (void)showIndicator
{
    [self showIndicatorWithView:nil];
}
#pragma mark 显示一些信息
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view complication:(ComplicationOption)option{
    
    if (view == nil) {
        return nil;
    }
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
	hud.contentColor = kContentColor;
	hud.bezelView.backgroundColor = kContentBackFroundColor;
    hud.label.text = message;
	hud.label.numberOfLines = 0;
    hud.mode = MBProgressHUDModeText;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;

    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    
    hud.animationType = MBProgressHUDAnimationZoom;
	hud.offset = CGPointMake(0, -32.0);
    // 1.5秒之后再消失
    hud.completionBlock = option;
	CGFloat time = 1.5f;
	CGRect rect = [hud.label textRectForBounds:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) limitedToNumberOfLines:0];
	if (rect.size.width > 0.75f*[UIScreen mainScreen].bounds.size.width) {
		time = 4.f;
	}
    [hud hideAnimated:YES afterDelay:time];
    
    return hud;
}

+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view
{
    return [self showMessage:message toView:view complication:nil];
}

+ (void)hideHUDForView:(UIView *)view
{
    if (view == nil) {
        return;
    }
    [self hideHUDForView:view animated:NO];
}

@end
