//
//  StopSurveyViewController.m
//  babyQ
//
//  Created by Chris Wood on 8/5/14.
//  Copyright (c) 2014 babyQ. All rights reserved.
//

#import "StopSurveyViewController.h"

@interface StopSurveyViewController ()

@end

@implementation StopSurveyViewController

@synthesize message,yesButton,noButton,presentingSurvey;

- (void)viewDidLoad
{
    [super viewDidLoad];
    yesButton.titleLabel.font = [UIFont fontWithName:@"MyriadPro-Bold" size:18];
    noButton.titleLabel.font = [UIFont fontWithName:@"MyriadPro-Regular" size:18];
    message.font = [UIFont fontWithName:@"MyriadPro-Regular" size:15];
    // Do any additional setup after loading the view.
}

-(IBAction)yesPressed
{
    HomePageNavigationController* nav = (HomePageNavigationController*) self.presentingViewController;
    [nav dismissViewControllerAnimated:YES completion:nil];
    nav.view.userInteractionEnabled = YES;
    [presentingSurvey stopSurvey];
}

-(IBAction)noPressed
{
    HomePageNavigationController* nav = (HomePageNavigationController*) self.presentingViewController;
    [nav dismissViewControllerAnimated:YES completion:nil];
    nav.view.userInteractionEnabled = YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
