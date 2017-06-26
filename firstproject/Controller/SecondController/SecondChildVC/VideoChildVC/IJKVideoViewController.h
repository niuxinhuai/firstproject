//
//  IJKVideoViewController.h
//  firstproject
//
//  Created by 牛新怀 on 2017/5/24.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#import "NBasiViewController.h"

@interface IJKVideoViewController : NBasiViewController
@property (nonatomic, strong)NSString * videoStream_addr;
@property (nonatomic, strong)YKLives * videoLives;
@property (nonatomic, strong)NSArray * scrollArray;
@end
