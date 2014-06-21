//
//  TipHistoryViewController.m
//  babyQ
//
//  Created by Chris Wood on 6/17/14.
//  Copyright (c) 2014 babyQ. All rights reserved.
//

#import "TipHistoryViewController.h"

@interface TipHistoryViewController ()

@end

@implementation TipHistoryViewController

@synthesize scrollView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.scrollView setBackgroundColor:[UIColor whiteColor]];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.backItem.title = @"";
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationController.navigationBar.topItem.title = @"TIP HISTORY";
    
    NSString* api_token = [(AppDelegate *)[[UIApplication sharedApplication] delegate] api_token];
    NSString* user_email = [(AppDelegate *)[[UIApplication sharedApplication] delegate] user_email];
    Constants* constants = [[Constants alloc] init];
    NSString* getTipHistoryURL = [[constants.HOST stringByAppendingString:constants.VERSION] stringByAppendingString:constants.GET_TIP_HISTORY_PATH];
    NSString* postData = [[[@"ApiToken=" stringByAppendingString:api_token] stringByAppendingString:@"&Email="] stringByAppendingString:user_email];
    NSMutableURLRequest *tipHistoryRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:getTipHistoryURL]];
    [tipHistoryRequest setHTTPMethod:@"POST"];
    [tipHistoryRequest setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLConnection* conn = [[NSURLConnection alloc] initWithRequest:tipHistoryRequest delegate:self];
    if (conn)
    {
        
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data
{
    NSLog(@"received data tip history");
    NSString* json_response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"tip history response: %@", json_response);
    NSData* json_data = [json_response dataUsingEncoding:NSUTF8StringEncoding];
    NSArray* tipsArray = [NSJSONSerialization JSONObjectWithData: json_data
                                                                        options: NSJSONReadingMutableContainers
                                                                          error: nil];
    for (int i = 0; i < [tipsArray count]; i++)
    {
        UIImageView* tipImage = [[UIImageView alloc] initWithFrame:CGRectMake(97, 319+200*i, 32, 32)];
        tipImage.image = [UIImage imageNamed:@"babyq_dailytip_icon.png"];
        [self.scrollView addSubview:tipImage];
        
        [UIImage imageNamed:@"babyq_dailytip_icon.png"];
        UITextView* nextTip = [[UITextView alloc] initWithFrame:CGRectMake(20, 365 + 200*i, 280, 160)];
        nextTip.backgroundColor = [UIColor clearColor];
        nextTip.editable = NO;
        nextTip.font = [UIFont fontWithName:@"MyriadPro-Regular" size:14];
        nextTip.textAlignment = NSTextAlignmentCenter;
        nextTip.userInteractionEnabled = NO;
        nextTip.text = tipsArray[i][@"Body"];
        [self.scrollView addSubview:nextTip];
        
        UILabel* tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(144, 319 + 200*i, 114, 21)];
        tipLabel.text = @"DAILY TIP";
        tipLabel.font = [UIFont fontWithName:@"Bebas" size:17];
        [self.scrollView addSubview:tipLabel];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate* tipDate = [dateFormatter dateFromString:tipsArray[i][@"ReceivedDate"]];
        [dateFormatter setDateFormat:@"MM.dd.yyyy"];
        UILabel* dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(144, 341 + 200*i, 112, 21)];
        dateLabel.text = [dateFormatter stringFromDate:tipDate];
        dateLabel.font = [UIFont fontWithName:@"Bebas" size:17];
        [self.scrollView addSubview:dateLabel];
    }
    
    [self.scrollView setContentSize:CGSizeMake(320, 568 + 205*([tipsArray count]-1))];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"ERROR tip history");
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"finished loading tip history");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
