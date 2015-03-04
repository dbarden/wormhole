//
//  Route+i18n.m
//  wormhole
//
//  Created by Daniel Barden on 04/03/15.
//  Copyright (c) 2015 azapp. All rights reserved.
//

#import "Route+Formatting.h"

@implementation Route(Formatting)

- (NSString *)localizedTransportName
{
    if (self.transportMode == HereTransportModePedestrian) {
        return NSLocalizedString(@"pedestrian", nil);
    } else if (self.transportMode == HereTransportModePublicTransport) {
        return NSLocalizedString(@"public_transport", nil);
    } else if (self.transportMode == HereTransportModeCar) {
        return NSLocalizedString(@"car", nil);
    }
    return NSLocalizedString(@"undetermined", nil);
}

- (NSString *)formattedTravelTime
{

    NSDateComponentsFormatter *componentFormatter = [[NSDateComponentsFormatter alloc] init];

    componentFormatter.unitsStyle = NSDateComponentsFormatterUnitsStyleAbbreviated;
    componentFormatter.zeroFormattingBehavior = NSDateComponentsFormatterZeroFormattingBehaviorDropAll;
    return [componentFormatter stringFromTimeInterval:self.travelTime];
}

- (NSString *)formattedDistance
{
    MKDistanceFormatter *distanceFormatter = [[MKDistanceFormatter alloc] init];
    return [distanceFormatter stringFromDistance:self.distance];
}

@end
