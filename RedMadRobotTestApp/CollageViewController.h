//
//  CollageViewController.h
//  RedMadRobotTestApp
//
//  Created by Екатерина Колесникова on 13.04.15.
//  Copyright (c) 2015 Kolesnikova Ekaterina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollagePhotoView.h"
#import <MWPhotoBrowser/MWPhotoBrowser.h>

@interface CollageViewController : UIViewController < CollagePhotoViewDelegate, MWPhotoBrowserDelegate >

@end
