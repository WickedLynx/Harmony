//
//  HMYFavourite.m
//  Harmony
//
//  Created by Harshad Dange on 08/12/2013.
//  Copyright (c) 2013 Laughing Buddha Software. All rights reserved.
//

#import "HMYFavourite.h"

NSString *const HMYFavouriteNameKey = @"name";
NSString *const HMYFavouriteAbsolutePathKey = @"absolutePath";
NSString *const HMYFavouriteDateCreatedKey = @"dateCreated";

@implementation HMYFavourite

#pragma mark - Creation

- (instancetype)initWithName:(NSString *)name absolutePath:(NSString *)absolutePath dateCreated:(NSDate *)dateCreated {
    
    self = [super init];
    
    if (self != nil) {
        
        _name = [name copy];
        _absolutePath = [absolutePath copy];
        _dateCreated = [dateCreated copy];
    }
    
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    
    return [self initWithName:dictionary[HMYFavouriteNameKey] absolutePath:dictionary[HMYFavouriteAbsolutePathKey] dateCreated:dictionary[HMYFavouriteDateCreatedKey]];
}

#pragma mark - Public methods

- (NSDictionary *)dictionaryRepresentation {
    
    return @{HMYFavouriteNameKey : _name, HMYFavouriteAbsolutePathKey : _absolutePath, HMYFavouriteDateCreatedKey : _dateCreated};
}

@end
