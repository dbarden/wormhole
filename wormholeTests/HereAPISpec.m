//
//  HereAPISpec.m
//  wormhole
//
//  Created by Daniel Barden on 03/03/15.
//  Copyright (c) 2015 azapp. All rights reserved.
//

#import <Specta/Specta.h>
#define EXP_SHORTHAND
#import <Expecta/Expecta.h>

#import "HereAPI.h"
#import "HereAPI+Testing.h"
#import "HereAPISpecHelper.h"


SpecBegin(HereAPI)

describe(@"HereApi Places", ^{

    it(@"should initialize a request to places", ^{
        [HereAPI setAppId:@"testAppId" appCode:@"test"];
        NSURLSessionDataTask *dataTask = [HereAPI requestSearchWithQuery:@"testQuery" location:nil success:nil failure:nil];
        expect(dataTask).toNot.beNil();
        expect(dataTask.currentRequest.URL.host).to.equal(@"places.cit.api.here.com");
        expect(dataTask.currentRequest.URL.query).to.contain(@"app_id=testAppId");
        expect(dataTask.currentRequest.URL.query).to.contain(@"q=testQuery");
    });

    it(@"should return nil when no appid", ^{
        [HereAPI resetAPIKeys];
        NSURLSessionDataTask *dataTask = [HereAPI requestSearchWithQuery:@"testQuery" location:nil success:nil failure:nil];
        expect(dataTask).to.beNil();

    });

    it(@"should return a list of places in the success callback", ^{
        [HereAPISpecHelper enablePlacesNetworkStub];
        [HereAPI setAppId:@"testAppId" appCode:@"test"];

        waitUntil(^(DoneCallback done) {
            NSURLSessionDataTask *dataTask = [HereAPI requestSearchWithQuery:@"testQuery" location:nil success:^(NSArray *elements) {
                expect(elements.count).to.equal(2);
                done();
            } failure:nil];
            [dataTask resume];
        });
    });
});
SpecEnd
