//
//  RegisterUserViewController.h
//  ChatApp
//
//  Created by admin on 11/1/14.
//  Copyright (c) 2014 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface RegisterUserViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *userNameInput;

@property (weak, nonatomic) IBOutlet UITextField *passwordInput;

@property (weak, nonatomic) IBOutlet UITextField *verifyPasswordInput;

- (IBAction)signUpTouchUp:(id)sender;

@end
