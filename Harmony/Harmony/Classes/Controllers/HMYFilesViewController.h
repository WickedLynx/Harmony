//
//  HMYFilesViewController.h
//  Harmony
//
//  Created by Harshad Dange on 07/12/2013.
//  Copyright (c) 2013 Laughing Buddha Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HMYFavouriteStore;

@interface HMYFilesViewController : UIViewController

- (instancetype)initWithPath:(NSString *)path;

@property (strong, nonatomic) HMYFavouriteStore *favouriteStore;

@end
