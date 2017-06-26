//
//  NBasiViewController.h
//  firstproject
//
//  Created by 牛新怀 on 2017/5/17.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,BarButtonItemTitleColorType){// 导航条颜色
    ButtonItemTitleColorTypeBlue=0,
    ButtonItemTitleColorTypeWhite
    
};
typedef NS_ENUM(NSInteger,NavigationTitleColorType) {//导航条title字体颜色
    NavigationTitleColorTypeBlue,
    NavigationTitleColorTypeWhite
    
};
@interface NBasiViewController : UIViewController
@property (nonatomic, assign)BarButtonItemTitleColorType colorType;
@property (nonatomic, assign)NavigationTitleColorType navColorType;

@end
