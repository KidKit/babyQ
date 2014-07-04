//
//  JoinViewController.h
//  babyQ
//
//  Created by Chris Wood on 6/13/14.
//  Copyright (c) 2014 babyQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SideSwipeTableViewController.h"
#import "AppDelegate.h"

@interface JoinViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, retain) IBOutlet UIScrollView* scrollView;
@property (nonatomic, retain) IBOutlet UIImageView* background;
@property (nonatomic,retain) IBOutlet UIButton* joinButton;
@property (nonatomic,retain) IBOutlet UITextField* email;
@property (nonatomic,retain) IBOutlet UITextField* password;
@property (nonatomic,retain) IBOutlet UITextField* zipcode;

@property (nonatomic,retain) IBOutlet UILabel* currentlyPregnantLabel;
@property (nonatomic,retain) IBOutlet UILabel* yesLabel;
@property (nonatomic,retain) IBOutlet UILabel* noLabel;
@property (nonatomic,retain) IBOutlet UIButton* yesButton;
@property (nonatomic,retain) IBOutlet UIButton* noButton;
@property (nonatomic,retain) IBOutlet UIButton* termsCheckbox;
@property (nonatomic,retain) IBOutlet UILabel* termsLabelText;
@property (nonatomic,retain) IBOutlet UIButton* termsLabelLink;

@property (nonatomic,retain) IBOutlet UILabel* whenDueLabel;

@property (nonatomic, retain) IBOutlet UIDatePicker* datePicker;

- (IBAction)clickedYes:(id)sender;
- (IBAction)clickedNo:(id)sender;
- (IBAction)clickedTermsCheckbox:(id)sender;
- (IBAction)clickedTermsLink:(id)sender;
- (IBAction)clickedJoin;

@end
