//
//  CreateItineraryDataSource.h
//  wormhole
//
//  Created by Daniel Barden on 02/03/15.
//  Copyright (c) 2015 azapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Place.h"

FOUNDATION_EXPORT NSString *const CreateItineraryCellIdentifier;

@interface CreateItineraryDataSource : NSObject <UITableViewDataSource>

- (void)addPlace:(Place *)place;

@end
