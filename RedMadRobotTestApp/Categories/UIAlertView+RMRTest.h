//
//  UIAlertView+RMRTest.h
//  RedMadRobotTestApp
//
//  Created by Екатерина Колесникова on 13.04.15.
//  Copyright (c) 2015 Kolesnikova Ekaterina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (RMRTest)

+ (UIAlertView *)alertRMRNoFindUsers;
+ (UIAlertView *)alertRMRUnknownError;
+ (UIAlertView *)alertRMRPermissionDenied;
+ (UIAlertView *)alertRMRNoPhotoWithDelegate:(id)delegate;

@end
