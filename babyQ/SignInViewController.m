//
//  SignInViewController.m
//  babyQ
//
//  Created by Chris Wood on 6/13/14.
//  Copyright (c) 2014 babyQ. All rights reserved.
//

#import "SignInViewController.h"
@interface SignInViewController ()

@end

@implementation SignInViewController

@synthesize email,password,errorMessage;

NSURLConnection* registerDeviceConnection;
NSURLConnection* signInConnection;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.backItem.title = @"";
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:120.0/255.0f green:120.0/255.0f blue:120.0/255.0f alpha:1.0f];
    self.navigationController.navigationBar.topItem.title = @"";
    self.navigationItem.title = @"SIGN IN";
    
    email.font = [UIFont fontWithName:@"MyriadPro-Semibold" size:14];
    email.delegate = self;

    password.font = [UIFont fontWithName:@"MyriadPro-Semibold" size:14];
    password.delegate = self;
    
    errorMessage.textColor = [UIColor redColor];
    errorMessage.font = [UIFont fontWithName:@"MyriadPro-Semibold" size:14];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

-(void) viewDidAppear:(BOOL)animated
{
    self.navigationItem.title = @"SIGN IN";
}

-(void)dismissKeyboard {
    [email resignFirstResponder];
    [password resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    errorMessage.text = @"";
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data
{
    if (connection == signInConnection)
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
            appDelegate.user_email = self.email.text;
            appDelegate.fb_profilePicture = nil;
            [[NSUserDefaults standardUserDefaults] setValue:appDelegate.user_email forKey:@"babyQ_email"];
            [[NSUserDefaults standardUserDefaults] setValue:appDelegate.api_token forKey:@"babyQ_api_token"];
            
            Constants* constants = [[Constants alloc] init];
            NSString* registerDeviceURL = [[constants.HOST stringByAppendingString:constants.VERSION] stringByAppendingString:constants.REGISTER_DEVICE_PATH];
            NSString* postData = [[[@"ApiToken=" stringByAppendingString:appDelegate.api_token] stringByAppendingString:@"&Email="] stringByAppendingString:appDelegate.user_email];
            postData = [[postData stringByAppendingString:@"&IsActive=1&DeviceId="] stringByAppendingString:[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
            postData = [postData stringByAppendingString:@"&DeviceToken="];
            
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:registerDeviceURL]];
            [request setHTTPMethod:@"POST"];
            [request setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
            registerDeviceConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            
            UIStoryboard * homeScreens = [UIStoryboard storyboardWithName:@"HomePage" bundle:nil];
            SideSwipeTableViewController* sideSwipeTableView = [homeScreens instantiateViewControllerWithIdentifier:@"SideSwipeTableView"];
            
            CurrentScoreViewController* currentScoreView = [homeScreens instantiateViewControllerWithIdentifier:@"CurrentScoreView"];
            
            MMDrawerController * swipeController = [[MMDrawerController alloc]
                                                    initWithCenterViewController:currentScoreView
                                                    leftDrawerViewController:sideSwipeTableView
                                                    rightDrawerViewController:nil];
            [swipeController setMaximumLeftDrawerWidth:262];
            [swipeController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeBezelPanningCenterView];
            [swipeController setShowsShadow:NO];
            
            [self.navigationController pushViewController:swipeController animated:YES];
        } else
        {
            errorMessage.text = @"Email/Password combination invalid";
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
- (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
}

- (BOOL) validateFields
{
    if (![self validateEmail:self.email.text])
    {
        errorMessage.text = @"Invalid email address";
        return NO;
    }
    else if ([self.password.text length] < 6)
    {
        errorMessage.text = @"Password too short";
        return NO;
    }
    return YES;
}

- (IBAction) signIn
{
    if ([self validateFields])
    {
        NSString* em = self.email.text;
        NSString* pwd = self.password.text;
        Constants* constants = [[Constants alloc] init];
        NSString* loginURL = [[constants.HOST stringByAppendingString:constants.VERSION] stringByAppendingString:constants.LOGIN_PATH];
        NSString* postData = [[[@"Email=" stringByAppendingString:em] stringByAppendingString:@"&Password="] stringByAppendingString:pwd];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:loginURL]];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
        signInConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    }
}

- (IBAction)forgotPassword
{
    UIStoryboard* forgotPasswordStoryboard = [UIStoryboard storyboardWithName:@"ForgotPassword" bundle:nil];
    UIViewController* forgotPasswordForm = [forgotPasswordStoryboard instantiateInitialViewController];
    forgotPasswordForm.modalPresentationStyle = UIModalPresentationFullScreen;
    forgotPasswordForm.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
    
    self.navigationController.modalPresentationStyle = UIModalPresentationCurrentContext;
    self.navigationController.view.userInteractionEnabled = NO;
    [self.navigationController presentViewController:forgotPasswordForm animated:YES completion:^(){
        //[forgotPasswordForm.view setFrame:CGRectMake(10, 100, 300, 150)];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
