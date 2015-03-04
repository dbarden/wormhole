//
//  MKPolyline.h
//  wormhole
//
//  Created by Daniel Barden on 04/03/15.
//  Copyright (c) 2015 azapp. All rights reserved.
//

@import MapKit;

@class Leg;

@interface MKPolyline(Wormhole)

- (instancetype)initWithLeg:(Leg *)leg;

@end
