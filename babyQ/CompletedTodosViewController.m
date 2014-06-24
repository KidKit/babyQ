//
//  CompletedTodosViewController.m
//  babyQ
//
//  Created by Chris Wood on 6/17/14.
//  Copyright (c) 2014 babyQ. All rights reserved.
//

#import "CompletedTodosViewController.h"

@interface CompletedTodosViewController ()

@end

@implementation CompletedTodosViewController

@synthesize completedTodosArray,completedTodosData;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.scrollView setContentSize:CGSizeMake(320, 568)];
    [self.scrollView setBackgroundColor:[UIColor whiteColor]];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.backItem.title = @"";
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationController.navigationBar.topItem.title = @"COMPLETED TO-DOS";
    
    completedTodosData = [[NSMutableData alloc] init];
    
    NSString* api_token = [(AppDelegate *)[[UIApplication sharedApplication] delegate] api_token];
    NSString* user_email = [(AppDelegate *)[[UIApplication sharedApplication] delegate] user_email];
    Constants* constants = [[Constants alloc] init];
    NSString* getCompletedTodosURL = [[constants.HOST stringByAppendingString:constants.VERSION] stringByAppendingString:constants.GET_COMPLETED_TODOS_PATH];
    NSString* postData = [[[@"ApiToken=" stringByAppendingString:api_token] stringByAppendingString:@"&Email="] stringByAppendingString:user_email];
    NSMutableURLRequest *completedTodosRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:getCompletedTodosURL]];
    [completedTodosRequest setHTTPMethod:@"POST"];
    [completedTodosRequest setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLConnection* conn = [[NSURLConnection alloc] initWithRequest:completedTodosRequest delegate:self];
    if (conn)
    {
        
    }
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data
{
    NSLog(@"received data completed todos");
    [completedTodosData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"ERROR completed todos");
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString* json_response = [[NSString alloc] initWithData:completedTodosData encoding:NSUTF8StringEncoding];
    NSLog(@"tip history response: %@", json_response);
    if ([json_response rangeOfString:@"ERROR"].location == NSNotFound)
    {
        NSData* json_data = [json_response dataUsingEncoding:NSUTF8StringEncoding];
        completedTodosArray = [NSJSONSerialization JSONObjectWithData: json_data
                                                    options: NSJSONReadingMutableContainers
                                                      error: nil];
        [self.scrollView setContentSize:CGSizeMake(320, 568 + 185*([completedTodosArray count]-1))];
        [self.background setFrame:CGRectMake(0, 0, 320, 568 + 185*([completedTodosArray count]-1))];
        for (int i = 0; i < [completedTodosArray count]; i++)
        {
            UIImageView* toDoImage = [[UIImageView alloc] initWithFrame:CGRectMake(97, 319+180*i, 32, 32)];
            toDoImage.image = [UIImage imageNamed:@"babyq_circle_orange.png"];
            [self.scrollView addSubview:toDoImage];
            
            UITextView* nextTodo = [[UITextView alloc] initWithFrame:CGRectMake(20, 365 + 180*i, 280, 160)];
            nextTodo.backgroundColor = [UIColor clearColor];
            nextTodo.editable = NO;
            nextTodo.font = [UIFont fontWithName:@"MyriadPro-Regular" size:14];
            nextTodo.textAlignment = NSTextAlignmentCenter;
            nextTodo.userInteractionEnabled = NO;
            nextTodo.text = completedTodosArray[i][@"Body"];
            [self.scrollView addSubview:nextTodo];
            
            UILabel* todoLabel = [[UILabel alloc] initWithFrame:CGRectMake(144, 319 + 180*i, 114, 21)];
            todoLabel.text = completedTodosArray[i][@"ToDoType"];
            todoLabel.font = [UIFont fontWithName:@"Bebas" size:17];
            [self.scrollView addSubview:todoLabel];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate* tipDate = [dateFormatter dateFromString:completedTodosArray[i][@"ReceivedDate"]];
            [dateFormatter setDateFormat:@"MM.dd.yyyy"];
            UILabel* dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(144, 341 + 180*i, 112, 21)];
            dateLabel.text = [dateFormatter stringFromDate:tipDate];
            dateLabel.font = [UIFont fontWithName:@"Bebas" size:17];
            dateLabel.highlighted = NO;
            dateLabel.enabled = NO;
            dateLabel.textColor = [UIColor colorWithRed:227.0f/255.0f green:95.0f/255.0f blue:62.0f/255.0f alpha:1.0f];
            [self.scrollView addSubview:dateLabel];
        }
    } else {
        UILabel* todoLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 319, 240, 24)];
        todoLabel.textAlignment = NSTextAlignmentCenter;
        todoLabel.text = @"No completed To-Dos.";
        todoLabel.font = [UIFont fontWithName:@"Bebas" size:17];
        [self.scrollView addSubview:todoLabel];
    }
    NSLog(@"finished loading tip history");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
