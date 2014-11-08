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
#import "PictureUITableViewCell.h"
#import "ShowLocationViewController.h"
<<<<<<< Updated upstream
#import "CoreDataHelper.h"
#import "ChatUser.h"
=======
#import "ShowPictureViewController.h"
#import "Message.h"
>>>>>>> Stashed changes

@interface ChatSessionViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic) NSMutableArray *messages;

@property (nonatomic) PFUser *loggedUser;

@property (nonatomic) PFUser *otherUser;

@end
