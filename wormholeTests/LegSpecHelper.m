//
//  LegSpecHelper.m
//  wormhole
//
//  Created by Daniel Barden on 04/03/15.
//  Copyright (c) 2015 azapp. All rights reserved.
//

#import "LegSpecHelper.h"

const NSUInteger legLength = 3330;
const NSTimeInterval travelTime = 3393;

@implementation LegSpecHelper

+ (NSDictionary *)sampleData
{
    return @{@"start": @{
                     @"mappedPosition": @{
                             @"latitude": @(52.5162994),
                             @"longitude": @(13.3776737)
                             },
                     @"label": @"Pariser Platz",
                     },
             @"end": @{
                     @"mappedPosition": @{
                             @"latitude": @(52.5021815),
                             @"longitude": @(13.3415001)
                             },
                     @"label": @"Tauentzienstraße",
                     },
             @"length": @(legLength),
             @"travelTime": @(travelTime),
             @"maneuver": @[
                     @{
                         @"position": @{
                                 @"latitude": @(52.5162994),
                                 @"longitude": @(13.3776737)
                                 },
                         @"instruction": @"Head west on Pariser Platz. Go for 52 m.",
                         @"travelTime": @(62),
                         @"length": @(52),
                         },
                     @{
                         @"position": @{
                                 @"latitude": @(52.5162148),
                                 @"longitude": @(13.3769166)
                                 },
                         @"instruction": @"Turn left onto Platz des 18. März. Go for 36 m.",
                         @"travelTime": @(37),
                         @"length": @(36),
                         }
                     ]
             };

}
@end
