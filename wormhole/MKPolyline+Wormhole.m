//
//  MKPolyline.m
//  wormhole
//
//  Created by Daniel Barden on 04/03/15.
//  Copyright (c) 2015 azapp. All rights reserved.
//

#import "MKPolyline+Wormhole.h"
#import "Leg.h"
#import "Maneuver.h"

@implementation MKPolyline(Wormhole)

- (instancetype)initWithLeg:(Leg *)leg
{
    NSArray *maneuvers = leg.maneuvers;

    CLLocationCoordinate2D *coordinateArray = malloc(sizeof(CLLocationCoordinate2D) * maneuvers.count);

    int caIndex = 0;
    for (Maneuver *maneuver in maneuvers) {
        coordinateArray[caIndex] = maneuver.coordinate;
        caIndex++;
    }

    self = [MKPolyline polylineWithCoordinates:coordinateArray
                                                      count:maneuvers.count];

    free(coordinateArray);
    return self;
}

@end
