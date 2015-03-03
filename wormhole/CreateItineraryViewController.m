//
//  ViewController.m
//  wormhole
//
//  Created by Daniel Barden on 02/03/15.
//  Copyright (c) 2015 azapp. All rights reserved.
//

#import "CreateItineraryViewController.h"
#import "SearchViewController.h"
#import "CreateItineraryDataSource.h"
// TODO: Prefix the classes

static NSString *const cellIdentifier = @"CellIdentifier";

@interface CreateItineraryViewController () <UITableViewDataSource, UITableViewDelegate, UISearchControllerDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *editTableView;

@property (nonatomic, strong) SearchViewController *searchViewController;
@property (nonatomic, strong) UISearchController *searchController;

@property (nonatomic, strong) CreateItineraryDataSource *dataSource;
@end

@implementation CreateItineraryViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    CreateItineraryDataSource *dataSource = [[CreateItineraryDataSource alloc] init];
    self.dataSource = dataSource;
    self.tableView.dataSource = self.dataSource;
    self.tableView.delegate = self;
    self.tableView.allowsSelection = NO;

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CreateItineraryCellIdentifier];


    // SearchViewController
    SearchViewController *searchViewController = [[SearchViewController alloc] init];
    self.searchViewController = searchViewController;
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:searchViewController];
    self.searchController.searchBar.placeholder = NSLocalizedString(@"search_locations", nil);
    self.searchController.searchResultsUpdater = searchViewController;
    
    [self.searchController.searchBar sizeToFit];
    self.searchController.delegate = self;
    self.tableView.tableHeaderView = self.searchController.searchBar;

    //Footer
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:NSLocalizedString(@"calculate_route", nil) forState:UIControlStateNormal];
    [button setTitle:NSLocalizedString(@"calculate_route", nil) forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(calculateRoute) forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    self.tableView.tableFooterView = button;
}

- (void)calculateRoute
{
    NSLog(@"***");
}

- (IBAction)editTableView:(id)sender
{
    if (self.tableView.editing) {
        self.editTableView.title = NSLocalizedString(@"Done", nil);
        self.tableView.editing = NO;
    } else {
        self.editTableView.title = NSLocalizedString(@"Edit", nil);
        self.tableView.editing = YES;
    }
}

#pragma mark - UISearchControllerDelegate

- (void)willDismissSearchController:(UISearchController *)searchController
{
    if (self.searchViewController.selectedPlace){
        [self.dataSource addPlace:self.searchViewController.selectedPlace];
        [self.tableView reloadData];
    }
}
@end
