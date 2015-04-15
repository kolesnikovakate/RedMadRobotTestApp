//
//  CollageViewController.m
//  RedMadRobotTestApp
//
//  Created by Екатерина Колесникова on 13.04.15.
//  Copyright (c) 2015 Kolesnikova Ekaterina. All rights reserved.
//

#import "CollageViewController.h"
#import "AFNetworking.h"
#import "UIAlertView+RMRTest.h"
#import "JSONParser.h"
#import "RMRPhoto.h"
#import "NetworkUtilites.h"
#import "CollagePhotoView.h"

@interface CollageViewController () < UIAlertViewDelegate >

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet CollagePhotoView *collageView1;
@property (weak, nonatomic) IBOutlet CollagePhotoView *collageView2;
@property (weak, nonatomic) IBOutlet CollagePhotoView *collageView3;
@property (weak, nonatomic) IBOutlet CollagePhotoView *collageView4;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collageViewWidthConstraint;

@end

@implementation CollageViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;

    [self.activityIndicator startAnimating];
    self.activityIndicator.hidden = NO;

    [NetworkUtilites getUserPhotosWithCompletion:^(NSArray *photos, NSError *error) {
        if (!error) {
            if (photos.count > 0) {
                [self loadPhotos:photos];
                [self.activityIndicator stopAnimating];
                self.activityIndicator.hidden = YES;
            } else {
                [[UIAlertView alertRMRNoPhotoWithDelegate:self] show];
            }
        } else {
            [[UIAlertView alertRMRUnknownError] show];
            [self.activityIndicator stopAnimating];
            self.activityIndicator.hidden = YES;
        }
    }];
}

- (void)viewDidLayoutSubviews
{
    self.collageViewWidthConstraint.constant = MIN(self.view.bounds.size.height, self.view.bounds.size.width) - 20.f;
}

- (void)loadPhotos:(NSArray *)photoArray
{
    if (photoArray.count > 3) {
        [self.collageView1 loadImageWithPhoto:photoArray[0]];
        [self.collageView2 loadImageWithPhoto:photoArray[1]];
        [self.collageView3 loadImageWithPhoto:photoArray[2]];
        [self.collageView4 loadImageWithPhoto:photoArray[3]];
    }
}

#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
