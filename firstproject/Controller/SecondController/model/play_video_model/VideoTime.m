//
//  VideoTime.m
//  firstproject
//
//  Created by 牛新怀 on 2017/8/2.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#import "VideoTime.h"

@implementation VideoTime
// 获取时间
+ (NSString *)convertTime:(CGFloat)second{
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:second];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (second/3600 >= 1) {
        [formatter setDateFormat:@"HH:mm:ss"];
    } else {
        [formatter setDateFormat:@"mm:ss"];
    }
    NSString *showtimeNew = [formatter stringFromDate:d];
    return showtimeNew;
}
+(UIButton *)createButtonWithImageName:(NSString *)imageName withTag:(NSInteger)tag{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = tag;
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    
    
    [button sizeToFit];
    return button;
}
@end
