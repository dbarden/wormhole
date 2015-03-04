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
#import "LegSpecHelper.h"

SpecBegin(Leg)

describe(@"Leg", ^{
    it(@"should be initialized correctly", ^{
        NSDictionary *testData = [LegSpecHelper sampleData];

        Leg *sut = [[Leg alloc] initWithDictionary:testData];
        expect(sut.startWaypoint).toNot.beNil();
        expect(sut.endWaypoint).toNot.beNil();
        expect(sut.maneuvers.count).to.equal(2);
        expect(sut.length).to.equal(3330);
        expect(sut.travelTime).to.equal(3393);
    });
});
SpecEnd
