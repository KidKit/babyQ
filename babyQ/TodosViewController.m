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

@interface NSString (stringByDecodingURLFormat)
- (NSString *)stringByDecodingURLFormat;
@end

@implementation NSString (stringByDecodingURLFormat)
- (NSString *)stringByDecodingURLFormat
{
    NSString *result = [(NSString *)self stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    result = [result stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return result;
}
@end

@implementation TodosViewController

@synthesize todosArray,todosData,completedTodosButton,todosDueDate,headerButton1,headerButton2,offlineMessage;

UIActivityIndicatorView *spinner;
NSURLConnection* getTodosConnection;
NSURLConnection* setTodoCompletedConnection;
bool isRefresh = NO;
BOOL internet;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self testInternetConnection];
    
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.center = CGPointMake(160, 240);
    spinner.hidesWhenStopped = YES;
    [self.view addSubview:spinner];
    [spinner startAnimating];
    
    headerButton1.imageEdgeInsets = UIEdgeInsetsMake(12, 12, 12, 12);
    headerButton2.imageEdgeInsets = UIEdgeInsetsMake(12, 12, 12, 12);
    
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

- (void) viewWillDisappear:(BOOL)animated
{
    isRefresh = NO;
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
                UITextView* nextTodo = [[UITextView alloc] initWithFrame:CGRectMake(40, 120 + 60*(i), 210, 52)];
                nextTodo.backgroundColor = [UIColor clearColor];
                nextTodo.editable = NO;
                nextTodo.userInteractionEnabled = YES;
                nextTodo.font = [UIFont fontWithName:@"MyriadPro-Regular" size:15];
                nextTodo.textColor = [UIColor colorWithRed:120.0/255.0f green:120.0/255.0f blue:120.0/255.0f alpha:1.0f];
                if (todosArray[i][@"Body"] != (id)[NSNull null])
                    nextTodo.text = [todosArray[i][@"Body"] stringByDecodingURLFormat];
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                               initWithTarget:self
                                               action:@selector(markTodoCompleted:)];
                
                [nextTodo addGestureRecognizer:tap];
                nextTodo.tag = i;
                [self.view addSubview:nextTodo];
                
                UILabel* todoNumber = [[UILabel alloc] initWithFrame:CGRectMake(35, 126 + 60*(i), 18, 18)];
                todoNumber.text = @"\u2022";
                todoNumber.font = [UIFont fontWithName:@"MyriadPro-Regular" size:15];
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
            NSCalendar *gregorian = [[NSCalendar alloc]
                                     initWithCalendarIdentifier:NSGregorianCalendar];
            NSDateComponents *comps = [gregorian components: NSDayCalendarUnit
                                                   fromDate: [NSDate date]
                                                     toDate: date
                                                    options: 0];
            int days = (int) [comps day];
            todosDueDate.text = [NSString stringWithFormat:@"DUE: %i days from now", days];
        } else {
            todosDueDate.hidden = YES;
            UILabel* todoLabel = [[UILabel alloc] initWithFrame:CGRectMake(36, 126, 240, 72)];
            todoLabel.textAlignment = NSTextAlignmentCenter;
            todoLabel.numberOfLines = 3;
            todoLabel.text = @"Congratulations!\nYou've just completed your recommended list of to-do's";
            todoLabel.textColor = [UIColor colorWithRed:120.0/255.0f green:120.0/255.0f blue:120.0/255.0f alpha:1.0f];
            todoLabel.font = [UIFont fontWithName:@"MyriadPro-Bold" size:18];
            [self.view addSubview:todoLabel];
        }
        [spinner stopAnimating];
    }
}

- (IBAction)openSideSwipeView
{
    [(MMDrawerController* )self.navigationController.topViewController openDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (void) markTodoCompleted:(UITapGestureRecognizer*)sender
{
    UIView* touchedView;
    if (![sender isKindOfClass:[UIButton class]])
        touchedView = sender.view;
    else
        touchedView = (UIView*)sender;
    for (UIView* view in [self.view subviews])
    {
        if ([view isKindOfClass:[UIButton class]] && view.tag == touchedView.tag)
            [(UIButton*)view setBackgroundImage:[UIImage imageNamed:@"babyq_circle_orange.png"] forState:UIControlStateNormal];
        
    }
    NSString* api_token = [(AppDelegate *)[[UIApplication sharedApplication] delegate] api_token];
    NSString* user_email = [(AppDelegate *)[[UIApplication sharedApplication] delegate] user_email];
    Constants* constants = [[Constants alloc] init];
    NSString* todosURL = [[constants.HOST stringByAppendingString:constants.VERSION] stringByAppendingString:constants.SET_TODO_COMPLETED_PATH];
    NSString* postData = [[[@"ApiToken=" stringByAppendingString:api_token] stringByAppendingString:@"&Email="] stringByAppendingString:user_email];
    postData = [[postData stringByAppendingString:@"&ToDoId="] stringByAppendingString:todosArray[touchedView.tag][@"ToDoId"] ];
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
        NSString* question_number = [NSString stringWithFormat:@"%lu", [selected_answers count]+1];
        NSString* question_key = [[survey_json[@"Questions"] allKeys] objectAtIndex:([question_number intValue]-1)];
        NSString* type = survey_json[@"Questions"][question_key][@"QuestionTypeDescription"];
        surveyController.question_number = [NSString stringWithFormat:@"%lu", [selected_answers count] + 1];
        surveyController.question_type = type;
    }
    
    [self.navigationController pushViewController:surveyController animated:YES];
}

- (void)testInternetConnection
{
    Reachability* internetReachableFoo = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    // Internet is reachable
    internetReachableFoo.reachableBlock = ^(Reachability*reach)
    {
        internet = YES;
        offlineMessage.hidden = YES;
        headerButton2.enabled = YES;
        completedTodosButton.enabled = YES;
    };
    
    // Internet is not reachable
    internetReachableFoo.unreachableBlock = ^(Reachability*reach)
    {
        internet = NO;
        offlineMessage.hidden = NO;
        headerButton2.enabled = NO;
        completedTodosButton.enabled = NO;
    };
    
    [internetReachableFoo startNotifier];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
