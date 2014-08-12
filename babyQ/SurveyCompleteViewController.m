//
//  SurveyCompleteViewController.m
//  babyQ
//
//  Created by Chris Wood on 8/5/14.
//  Copyright (c) 2014 babyQ. All rights reserved.
//

#import "SurveyCompleteViewController.h"
#import "HomePageNavigationController.h"

@interface SurveyCompleteViewController ()

@end

@implementation SurveyCompleteViewController

@synthesize surveyCompleteHeader,thankYouMessage,okButton,presentingSurvey;

- (void)viewDidLoad
{
    [super viewDidLoad];
    surveyCompleteHeader.font = [UIFont fontWithName:@"Bebas" size:19];
    okButton.titleLabel.font = [UIFont fontWithName:@"MyriadPro-Bold" size:19];
    thankYouMessage.font = [UIFont fontWithName:@"MyriadPro-Regular" size:16];
}

-(IBAction)okPressed
{
    HomePageNavigationController* nav = (HomePageNavigationController*) self.presentingViewController;
    [nav dismissViewControllerAnimated:YES completion:nil];
    nav.view.userInteractionEnabled = YES;
    [presentingSurvey submitSurvey];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
