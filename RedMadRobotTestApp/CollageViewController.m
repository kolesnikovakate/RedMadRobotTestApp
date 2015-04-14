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

@interface CollageViewController () < UIAlertViewDelegate >

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

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

- (void)loadPhotos:(NSArray *)photoArray
{
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    for (RMRPhoto *photo in photoArray) {
        NSOperation *loadImgOp = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(loadImageWithPhoto:) object:photo];
        [queue addOperation:loadImgOp];
    }

}

- (void)loadImageWithPhoto:(RMRPhoto *)photo
{
    NSURL *url = [NSURL URLWithString:photo.thumbnailUrlString];
    UIImage *thumb = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
    //photo.data = UIImageJPEGRepresentation(thumb, 1.0f);
    [self performSelectorOnMainThread:@selector(setImage:) withObject:thumb waitUntilDone:YES];
}

-(void)setImage:(UIImage *)image
{
    self.imageView.image = image;
}

#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
