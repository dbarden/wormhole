//
//  ManeuverSpec.m
//  wormhole
//
//  Created by Daniel Barden on 03/03/15.
//  Copyright (c) 2015 azapp. All rights reserved.
//

#import <Specta/Specta.h>
#define EXP_SHORTHAND
#import <Expecta/Expecta.h>

#import "Maneuver.h"

SpecBegin(Maneuver)

describe(@"Maneuver",^{
    it(@"should be initialized correctly", ^{
        NSString *instruction = @"Turn Left in 50m";
        NSNumber *travelTime = @(235);
        NSNumber *length = @(32);
        NSNumber *latitude = @(42.13123);
        NSNumber *longitude = @(12.13123);

        NSDictionary *testData = @{@"instruction": instruction,
                                   @"travelTime": travelTime,
                                   @"length": length,
                                   @"position": @{@"latitude": latitude,
                                                  @"longitude": longitude
                                                  }
                                   };

        Maneuver *sut = [[Maneuver alloc] initWithDictionary:testData];

        expect(sut.instructions).to.equal(instruction);
        expect(sut.travelTime).to.equal([travelTime doubleValue]);
        expect(sut.length).to.equal([length doubleValue]);
        expect(sut.coordinate.latitude).to.equal([latitude doubleValue]);
        expect(sut.coordinate.longitude).to.equal([longitude doubleValue]);

    });
});
SpecEnd
