//
//  CollagePhotoView.h
//  RedMadRobotTestApp
//
//  Created by Екатерина Колесникова on 14.04.15.
//  Copyright (c) 2015 Kolesnikova Ekaterina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMRPhoto.h"

IB_DESIGNABLE @interface CollagePhotoView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UIView *view;

- (void)loadImageWithPhoto:(RMRPhoto *)photo;

@end
