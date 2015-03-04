//
//  LegSpecHelper.h
//  wormhole
//
//  Created by Daniel Barden on 04/03/15.
//  Copyright (c) 2015 azapp. All rights reserved.
//

#import <Foundation/Foundation.h>

extern const NSUInteger legLength;
extern const NSTimeInterval travelTime;

@interface LegSpecHelper : NSObject

+ (NSDictionary *)sampleData;
@end
