//
//  Message.h
//  ChatApp
//
//  Created by RadvachTsvetkov on 11/8/14.
//  Copyright (c) 2014 RadvachTsvetkov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface Message : PFObject<PFSubclassing>

+ (NSString *)parseClassName;

@property (retain) NSString *displayName;

@end
