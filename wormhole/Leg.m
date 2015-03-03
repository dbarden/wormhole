//
//  Leg.m
//  wormhole
//
//  Created by Daniel Barden on 03/03/15.
//  Copyright (c) 2015 azapp. All rights reserved.
//

#import "Leg.h"
#import "Waypoint.h"
#import "Maneuver.h"

static NSString *const StartKey = @"start";
static NSString *const EndKey = @"end";
static NSString *const ManeuverKey = @"maneuver";
static NSString *const TravelTimeKey = @"travelTime";
static NSString *const LengthKey = @"length";

@interface Leg ()

@property (nonatomic, strong, readwrite) Waypoint *startWaypoint;
@property (nonatomic, strong, readwrite) Waypoint *endWayPoint;
@property (nonatomic, strong, readwrite) NSArray *maneuvers;
@property (nonatomic, assign, readwrite) NSTimeInterval travelTime;
@property (nonatomic, assign, readwrite) NSUInteger length;

@end

@implementation Leg

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        _startWaypoint = [[Waypoint alloc] initWithDictionary:dictionary[StartKey]];
        _endWaypoint = [[Waypoint alloc] initWithDictionary:dictionary[EndKey]];
        _travelTime = [dictionary[TravelTimeKey] doubleValue];
        _length = [dictionary[LengthKey] doubleValue];

        NSMutableArray *maneuverMutableArray = [NSMutableArray array];
        for (NSDictionary *maneuverDict in dictionary[ManeuverKey]) {
            Maneuver *maneuver = [[Maneuver alloc] initWithDictionary:maneuverDict];
            [maneuverMutableArray addObject:maneuver];
        }
        _maneuvers = [maneuverMutableArray copy];
    }
    return self;

}
@end
