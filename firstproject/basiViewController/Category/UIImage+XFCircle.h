//
//  AppDelegate.h
//  firstproject
//
//  Created by 牛新怀 on 2017/5/9.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (XFCircle)
- (UIImage *)circleImage;// 防止离屏渲染为image添加圆角
+ (UIImage *) imageFromURLString: (NSString *) urlstring;
@end
