//
//  RouteSpec.m
//  wormhole
//
//  Created by Daniel Barden on 03/03/15.
//  Copyright (c) 2015 azapp. All rights reserved.
//

#import <Specta/Specta.h>
#define EXP_SHORTHAND
#import <Expecta/Expecta.h>

#import "Route.h"
#import "RouteSpecHelper.h"

SpecBegin(Route)
describe(@"Route", ^{
    it(@"should be initialized correctly", ^{
        Route *sut = [[Route alloc] initWithDictionary:[RouteSpecHelper sampleData]];
        expect(sut.waypoints.count).to.equal(3);
        expect(sut.legs.count).to.equal(1);
        expect(sut.transportMode).to.equal(0);
        expect(sut.distance).to.equal(routeDistance);
        expect(sut.travelTime).to.equal(routeTravelTime);
    });
});

SpecEnd
