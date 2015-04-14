//
//  RMRPhoto.h
//  RedMadRobotTestApp
//
//  Created by Екатерина Колесникова on 13.04.15.
//  Copyright (c) 2015 Kolesnikova Ekaterina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RMRPhoto : NSObject

@property (nonatomic, strong) NSNumber *likesCount;
@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, strong) NSString *thumbnailUrlString;
@property (nonatomic, strong) NSData *data;

@end
