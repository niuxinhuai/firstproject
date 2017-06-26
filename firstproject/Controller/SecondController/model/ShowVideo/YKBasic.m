//
//  YKBasic.m
//
//  Created by   on 2017/5/24
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "YKBasic.h"
#import "YKLives.h"


NSString *const kYKBasicExpireTime = @"expire_time";
NSString *const kYKBasicLives = @"lives";
NSString *const kYKBasicDmError = @"dm_error";
NSString *const kYKBasicErrorMsg = @"error_msg";


@interface YKBasic ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation YKBasic

@synthesize expireTime = _expireTime;
@synthesize lives = _lives;
@synthesize dmError = _dmError;
@synthesize errorMsg = _errorMsg;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.expireTime = [[self objectOrNilForKey:kYKBasicExpireTime fromDictionary:dict] doubleValue];
    NSObject *receivedYKLives = [dict objectForKey:kYKBasicLives];
    NSMutableArray *parsedYKLives = [NSMutableArray array];
    
    if ([receivedYKLives isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedYKLives) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedYKLives addObject:[YKLives modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedYKLives isKindOfClass:[NSDictionary class]]) {
       [parsedYKLives addObject:[YKLives modelObjectWithDictionary:(NSDictionary *)receivedYKLives]];
    }

    self.lives = [NSArray arrayWithArray:parsedYKLives];
            self.dmError = [[self objectOrNilForKey:kYKBasicDmError fromDictionary:dict] doubleValue];
            self.errorMsg = [self objectOrNilForKey:kYKBasicErrorMsg fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.expireTime] forKey:kYKBasicExpireTime];
    NSMutableArray *tempArrayForLives = [NSMutableArray array];
    
    for (NSObject *subArrayObject in self.lives) {
        if ([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForLives addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForLives addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForLives] forKey:kYKBasicLives];
    [mutableDict setValue:[NSNumber numberWithDouble:self.dmError] forKey:kYKBasicDmError];
    [mutableDict setValue:self.errorMsg forKey:kYKBasicErrorMsg];

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

    self.expireTime = [aDecoder decodeDoubleForKey:kYKBasicExpireTime];
    self.lives = [aDecoder decodeObjectForKey:kYKBasicLives];
    self.dmError = [aDecoder decodeDoubleForKey:kYKBasicDmError];
    self.errorMsg = [aDecoder decodeObjectForKey:kYKBasicErrorMsg];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_expireTime forKey:kYKBasicExpireTime];
    [aCoder encodeObject:_lives forKey:kYKBasicLives];
    [aCoder encodeDouble:_dmError forKey:kYKBasicDmError];
    [aCoder encodeObject:_errorMsg forKey:kYKBasicErrorMsg];
}

- (id)copyWithZone:(NSZone *)zone {
    YKBasic *copy = [[YKBasic alloc] init];
    
    
    
    if (copy) {

        copy.expireTime = self.expireTime;
        copy.lives = [self.lives copyWithZone:zone];
        copy.dmError = self.dmError;
        copy.errorMsg = [self.errorMsg copyWithZone:zone];
    }
    
    return copy;
}


@end
