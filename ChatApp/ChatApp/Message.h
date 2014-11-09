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

@property (retain) NSString *TextMessage;
@property (retain) NSString *User1;
@property (retain) NSString *User2;
@property BOOL HasPicture;
@property BOOL HasAudio;
@property (retain) PFFile *Picture;
@property (retain) PFFile *Audio;

@end
