//
//  WaypointSpec.m
//  wormhole
//
//  Created by Daniel Barden on 03/03/15.
//  Copyright (c) 2015 azapp. All rights reserved.
//

#import <Specta/Specta.h>
#define EXP_SHORTHAND
#import <Expecta/Expecta.h>

#import "Waypoint.h"

SpecBegin(Waypoint)

describe(@"Waypoint", ^{
    it(@"should be initialized correctly", ^{
        NSString *labelName = @"Eiffel Tower";
        NSString *latitude = @"53.5";
        NSString *longitude = @"12.48";
        NSDictionary *testData = @{@"label": labelName,
                                   @"mappedPosition": @{@"latitude": latitude,
                                                        @"longitude":longitude}};
        Waypoint *sut = [[Waypoint alloc] initWithDictionary:testData];
        expect(sut.label).to.equal(labelName);
        expect(sut.position.coordinate.latitude).to.equal([latitude doubleValue]);
        expect(sut.position.coordinate.longitude).to.equal([longitude doubleValue]);
    });
});
SpecEnd
