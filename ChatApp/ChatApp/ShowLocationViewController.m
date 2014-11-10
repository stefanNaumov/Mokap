//
//  ShowLocationViewController.m
//  ChatApp
//
//  Created by RadvachTsvetkov on 11/7/14.
//  Copyright (c) 2014 RadvachTsvetkov. All rights reserved.
//

#import "ShowLocationViewController.h"

@interface ShowLocationViewController (){

    PFGeoPoint *location;
    MKCoordinateRegion region;
    MKPointAnnotation *annotation;
    ChatAppNavigationController *navController;
    CLLocation *userLocation;
    NSTimer *timer;
}
@end

@implementation ShowLocationViewController

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
    // Do any additional setup after loading the view.
    
    location = self.otherUser[@"location"];
    
    CLLocationCoordinate2D coord;
    coord.longitude = location.longitude;
    coord.latitude = location.latitude;
    
    annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = coord;
    annotation.title = self.otherUser.username;
    
    region.center.longitude = location.longitude;
    region.center.latitude = location.latitude;
    region.span.longitudeDelta = 0.005;
    region.span.latitudeDelta = 0.005;
    
    [self.mapView setCenterCoordinate:coord animated:YES];
    [self.mapView setRegion:region];
    [self.mapView addAnnotation:annotation];
    
}

-(void)refreshUserLocation{
    userLocation = navController.locationManager.location;
    PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLocation:userLocation];
    
    self.loggedUser[@"location"] = geoPoint;
    [self.loggedUser saveEventually];
    NSLog(@"ShowLocation - refreshUserLocation");
}

-(void)callSelector:(SEL)selector Every: (double) second{
    timer = [NSTimer scheduledTimerWithTimeInterval:second target:self selector:selector userInfo:nil repeats:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    SEL refreshUserLocationSelector = @selector(refreshUserLocation);
    [self callSelector:refreshUserLocationSelector Every:5.0];
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (timer.isValid) {
        [timer invalidate];
    }
    timer = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
