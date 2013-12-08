//
//  main.m
//  Harmony
//
//  Created by Harshad Dange on 07/12/2013.
//  Copyright (c) 2013 Laughing Buddha Software. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HMYAppDelegate.h"

int main(int argc, char * argv[])
{
    setuid(0);
    setgid(0);
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([HMYAppDelegate class]));
    }
}
