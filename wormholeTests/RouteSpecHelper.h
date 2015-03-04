//
//  RouteSpecHelper.h
//  wormhole
//
//  Created by Daniel Barden on 04/03/15.
//  Copyright (c) 2015 azapp. All rights reserved.
//

#import <Foundation/Foundation.h>

extern const NSUInteger routeDistance;
extern const NSTimeInterval routeTravelTime;

@interface RouteSpecHelper : NSObject

+ (NSDictionary *)sampleData;

@end
