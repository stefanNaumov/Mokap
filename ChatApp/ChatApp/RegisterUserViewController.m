//
//  RegisterUserViewController.m
//  ChatApp
//
//  Created by admin on 11/1/14.
//  Copyright (c) 2014 admin. All rights reserved.
//

#import "RegisterUserViewController.h"

@interface RegisterUserViewController ()

@end

static NSString *usersTableViewSegue = @"usersTableViewSegue";

@implementation RegisterUserViewController{
    PFUser *user;
    UserDataInputValidator *validator;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    validator = [[UserDataInputValidator alloc] init];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signUpTouchUp:(id)sender {
    UIAlertView *alertView;
    NSString *username = self.userNameInput.text;
    NSString *password = self.passwordInput.text;
    NSString *verifiedPassword = self.verifyPasswordInput.text;
    
    //hide keyboard
    [self.userNameInput resignFirstResponder];
    [self.passwordInput resignFirstResponder];
    [self.verifyPasswordInput resignFirstResponder];
    
    if (![validator validateUserName:username]) {
        alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Username must be between 1 and 40 symbols" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView show];
    }
    else if(![validator validatePassword:password]){
        alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Password must be between 5 and 30 symbols" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView show];
    }
    else if(![validator verifyPassword:password withPassword:verifiedPassword]){
        alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Verified password is incorrect!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView show];
    }
    else{
        
        user = [PFUser user];
        user.username = username;
        user.password = password;
        
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            UIAlertView *registerAlertView;
            if (!error) {
                registerAlertView = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Registration succesfull!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                
                [registerAlertView show];
            }
            else{
                registerAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Username is used by another user!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [registerAlertView show];
            }
        }];
        
        //clear inputs
        self.userNameInput.text = @"";
        self.passwordInput.text = @"";
        self.verifyPasswordInput.text = @"";
        
        
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self performSegueWithIdentifier:usersTableViewSegue sender:self];
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

//hide keyboard when user clicks somewhere on the screen
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:TRUE];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
