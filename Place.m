//
//  Place.m
//  wormhole
//
//  Created by Daniel Barden on 02/03/15.
//  Copyright (c) 2015 azapp. All rights reserved.
//

#import "Place.h"

@implementation Place

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        _title = dictionary[@"title"];
        _location = [[CLLocation alloc] initWithLatitude:[dictionary[@"position"][0] doubleValue] longitude:[dictionary[@"position"][1] doubleValue]];
    }

    return self;
}

- (void)dealloc
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ - %@", self.title, self.location];
}
@end
