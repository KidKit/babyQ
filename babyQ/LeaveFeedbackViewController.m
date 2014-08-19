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

@synthesize feedbackTextView,sendFeedbackButton,kudos,suggestions,errors,offlineMessage,sentMessage;

int selected_tab;
bool internet;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self testInternetConnection];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    kudos.tintColor = [UIColor colorWithRed:100.0/255.0f green:100.0/255.0f blue:100.0/255.0f alpha:1.0f];
    suggestions.tintColor = [UIColor colorWithRed:100.0/255.0f green:100.0/255.0f blue:100.0/255.0f alpha:1.0f];
    errors.tintColor = [UIColor colorWithRed:100.0/255.0f green:100.0/255.0f blue:100.0/255.0f alpha:1.0f];
    kudos.titleLabel.font = [UIFont fontWithName:@"MyriadPro-Semibold" size:15];
    suggestions.titleLabel.font = [UIFont fontWithName:@"MyriadPro-Semibold" size:15];
    errors.titleLabel.font = [UIFont fontWithName:@"MyriadPro-Semibold" size:15];
    
    sentMessage.hidden = YES;
    sentMessage.font = [UIFont fontWithName:@"MyriadPro-Regular" size:14];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    [self clickedKudos:kudos];
}

-(void)dismissKeyboard {
    [feedbackTextView resignFirstResponder];
}

-(void) viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.backItem.title = @"";
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:120.0/255.0f green:120.0/255.0f blue:120.0/255.0f alpha:1.0f];
    self.navigationController.navigationBar.topItem.title = @"LEAVE FEEDBACK";
    self.navigationController.navigationBar.topItem.rightBarButtonItem = sendFeedbackButton;
    
    [sendFeedbackButton setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"MyriadPro-Semibold" size:15.0]} forState:UIControlStateNormal];
    sendFeedbackButton.title = @"SUBMIT";
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (void) keyboardDidShow:(NSNotification *) notif
{
    [feedbackTextView setFrame:CGRectMake(feedbackTextView.frame.origin.x, feedbackTextView.frame.origin.y, feedbackTextView.frame.size.width, feedbackTextView.frame.size.height - 200)];
    if ([feedbackTextView.text isEqualToString:@"Questions/Comments"])
        feedbackTextView.text = @"";
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
        switch (selected_tab) {
            case 0:
                [controller setToRecipients:[NSArray arrayWithObject:@"support@babyq.com"]];
                [controller setSubject:@"BabyQ Kudos"];
                break;
            case 1:
                [controller setToRecipients:[NSArray arrayWithObject:@"support@babyq.com"]];
                [controller setSubject:@"BabyQ Suggestions"];
                break;
            case 2:
                [controller setToRecipients:[NSArray arrayWithObject:@"support@babyq.com"]];
                [controller setSubject:@"BabyQ Errors"];
                break;
            default:
                break;
        }
    }
    [controller setMessageBody:feedbackTextView.text isHTML:NO];
    [self presentViewController:controller animated:YES completion:nil];
}

-(IBAction)clickedKudos:(UIButton*)sender
{
    selected_tab = 0;
    [sender setBackgroundImage:[UIImage imageNamed:@"babyq_feedback_tab.png"] forState:UIControlStateNormal];
    [suggestions setBackgroundImage:nil forState:UIControlStateNormal];
    [errors setBackgroundImage:nil forState:UIControlStateNormal];
}

-(IBAction)clickedSuggestions:(UIButton*)sender
{
    selected_tab = 1;
    [sender setBackgroundImage:[UIImage imageNamed:@"babyq_feedback_tab.png"] forState:UIControlStateNormal];
    [kudos setBackgroundImage:nil forState:UIControlStateNormal];
    [errors setBackgroundImage:nil forState:UIControlStateNormal];
}

-(IBAction)clickedErrors:(UIButton*)sender
{
    selected_tab = 2;
    [sender setBackgroundImage:[UIImage imageNamed:@"babyq_feedback_tab.png"] forState:UIControlStateNormal];
    [suggestions setBackgroundImage:nil forState:UIControlStateNormal];
    [kudos setBackgroundImage:nil forState:UIControlStateNormal];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
    if (result == MFMailComposeResultSent || result == MFMailComposeResultSaved)
    {
        sentMessage.hidden = NO;
        [sentMessage setFrame:CGRectMake(sentMessage.frame.origin.x, 64, sentMessage.frame.size.width, sentMessage.frame.size.height)];
        [UIView animateWithDuration:3.0f animations:^{
            [sentMessage setFrame:CGRectMake(sentMessage.frame.origin.x, sentMessage.frame.origin.y-38, sentMessage.frame.size.width, sentMessage.frame.size.height)];
        } completion:^(BOOL finished) {
            if (finished)
                sentMessage.hidden = YES;
        }];
        feedbackTextView.text = @"Questions/Comments";
    }
}

- (void)testInternetConnection
{
    Reachability* internetReachableFoo = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    // Internet is reachable
    internetReachableFoo.reachableBlock = ^(Reachability*reach)
    {
        internet = YES;
        offlineMessage.hidden = YES;
        sendFeedbackButton.enabled = YES;
    };
    
    // Internet is not reachable
    internetReachableFoo.unreachableBlock = ^(Reachability*reach)
    {
        internet = NO;
        offlineMessage.hidden = NO;
        sendFeedbackButton.enabled = NO;
    };
    
    [internetReachableFoo startNotifier];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
