//
//  UserSettingsViewController.m
//  babyQ
//
//  Created by Chris Wood on 6/13/14.
//  Copyright (c) 2014 babyQ. All rights reserved.
//

#import "UserSettingsViewController.h"

@interface UserSettingsViewController ()

@end

@implementation UserSettingsViewController

@synthesize scrollView,profilePicture,emailView,email,password,theNewPassword,saveAccountButton,cancelAccountButton,alertsView,alertsHeader,surveyAlerts,dailyTipAlerts,surveyAlertsLabel,dailyTipAlertsLabel,rateAppLink,savedMessage,offlineMessage;

BOOL internet;
NSString* prevEmail;
NSString* prevPassword;
NSURLConnection* setDeviceSettingsConnection;
NSURLConnection* getDeviceSettingsConnection;
NSURLConnection* setDeviceInactiveConnection;
NSURLConnection* changeEmailConnection;
NSURLConnection* changePasswordConnection;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self testInternetConnection];
    [self.scrollView setContentSize:CGSizeMake(320, 650)];
    [self.scrollView setBackgroundColor:[UIColor whiteColor]];
    
    NSString* fb_pic = [(AppDelegate *)[UIApplication sharedApplication].delegate fb_profilePicture];
    if ([fb_pic length] > 0)
    {
        profilePicture.layer.cornerRadius = 50.0;
        profilePicture.layer.masksToBounds = YES;
        profilePicture.contentMode = UIViewContentModeScaleAspectFill;
        NSURL *imageURL = [NSURL URLWithString:fb_pic];
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        UIImage *image = [UIImage imageWithData:imageData];
        profilePicture.image = image;
        profilePicture.userInteractionEnabled = NO;
    } else {
        NSString* user_email = [(AppDelegate *)[[UIApplication sharedApplication] delegate] user_email];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:[user_email stringByAppendingString:@"_latest_photo.png"]];
        
        NSData* picData = [NSData dataWithContentsOfFile:imagePath];
        if (picData != nil)
        {
            profilePicture.layer.cornerRadius = 50.0;
            profilePicture.layer.masksToBounds = YES;
            profilePicture.contentMode = UIViewContentModeScaleAspectFill;
            UIImage* picImage = [UIImage imageWithData:picData];
            profilePicture.image = picImage;
        }
    }
    
    NSString* api_token = [(AppDelegate *)[[UIApplication sharedApplication] delegate] api_token];
    NSString* user_email = [(AppDelegate *)[[UIApplication sharedApplication] delegate] user_email];
    Constants* constants = [[Constants alloc] init];
    NSString* getCurrentScoreURL = [[constants.HOST stringByAppendingString:constants.VERSION] stringByAppendingString:constants.GET_DEVICE_SETTINGS_PATH];
    NSString* postData = [[[@"ApiToken=" stringByAppendingString:api_token] stringByAppendingString:@"&Email="] stringByAppendingString:user_email];
    postData = [[postData stringByAppendingString:@"&DeviceId="] stringByAppendingString:[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
    
    NSMutableURLRequest *currentScoreRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:getCurrentScoreURL]];
    [currentScoreRequest setHTTPMethod:@"POST"];
    [currentScoreRequest setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    getDeviceSettingsConnection = [[NSURLConnection alloc] initWithRequest:currentScoreRequest delegate:self];
    
    savedMessage.font = [UIFont fontWithName:@"MyriadPro-Semibold" size:15];
    savedMessage.hidden = YES;
    email.font = [UIFont fontWithName:@"MyriadPro-Semibold" size:15];
    email.delegate = self;
    email.text = user_email;
    password.font = [UIFont fontWithName:@"MyriadPro-Semibold" size:15];
    password.delegate = self;
    theNewPassword.font = [UIFont fontWithName:@"MyriadPro-Semibold" size:15];
    theNewPassword.delegate = self;
    
    surveyAlerts.transform = CGAffineTransformMakeScale(0.9, 0.9);
    dailyTipAlerts.transform = CGAffineTransformMakeScale(0.9, 0.9);
    
    alertsHeader.font = [UIFont fontWithName:@"MyriadPro-Semibold" size:15];
    surveyAlertsLabel.font = [UIFont fontWithName:@"MyriadPro-Regular" size:13];
    dailyTipAlertsLabel.font = [UIFont fontWithName:@"MyriadPro-Regular" size:13];
    rateAppLink.titleLabel.font = [UIFont fontWithName:@"MyriadPro-Regular" size:13];
    
    prevEmail = email.text;
    prevPassword = password.text;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.scrollView addGestureRecognizer:tap];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.backItem.title = @"";
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:120.0/255.0f green:120.0/255.0f blue:120.0/255.0f alpha:1.0f];
    self.navigationController.navigationBar.topItem.title = @"SETTINGS";
}

-(void) viewWillDisappear:(BOOL)animated
{
    [self dismissKeyboard];
}

-(void)dismissKeyboard {
    [email resignFirstResponder];
    [password resignFirstResponder];
    [theNewPassword resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    if (emailView.frame.size.height < 200)
    {
        [UIView animateWithDuration:0.5f animations:^{
            [alertsView setFrame:CGRectMake(alertsView.frame.origin.x, alertsView.frame.origin.y + 107, alertsView.frame.size.width, alertsView.frame.size.height)];
        }];
        [UIView animateWithDuration:0.5f animations:^{
            [emailView setFrame:CGRectMake(emailView.frame.origin.x, emailView.frame.origin.y, emailView.frame.size.width, emailView.frame.size.height + 107)];
        }];
    }
}

-(IBAction)saveAccountFields
{
    
    NSString* api_token = [(AppDelegate *)[[UIApplication sharedApplication] delegate] api_token];
    NSString* user_email = [(AppDelegate *)[[UIApplication sharedApplication] delegate] user_email];
    Constants* constants = [[Constants alloc] init];
    
    if (![email.text isEqualToString:prevEmail])
    {
        NSString* getCurrentScoreURL = [[constants.HOST stringByAppendingString:constants.VERSION] stringByAppendingString:constants.CHANGE_EMAIL_PATH];
        NSString* postData = [[[@"ApiToken=" stringByAppendingString:api_token] stringByAppendingString:@"&Email="] stringByAppendingString:user_email];
        postData = [[postData stringByAppendingString:@"&NewEmail="] stringByAppendingString:email.text];
        
        NSMutableURLRequest *currentScoreRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:getCurrentScoreURL]];
        [currentScoreRequest setHTTPMethod:@"POST"];
        [currentScoreRequest setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
        changeEmailConnection = [[NSURLConnection alloc] initWithRequest:currentScoreRequest delegate:self];
    }
    if ([password.text length] > 0 && [theNewPassword.text length] > 0)
    {
        NSString* getCurrentScoreURL = [[constants.HOST stringByAppendingString:constants.VERSION] stringByAppendingString:constants.CHANGE_PASSWORD_PATH];
        NSString* postData = [[[@"ApiToken=" stringByAppendingString:api_token] stringByAppendingString:@"&Email="] stringByAppendingString:user_email];
        postData = [[postData stringByAppendingString:@"&CurrentPassword="] stringByAppendingString:password.text];
        postData = [[postData stringByAppendingString:@"&NewPassword="] stringByAppendingString:theNewPassword.text];
        
        NSMutableURLRequest *currentScoreRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:getCurrentScoreURL]];
        [currentScoreRequest setHTTPMethod:@"POST"];
        [currentScoreRequest setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
        changePasswordConnection = [[NSURLConnection alloc] initWithRequest:currentScoreRequest delegate:self];
    }
}

-(IBAction)cancelAccountFields
{
    email.text = prevEmail;
    password.text = prevPassword;
    [email resignFirstResponder];
    [password resignFirstResponder];
    [theNewPassword resignFirstResponder];
    [UIView animateWithDuration:0.5f animations:^{
        [UIView animateWithDuration:0.5f animations:^{
            [alertsView setFrame:CGRectMake(alertsView.frame.origin.x, alertsView.frame.origin.y - 107, alertsView.frame.size.width, alertsView.frame.size.height)];
        }];
        [emailView setFrame:CGRectMake(emailView.frame.origin.x, emailView.frame.origin.y, emailView.frame.size.width, emailView.frame.size.height - 107)];
    }];
}

-(IBAction)openAppStore
{
    NSString* appID = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    NSString* url = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", appID];
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];
}

-(IBAction)toggleSurveyAlerts:(id)sender
{
    
    NSString* api_token = [(AppDelegate *)[[UIApplication sharedApplication] delegate] api_token];
    NSString* user_email = [(AppDelegate *)[[UIApplication sharedApplication] delegate] user_email];
    Constants* constants = [[Constants alloc] init];
    NSString* getCurrentScoreURL = [[constants.HOST stringByAppendingString:constants.VERSION] stringByAppendingString:constants.SET_DEVICE_SETTINGS_PATH];
    NSString* postData = [[[@"ApiToken=" stringByAppendingString:api_token] stringByAppendingString:@"&Email="] stringByAppendingString:user_email];
    postData = [[postData stringByAppendingString:@"&DeviceId="] stringByAppendingString:[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
    postData = [[postData stringByAppendingString:@"&IsActive=1&SurveyReminder="] stringByAppendingString:surveyAlerts.on ? @"1" : @"0"];
    postData = [[postData stringByAppendingString:@"&DailyTipNotification="] stringByAppendingString:dailyTipAlerts.on ? @"1" : @"0"];
    
    NSMutableURLRequest *currentScoreRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:getCurrentScoreURL]];
    [currentScoreRequest setHTTPMethod:@"POST"];
    [currentScoreRequest setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    setDeviceSettingsConnection = [[NSURLConnection alloc] initWithRequest:currentScoreRequest delegate:self];
}

-(IBAction)toggleDailyTipAlerts:(id)sender
{
    NSString* api_token = [(AppDelegate *)[[UIApplication sharedApplication] delegate] api_token];
    NSString* user_email = [(AppDelegate *)[[UIApplication sharedApplication] delegate] user_email];
    Constants* constants = [[Constants alloc] init];
    NSString* getCurrentScoreURL = [[constants.HOST stringByAppendingString:constants.VERSION] stringByAppendingString:constants.SET_DEVICE_SETTINGS_PATH];
    NSString* postData = [[[@"ApiToken=" stringByAppendingString:api_token] stringByAppendingString:@"&Email="] stringByAppendingString:user_email];
    postData = [[postData stringByAppendingString:@"&DeviceId="] stringByAppendingString:[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
    postData = [[postData stringByAppendingString:@"&IsActive=1&SurveyReminder="] stringByAppendingString:surveyAlerts.on ? @"1" : @"0"];
    postData = [[postData stringByAppendingString:@"&DailyTipNotification="] stringByAppendingString:dailyTipAlerts.on ? @"1" : @"0"];
    
    NSMutableURLRequest *currentScoreRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:getCurrentScoreURL]];
    [currentScoreRequest setHTTPMethod:@"POST"];
    [currentScoreRequest setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    setDeviceSettingsConnection = [[NSURLConnection alloc] initWithRequest:currentScoreRequest delegate:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data
{
    if (connection == getDeviceSettingsConnection)
    {
        NSString* json_response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSData* json_data = [json_response dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary* json_dictionary = [NSJSONSerialization JSONObjectWithData: json_data
                                                                        options: NSJSONReadingMutableContainers
                                                                          error: nil];
        if ([json_dictionary[@"DailyTipNotification"] isEqualToString:@"1"])
            dailyTipAlerts.on = YES;
        else
            dailyTipAlerts.on = NO;
        
        
        if ([json_dictionary[@"SurveyReminder"] isEqualToString:@"1"])
            surveyAlerts.on = YES;
        else
            surveyAlerts.on = NO;
            
    }
    else if (connection == setDeviceSettingsConnection)
    {
        NSString* json_response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSData* json_data = [json_response dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary* json_dictionary = [NSJSONSerialization JSONObjectWithData: json_data
                                                                        options: NSJSONReadingMutableContainers
                                                                          error: nil];
        if ([json_dictionary[@"VALID"] isEqualToString:@"Success"])
        {
            NSLog(@"device settings set successfully");
        }
    } else if (connection == setDeviceInactiveConnection)
    {
        NSString* json_response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSData* json_data = [json_response dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary* json_dictionary = [NSJSONSerialization JSONObjectWithData: json_data
                                                                        options: NSJSONReadingMutableContainers
                                                                          error: nil];
        if ([json_dictionary[@"VALID"] isEqualToString:@"Success"])
        {
            NSLog(@"device successfully set inactive");
        }
    } else if (connection == changeEmailConnection)
    {
        NSString* json_response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSData* json_data = [json_response dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary* json_dictionary = [NSJSONSerialization JSONObjectWithData: json_data
                                                                        options: NSJSONReadingMutableContainers
                                                                          error: nil];
        if ([json_dictionary[@"VALID"] isEqualToString:@"Success"])
        {
            
            if (emailView.frame.size.height > 200)
            {
                [UIView animateWithDuration:0.5f animations:^{
                    [alertsView setFrame:CGRectMake(alertsView.frame.origin.x, alertsView.frame.origin.y - 107, alertsView.frame.size.width, alertsView.frame.size.height)];
                    [emailView setFrame:CGRectMake(emailView.frame.origin.x, emailView.frame.origin.y, emailView.frame.size.width, emailView.frame.size.height - 107)];
                }];
                savedMessage.hidden = NO;
                [savedMessage setFrame:CGRectMake(savedMessage.frame.origin.x, 64+scrollView.contentOffset.y, savedMessage.frame.size.width, savedMessage.frame.size.height)];
                [UIView animateWithDuration:2.0f animations:^{
                    [savedMessage setFrame:CGRectMake(savedMessage.frame.origin.x, savedMessage.frame.origin.y-38, savedMessage.frame.size.width, savedMessage.frame.size.height)];
                } completion:^(BOOL finished) {
                    if (finished)
                        savedMessage.hidden = YES;
                }];
            }
            [[NSUserDefaults standardUserDefaults] setValue:email.text forKey:@"babyQ_email"];
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *oldImagePath = [documentsDirectory stringByAppendingPathComponent:[prevEmail stringByAppendingString:@"_latest_photo.png"]];
            NSString *newImagePath = [documentsDirectory stringByAppendingPathComponent:[email.text stringByAppendingString:@"_latest_photo.png"]];
            [[NSFileManager defaultManager] removeItemAtPath:newImagePath error:nil];
            [[NSFileManager defaultManager] moveItemAtPath:oldImagePath toPath:newImagePath error:nil];
            
            prevEmail = email.text;
            AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
            appDelegate.user_email = email.text;
            [email resignFirstResponder];
            [password resignFirstResponder];
            [theNewPassword resignFirstResponder];
        }
    }else if (connection == changePasswordConnection)
    {
        NSString* json_response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSData* json_data = [json_response dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary* json_dictionary = [NSJSONSerialization JSONObjectWithData: json_data
                                                                        options: NSJSONReadingMutableContainers
                                                                          error: nil];
        if ([json_dictionary[@"VALID"] isEqualToString:@"Success"])
        {
            prevPassword = password.text;
            if (emailView.frame.size.height > 200)
            {
                [UIView animateWithDuration:0.5f animations:^{
                    [alertsView setFrame:CGRectMake(alertsView.frame.origin.x, alertsView.frame.origin.y - 107, alertsView.frame.size.width, alertsView.frame.size.height)];
                    [emailView setFrame:CGRectMake(emailView.frame.origin.x, emailView.frame.origin.y, emailView.frame.size.width, emailView.frame.size.height - 107)];
                }];
                savedMessage.hidden = NO;
                [savedMessage setFrame:CGRectMake(savedMessage.frame.origin.x, 64+scrollView.contentOffset.y, savedMessage.frame.size.width, savedMessage.frame.size.height)];
                [UIView animateWithDuration:3.0f animations:^{
                    [savedMessage setFrame:CGRectMake(savedMessage.frame.origin.x, savedMessage.frame.origin.y-38, savedMessage.frame.size.width, savedMessage.frame.size.height)];
                } completion:^(BOOL finished) {
                    if (finished)
                        savedMessage.hidden = YES;
                }];
            }
            [email resignFirstResponder];
            [password resignFirstResponder];
            [theNewPassword resignFirstResponder];
        }
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
}

-(IBAction)signOut
{
    // If the session state is any of the two "open" states when the button is clicked
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        
        // Close the session and remove the access token from the cache
        // The session state handler (in the app delegate) will be called automatically
        [FBSession.activeSession closeAndClearTokenInformation];
        
        // If the session state is not any of the two "open" states when the button is clicked
    }
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    
    Constants* constants = [[Constants alloc] init];
    NSString* user_email = [(AppDelegate *)[[UIApplication sharedApplication] delegate] user_email];
    NSString* registerDeviceURL = [[constants.HOST stringByAppendingString:constants.VERSION] stringByAppendingString:constants.SET_DEVICE_SETTINGS_PATH];
    NSString* postData = [[[@"ApiToken=" stringByAppendingString:appDelegate.api_token] stringByAppendingString:@"&Email="] stringByAppendingString:user_email];
    postData = [[postData stringByAppendingString:@"&IsActive=0&DailyTipNotification=&SurveyReminder=&DeviceId="] stringByAppendingString:[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:registerDeviceURL]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    setDeviceInactiveConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"babyQ_email"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"babyQ_api_token"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"babyQ_fb_profilePicture"];
    appDelegate.api_token = nil;
    appDelegate.fb_name = nil;
    appDelegate.fb_userId = nil;
    appDelegate.fb_name = nil;
    appDelegate.fb_birthday = nil;
    appDelegate.user_email = nil;
    appDelegate.fb_profilePicture = nil;
}

- (void)testInternetConnection
{
    Reachability* internetReachableFoo = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    // Internet is reachable
    internetReachableFoo.reachableBlock = ^(Reachability*reach)
    {
        internet = YES;
        offlineMessage.hidden = YES;
        email.enabled = YES;
        password.enabled = YES;
        dailyTipAlerts.enabled = YES;
        surveyAlerts.enabled = YES;
    };
    
    // Internet is not reachable
    internetReachableFoo.unreachableBlock = ^(Reachability*reach)
    {
        internet = NO;
        offlineMessage.hidden = NO;
        email.enabled = NO;
        password.enabled = NO;
        dailyTipAlerts.enabled = NO;
        surveyAlerts.enabled = NO;
    };
    
    [internetReachableFoo startNotifier];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
