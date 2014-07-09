//
//  ForgotPasswordViewController.m
//  babyQ
//
//  Created by Chris Wood on 7/8/14.
//  Copyright (c) 2014 babyQ. All rights reserved.
//

#import "ForgotPasswordViewController.h"

@interface ForgotPasswordViewController ()

@end

@implementation ForgotPasswordViewController

@synthesize forgotPassword,enterEmail,emailField,cancelButton,resetButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
    forgotPassword.font = [UIFont fontWithName:@"MyriadPro-Semibold" size:18];
    enterEmail.font = [UIFont fontWithName:@"MyriadPro-Regular" size:14];
    cancelButton.titleLabel.font = [UIFont fontWithName:@"MyriadPro-Regular" size:18];
    resetButton.titleLabel.font = [UIFont fontWithName:@"MyriadPro-Semibold" size:18];
}

- (IBAction)clickedCancel
{
    HomePageNavigationController* nav = (HomePageNavigationController*) self.presentingViewController;
    [nav dismissViewControllerAnimated:YES completion:nil];
    nav.view.userInteractionEnabled = YES;
}

- (IBAction)clickedReset
{
    NSString* email = emailField.text;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
