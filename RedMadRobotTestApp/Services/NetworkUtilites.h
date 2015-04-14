//
//  NetworkUtilites.h
//  RedMadRobotTestApp
//
//  Created by Екатерина Колесникова on 14.04.15.
//  Copyright (c) 2015 Kolesnikova Ekaterina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RMRUser.h"

typedef void (^RMRRequrestUserCompletionBlock)(RMRUser *user, NSError *error);
typedef void (^RMRRequrestUserPermissionsCompletionBlock)(BOOL result, NSError *error);

@interface NetworkUtilites : NSObject

+ (void)getUserWithUserName:(NSString *)username completion:(RMRRequrestUserCompletionBlock)completion;
+ (void)checkUserPermissionsWithUserId:(NSNumber *)userId completion:(RMRRequrestUserPermissionsCompletionBlock)completion;

@end
