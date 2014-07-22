//
//  LeaveFeedbackViewController.m
//  babyQ
//
//  Created by Chris Wood on 6/13/14.
//  Copyright (c) 2014 babyQ. All rights reserved.
//

#import "LeaveFeedbackViewController.h"

@interface LeaveFeedbackViewController ()

@end

@implementation LeaveFeedbackViewController

@synthesize feedbackTextView,sendFeedbackButton,tabBar;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
}

-(void) viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.backItem.title = @"";
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:120.0/255.0f green:120.0/255.0f blue:120.0/255.0f alpha:1.0f];
    self.navigationController.navigationBar.topItem.title = @"LEAVE FEEDBACK";
    self.navigationController.navigationBar.topItem.rightBarButtonItem = sendFeedbackButton;
    
    [sendFeedbackButton setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"MyriadPro-Semibold" size:14.0]} forState:UIControlStateNormal];
    sendFeedbackButton.title = @"SUBMIT";
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (void) keyboardDidShow:(NSNotification *) notif
{
    [feedbackTextView setFrame:CGRectMake(feedbackTextView.frame.origin.x, feedbackTextView.frame.origin.y, feedbackTextView.frame.size.width, feedbackTextView.frame.size.height - 200)];
}

- (void)keyboardDidHide: (NSNotification *) notif
{
    [feedbackTextView setFrame:CGRectMake(feedbackTextView.frame.origin.x, feedbackTextView.frame.origin.y, feedbackTextView.frame.size.width, feedbackTextView.frame.size.height + 200)];
}

- (IBAction)sendFeedback
{
    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    if ([MFMailComposeViewController canSendMail])
    {
        switch (0/*selected tab*/) {
            case 0:
                [controller setToRecipients:[NSArray arrayWithObject:@"support@babyq.com"]];
                break;
            case 1:
                [controller setToRecipients:[NSArray arrayWithObject:@"support@babyq.com"]];
                break;
            case 2:
                [controller setToRecipients:[NSArray arrayWithObject:@"support@babyq.com"]];
                break;
            default:
                break;
        }
    }
    [controller setSubject:@"BabyQ Feedback"];
    [controller setMessageBody:feedbackTextView.text isHTML:NO];
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
