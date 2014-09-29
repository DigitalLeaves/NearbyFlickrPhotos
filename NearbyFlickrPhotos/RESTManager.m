//
//  RESTManager.m
//  NearbyFlickrPhotos
//
//  Created by Nacho on 31/8/14.
//  Copyright (c) 2014 Ignacio Nieto Carvajal. All rights reserved.
//

#import "RESTManager.h"

#define kNearbyFlickrPhotosFlickrAPIKey                 @"f6ff7588191919b583b40832241da001"
#define kNearbyFlickrPhotosFlickrBaseRESTURL            @"https://api.flickr.com/services/rest/?method="
#define kNearbyFlickrPhotosFlickrSearchMethod           @"flickr.photos.search"
#define kNearbyFlickrPhotosFlickrJSONFormat             @"format=json"
#define kNearbyFlickrPhotosFlickrApiKeyParameter        @"api_key"
#define kNearbyFlickrPhotosFlickrLatitudeParameter      @"lat="
#define kNearbyFlickrPhotosFlickrLongitudeParameter     @"lon="
#define kNearbyFlickrPhotosFlickrBoundingBoxParameter   @"bbox"
#define kNearbyFlickrPhotosFlickrExtras                 @"extras=geo,url_t,url_o,url_m" // geo data, thumbnail URL, original image URL
#define kNearbyFlickrPhotosRadiusParameter              @"radius="
#define kNearbyFlickrPhotosRadiusUnitParameter          @"radius_units=km" // radius unit in KM (default).
#define kNearbyFlickrPhotosFlickrNoJSONCallback         @"nojsoncallback=1" // to avoid Flickr wrapping response JSON in non-standard JSON
#define kNearbyFlickrPhotosFlickrPerPageParameter       @"per_page="
#define kNearbyFlickrPhotosMaxPhotosToRetrieve          100 // max number of photos to retrieve from the Flickr REST API
#define kNearbyFlickrPhotosResponseParamPhotos          @"photos"
#define kNearbyFlickrPhotosResponseParamPhoto           @"photo"


@implementation RESTManager

/** Designated initializer. The singleton instance of RESTManager must be obtained from this method */
+ (RESTManager *) sharedInstance
{
    static dispatch_once_t pred = 0;
    __strong static RESTManager * _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

#pragma mark Flickr API methods

/** Loads the Flickr photos close to a location (expressed in CLLocationCoordinate) and relative to a radius. */
- (void) loadFlickrImagesFromLocation: (CLLocationCoordinate2D) bottomLeft toLocation: (CLLocationCoordinate2D) topRight andExecuteBlock: ( void (^) (BOOL success, NSArray * entries) ) block {
    // build the request, baseURL and parameters
    NSString * baseURL = [self buildFlickrSearchURLFromLocation:bottomLeft toLocation:topRight];
    AFHTTPRequestOperationManager * manager = [[AFHTTPRequestOperationManager alloc] init];
    
    // execute the request
    NSLog(@"Requesting flickr photos: %@", baseURL);
    [manager GET:baseURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Response from Flickr: %@", responseObject);
        // analyze results
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) { // analyze response looking for the photos array
            NSDictionary * responseDict = (NSDictionary *) responseObject;
            NSDictionary * photosDict = responseDict[kNearbyFlickrPhotosResponseParamPhotos];
            if (photosDict && ([photosDict isKindOfClass:[NSDictionary class]])) {
                NSArray * photoArray = photosDict[kNearbyFlickrPhotosResponseParamPhoto];
                if (photoArray && ([photoArray isKindOfClass:[NSArray class]])) {
                    block(YES, photoArray);
                } else block(NO, nil);
            } else block(NO, nil);
        } else block(NO, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) { // invalid request.
        NSLog(@"Error loading images from flickr: %@", error.localizedDescription);
        block(NO, nil);
    }];
}

#pragma mark loading remote images methods

/** Loads a remote image from a URL and executes a block */
- (void) loadRemoteImageFromURL: (NSURL *) url andExecuteBlock: ( void (^) (BOOL success, UIImage * image, NSURL * url) ) block {
    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
    requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        block(YES, responseObject, url);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(NO, nil, url);
    }];
    [requestOperation start];
}

#pragma mark utility methods

/** Builds the Flickr REST API request URL for a search given a coordinate and a radius */
- (NSString *) buildFlickrSearchURLFromLocation: (CLLocationCoordinate2D) bottomLeft toLocation: (CLLocationCoordinate2D) topRight {
    return [NSString stringWithFormat:@"%@%@&%@&%@=%@&%@=%f,%f,%f,%f&%@&%@%d&%@",
            kNearbyFlickrPhotosFlickrBaseRESTURL,
            kNearbyFlickrPhotosFlickrSearchMethod,
            kNearbyFlickrPhotosFlickrJSONFormat,
            kNearbyFlickrPhotosFlickrApiKeyParameter,kNearbyFlickrPhotosFlickrAPIKey,
            kNearbyFlickrPhotosFlickrBoundingBoxParameter, bottomLeft.longitude, bottomLeft.latitude, topRight.longitude, topRight.latitude,
            kNearbyFlickrPhotosFlickrExtras,
            kNearbyFlickrPhotosFlickrPerPageParameter, kNearbyFlickrPhotosMaxPhotosToRetrieve,
            kNearbyFlickrPhotosFlickrNoJSONCallback];
}

@end
