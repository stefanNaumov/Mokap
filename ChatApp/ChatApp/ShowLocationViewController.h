//
//  ShowLocationViewController.h
//  ChatApp
//
//  Created by RadvachTsvetkov on 11/7/14.
//  Copyright (c) 2014 RadvachTsvetkov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ChatAppNavigationController.h"

@interface ShowLocationViewController : UIViewController<MKMapViewDelegate>

@property (nonatomic) PFUser *loggedUser;
@property (nonatomic) PFUser *otherUser;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
