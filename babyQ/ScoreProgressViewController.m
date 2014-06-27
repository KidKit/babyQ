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

@synthesize scrollView,scoreLabel,todosView,dailyTipView,scoreHistoryData,scoreHistoryArray,todosArray,completedTodosButton,dailyTip,totalScoreBig,lifestyleScore,nutritionScore,exerciseScore,stressScore,scoreDate,dailyTipDate,todosDueDate;

NSURLConnection* getScoreHistoryConnection;
NSURLConnection* toDosConnection;
NSURLConnection* dailyTipConnection;
NSURLConnection* setTodoCompletedConnection;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.scrollView setContentSize:CGSizeMake(320, 1200)];
    [self.scrollView setBackgroundColor:[UIColor whiteColor]];
    [scoreLabel setTransform:CGAffineTransformMakeRotation(-M_PI / 2)];
    
    scoreHistoryData = [[NSMutableData alloc] init];
    
    NSString* api_token = [(AppDelegate *)[[UIApplication sharedApplication] delegate] api_token];
    NSString* user_email = [(AppDelegate *)[[UIApplication sharedApplication] delegate] user_email];
    Constants* constants = [[Constants alloc] init];
    NSString* getCurrentScoreURL = [[constants.HOST stringByAppendingString:constants.VERSION] stringByAppendingString:constants.GET_SCORE_HISTORY_PATH];
    NSString* postData = [[[@"ApiToken=" stringByAppendingString:api_token] stringByAppendingString:@"&Email="] stringByAppendingString:user_email];
    NSMutableURLRequest *currentScoreRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:getCurrentScoreURL]];
    [currentScoreRequest setHTTPMethod:@"POST"];
    [currentScoreRequest setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    getScoreHistoryConnection = [[NSURLConnection alloc] initWithRequest:currentScoreRequest delegate:self];
    
    NSString* dailyTipURL = [[constants.HOST stringByAppendingString:constants.VERSION] stringByAppendingString:constants.GET_DAILY_TIP_PATH];
    NSMutableURLRequest *dailyTipRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:dailyTipURL]];
    [dailyTipRequest setHTTPMethod:@"POST"];
    [dailyTipRequest setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    dailyTipConnection = [[NSURLConnection alloc] initWithRequest:dailyTipRequest delegate:self];
    
    NSString* toDosURL = [[constants.HOST stringByAppendingString:constants.VERSION] stringByAppendingString:constants.GET_CURRENT_TODOS_PATH];
    NSMutableURLRequest *toDosRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:toDosURL]];
    [toDosRequest setHTTPMethod:@"POST"];
    [toDosRequest setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    toDosConnection = [[NSURLConnection alloc] initWithRequest:toDosRequest delegate:self];
    
    dailyTipView.hidden = YES;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data
{
    NSLog(@"received data current score");
    if (connection == getScoreHistoryConnection)
    {
        [scoreHistoryData appendData:data];
    } else if (connection == dailyTipConnection)
    {
        NSLog(@"received data daily tip");
        NSString* json_response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSData* json_data = [json_response dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary* json_dictionary = [NSJSONSerialization JSONObjectWithData: json_data
                                                                        options: NSJSONReadingMutableContainers
                                                                          error: nil];
        dailyTip.text = json_dictionary[@"Body"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString* dateString = json_dictionary[@"ReceivedDate"];
        NSDate* date = [dateFormatter dateFromString:dateString];
        [dateFormatter setDateFormat:@"MM.dd.yyyy"];
        dailyTipDate.text = [dateFormatter stringFromDate:date];
        
    } else if (connection == toDosConnection)
    {
        NSString* json_response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if ([json_response rangeOfString:@"ERROR"].location == NSNotFound)
        {
            NSData* json_data = [json_response dataUsingEncoding:NSUTF8StringEncoding];
            
            todosArray = [NSJSONSerialization JSONObjectWithData: json_data
                                                         options: NSJSONReadingMutableContainers
                                                           error: nil];
            for (int i = 0; i < [todosArray count]; i++)
            {
                UITextView* nextTodo = [[UITextView alloc] initWithFrame:CGRectMake(37, 39 + 65*(i), 189, 54)];
                nextTodo.backgroundColor = [UIColor clearColor];
                nextTodo.editable = NO;
                nextTodo.userInteractionEnabled = NO;
                nextTodo.text = todosArray[i][@"Body"];
                [self.todosView addSubview:nextTodo];
                
                UILabel* answerChoice = [[UILabel alloc] initWithFrame:CGRectMake(18, 48 + 65*(i), 18, 18)];
                answerChoice.text = [NSString stringWithFormat:@"%d.", i+1];
                answerChoice.font = [UIFont fontWithName:@"Bebas" size:12];
                [self.todosView addSubview:answerChoice];
                
                UIButton* checkBox = [UIButton buttonWithType:UIButtonTypeCustom];
                checkBox.tag = i;
                [checkBox setFrame:CGRectMake(247, 50+65*(i), 16, 16)];
                [checkBox setBackgroundImage:[UIImage imageNamed:@"babyq_circle.png"] forState:UIControlStateNormal];
                [checkBox addTarget:self action:@selector(markTodoCompleted:) forControlEvents:UIControlEventTouchUpInside];
                [self.todosView addSubview:checkBox];
                
            }
            NSUInteger numberOfTodos = [todosArray count];
            if (numberOfTodos > 4)
            {
                [self.scrollView setContentSize:CGSizeMake(320, 1500+(numberOfTodos-4))];
                [self.todosView setFrame:CGRectMake(todosView.frame.origin.x, todosView.frame.origin.y, todosView.frame.size.width, todosView.frame.size.height+65*(numberOfTodos-4))];
                [completedTodosButton setFrame:CGRectMake(completedTodosButton.frame.origin.x, completedTodosButton.frame.origin.y +65*(numberOfTodos-4), completedTodosButton.frame.size.width, completedTodosButton.frame.size.height)];
            }
        } else {
            todosDueDate.hidden = YES;
            UILabel* todoLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 39, 240, 24)];
            todoLabel.textAlignment = NSTextAlignmentCenter;
            todoLabel.text = @"All To-Dos Completed.";
            todoLabel.font = [UIFont fontWithName:@"Bebas" size:17];
            [self.todosView addSubview:todoLabel];
        }
    } else if (connection == setTodoCompletedConnection)
    {
        NSString* json_response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSData* json_data = [json_response dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary* setCompletedResponse = [NSJSONSerialization JSONObjectWithData: json_data
                                                                             options: NSJSONReadingMutableContainers
                                                                               error: nil];
        if ([setCompletedResponse[@"VALID"] isEqualToString:@"Success"])
        {
            NSString* title = @"TO-DO COMPLETED!";
            NSString* message = @"Congrats! You've just taken another step closer to improving your babyQ. Keep it up!";
            NSString* buttonTitle = @"OKAY, I GOT IT!";
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:buttonTitle otherButtonTitles:nil];
            alert.tag = 0;
            [alert dismissWithClickedButtonIndex:0 animated:YES];
            [alert show];
        }
    }
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"ERROR current");
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (connection == getScoreHistoryConnection)
    {
        NSMutableArray* pastScores = [[NSMutableArray alloc] init];
        NSString* json_response = [[NSString alloc] initWithData:scoreHistoryData encoding:NSUTF8StringEncoding];
        NSData* json_data = [json_response dataUsingEncoding:NSUTF8StringEncoding];
        scoreHistoryArray = [NSJSONSerialization JSONObjectWithData: json_data
                                                              options: NSJSONReadingMutableContainers
                                                                error: nil];
        
        for (int i = 0; i < [scoreHistoryArray count]; i++)
        {
            [pastScores addObject:scoreHistoryArray[i][@"OverallScore"]];
        }
        
        ScoreProgressGraphView* graphView = [[ScoreProgressGraphView alloc] initWithFrame:CGRectMake(52, 84, 248, 184)];
        [graphView setContentSize:CGSizeMake(1200, 184)];
        graphView.scrollEnabled = YES;
        graphView.yValues = pastScores;
        [graphView calc_info];
        for (int i = 0; i < [graphView.circles count]; i++)
        {
            UIButton* pastScore = graphView.circles[i];
            [pastScore addTarget:self action:@selector(clickedPastScore:) forControlEvents:UIControlEventTouchUpInside];
            [graphView addSubview:pastScore];
        }
        [self clickedPastScore:graphView.circles[[graphView.circles count] -1]];
        [self.scrollView addSubview:graphView];
        
    }
    NSLog(@"finished loading current score");
}

- (void) clickedPastScore:(UIButton*)sender
{
    totalScoreBig.text = scoreHistoryArray[sender.tag][@"OverallScore"];
    lifestyleScore.text = scoreHistoryArray[sender.tag][@"LifestyleScore"];
    exerciseScore.text = scoreHistoryArray[sender.tag][@"ExerciseScore"];
    nutritionScore.text = scoreHistoryArray[sender.tag][@"StressScore"];
    stressScore.text = scoreHistoryArray[sender.tag][@"StressScore"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* dateString = scoreHistoryArray[sender.tag][@"SurveyFinished"];
    NSDate* date = [dateFormatter dateFromString:dateString];
    [dateFormatter setDateFormat:@"MM.dd.yyyy"];
    scoreDate.text = [dateFormatter stringFromDate:date];
}

- (void) markTodoCompleted:(UIButton*)sender
{
    NSString* api_token = [(AppDelegate *)[[UIApplication sharedApplication] delegate] api_token];
    NSString* user_email = [(AppDelegate *)[[UIApplication sharedApplication] delegate] user_email];
    Constants* constants = [[Constants alloc] init];
    NSString* todosURL = [[constants.HOST stringByAppendingString:constants.VERSION] stringByAppendingString:constants.SET_TODO_COMPLETED_PATH];
    NSString* postData = [[[@"ApiToken=" stringByAppendingString:api_token] stringByAppendingString:@"&Email="] stringByAppendingString:user_email];
    postData = [[postData stringByAppendingString:@"&ToDoId="] stringByAppendingString:todosArray[sender.tag][@"ToDoId"] ];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:todosURL]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    setTodoCompletedConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    for (UIView *subview in self.scrollView.subviews) {
        if ([subview isKindOfClass:[UIButton class]])
        {
            UIButton* button = (UIButton*) subview;
            if (button.tag >= 0)
                [button setBackgroundImage:[UIImage imageNamed:@"babyq_circle.png"] forState:UIControlStateNormal];
        }
    }
    [sender setBackgroundImage:[UIImage imageNamed:@"babyq_circle_orange.png"] forState:UIControlStateNormal];
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
    if (survey_json == nil)
        surveyController.question_number = @"1";
    else
        surveyController.question_number = [NSString stringWithFormat:@"%lu", [selected_answers count] + 1];
    [self.navigationController pushViewController:surveyController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
