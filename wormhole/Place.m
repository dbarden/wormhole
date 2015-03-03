//
//  Place.m
//  wormhole
//
//  Created by Daniel Barden on 02/03/15.
//  Copyright (c) 2015 azapp. All rights reserved.
//

#import "Place.h"

static NSString *const PositionKey = @"position";
static NSString *const TitleKey = @"title";
static NSString *const VicinityKey = @"vicinity";

@implementation Place

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        _title = dictionary[TitleKey];
        CLLocationDegrees latitude = [dictionary[PositionKey][0] doubleValue];
        CLLocationDegrees longitude = [dictionary[PositionKey][1] doubleValue];
        _coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        _vicinity = [[dictionary[VicinityKey] componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@" "];
    }

    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ - {%f, %f}", self.title, self.coordinate.latitude, self.coordinate.longitude];
}
@end
