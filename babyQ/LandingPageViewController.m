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

NSURLConnection *fbLoginConnection;

- (void)viewDidLoad
{
    [super viewDidLoad];
        
}

- (void) viewWillAppear:(BOOL)animated
{
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
             
             appDelegate.user_email = [user objectForKey:@"email"];
             appDelegate.fb_userId = [user objectForKey:@"id"];
             NSLog(@"FB user birthday:%@",user.birthday);
             NSLog(@"email id:%@",[user objectForKey:@"email"]);
         
         if ([[(AppDelegate *)[UIApplication sharedApplication].delegate user_email] length] != 0)
         {
             NSString* email = [(AppDelegate *)[UIApplication sharedApplication].delegate user_email];
             NSString* fb_id = [(AppDelegate *)[UIApplication sharedApplication].delegate fb_userId];
             Constants* constants = [[Constants alloc] init];
             NSString* loginURL = [[constants.HOST stringByAppendingString:constants.VERSION] stringByAppendingString:constants.FACEBOOK_LOGIN_PATH];
             NSString* postData = [[[@"Email=" stringByAppendingString:email] stringByAppendingString:@"&FacebookId="] stringByAppendingString:fb_id];
             NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:loginURL]];
             [request setHTTPMethod:@"POST"];
             [request setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
             fbLoginConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
         }
        }];
    }];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data
{
    NSLog(@"received data facebook sign in");
    NSString* json_response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSData* json_data = [json_response dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary* json_dictionary = [NSJSONSerialization JSONObjectWithData: json_data
                                                                    options: NSJSONReadingMutableContainers
                                                                      error: nil];
    if ([json_dictionary[@"VALID"] isEqualToString:@"Success"])
    {
        AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        appDelegate.api_token = json_dictionary[@"API TOKEN"];
        
        if (true /*[json_dictionary[@"IsNewUser"] isEqualToString:@"1"]*/)
        {
            JoinViewController* joinViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Join"];
            joinViewController.fb_email = [(AppDelegate *)[UIApplication sharedApplication].delegate user_email];
            
            [self.navigationController pushViewController:joinViewController animated:YES];
        }
        else
        {
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
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"ERROR");
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"finished loading facebook sign in");
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
