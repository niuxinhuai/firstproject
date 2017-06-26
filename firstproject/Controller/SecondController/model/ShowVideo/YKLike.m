//
//  YKLike.m
//
//  Created by   on 2017/5/24
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "YKLike.h"


NSString *const kYKLikeId = @"id";
NSString *const kYKLikeIcon = @"icon";


@interface YKLike ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation YKLike

@synthesize likeIdentifier = _likeIdentifier;
@synthesize icon = _icon;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.likeIdentifier = [[self objectOrNilForKey:kYKLikeId fromDictionary:dict] doubleValue];
            self.icon = [self objectOrNilForKey:kYKLikeIcon fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.likeIdentifier] forKey:kYKLikeId];
    [mutableDict setValue:self.icon forKey:kYKLikeIcon];

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

    self.likeIdentifier = [aDecoder decodeDoubleForKey:kYKLikeId];
    self.icon = [aDecoder decodeObjectForKey:kYKLikeIcon];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_likeIdentifier forKey:kYKLikeId];
    [aCoder encodeObject:_icon forKey:kYKLikeIcon];
}

- (id)copyWithZone:(NSZone *)zone {
    YKLike *copy = [[YKLike alloc] init];
    
    
    
    if (copy) {

        copy.likeIdentifier = self.likeIdentifier;
        copy.icon = [self.icon copyWithZone:zone];
    }
    
    return copy;
}


@end
