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

+ (void)checkUserPermissionsWithUserId:(NSNumber *)userId completion:(RMRRequrestUserPermissionsCompletionBlock)completion
{
    NSString *completeRequestUrl = [NSString stringWithFormat:@"https://api.instagram.com/v1/users/%@/", userId];;
    NSDictionary *parameters = @{@"client_id": kRMRClientId};

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

@end
