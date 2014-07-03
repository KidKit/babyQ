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

@synthesize scrollView,email,password,saveAccountButton,cancelAccountButton,editAccountButton;

NSString* prevEmail;
NSString* prevPassword;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.scrollView setContentSize:CGSizeMake(320, 651)];
    [self.scrollView setBackgroundColor:[UIColor whiteColor]];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.backItem.title = @"";
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationController.navigationBar.topItem.title = @"SETTINGS";
    
    email.font = [UIFont fontWithName:@"MyriadPro-Semibold" size:14];
    email.delegate = self;
    password.font = [UIFont fontWithName:@"MyriadPro-Semibold" size:14];
    password.delegate = self;
    
    saveAccountButton.hidden = YES;
    cancelAccountButton.hidden = YES;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

-(IBAction)editAccountFields
{
    prevEmail = email.text;
    prevPassword = password.text;
    email.userInteractionEnabled = YES;
    password.userInteractionEnabled = YES;
    editAccountButton.enabled = NO;
    saveAccountButton.hidden = NO;
    cancelAccountButton.hidden = NO;
}

-(IBAction)saveAccountFields
{
    email.userInteractionEnabled = NO;
    password.userInteractionEnabled = NO;
    editAccountButton.enabled = YES;
    saveAccountButton.hidden = YES;
    cancelAccountButton.hidden = YES;
}

-(IBAction)cancelAccountFields
{
    email.text = prevEmail;
    password.text = prevPassword;
    email.userInteractionEnabled = NO;
    password.userInteractionEnabled = NO;
    editAccountButton.enabled = YES;
    saveAccountButton.hidden = YES;
    cancelAccountButton.hidden = YES;
}

-(IBAction)signOut
{
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
