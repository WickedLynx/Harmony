//
//  HMYHTMLViewController.h
//  Harmony
//
//  Created by Harshad on 09/12/13.
//  Copyright (c) 2013 Laughing Buddha Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMYHTMLViewController : UIViewController

- (instancetype)initWithHTMLString:(NSString *)HTMLString;

@property (copy, nonatomic) NSString *HTMLString;

@end
