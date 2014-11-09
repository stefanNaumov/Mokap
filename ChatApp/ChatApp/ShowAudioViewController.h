//
//  ShowAudioViewController.h
//  ChatApp
//
//  Created by RadvachTsvetkov on 11/9/14.
//  Copyright (c) 2014 RadvachTsvetkov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "Message.h"

@interface ShowAudioViewController : UIViewController

@property (nonatomic) Message *message;

@end
