//
//  Route.m
//  wormhole
//
//  Created by Daniel Barden on 03/03/15.
//  Copyright (c) 2015 azapp. All rights reserved.
//

#import "Route.h"
#import "Waypoint.h"
#import "Leg.h"

static NSString *const WaypointsKey = @"waypoint";
static NSString *const LegsKey = @"leg";
static NSString *const SummaryKey = @"summary";
static NSString *const DistanceKey = @"distance";
static NSString *const BaseTimeKey = @"baseTime";
static NSString *const ModeKey = @"mode";
static NSString *const TransportModesKey = @"transportModes";

@interface Route ()

@property (nonatomic, strong, readwrite) NSArray *waypoints;
@property (nonatomic, strong, readwrite) NSArray *legs;
@property (nonatomic, assign, readwrite) HereTransportMode transportMode;
@property (nonatomic, assign, readwrite) NSUInteger distance;
@property (nonatomic, assign, readwrite) NSTimeInterval travelTime;

@end

@implementation Route

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        _distance = [dictionary[SummaryKey][DistanceKey] unsignedIntegerValue];
        _travelTime = [dictionary[SummaryKey][BaseTimeKey] doubleValue];
        _transportMode = [self transportModeToEnum:[dictionary[ModeKey][TransportModesKey] firstObject]];

        NSMutableArray *waypointsMutableArray = [NSMutableArray array];
        for (NSDictionary *waypointDict in dictionary[WaypointsKey]) {
            Waypoint *waypoint = [[Waypoint alloc] initWithDictionary:waypointDict];
            [waypointsMutableArray addObject:waypoint];
        }
        _waypoints = [waypointsMutableArray copy];

        NSMutableArray *legsMutableArray = [NSMutableArray array];
        for (NSDictionary *legDict in dictionary[LegsKey]) {
            Leg *leg = [[Leg alloc] initWithDictionary:legDict];
            [legsMutableArray addObject:leg];
        }
        _legs = [legsMutableArray copy];
    }
    return self;
}

- (MKCoordinateRegion)routeRegion
{
    CLLocationCoordinate2D topLeftCoord;
    topLeftCoord.latitude = -90;
    topLeftCoord.longitude = 180;

    CLLocationCoordinate2D bottomRightCoord;
    bottomRightCoord.latitude = 90;
    bottomRightCoord.longitude = -180;

    for (Waypoint *waypoint in self.waypoints)
    {
        topLeftCoord.longitude = fmin(topLeftCoord.longitude, waypoint.coordinate.longitude);
        topLeftCoord.latitude = fmax(topLeftCoord.latitude, waypoint.coordinate.latitude);

        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, waypoint.coordinate.longitude);
        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, waypoint.coordinate.latitude);
    }

    MKCoordinateRegion region;
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.4;
    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.4;

    return region;
}

- (HereTransportMode)transportModeToEnum:(NSString *)string
{
    if ([string isEqualToString:@"pedestrian"]) {
        return  HereTransportModePedestrian;
    } else if ([string isEqualToString:@"publicTransport"]) {
        return HereTransportModePublicTransport;
    } else if ([string isEqualToString:@"car"]) {
        return HereTransportModeCar;
    }
    return 0;
}

@end
