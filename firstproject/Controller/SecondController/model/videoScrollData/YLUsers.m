//
//  YLUsers.m
//
//  Created by   on 2017/5/26
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "YLUsers.h"


NSString *const kYLUsersId = @"id";
NSString *const kYLUsersThirdPlatform = @"third_platform";
NSString *const kYLUsersDescription = @"description";
NSString *const kYLUsersRankVeri = @"rank_veri";
NSString *const kYLUsersSex = @"sex";
NSString *const kYLUsersGmutex = @"gmutex";
NSString *const kYLUsersVerified = @"verified";
NSString *const kYLUsersEmotion = @"emotion";
NSString *const kYLUsersNick = @"nick";
NSString *const kYLUsersInkeVerify = @"inke_verify";
NSString *const kYLUsersVerifiedReason = @"verified_reason";
NSString *const kYLUsersBirth = @"birth";
NSString *const kYLUsersLocation = @"location";
NSString *const kYLUsersPortrait = @"portrait";
NSString *const kYLUsersHometown = @"hometown";
NSString *const kYLUsersLevel = @"level";
NSString *const kYLUsersVeriInfo = @"veri_info";
NSString *const kYLUsersGender = @"gender";


@interface YLUsers ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation YLUsers

@synthesize usersIdentifier = _usersIdentifier;
@synthesize thirdPlatform = _thirdPlatform;
@synthesize usersDescription = _usersDescription;
@synthesize rankVeri = _rankVeri;
@synthesize sex = _sex;
@synthesize gmutex = _gmutex;
@synthesize verified = _verified;
@synthesize emotion = _emotion;
@synthesize nick = _nick;
@synthesize inkeVerify = _inkeVerify;
@synthesize verifiedReason = _verifiedReason;
@synthesize birth = _birth;
@synthesize location = _location;
@synthesize portrait = _portrait;
@synthesize hometown = _hometown;
@synthesize level = _level;
@synthesize veriInfo = _veriInfo;
@synthesize gender = _gender;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.usersIdentifier = [[self objectOrNilForKey:kYLUsersId fromDictionary:dict] doubleValue];
            self.thirdPlatform = [self objectOrNilForKey:kYLUsersThirdPlatform fromDictionary:dict];
            self.usersDescription = [self objectOrNilForKey:kYLUsersDescription fromDictionary:dict];
            self.rankVeri = [[self objectOrNilForKey:kYLUsersRankVeri fromDictionary:dict] doubleValue];
            self.sex = [[self objectOrNilForKey:kYLUsersSex fromDictionary:dict] doubleValue];
            self.gmutex = [[self objectOrNilForKey:kYLUsersGmutex fromDictionary:dict] doubleValue];
            self.verified = [[self objectOrNilForKey:kYLUsersVerified fromDictionary:dict] doubleValue];
            self.emotion = [self objectOrNilForKey:kYLUsersEmotion fromDictionary:dict];
            self.nick = [self objectOrNilForKey:kYLUsersNick fromDictionary:dict];
            self.inkeVerify = [[self objectOrNilForKey:kYLUsersInkeVerify fromDictionary:dict] doubleValue];
            self.verifiedReason = [self objectOrNilForKey:kYLUsersVerifiedReason fromDictionary:dict];
            self.birth = [self objectOrNilForKey:kYLUsersBirth fromDictionary:dict];
            self.location = [self objectOrNilForKey:kYLUsersLocation fromDictionary:dict];
            self.portrait = [self objectOrNilForKey:kYLUsersPortrait fromDictionary:dict];
            self.hometown = [self objectOrNilForKey:kYLUsersHometown fromDictionary:dict];
            self.level = [[self objectOrNilForKey:kYLUsersLevel fromDictionary:dict] doubleValue];
            self.veriInfo = [self objectOrNilForKey:kYLUsersVeriInfo fromDictionary:dict];
            self.gender = [[self objectOrNilForKey:kYLUsersGender fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.usersIdentifier] forKey:kYLUsersId];
    [mutableDict setValue:self.thirdPlatform forKey:kYLUsersThirdPlatform];
    [mutableDict setValue:self.usersDescription forKey:kYLUsersDescription];
    [mutableDict setValue:[NSNumber numberWithDouble:self.rankVeri] forKey:kYLUsersRankVeri];
    [mutableDict setValue:[NSNumber numberWithDouble:self.sex] forKey:kYLUsersSex];
    [mutableDict setValue:[NSNumber numberWithDouble:self.gmutex] forKey:kYLUsersGmutex];
    [mutableDict setValue:[NSNumber numberWithDouble:self.verified] forKey:kYLUsersVerified];
    [mutableDict setValue:self.emotion forKey:kYLUsersEmotion];
    [mutableDict setValue:self.nick forKey:kYLUsersNick];
    [mutableDict setValue:[NSNumber numberWithDouble:self.inkeVerify] forKey:kYLUsersInkeVerify];
    [mutableDict setValue:self.verifiedReason forKey:kYLUsersVerifiedReason];
    [mutableDict setValue:self.birth forKey:kYLUsersBirth];
    [mutableDict setValue:self.location forKey:kYLUsersLocation];
    [mutableDict setValue:self.portrait forKey:kYLUsersPortrait];
    [mutableDict setValue:self.hometown forKey:kYLUsersHometown];
    [mutableDict setValue:[NSNumber numberWithDouble:self.level] forKey:kYLUsersLevel];
    [mutableDict setValue:self.veriInfo forKey:kYLUsersVeriInfo];
    [mutableDict setValue:[NSNumber numberWithDouble:self.gender] forKey:kYLUsersGender];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description  {
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict {
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];

    self.usersIdentifier = [aDecoder decodeDoubleForKey:kYLUsersId];
    self.thirdPlatform = [aDecoder decodeObjectForKey:kYLUsersThirdPlatform];
    self.usersDescription = [aDecoder decodeObjectForKey:kYLUsersDescription];
    self.rankVeri = [aDecoder decodeDoubleForKey:kYLUsersRankVeri];
    self.sex = [aDecoder decodeDoubleForKey:kYLUsersSex];
    self.gmutex = [aDecoder decodeDoubleForKey:kYLUsersGmutex];
    self.verified = [aDecoder decodeDoubleForKey:kYLUsersVerified];
    self.emotion = [aDecoder decodeObjectForKey:kYLUsersEmotion];
    self.nick = [aDecoder decodeObjectForKey:kYLUsersNick];
    self.inkeVerify = [aDecoder decodeDoubleForKey:kYLUsersInkeVerify];
    self.verifiedReason = [aDecoder decodeObjectForKey:kYLUsersVerifiedReason];
    self.birth = [aDecoder decodeObjectForKey:kYLUsersBirth];
    self.location = [aDecoder decodeObjectForKey:kYLUsersLocation];
    self.portrait = [aDecoder decodeObjectForKey:kYLUsersPortrait];
    self.hometown = [aDecoder decodeObjectForKey:kYLUsersHometown];
    self.level = [aDecoder decodeDoubleForKey:kYLUsersLevel];
    self.veriInfo = [aDecoder decodeObjectForKey:kYLUsersVeriInfo];
    self.gender = [aDecoder decodeDoubleForKey:kYLUsersGender];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_usersIdentifier forKey:kYLUsersId];
    [aCoder encodeObject:_thirdPlatform forKey:kYLUsersThirdPlatform];
    [aCoder encodeObject:_usersDescription forKey:kYLUsersDescription];
    [aCoder encodeDouble:_rankVeri forKey:kYLUsersRankVeri];
    [aCoder encodeDouble:_sex forKey:kYLUsersSex];
    [aCoder encodeDouble:_gmutex forKey:kYLUsersGmutex];
    [aCoder encodeDouble:_verified forKey:kYLUsersVerified];
    [aCoder encodeObject:_emotion forKey:kYLUsersEmotion];
    [aCoder encodeObject:_nick forKey:kYLUsersNick];
    [aCoder encodeDouble:_inkeVerify forKey:kYLUsersInkeVerify];
    [aCoder encodeObject:_verifiedReason forKey:kYLUsersVerifiedReason];
    [aCoder encodeObject:_birth forKey:kYLUsersBirth];
    [aCoder encodeObject:_location forKey:kYLUsersLocation];
    [aCoder encodeObject:_portrait forKey:kYLUsersPortrait];
    [aCoder encodeObject:_hometown forKey:kYLUsersHometown];
    [aCoder encodeDouble:_level forKey:kYLUsersLevel];
    [aCoder encodeObject:_veriInfo forKey:kYLUsersVeriInfo];
    [aCoder encodeDouble:_gender forKey:kYLUsersGender];
}

- (id)copyWithZone:(NSZone *)zone {
    YLUsers *copy = [[YLUsers alloc] init];
    
    
    
    if (copy) {

        copy.usersIdentifier = self.usersIdentifier;
        copy.thirdPlatform = [self.thirdPlatform copyWithZone:zone];
        copy.usersDescription = [self.usersDescription copyWithZone:zone];
        copy.rankVeri = self.rankVeri;
        copy.sex = self.sex;
        copy.gmutex = self.gmutex;
        copy.verified = self.verified;
        copy.emotion = [self.emotion copyWithZone:zone];
        copy.nick = [self.nick copyWithZone:zone];
        copy.inkeVerify = self.inkeVerify;
        copy.verifiedReason = [self.verifiedReason copyWithZone:zone];
        copy.birth = [self.birth copyWithZone:zone];
        copy.location = [self.location copyWithZone:zone];
        copy.portrait = [self.portrait copyWithZone:zone];
        copy.hometown = [self.hometown copyWithZone:zone];
        copy.level = self.level;
        copy.veriInfo = [self.veriInfo copyWithZone:zone];
        copy.gender = self.gender;
    }
    
    return copy;
}


@end
