//
//  LegSpec.m
//  wormhole
//
//  Created by Daniel Barden on 03/03/15.
//  Copyright (c) 2015 azapp. All rights reserved.
//

#import <Specta/Specta.h>
#define EXP_SHORTHAND
#import <Expecta/Expecta.h>

#import "Leg.h"

SpecBegin(Leg)

describe(@"Leg", ^{
    it(@"should be initialized correctly", ^{
        NSDictionary *testData = @{@"start": @{
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
                                   @"length": @(3330),
                                   @"travelTime": @(3393),
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

        Leg *sut = [[Leg alloc] initWithDictionary:testData];
        expect(sut.startWaypoint).toNot.beNil();
        expect(sut.endWaypoint).toNot.beNil();
        expect(sut.maneuvers.count).to.equal(2);
        expect(sut.length).to.equal(3330);
        expect(sut.travelTime).to.equal(3393);
    });
});
SpecEnd
