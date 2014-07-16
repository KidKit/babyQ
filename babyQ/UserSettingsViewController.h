//
//  UserSettingsViewController.h
//  babyQ
//
//  Created by Chris Wood on 6/13/14.
//  Copyright (c) 2014 babyQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>

@interface UserSettingsViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, retain) IBOutlet UIScrollView* scrollView;

@property (nonatomic,retain) IBOutlet UITextField* email;
@property (nonatomic,retain) IBOutlet UITextField* password;
@property (nonatomic, retain) IBOutlet UIImageView* profilePicture;
@property (nonatomic, retain) IBOutlet UIButton* saveAccountButton;
@property (nonatomic, retain) IBOutlet UIButton* cancelAccountButton;
@property (nonatomic,retain) IBOutlet UIButton* editAccountButton;

@property (nonatomic,retain) IBOutlet UISwitch* surveyAlerts;
@property (nonatomic,retain) IBOutlet UISwitch* dailyTipAlerts;
@property (nonatomic,retain) IBOutlet UIButton* rateAppLink;

-(IBAction)editAccountFields;
-(IBAction)saveAccountFields;
-(IBAction)cancelAccountFields;

-(IBAction)toggleSurveyAlerts:(id)sender;
-(IBAction)toggleDailyTipAlerts:(id)sender;

-(IBAction)openAppStore;

-(IBAction)signOut;

@end
