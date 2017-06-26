//
//  YKCreator.m
//
//  Created by   on 2017/5/24
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "YKCreator.h"


NSString *const kYKCreatorGender = @"gender";
NSString *const kYKCreatorId = @"id";
NSString *const kYKCreatorLevel = @"level";
NSString *const kYKCreatorNick = @"nick";
NSString *const kYKCreatorPortrait = @"portrait";


@interface YKCreator ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation YKCreator

@synthesize gender = _gender;
@synthesize creatorIdentifier = _creatorIdentifier;
@synthesize level = _level;
@synthesize nick = _nick;
@synthesize portrait = _portrait;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.gender = [[self objectOrNilForKey:kYKCreatorGender fromDictionary:dict] doubleValue];
            self.creatorIdentifier = [[self objectOrNilForKey:kYKCreatorId fromDictionary:dict] doubleValue];
            self.level = [[self objectOrNilForKey:kYKCreatorLevel fromDictionary:dict] doubleValue];
            self.nick = [self objectOrNilForKey:kYKCreatorNick fromDictionary:dict];
            self.portrait = [self objectOrNilForKey:kYKCreatorPortrait fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.gender] forKey:kYKCreatorGender];
    [mutableDict setValue:[NSNumber numberWithDouble:self.creatorIdentifier] forKey:kYKCreatorId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.level] forKey:kYKCreatorLevel];
    [mutableDict setValue:self.nick forKey:kYKCreatorNick];
    [mutableDict setValue:self.portrait forKey:kYKCreatorPortrait];

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

    self.gender = [aDecoder decodeDoubleForKey:kYKCreatorGender];
    self.creatorIdentifier = [aDecoder decodeDoubleForKey:kYKCreatorId];
    self.level = [aDecoder decodeDoubleForKey:kYKCreatorLevel];
    self.nick = [aDecoder decodeObjectForKey:kYKCreatorNick];
    self.portrait = [aDecoder decodeObjectForKey:kYKCreatorPortrait];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_gender forKey:kYKCreatorGender];
    [aCoder encodeDouble:_creatorIdentifier forKey:kYKCreatorId];
    [aCoder encodeDouble:_level forKey:kYKCreatorLevel];
    [aCoder encodeObject:_nick forKey:kYKCreatorNick];
    [aCoder encodeObject:_portrait forKey:kYKCreatorPortrait];
}

- (id)copyWithZone:(NSZone *)zone {
    YKCreator *copy = [[YKCreator alloc] init];
    
    
    
    if (copy) {

        copy.gender = self.gender;
        copy.creatorIdentifier = self.creatorIdentifier;
        copy.level = self.level;
        copy.nick = [self.nick copyWithZone:zone];
        copy.portrait = [self.portrait copyWithZone:zone];
    }
    
    return copy;
}


@end
