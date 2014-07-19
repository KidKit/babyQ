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

NSURLConnection* getCompletedTodosConnection;
NSURLConnection* getMoreCompletedTodosConnection;
int page;

@synthesize completedTodosArray,completedTodosData,moreButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.scrollView setContentSize:CGSizeMake(320, 568)];
    [self.scrollView setBackgroundColor:[UIColor whiteColor]];
    
    page = 0;
    completedTodosData = [[NSMutableData alloc] init];
    completedTodosArray = [[NSArray alloc] init];
    
    NSString* api_token = [(AppDelegate *)[[UIApplication sharedApplication] delegate] api_token];
    NSString* user_email = [(AppDelegate *)[[UIApplication sharedApplication] delegate] user_email];
    Constants* constants = [[Constants alloc] init];
    NSString* getCompletedTodosURL = [[constants.HOST stringByAppendingString:constants.VERSION] stringByAppendingString:constants.GET_COMPLETED_TODOS_PATH];
    NSString* postData = [[[@"ApiToken=" stringByAppendingString:api_token] stringByAppendingString:@"&Email="] stringByAppendingString:user_email];
    NSMutableURLRequest *completedTodosRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:getCompletedTodosURL]];
    [completedTodosRequest setHTTPMethod:@"POST"];
    [completedTodosRequest setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    getCompletedTodosConnection = [[NSURLConnection alloc] initWithRequest:completedTodosRequest delegate:self];
}

-(void) viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.backItem.title = @"";
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:120.0/255.0f green:120.0/255.0f blue:120.0/255.0f alpha:1.0f];
    self.navigationController.navigationBar.topItem.title = @"COMPLETED TO-DO'S";
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data
{
    [completedTodosData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString* json_response = [[NSString alloc] initWithData:completedTodosData encoding:NSUTF8StringEncoding];
   
    if ([json_response rangeOfString:@"ERROR"].location == NSNotFound)
    {
        NSData* json_data = [json_response dataUsingEncoding:NSUTF8StringEncoding];
        NSArray* todos = [NSJSONSerialization JSONObjectWithData: json_data
                                                    options: NSJSONReadingMutableContainers
                                                      error: nil];
        completedTodosArray = [completedTodosArray arrayByAddingObjectsFromArray:todos];
        
        [self.scrollView setContentSize:CGSizeMake(320, 568 + 150*([completedTodosArray count]-1))];
        [self.background setFrame:CGRectMake(0, 0, 320, 768 + 150*([completedTodosArray count]-1))];
        for (int i = 0+7*page; i < [completedTodosArray count]; i++)
        {
            UIImageView* toDoImage = [[UIImageView alloc] initWithFrame:CGRectMake(97, 319+150*i, 32, 32)];
            toDoImage.image = [UIImage imageNamed:@"babyq_circle_orange.png"];
            [self.scrollView addSubview:toDoImage];
            
            UITextView* nextTodo = [[UITextView alloc] initWithFrame:CGRectMake(20, 365 + 150*i, 280, 160)];
            nextTodo.backgroundColor = [UIColor clearColor];
            nextTodo.editable = NO;
            nextTodo.font = [UIFont fontWithName:@"MyriadPro-Regular" size:14];
            nextTodo.textColor = [UIColor colorWithRed:171.0/255.0f green:166.0/255.0f blue:164.0/255.0f alpha:1.0f];
            nextTodo.textAlignment = NSTextAlignmentCenter;
            nextTodo.userInteractionEnabled = NO;
            if (completedTodosArray[i][@"Body"] != (id)[NSNull null])
                nextTodo.text = completedTodosArray[i][@"Body"];
            [self.scrollView addSubview:nextTodo];
            
            UILabel* todoLabel = [[UILabel alloc] initWithFrame:CGRectMake(144, 312 + 150*i, 114, 21)];
            todoLabel.text = [completedTodosArray[i][@"ToDoType"] uppercaseString];
            todoLabel.font = [UIFont fontWithName:@"MyriadPro-Semibold" size:17];
            todoLabel.textColor = [UIColor colorWithRed:120.0/255.0f green:120.0/255.0f blue:120.0/255.0f alpha:1.0f];
            [self.scrollView addSubview:todoLabel];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString* dateString = completedTodosArray[i][@"CompletedDate"];
            if (dateString != (id)[NSNull null] && dateString.length > 0)
            {
                NSDate* tipDate = [dateFormatter dateFromString:dateString];
                [dateFormatter setDateFormat:@"MM.dd.yyyy"];
                UILabel* dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(144, 334 + 150*i, 112, 21)];
                dateLabel.text = [dateFormatter stringFromDate:tipDate];
                dateLabel.textColor = [UIColor colorWithRed:227.0/255.0f green:95.0/255.0f blue:62.0/255.0f alpha:1.0f];
                dateLabel.font = [UIFont fontWithName:@"MyriadPro-Semibold" size:17];
                dateLabel.highlighted = NO;
                dateLabel.enabled = YES;
                [self.scrollView addSubview:dateLabel];
            }
        }
        if ([completedTodosArray count] % 7 == 0)
        {
            moreButton = [[UIButton alloc] initWithFrame:CGRectMake(137, 430+150*([completedTodosArray count]-1), 46, 30)];
            [moreButton setTitleColor:[UIColor colorWithRed:124/255.0 green:197/255.0 blue:189/255.0 alpha:1.0] forState:UIControlStateNormal];
            [moreButton setTitle:@"More" forState:UIControlStateNormal];
            [moreButton addTarget:self action:@selector(getMoreCompletedTodos) forControlEvents:UIControlEventTouchUpInside];
            [self.scrollView addSubview:moreButton];
        }
    } else {
        if (page == 0)
        {
            UILabel* todoLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 319, 240, 24)];
            todoLabel.textAlignment = NSTextAlignmentCenter;
            todoLabel.text = @"No completed To-Dos.";
            todoLabel.font = [UIFont fontWithName:@"Bebas" size:17];
            [self.scrollView addSubview:todoLabel];
        }
    }
}

-(void) getMoreCompletedTodos
{
    page++;
    [moreButton removeFromSuperview];
    completedTodosData = [[NSMutableData alloc] init];
    NSString* api_token = [(AppDelegate *)[[UIApplication sharedApplication] delegate] api_token];
    NSString* user_email = [(AppDelegate *)[[UIApplication sharedApplication] delegate] user_email];
    Constants* constants = [[Constants alloc] init];
    NSString* getMoreTipsURL = [[constants.HOST stringByAppendingString:constants.VERSION] stringByAppendingString:constants.GET_NEXT_COMPLETED_TODOS_GROUP_PATH];
    NSString* postData = [[[@"ApiToken=" stringByAppendingString:api_token] stringByAppendingString:@"&Email="] stringByAppendingString:user_email];
    postData = [[postData stringByAppendingString:@"&ToDoId="] stringByAppendingString:completedTodosArray[6][@"ToDoId"]];
    NSMutableURLRequest *moreTipsRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:getMoreTipsURL]];
    [moreTipsRequest setHTTPMethod:@"POST"];
    [moreTipsRequest setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    getMoreCompletedTodosConnection = [[NSURLConnection alloc] initWithRequest:moreTipsRequest delegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
