//
//  HMYFile.h
//  Harmony
//
//  Created by Harshad Dange on 07/12/2013.
//  Copyright (c) 2013 Laughing Buddha Software. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, HMYFileType) {
    
    HMYFileTypeDirectory,
    HMYFileTypeOther
};

@interface HMYFile : NSObject

+ (instancetype)fileWithPath:(NSString *)path attributes:(NSDictionary *)attributes;

- (NSString *)absolutePath;
- (NSString *)name;
- (NSDate *)dateCreated;
- (NSDate *)dateModified;
- (NSString *)extension;
- (HMYFileType)type;

@end
