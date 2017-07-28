//
//  NSObject+DebugDescription.m
//  firstproject
//
//  Created by 牛新怀 on 2017/7/28.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#import "NSObject+DebugDescription.h"
#import <objc/runtime.h>
@implementation NSObject (DebugDescription)
- (NSString *)debugDescription{
    if ([self isKindOfClass:[NSArray class]] ||
        [self isKindOfClass:[NSDictionary class]] ||
        [self isKindOfClass:[NSNumber class]] ||
        [self isKindOfClass:[NSString class]])
    {
        return self.debugDescription;
    }
    // 初始化一个字典
    NSMutableDictionary * mutableDictionary = [NSMutableDictionary dictionary];
    // 得到当前class的所有属性
    uint count;
    objc_property_t * properties = class_copyPropertyList([self class], &count);
    for (int i=0; i<count; i++) {// KVC得到每个属性的值
        objc_property_t property = properties[i];
        NSString *name = @(property_getName(property));
        id value = [self valueForKey:name] ? : @"nil";
        [mutableDictionary setObject:value forKey:name];
    }
    // 释放
    free(properties);
    return [NSString stringWithFormat:@"<%@: %p> -- %@",[self class],self,mutableDictionary];
    
    
}

- (NSString *)description{
    if ([self isKindOfClass:[NSArray class]] ||
        [self isKindOfClass:[NSDictionary class]] ||
        [self isKindOfClass:[NSNumber class]] ||
        [self isKindOfClass:[NSString class]])
    {
        return self.debugDescription;
    }
    // 初始化一个字典
    NSMutableDictionary * mutableDictionary = [NSMutableDictionary dictionary];
    // 得到当前class的所有属性
    uint count;
    objc_property_t * properties = class_copyPropertyList([self class], &count);
    for (int i=0; i<count; i++) {// KVC得到每个属性的值
        objc_property_t property = properties[i];
        NSString *name = @(property_getName(property));
        id value = [self valueForKey:name] ? : @"nil";
        [mutableDictionary setObject:value forKey:name];
    }
    // 释放
    free(properties);
    return [NSString stringWithFormat:@"<%@: %p> -- %@",[self class],self,mutableDictionary];
    
    
}

@end
