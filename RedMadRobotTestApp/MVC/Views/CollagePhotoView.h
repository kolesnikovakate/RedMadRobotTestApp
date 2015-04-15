//
//  CollagePhotoView.h
//  RedMadRobotTestApp
//
//  Created by Екатерина Колесникова on 14.04.15.
//  Copyright (c) 2015 Kolesnikova Ekaterina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMRPhoto.h"

@class CollagePhotoView;

@protocol CollagePhotoViewDelegate < NSObject >
- (void)tapOnCollageView:(CollagePhotoView *)collagePhotoView;
@end

IB_DESIGNABLE @interface CollagePhotoView : UIView

@property (nonatomic, weak) id < CollagePhotoViewDelegate > delegate;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UIView *view;

- (IBAction)tapOnView:(UITapGestureRecognizer *)sender;

- (void)loadImageWithPhoto:(RMRPhoto *)photo;

@end
