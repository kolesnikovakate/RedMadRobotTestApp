//
//  JSONParser.h
//  RedMadRobotTestApp
//
//  Created by Екатерина Колесникова on 13.04.15.
//  Copyright (c) 2015 Kolesnikova Ekaterina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSONParser : NSObject

+ (NSNumber *)parseJSONdata:(id)jsonData andFindUserIdByUsername:(NSString *)username;
+ (NSArray *)parseAndGetPhotosByJSONdata:(id)jsonData;

@end
