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

UIActivityIndicatorView *spinner;
NSURLConnection* forgotPasswordConnection;

@synthesize forgotPassword,enterEmail,emailField,cancelButton,resetButton,confirmSentMessage,okButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
    forgotPassword.font = [UIFont fontWithName:@"MyriadPro-Semibold" size:19];
    enterEmail.font = [UIFont fontWithName:@"MyriadPro-Regular" size:15];
    confirmSentMessage.font = [UIFont fontWithName:@"MyriadPro-Regular" size:15];
    cancelButton.titleLabel.font = [UIFont fontWithName:@"MyriadPro-Regular" size:19];
    resetButton.titleLabel.font = [UIFont fontWithName:@"MyriadPro-Semibold" size:19];
    okButton.titleLabel.font = [UIFont fontWithName:@"MyriadPro-Semibold" size:19];
    
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
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.center = CGPointMake(160, 120);
    spinner.hidesWhenStopped = YES;
    [self.view addSubview:spinner];
    [spinner startAnimating];
    
    NSString* email = emailField.text;
    Constants* constants = [[Constants alloc] init];
    NSString* loginURL = [[constants.HOST stringByAppendingString:constants.VERSION] stringByAppendingString:constants.FORGOT_PASSWORD_PATH];
    NSString* postData = [@"Email=" stringByAppendingString:email];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:loginURL]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    forgotPasswordConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}

- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data
{
    NSString* json_response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSData* json_data = [json_response dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary* json_dictionary = [NSJSONSerialization JSONObjectWithData: json_data
                                                                    options: NSJSONReadingMutableContainers
                                                                      error: nil];
    if ([json_dictionary[@"VALID"] isEqualToString:@"A request to reset your password was successfully sent. Check your email for instructions."])
    {
        enterEmail.hidden = YES;
        forgotPassword.hidden = YES;
        emailField.hidden = YES;
        cancelButton.hidden = YES;
        resetButton.hidden = YES;
        okButton.hidden = NO;
        confirmSentMessage.hidden = NO;
    } else {
        enterEmail.hidden = YES;
        forgotPassword.hidden = YES;
        emailField.hidden = YES;
        cancelButton.hidden = YES;
        resetButton.hidden = YES;
        okButton.hidden = NO;
        confirmSentMessage.hidden = NO;
        confirmSentMessage.text = @"This email does not exist in our system.";
    }
    [spinner stopAnimating];
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
