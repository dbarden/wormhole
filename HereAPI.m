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

static NSString *const HereTransportMapping[3] = {
    @"fastest;pedestrian",
    @"fastest;publicTransportTimeTable",
    @"fastest;car",
};

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

+ (NSURLSessionDataTask *)requestRouteWithPlaces:(NSArray *)places
                                            mode:(HereTransportMode)transportMode
{
    return [[self sharedInstance] requestRouteWithPlaces:places mode:transportMode failure:nil];
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


    NSURLQueryItem *appId = [NSURLQueryItem queryItemWithName:@"app_id" value:self.appId];
    NSURLQueryItem *appCode = [NSURLQueryItem queryItemWithName:@"app_code" value:self.appCode];
    NSURLQueryItem *size = [NSURLQueryItem queryItemWithName:@"size" value:@"10"];
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

        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

        NSMutableArray *placeEntries = [NSMutableArray array];
        for (NSDictionary *entry in dictionary[@"results"][@"items"]) {
            [placeEntries addObject:[[Place alloc] initWithDictionary:entry]];
        }
        success(placeEntries);

    }];

    return dataTask;
}

// TODO: Add language
- (NSURLSessionDataTask *)requestRouteWithPlaces:(NSArray *)places
                                            mode:(HereTransportMode)transportMode
                                         failure:(void (^)(NSError *error))failure
{
    NSURLComponents *urlComponents = [[NSURLComponents alloc] init];
    urlComponents.scheme = @"http";
    urlComponents.host = @"route.cit.api.here.com";
    urlComponents.path = @"/routing/7.2/calculateroute.json";


    __block NSMutableArray *queryItems = [NSMutableArray array];
    NSURLQueryItem *appId = [NSURLQueryItem queryItemWithName:@"app_id" value:self.appId];
    NSURLQueryItem *appCode = [NSURLQueryItem queryItemWithName:@"app_code" value:self.appCode];
    NSURLQueryItem *instructionFormat = [NSURLQueryItem queryItemWithName:@"instructionFormat" value:@"text"];

    NSURLQueryItem *mode = [NSURLQueryItem queryItemWithName:@"mode" value:HereTransportMapping[transportMode]];

    [queryItems addObject:appId];
    [queryItems addObject:appCode];
    [queryItems addObject:instructionFormat];
    [queryItems addObject:mode];

    [places enumerateObjectsUsingBlock:^(Place *obj, NSUInteger idx, BOOL *stop) {
        NSString *queryItemName = [NSString stringWithFormat:@"waypoint%lu",(unsigned long)idx];
        NSString *queryItemValue = [NSString stringWithFormat:@"geo!%f,%f", obj.location.coordinate.latitude, obj.location.coordinate.longitude];
        NSURLQueryItem *waypoint = [NSURLQueryItem queryItemWithName:queryItemName value:queryItemValue];
        [queryItems addObject:waypoint];
    }];

    urlComponents.queryItems = queryItems;

    NSURLRequest *requestURL = [NSURLRequest requestWithURL:urlComponents.URL];

    NSLog(@"Requesting %@", requestURL.URL.absoluteString);

    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:requestURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;

        if (error || httpResponse.statusCode > 400) {
            failure(error);
            return;
        }
        // Parse the route
    }];

    return dataTask;

}

@end


