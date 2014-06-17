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

- (void) viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
}

- (IBAction)startSurvey:(id)sender
{
    UIStoryboard* surveyScreens = [UIStoryboard storyboardWithName:@"Survey" bundle:nil];
    SurveyViewController* surveyController = [surveyScreens instantiateInitialViewController];
    [self.navigationController pushViewController:surveyController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

@implementation UILabel (CustomFontLabel)

-(void)awakeFromNib{
    float size = [self.font pointSize];
    self.font = [UIFont fontWithName:@"Bebas" size:size];
}

@end

@implementation UITextView (CustomFontLabel)

-(void)awakeFromNib{
    float size = [self.font pointSize];
    self.font = [UIFont fontWithName:@"MyriadPro-Regular" size:size];
}

@end
