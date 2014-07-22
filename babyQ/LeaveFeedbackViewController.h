//
//  LeaveFeedbackViewController.h
//  babyQ
//
//  Created by Chris Wood on 6/13/14.
//  Copyright (c) 2014 babyQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface LeaveFeedbackViewController : UIViewController <MFMailComposeViewControllerDelegate,UITextFieldDelegate>

@property (nonatomic,retain) IBOutlet UITextView* feedbackTextView;
@property (nonatomic,retain) IBOutlet UIBarButtonItem* sendFeedbackButton;
@property (nonatomic,retain) IBOutlet UITabBar* tabBar;

- (IBAction)sendFeedback;

@end
