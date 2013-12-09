//
//  HMYHTMLView.m
//  Harmony
//
//  Created by Harshad on 09/12/13.
//  Copyright (c) 2013 Laughing Buddha Software. All rights reserved.
//

#import "HMYHTMLView.h"

@implementation HMYHTMLView {

    __weak UIWebView *_webView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

        UIWebView *aWebView = [[UIWebView alloc] initWithFrame:self.bounds];
        [aWebView setAutoresizingMask:(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth)];
        [aWebView setScalesPageToFit:YES];

        [self addSubview:aWebView];
        _webView = aWebView;
    }
    return self;
}

- (UIWebView *)webView {
    return _webView;
}

@end
