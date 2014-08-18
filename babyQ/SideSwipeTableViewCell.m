//
//  SideSwipeTableCellTableViewCell.m
//  babyQ
//
//  Created by Chris Wood on 6/11/14.
//  Copyright (c) 2014 babyQ. All rights reserved.
//

#import "SideSwipeTableViewCell.h"

@implementation SideSwipeTableViewCell

@synthesize textLabel;

- (void) layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(20,8,24,23);
    if ([self.textLabel.text isEqualToString:@"My Profile"])
        self.imageView.frame = CGRectMake(18,10,28,20);
}

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
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
