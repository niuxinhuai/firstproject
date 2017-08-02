//
//  PracticesViewController.h
//  firstproject
//
//  Created by 牛新怀 on 2017/5/24.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, Direction) {
    DirectionLeftOrRight,
    DirectionUpOrDown,
    DirectionNone
    
};
typedef NS_ENUM(NSUInteger,UserChouseButtonTag){
    UserChouseButtonTagWithFillScreen     =100,// 全屏
    UserChouseButtonTagWithVoice          =101,// 声音
    UserChouseButtonTagWithBegin          =102,// 开始暂停
    
};
@interface PracticesViewController : NBasiViewController

@end
