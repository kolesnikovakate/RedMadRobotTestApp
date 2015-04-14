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

@interface CollageViewController ()

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation CollageViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;

    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:kRMRCurrentUserIdKey];
    NSString *completeRequestUrl = [NSString stringWithFormat:@"https://api.instagram.com/v1/users/%@/media/recent/", userId];
    NSDictionary *parameters = @{@"client_id": kRMRClientId};

    [self.activityIndicator startAnimating];
    self.activityIndicator.hidden = NO;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:completeRequestUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *photoArray = [JSONParser parseAndGetPhotosByJSONdata:responseObject];
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"likesCount" ascending:NO];
        NSArray *sortedArray = [photoArray sortedArrayUsingDescriptors:@[sort]];
        [self loadPhotos:sortedArray];
        [self.activityIndicator stopAnimating];
        self.activityIndicator.hidden = YES;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[UIAlertView alertRMRUnknownError] show];
        [self.activityIndicator stopAnimating];
        self.activityIndicator.hidden = YES;
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

@end
