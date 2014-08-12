//
//  GetScoreViewController.m
//  babyQ
//
//  Created by Chris Wood on 7/2/14.
//  Copyright (c) 2014 babyQ. All rights reserved.
//

#import "GetScoreViewController.h"

@interface GetScoreViewController ()

@end

@implementation GetScoreViewController

@synthesize updateBlurb;

- (void)viewDidLoad
{
    [super viewDidLoad];
    updateBlurb.font = [UIFont fontWithName:@"MyriadPro-Regular" size:12];
}

- (IBAction)updateScore
{
    UIStoryboard* surveyScreens = [UIStoryboard storyboardWithName:@"Survey" bundle:nil];
    SurveyViewController* surveyController = [surveyScreens instantiateInitialViewController];
    if (survey_json == nil)
        surveyController.question_number = @"1";
    else
        surveyController.question_number = [NSString stringWithFormat:@"%lu", [selected_answers count] + 1];
    HomePageNavigationController* nav = (HomePageNavigationController*) self.presentingViewController;
    [nav dismissViewControllerAnimated:NO completion:nil];
    [nav pushViewController:surveyController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
