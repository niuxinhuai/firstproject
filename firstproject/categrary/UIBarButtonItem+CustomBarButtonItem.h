//
//  UIBarButtonItem+CustomBarButtonItem.h
//  firstproject
//
//  Created by 牛新怀 on 2017/5/19.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (CustomBarButtonItem)

/*
 导航条按钮只有图片形式
 */
+(instancetype)barButtonItemWithImageNamed:(NSString *)imageNamed target:(id)target action:(SEL)action;
/*
 导航条按钮只有字体形式
 */
+(instancetype)barButtonItemWithItemTitle:(NSString *)title target:(id)target action:(SEL)action;
@end
