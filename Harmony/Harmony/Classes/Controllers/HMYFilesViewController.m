//
//  HMYFilesViewController.m
//  Harmony
//
//  Created by Harshad Dange on 07/12/2013.
//  Copyright (c) 2013 Laughing Buddha Software. All rights reserved.
//

#import "HMYFilesViewController.h"
#import "HMYFilesView.h"

#import "HMYFile.h"
#import "HMYTextEditorController.h"
#import "HMYFavourite.h"
#import "HMYFavouriteStore.h"

typedef NS_ENUM(NSUInteger, HMYFileAction) {
    HMYFileActionAddToFavourites = 0,
    HMYFileActionNewFile,
    HMYFileActionSortByName,
    HMYFileActionSortByLatest,
    HMYFileActionSortByType
};

@interface HMYFilesViewController () <NSFileManagerDelegate, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UIActionSheetDelegate, UIAlertViewDelegate> {
    
    NSFileManager *_fileManager;
    NSArray *_filesAtCurrentPath;
    
    NSMutableArray *_browsingHistory;
    __weak HMYFilesView *_filesView;
    
    NSMutableArray *_unfilteredFiles;
    
    NSSortDescriptor *_fileSortDescriptor;
    
}

- (void)refresh;
- (void)touchBack;
- (void)touchAdd;

@end

@implementation HMYFilesViewController

#pragma mark - Creation

- (instancetype)initWithPath:(NSString *)path {
    
    self = [super init];
    
    if (self != nil) {
        _browsingHistory = [NSMutableArray arrayWithObject:path];
        _fileSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"type" ascending:YES];

        [self setTabBarItem:[[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemSearch tag:0]];
    }
    
    return self;
}

#pragma mark - View lifecycle

- (void)loadView {
    HMYFilesView *filesView = [[HMYFilesView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [filesView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    
    [self setView:filesView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [[_filesView filesTableView] setDataSource:self];
    [[_filesView filesTableView] setDelegate:self];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(touchBack)];
    [self.navigationItem setLeftBarButtonItem:backButton];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(touchAdd)];
    [self.navigationItem setRightBarButtonItem:addButton];
    
    [[_filesView searchBar] setDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self refresh];
}

- (void)setView:(UIView *)view {
    
    if (![view isKindOfClass:[HMYFilesView class]]) {
        
        [NSException raise:NSInternalInconsistencyException format:@"%@ can only be associated with %@", NSStringFromClass([self class]), NSStringFromClass([HMYFilesView class])];
    }
    
    [super setView:view];
    
    _filesView = (HMYFilesView *)view;
}

#pragma mark - Actions

- (void)touchBack {
    
    [_browsingHistory removeObjectAtIndex:0];
    if ([_browsingHistory count] == 0) {
        
        if ([self.navigationController.viewControllers count] > 1) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [_browsingHistory addObject:@"/"];
        }

    }
    
    [self refresh];
}

- (void)touchAdd {
    
    UIActionSheet *addMenuSheet = [[UIActionSheet alloc] initWithTitle:@"Choose an action" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Add to Favourites", @"New Item", @"Sort by name", @"Sort by Latest", @"Sort by type", nil];
    [addMenuSheet showFromTabBar:self.tabBarController.tabBar];
}

#pragma mark - Private methods

- (void)refresh {
    
    if (_fileManager == nil) {
        
        _fileManager = [[NSFileManager alloc] init];
    }
    
    NSMutableArray *files = [NSMutableArray new];
    
    NSString *absolutePath = nil;
    
    for (NSString *fileName in [_fileManager contentsOfDirectoryAtPath:[_browsingHistory firstObject] error:nil]) {
        
        absolutePath = [[_browsingHistory firstObject] stringByAppendingPathComponent:fileName];
        
        HMYFile *aFile = [HMYFile fileWithPath:absolutePath attributes:[_fileManager attributesOfItemAtPath:absolutePath error:nil]];
        [files addObject:aFile];
        
    }
    
    _filesAtCurrentPath = [files sortedArrayUsingDescriptors:@[_fileSortDescriptor]];
    
    [[_filesView filesTableView] reloadData];
    
    if ([_browsingHistory count] == 0) {
        
        [self.navigationItem.leftBarButtonItem setEnabled:NO];
        
    } else {
        
        [self.navigationItem.leftBarButtonItem setEnabled:YES];
    }
    
    NSString *title = [[[_browsingHistory firstObject] componentsSeparatedByString:@"/"] lastObject];
    if (title.length == 0) {
        title = [_browsingHistory firstObject];
    }
    [self setTitle:title];
    
    [[_filesView filesTableView] setContentOffset:CGPointZero];
    
    _unfilteredFiles = nil;
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_filesAtCurrentPath count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *HMYFilesTableViewCellIdentifier = @"HMYFilesTableViewCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HMYFilesTableViewCellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:HMYFilesTableViewCellIdentifier];
    }
    
    HMYFile *theFile = [_filesAtCurrentPath objectAtIndex:[indexPath row]];
    
    [cell.textLabel setText:[theFile name]];
    
    switch ([theFile type]) {
            
        case HMYFileTypeDirectory:
            [cell.textLabel setTextColor:[UIColor blackColor]];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            
            break;
            
        case HMYFileTypeOther:
            [cell.textLabel setTextColor:[UIColor darkGrayColor]];
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            
            break;
            
        default:
            break;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [[_filesView searchBar] resignFirstResponder];
    [[_filesView searchBar] setText:nil];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    HMYFile *theFile = [_filesAtCurrentPath objectAtIndex:[indexPath row]];
    
    if ([theFile type] == HMYFileTypeDirectory) {
        
        [_browsingHistory insertObject:[theFile absolutePath] atIndex:0];
        
        [self refresh];
        
    } else {
        
        HMYTextEditorController *textEditor = [[HMYTextEditorController alloc] initWithFile:theFile];
        
        [self.navigationController pushViewController:textEditor animated:YES];
    }
    
    _unfilteredFiles = nil;
    
}


#pragma mark - UISearchBarDelegate methods

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if (_unfilteredFiles == nil) {
        _unfilteredFiles = [_filesAtCurrentPath mutableCopy];
    }
    
    _filesAtCurrentPath = [_unfilteredFiles filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name contains[cd] %@", searchText]];
    [[_filesView filesTableView] reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [[_filesView searchBar] resignFirstResponder];

    [self refresh];
}

#pragma mark - UIActionSheetDelegate methods

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    HMYFileAction action = buttonIndex - [actionSheet firstOtherButtonIndex];
    
    switch (action) {
            
        case HMYFileActionAddToFavourites: {
            
            HMYFavourite *aFavourite = [[HMYFavourite alloc] initWithName:self.title absolutePath:[_browsingHistory firstObject] dateCreated:[NSDate date]];
            [self.favouriteStore addFavourite:aFavourite];
            
            [self.favouriteStore savePersistently];
            
            break;
        }
            
        case HMYFileActionNewFile:
            break;
            
        case HMYFileActionSortByName: {
            
            NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
            _fileSortDescriptor = sortDescriptor;
            
            [self refresh];
            
            break;
        }
            
        case HMYFileActionSortByLatest: {
            
            NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"dateCreated" ascending:NO];
            _fileSortDescriptor = sortDescriptor;
            
            [self refresh];

            break;
        }
            
        case HMYFileActionSortByType: {
            
            NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"type" ascending:YES];
            _fileSortDescriptor = sortDescriptor;
            
            [self refresh];
            
            break;
        }
            
            
        default:
            break;
    }
    
}


@end
