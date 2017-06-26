//
//  YKLives.m
//
//  Created by   on 2017/5/24
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "YKLives.h"
#import "YKExtra.h"
#import "YKCreator.h"


NSString *const kYKLivesId = @"id";
NSString *const kYKLivesExtra = @"extra";
NSString *const kYKLivesLike = @"like";
NSString *const kYKLivesRotate = @"rotate";
NSString *const kYKLivesVersion = @"version";
NSString *const kYKLivesOnlineUsers = @"online_users";
NSString *const kYKLivesMulti = @"multi";
NSString *const kYKLivesLink = @"link";
NSString *const kYKLivesShareAddr = @"share_addr";
NSString *const kYKLivesSlot = @"slot";
NSString *const kYKLivesCreator = @"creator";
NSString *const kYKLivesGroup = @"group";
NSString *const kYKLivesCity = @"city";
NSString *const kYKLivesLiveType = @"live_type";
NSString *const kYKLivesStreamAddr = @"stream_addr";
NSString *const kYKLivesOptimal = @"optimal";
NSString *const kYKLivesName = @"name";
NSString *const kYKLivesLandscape = @"landscape";


@interface YKLives ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation YKLives

@synthesize livesIdentifier = _livesIdentifier;
@synthesize extra = _extra;
@synthesize like = _like;
@synthesize rotate = _rotate;
@synthesize version = _version;
@synthesize onlineUsers = _onlineUsers;
@synthesize multi = _multi;
@synthesize link = _link;
@synthesize shareAddr = _shareAddr;
@synthesize slot = _slot;
@synthesize creator = _creator;
@synthesize group = _group;
@synthesize city = _city;
@synthesize liveType = _liveType;
@synthesize streamAddr = _streamAddr;
@synthesize optimal = _optimal;
@synthesize name = _name;
@synthesize landscape = _landscape;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.livesIdentifier = [self objectOrNilForKey:kYKLivesId fromDictionary:dict];
            self.extra = [YKExtra modelObjectWithDictionary:[dict objectForKey:kYKLivesExtra]];
            self.like = [self objectOrNilForKey:kYKLivesLike fromDictionary:dict];
            self.rotate = [[self objectOrNilForKey:kYKLivesRotate fromDictionary:dict] doubleValue];
            self.version = [[self objectOrNilForKey:kYKLivesVersion fromDictionary:dict] doubleValue];
            self.onlineUsers = [[self objectOrNilForKey:kYKLivesOnlineUsers fromDictionary:dict] doubleValue];
            self.multi = [[self objectOrNilForKey:kYKLivesMulti fromDictionary:dict] doubleValue];
            self.link = [[self objectOrNilForKey:kYKLivesLink fromDictionary:dict] doubleValue];
            self.shareAddr = [self objectOrNilForKey:kYKLivesShareAddr fromDictionary:dict];
            self.slot = [[self objectOrNilForKey:kYKLivesSlot fromDictionary:dict] doubleValue];
            self.creator = [YKCreator modelObjectWithDictionary:[dict objectForKey:kYKLivesCreator]];
            self.group = [[self objectOrNilForKey:kYKLivesGroup fromDictionary:dict] doubleValue];
            self.city = [self objectOrNilForKey:kYKLivesCity fromDictionary:dict];
            self.liveType = [self objectOrNilForKey:kYKLivesLiveType fromDictionary:dict];
            self.streamAddr = [self objectOrNilForKey:kYKLivesStreamAddr fromDictionary:dict];
            self.optimal = [[self objectOrNilForKey:kYKLivesOptimal fromDictionary:dict] doubleValue];
            self.name = [self objectOrNilForKey:kYKLivesName fromDictionary:dict];
            self.landscape = [[self objectOrNilForKey:kYKLivesLandscape fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.livesIdentifier forKey:kYKLivesId];
    [mutableDict setValue:[self.extra dictionaryRepresentation] forKey:kYKLivesExtra];
    NSMutableArray *tempArrayForLike = [NSMutableArray array];
    
    for (NSObject *subArrayObject in self.like) {
        if ([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForLike addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForLike addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForLike] forKey:kYKLivesLike];
    [mutableDict setValue:[NSNumber numberWithDouble:self.rotate] forKey:kYKLivesRotate];
    [mutableDict setValue:[NSNumber numberWithDouble:self.version] forKey:kYKLivesVersion];
    [mutableDict setValue:[NSNumber numberWithDouble:self.onlineUsers] forKey:kYKLivesOnlineUsers];
    [mutableDict setValue:[NSNumber numberWithDouble:self.multi] forKey:kYKLivesMulti];
    [mutableDict setValue:[NSNumber numberWithDouble:self.link] forKey:kYKLivesLink];
    [mutableDict setValue:self.shareAddr forKey:kYKLivesShareAddr];
    [mutableDict setValue:[NSNumber numberWithDouble:self.slot] forKey:kYKLivesSlot];
    [mutableDict setValue:[self.creator dictionaryRepresentation] forKey:kYKLivesCreator];
    [mutableDict setValue:[NSNumber numberWithDouble:self.group] forKey:kYKLivesGroup];
    [mutableDict setValue:self.city forKey:kYKLivesCity];
    [mutableDict setValue:self.liveType forKey:kYKLivesLiveType];
    [mutableDict setValue:self.streamAddr forKey:kYKLivesStreamAddr];
    [mutableDict setValue:[NSNumber numberWithDouble:self.optimal] forKey:kYKLivesOptimal];
    [mutableDict setValue:self.name forKey:kYKLivesName];
    [mutableDict setValue:[NSNumber numberWithDouble:self.landscape] forKey:kYKLivesLandscape];

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

    self.livesIdentifier = [aDecoder decodeObjectForKey:kYKLivesId];
    self.extra = [aDecoder decodeObjectForKey:kYKLivesExtra];
    self.like = [aDecoder decodeObjectForKey:kYKLivesLike];
    self.rotate = [aDecoder decodeDoubleForKey:kYKLivesRotate];
    self.version = [aDecoder decodeDoubleForKey:kYKLivesVersion];
    self.onlineUsers = [aDecoder decodeDoubleForKey:kYKLivesOnlineUsers];
    self.multi = [aDecoder decodeDoubleForKey:kYKLivesMulti];
    self.link = [aDecoder decodeDoubleForKey:kYKLivesLink];
    self.shareAddr = [aDecoder decodeObjectForKey:kYKLivesShareAddr];
    self.slot = [aDecoder decodeDoubleForKey:kYKLivesSlot];
    self.creator = [aDecoder decodeObjectForKey:kYKLivesCreator];
    self.group = [aDecoder decodeDoubleForKey:kYKLivesGroup];
    self.city = [aDecoder decodeObjectForKey:kYKLivesCity];
    self.liveType = [aDecoder decodeObjectForKey:kYKLivesLiveType];
    self.streamAddr = [aDecoder decodeObjectForKey:kYKLivesStreamAddr];
    self.optimal = [aDecoder decodeDoubleForKey:kYKLivesOptimal];
    self.name = [aDecoder decodeObjectForKey:kYKLivesName];
    self.landscape = [aDecoder decodeDoubleForKey:kYKLivesLandscape];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_livesIdentifier forKey:kYKLivesId];
    [aCoder encodeObject:_extra forKey:kYKLivesExtra];
    [aCoder encodeObject:_like forKey:kYKLivesLike];
    [aCoder encodeDouble:_rotate forKey:kYKLivesRotate];
    [aCoder encodeDouble:_version forKey:kYKLivesVersion];
    [aCoder encodeDouble:_onlineUsers forKey:kYKLivesOnlineUsers];
    [aCoder encodeDouble:_multi forKey:kYKLivesMulti];
    [aCoder encodeDouble:_link forKey:kYKLivesLink];
    [aCoder encodeObject:_shareAddr forKey:kYKLivesShareAddr];
    [aCoder encodeDouble:_slot forKey:kYKLivesSlot];
    [aCoder encodeObject:_creator forKey:kYKLivesCreator];
    [aCoder encodeDouble:_group forKey:kYKLivesGroup];
    [aCoder encodeObject:_city forKey:kYKLivesCity];
    [aCoder encodeObject:_liveType forKey:kYKLivesLiveType];
    [aCoder encodeObject:_streamAddr forKey:kYKLivesStreamAddr];
    [aCoder encodeDouble:_optimal forKey:kYKLivesOptimal];
    [aCoder encodeObject:_name forKey:kYKLivesName];
    [aCoder encodeDouble:_landscape forKey:kYKLivesLandscape];
}

- (id)copyWithZone:(NSZone *)zone {
    YKLives *copy = [[YKLives alloc] init];
    
    
    
    if (copy) {

        copy.livesIdentifier = [self.livesIdentifier copyWithZone:zone];
        copy.extra = [self.extra copyWithZone:zone];
        copy.like = [self.like copyWithZone:zone];
        copy.rotate = self.rotate;
        copy.version = self.version;
        copy.onlineUsers = self.onlineUsers;
        copy.multi = self.multi;
        copy.link = self.link;
        copy.shareAddr = [self.shareAddr copyWithZone:zone];
        copy.slot = self.slot;
        copy.creator = [self.creator copyWithZone:zone];
        copy.group = self.group;
        copy.city = [self.city copyWithZone:zone];
        copy.liveType = [self.liveType copyWithZone:zone];
        copy.streamAddr = [self.streamAddr copyWithZone:zone];
        copy.optimal = self.optimal;
        copy.name = [self.name copyWithZone:zone];
        copy.landscape = self.landscape;
    }
    
    return copy;
}


@end
