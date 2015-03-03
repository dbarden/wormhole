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
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:SearchCellReuseIdentifier];

    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.places.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SearchCellReuseIdentifier];
    if (self.places.count > 0) {
        cell.textLabel.text = [self.places[indexPath.row] valueForKey:@"title"];
    } else {
        cell.textLabel.text = @"Please type at least 3 characters";
    }

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Place *place = self.places[indexPath.row];
    self.selectedPlace = place;
    [self.searchController setActive:NO];
}

#pragma mark - UISearchResultUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSLog(@"%s %@", __PRETTY_FUNCTION__, searchController.searchBar.text);
    if (!self.searchController) {
        self.searchController = searchController;
    }

    NSString *query = searchController.searchBar.text;
    if (query.length < 3) {
        self.places = [NSMutableArray array];
        self.selectedPlace = nil;
        [self.tableView reloadData];
        return;
    }

    // To minimize the number of requests, wait for 1 second without typing
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(downloadData) object:nil];
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

    [self performSelector:@selector(downloadData) withObject:nil afterDelay:1];

}

- (void)downloadData
{
    NSLog(@"Starting the download");
    [self.dataTask resume];
}

@end
