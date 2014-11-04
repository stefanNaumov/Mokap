//
//  ChatSessionViewController.h
//  ChatApp
//
//  Created by admin on 11/4/14.
//  Copyright (c) 2014 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ChatSessionViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic) NSMutableArray *messages;

@property (nonatomic) PFUser *loggedUser;

@property (nonatomic) PFUser *otherUser;

@end
