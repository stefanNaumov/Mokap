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
    PFUser *user;
    
}

static NSString *usersTableViewSegue = @"usersTableViewSegue";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
    
    //PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
    //testObject[@"foo"] = @"bar";
    //[testObject saveInBackground];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logInTouchUp:(id)sender {
    user = [PFUser user];
    NSString *username = self.userNameInput.text;
    NSString *password = self.passwordInput.text;
    
    //hide keyboard
    [self.userNameInput resignFirstResponder];
    [self.passwordInput resignFirstResponder];
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error) {
        UIAlertView *loginAlertView;
        if (!error) {
            loginAlertView = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Logged in!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [loginAlertView show];
        }
        else{
            loginAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Login failed!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [loginAlertView show];
        }
    }];
    
    //clear inputs
    self.userNameInput.text = @"";
    self.passwordInput.text = @"";
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        
        [self performSegueWithIdentifier:usersTableViewSegue sender:nil];
    }
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    
    if ([segue.identifier isEqualToString:usersTableViewSegue]) {
        PFQuery *query = [PFUser query];
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
@end
