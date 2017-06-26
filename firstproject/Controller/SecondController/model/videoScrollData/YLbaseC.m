//
//  YLbaseC.m
//
//  Created by   on 2017/5/26
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "YLbaseC.h"
#import "YLUsers.h"


NSString *const kYLbaseCUsers = @"users";
NSString *const kYLbaseCDmError = @"dm_error";
NSString *const kYLbaseCTotal = @"total";
NSString *const kYLbaseCErrorMsg = @"error_msg";


@interface YLbaseC ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation YLbaseC

@synthesize users = _users;
@synthesize dmError = _dmError;
@synthesize total = _total;
@synthesize errorMsg = _errorMsg;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
    NSObject *receivedYLUsers = [dict objectForKey:kYLbaseCUsers];
    NSMutableArray *parsedYLUsers = [NSMutableArray array];
    
    if ([receivedYLUsers isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedYLUsers) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedYLUsers addObject:[YLUsers modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedYLUsers isKindOfClass:[NSDictionary class]]) {
       [parsedYLUsers addObject:[YLUsers modelObjectWithDictionary:(NSDictionary *)receivedYLUsers]];
    }

    self.users = [NSArray arrayWithArray:parsedYLUsers];
            self.dmError = [[self objectOrNilForKey:kYLbaseCDmError fromDictionary:dict] doubleValue];
            self.total = [[self objectOrNilForKey:kYLbaseCTotal fromDictionary:dict] doubleValue];
            self.errorMsg = [self objectOrNilForKey:kYLbaseCErrorMsg fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    NSMutableArray *tempArrayForUsers = [NSMutableArray array];
    
    for (NSObject *subArrayObject in self.users) {
        if ([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForUsers addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForUsers addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForUsers] forKey:kYLbaseCUsers];
    [mutableDict setValue:[NSNumber numberWithDouble:self.dmError] forKey:kYLbaseCDmError];
    [mutableDict setValue:[NSNumber numberWithDouble:self.total] forKey:kYLbaseCTotal];
    [mutableDict setValue:self.errorMsg forKey:kYLbaseCErrorMsg];

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

    self.users = [aDecoder decodeObjectForKey:kYLbaseCUsers];
    self.dmError = [aDecoder decodeDoubleForKey:kYLbaseCDmError];
    self.total = [aDecoder decodeDoubleForKey:kYLbaseCTotal];
    self.errorMsg = [aDecoder decodeObjectForKey:kYLbaseCErrorMsg];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_users forKey:kYLbaseCUsers];
    [aCoder encodeDouble:_dmError forKey:kYLbaseCDmError];
    [aCoder encodeDouble:_total forKey:kYLbaseCTotal];
    [aCoder encodeObject:_errorMsg forKey:kYLbaseCErrorMsg];
}

- (id)copyWithZone:(NSZone *)zone {
    YLbaseC *copy = [[YLbaseC alloc] init];
    
    
    
    if (copy) {

        copy.users = [self.users copyWithZone:zone];
        copy.dmError = self.dmError;
        copy.total = self.total;
        copy.errorMsg = [self.errorMsg copyWithZone:zone];
    }
    
    return copy;
}


@end
