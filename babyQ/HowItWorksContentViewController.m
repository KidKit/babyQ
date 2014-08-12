//
//  HowItWorksContentViewController.m
//  babyQ
//
//  Created by Chris Wood on 6/16/14.
//  Copyright (c) 2014 babyQ. All rights reserved.
//

#import "HowItWorksContentViewController.h"

@interface HowItWorksContentViewController ()

@end

@implementation HowItWorksContentViewController

@synthesize avatarImageView, titleLabel, pageTextView, pageIndex, titleText, pageText, imageFile;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    avatarImageView.image = [UIImage imageNamed:imageFile];
    titleLabel.text = titleText;
    titleLabel.font = [UIFont fontWithName:@"Bebas" size:19];
    pageTextView.text = pageText;
    pageTextView.font = [UIFont fontWithName:@"MyriadPro-Regular" size:15];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
