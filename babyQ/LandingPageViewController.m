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
