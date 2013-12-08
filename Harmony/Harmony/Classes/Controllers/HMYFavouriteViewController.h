//
//  HMYFavouriteViewController.h
//  Harmony
//
//  Created by Harshad Dange on 08/12/2013.
//  Copyright (c) 2013 Laughing Buddha Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HMYFavouriteStore;

@interface HMYFavouriteViewController : UIViewController

- (instancetype)initWithFavouriteStore:(HMYFavouriteStore *)favouriteStore;

@property (strong, nonatomic) HMYFavouriteStore *favouriteStore;

@end
