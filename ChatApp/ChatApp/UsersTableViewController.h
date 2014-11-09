//
//  UsersTableViewController.h
//  ChatApp
//
//  Created by admin on 11/2/14.
//  Copyright (c) 2014 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "ChatSessionViewController.h"
#import "CoreDataHelper.h"
#import "ChatUser.h"
#import "ChatUsers.h"

@interface UsersTableViewController : UITableViewController<UIGestureRecognizerDelegate>

@property (nonatomic) NSArray *users;
- (IBAction)swipeFilterUsers:(UIGestureRecognizer *)sender;


@end
