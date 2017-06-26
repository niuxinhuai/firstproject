//
//  BNBasic.h
//
//  Created by   on 2017/5/25
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface BNBasic : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSArray *ticker;
@property (nonatomic, assign) double dmError;
@property (nonatomic, strong) NSString *errorMsg;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
