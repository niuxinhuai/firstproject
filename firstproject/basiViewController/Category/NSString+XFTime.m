//
//  AppDelegate.m
//  firstproject
//
//  Created by 牛新怀 on 2017/5/9.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#import "NSString+XFTime.h"

@implementation NSString (XFTime)
+ (NSString *)stringWithTime:(NSTimeInterval)time {
    
    NSInteger min = time / 60;
    NSInteger second = (NSInteger)time % 60;
    
    return [NSString stringWithFormat:@"%02ld:%02ld", min, second];
}
@end
