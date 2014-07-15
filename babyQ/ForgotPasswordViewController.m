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

NSURLConnection* forgotPasswordConnection;

@synthesize forgotPassword,enterEmail,emailField,cancelButton,resetButton,confirmSentMessage,okButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
    forgotPassword.font = [UIFont fontWithName:@"MyriadPro-Semibold" size:18];
    enterEmail.font = [UIFont fontWithName:@"MyriadPro-Regular" size:14];
    confirmSentMessage.font = [UIFont fontWithName:@"MyriadPro-Regular" size:14];
    cancelButton.titleLabel.font = [UIFont fontWithName:@"MyriadPro-Regular" size:18];
    resetButton.titleLabel.font = [UIFont fontWithName:@"MyriadPro-Semibold" size:18];
    okButton.titleLabel.font = [UIFont fontWithName:@"MyriadPro-Semibold" size:18];
    
    confirmSentMessage.hidden = YES;
    okButton.hidden = YES;
}

- (IBAction)clickedCancel
{
    HomePageNavigationController* nav = (HomePageNavigationController*) self.presentingViewController;
    [nav dismissViewControllerAnimated:YES completion:nil];
    nav.view.userInteractionEnabled = YES;
}

- (IBAction)clickedOK
{
    HomePageNavigationController* nav = (HomePageNavigationController*) self.presentingViewController;
    [nav dismissViewControllerAnimated:YES completion:nil];
    nav.view.userInteractionEnabled = YES;
}

- (IBAction)clickedReset
{
    NSString* email = emailField.text;
    Constants* constants = [[Constants alloc] init];
    NSString* loginURL = [[constants.HOST stringByAppendingString:constants.VERSION] stringByAppendingString:constants.FORGOT_PASSWORD_PATH];
    NSString* postData = [@"Email=" stringByAppendingString:email];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:loginURL]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    forgotPasswordConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data
{
    NSString* json_response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSData* json_data = [json_response dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary* json_dictionary = [NSJSONSerialization JSONObjectWithData: json_data
                                                                    options: NSJSONReadingMutableContainers
                                                                      error: nil];
    if ([json_dictionary[@"VALID"] isEqualToString:@"An email has been sent to your account with instructions on how to reset your password!"])
    {
        enterEmail.hidden = YES;
        forgotPassword.hidden = YES;
        emailField.hidden = YES;
        cancelButton.hidden = YES;
        resetButton.hidden = YES;
        okButton.hidden = NO;
        confirmSentMessage.hidden = NO;
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
