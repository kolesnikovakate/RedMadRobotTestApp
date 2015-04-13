//
//  UIAlertView+RMRTest.m
//  RedMadRobotTestApp
//
//  Created by Екатерина Колесникова on 13.04.15.
//  Copyright (c) 2015 Kolesnikova Ekaterina. All rights reserved.
//

#import "UIAlertView+RMRTest.h"

@implementation UIAlertView (RMRTest)

+ (UIAlertView *)alertRMRNoFindUsers
{
    return [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ATTENTION", @"")
                                      message:NSLocalizedString(@"NO_USERS", @"")
                                     delegate:nil
                            cancelButtonTitle:@"ОК"
                            otherButtonTitles:nil];
}

+ (UIAlertView *)alertRMRUnknownError
{
    return [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ERROR", @"")
                                      message:NSLocalizedString(@"UNKNOWN_ERROR", @"")
                                     delegate:nil
                            cancelButtonTitle:@"ОК"
                            otherButtonTitles:nil];
}

@end
