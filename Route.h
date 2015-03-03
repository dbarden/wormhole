//
//  Route.h
//  wormhole
//
//  Created by Daniel Barden on 03/03/15.
//  Copyright (c) 2015 azapp. All rights reserved.
//

@import Foundation;

@interface Route : NSObject

@property (nonatomic, strong, readonly) NSArray *waypoints;
@property (nonatomic, strong, readonly) NSArray *legs;
@property (nonatomic, copy, readonly) NSString *transportMode;
@property (nonatomic, assign, readonly) NSUInteger distance;
@property (nonatomic, assign, readonly) NSTimeInterval travelTime;

/**
 *  Create a route object.
 *
 *  @param dictionary The dictionary returned by the HERE API
 *
 *  @return a configure instance of route
 */
- (instancetype)initWithDictionary:(NSDictionary *)dictionary NS_DESIGNATED_INITIALIZER;

@end
