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

unsigned long long const HMYEditorMaxFileSize = 50000000; // 5 MB

@interface HMYTextEditorController () <UITextViewDelegate, UIAlertViewDelegate> {
    __weak HMYTextEditorView *_editorView;
    HMYFile *_file;
    NSString *_fileContent;
}

- (void)touchSave;

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
        
        UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(touchSave)];
        [self.navigationItem setRightBarButtonItem:saveButton];
    }


}

- (void)setView:(UIView *)view {
    
    if (![view isKindOfClass:[HMYTextEditorView class]]) {
        
        [NSException raise:NSInternalInconsistencyException format:@"%@ should only be associated with %@", NSStringFromClass([self class]), NSStringFromClass([HMYTextEditorView class])];
    }
    
    [super setView:view];
    
    _editorView = (HMYTextEditorView *)view;
}

#pragma mark - Actions

- (void)touchSave {
    
    if (![[[_editorView editorTextView] text] isEqualToString:_fileContent]) {
        
        UIAlertView *saveAlert = [[UIAlertView alloc] initWithTitle:@"Save File?" message:@"This acton cannot be reverted" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        
        [saveAlert show];
    }
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





@end
