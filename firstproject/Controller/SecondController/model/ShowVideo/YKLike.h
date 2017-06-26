//
//  YKLike.h
//
//  Created by   on 2017/5/24
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface YKLike : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double likeIdentifier;
@property (nonatomic, strong) NSString *icon;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
