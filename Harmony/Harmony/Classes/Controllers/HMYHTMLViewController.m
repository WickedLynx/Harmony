//
//  HMYHTMLViewController.m
//  Harmony
//
//  Created by Harshad on 09/12/13.
//  Copyright (c) 2013 Laughing Buddha Software. All rights reserved.
//

#import "HMYHTMLViewController.h"
#import "HMYHTMLView.h"

@interface HMYHTMLViewController () {
    __weak HMYHTMLView *_HTMLView;
}

@end

@implementation HMYHTMLViewController

#pragma mark - Creation

- (instancetype)initWithHTMLString:(NSString *)HTMLString {

    self = [super init];

    if (self != nil) {

        _HTMLString = [HTMLString copy];
    }

    return self;
}

#pragma mark - View lifecycle

- (void)loadView {

    HMYHTMLView *HTMLView = [[HMYHTMLView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [HTMLView setAutoresizingMask:(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth)];

    [self setView:HTMLView];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    [self setTitle:@"Preview"];

    [[_HTMLView webView] loadHTMLString:_HTMLString baseURL:nil];
}

- (void)setView:(UIView *)view {

    if (![view isKindOfClass:[HMYHTMLView class]]) {

        [NSException raise:NSInternalInconsistencyException format:@"%@ should only be associated with %@", NSStringFromClass([self class]), NSStringFromClass([HMYHTMLView class])];
    }

    [super setView:view];

    _HTMLView = (HMYHTMLView *)view;
}

#pragma mark - Public methods

- (void)setHTMLString:(NSString *)HTMLString {

    _HTMLString = nil;
    _HTMLString = [HTMLString copy];

    [[_HTMLView webView] loadHTMLString:_HTMLString baseURL:nil];
}

@end
