//
//  CurrentScoreViewController.m
//  babyQ
//
//  Created by Chris Wood on 6/11/14.
//  Copyright (c) 2014 babyQ. All rights reserved.
//

#import "CurrentScoreViewController.h"

@interface CurrentScoreViewController ()

@end

@implementation CurrentScoreViewController

@synthesize scrollView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.scrollView setContentSize:CGSizeMake(320, 1500)];
    [self.scrollView setBackgroundColor:[UIColor whiteColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
