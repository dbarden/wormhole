//
//  ViewItineraryViewController.m
//  wormhole
//
//  Created by Daniel Barden on 03/03/15.
//  Copyright (c) 2015 azapp. All rights reserved.
//

@import MapKit;

#import "ViewItineraryViewController.h"
#import "HereAPI.h"
#import "Route.h"
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
    self.mapView.delegate = self;
    self.routeConfigurations = [NSMutableDictionary dictionary];

}

- (void)viewWillAppear:(BOOL)animated
{
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
    self.routeConfigurations[route.transportMode] = route;

    // It's horrible, I know
    if (self.segmentedControl.selectedSegmentIndex == 0 && ![route.transportMode isEqualToString:@"pedestrian"] ) {
        return;
    }

    if (self.segmentedControl.selectedSegmentIndex == 1 && ![route.transportMode isEqualToString:@"publicTransport"]) {
        return;
    }

    if (self.segmentedControl.selectedSegmentIndex == 2 && ![route.transportMode isEqualToString:@"car"]) {
        return;
    }

    [self.mapView removeOverlays:self.mapView.overlays];
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView setRegion:[route routeRegion] animated:YES];
    [self.mapView addAnnotations:route.waypoints];
    self.route = route;

    for (Leg *leg in route.legs) {
        NSArray *maneuvers = leg.maneuvers;

        CLLocationCoordinate2D *coordinateArray = malloc(sizeof(CLLocationCoordinate2D) * maneuvers.count);

        int caIndex = 0;
        for (Maneuver *maneuver in maneuvers) {
            coordinateArray[caIndex] = maneuver.coordinate;
            caIndex++;
        }

        MKPolyline *lines = [MKPolyline polylineWithCoordinates:coordinateArray
                                                          count:maneuvers.count];

        free(coordinateArray);

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.mapView addOverlay:lines];
            [self.tableView reloadData];
        });
    }

}

- (IBAction)segmentValueChanged:(UISegmentedControl *)sender
{
    if (sender.selectedSegmentIndex == 0) {
        Route *route = self.routeConfigurations[@"pedestrian"];
        if (route) {
            [self updateWithRoute:route];
        }
    } else if (sender.selectedSegmentIndex == 1) {
        Route *route = self.routeConfigurations[@"publicTransport"];
        if (route) {
            [self updateWithRoute:route];
        }

    } else if (sender.selectedSegmentIndex == 2) {
        Route *route = self.routeConfigurations[@"car"];
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
    /***** Section 0 ****/
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"General"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"General"];
        }
        // Ok, it's already 23:00. Maybe I should call it a day
        if(indexPath.row == 0){
            cell.textLabel.text = NSLocalizedString(@"Total Time", 0);
            NSDateComponentsFormatter *componentFormatter = [[NSDateComponentsFormatter alloc] init];

            componentFormatter.unitsStyle = NSDateComponentsFormatterUnitsStylePositional;
            componentFormatter.zeroFormattingBehavior = NSDateComponentsFormatterZeroFormattingBehaviorDropAll;

            NSString *formattedString = [componentFormatter stringFromTimeInterval:self.route.travelTime];

            cell.detailTextLabel.text = formattedString;
        } else if (indexPath.row == 1) {

            cell.textLabel.text = NSLocalizedString(@"Total Distance", nil);
            NSLengthFormatter *lengthFormatter = [[NSLengthFormatter alloc] init];

            cell.detailTextLabel.text = [lengthFormatter stringFromValue:self.route.distance unit:NSLengthFormatterUnitMeter];
        } else if (indexPath.row == 2) {
            cell.textLabel.text = NSLocalizedString(@"Transport mode", nil);
            cell.detailTextLabel.text = self.route.transportMode;
        }
        return cell;
    /***** Section 1 ****/
    } else if (indexPath.section == 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Waypoints"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WayPoints"];
        }
        Waypoint *waypoint = self.route.waypoints[indexPath.row];
        cell.textLabel.text = waypoint.title;
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Maneuver"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Maneuver"];
        }
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
        return NSLocalizedString(@"General Information", nil);
    } else if (section == 1) {
        return  NSLocalizedString(@"Waypoints", nil);
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
@end
