//
//  HMYFavouriteStore.m
//  Harmony
//
//  Created by Harshad Dange on 08/12/2013.
//  Copyright (c) 2013 Laughing Buddha Software. All rights reserved.
//

#import "HMYFavouriteStore.h"

#import "HMYFavourite.h"

NSString *const HMYFavouritesFileName = @"Favourites.plist";

@interface HMYFavouriteStore ()

+ (NSString *)favouritesFilePath;

@end

@implementation HMYFavouriteStore {
    NSMutableArray *_favourites;
}

#pragma mark - Creation

- (id)init {
    
    self = [super init];
    
    if (self != nil) {
        
        [self reloadFromPersistentStore];
    }
    
    return self;
}

#pragma mark - Public methods

- (void)reloadFromPersistentStore {
    NSArray *serialisedFavourites = [NSArray arrayWithContentsOfFile:[HMYFavouriteStore favouritesFilePath]];
    _favourites = [NSMutableArray arrayWithCapacity:[serialisedFavourites count]];
    
    for (NSDictionary *aSerialisedFavourite in serialisedFavourites) {
        
        HMYFavourite *aFavourite = [[HMYFavourite alloc] initWithDictionary:aSerialisedFavourite];
        [_favourites addObject:aFavourite];
    }
    
    NSSortDescriptor *dateCreatedDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"dateCreated" ascending:YES];
    
    [_favourites sortUsingDescriptors:@[dateCreatedDescriptor]];
}

- (NSArray *)favourites {
    return _favourites;
}

- (void)addFavourite:(HMYFavourite *)aFavourite {
    
    if (![_favourites containsObject:aFavourite]) {
        [_favourites addObject:aFavourite];
    }
}

- (void)deleteFavourite:(HMYFavourite *)aFavourite {
    
    [_favourites removeObject:aFavourite];
}

- (void)savePersistently {
    
    NSMutableArray *serialisedFavourites = [NSMutableArray arrayWithCapacity:[_favourites count]];
    
    for (HMYFavourite *aFavourite in _favourites) {
        
        [serialisedFavourites addObject:[aFavourite dictionaryRepresentation]];
    }
    
    [serialisedFavourites writeToFile:[HMYFavouriteStore favouritesFilePath] atomically:YES];
}

#pragma mark - Private methods

+ (NSString *)favouritesFilePath {
    
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    return [documentsDirectory stringByAppendingPathComponent:HMYFavouritesFileName];
    
}

@end
