//
//  CurrentScoreViewController.m
//  babyQ
//
//  Created by Chris Wood on 6/11/14.
//  Copyright (c) 2014 babyQ. All rights reserved.
//

#import "CurrentScoreViewController.h"
#import "Constants.h"

@interface CurrentScoreViewController ()

@end

@implementation CurrentScoreViewController

@synthesize scrollView,todosView,dailyTipView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.scrollView setContentSize:CGSizeMake(320, 1500)];
    [self.scrollView setBackgroundColor:[UIColor whiteColor]];
    dailyTipView.hidden = YES;
}

- (void) viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
}

- (IBAction)startSurvey
{
    UIStoryboard* surveyScreens = [UIStoryboard storyboardWithName:@"Survey" bundle:nil];
    SurveyViewController* surveyController = [surveyScreens instantiateInitialViewController];
    surveyController.question_number = @"1";
    [self.navigationController pushViewController:surveyController animated:YES];
}

-(IBAction) getCompletedTodos
{
    UIStoryboard* todosStoryboard = [UIStoryboard storyboardWithName:@"Todos" bundle:nil];
    UIViewController* completedTodos = [todosStoryboard instantiateViewControllerWithIdentifier:@"CompletedTodosView"];
    [self.navigationController pushViewController:completedTodos animated:YES];
}

-(IBAction) getTipHistory
{
    UIStoryboard* todosStoryboard = [UIStoryboard storyboardWithName:@"Todos" bundle:nil];
    UIViewController* completedTodos = [todosStoryboard instantiateViewControllerWithIdentifier:@"TipHistoryView"];
    [self.navigationController pushViewController:completedTodos animated:YES];
}

- (IBAction)toggleTodosAndDaily:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
    
    if (selectedSegment == 0) {
        //toggle the correct view to be visible
        [todosView setHidden:NO];
        [dailyTipView setHidden:YES];
    }
    else{
        //toggle the correct view to be visible
        [todosView setHidden:YES];
        [dailyTipView setHidden:NO];
    }
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
