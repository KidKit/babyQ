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
         [appDelegate sessionStateChanged:session state:state error:error];
         if ([[(AppDelegate *)[UIApplication sharedApplication].delegate user_email] length] != 0)
         {
             SignInViewController* signInViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SignIn"];
             signInViewController.fb_email = [(AppDelegate *)[UIApplication sharedApplication].delegate user_email];
             [self.navigationController pushViewController:signInViewController animated:YES];
         }
     }];
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
