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

@synthesize todosArray,todosData,completedTodosButton,todosDueDate;

NSURLConnection* getTodosConnection;
NSURLConnection* setTodoCompletedConnection;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    todosData = [[NSMutableData alloc] init];
    
    
    NSString* api_token = [(AppDelegate *)[[UIApplication sharedApplication] delegate] api_token];
    NSString* user_email = [(AppDelegate *)[[UIApplication sharedApplication] delegate] user_email];
    Constants* constants = [[Constants alloc] init];
    NSString* todosURL = [[constants.HOST stringByAppendingString:constants.VERSION] stringByAppendingString:constants.GET_CURRENT_TODOS_PATH];
    NSString* postData = [[[@"ApiToken=" stringByAppendingString:api_token] stringByAppendingString:@"&Email="] stringByAppendingString:user_email];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:todosURL]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    getTodosConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    // Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data
{
    NSLog(@"received data todos");
    if (connection == getTodosConnection)
        [todosData appendData:data];
    else if (connection == setTodoCompletedConnection)
    {
        NSString* json_response = [[NSString alloc] initWithData:todosData encoding:NSUTF8StringEncoding];
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
    NSLog(@"ERROR todos");
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (connection == getTodosConnection)
    {
        NSString* json_response = [[NSString alloc] initWithData:todosData encoding:NSUTF8StringEncoding];
        
        if ([json_response rangeOfString:@"ERROR"].location == NSNotFound)
        {
            NSData* json_data = [json_response dataUsingEncoding:NSUTF8StringEncoding];
            
            todosArray = [NSJSONSerialization JSONObjectWithData: json_data
                                                         options: NSJSONReadingMutableContainers
                                                           error: nil];
            for (int i = 0; i < [todosArray count]; i++)
            {
                UITextView* nextTodo = [[UITextView alloc] initWithFrame:CGRectMake(54, 118 + 65*(i), 189, 59)];
                nextTodo.backgroundColor = [UIColor clearColor];
                nextTodo.editable = NO;
                nextTodo.userInteractionEnabled = NO;
                nextTodo.font = [UIFont fontWithName:@"MyriadPro-Semibold" size:12];
                nextTodo.text = todosArray[i][@"Body"];
                [self.view addSubview:nextTodo];
                
                UILabel* todoNumber = [[UILabel alloc] initWithFrame:CGRectMake(35, 126 + 65*(i), 18, 18)];
                todoNumber.text = [NSString stringWithFormat:@"%d.", i+1];
                todoNumber.font = [UIFont fontWithName:@"MyriadPro-Regular" size:12];
                [self.view addSubview:todoNumber];
                
                UIButton* checkBox = [UIButton buttonWithType:UIButtonTypeCustom];
                checkBox.tag = i;
                [checkBox setFrame:CGRectMake(276, 134+65*(i), 16, 16)];
                [checkBox setBackgroundImage:[UIImage imageNamed:@"babyq_circle.png"] forState:UIControlStateNormal];
                [checkBox addTarget:self action:@selector(markTodoCompleted:) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:checkBox];
                
            }
            NSUInteger numberOfTodos = [todosArray count];
            if (numberOfTodos > 1)
            {
                [completedTodosButton setFrame:CGRectMake(completedTodosButton.frame.origin.x, completedTodosButton.frame.origin.y +65*(numberOfTodos-1), completedTodosButton.frame.size.width, completedTodosButton.frame.size.height)];
            }
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString* dateString = todosArray[0][@"DueDate"];
            NSDate* date = [dateFormatter dateFromString:dateString];
            [dateFormatter setDateFormat:@"MM.dd.yyyy"];
            todosDueDate.text = [NSString stringWithFormat:@"DUE %@", [dateFormatter stringFromDate:date]];
        } else {
            todosDueDate.hidden = YES;
            UILabel* todoLabel = [[UILabel alloc] initWithFrame:CGRectMake(36, 126, 240, 24)];
            todoLabel.textAlignment = NSTextAlignmentCenter;
            todoLabel.text = @"All To-Dos Completed.";
            todoLabel.font = [UIFont fontWithName:@"Bebas" size:17];
            [self.view addSubview:todoLabel];
        }
    }
    NSLog(@"finished loading todos");
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

    for (UIView *subview in self.view.subviews) {
        if ([subview isKindOfClass:[UIButton class]])
        {
            UIButton* button = (UIButton*) subview;
            if (button.tag >= 0)
                [button setBackgroundImage:[UIImage imageNamed:@"babyq_circle.png"] forState:UIControlStateNormal];
        }
    }
    [sender setBackgroundImage:[UIImage imageNamed:@"babyq_circle_orange.png"] forState:UIControlStateNormal];
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
