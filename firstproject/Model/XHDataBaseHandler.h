//
//  XHDataBaseHandler.h
//  firstproject
//
//  Created by 牛新怀 on 2017/9/25.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XHDataBaseHandler : NSObject

+ (instancetype)shareInstance;

- (NSMutableArray *)totalCacheArray;

- (void)saveItemDic:(NSMutableDictionary *)dic
          className:(NSString *)name;

- (void)readCacheList;

- (void)delectAllList;
@end
