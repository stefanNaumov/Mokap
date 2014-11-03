//
//  ChatAppNavigationController.m
//  ChatApp
//
//  Created by admin on 11/3/14.
//  Copyright (c) 2014 admin. All rights reserved.
//

#import "ChatAppNavigationController.h"



@implementation ChatAppNavigationController{
    
    CLLocation *location;
}

@synthesize locationManager;

-(id)init{
    self = [super init];
    if (self) {
        locationManager = [[CLLocationManager alloc] init];
        [locationManager requestWhenInUseAuthorization];
        [locationManager requestAlwaysAuthorization];
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        [locationManager startUpdatingLocation];
    }
    
    return self;
}

+(ChatAppNavigationController *)sharedSingleton{
    static ChatAppNavigationController *sharedSingleton;
    if (!sharedSingleton) {
        @synchronized(sharedSingleton){
            sharedSingleton = [ChatAppNavigationController new];
        }
    }
    
    return sharedSingleton;
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    CLLocation *lastLocation = [locations lastObject];
    
    location = lastLocation;
    
   // NSLog(@"%@",location);
}

-(CLLocation *) getDidUpdateLocation{
    return location;
}
@end
