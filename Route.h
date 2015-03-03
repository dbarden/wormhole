//
//  Route.h
//  wormhole
//
//  Created by Daniel Barden on 03/03/15.
//  Copyright (c) 2015 azapp. All rights reserved.
//

@import Foundation;

@interface Route : NSObject

@property (nonatomic, strong, readonly) id startPoint;
@property (nonatomic, strong, readonly) id endPoint;
@property (nonatomic, strong, readonly) NSArray *maneuvers;
@property (nonatomic, strong, readonly) NSArray *waypoints;
@property (nonatomic, assign, readonly) NSString *transportMode;
@property (nonatomic, assign, readonly) NSUInteger distance;
@property (nonatomic, assign, readonly) NSTimeInterval duration;

/**
 *  Create a route object.
 *
 *  @param dictionary The dictionary returned by the HERE API
 *
 *  @return a configure instance of route
 */
- (instancetype)initWithDictionary:(NSDictionary *)dictionary NS_DESIGNATED_INITIALIZER;

@end
