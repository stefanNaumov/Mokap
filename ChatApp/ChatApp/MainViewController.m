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

    HomeScreenAnimationsGenerator *animationsGenerator;
    ChatAppNavigationController *navController;
    CLLocation *userLocation;
}

static NSString *usersTableViewSegue = @"usersTableViewSegue";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    navController = [ChatAppNavigationController sharedSingleton];
    
    animationsGenerator = [[HomeScreenAnimationsGenerator alloc] initWithViewController:self];
    [animationsGenerator generateAnimations];
    
    [self setButtonStyles];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) updateViewConstraints{
    [super updateViewConstraints];
}
//action for logging the user and setting user's coordinates from current user position
- (IBAction)logInTouchUp:(id)sender {
    
     userLocation = navController.locationManager.location;
    
    NSString *username = self.userNameInput.text;
    NSString *password = self.passwordInput.text;
    
    //hide keyboard
    [self.userNameInput resignFirstResponder];
    [self.passwordInput resignFirstResponder];
    
    //[navController]
    PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLocation:userLocation];
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error) {
        UIAlertView *loginAlertView;
        if (!error) {
            user[@"location"] = geoPoint;
            //NSLog(@"%@",geoPoint);
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

-(void) setButtonStyles{
    
    self.signInButton.layer.borderWidth = 0.8f;
    self.signInButton.layer.cornerRadius = 35.0f;
    self.signInButton.layer.backgroundColor = [UIColor colorWithRed:190.0/255.0 green:150.0/255.0 blue:117/255.0 alpha:0.3].CGColor;
    
    self.signUpButton.layer.borderWidth = 0.8f;
    self.signUpButton.layer.cornerRadius = 35.0f;
    self.signUpButton.layer.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:153.0/255.0 blue:51/255.0 alpha:0.3].CGColor;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:TRUE];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
@end
