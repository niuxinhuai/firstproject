//
//  XHTabBar.h
//  firstproject
//
//  Created by 牛新怀 on 2017/8/22.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XHTabBar;
@protocol XHTabBarDelegate <NSObject>


- (void)tabBarPlusBtnClick:(XHTabBar *)tabBar withButton:(UIButton *)btn;
@end
@interface XHTabBar : UITabBar
@property (weak, nonatomic)id<XHTabBarDelegate>myDelegate;
/** plus按钮 */
@property (nonatomic, weak) UIButton *plusBtn ;
@end
