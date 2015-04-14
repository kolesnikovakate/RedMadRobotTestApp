//
//  JSONParser.m
//  RedMadRobotTestApp
//
//  Created by Екатерина Колесникова on 13.04.15.
//  Copyright (c) 2015 Kolesnikova Ekaterina. All rights reserved.
//

#import "JSONParser.h"
#import "RMRPhoto.h"

@implementation JSONParser

+ (NSNumber *)parseJSONdata:(id)jsonData andFindUserIdByUsername:(NSString *)username
{
    NSNumber *userId = nil;
    NSDictionary *dataDictionary = [jsonData objectForKey:@"data"];
    for (NSDictionary *userDiction in dataDictionary) {
        if ([[NSString stringWithFormat:@"%@", [userDiction objectForKey:@"username"]] isEqualToString:username]) {
            userId = [userDiction objectForKey:@"id"];
        }
    }
    return userId;
}

+ (NSArray *)parseAndGetPhotosByJSONdata:(id)jsonData
{
    NSMutableArray *photoArray = [[NSMutableArray alloc] init];
    NSDictionary *dataDictionary = [jsonData objectForKey:@"data"];
    for (NSDictionary *photoDiction in dataDictionary) {
        if ([[NSString stringWithFormat:@"%@", [photoDiction objectForKey:@"type"]] isEqualToString:@"image"]) {
            RMRPhoto *photo = [[RMRPhoto alloc] init];
            NSDictionary *imagesDiction = [photoDiction objectForKey:@"images"];
            NSDictionary *standardResolutionDiction = [imagesDiction objectForKey:@"standard_resolution"];
            photo.urlString = [standardResolutionDiction objectForKey:@"url"];
            NSDictionary *thumbnailDiction = [imagesDiction objectForKey:@"thumbnail"];
            photo.thumbnailUrlString = [thumbnailDiction objectForKey:@"url"];
            NSDictionary *likesDiction = [photoDiction objectForKey:@"likes"];
            photo.likesCount = [likesDiction objectForKey:@"count"];
            [photoArray addObject:photo];
        }
    }
    return photoArray;
}

@end
