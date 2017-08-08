//
//  VideoTime.h
//  firstproject
//
//  Created by 牛新怀 on 2017/8/2.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoTime : NSObject
// 获取时间
+ (NSString *)convertTime:(CGFloat)second;
+(UIButton *)createButtonWithImageName:(NSString *)imageName withTag:(NSInteger)tag;
+ (UIImage*) thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time;
@end
