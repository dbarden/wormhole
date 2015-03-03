//
//  HereAPI.h
//  wormhole
//
//  Created by Daniel Barden on 02/03/15.
//  Copyright (c) 2015 azapp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface HereAPI : NSObject

+ (void)setAppId:(NSString *)appId appCode:(NSString *)appCode;

+ (NSURLSessionDataTask *)requestSearchWithQuery:(NSString *)query
                                   location:(CLLocation *)location
                                    success:(void (^)(NSArray *elements))success
                                    failure:(void (^)(NSError *error))failure;
@end
