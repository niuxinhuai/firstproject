//
//  EmojiModel.m
//  firstproject
//
//  Created by 牛新怀 on 2017/6/3.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#import "EmojiModel.h"

@implementation EmojiModel
+(NSMutableArray *)getImageArray{
    NSMutableArray * mutableArray = [[NSMutableArray alloc]init];
    dispatch_queue_t q_concurrent = dispatch_queue_create("my_concurrent_queue", DISPATCH_QUEUE_CONCURRENT);
dispatch_async(q_concurrent, ^{
    for (int i=0; i<143; i++) {
        [mutableArray addObject:[NSString stringWithFormat:@"face%003d",i]];
    }
    
});
   
    return mutableArray;
}
@end
