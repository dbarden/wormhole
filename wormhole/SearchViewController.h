//
//  SearchViewController.h
//  wormhole
//
//  Created by Daniel Barden on 02/03/15.
//  Copyright (c) 2015 azapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Place.h"

@interface SearchViewController : UITableViewController <UISearchResultsUpdating>

@property (nonatomic, strong, readonly) Place *selectedPlace;

@end
