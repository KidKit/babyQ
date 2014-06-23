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
    
    NSString* api_token = [(AppDelegate *)[[UIApplication sharedApplication] delegate] api_token];
    NSString* user_email = [(AppDelegate *)[[UIApplication sharedApplication] delegate] user_email];
    Constants* constants = [[Constants alloc] init];
    NSString* getCurrentScoreURL = [[constants.HOST stringByAppendingString:constants.VERSION] stringByAppendingString:constants.GET_SCORE_HISTORY_PATH];
    NSString* postData = [[[@"ApiToken=" stringByAppendingString:api_token] stringByAppendingString:@"&Email="] stringByAppendingString:user_email];
    NSMutableURLRequest *currentScoreRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:getCurrentScoreURL]];
    [currentScoreRequest setHTTPMethod:@"POST"];
    [currentScoreRequest setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLConnection* conn = [[NSURLConnection alloc] initWithRequest:currentScoreRequest delegate:self];
    
    dailyTipView.hidden = YES;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data
{
    NSLog(@"received data current score");
    NSMutableArray* pastScores = [[NSMutableArray alloc] init];
    NSString* json_response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSData* json_data = [json_response dataUsingEncoding:NSUTF8StringEncoding];
    NSArray* json_array = [NSJSONSerialization JSONObjectWithData: json_data
                                                                        options: NSJSONReadingMutableContainers
                                                                          error: nil];
    
    for (int i = 0; i < [json_array count]; i++)
    {
        [pastScores addObject:json_array[i][@"OverallScore"]];
    }
    
    ScoreProgressGraphView* graphView = [[ScoreProgressGraphView alloc] initWithFrame:CGRectMake(52, 84, 248, 184)];
    [graphView setContentSize:CGSizeMake(1200, 184)];
    graphView.scrollEnabled = YES;
    graphView.yValues = pastScores;
    [self.scrollView addSubview:graphView];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"ERROR current");
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"finished loading current score");
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
    self.navigationController.navigationBarHidden = YES;
}

-(IBAction) getCompletedTodos
{
    UIStoryboard* todosStoryboard = [UIStoryboard storyboardWithName:@"Todos" bundle:nil];
    UIViewController* completedTodos = [todosStoryboard instantiateViewControllerWithIdentifier:@"CompletedTodosView"];
    [self.navigationController pushViewController:completedTodos animated:YES];
    self.navigationController.navigationBarHidden = YES;
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
