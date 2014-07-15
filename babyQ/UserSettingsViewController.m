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

@synthesize scrollView,profilePicture,email,password,saveAccountButton,cancelAccountButton,editAccountButton;

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
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:@"latest_photo.png"];
        
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
    // If the session state is any of the two "open" states when the button is clicked
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        
        // Close the session and remove the access token from the cache
        // The session state handler (in the app delegate) will be called automatically
        [FBSession.activeSession closeAndClearTokenInformation];
        
        // If the session state is not any of the two "open" states when the button is clicked
    }
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    appDelegate.api_token = nil;
    appDelegate.fb_name = nil;
    appDelegate.fb_userId = nil;
    appDelegate.fb_name = nil;
    appDelegate.fb_birthday = nil;
    appDelegate.user_email = nil;
    appDelegate.fb_profilePicture = nil;
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
