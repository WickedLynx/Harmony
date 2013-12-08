//
//  HMYFavourite.h
//  Harmony
//
//  Created by Harshad Dange on 08/12/2013.
//  Copyright (c) 2013 Laughing Buddha Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMYFavourite : NSObject

- (instancetype)initWithName:(NSString *)name absolutePath:(NSString *)absolutePath dateCreated:(NSDate *)dateCreated;
- (NSDictionary *)dictionaryRepresentation;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *absolutePath;
@property (strong, nonatomic) NSDate *dateCreated;

@end
