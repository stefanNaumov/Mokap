//
//  ViewController.m
//  ChatApp
//
//  Created by RadvachTsvetkov on 10/30/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController{

    CLLocationManager *locationManager;
    CLLocation *userLocation;
}

static NSString *usersTableViewSegue = @"usersTableViewSegue";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    locationManager = [[CLLocationManager alloc] init];
    [locationManager requestWhenInUseAuthorization];
    [locationManager requestAlwaysAuthorization];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [locationManager startUpdatingLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//action for logging the user and setting user's coordinates from current user position
- (IBAction)logInTouchUp:(id)sender {

    NSString *username = self.userNameInput.text;
    NSString *password = self.passwordInput.text;
    
    //hide keyboard
    [self.userNameInput resignFirstResponder];
    [self.passwordInput resignFirstResponder];
    
    PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLocation:userLocation];
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error) {
        UIAlertView *loginAlertView;
        if (!error) {
            user[@"location"] = geoPoint;
            [user saveEventually];
            
            loginAlertView = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Logged in!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [loginAlertView show];
        }
        else{
            loginAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Username or password incorrect!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [loginAlertView show];
        }
    }];
    
    //clear inputs
    self.userNameInput.text = @"";
    self.passwordInput.text = @"";
}

//respond UIAlert view cancel button click by triggerring the usersTableViewSegue
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        
        [self performSegueWithIdentifier:usersTableViewSegue sender:nil];
    }
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:usersTableViewSegue]) {
        PFQuery *query = [PFUser query];
        PFUser *currentUser = [PFUser currentUser];
        
        [query whereKey:@"username" notEqualTo:[currentUser username]];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                UsersTableViewController *controller = [segue destinationViewController];
                [controller setUsers:objects];
                [controller.tableView reloadData];
            }
            else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Could not connect to server!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
            }
            
        }];
    }
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    CLLocation *lastLocation = [locations lastObject];
    
    userLocation = lastLocation;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:TRUE];
}
@end
