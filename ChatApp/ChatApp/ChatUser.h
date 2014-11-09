//
//  ChatUser.h
//  ChatApp
//
//  Created by admin on 11/8/14.
//  Copyright (c) 2014 admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ChatUsers;

@interface ChatUser : NSManagedObject

@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSSet *chatUsers;
@end

@interface ChatUser (CoreDataGeneratedAccessors)

- (void)addChatUsersObject:(ChatUsers *)value;
- (void)removeChatUsersObject:(ChatUsers *)value;
- (void)addChatUsers:(NSSet *)values;
- (void)removeChatUsers:(NSSet *)values;

@end
