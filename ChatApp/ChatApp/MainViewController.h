//
//  ViewController.h
//  ChatApp
//
//  Created by RadvachTsvetkov on 10/30/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "UsersTableViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "ChatAppNavigationController.h"
#import "HomeScreenAnimationsGenerator.h"
#import "ButtonStyleSetter.h"

@interface MainViewController : UIViewController<UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userNameInput;
@property (weak, nonatomic) IBOutlet UITextField *passwordInput;
- (IBAction)logInTouchUp:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;

@end
