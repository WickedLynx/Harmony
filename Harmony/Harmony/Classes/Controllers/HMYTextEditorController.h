//
//  HMYTextEditorController.h
//  Harmony
//
//  Created by Harshad Dange on 07/12/2013.
//  Copyright (c) 2013 Laughing Buddha Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HMYFile;

@interface HMYTextEditorController : UIViewController

- (instancetype)initWithFile:(HMYFile *)file;

@end
