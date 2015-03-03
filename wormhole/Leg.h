//
//  Leg.h
//  wormhole
//
//  Created by Daniel Barden on 03/03/15.
//  Copyright (c) 2015 azapp. All rights reserved.
//

@import Foundation;

@class Waypoint;

@interface Leg : NSObject

@property (nonatomic, strong, readonly) Waypoint *startWaypoint;
@property (nonatomic, strong, readonly) Waypoint *endWaypoint;
@property (nonatomic, strong, readonly) NSArray *maneuvers;
@property (nonatomic, assign, readonly) NSTimeInterval travelTime;
@property (nonatomic, assign, readonly) NSUInteger length;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary NS_DESIGNATED_INITIALIZER;

@end
