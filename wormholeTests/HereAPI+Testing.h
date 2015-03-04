//
//  HereAPISpec+Testing.h
//  wormhole
//
//  Created by Daniel Barden on 04/03/15.
//  Copyright (c) 2015 azapp. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HereAPI.h"

@interface HereAPI(Testing)
+ (HereAPI *)sharedInstance;
+ (void)resetAPIKeys;

@end
