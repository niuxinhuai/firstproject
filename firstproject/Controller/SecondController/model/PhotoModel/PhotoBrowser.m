//
//  PhotoBrowser.m
//  firstproject
//
//  Created by 牛新怀 on 2017/9/9.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#import "PhotoBrowser.h"

@implementation PhotoBrowser
+ (NSMutableArray *)imageDataSourceArray{
    NSMutableArray * array = [NSMutableArray array];
    for (int idx =0; idx<5; idx++) {
        NSString * imageNamed = [NSString stringWithFormat:@"animation%d.jpg",idx+1];
        [array addObject:imageNamed];
    }
    return [array copy];
}
@end
