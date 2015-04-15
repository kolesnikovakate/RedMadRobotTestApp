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

@interface CollageViewController ()

@property (weak, nonatomic) IBOutlet UIView *mainCollageView;
@property (weak, nonatomic) IBOutlet CollagePhotoView *collageView1;
@property (weak, nonatomic) IBOutlet CollagePhotoView *collageView2;
@property (weak, nonatomic) IBOutlet CollagePhotoView *collageView3;
@property (weak, nonatomic) IBOutlet CollagePhotoView *collageView4;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collageViewWidthConstraint;

@end

@implementation CollageViewController {
    NSArray *_photoArray;
    CollagePhotoView *_currentCollageView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    _photoArray = [[NSArray alloc] init];

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
                _photoArray = photos;
                [self loadStartPhotos];
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
        }
    }];
}

- (void)viewDidLayoutSubviews
{
    self.collageViewWidthConstraint.constant = MIN(self.view.bounds.size.height, self.view.bounds.size.width) - 20.f;
}

- (void)loadStartPhotos
{
    if (_photoArray.count > 3) {
        [self.collageView1 loadImageWithPhoto:_photoArray[0]];
        [self.collageView2 loadImageWithPhoto:_photoArray[1]];
        [self.collageView3 loadImageWithPhoto:_photoArray[2]];
        [self.collageView4 loadImageWithPhoto:_photoArray[3]];
    }
}

- (void)selectedPhoto:(RMRPhoto *)photo
{
    [_currentCollageView loadImageWithPhoto:photo];
}

- (void)sendCollage:(id)sender
{
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController* mailVC = [[MFMailComposeViewController alloc] init];
        mailVC.mailComposeDelegate = self;
        [mailVC setSubject:NSLocalizedString(@"TITLE", @"")];
        UIImage * photoCollageImage = [self.mainCollageView getCollageImage];
        NSData *imageData = UIImagePNGRepresentation(photoCollageImage);
        [mailVC addAttachmentData:imageData mimeType:@"image/png" fileName:NSLocalizedString(@"FILE_NAME", @"")];
        [self presentViewController:mailVC animated:YES completion:nil];
    } else {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"CAN_NOT_SEND_EMAIL", @"")];
    }
}

#pragma mark - MFMailComposeViewController Delegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    if (result == MFMailComposeResultFailed) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"ERROR_SEND_EMAIL", @"")];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - CollagePhotoView Delegate

- (void)tapOnCollageView:(CollagePhotoView *)collagePhotoView
{
    _currentCollageView = collagePhotoView;

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
    return [_photoArray count];
}

- (BOOL)photoBrowser:(MWPhotoBrowser *)photoBrowser isPhotoSelectedAtIndex:(NSUInteger)index
{
    return NO;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index
{
    RMRPhoto *photo = _photoArray[index];
    return [MWPhoto photoWithURL:[NSURL URLWithString:photo.thumbnailUrlString]];
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    RMRPhoto *photo = _photoArray[index];
    return [MWPhoto photoWithURL:[NSURL URLWithString:photo.urlString]];
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index selectedChanged:(BOOL)selected
{
    [self.navigationController popViewControllerAnimated:YES];
    [self selectedPhoto:_photoArray[index]];
}

@end
