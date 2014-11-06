//
//  MessageBalloonUITableViewCell.m
//  ChatApp
//
//  Created by RadvachTsvetkov on 11/5/14.
//  Copyright (c) 2014 RadvachTsvetkov. All rights reserved.
//

#import "MessageBalloonUITableViewCell.h"

@implementation MessageBalloonUITableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code   self.contentView.frame = self.bounds;
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
