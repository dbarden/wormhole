//
//  Waypoint.m
//  wormhole
//
//  Created by Daniel Barden on 03/03/15.
//  Copyright (c) 2015 azapp. All rights reserved.
//

#import "Waypoint.h"

static NSString *const NameKey = @"label";
static NSString *const PositionKey = @"mappedPosition";
static NSString *const LatitudeKey = @"latitude";
static NSString *const LongitudeKey = @"longitude";

@interface Waypoint ()

@property (nonatomic, copy, readwrite) NSString *label;
@property (nonatomic, strong, readwrite) CLLocation *position;

@end

@implementation Waypoint

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        _label = dictionary[NameKey];

        CLLocationDegrees latitude = [dictionary[PositionKey][LatitudeKey] doubleValue];
        CLLocationDegrees longitude = [dictionary[PositionKey][LongitudeKey] doubleValue];
        _position = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    }
    return self;
}
@end
