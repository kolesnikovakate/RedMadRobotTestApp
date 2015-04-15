//
//  NSDictionary+InstagramRequest.h
//  RedMadRobotTestApp
//
//  Created by Екатерина Колесникова on 15.04.15.
//  Copyright (c) 2015 Kolesnikova Ekaterina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (InstagramRequest)

+ (NSDictionary *)requestParamsDictionaryWithDictionary:(NSDictionary *)parameters;

@end
