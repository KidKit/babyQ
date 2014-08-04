//
//  LandingPageViewController.m
//  babyQ
//
//  Created by Chris Wood on 6/13/14.
//  Copyright (c) 2014 babyQ. All rights reserved.
//

#import "LandingPageViewController.h"

@interface LandingPageViewController ()

@end

@implementation LandingPageViewController

@synthesize headerLabel;

NSURLConnection* fbLoginConnection;
NSURLConnection* fbSaveDataConnection;
NSURLConnection* registerDeviceConnection;

- (void)viewDidLoad
{
    [super viewDidLoad];
    headerLabel.font = [UIFont fontWithName:@"MyriadPro-Regular" size:14];
}

- (void) viewWillAppear:(BOOL)animated
{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"babyQ_email"] length] > 0)
    {
        AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
        appDelegate.user_email = [[NSUserDefaults standardUserDefaults] objectForKey:@"babyQ_email"];
        appDelegate.api_token = [[NSUserDefaults standardUserDefaults] objectForKey:@"babyQ_api_token"];
        appDelegate.fb_profilePicture = [[NSUserDefaults standardUserDefaults] objectForKey:@"babyQ_fb_profilePicture"];
        
        UIStoryboard * homeScreens = [UIStoryboard storyboardWithName:@"HomePage" bundle:nil];
        SideSwipeTableViewController* sideSwipeTableView = [homeScreens instantiateViewControllerWithIdentifier:@"SideSwipeTableView"];
        
        CurrentScoreViewController* currentScoreView = [homeScreens instantiateViewControllerWithIdentifier:@"CurrentScoreView"];
        
        MMDrawerController * swipeController = [[MMDrawerController alloc]
                                                initWithCenterViewController:currentScoreView
                                                leftDrawerViewController:sideSwipeTableView
                                                rightDrawerViewController:nil];
        [swipeController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeBezelPanningCenterView];
        [swipeController setShowsShadow:NO];
        [self.navigationController pushViewController:swipeController animated:YES];
    }
    if ([self.restorationIdentifier isEqualToString:@"SignInJoin"])
    {
        self.navigationController.navigationBarHidden = NO;
        self.navigationController.navigationBar.backItem.title = @"";
        self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:120.0/255.0f green:120.0/255.0f blue:120.0/255.0f alpha:1.0f];
        self.navigationController.navigationBar.topItem.title = @"SIGN IN OR JOIN";
    }
    else
        self.navigationController.navigationBarHidden = YES;
}

- (IBAction)loginWithFacebook:(id)sender
{
    // Open a session showing the user the login UI
    // You must ALWAYS ask for public_profile permissions when opening a session
    [FBSession openActiveSessionWithReadPermissions:@[@"public_profile,user_birthday,email,user_location"]
                                       allowLoginUI:YES
                                  completionHandler:
     ^(FBSession *session, FBSessionState state, NSError *error) {
         
         // Retrieve the app delegate
         AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
         // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
         [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
             
             if (user)
             {
                 appDelegate.user_email = [user objectForKey:@"email"];
                 appDelegate.fb_userId = [user objectForKey:@"id"];
                 appDelegate.fb_birthday = user.birthday;
                 appDelegate.fb_name = user.name;
                 appDelegate.fb_profilePicture = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", [user objectID]];
                 
                 [[NSUserDefaults standardUserDefaults] setObject:appDelegate.fb_profilePicture forKey:@"babyQ_fb_profilePicture"];
                 
                 
                 if ([[(AppDelegate *)[UIApplication sharedApplication].delegate user_email] length] != 0)
                 {
                     NSString* email = [(AppDelegate *)[UIApplication sharedApplication].delegate user_email];
                     NSString* fb_id = [(AppDelegate *)[UIApplication sharedApplication].delegate fb_userId];
                     Constants* constants = [[Constants alloc] init];
                     NSString* facebookLoginURL = [[constants.HOST stringByAppendingString:constants.VERSION] stringByAppendingString:constants.FACEBOOK_LOGIN_PATH];
                     NSString* postData = [[[@"Email=" stringByAppendingString:email] stringByAppendingString:@"&FacebookId="] stringByAppendingString:fb_id];
                     NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:facebookLoginURL]];
                     [request setHTTPMethod:@"POST"];
                     [request setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
                     fbLoginConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
                 }
             }
        }];
    }];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data
{
    if (connection == fbLoginConnection)
    {
        NSString* json_response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSData* json_data = [json_response dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary* json_dictionary = [NSJSONSerialization JSONObjectWithData: json_data
                                                                        options: NSJSONReadingMutableContainers
                                                                          error: nil];
        if ([json_dictionary[@"VALID"] isEqualToString:@"Success"])
        {
            AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            appDelegate.api_token = json_dictionary[@"API TOKEN"];
            
            if ([json_dictionary[@"IsNewUser"] isEqualToString:@"1"])
            {
                JoinViewController* joinViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Join"];
                joinViewController.fb_email = [(AppDelegate *)[UIApplication sharedApplication].delegate user_email];
                joinViewController.fb_profilePicture = [(AppDelegate *)[UIApplication sharedApplication].delegate fb_profilePicture];
                [self.navigationController pushViewController:joinViewController animated:YES];
            }
            else
            {
                Constants* constants = [[Constants alloc] init];
                NSString* em = [(AppDelegate *)[UIApplication sharedApplication].delegate user_email];
                NSString* api_token = [(AppDelegate *)[[UIApplication sharedApplication] delegate] api_token];
                NSString* fb_name = [(AppDelegate *)[[UIApplication sharedApplication] delegate] fb_name];
                NSString* pushDataURL = [[constants.HOST stringByAppendingString:constants.VERSION] stringByAppendingString:constants.SET_ABOUT_ME_PATH];
                NSString* postData = [[[@"ApiToken=" stringByAppendingString:api_token] stringByAppendingString:@"&Email="] stringByAppendingString:em];
                
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"MM/dd/yyyy"];
                NSDate* fb_bday = [dateFormatter dateFromString:[(AppDelegate *)[[UIApplication sharedApplication] delegate] fb_birthday]];
                if (fb_bday != nil && fb_bday != (id)[NSNull null])
                {
                    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    NSString* formatted_bday =  [dateFormatter stringFromDate:fb_bday];
                    postData = [[postData stringByAppendingString:@"&Birthdate="] stringByAppendingString:formatted_bday];
                } else
                    postData = [[postData stringByAppendingString:@"&Birthdate="] stringByAppendingString:@""];
                
                if ([fb_name length] > 0)
                    postData = [[postData stringByAppendingString:@"&Name="] stringByAppendingString:fb_name];
                else
                    postData = [[postData stringByAppendingString:@"&Name="] stringByAppendingString:@""];
                
                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:pushDataURL]];
                [request setHTTPMethod:@"POST"];
                [request setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
                fbSaveDataConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
                
                NSString* registerDeviceURL = [[constants.HOST stringByAppendingString:constants.VERSION] stringByAppendingString:constants.REGISTER_DEVICE_PATH];
                postData = [[[@"ApiToken=" stringByAppendingString:appDelegate.api_token] stringByAppendingString:@"&Email="] stringByAppendingString:appDelegate.user_email];
                NSString* deviceUUID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
                postData = [[postData stringByAppendingString:@"&IsActive=1&DeviceId="] stringByAppendingString:deviceUUID];
                postData = [postData stringByAppendingString:@"&DeviceToken="];
                
                request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:registerDeviceURL]];
                [request setHTTPMethod:@"POST"];
                [request setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
                registerDeviceConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
                
                [[NSUserDefaults standardUserDefaults] setValue:em forKey:@"babyQ_email"];
                [[NSUserDefaults standardUserDefaults] setValue:api_token forKey:@"babyQ_api_token"];
                
                UIStoryboard * homeScreens = [UIStoryboard storyboardWithName:@"HomePage" bundle:nil];
                SideSwipeTableViewController* sideSwipeTableView = [homeScreens instantiateViewControllerWithIdentifier:@"SideSwipeTableView"];
                
                CurrentScoreViewController* currentScoreView = [homeScreens instantiateViewControllerWithIdentifier:@"CurrentScoreView"];
                
                MMDrawerController * swipeController = [[MMDrawerController alloc]
                                                        initWithCenterViewController:currentScoreView
                                                        leftDrawerViewController:sideSwipeTableView
                                                        rightDrawerViewController:nil];
                [swipeController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeBezelPanningCenterView];
                [swipeController setShowsShadow:NO];
                [self.navigationController pushViewController:swipeController animated:YES];
            }
        }
    } else if (connection == registerDeviceConnection)
    {
        NSString* json_response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSData* json_data = [json_response dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary* json_dictionary = [NSJSONSerialization JSONObjectWithData: json_data
                                                                        options: NSJSONReadingMutableContainers
                                                                          error: nil];
        if ([json_dictionary[@"VALID"] isEqualToString:@"Success"])
        {
            NSLog(@"Registered device");
        }
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
}

- (IBAction)pushSignInJoinScreen
{
    LandingPageViewController* signInJoin = [self.storyboard instantiateViewControllerWithIdentifier:@"SignInJoin"];
    [self.navigationController pushViewController:signInJoin animated:YES];
}

- (IBAction)signIn:(id)sender
{
    SignInViewController* signInViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SignIn"];
    [self.navigationController pushViewController:signInViewController animated:YES];
}

- (IBAction)join:(id)sender
{
    JoinViewController* joinViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Join"];
    [self.navigationController pushViewController:joinViewController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
