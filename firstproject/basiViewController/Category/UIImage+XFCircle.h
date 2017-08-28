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

+ (UIImage *) imageFromURLString: (NSString *) urlstring;// 从链接获取图片
// 方法一、添加UIImage分类
- (UIImage *)imageByApplyingAlpha:(CGFloat) alpha;
// 上传图片中的压缩图片
+(UIImage *)resizeImage:(UIImage *)image;

+ (UIImage *)sapicamera_rotateImageEx:(CGImageRef)imgRef orientation:(UIImageOrientation) orient;
+ (UIImage *)imageWithColor:(UIColor *)color;
// 截取当前屏幕为图片
+ (UIImage *)imageWithScreenshot;

@end
