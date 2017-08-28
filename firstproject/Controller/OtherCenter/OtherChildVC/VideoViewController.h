//
//  VideoViewController.h
//  firstproject
//
//  Created by 牛新怀 on 2017/5/22.
//  Copyright © 2017年 牛新怀. All rights reserved.
//
typedef void(^CancleBlock)(UIImage * images);
#import "NBasiViewController.h"

@interface VideoViewController : NBasiViewController
@property (copy, nonatomic)CancleBlock backBlock;
@end
