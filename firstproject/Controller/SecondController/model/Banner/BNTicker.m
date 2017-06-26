//
//  BNTicker.m
//
//  Created by   on 2017/5/25
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "BNTicker.h"


NSString *const kBNTickerImage = @"image";
NSString *const kBNTickerLink = @"link";
NSString *const kBNTickerAtom = @"atom";


@interface BNTicker ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation BNTicker

@synthesize image = _image;
@synthesize link = _link;
@synthesize atom = _atom;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.image = [self objectOrNilForKey:kBNTickerImage fromDictionary:dict];
            self.link = [self objectOrNilForKey:kBNTickerLink fromDictionary:dict];
            self.atom = [[self objectOrNilForKey:kBNTickerAtom fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.image forKey:kBNTickerImage];
    [mutableDict setValue:self.link forKey:kBNTickerLink];
    [mutableDict setValue:[NSNumber numberWithDouble:self.atom] forKey:kBNTickerAtom];

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

    self.image = [aDecoder decodeObjectForKey:kBNTickerImage];
    self.link = [aDecoder decodeObjectForKey:kBNTickerLink];
    self.atom = [aDecoder decodeDoubleForKey:kBNTickerAtom];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_image forKey:kBNTickerImage];
    [aCoder encodeObject:_link forKey:kBNTickerLink];
    [aCoder encodeDouble:_atom forKey:kBNTickerAtom];
}

- (id)copyWithZone:(NSZone *)zone {
    BNTicker *copy = [[BNTicker alloc] init];
    
    
    
    if (copy) {

        copy.image = [self.image copyWithZone:zone];
        copy.link = [self.link copyWithZone:zone];
        copy.atom = self.atom;
    }
    
    return copy;
}


@end
