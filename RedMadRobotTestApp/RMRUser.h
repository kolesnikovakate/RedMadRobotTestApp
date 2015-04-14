//
//  RMRUser.h
//  RedMadRobotTestApp
//
//  Created by Екатерина Колесникова on 14.04.15.
//  Copyright (c) 2015 Kolesnikova Ekaterina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RMRUser : NSObject

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSURL *photoURL;
@property (nonatomic, strong) NSNumber *idx;

@end
