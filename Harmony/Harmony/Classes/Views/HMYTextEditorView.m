//
//  HMYTextEditorView.m
//  Harmony
//
//  Created by Harshad Dange on 07/12/2013.
//  Copyright (c) 2013 Laughing Buddha Software. All rights reserved.
//

#import "HMYTextEditorView.h"

@implementation HMYTextEditorView {
    __weak UITextView *_editorTextView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UITextView *aTextView = [[UITextView alloc] initWithFrame:self.bounds];
        [aTextView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
        [aTextView setFont:[UIFont fontWithName:@"Menlo-Regular" size:12.0f]];
        [aTextView setTextColor:[UIColor darkTextColor]];
        [self addSubview:aTextView];
        
        _editorTextView = aTextView;
    }
    
    return self;
}

#pragma mark - Private methods

- (UITextView *)editorTextView {
    return _editorTextView;
}


@end
