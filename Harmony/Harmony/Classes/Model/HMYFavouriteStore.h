//
//  HMYFavouriteStore.h
//  Harmony
//
//  Created by Harshad Dange on 08/12/2013.
//  Copyright (c) 2013 Laughing Buddha Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HMYFavourite;

@interface HMYFavouriteStore : NSObject


- (NSArray *)favourites;
- (void)addFavourite:(HMYFavourite *)aFavourite;
- (void)deleteFavourite:(HMYFavourite *)aFavourite;

- (void)savePersistently;
- (void)reloadFromPersistentStore;


@end
