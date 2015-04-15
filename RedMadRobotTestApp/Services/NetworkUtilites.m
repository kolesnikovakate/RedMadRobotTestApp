//
//  NetworkUtilites.m
//  RedMadRobotTestApp
//
//  Created by Екатерина Колесникова on 14.04.15.
//  Copyright (c) 2015 Kolesnikova Ekaterina. All rights reserved.
//

#import "NetworkUtilites.h"
#import "AFNetworking.h"
#import "JSONParser.h"
#import "NSDictionary+InstagramRequest.h"

@implementation NetworkUtilites

+ (void)getUserWithUserName:(NSString *)username completion:(RMRRequrestUserCompletionBlock)completion
{
    NSString *completeRequestUrl = @"https://api.instagram.com/v1/users/search/";
    NSDictionary *parameters = @{@"q": username,
                                 @"client_id": kRMRClientId};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:completeRequestUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completion) {
            NSNumber *userId = [JSONParser parseJSONdata:responseObject andFindUserIdByUsername:username];
            if (userId != nil) {
                RMRUser *user = [[RMRUser alloc] init];
                user.username = username;
                user.idx = userId;

                completion(user, nil);
            } else {
                completion(nil, nil);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
             completion(nil, error);
        }
    }];
}

+ (void)checkUserPermissionsWintCompletion:(RMRRequrestUserPermissionsCompletionBlock)completion
{
    NSNumber *userId = [[NSUserDefaults standardUserDefaults] objectForKey:kRMRCurrentUserIdKey];
    NSString *completeRequestUrl = [NSString stringWithFormat:@"https://api.instagram.com/v1/users/%@/", userId];;
    NSDictionary *parameters = [NSDictionary requestParamsDictionaryWithDictionary:nil];
  //@{@"client_id": kRMRClientId};

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:completeRequestUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completion) {
            completion(YES, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion(NO, error);
        }
    }];
}

+ (void)getUserPhotosWithCompletion:(RMRRequrestUserPhotosCompletionBlock)completion
{
    [self getUserPhotosMediaWithLPhotos:[NSMutableArray new] maxID:nil maxMediaCount:kRMRMaxMediaCount completion:completion];
}

+ (void)getUserPhotosMediaWithLPhotos:(NSMutableArray *)photos
                                maxID:(NSString *)maxID
                        maxMediaCount:(NSInteger)maxMediaCount
                           completion:(RMRRequrestUserPhotosCompletionBlock)completion {
    NSDictionary *parameters = [NSDictionary requestParamsDictionaryWithDictionary:(maxID ? @{@"max_id" : maxID} : nil )];
//    if (maxID) {
//        params = @{@"max_id" : maxID,
//                   @"client_id": kRMRClientId};
//    } else {
//        params = @{@"client_id": kRMRClientId};
//    }

    NSNumber *userId = [[NSUserDefaults standardUserDefaults] objectForKey:kRMRCurrentUserIdKey];
    NSString *completeRequestUrl = [NSString stringWithFormat:@"https://api.instagram.com/v1/users/%@/media/recent/", userId];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:completeRequestUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *newPhotoArray = [JSONParser parseAndGetPhotosByJSONdata:responseObject];
        NSString *newMaxID = responseObject[@"pagination"][@"next_max_id"];
        [photos addObjectsFromArray:newPhotoArray];
        if ([photos count] >= maxMediaCount || [newMaxID length] == 0) {
            if (completion) {
                completion([photos sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"likesCount" ascending:NO]]], nil);
            }
        } else {
            [self getUserPhotosMediaWithLPhotos:photos maxID:newMaxID maxMediaCount:maxMediaCount completion:completion];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion(nil, error);
        }
    }];
}

@end
