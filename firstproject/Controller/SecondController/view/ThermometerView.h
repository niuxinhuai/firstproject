//
//  ThermometerView.h
//  firstproject
//
//  Created by 牛新怀 on 2017/7/31.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThermometerView : UIView
@property (nonatomic, strong)UIColor * fillColors;
@property (nonatomic, strong)UIColor * strokeColors;
@property (nonatomic, assign)CGFloat strokeEndBissniss;
- (void)start;
@end
