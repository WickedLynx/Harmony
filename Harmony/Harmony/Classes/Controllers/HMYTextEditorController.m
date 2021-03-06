//
//  HMYTextEditorController.m
//  Harmony
//
//  Created by Harshad Dange on 07/12/2013.
//  Copyright (c) 2013 Laughing Buddha Software. All rights reserved.
//

#import "HMYTextEditorController.h"
#import "HMYTextEditorView.h"

#import "HMYFile.h"

#import "MMMarkdown.h"
#import "HMYHTMLViewController.h"

unsigned long long const HMYEditorMaxFileSize = 50000000; // 5 MB

typedef NS_ENUM(NSInteger, HMYTextEditorActionType) {
    HMYTextEditorActionTypeRenderHTML = 0,
    HMYTextEditorActionTypeSave,
    HMYTextEditorActionTypeRevertToSaved
};

@interface HMYTextEditorController () <UITextViewDelegate, UIAlertViewDelegate, UIActionSheetDelegate> {
    __weak HMYTextEditorView *_editorView;
    HMYFile *_file;
    NSString *_fileContent;
}

- (void)touchOptions;
- (void)keyboardWillShow:(NSNotification *)aNotification;
- (void)keyboardWillHide:(NSNotification *)aNotification;

@end

@implementation HMYTextEditorController

#pragma mark - Creation

- (instancetype)initWithFile:(HMYFile *)file {
    
    self = [super init];
    if (self != nil) {
        
        _file = file;
        
    }
    
    return self;
}

#pragma mark - Cleanup

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[_editorView editorTextView] setDelegate:nil];
}

#pragma mark - View lifecycle

- (void)loadView {
    HMYTextEditorView *view = [[HMYTextEditorView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [view setAutoresizingMask:(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth)];
    
    [self setView:view];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self setTitle:[_file name]];
    
    [[_editorView editorTextView] setDelegate:self];
    
    NSData *fileData = [NSData dataWithContentsOfFile:[_file absolutePath]];
    
    if ([fileData length] > HMYEditorMaxFileSize) {
        
        UIAlertView *fileTooLargeAlert = [[UIAlertView alloc] initWithTitle:@"File too large" message:@"This file cannot be opened" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
        [fileTooLargeAlert show];
        
        __weak HMYTextEditorController *wSelf = self;
        
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [wSelf.navigationController popViewControllerAnimated:YES];
        });
        
    } else {
        
        NSString *fileText = [[NSString alloc] initWithData:fileData encoding:NSUTF8StringEncoding];
        _fileContent = [fileText copy];
        [[_editorView editorTextView] setText:fileText];
        
        UIBarButtonItem *optionsButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(touchOptions)];
        [self.navigationItem setRightBarButtonItem:optionsButton];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

}

- (void)setView:(UIView *)view {
    
    if (![view isKindOfClass:[HMYTextEditorView class]]) {
        
        [NSException raise:NSInternalInconsistencyException format:@"%@ should only be associated with %@", NSStringFromClass([self class]), NSStringFromClass([HMYTextEditorView class])];
    }
    
    [super setView:view];
    
    _editorView = (HMYTextEditorView *)view;
}

#pragma mark - Actions

- (void)touchOptions {

    UIActionSheet *optionsSheet = [[UIActionSheet alloc] initWithTitle:@"Choose an action" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Render HTML", @"Save", @"Revert to Saved", nil];
//    [optionsSheet showInView:self.view];
    [optionsSheet showFromTabBar:self.tabBarController.tabBar];
}

#pragma mark - UIAlertViewDelegate methods

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex != [alertView cancelButtonIndex]) {
        
        NSData *fileData = [[[_editorView editorTextView] text] dataUsingEncoding:NSUTF8StringEncoding];
        
        NSError *writeError = nil;
        
        if (![fileData writeToFile:[_file absolutePath] options:NSDataWritingAtomic error:&writeError]) {
            
            UIAlertView *writeFailAlert = [[UIAlertView alloc] initWithTitle:@"Failed to write" message:[writeError localizedDescription] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
            
            [writeFailAlert show];
        }
    }
}

#pragma mark - UIActionSheetDelegate methods

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {

    HMYTextEditorActionType action = buttonIndex - [actionSheet firstOtherButtonIndex];

    switch (action) {
        case HMYTextEditorActionTypeRenderHTML: {

            NSString *HTMLString = [MMMarkdown HTMLStringWithMarkdown:[[_editorView editorTextView] text] error:nil];

            HMYHTMLViewController *HTMLViewController = [[HMYHTMLViewController alloc] initWithHTMLString:HTMLString];

            [self.navigationController pushViewController:HTMLViewController animated:YES];

            break;
        }

        case HMYTextEditorActionTypeSave: {
            if (![[[_editorView editorTextView] text] isEqualToString:_fileContent]) {

                UIAlertView *saveAlert = [[UIAlertView alloc] initWithTitle:@"Save File?" message:@"This acton cannot be reverted" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];

                [saveAlert show];
            }
            break;
        }

        case HMYTextEditorActionTypeRevertToSaved: {
            if (![[[_editorView editorTextView] text] isEqualToString:_fileContent]) {
                [[_editorView editorTextView] setText:_fileContent];
            }

            break;
        }

        default:
            break;
    }
}

#pragma mark - Notification handlers

- (void)keyboardWillShow:(NSNotification *)aNotification {
    __weak HMYTextEditorController *wSelf = self;
    NSValue *endFrameValue = aNotification.userInfo[UIKeyboardFrameEndUserInfoKey];
    CGRect endFrame = [endFrameValue CGRectValue];
    
    CGRect editorFrame = [[_editorView editorTextView] frame];
    editorFrame.size.height = editorFrame.size.height - endFrame.size.height + 48.0f;
    
    [UIView animateWithDuration:0.25f delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
        __strong HMYTextEditorController *sSelf = wSelf;
        [[sSelf->_editorView editorTextView] setFrame:editorFrame];
    } completion:^(BOOL finished) {
        
    }];
    

}

- (void)keyboardWillHide:(NSNotification *)aNotification {
    __weak HMYTextEditorController *wSelf = self;
    [UIView animateWithDuration:0.25f delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
        __strong HMYTextEditorController *sSelf = wSelf;
        [[sSelf->_editorView editorTextView] setFrame:_editorView.frame];
    } completion:^(BOOL finished) {
        
    }];

}





@end
