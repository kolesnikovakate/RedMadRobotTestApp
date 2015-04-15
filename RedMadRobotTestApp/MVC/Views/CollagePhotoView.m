//
//  CollagePhotoView.m
//  RedMadRobotTestApp
//
//  Created by Екатерина Колесникова on 14.04.15.
//  Copyright (c) 2015 Kolesnikova Ekaterina. All rights reserved.
//

#import "CollagePhotoView.h"

@implementation CollagePhotoView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [[NSBundle mainBundle] loadNibNamed:@"CollagePhotoView"
                                      owner:self options:nil];
        [self addSubview:self.view];
        self.activityIndicator.hidden = YES;
        self.imageView.hidden = YES;
    }
    return self;
}

- (void)layoutSubviews
{
    CGSize size = self.frame.size;
    CGPoint origin = self.view.frame.origin;
    [self.view setFrame:CGRectMake(origin.x, origin.y, size.width, size.height)];
}

- (IBAction)tapOnView:(UITapGestureRecognizer *)sender
{
    self.imageView.image = nil;
    [self.delegate tapOnCollageView:self];
}

- (void)loadImageWithPhoto:(RMRPhoto *)photo
{
    self.imageView.hidden = NO;
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
    NSURL *url = [NSURL URLWithString:photo.urlString];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.imageView setImage:image];
            self.activityIndicator.hidden = YES;
            [self.activityIndicator stopAnimating];
        });
    });
    
}

@end
