//
//  PhotoDetailViewController.m
//  NearbyFlickrPhotos
//
//  Created by Nacho on 31/8/14.
//  Copyright (c) 2014 Ignacio Nieto Carvajal. All rights reserved.
//

#import "PhotoDetailViewController.h"

@interface PhotoDetailViewController ()

// outlets and buttons
@property (nonatomic, weak) IBOutlet UIImageView * backgroundImage;
@property (nonatomic, weak) IBOutlet UIView * textContentView;
@property (nonatomic, weak) IBOutlet UILabel * titleLabel;
@property (nonatomic, weak) IBOutlet UILabel * subtitleLabel;
@property (nonatomic, weak) IBOutlet UIButton * getBackButton;
@property (nonatomic, weak) IBOutlet UIButton * shareButton;

@end

@implementation PhotoDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // fill the photo fields
    if (self.imageToShowInDetail) self.backgroundImage.image = self.imageToShowInDetail;
    if (self.photoTitle) self.titleLabel.text = self.photoTitle;
    else self.photoTitle = @"Unknown title";
    if (CLLocationCoordinate2DIsValid(self.photoCoordinate)) self.subtitleLabel.text = [NSString stringWithFormat:@"Longitude %f, Latitude %f", self.photoCoordinate.longitude, self.photoCoordinate.latitude];
    else self.subtitleLabel.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Button actions

- (IBAction)getBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)sharePhoto:(id)sender {
    if (!self.imageToShowInDetail) return;
    // share photo
    NSString *textToShare = [NSString stringWithFormat:@"%@\nShared by NearbyFlickrPhotos, by Ignacio Nieto Carvajal.", self.photoTitle];
    UIImage *imageToShare = self.imageToShowInDetail;
    NSURL * urlToShare = [NSURL URLWithString:kNearbyFlickrPhotosAuthorURL];
    NSArray *itemsToShare = @[textToShare, imageToShare, urlToShare];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeAddToReadingList, UIActivityTypeSaveToCameraRoll];
    [activityVC setValue: @"I would like to share a Flickr pic with you!" forKey:@"subject"];
    activityVC.completionHandler = ^(NSString *activityType, BOOL completed) {
        if (completed) [self showAlertWithMessage:[NSString stringWithFormat:@"Flickr photo %@ shared", self.photoTitle] isError:NO];
        else [self showAlertWithMessage:[NSString stringWithFormat:@"Flickr Photo %@ was not shared", self.photoTitle] isError:YES];
    };
    [self presentViewController:activityVC animated:YES completion:nil];
    

}

#pragma mark messages and alerts

- (void) showAlertWithMessage: (NSString *) message isError: (BOOL) error {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:error?@"Error":@"Message" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
}


@end
