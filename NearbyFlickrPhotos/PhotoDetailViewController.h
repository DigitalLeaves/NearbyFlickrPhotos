//
//  PhotoDetailViewController.h
//  NearbyFlickrPhotos
//
//  Created by Nacho on 31/8/14.
//  Copyright (c) 2014 Ignacio Nieto Carvajal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface PhotoDetailViewController : UIViewController

@property (nonatomic, strong) UIImage * imageToShowInDetail;
@property (nonatomic, strong) NSString * photoTitle;
@property (nonatomic) CLLocationCoordinate2D photoCoordinate;


@end
