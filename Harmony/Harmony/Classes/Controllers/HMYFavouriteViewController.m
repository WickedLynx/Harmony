//
//  HMYFavouriteViewController.m
//  Harmony
//
//  Created by Harshad Dange on 08/12/2013.
//  Copyright (c) 2013 Laughing Buddha Software. All rights reserved.
//

#import "HMYFavouriteViewController.h"
#import "HMYFilesView.h"

#import "HMYFavouriteStore.h"
#import "HMYFavourite.h"
#import "HMYFilesViewController.h"

@interface HMYFavouriteViewController () <UITableViewDataSource, UITableViewDelegate> {
    
    __weak HMYFilesView *_favouritesView;
    
}

- (void)refresh;

@end

@implementation HMYFavouriteViewController

#pragma mark - Construction

- (instancetype)initWithFavouriteStore:(HMYFavouriteStore *)favouriteStore {
    
    self = [super init];
    if (self != nil) {
        
        _favouriteStore = favouriteStore;
        
        [self setTitle:@"Favourites"];
    }
    
    return self;
}

#pragma mark - View lifecycle

- (void)loadView {
    
    UIView *view = [[HMYFilesView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [view setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    
    [self setView:view];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self setTitle:@"Favourites"];
    
    [[_favouritesView filesTableView] setTableHeaderView:nil];
    
    [[_favouritesView filesTableView] setDataSource:self];
    [[_favouritesView filesTableView] setDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self refresh];
}

- (void)setView:(UIView *)view {
    
    if (![view isKindOfClass:[HMYFilesView class]]) {
        
        [NSException raise:NSInternalInconsistencyException format:@"%@ should only be associated with %@", NSStringFromClass([self class]), NSStringFromClass([HMYFilesView class])];
    }
    
    [super setView:view];
    
    _favouritesView = (HMYFilesView *)view;
}

#pragma mark - Private methods

- (void)refresh {
    [_favouriteStore reloadFromPersistentStore];
    
    [[_favouritesView filesTableView] reloadData];
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[_favouriteStore favourites] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *FavouritesTableCellIdentifier = @"FavouritesTableCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FavouritesTableCellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:FavouritesTableCellIdentifier];
    }
    
    HMYFavourite *theFavourite = [[_favouriteStore favourites] objectAtIndex:[indexPath row]];
    
    [cell.textLabel setText:theFavourite.name];
    [cell.detailTextLabel setText:theFavourite.absolutePath];
    
    return cell;
}

#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HMYFavourite *theFavourite = [[_favouriteStore favourites] objectAtIndex:[indexPath row]];
    
    HMYFilesViewController *filesViewController = [[HMYFilesViewController alloc] initWithPath:theFavourite.absolutePath];
    [self.navigationController pushViewController:filesViewController animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)tableView:(UITableView*)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        HMYFavourite *theFavourite = [[_favouriteStore favourites] objectAtIndex:[indexPath row]];
        [_favouriteStore deleteFavourite:theFavourite];
        [_favouriteStore savePersistently];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}



@end
