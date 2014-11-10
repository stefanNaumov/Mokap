//
//  ChatAppNavigationController.h
//  ChatApp
//
//  Created by admin on 11/3/14.
//  Copyright (c) 2014 admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>

@interface ChatAppNavigationController : NSObject<CLLocationManagerDelegate>

@property (nonatomic,strong) CLLocationManager *locationManager;

+(ChatAppNavigationController *)sharedSingleton;

-(CLLocation *) getDidUpdateLocation;

-(void)uploadUserLocation: (PFUser*) user;

@end
