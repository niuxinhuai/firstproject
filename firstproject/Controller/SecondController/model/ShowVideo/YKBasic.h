//
//  YKBasic.h
//
//  Created by   on 2017/5/24
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface YKBasic : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double expireTime;
@property (nonatomic, strong) NSArray *lives;
@property (nonatomic, assign) double dmError;
@property (nonatomic, strong) NSString *errorMsg;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
