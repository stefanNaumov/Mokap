//
//  ChatUsers.h
//  ChatApp
//
//  Created by admin on 11/8/14.
//  Copyright (c) 2014 admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ChatUser;

@interface ChatUsers : NSManagedObject

@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) ChatUser *user;

@end
