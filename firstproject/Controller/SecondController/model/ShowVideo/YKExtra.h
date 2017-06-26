//
//  YKExtra.h
//
//  Created by   on 2017/5/24
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface YKExtra : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) id cover;
@property (nonatomic, strong) NSArray *label;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
