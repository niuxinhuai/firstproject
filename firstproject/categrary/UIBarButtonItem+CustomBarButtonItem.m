//
//  UIBarButtonItem+CustomBarButtonItem.m
//  firstproject
//
//  Created by 牛新怀 on 2017/5/19.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#import "UIBarButtonItem+CustomBarButtonItem.h"
#import "UIColor+HexColor.h"

@implementation UIBarButtonItem (CustomBarButtonItem)

+(instancetype)barButtonItemWithImageNamed:(NSString *)imageNamed target:(id)target action:(SEL)action{
    UIButton * barButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if (imageNamed) {
        [barButton setImage:[UIImage imageNamed:imageNamed] forState:UIControlStateNormal];

    }else{
        barButton.backgroundColor = [UIColor redColor];
    }
    [barButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [barButton sizeToFit];
    
    return [[UIBarButtonItem alloc]initWithCustomView:barButton];
    
    
}

+(instancetype)barButtonItemWithItemTitle:(NSString *)title target:(id)target action:(SEL)action{
    UIButton * titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [titleButton setTitle:title forState:UIControlStateNormal];
    titleButton.userInteractionEnabled = YES;
    //字体颜色默认为红色
    [titleButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [titleButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [titleButton sizeToFit];
    
    return [[UIBarButtonItem alloc]initWithCustomView:titleButton];
    
    
}





@end
