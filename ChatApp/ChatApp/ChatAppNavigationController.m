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
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
        // Being compiled with a Base SDK of iOS 8 or later
        // Now do a runtime check to be sure the method is supported
        if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [self.locationManager requestAlwaysAuthorization];
        } else {
            // No such method on this device - do something else as needed
        }
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.locationManager requestWhenInUseAuthorization];
        } else {
            // No such method on this device - do something else as needed
        }
#else
        // Being compiled with a Base SDK of iOS 7.x or earlier
        // No such method - do something else as needed
#endif
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
