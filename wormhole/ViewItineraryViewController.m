//
//  ViewItineraryViewController.m
//  wormhole
//
//  Created by Daniel Barden on 03/03/15.
//  Copyright (c) 2015 azapp. All rights reserved.
//

@import MapKit;
#import "MKPolyline+Wormhole.h"

#import "ViewItineraryViewController.h"
#import "HereAPI.h"
#import "Route.h"
#import "Route+Formatting.h"
#import "Maneuver.h"
#import "Leg.h"
#import "Waypoint.h"

static NSString *generalSection[2] = {@"Time", @"Distance"};

@interface ViewItineraryViewController ()<MKMapViewDelegate>

@property (nonatomic, strong) Route *pedestrianRoute;

@property (nonatomic, weak) IBOutlet MKMapView *mapView;
@property (nonatomic, weak) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, strong) Route *route;

@property (nonatomic, strong) NSMutableDictionary *routeConfigurations;

@end

@implementation ViewItineraryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mapView.delegate = self;
    self.tableView.allowsSelection = NO;
    self.routeConfigurations = [NSMutableDictionary dictionary];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSURLSessionDataTask *pedestrianRouteDataTask = [HereAPI requestRouteWithPlaces:self.places mode:HereTransportModePedestrian success:^(Route *route) {
        [self updateWithRoute:route];
    } failure:^(NSError *error) {
        // TODO: Handle error
    }];
    [pedestrianRouteDataTask resume];

    NSURLSessionDataTask *carRouteDataTask = [HereAPI requestRouteWithPlaces:self.places mode:HereTransportModeCar success:^(Route *route) {
        [self updateWithRoute:route];
    } failure:^(NSError *error) {
        // TODO: Handle error
    }];
    [carRouteDataTask resume];

    NSURLSessionDataTask *publicTransportDataTask = [HereAPI requestRouteWithPlaces:self.places mode:HereTransportModePublicTransport success:^(Route *route) {
        [self updateWithRoute:route];
    } failure:^(NSError *error) {
        // TODO: Handle error
    }];
    [publicTransportDataTask resume];

}

- (void)updateWithRoute:(Route *)route
{
    self.routeConfigurations[@(route.transportMode)] = route;

    // It's horrible, I know
    if (self.segmentedControl.selectedSegmentIndex == 0 && !(route.transportMode == HereTransportModePedestrian) ) {
        return;
    }

    if (self.segmentedControl.selectedSegmentIndex == 1 && !(route.transportMode == HereTransportModePublicTransport)) {
        return;
    }

    if (self.segmentedControl.selectedSegmentIndex == 2 && !(route.transportMode == HereTransportModeCar)) {
        return;
    }

    [self.mapView removeOverlays:self.mapView.overlays];
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView setRegion:[route routeRegion] animated:YES];
    [self.mapView addAnnotations:route.waypoints];
    self.route = route;

    for (Leg *leg in route.legs) {
        MKPolyline *line = [[MKPolyline alloc] initWithLeg:leg];

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.mapView addOverlay:line];
            [self.tableView reloadData];
        });
    }
}

- (IBAction)segmentValueChanged:(UISegmentedControl *)sender
{
    if (sender.selectedSegmentIndex == 0) {
        Route *route = self.routeConfigurations[@(HereTransportModePedestrian)];
        if (route) {
            [self updateWithRoute:route];
        }
    } else if (sender.selectedSegmentIndex == 1) {
        Route *route = self.routeConfigurations[@(HereTransportModePublicTransport)];
        if (route) {
            [self updateWithRoute:route];
        }

    } else if (sender.selectedSegmentIndex == 2) {
        Route *route = self.routeConfigurations[@(HereTransportModeCar)];
        if (route) {
            [self updateWithRoute:route];
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.route.legs.count + 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    } else if (section == 1) {
        return self.route.waypoints.count;
    } else {
        Leg *leg = self.route.legs[section - 2];
        return leg.maneuvers.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /**** Section General Information ****/
    if (indexPath.section == 0) {

        UITableViewCell *cell = [self cellForGeneralInformationAtRow:indexPath.row tableView:tableView];
        return cell;
    /**** Section Waypoints ****/
    } else if (indexPath.section == 1) {

        UITableViewCell *cell = [self cellWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Default" tableView:tableView];
        Waypoint *waypoint = self.route.waypoints[indexPath.row];
        cell.textLabel.text = waypoint.title;
        cell.textLabel.numberOfLines = 0;
        return cell;
    /**** Section Maneuvers ****/
    } else {
        UITableViewCell *cell = [self cellWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Default" tableView:tableView];
        Leg *leg = self.route.legs[indexPath.section -2];
        Maneuver *maneuver = leg.maneuvers[indexPath.row];
        cell.textLabel.text = maneuver.instructions;
        cell.textLabel.numberOfLines = 0;
        return cell;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return NSLocalizedString(@"general_information", nil);
    } else if (section == 1) {
        return  NSLocalizedString(@"waypoints", nil);
    } else {
        Leg *leg = self.route.legs[section -2];
        return [NSString stringWithFormat:@"%@ -> %@", leg.startWaypoint.title, leg.endWaypoint.title];
    }
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKPinAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pin"];
    if ([annotation isEqual:[self.route.waypoints firstObject]]) {
        annotationView.pinColor = MKPinAnnotationColorRed;
    } else if ([annotation isEqual:[self.route.waypoints lastObject]]) {
        annotationView.pinColor = MKPinAnnotationColorGreen;
    } else {
        annotationView.pinColor = MKPinAnnotationColorPurple;
    }

    return annotationView;
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay {
    MKPolylineView *polylineView = [[MKPolylineView alloc] initWithPolyline:overlay];
    polylineView.strokeColor = [UIColor colorWithRed:204/255. green:45/255. blue:70/255. alpha:1.0];
    polylineView.lineWidth = 10.0;

    return polylineView;
}


// It probably should go in a category somewhere else :)
- (UITableViewCell *)cellWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier tableView:(UITableView *)tableView
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:style reuseIdentifier:reuseIdentifier];
    }
    return cell;
}

- (UITableViewCell *)cellForGeneralInformationAtRow:(NSUInteger)row tableView:(UITableView *)tableView
{
    UITableViewCell *cell = [self cellWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"General" tableView:tableView];
    if (row == 0){
        cell.textLabel.text = NSLocalizedString(@"total_time", nil);
        NSString *formattedString = [self.route formattedTravelTime];
        cell.detailTextLabel.text = formattedString ? formattedString : NSLocalizedString(@"loading", nil);
    } else if (row == 1) {
        cell.textLabel.text = NSLocalizedString(@"total_distance", nil);
        NSString *formattedString = [self.route formattedDistance];
        cell.detailTextLabel.text = formattedString ? formattedString : NSLocalizedString(@"loading", nil);
    } else if (row == 2) {
        cell.textLabel.text = NSLocalizedString(@"transport_mode", nil);
        NSString *formattedString = [self.route localizedTransportName];
        cell.detailTextLabel.text = formattedString ? formattedString : NSLocalizedString(@"loading", nil);
    }

    return cell;
}
@end
