//
//  ChatSessionViewController.h
//  ChatApp
//
//  Created by admin on 11/4/14.
//  Copyright (c) 2014 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "MessageBalloonUITableViewCell.h"
#import "ShowLocationViewController.h"
#import "CoreDataHelper.h"
#import "ChatUser.h"

@interface ChatSessionViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic) NSMutableArray *messages;

@property (nonatomic) PFUser *loggedUser;

@property (nonatomic) PFUser *otherUser;

@end
