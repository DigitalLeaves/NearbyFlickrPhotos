//
//  RESTManager.h
//  NearbyFlickrPhotos
//
//  Created by Nacho on 31/8/14.
//  Copyright (c) 2014 Ignacio Nieto Carvajal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import <CoreLocation/CoreLocation.h>

/** Entity in charge of communicating with the REST API of Flickr. Uses the Singleton design pattern. */
@interface RESTManager : NSObject

/** Designated initializer. The singleton instance of RESTManager must be obtained from this method */
+ (RESTManager *) sharedInstance;

/** Loads a remote image from a URL and executes a block */
- (void) loadRemoteImageFromURL: (NSURL *) url andExecuteBlock: ( void (^) (BOOL success, UIImage * image, NSURL * url) ) block;

/** Loads the Flickr photos close to a location (expressed in CLLocationCoordinate) and relative to a radius. */
- (void) loadFlickrImagesFromLocation: (CLLocationCoordinate2D) bottomLeft toLocation: (CLLocationCoordinate2D) topRight andExecuteBlock: ( void (^) (BOOL success, NSArray * entries) ) block;

@end
