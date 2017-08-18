//
//  UIView+HUD.m
//  firstproject
//
//  Created by 牛新怀 on 2017/8/18.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#import "UIView+HUD.h"
#import <MBProgressHUD.h>
@implementation UIView (HUD)
- (void)showHUDView{
    MBProgressHUD * HUD = [[MBProgressHUD alloc]init];
    HUD.mode = MBProgressHUDModeIndeterminate;
    [HUD showHUDView];
}
- (void)hideSUDView{
    
}




@end
