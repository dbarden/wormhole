//
//  HereAPI.m
//  wormhole
//
//  Created by Daniel Barden on 02/03/15.
//  Copyright (c) 2015 azapp. All rights reserved.
//

#import "HereAPI.h"
#import "Place.h"

static NSString *const SearchBaseURL = @"http://places.cit.api.here.com/places/v1/discover/search";

@interface HereAPI()

@property (nonatomic, copy) NSString *appId;
@property (nonatomic, copy) NSString *appCode;
@end

@implementation HereAPI

+ (HereAPI *)sharedInstance
{
    static HereAPI *sharedInstance;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        sharedInstance = [[HereAPI alloc] init];
    });

    return sharedInstance;
}

+ (void)setAppId:(NSString *)appId appCode:(NSString *)appCode
{
    [[self sharedInstance] setAppId:appId appCode:appCode];
}

+ (NSURLSessionDataTask *)requestSearchWithQuery:(NSString *)query
                                   location:(CLLocation *)location
                                    success:(void (^)(NSArray *))success
                                    failure:(void (^)(NSError *))failure
{
    return [[self sharedInstance] requestSearchWithQuery:query location:location success:success failure:failure];
}

- (void)setAppId:(NSString *)appId appCode:(NSString *)appCode
{
    self.appId = appId;
    self.appCode = appCode;
}

- (NSURLSessionDataTask *)requestSearchWithQuery:(NSString *)query
                                   location:(CLLocation *)location
                                    success:(void (^)(NSArray *))success
                                    failure:(void (^)(NSError *))failure
{
    if (!self.appId || !self.appCode) {
        NSLog(@"AppId or AppCode not available. Please cal +[HereAPI setAppId:appCode:] to initialize the API");
        return nil;
    }

    NSURLComponents *urlComponents = [[NSURLComponents alloc] init];
    urlComponents.scheme = @"http";
    urlComponents.host = @"places.cit.api.here.com";
    urlComponents.path = @"/places/v1/discover/search";

    NSURLQueryItem *size = [NSURLQueryItem queryItemWithName:@"size" value:@"10"];
    NSURLQueryItem *appId = [NSURLQueryItem queryItemWithName:@"app_id" value:self.appId];
    NSURLQueryItem *appCode = [NSURLQueryItem queryItemWithName:@"app_code" value:self.appCode];
    NSURLQueryItem *queryItem = [NSURLQueryItem queryItemWithName:@"q" value:query];
    NSURLQueryItem *at = [NSURLQueryItem queryItemWithName:@"at" value:[NSString stringWithFormat:@"%f,%f", location.coordinate.latitude, location.coordinate.longitude]];

    urlComponents.queryItems = @[appId, appCode, queryItem, at, size];
    NSURLRequest *requestURL = [NSURLRequest requestWithURL:urlComponents.URL];


    NSLog(@"Requesting URL: %@", requestURL);
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:requestURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;

        if (error || httpResponse.statusCode > 400) {
            failure(error);
            return;
        }
        NSLog(@"***");

        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

        NSMutableArray *placeEntries = [NSMutableArray array];
        for (NSDictionary *entry in dictionary[@"results"][@"items"]) {
            [placeEntries addObject:[[Place alloc] initWithDictionary:entry]];
        }
        success(placeEntries);

    }];

    return dataTask;
}


@end
