//
//  HereAPI.h
//  wormhole
//
//  Created by Daniel Barden on 02/03/15.
//  Copyright (c) 2015 azapp. All rights reserved.
//

#import "HereTransportModes.h"
@import Foundation;
@import CoreLocation;


@class Route;

@interface HereAPI : NSObject

/**
 *  Sets the initial credentials to use the HERE API
 *
 *  These credentials can be obtained on the HERE website at https://developer.here.com/get-started#/
 *
 *  @param appId   The application id to be used
 *  @param appCode The aplication code to be used
 */
+ (void)setAppId:(NSString *)appId appCode:(NSString *)appCode;

/**
 *  Creates the NSURLSessionDataTask to perform query about a place
 *
 *  Creates and configures a NSURLSessionDataTask to perform a give query. This method does not start
 *  the download of the information.
 *
 *  @param query    The query to be used
 *  @param location The location of the user or the an area used to filter the results
 *  @param success  A success block. `elements` contains an array of `Place` objects
 *  @param failure  A failure block.
 *
 *  @return A configured NSURLSessionDataTask
 */
+ (NSURLSessionDataTask *)requestSearchWithQuery:(NSString *)query
                                   location:(CLLocation *)location
                                    success:(void (^)(NSArray *elements))success
                                    failure:(void (^)(NSError *error))failure;

/**
 *  Request a route between a given number of places.
 *
 *  @param places        An array containing `Place` objects
 *  @param transportMode The desired transport mode
 *  @param success       The block to be executed in case of success
 *  @param failure       The block to be executed in case of failure
 *
 *  @return A configured NSURLSessionDataTask
 */
+ (NSURLSessionDataTask *)requestRouteWithPlaces:(NSArray *)places
                                            mode:(HereTransportMode)transportMode
                                         success:(void (^)(Route *route))success
                                         failure:(void (^)(NSError *))failure;

@end
