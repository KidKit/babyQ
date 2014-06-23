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

@synthesize todosArray,todosData,completedTodosButton;

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
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (conn)
    {
        
    }
    // Do any additional setup after loading the view.
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data
{
    NSLog(@"received data todos");
    [todosData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"ERROR todos");
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString* json_response = [[NSString alloc] initWithData:todosData encoding:NSUTF8StringEncoding];
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
        nextTodo.text = todosArray[i][@"Body"];
        [self.view addSubview:nextTodo];
        
        UILabel* answerChoice = [[UILabel alloc] initWithFrame:CGRectMake(35, 126 + 65*(i), 18, 18)];
        answerChoice.text = [NSString stringWithFormat:@"%d.", i+1];
        answerChoice.font = [UIFont fontWithName:@"Bebas" size:12];
        [self.view addSubview:answerChoice];
        
        UIButton* checkBox = [UIButton buttonWithType:UIButtonTypeCustom];
        checkBox.tag = i;
        [checkBox setFrame:CGRectMake(276, 134+65*(i), 16, 16)];
        [checkBox setBackgroundImage:[UIImage imageNamed:@"babyq_circle.png"] forState:UIControlStateNormal];
        [checkBox addTarget:self action:@selector(clickedAnswer:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:checkBox];
        
    }
    NSUInteger numberOfTodos = [todosArray count];
    if (numberOfTodos > 1)
    {
        [completedTodosButton setFrame:CGRectMake(completedTodosButton.frame.origin.x, completedTodosButton.frame.origin.y +65*(numberOfTodos-1), completedTodosButton.frame.size.width, completedTodosButton.frame.size.height)];
    }
    NSLog(@"finished loading todos");
}

- (void) clickedAnswer:(UIButton*)sender
{
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
    surveyController.question_number = @"1";
    [self.navigationController pushViewController:surveyController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
