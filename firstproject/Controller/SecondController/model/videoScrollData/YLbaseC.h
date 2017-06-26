//
//  YLbaseC.h
//
//  Created by   on 2017/5/26
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface YLbaseC : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSArray *users;
@property (nonatomic, assign) double dmError;
@property (nonatomic, assign) double total;
@property (nonatomic, strong) NSString *errorMsg;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
