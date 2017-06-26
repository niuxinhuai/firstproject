//
//  LLView.h
//  firstproject
//
//  Created by 牛新怀 on 2017/6/7.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,ScrollBackColor){// 上部分scroll背景颜色
    ScrollBackColorWhite              =10,
    ScrollBackColorAlphaWhiteColor,
};
@interface LLView : UIViewController
@property (assign, nonatomic) ScrollBackColor topScrollBackGroundColorType;
@property (strong, nonatomic) NSArray * topTitleArray;// 顶部滚动的数组
@property (strong, nonatomic) NSArray * childViewControlArray;
@property (strong, nonatomic) UIFont * titleFont;
@property (strong, nonatomic) UIColor * selectColor;
@property (strong, nonatomic) UIColor * normalColor;
@property (strong, nonatomic) UIView * lineView;
@end
