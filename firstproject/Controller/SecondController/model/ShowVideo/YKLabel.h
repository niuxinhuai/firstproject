//
//  YKLabel.h
//
//  Created by   on 2017/5/24
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface YKLabel : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *tabKey;
@property (nonatomic, strong) NSString *tabName;
@property (nonatomic, strong) NSArray *cl;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
