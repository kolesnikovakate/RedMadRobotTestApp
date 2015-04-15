//
//  UIView+RMRTest.m
//  RedMadRobotTestApp
//
//  Created by Екатерина Колесникова on 15.04.15.
//  Copyright (c) 2015 Kolesnikova Ekaterina. All rights reserved.
//

#import "UIView+RMRTest.h"

@implementation UIView (RMRTest)

- (UIImage *)getCollageImage
{
//    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0f);
//    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:NO];
//    UIImage * snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return snapshotImage;

//    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0.0);
//    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
//
//    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
//
//    UIGraphicsEndImageContext();
//
//    return img;

    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0.0f);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:NO];
    UIImage * snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snapshotImage;
}

@end
