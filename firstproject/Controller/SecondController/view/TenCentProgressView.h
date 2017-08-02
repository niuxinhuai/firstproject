//
//  TenCentProgressView.h
//  firstproject
//
//  Created by 牛新怀 on 2017/8/1.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TenCentProgressView : UIView
@property (nonatomic, strong) CAShapeLayer * animationLayer;
- (void)tencentStartAnimation;
@end
