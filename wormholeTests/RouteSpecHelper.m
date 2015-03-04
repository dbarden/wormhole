//
//  RouteSpecHelper.m
//  wormhole
//
//  Created by Daniel Barden on 04/03/15.
//  Copyright (c) 2015 azapp. All rights reserved.
//

#import "RouteSpecHelper.h"
#import "LegSpecHelper.h"

const NSUInteger routeDistance = 6009;
const NSTimeInterval routeTravelTime = 6116;
@implementation RouteSpecHelper

+ (NSDictionary *)sampleData
{


    return @{
             @"waypoint": @[
                     @{
                         @"linkId": @"-1609370976066142643",
                         @"mappedPosition": @{
                                 @"latitude": @(52.5162994),
                                 @"longitude": @(13.3776737)
                                 },
                         @"originalPosition": @{
                                 @"latitude": @(52.51628),
                                 @"longitude": @(13.37768)
                                 },
                         @"type": @"stopOver",
                         @"spot": @(0.5),
                         @"sideOfStreet": @"neither",
                         @"mappedRoadName": @"Pariser Platz",
                         @"label": @"Pariser Platz",
                         @"shapeIndex": @(0)
                         },
                     @{
                         @"linkId": @"+1609300603010220198",
                         @"mappedPosition": @{
                                 @"latitude": @(52.5021815),
                                 @"longitude": @(13.3415001)
                                 },
                         @"originalPosition": @{
                                 @"latitude": @(52.50217),
                                 @"longitude": @(13.3414899)
                                 },
                         @"type": @"stopOver",
                         @"spot": @(0.2159091),
                         @"sideOfStreet": @"left",
                         @"mappedRoadName": @"Tauentzienstraße",
                         @"label": @"Tauentzienstraße",
                         @"shapeIndex": @(67)
                         },
                     @{
                         @"linkId": @"+1609300607305187563",
                         @"mappedPosition": @{
                                 @"latitude": @(52.509303),
                                 @"longitude": @(13.3728352)
                                 },
                         @"originalPosition": @{
                                 @"latitude": @(52.50933),
                                 @"longitude": @(13.37283)
                                 },
                         @"type": @"stopOver",
                         @"spot": @(0.826087),
                         @"sideOfStreet": @"left",
                         @"mappedRoadName": @"Potsdamer Straße",
                         @"label": @"Potsdamer Straße - B1",
                         @"shapeIndex": @(123)
                         }
                     ],
             @"mode": @{
                     @"type": @"fastest",
                     @"transportModes": @[
                             @"pedestrian"
                             ],
                     @"trafficMode": @"default",
                     @"feature": @[

                             ]
                     },
             @"leg": @[ [LegSpecHelper sampleData]
                        ],
             @"summary": @{
                     @"distance": @(routeDistance),
                     @"baseTime": @(routeTravelTime),
                     @"flags": @[
                             @"noThroughRoad",
                             @"builtUpArea"
                             ],
                     @"text": @"The trip takes 6.0 km and 1:42 h.",
                     @"travelTime": @(routeTravelTime),
                     @"_type": @"RouteSummaryType"
                     }
             };
}

@end
