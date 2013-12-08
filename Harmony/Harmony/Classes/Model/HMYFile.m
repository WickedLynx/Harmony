//
//  HMYFile.m
//  Harmony
//
//  Created by Harshad Dange on 07/12/2013.
//  Copyright (c) 2013 Laughing Buddha Software. All rights reserved.
//

#import "HMYFile.h"

NSInteger const HMYFileTypeNotDetermined = -322;

@implementation HMYFile {
    
    NSDictionary *_attributes;
    
    NSString *_name;
    NSString *_absolutePath;
    NSDate *_dateCreated;
    NSDate *_dateModified;
    NSString *_extension;
    HMYFileType _type;
}

#pragma mark - Creation

+ (instancetype)fileWithPath:(NSString *)path attributes:(NSDictionary *)attributes {
    
    HMYFile *file = [[[self class] alloc] init];
    
    file->_attributes = [attributes copy];
    file->_absolutePath = [path copy];
    file->_type = HMYFileTypeNotDetermined;
    
    return file;
}

#pragma mark - Public methods

- (NSString *)absolutePath {
    
    return _absolutePath;
}

- (void)parseNameAndExtension {
    
    NSString *fullName = [[_absolutePath componentsSeparatedByString:@"/"] lastObject];
    NSMutableArray *nameComponents = [[fullName componentsSeparatedByString:@"."] mutableCopy];
    
    _name = fullName;
        
    _extension = [nameComponents lastObject];
    
    [nameComponents removeObject:[nameComponents lastObject]];
    
    if ([[_name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
        
        _name = [_absolutePath copy];
    }
    
    NSString *fileType = _attributes[NSFileType];
    
    if (   [fileType isEqualToString:NSFileTypeDirectory]
        || [_extension caseInsensitiveCompare:@"app"] == NSOrderedSame
        || [fileType isEqualToString:NSFileTypeSymbolicLink]) {
        
        _type = HMYFileTypeDirectory;
        
    } else {
        
        _type = HMYFileTypeOther;
    }
    
}

- (NSString *)name {
    
    if (_name == nil) {
        
        [self parseNameAndExtension];
        
    }
    
    return _name;

}

- (NSDate *)dateCreated {

    return _attributes[NSFileCreationDate];
}

- (NSDate *)dateModified {
    
    return _attributes[NSFileModificationDate];
}

- (NSString *)extension {
    
    if (_extension == nil) {
        
        [self parseNameAndExtension];
        
    }
    
    return _extension;
}


- (HMYFileType)type {
    
    if (_type == HMYFileTypeNotDetermined) {
        
        [self parseNameAndExtension];
        
    }
    
    return _type;
}




@end
