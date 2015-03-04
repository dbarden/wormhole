//
//  HereAPISpec+Testing.m
//  wormhole
//
//  Created by Daniel Barden on 04/03/15.
//  Copyright (c) 2015 azapp. All rights reserved.
//

#import "HereAPI+Testing.h"
#import "HereAPI.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincomplete-implementation"
@implementation HereAPI(Testing)
#pragma clang diagnostic pop

+ (void)resetAPIKeys
{
    [[HereAPI sharedInstance] setValue:nil forKey:@"appId"];
    [[HereAPI sharedInstance] setValue:nil forKey:@"appCode"];
}

@end
