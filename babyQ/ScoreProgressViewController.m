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

@synthesize scrollView,scoreLabel,todosView,dailyTipView;

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
    
    dailyTipView.hidden = YES;
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

-(IBAction) getTipHistory
{
    UIStoryboard* todosStoryboard = [UIStoryboard storyboardWithName:@"Todos" bundle:nil];
    UIViewController* completedTodos = [todosStoryboard instantiateViewControllerWithIdentifier:@"TipHistoryView"];
    [self.navigationController pushViewController:completedTodos animated:YES];
}

-(IBAction) getCompletedTodos
{
    UIStoryboard* todosStoryboard = [UIStoryboard storyboardWithName:@"Todos" bundle:nil];
    UIViewController* completedTodos = [todosStoryboard instantiateViewControllerWithIdentifier:@"CompletedTodosView"];
    [self.navigationController pushViewController:completedTodos animated:YES];
}

- (IBAction)startSurvey
{
    UIStoryboard* surveyScreens = [UIStoryboard storyboardWithName:@"Survey" bundle:nil];
    SurveyViewController* surveyController = [surveyScreens instantiateInitialViewController];
    surveyController.question_number = @"1";
    [self.navigationController pushViewController:surveyController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
