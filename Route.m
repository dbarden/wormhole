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
@property (nonatomic, copy, readwrite) NSString *transportMode;
@property (nonatomic, assign, readwrite) NSUInteger distance;
@property (nonatomic, assign, readwrite) NSTimeInterval travelTime;

@end

@implementation Route

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        _distance = [dictionary[DistanceKey] unsignedIntegerValue];
        _travelTime = [dictionary[BaseTimeKey] doubleValue];
        _transportMode = [dictionary[ModeKey][TransportModesKey] firstObject];

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
@end
