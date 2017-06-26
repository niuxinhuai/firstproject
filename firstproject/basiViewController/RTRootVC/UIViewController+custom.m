//
//  UIViewController+custom.m
//  firstproject
//
//  Created by 牛新怀 on 2017/6/23.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#import "UIViewController+custom.h"
#import <objc/runtime.h>
@implementation UIViewController (custom)
+(void)load{
    SEL originalSelector = @selector(viewWillAppear:);
    SEL swizzledSelector = @selector(nx_viewViewAppear:);
    /*
     改变系统方法使用class_getInstanceMethod("","");
     */
    Method originalMethod = class_getInstanceMethod([self class], originalSelector);
    Method swizzledMethod = class_getInstanceMethod([self class], swizzledSelector);
    method_exchangeImplementations(originalMethod, swizzledMethod);
}
-(void)nx_viewViewAppear:(BOOL)isAnimation{
    NSString * strClass = NSStringFromClass([self class]);
    
    
    NSLog(@"%@ customViewController",strClass);
    [self nx_viewViewAppear:isAnimation];
}
@end
