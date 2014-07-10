//
//  ForgotPasswordViewController.h
//  babyQ
//
//  Created by Chris Wood on 7/8/14.
//  Copyright (c) 2014 babyQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomePageNavigationController.h"

@interface ForgotPasswordViewController : UIViewController

@property (nonatomic,retain) IBOutlet UILabel* forgotPassword;
@property (nonatomic,retain) IBOutlet UILabel* enterEmail;
@property (nonatomic,retain) IBOutlet UILabel* confirmSentMessage;
@property (nonatomic,retain) IBOutlet UITextField* emailField;
@property (nonatomic,retain) IBOutlet UIButton* cancelButton;
@property (nonatomic,retain) IBOutlet UIButton* resetButton;
@property (nonatomic,retain) IBOutlet UIButton* okButton;

- (IBAction)clickedCancel;
- (IBAction)clickedOK;
- (IBAction)clickedReset;

@end
