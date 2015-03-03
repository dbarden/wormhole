//
//  AppDelegate.m
//  wormhole
//
//  Created by Daniel Barden on 02/03/15.
//  Copyright (c) 2015 azapp. All rights reserved.
//

#import "AppDelegate.h"
#import "HereAPI.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [HereAPI setAppId:@"DemoAppId01082013GAL" appCode:@"AJKnXv84fjrb0KIHawS0Tg"];
    return YES;
}

@end
