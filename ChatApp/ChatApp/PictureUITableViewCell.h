//
//  PictureUITableViewCell.h
//  ChatApp
//
//  Created by RadvachTsvetkov on 11/8/14.
//  Copyright (c) 2014 RadvachTsvetkov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PictureUITableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *messageText;
@property (weak, nonatomic) IBOutlet UIImageView *image;

@end
