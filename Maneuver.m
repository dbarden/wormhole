//
//  Maneuver.m
//  wormhole
//
//  Created by Daniel Barden on 03/03/15.
//  Copyright (c) 2015 azapp. All rights reserved.
//

#import "Maneuver.h"

static NSString *const InstructionKey = @"instruction";
static NSString *const TravelTimeKey = @"travelTime";
static NSString *const LengthKey = @"length";
static NSString *const PositionKey = @"position";
static NSString *const LatitudeKey = @"latitude";
static NSString *const LongitudeKey = @"longitude";


@interface Maneuver ()

@property (nonatomic, copy, readwrite) NSString *instructions;
@property (nonatomic, strong, readwrite) CLLocation *position;
@property (nonatomic, assign, readwrite) NSTimeInterval travelTime;
@property (nonatomic, assign, readwrite) NSUInteger length;

@end


@implementation Maneuver

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        _instructions = dictionary[InstructionKey];
        _travelTime = [dictionary[TravelTimeKey] doubleValue];
        _length = [dictionary[LengthKey] unsignedIntegerValue];

        CLLocationDegrees latitude = [dictionary[PositionKey][LatitudeKey] doubleValue];
        CLLocationDegrees longitude = [dictionary[PositionKey][LongitudeKey] doubleValue];
        _position = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    }
    return self;
}
@end
