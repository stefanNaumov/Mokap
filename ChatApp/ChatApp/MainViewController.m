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
    ButtonStyleSetter *btnStyleSetter;
    UIBarButtonItem *logOutBtn;
    
}

static NSString *homeScreenTitle = @"Welcome To ChatApp!";
static NSString *usersTableViewSegue = @"usersTableViewSegue";

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = homeScreenTitle;
    btnStyleSetter = [ButtonStyleSetter sharedSingleton];
    
    navController = [ChatAppNavigationController sharedSingleton];
    
    animationsGenerator = [[HomeScreenAnimationsGenerator alloc] initWithViewController:self];
    
    [self loadButtonStyles];
    [animationsGenerator generateAnimations];
    
    logOutBtn = [[UIBarButtonItem alloc] init];
    logOutBtn.title = @"LogOut";
    self.navigationItem.backBarButtonItem = logOutBtn;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) loadButtonStyles{
    [btnStyleSetter setBackgroundColor:self.signInButton withColorRed:190.0 colorGreen:150.0 colorBLue:117.0 alpha:0.3];
    [btnStyleSetter setBorderWidth:self.signInButton withBorderWith:0.8f];
    [btnStyleSetter setCornerRadius:self.signInButton withRadius:35.0f];
    
    [btnStyleSetter setBackgroundColor:self.signUpButton withColorRed:255.0 colorGreen:153.0 colorBLue:51.0 alpha:0.3];
    [btnStyleSetter setBorderWidth:self.signUpButton withBorderWith:0.8f];
    [btnStyleSetter setCornerRadius:self.signUpButton withRadius:35.0];
}

//action for logging the user and setting user's coordinates from current user position
- (IBAction)logInTouchUp:(id)sender {
    
     userLocation = navController.locationManager.location;
    
    NSString *username = self.userNameInput.text;
    NSString *password = self.passwordInput.text;
    
    //hide keyboard
    [self textFieldShouldReturn:self.userNameInput];
    [self textFieldShouldReturn:self.passwordInput];
    
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
            _passwordInput.text = @"";
        }
    }];
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

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:TRUE];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
@end
