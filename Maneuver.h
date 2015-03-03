//
//  Maneuver.h
//  wormhole
//
//  Created by Daniel Barden on 03/03/15.
//  Copyright (c) 2015 azapp. All rights reserved.
//

@import Foundation;
@import CoreLocation;

@interface Maneuver : NSObject


@property (nonatomic, copy, readonly) NSString *instructions;
@property (nonatomic, strong, readonly) CLLocation *position;
@property (nonatomic, assign, readonly) NSTimeInterval travelTime;
@property (nonatomic, assign, readonly) NSUInteger length;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary NS_DESIGNATED_INITIALIZER;
@end
