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

@synthesize background,datePicker,email,fb_email,password,zipcode,currentlyPregnantLabel,yesButton,noButton,yesLabel,noLabel,whenDueLabel,joinButton,termsCheckbox,termsLabelText,termsLabelLink;

BOOL isPregnant;
BOOL agreedToTerms;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.scrollView setContentSize:CGSizeMake(320, 550)];
    [self.scrollView setBackgroundColor:[UIColor whiteColor]];
    [self.datePicker setFrame:CGRectMake(32, 395, 240, 150)];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    
    email.font = [UIFont fontWithName:@"MyriadPro-Semibold" size:14];
    email.delegate = self;
    password.font = [UIFont fontWithName:@"MyriadPro-Semibold" size:14];
    password.delegate = self;
    if ([fb_email length] != 0)
    {
        email.text = fb_email;
        password.enabled = NO;
        password.placeholder = @"Facebook login: no password required.";
    }
    zipcode.font = [UIFont fontWithName:@"MyriadPro-Semibold" size:14];
    zipcode.delegate = self;
    currentlyPregnantLabel.font = [UIFont fontWithName:@"MyriadPro-Regular" size:14];
    yesLabel.font = [UIFont fontWithName:@"MyriadPro-Semibold" size:14];
    noLabel.font = [UIFont fontWithName:@"MyriadPro-Semibold" size:14];
    whenDueLabel.font = [UIFont fontWithName:@"MyriadPro-Regular" size:14];
    whenDueLabel.hidden = YES;
    datePicker.hidden = YES;
    [background setFrame:CGRectMake(background.frame.origin.x, background.frame.origin.y, background.frame.size.width, background.frame.size.height-180)];
    [joinButton setFrame:CGRectMake(joinButton.frame.origin.x, joinButton.frame.origin.y-180, joinButton.frame.size.width, joinButton.frame.size.height)];
    [termsCheckbox setFrame:CGRectMake(termsCheckbox.frame.origin.x, termsCheckbox.frame.origin.y-180, termsCheckbox.frame.size.width, termsCheckbox.frame.size.height)];
    [termsLabelText setFrame:CGRectMake(termsLabelText.frame.origin.x, termsLabelText.frame.origin.y-180, termsLabelText.frame.size.width, termsLabelText.frame.size.height)];
    [termsLabelLink setFrame:CGRectMake(termsLabelLink.frame.origin.x, termsLabelLink.frame.origin.y-180, termsLabelLink.frame.size.width, termsLabelLink.frame.size.height)];
    agreedToTerms = YES;
    isPregnant = NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (IBAction)clickedYes:(id)sender
{
    if (!isPregnant)
    {
        [self.scrollView setContentSize:CGSizeMake(320, 700)];
        [yesButton setImage:[UIImage imageNamed:@"babyq_check_mark.png"] forState:UIControlStateNormal] ;
        [noButton setImage:[UIImage imageNamed:@"babyq_check_box.png"] forState:UIControlStateNormal];
        whenDueLabel.hidden = NO;
        datePicker.hidden = NO;
        isPregnant = YES;
        [background setFrame:CGRectMake(background.frame.origin.x, background.frame.origin.y, background.frame.size.width, background.frame.size.height+180)];
        [joinButton setFrame:CGRectMake(joinButton.frame.origin.x, joinButton.frame.origin.y+180, joinButton.frame.size.width, joinButton.frame.size.height)];
        [termsCheckbox setFrame:CGRectMake(termsCheckbox.frame.origin.x, termsCheckbox.frame.origin.y+180, termsCheckbox.frame.size.width, termsCheckbox.frame.size.height)];
        [termsLabelText setFrame:CGRectMake(termsLabelText.frame.origin.x, termsLabelText.frame.origin.y+180, termsLabelText.frame.size.width, termsLabelText.frame.size.height)];
        [termsLabelLink setFrame:CGRectMake(termsLabelLink.frame.origin.x, termsLabelLink.frame.origin.y+180, termsLabelLink.frame.size.width, termsLabelLink.frame.size.height)];
    }
}

- (IBAction)clickedNo:(id)sender
{
    [noButton setImage:[UIImage imageNamed:@"babyq_check_mark.png"] forState:UIControlStateNormal];
    [yesButton setImage:[UIImage imageNamed:@"babyq_check_box.png"] forState:UIControlStateNormal];
    if (isPregnant)
    {
        [self.scrollView setContentSize:CGSizeMake(320, 550)];
        whenDueLabel.hidden = YES;
        datePicker.hidden = YES;
        isPregnant = NO;
        [background setFrame:CGRectMake(background.frame.origin.x, background.frame.origin.y, background.frame.size.width, background.frame.size.height-180)];
        [joinButton setFrame:CGRectMake(joinButton.frame.origin.x, joinButton.frame.origin.y-180, joinButton.frame.size.width, joinButton.frame.size.height)];
        [termsCheckbox setFrame:CGRectMake(termsCheckbox.frame.origin.x, termsCheckbox.frame.origin.y-180, termsCheckbox.frame.size.width, termsCheckbox.frame.size.height)];
        [termsLabelText setFrame:CGRectMake(termsLabelText.frame.origin.x, termsLabelText.frame.origin.y-180, termsLabelText.frame.size.width, termsLabelText.frame.size.height)];
        [termsLabelLink setFrame:CGRectMake(termsLabelLink.frame.origin.x, termsLabelLink.frame.origin.y-180, termsLabelLink.frame.size.width, termsLabelLink.frame.size.height)];
    }
}

- (IBAction)clickedTermsCheckbox:(id)sender
{
    agreedToTerms = !agreedToTerms;
    agreedToTerms ? [termsCheckbox setImage:[UIImage imageNamed:@"babyq_check_mark.png"] forState:UIControlStateNormal] :
                    [termsCheckbox setImage:[UIImage imageNamed:@"babyq_check_box.png"] forState:UIControlStateNormal];
    
}

- (IBAction)clickedTermsLink:(id)sender
{
    UIStoryboard * settingsScreens = [UIStoryboard storyboardWithName:@"Settings" bundle:nil];
    UIViewController* termsOfUse = [settingsScreens instantiateViewControllerWithIdentifier:@"TermsOfUse"];
    [self.navigationController pushViewController:termsOfUse animated:YES];
}

- (IBAction)clickedJoin
{
    NSString* em = self.email.text;
    NSString* pwd = self.password.text;
    NSString* zip = self.zipcode.text;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* date = [dateFormatter stringFromDate: datePicker.date];
    
    if (self.password.enabled)
    {
        if ([em length] != 0 && [pwd length] != 0 && [zip length] != 0 && agreedToTerms)
        {
            Constants* constants = [[Constants alloc] init];
            NSString* joinURL = [[constants.HOST stringByAppendingString:constants.VERSION] stringByAppendingString:constants.CREATE_ACCOUNT_PATH];
            NSString* postData = [[[@"Email=" stringByAppendingString:em] stringByAppendingString:@"&Password="] stringByAppendingString:pwd];
            postData = [[postData stringByAppendingString:@"&ZipCode="] stringByAppendingString:zip];
            postData = [[postData stringByAppendingString:@"&IsPregnant="] stringByAppendingString:isPregnant ? @"1" : @"0"];
            
            postData = [[postData stringByAppendingString:@"&DueDate="] stringByAppendingString:date];
            
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:joinURL]];
            [request setHTTPMethod:@"POST"];
            [request setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
            NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            if (conn)
            {
                
            }
        } else {
            //validation code
        }
    } else {
        if ([em length] != 0 && [zip length] != 0 && agreedToTerms)
        {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"MM/dd/yyyy"];
            NSDate* fb_bday = [dateFormatter dateFromString:[(AppDelegate *)[[UIApplication sharedApplication] delegate] fb_birthday]];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString* formatted_bday =  [dateFormatter stringFromDate:fb_bday];
            Constants* constants = [[Constants alloc] init];
            NSString* api_token = [(AppDelegate *)[[UIApplication sharedApplication] delegate] api_token];
            NSString* fb_name = [(AppDelegate *)[[UIApplication sharedApplication] delegate] fb_name];
            NSString* joinURL = [[constants.HOST stringByAppendingString:constants.VERSION] stringByAppendingString:constants.FACEBOOK_FINALIZE_PATH];
            NSString* postData = [[[@"ApiToken=" stringByAppendingString:api_token] stringByAppendingString:@"&Email="] stringByAppendingString:em];
            postData = [[postData stringByAppendingString:@"&ZipCode="] stringByAppendingString:zip];
            postData = [[postData stringByAppendingString:@"&IsPregnant="] stringByAppendingString:isPregnant ? @"1" : @"0"];
            postData = [[postData stringByAppendingString:@"&DueDate="] stringByAppendingString:date];
            postData = [[postData stringByAppendingString:@"&Birthdate="] stringByAppendingString:formatted_bday];
            postData = [[postData stringByAppendingString:@"&Name="] stringByAppendingString:fb_name];
            
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:joinURL]];
            [request setHTTPMethod:@"POST"];
            [request setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
            NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            if (conn)
            {
                
            }
        } else {
            //validation code
        }
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

- (void) viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.backItem.title = @"";
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationController.navigationBar.topItem.title = @"JOIN";
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
