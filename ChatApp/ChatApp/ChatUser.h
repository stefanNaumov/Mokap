//
//  ChatUser.h
//  ChatApp
//
//  Created by admin on 11/8/14.
//  Copyright (c) 2014 admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ChatUser;

@interface ChatUser : NSManagedObject

@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSSet *chatters;
@end

@interface ChatUser (CoreDataGeneratedAccessors)

- (void)addChattersObject:(ChatUser *)value;
- (void)removeChattersObject:(ChatUser *)value;
- (void)addChatters:(NSSet *)values;
- (void)removeChatters:(NSSet *)values;

@end
