//
//  YKLives.h
//
//  Created by   on 2017/5/24
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YKExtra, YKCreator;

@interface YKLives : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *livesIdentifier;
@property (nonatomic, strong) YKExtra *extra;
@property (nonatomic, strong) NSArray *like;
@property (nonatomic, assign) double rotate;
@property (nonatomic, assign) double version;
@property (nonatomic, assign) double onlineUsers;
@property (nonatomic, assign) double multi;
@property (nonatomic, assign) double link;
@property (nonatomic, strong) NSString *shareAddr;
@property (nonatomic, assign) double slot;
@property (nonatomic, strong) YKCreator *creator;
@property (nonatomic, assign) double group;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *liveType;
@property (nonatomic, strong) NSString *streamAddr;
@property (nonatomic, assign) double optimal;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) double landscape;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
