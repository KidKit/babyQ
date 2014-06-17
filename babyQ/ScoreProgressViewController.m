//
//  ScoreProgressViewController.m
//  babyQ
//
//  Created by Chris Wood on 6/16/14.
//  Copyright (c) 2014 babyQ. All rights reserved.
//

#import "ScoreProgressViewController.h"

@interface ScoreProgressViewController ()

@end

@implementation ScoreProgressViewController

@synthesize scrollView,scoreLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.scrollView setContentSize:CGSizeMake(320, 1200)];
    [self.scrollView setBackgroundColor:[UIColor whiteColor]];
    [scoreLabel setTransform:CGAffineTransformMakeRotation(-M_PI / 2)];
    
    ScoreProgressGraphView* graphView = [[ScoreProgressGraphView alloc] initWithFrame:CGRectMake(52, 84, 248, 184)];
    [graphView setContentSize:CGSizeMake(1200, 184)];
    graphView.scrollEnabled = YES;
    graphView.yValues = @[@0,@10,@20,@10,@20,@50,@75,@40];
    [self.scrollView addSubview:graphView];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
