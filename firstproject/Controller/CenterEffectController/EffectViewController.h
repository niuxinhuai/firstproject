//
//  EffectViewController.h
//  firstproject
//
//  Created by 牛新怀 on 2017/8/22.
//  Copyright © 2017年 牛新怀. All rights reserved.
//
typedef void(^CancleBlock)();
#import <UIKit/UIKit.h>

@interface EffectViewController : UIViewController
@property (copy, nonatomic)CancleBlock dismissBlock;
@end
