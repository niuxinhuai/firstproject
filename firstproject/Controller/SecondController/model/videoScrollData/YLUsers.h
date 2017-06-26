//
//  YLUsers.h
//
//  Created by   on 2017/5/26
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface YLUsers : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double usersIdentifier;
@property (nonatomic, strong) NSString *thirdPlatform;
@property (nonatomic, strong) NSString *usersDescription;
@property (nonatomic, assign) double rankVeri;
@property (nonatomic, assign) double sex;
@property (nonatomic, assign) double gmutex;
@property (nonatomic, assign) double verified;
@property (nonatomic, strong) NSString *emotion;
@property (nonatomic, strong) NSString *nick;
@property (nonatomic, assign) double inkeVerify;
@property (nonatomic, strong) NSString *verifiedReason;
@property (nonatomic, strong) NSString *birth;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *portrait;
@property (nonatomic, strong) NSString *hometown;
@property (nonatomic, assign) double level;
@property (nonatomic, strong) NSString *veriInfo;
@property (nonatomic, assign) double gender;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
