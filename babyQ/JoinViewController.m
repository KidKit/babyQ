//
//  JoinViewController.m
//  babyQ
//
//  Created by Chris Wood on 6/13/14.
//  Copyright (c) 2014 babyQ. All rights reserved.
//

#import "JoinViewController.h"

@interface JoinViewController ()

@end

@implementation JoinViewController

@synthesize background,datePicker,email,password,zipcode,currentlyPregnantLabel,yesButton,noButton,yesLabel,noLabel,whenDueLabel,joinButton;

BOOL isPregnant;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.scrollView setContentSize:CGSizeMake(320, 650)];
    [self.scrollView setBackgroundColor:[UIColor whiteColor]];
    [self.datePicker setFrame:CGRectMake(32, 395, 240, 150)];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.backItem.title = @"";
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationController.navigationBar.topItem.title = @"JOIN";
    
    email.font = [UIFont fontWithName:@"MyriadPro-Semibold" size:14];
    email.delegate = self;
    password.font = [UIFont fontWithName:@"MyriadPro-Semibold" size:14];
    password.delegate = self;
    zipcode.font = [UIFont fontWithName:@"MyriadPro-Semibold" size:14];
    zipcode.delegate = self;
    currentlyPregnantLabel.font = [UIFont fontWithName:@"MyriadPro-Regular" size:14];
    yesLabel.font = [UIFont fontWithName:@"MyriadPro-Semibold" size:14];
    noLabel.font = [UIFont fontWithName:@"MyriadPro-Semibold" size:14];
    whenDueLabel.font = [UIFont fontWithName:@"MyriadPro-Regular" size:14];
    whenDueLabel.hidden = YES;
    datePicker.hidden = YES;
    [background setFrame:CGRectMake(background.frame.origin.x, background.frame.origin.y, background.frame.size.width, background.frame.size.height-160)];
    [joinButton setFrame:CGRectMake(joinButton.frame.origin.x, joinButton.frame.origin.y-160, joinButton.frame.size.width, joinButton.frame.size.height)];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (IBAction)clickedYes:(id)sender
{
    [yesButton setImage:[UIImage imageNamed:@"babyq_check_mark.png"] forState:UIControlStateNormal] ;
    [noButton setImage:[UIImage imageNamed:@"babyq_check_box.png"] forState:UIControlStateNormal];
    whenDueLabel.hidden = NO;
    datePicker.hidden = NO;
    isPregnant = YES;
    [background setFrame:CGRectMake(background.frame.origin.x, background.frame.origin.y, background.frame.size.width, background.frame.size.height+160)];
    [joinButton setFrame:CGRectMake(joinButton.frame.origin.x, joinButton.frame.origin.y+160, joinButton.frame.size.width, joinButton.frame.size.height)];
}

- (IBAction)clickedNo:(id)sender
{
    [noButton setImage:[UIImage imageNamed:@"babyq_check_mark.png"] forState:UIControlStateNormal];
    [yesButton setImage:[UIImage imageNamed:@"babyq_check_box.png"] forState:UIControlStateNormal];
    whenDueLabel.hidden = YES;
    datePicker.hidden = YES;
    isPregnant = NO;
    [background setFrame:CGRectMake(background.frame.origin.x, background.frame.origin.y, background.frame.size.width, background.frame.size.height-160)];
    [joinButton setFrame:CGRectMake(joinButton.frame.origin.x, joinButton.frame.origin.y-160, joinButton.frame.size.width, joinButton.frame.size.height)];
}

- (IBAction)clickedJoin
{
    NSString* em = self.email.text;
    NSString* pwd = self.password.text;
    NSString* zip = self.zipcode.text;
    
    Constants* constants = [[Constants alloc] init];
    NSString* joinURL = [[constants.HOST stringByAppendingString:constants.VERSION] stringByAppendingString:constants.CREATE_ACCOUNT_PATH];
    NSString* postData = [[[@"Email=" stringByAppendingString:em] stringByAppendingString:@"&Password="] stringByAppendingString:pwd];
    postData = [[postData stringByAppendingString:@"&ZipCode="] stringByAppendingString:zip];
    postData = [[postData stringByAppendingString:@"&IsPregnant="] stringByAppendingString:isPregnant ? @"1" : @"0"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* date = [dateFormatter stringFromDate: datePicker.date];
    
    postData = [[postData stringByAppendingString:@"&DueDate="] stringByAppendingString:date];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:joinURL]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (conn)
    {
        
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data
{
    NSLog(@"received data sign in");
    NSString* json_response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSData* json_data = [json_response dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary* json_dictionary = [NSJSONSerialization JSONObjectWithData: json_data
                                                                    options: NSJSONReadingMutableContainers
                                                                      error: nil];
    if ([json_dictionary[@"VALID"] isEqualToString:@"Success"])
    {
        AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        appDelegate.api_token = json_dictionary[@"API TOKEN"];
        appDelegate.user_email = self.email.text;
        UIStoryboard * homeScreens = [UIStoryboard storyboardWithName:@"HomePage" bundle:nil];
        SideSwipeTableViewController* sideSwipeTableView = [homeScreens instantiateViewControllerWithIdentifier:@"SideSwipeTableView"];
        
        CurrentScoreViewController* currentScoreView = [homeScreens instantiateViewControllerWithIdentifier:@"CurrentScoreView"];
        
        MMDrawerController * swipeController = [[MMDrawerController alloc]
                                                initWithCenterViewController:currentScoreView
                                                leftDrawerViewController:sideSwipeTableView
                                                rightDrawerViewController:nil];
        [swipeController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModePanningCenterView];
        [swipeController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeBezelPanningCenterView];
        
        [self.navigationController pushViewController:swipeController animated:YES];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"ERROR");
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"finished loading sign in");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
