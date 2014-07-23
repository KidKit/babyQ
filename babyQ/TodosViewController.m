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
bool isRefresh = NO;

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
    if (connection == getTodosConnection)
        [todosData appendData:data];
    else if (connection == setTodoCompletedConnection)
    {
        NSString* json_response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSData* json_data = [json_response dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary* setCompletedResponse = [NSJSONSerialization JSONObjectWithData: json_data
                                                     options: NSJSONReadingMutableContainers
                                                       error: nil];
        if ([setCompletedResponse[@"VALID"] isEqualToString:@"Success"])
        {
            [self performSelector:@selector(refreshTodosView) withObject:nil afterDelay:1.0];
        }
    }
}

- (void) refreshTodosView
{
    for (UIView *subview in self.view.subviews) {
        if (subview.tag >= 0)
        {
            [subview removeFromSuperview];
        }
    }
    todosData = [[NSMutableData alloc] init];
    NSString* api_token = [(AppDelegate *)[[UIApplication sharedApplication] delegate] api_token];
    NSString* user_email = [(AppDelegate *)[[UIApplication sharedApplication] delegate] user_email];
    Constants* constants = [[Constants alloc] init];
    NSString* toDosURL = [[constants.HOST stringByAppendingString:constants.VERSION] stringByAppendingString:constants.GET_CURRENT_TODOS_PATH];
    NSString* postData = [[[@"ApiToken=" stringByAppendingString:api_token] stringByAppendingString:@"&Email="] stringByAppendingString:user_email];
    NSMutableURLRequest *toDosRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:toDosURL]];
    [toDosRequest setHTTPMethod:@"POST"];
    [toDosRequest setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    getTodosConnection = [[NSURLConnection alloc] initWithRequest:toDosRequest delegate:self];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
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
                UITextView* nextTodo = [[UITextView alloc] initWithFrame:CGRectMake(54, 120 + 60*(i), 189, 59)];
                nextTodo.backgroundColor = [UIColor clearColor];
                nextTodo.editable = NO;
                nextTodo.userInteractionEnabled = NO;
                nextTodo.font = [UIFont fontWithName:@"MyriadPro-Regular" size:12];
                nextTodo.textColor = [UIColor colorWithRed:120.0/255.0f green:120.0/255.0f blue:120.0/255.0f alpha:1.0f];
                if (todosArray[i][@"Body"] != (id)[NSNull null])
                    nextTodo.text = todosArray[i][@"Body"];
                [self.view addSubview:nextTodo];
                
                UILabel* todoNumber = [[UILabel alloc] initWithFrame:CGRectMake(35, 126 + 60*(i), 18, 18)];
                todoNumber.text = @"\u2022";
                todoNumber.font = [UIFont fontWithName:@"MyriadPro-Regular" size:12];
                todoNumber.textColor = [UIColor colorWithRed:120.0/255.0f green:120.0/255.0f blue:120.0/255.0f alpha:1.0f];
                [self.view addSubview:todoNumber];
                
                UIButton* checkBox = [UIButton buttonWithType:UIButtonTypeCustom];
                checkBox.tag = i;
                [checkBox setFrame:CGRectMake(276, 120+60*(i), 32, 32)];
                [checkBox setBackgroundImage:[UIImage imageNamed:@"babyq_circle.png"] forState:UIControlStateNormal];
                [checkBox addTarget:self action:@selector(markTodoCompleted:) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:checkBox];
                
            }
            NSUInteger numberOfTodos = [todosArray count];
            if (numberOfTodos > 1 && !isRefresh)
            {
                isRefresh = YES;
                [completedTodosButton setFrame:CGRectMake(completedTodosButton.frame.origin.x, completedTodosButton.frame.origin.y +60*(numberOfTodos-1), completedTodosButton.frame.size.width, completedTodosButton.frame.size.height)];
            }
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString* dateString = todosArray[0][@"DueDate"];
            NSDate* date = [dateFormatter dateFromString:dateString];
            [dateFormatter setDateFormat:@"MM.dd.yyyy"];
            todosDueDate.text = [NSString stringWithFormat:@"DUE: %@", [dateFormatter stringFromDate:date]];
        } else {
            todosDueDate.hidden = YES;
            UILabel* todoLabel = [[UILabel alloc] initWithFrame:CGRectMake(36, 126, 240, 24)];
            todoLabel.textAlignment = NSTextAlignmentCenter;
            todoLabel.text = @"All To-Do's Completed";
            todoLabel.textColor = [UIColor colorWithRed:120.0/255.0f green:120.0/255.0f blue:120.0/255.0f alpha:1.0f];
            todoLabel.font = [UIFont fontWithName:@"Bebas" size:17];
            [self.view addSubview:todoLabel];
        }
    }
}

- (IBAction)openSideSwipeView
{
    [(MMDrawerController* )self.navigationController.topViewController openDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (void) markTodoCompleted:(UIButton*)sender
{
    [sender setBackgroundImage:[UIImage imageNamed:@"babyq_circle_orange.png"] forState:UIControlStateNormal];
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
    {
        surveyController.question_number = @"1";
        surveyController.question_type = @"Multiple Choice";
    }
    else
    {
        if (extraQuestionsReached)
        {
            NSString* question_number = [NSString stringWithFormat:@"%lu", [selected_extra_answers count]+1];
            NSString* question_key = [[survey_json[@"ExtraQuestions"] allKeys] objectAtIndex:([question_number intValue]-1)];
            surveyController = [surveyScreens instantiateViewControllerWithIdentifier:@"SurveyQuestion"];
            NSString* type = survey_json[@"ExtraQuestions"][question_key][@"QuestionTypeDescription"];
            surveyController.question_number = question_number;
            surveyController.question_type = type;
        }
        else
        {
            surveyController.question_number = [NSString stringWithFormat:@"%lu", [selected_answers count] + 1];
            surveyController.question_type = @"Multiple Choice";
        }
    }
    [self.navigationController pushViewController:surveyController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
