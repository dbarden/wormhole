//
//  ViewController.m
//  wormhole
//
//  Created by Daniel Barden on 02/03/15.
//  Copyright (c) 2015 azapp. All rights reserved.
//

// TODO: Remove duplicated entries

#import "CreateItineraryViewController.h"
#import "CreateItineraryDataSource.h"
#import "SearchViewController.h"
#import "ViewItineraryViewController.h"
#import "HereAPI.h"

static NSString *const cellIdentifier = @"CellIdentifier";

@interface CreateItineraryViewController () <UITableViewDataSource, UITableViewDelegate, UISearchControllerDelegate, UISearchBarDelegate>

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

    // SearchViewController
    SearchViewController *searchViewController = [[SearchViewController alloc] init];
    self.searchViewController = searchViewController;
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:searchViewController];
    self.searchController.searchBar.placeholder = NSLocalizedString(@"search_locations", nil);
    self.searchController.searchResultsUpdater = searchViewController;
    
    [self.searchController.searchBar sizeToFit];
    self.searchController.delegate = self;
    self.tableView.tableHeaderView = self.searchController.searchBar;
}

- (IBAction)calculateRoute
{
    if (self.dataSource.places.count < 2){
        UIAlertController *alertController = [self createAlertController];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        [self performSegueWithIdentifier:@"ViewItinerary" sender:self];
    }
}

- (IBAction)editTableView:(id)sender
{
    self.tableView.editing = !self.tableView.editing;
}

#pragma mark - UISearchControllerDelegate

- (void)willDismissSearchController:(UISearchController *)searchController
{
    if (self.searchViewController.selectedPlace){
        [self.dataSource addPlace:self.searchViewController.selectedPlace];
        [self.tableView reloadData];
    }
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ViewItinerary"]) {
        ViewItineraryViewController *viewItineraryVC = segue.destinationViewController;
        viewItineraryVC.places = self.dataSource.places;
    }
}

#pragma mark - Helper Methods
- (UIAlertController *)createAlertController
{
    UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"dismiss", nil) style:UIAlertActionStyleDefault handler:nil];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"failure", nil)
                                                                             message:NSLocalizedString(@"two_points_warning", nil)
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:dismissAction];
    return alertController;
}

@end
