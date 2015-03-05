//
//  SearchViewController.m
//  wormhole
//
//  Created by Daniel Barden on 02/03/15.
//  Copyright (c) 2015 azapp. All rights reserved.
//

// TODO: Rotation screws up with the searchViewController
// TODO: Is there a better way to provide the selected cell to CreateItinerary? I feel dirty
#import "SearchViewController.h"
#import "HereAPI.h"

static NSString *const SearchCellReuseIdentifier = @"SearchCellReuseIdentifier";

@interface SearchViewController () <UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate>

@property (nonatomic, strong) NSMutableArray *places;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSURLSessionDataTask *dataTask;

@property (nonatomic, strong, readwrite) Place *selectedPlace;

@property (nonatomic, weak) UISearchController *searchController;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.places = [NSMutableArray array];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager requestWhenInUseAuthorization];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.locationManager startUpdatingLocation];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.locationManager stopUpdatingLocation];

}
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.places.count ? self.places.count : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SearchCellReuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SearchCellReuseIdentifier];
    }

    if (self.places) {
        if (self.places.count >0 ){
            Place *place = (Place *)self.places[indexPath.row];

            NSAssert([place isKindOfClass:[Place class]], @"Value is not of type Place", NULL);

            cell.textLabel.text = place.title;
            cell.detailTextLabel.text = place.vicinity;
        } else {
            cell.textLabel.text = NSLocalizedString(@"no_search_results", nil);
            cell.detailTextLabel.text = nil;
            
        }
    } else {
        NSString *textString = self.dataTask ? NSLocalizedString(@"loading", nil) : NSLocalizedString(@"please_three_chars", nil);;

        cell.textLabel.text = textString;
        cell.detailTextLabel.text = nil;
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.places.count == 0) {
        return;
    }
    Place *place = self.places[indexPath.row];
    self.selectedPlace = place;
    [self.searchController setActive:NO];
}

#pragma mark - UISearchResultUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    if (!searchController.active) {
        return;
    }
    
    if (!self.searchController) {
        self.searchController = searchController;
    }
    

    // To minimize the number of requests, wait for 1 second without typing
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(downloadData) object:nil];

    NSString *query = self.searchController.searchBar.text;
    if (query.length < 3) {
        self.places = nil;
        self.selectedPlace = nil;
        [self.dataTask cancel];
        self.dataTask = nil;
        [self.tableView reloadData];
        return;
    }


    [self performSelector:@selector(downloadData) withObject:nil afterDelay:1];
}

#pragma mark - Convenience methods

- (void)downloadData
{
    NSString *query = self.searchController.searchBar.text;
    self.dataTask = [HereAPI requestSearchWithQuery:query location:self.locationManager.location success:^(NSArray *elements) {

        self.places = [NSMutableArray arrayWithArray:elements];
        NSLog(@"Results %@", self.places);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });

    } failure:^(NSError *error) {
        // TODO: Add proper error handling
        NSLog(@"Error: %@", error);
    }];

    [self.dataTask resume];
}

@end
