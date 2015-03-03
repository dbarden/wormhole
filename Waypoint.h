//
//  Waypoint.h
//  wormhole
//
//  Created by Daniel Barden on 03/03/15.
//  Copyright (c) 2015 azapp. All rights reserved.
//

@import Foundation;
@import CoreLocation;

@interface Waypoint : NSObject

@property (nonatomic, copy, readonly) NSString *label;
@property (nonatomic, strong, readonly) CLLocation *position;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary NS_DESIGNATED_INITIALIZER;

@end
