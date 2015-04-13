//
//  JSONParser.m
//  RedMadRobotTestApp
//
//  Created by Екатерина Колесникова on 13.04.15.
//  Copyright (c) 2015 Kolesnikova Ekaterina. All rights reserved.
//

#import "JSONParser.h"

@implementation JSONParser

+ (NSString *)parseJSONdata:(id)jsonData andFindUserIdByUsername:(NSString *)username
{
    NSString *userId = nil;
    NSDictionary *dataDictionary = [jsonData objectForKey:@"data"];
    for (NSDictionary *userDiction in dataDictionary) {
        if ([[NSString stringWithFormat:@"%@", [userDiction objectForKey:@"username"]] isEqualToString:username]) {
            userId = [userDiction objectForKey:@"id"];
        }
    }
    return userId;
}

@end
