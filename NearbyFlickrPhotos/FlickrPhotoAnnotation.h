//
//  FlickrPhotoAnnotation.h
//  NearbyFlickrPhotos
//
//  Created by Nacho on 31/8/14.
//  Copyright (c) 2014 Ignacio Nieto Carvajal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "RESTManager.h"

@interface FlickrPhotoAnnotation : NSObject <MKAnnotation>

/** Designated intializer. Initializes the annotation with the dictionary values returned from Flickr REST API */
- (id) initWithValuesFromDictionary: (NSDictionary *) dictionary;

@property (nonatomic, strong) UIImage * cachedBigImage;         // cached image, original (big) version
@property (nonatomic, strong) UIImage * cachedThumbnailImage;   // cached image, thumbnail
@property (nonatomic, strong) NSString * imageTitle;            // The name(title) of the Flickr Photo (if any)
@property (nonatomic, strong) NSString * bigImageURL;           // original (big) image data
@property (nonatomic, strong) NSString * thumbnailImageURL;     // thumbnail image data.

@end
