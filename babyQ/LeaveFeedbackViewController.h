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
@property (nonatomic,retain) IBOutlet UIButton* kudos;
@property (nonatomic,retain) IBOutlet UIButton* suggestions;
@property (nonatomic,retain) IBOutlet UIButton* errors;

-(IBAction)clickedKudos:(UIButton*)sender;
-(IBAction)clickedSuggestions:(UIButton*)sender;
-(IBAction)clickedErrors:(UIButton*)sender;
- (IBAction)sendFeedback;

@end
