//
//  YKLabel.m
//
//  Created by   on 2017/5/24
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "YKLabel.h"


NSString *const kYKLabelTabKey = @"tab_key";
NSString *const kYKLabelTabName = @"tab_name";
NSString *const kYKLabelCl = @"cl";


@interface YKLabel ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation YKLabel

@synthesize tabKey = _tabKey;
@synthesize tabName = _tabName;
@synthesize cl = _cl;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.tabKey = [self objectOrNilForKey:kYKLabelTabKey fromDictionary:dict];
            self.tabName = [self objectOrNilForKey:kYKLabelTabName fromDictionary:dict];
            self.cl = [self objectOrNilForKey:kYKLabelCl fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.tabKey forKey:kYKLabelTabKey];
    [mutableDict setValue:self.tabName forKey:kYKLabelTabName];
    NSMutableArray *tempArrayForCl = [NSMutableArray array];
    
    for (NSObject *subArrayObject in self.cl) {
        if ([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForCl addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForCl addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForCl] forKey:kYKLabelCl];

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

    self.tabKey = [aDecoder decodeObjectForKey:kYKLabelTabKey];
    self.tabName = [aDecoder decodeObjectForKey:kYKLabelTabName];
    self.cl = [aDecoder decodeObjectForKey:kYKLabelCl];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_tabKey forKey:kYKLabelTabKey];
    [aCoder encodeObject:_tabName forKey:kYKLabelTabName];
    [aCoder encodeObject:_cl forKey:kYKLabelCl];
}

- (id)copyWithZone:(NSZone *)zone {
    YKLabel *copy = [[YKLabel alloc] init];
    
    
    
    if (copy) {

        copy.tabKey = [self.tabKey copyWithZone:zone];
        copy.tabName = [self.tabName copyWithZone:zone];
        copy.cl = [self.cl copyWithZone:zone];
    }
    
    return copy;
}


@end
