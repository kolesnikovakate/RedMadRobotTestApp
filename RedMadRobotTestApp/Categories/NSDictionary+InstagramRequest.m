//
//  NSDictionary+InstagramRequest.m
//  RedMadRobotTestApp
//
//  Created by Екатерина Колесникова on 15.04.15.
//  Copyright (c) 2015 Kolesnikova Ekaterina. All rights reserved.
//

#import "NSDictionary+InstagramRequest.h"

@implementation NSDictionary (InstagramRequest)

+ (NSDictionary *)requestParamsDictionaryWithDictionary:(NSDictionary *)parameters
{
    NSMutableDictionary *params = parameters ? [parameters mutableCopy] : [NSMutableDictionary new];
    params[@"client_id"] = kRMRClientId;
    return params;
}

@end
