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

@implementation TipHistoryViewController

UIActivityIndicatorView *spinner;
NSURLConnection* getTipsConnection;
NSURLConnection* getMoreTipsConnection;
int page;

@synthesize scrollView,background,tipsArray,tipsData,moreButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.center = CGPointMake(160, 240);
    spinner.hidesWhenStopped = YES;
    [self.view addSubview:spinner];
    [spinner startAnimating];
    
    page = 0;
    [self.scrollView setBackgroundColor:[UIColor whiteColor]];
    
    tipsData = [[NSMutableData alloc] init];
    tipsArray = [[NSArray alloc] init];
    NSString* api_token = [(AppDelegate *)[[UIApplication sharedApplication] delegate] api_token];
    NSString* user_email = [(AppDelegate *)[[UIApplication sharedApplication] delegate] user_email];
    Constants* constants = [[Constants alloc] init];
    NSString* getTipHistoryURL = [[constants.HOST stringByAppendingString:constants.VERSION] stringByAppendingString:constants.GET_TIP_HISTORY_PATH];
    NSString* postData = [[[@"ApiToken=" stringByAppendingString:api_token] stringByAppendingString:@"&Email="] stringByAppendingString:user_email];
    NSMutableURLRequest *tipHistoryRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:getTipHistoryURL]];
    [tipHistoryRequest setHTTPMethod:@"POST"];
    [tipHistoryRequest setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    getTipsConnection = [[NSURLConnection alloc] initWithRequest:tipHistoryRequest delegate:self];

}

-(void) viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.backItem.title = @"";
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:120.0/255.0f green:120.0/255.0f blue:120.0/255.0f alpha:1.0f];
    self.navigationController.navigationBar.topItem.title = @"TIP HISTORY";
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data
{
    [tipsData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString* json_response = [[NSString alloc] initWithData:tipsData encoding:NSUTF8StringEncoding];
    if ([json_response rangeOfString:@"ERROR"].location == NSNotFound)
    {
        NSData* json_data = [json_response dataUsingEncoding:NSUTF8StringEncoding];
        NSArray* tips = [NSJSONSerialization JSONObjectWithData: json_data
                                                    options: NSJSONReadingMutableContainers
                                                      error: nil];
        tipsArray = [tipsArray arrayByAddingObjectsFromArray:tips];
        
        [self.scrollView setContentSize:CGSizeMake(320, 568 + 205*([tipsArray count]-1))];
        [self.background setFrame:CGRectMake(0, 0, 320, 568 + 205*([tipsArray count]-1))];
        for (int i = 0+7*page; i < [tipsArray count]; i++)
        {
            UIImageView* tipImage = [[UIImageView alloc] initWithFrame:CGRectMake(97, 319+200*i, 32, 32)];
            tipImage.image = [UIImage imageNamed:@"babyq_dailytip_icon.png"];
            [self.scrollView addSubview:tipImage];
            
            [UIImage imageNamed:@"babyq_dailytip_icon.png"];
            UITextView* nextTip = [[UITextView alloc] initWithFrame:CGRectMake(20, 365 + 200*i, 280, 160)];
            nextTip.backgroundColor = [UIColor clearColor];
            nextTip.editable = NO;
            nextTip.font = [UIFont fontWithName:@"MyriadPro-Regular" size:15];
            nextTip.textAlignment = NSTextAlignmentCenter;
            nextTip.userInteractionEnabled = NO;
            nextTip.text = [tipsArray[i][@"Body"] stringByDecodingURLFormat];
            [self.scrollView addSubview:nextTip];
            
            UILabel* tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(144, 319 + 200*i, 114, 21)];
            tipLabel.text = @"DAILY TIP";
            tipLabel.font = [UIFont fontWithName:@"MyriadPro-Bold" size:18];
            [self.scrollView addSubview:tipLabel];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate* tipDate = [dateFormatter dateFromString:tipsArray[i][@"ReceivedDate"]];
            [dateFormatter setDateFormat:@"MM.dd.yyyy"];
            UILabel* dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(144, 341 + 200*i, 112, 21)];
            
           
            NSCalendar *gregorian = [[NSCalendar alloc]
                                     initWithCalendarIdentifier:NSGregorianCalendar];
            NSDateComponents *comps = [gregorian components: NSDayCalendarUnit
                                                   fromDate: tipDate
                                                     toDate: [NSDate date]
                                                    options: 0];
            int days = (int) [comps day];
            
            
            dateLabel.text = [NSString stringWithFormat:@"%d  days ago", days];
            dateLabel.font = [UIFont fontWithName:@"Bebas" size:18];
            dateLabel.highlighted = NO;
            dateLabel.enabled = NO;
            dateLabel.textColor = [UIColor colorWithRed:227.0f/255.0f green:95.0f/255.0f blue:62.0f/255.0f alpha:1.0f];
            [self.scrollView addSubview:dateLabel];
        }
        if ([tipsArray count] % 7 == 0)
        {
            moreButton = [[UIButton alloc] initWithFrame:CGRectMake(37, 505+200*([tipsArray count]-1), 246, 30)];
            [moreButton setTitleColor:[UIColor colorWithRed:124/255.0 green:197/255.0 blue:189/255.0 alpha:1.0] forState:UIControlStateNormal];
            [moreButton setTitle:@"More" forState:UIControlStateNormal];
            [moreButton addTarget:self action:@selector(getMoreTips) forControlEvents:UIControlEventTouchUpInside];
            [self.scrollView addSubview:moreButton];
        }
    } else {
        if ([tipsArray count] >0)
        {
            UILabel* tipLabel = [[UILabel alloc] initWithFrame:moreButton.frame];
            tipLabel.text = @"No more tip history";
            tipLabel.textColor = [UIColor colorWithRed:120.0/255.0f green:120.0/255.0f blue:120.0/255.0f alpha:1.0f];
            tipLabel.textAlignment = NSTextAlignmentCenter;
            tipLabel.font = [UIFont fontWithName:@"Bebas" size:18];
            [moreButton removeFromSuperview];
            [self.scrollView addSubview:tipLabel];
        }
        else
        {
            UILabel* tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 319, 120, 21)];
            tipLabel.text = @"No tip history";
            tipLabel.textColor = [UIColor colorWithRed:120.0/255.0f green:120.0/255.0f blue:120.0/255.0f alpha:1.0f];
            tipLabel.textAlignment = NSTextAlignmentCenter;
            tipLabel.font = [UIFont fontWithName:@"Bebas" size:18];
            [self.scrollView addSubview:tipLabel];
        }
    }
    [spinner stopAnimating];
}

-(void) getMoreTips
{
    page++;
    spinner.center = CGPointMake(160, 240+scrollView.contentOffset.y);
    [moreButton removeFromSuperview];
    tipsData = [[NSMutableData alloc] init];
    NSString* api_token = [(AppDelegate *)[[UIApplication sharedApplication] delegate] api_token];
    NSString* user_email = [(AppDelegate *)[[UIApplication sharedApplication] delegate] user_email];
    Constants* constants = [[Constants alloc] init];
    NSString* getMoreTipsURL = [[constants.HOST stringByAppendingString:constants.VERSION] stringByAppendingString:constants.GET_NEXT_TIP_HISTORY_GROUP_PATH];
    NSString* postData = [[[@"ApiToken=" stringByAppendingString:api_token] stringByAppendingString:@"&Email="] stringByAppendingString:user_email];
    postData = [[postData stringByAppendingString:@"&TipId="] stringByAppendingString:tipsArray[6][@"TipId"]];
    NSMutableURLRequest *moreTipsRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:getMoreTipsURL]];
    [moreTipsRequest setHTTPMethod:@"POST"];
    [moreTipsRequest setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    getMoreTipsConnection = [[NSURLConnection alloc] initWithRequest:moreTipsRequest delegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
