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

@synthesize scrollView,todosView,dailyTipView,dailyTip,completedTodosButton,todosArray;

NSURLConnection* currentScoreConnection;
NSURLConnection* dailyTipConnection;
NSURLConnection* toDosConnection;
NSURLConnection* setTodoCompletedConnection;

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.scrollView setContentSize:CGSizeMake(320, 1500)];
    [self.scrollView setBackgroundColor:[UIColor whiteColor]];
    dailyTipView.hidden = YES;
    
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE, MMM dd"];
    self.todaysDate.text = [dateFormatter stringFromDate:now];
    
    NSString* api_token = [(AppDelegate *)[[UIApplication sharedApplication] delegate] api_token];
    NSString* user_email = [(AppDelegate *)[[UIApplication sharedApplication] delegate] user_email];
    Constants* constants = [[Constants alloc] init];
    NSString* getCurrentScoreURL = [[constants.HOST stringByAppendingString:constants.VERSION] stringByAppendingString:constants.GET_CURRENT_SCORE_PATH];
    NSString* postData = [[[@"ApiToken=" stringByAppendingString:api_token] stringByAppendingString:@"&Email="] stringByAppendingString:user_email];
    NSMutableURLRequest *currentScoreRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:getCurrentScoreURL]];
    [currentScoreRequest setHTTPMethod:@"POST"];
    [currentScoreRequest setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    currentScoreConnection = [[NSURLConnection alloc] initWithRequest:currentScoreRequest delegate:self];
    
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
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data
{
    if (connection == currentScoreConnection)
    {
        NSLog(@"received data current score");
        NSString* json_response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSData* json_data = [json_response dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary* json_dictionary = [NSJSONSerialization JSONObjectWithData: json_data
                                                                        options: NSJSONReadingMutableContainers
                                                                          error: nil];
        if (true /*[json_dictionary[@"VALID"] isEqualToString:@"Success"]*/)
        {
            self.totalScoreBig.text = json_dictionary[@"OverallScore"];
            self.totalScoreSmall.text = json_dictionary[@"OverallScore"];
            self.lifestyleScore.text = json_dictionary[@"LifestyleScore"];
            self.exerciseScore.text = json_dictionary[@"ExerciseScore"];
            self.nutritionScore.text = json_dictionary[@"StressScore"];
            self.stressScore.text = json_dictionary[@"StressScore"];
            self.workBlurb.text = json_dictionary[@"OverallMessage"];
            int delta = [json_dictionary[@"OverallDelta"] intValue];
            if (delta >= 0)
                self.delta.text = [@"+" stringByAppendingString:[NSString stringWithFormat:@"%@", json_dictionary[@"OverallDelta"]]];
            else
                self.delta.text = [NSString stringWithFormat:@"%d",delta];
        }
    } else if (connection ==  dailyTipConnection)
    {
        NSLog(@"received data daily tip");
        NSString* json_response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSData* json_data = [json_response dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary* json_dictionary = [NSJSONSerialization JSONObjectWithData: json_data
                                                                        options: NSJSONReadingMutableContainers
                                                                          error: nil];
        dailyTip.text = json_dictionary[@"Body"];
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
            
        }
    }
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

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"ERROR current");
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"finished loading current score");
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
    self.navigationController.navigationBarHidden = YES;
}

-(IBAction) getTipHistory
{
    UIStoryboard* todosStoryboard = [UIStoryboard storyboardWithName:@"Todos" bundle:nil];
    UIViewController* completedTodos = [todosStoryboard instantiateViewControllerWithIdentifier:@"TipHistoryView"];
    [self.navigationController pushViewController:completedTodos animated:YES];
    self.navigationController.navigationBarHidden = YES;
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
