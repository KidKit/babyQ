//
//  TodosViewController.m
//  babyQ
//
//  Created by Chris Wood on 6/17/14.
//  Copyright (c) 2014 babyQ. All rights reserved.
//

#import "TodosViewController.h"

@interface TodosViewController ()

@end

@implementation TodosViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(IBAction) getCompletedTodos
{
    UIViewController* completedTodos = [self.storyboard instantiateViewControllerWithIdentifier:@"CompletedTodosView"];
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
