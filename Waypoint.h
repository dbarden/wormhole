//
//  Waypoint.h
//  wormhole
//
//  Created by Daniel Barden on 03/03/15.
//  Copyright (c) 2015 azapp. All rights reserved.
//

@import Foundation;
@import CoreLocation;
@import MapKit;

@interface Waypoint : NSObject<MKAnnotation>

@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, assign, readonly) CLLocationCoordinate2D coordinate;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary NS_DESIGNATED_INITIALIZER;

@end
