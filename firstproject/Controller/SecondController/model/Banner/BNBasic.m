//
//  BNBasic.m
//
//  Created by   on 2017/5/25
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "BNBasic.h"
#import "BNTicker.h"


NSString *const kBNBasicTicker = @"ticker";
NSString *const kBNBasicDmError = @"dm_error";
NSString *const kBNBasicErrorMsg = @"error_msg";


@interface BNBasic ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation BNBasic

@synthesize ticker = _ticker;
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
    NSObject *receivedBNTicker = [dict objectForKey:kBNBasicTicker];
    NSMutableArray *parsedBNTicker = [NSMutableArray array];
    
    if ([receivedBNTicker isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedBNTicker) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedBNTicker addObject:[BNTicker modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedBNTicker isKindOfClass:[NSDictionary class]]) {
       [parsedBNTicker addObject:[BNTicker modelObjectWithDictionary:(NSDictionary *)receivedBNTicker]];
    }

    self.ticker = [NSArray arrayWithArray:parsedBNTicker];
            self.dmError = [[self objectOrNilForKey:kBNBasicDmError fromDictionary:dict] doubleValue];
            self.errorMsg = [self objectOrNilForKey:kBNBasicErrorMsg fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    NSMutableArray *tempArrayForTicker = [NSMutableArray array];
    
    for (NSObject *subArrayObject in self.ticker) {
        if ([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForTicker addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForTicker addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForTicker] forKey:kBNBasicTicker];
    [mutableDict setValue:[NSNumber numberWithDouble:self.dmError] forKey:kBNBasicDmError];
    [mutableDict setValue:self.errorMsg forKey:kBNBasicErrorMsg];

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

    self.ticker = [aDecoder decodeObjectForKey:kBNBasicTicker];
    self.dmError = [aDecoder decodeDoubleForKey:kBNBasicDmError];
    self.errorMsg = [aDecoder decodeObjectForKey:kBNBasicErrorMsg];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_ticker forKey:kBNBasicTicker];
    [aCoder encodeDouble:_dmError forKey:kBNBasicDmError];
    [aCoder encodeObject:_errorMsg forKey:kBNBasicErrorMsg];
}

- (id)copyWithZone:(NSZone *)zone {
    BNBasic *copy = [[BNBasic alloc] init];
    
    
    
    if (copy) {

        copy.ticker = [self.ticker copyWithZone:zone];
        copy.dmError = self.dmError;
        copy.errorMsg = [self.errorMsg copyWithZone:zone];
    }
    
    return copy;
}


@end
