//
//  CollagePhotoView.m
//  RedMadRobotTestApp
//
//  Created by Екатерина Колесникова on 14.04.15.
//  Copyright (c) 2015 Kolesnikova Ekaterina. All rights reserved.
//

#import "CollagePhotoView.h"

@implementation CollagePhotoView

//- (void)encodeWithCoder:(NSCoder *)encoder
//{
//    [encoder encodeObject:self.imageView forKey:@"imageView"];
//    [encoder encodeObject:self.activityIndicator forKey:@"activityIndicator"];
//}
//
//- (id)initWithCoder:(NSCoder *)decoder
//{
//    self = [super init];
//    if( self != nil )
//    {
//        self.imageView = [decoder decodeObjectForKey:@"imageView"];
//        self.activityIndicator = [decoder decodeObjectForKey:@"activityIndicator"];
//    }
//    return self;
//}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [[NSBundle mainBundle] loadNibNamed:@"CollagePhotoView"
                                      owner:self options:nil];

        [self addSubview:self.view];
        self.activityIndicator.hidden = YES;
        self.imageView.hidden = YES;
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {

    }
    return self;
}

-(void)layoutSubviews
{
    CGSize size = self.frame.size;
    CGPoint origin = self.view.frame.origin;
    [self.view setFrame:CGRectMake(origin.x, origin.y, size.width, size.height)];
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
