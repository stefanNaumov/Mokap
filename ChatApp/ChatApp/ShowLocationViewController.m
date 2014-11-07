//
//  ShowLocationViewController.m
//  ChatApp
//
//  Created by RadvachTsvetkov on 11/7/14.
//  Copyright (c) 2014 RadvachTsvetkov. All rights reserved.
//

#import "ShowLocationViewController.h"

@interface ShowLocationViewController ()

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
    
    [[[UIAlertView alloc] initWithTitle:@"Other username is: " message:[NSString stringWithFormat:@"You chat with: %@", self.otherUser.username] delegate:nil cancelButtonTitle:@"Бегам!" otherButtonTitles:nil, nil] show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
