//
//  HereAPISpecHelper.m
//  wormhole
//
//  Created by Daniel Barden on 04/03/15.
//  Copyright (c) 2015 azapp. All rights reserved.
//

#import "HereAPISpecHelper.h"
#import <OHHTTPStubs/OHHTTPStubs.h>
#import <OHHTTPStubsResponse+JSON.h>

@implementation HereAPISpecHelper

+ (void)enablePlacesNetworkStub
{
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return [request.URL.host isEqualToString:@"places.cit.api.here.com"];
    } withStubResponse:^OHHTTPStubsResponse * (NSURLRequest * request) {
        return [OHHTTPStubsResponse
                responseWithFileAtPath:OHPathForFileInBundle(@"PlacesResponse.json", nil)
                statusCode:200
                headers:nil];
    }];
}
@end
