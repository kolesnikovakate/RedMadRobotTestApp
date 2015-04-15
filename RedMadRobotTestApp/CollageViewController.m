//
//  CollageViewController.m
//  RedMadRobotTestApp
//
//  Created by Екатерина Колесникова on 13.04.15.
//  Copyright (c) 2015 Kolesnikova Ekaterina. All rights reserved.
//

#import "CollageViewController.h"
#import "NetworkUtilites.h"
#import "RMRPhoto.h"
#import "UIView+RMRTest.h"

#import <SVProgressHUD/SVProgressHUD.h>

@interface CollageViewController () < UIAlertViewDelegate >

@property (weak, nonatomic) IBOutlet UIView *mainCollageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet CollagePhotoView *collageView1;
@property (weak, nonatomic) IBOutlet CollagePhotoView *collageView2;
@property (weak, nonatomic) IBOutlet CollagePhotoView *collageView3;
@property (weak, nonatomic) IBOutlet CollagePhotoView *collageView4;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collageViewWidthConstraint;
@property (nonatomic, weak) CollagePhotoView *currentCollageView;

@end

@implementation CollageViewController {
    NSArray *photoArray_;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;

    [self.activityIndicator startAnimating];
    self.activityIndicator.hidden = NO;

    photoArray_ = [[NSArray alloc] init];

    UIBarButtonItem *printButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                                 target:self
                                                                                 action:@selector(sendCollage:)];
    printButton.enabled = NO;
    self.navigationItem.rightBarButtonItem = printButton;

    [SVProgressHUD showWithStatus:NSLocalizedString(@"LOAD", @"") maskType:SVProgressHUDMaskTypeBlack];

    [NetworkUtilites getUserPhotosWithCompletion:^(NSArray *photos, NSError *error) {
        if (!error) {
            if (photos.count > 0) {
                [SVProgressHUD dismiss];
                photoArray_ = photos;
                [self loadStartPhotos];
                [self.activityIndicator stopAnimating];
                self.activityIndicator.hidden = YES;
                self.navigationItem.rightBarButtonItem.enabled = YES;
            } else {
                [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"NO_PHOTO", @"")];
                [self.navigationController popViewControllerAnimated:YES];
            }
            self.collageView1.delegate = self;
            self.collageView2.delegate = self;
            self.collageView3.delegate = self;
            self.collageView4.delegate = self;
        } else {
            [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
            [self.activityIndicator stopAnimating];
            self.activityIndicator.hidden = YES;
        }
    }];
}

- (void)viewDidLayoutSubviews
{
    self.collageViewWidthConstraint.constant = MIN(self.view.bounds.size.height, self.view.bounds.size.width) - 20.f;
}

- (void)loadStartPhotos
{
    if (photoArray_.count > 3) {
        [self.collageView1 loadImageWithPhoto:photoArray_[0]];
        [self.collageView2 loadImageWithPhoto:photoArray_[1]];
        [self.collageView3 loadImageWithPhoto:photoArray_[2]];
        [self.collageView4 loadImageWithPhoto:photoArray_[3]];
    }
}

- (void)onPhotoSelected:(RMRPhoto *)photo
{
    [self.currentCollageView loadImageWithPhoto:photo];
}

- (void)sendCollage:(id)sender {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController* mailVC = [[MFMailComposeViewController alloc] init];
        mailVC.mailComposeDelegate = self;
        [mailVC setSubject:@"Instagram collage"];
        UIImage * photoCollageImage = [self.mainCollageView getCollageImage];
        NSData *imageData = UIImagePNGRepresentation(photoCollageImage);
        [mailVC addAttachmentData:imageData mimeType:@"image/png" fileName:@"photoCollage"];
        [self presentViewController:mailVC animated:YES completion:nil];
    } else {
        NSLog(@"В данный момент отправка невозможна, пожалуйста, проверьте настройки email");
    }
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    if (result == MFMailComposeResultFailed) {
        NSLog(@"Не удалось отправить email");
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - CollagePhotoView Delegate

- (void)tapOnCollageView:(CollagePhotoView *)collagePhotoView
{
    self.currentCollageView = collagePhotoView;

    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.enableGrid = YES;
    browser.displayActionButton = NO;
    browser.displaySelectionButtons = YES;
    browser.startOnGrid = YES;
    [browser setCurrentPhotoIndex:0];
    [self.navigationController pushViewController:browser animated:YES];
}

#pragma mark - MWPhotoBrowser Delegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    return [photoArray_ count];
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    RMRPhoto *photo = photoArray_[index];
    return [MWPhoto photoWithURL:[NSURL URLWithString:photo.urlString]];
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index
{
    RMRPhoto *photo = photoArray_[index];
    return [MWPhoto photoWithURL:[NSURL URLWithString:photo.thumbnailUrlString]];
}

- (BOOL)photoBrowser:(MWPhotoBrowser *)photoBrowser isPhotoSelectedAtIndex:(NSUInteger)index
{
    return NO;
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index selectedChanged:(BOOL)selected
{
    [self.navigationController popViewControllerAnimated:YES];
    [self onPhotoSelected:photoArray_[index]];
}

@end
