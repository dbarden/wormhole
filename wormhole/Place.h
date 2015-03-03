//
//  Place.h
//  wormhole
//
//  Created by Daniel Barden on 02/03/15.
//  Copyright (c) 2015 azapp. All rights reserved.
//

@import Foundation;
@import CoreLocation;

@interface Place : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dictionary NS_DESIGNATED_INITIALIZER;
@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSString *vicinity;
@property (nonatomic, assign, readonly) CLLocationCoordinate2D coordinate;

@end
