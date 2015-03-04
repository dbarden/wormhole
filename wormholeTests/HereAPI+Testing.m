//
//  HereAPISpec+Testing.m
//  wormhole
//
//  Created by Daniel Barden on 04/03/15.
//  Copyright (c) 2015 azapp. All rights reserved.
//

#import "HereAPI+Testing.h"
#import "HereAPI.h"


@implementation HereAPI(Testing)

+ (void)resetAPIKeys
{
    [[HereAPI sharedInstance] setValue:nil forKey:@"appId"];
    [[HereAPI sharedInstance] setValue:nil forKey:@"appCode"];
}

@end
