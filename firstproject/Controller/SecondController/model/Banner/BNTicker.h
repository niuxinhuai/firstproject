//
//  BNTicker.h
//
//  Created by   on 2017/5/25
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface BNTicker : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *link;
@property (nonatomic, assign) double atom;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
