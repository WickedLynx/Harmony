//
//  HMYFilesView.m
//  Harmony
//
//  Created by Harshad Dange on 07/12/2013.
//  Copyright (c) 2013 Laughing Buddha Software. All rights reserved.
//

#import "HMYFilesView.h"

@implementation HMYFilesView {
    __weak UITableView *_filesTableView;
    __weak UISearchBar *_searchBar;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        UITableView *aTableView = [[UITableView alloc] initWithFrame:self.bounds];
        [self addSubview:aTableView];
        _filesTableView = aTableView;
        
        [aTableView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
        
        UISearchBar *aSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 44.0f)];
        [aSearchBar setShowsCancelButton:YES];
        [aSearchBar setShowsSearchResultsButton:NO];
        [aSearchBar setShowsBookmarkButton:NO];
        [aSearchBar setShowsScopeBar:NO];
        [_filesTableView setTableHeaderView:aSearchBar];
        _searchBar = aSearchBar;
        
    }
    
    return self;
}


#pragma mark - Public methods

- (UITableView *)filesTableView {
    return _filesTableView;
}

- (UISearchBar *)searchBar {
    return _searchBar;
}

@end
