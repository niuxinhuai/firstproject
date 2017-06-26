//
//  YKExtra.m
//
//  Created by   on 2017/5/24
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "YKExtra.h"
#import "YKLabel.h"


NSString *const kYKExtraCover = @"cover";
NSString *const kYKExtraLabel = @"label";


@interface YKExtra ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation YKExtra

@synthesize cover = _cover;
@synthesize label = _label;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.cover = [self objectOrNilForKey:kYKExtraCover fromDictionary:dict];
    NSObject *receivedYKLabel = [dict objectForKey:kYKExtraLabel];
    NSMutableArray *parsedYKLabel = [NSMutableArray array];
    
    if ([receivedYKLabel isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedYKLabel) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedYKLabel addObject:[YKLabel modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedYKLabel isKindOfClass:[NSDictionary class]]) {
       [parsedYKLabel addObject:[YKLabel modelObjectWithDictionary:(NSDictionary *)receivedYKLabel]];
    }

    self.label = [NSArray arrayWithArray:parsedYKLabel];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.cover forKey:kYKExtraCover];
    NSMutableArray *tempArrayForLabel = [NSMutableArray array];
    
    for (NSObject *subArrayObject in self.label) {
        if ([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForLabel addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForLabel addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForLabel] forKey:kYKExtraLabel];

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

    self.cover = [aDecoder decodeObjectForKey:kYKExtraCover];
    self.label = [aDecoder decodeObjectForKey:kYKExtraLabel];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_cover forKey:kYKExtraCover];
    [aCoder encodeObject:_label forKey:kYKExtraLabel];
}

- (id)copyWithZone:(NSZone *)zone {
    YKExtra *copy = [[YKExtra alloc] init];
    
    
    
    if (copy) {

        copy.cover = [self.cover copyWithZone:zone];
        copy.label = [self.label copyWithZone:zone];
    }
    
    return copy;
}


@end
