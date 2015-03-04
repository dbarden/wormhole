//
//  Route+i18n.h
//  wormhole
//
//  Created by Daniel Barden on 04/03/15.
//  Copyright (c) 2015 azapp. All rights reserved.
//

@import Foundation;

#import "Route.h"

@interface Route(Formatting)

- (NSString *)localizedTransportName;
- (NSString *)formattedTravelTime;
- (NSString *)formattedDistance;

@end
