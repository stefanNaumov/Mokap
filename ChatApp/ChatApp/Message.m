//
//  Message.m
//  ChatApp
//
//  Created by RadvachTsvetkov on 11/8/14.
//  Copyright (c) 2014 RadvachTsvetkov. All rights reserved.
//

#import "Message.h"
// Import this header to let Message know that PFObject privately provides most
// of the methods for PFSubclassing.
#import <Parse/PFObject+Subclass.h>

@implementation Message

@dynamic displayName;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Message";
}

@end
