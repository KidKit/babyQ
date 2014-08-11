//
//  MyProfileViewController.h
//  babyQ
//
//  Created by Chris Wood on 6/12/14.
//  Copyright (c) 2014 babyQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SurveyViewController.h"

@interface MyProfileViewController : UIViewController <UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, retain) IBOutlet UIScrollView* scrollView;

@property (nonatomic, retain) IBOutlet UILabel* offlineMessage;

@property (nonatomic, retain) IBOutlet UILabel* headerLabel;
@property (nonatomic, retain) IBOutlet UILabel* statusBarWhiteBG;
@property (nonatomic, retain) IBOutlet UIButton* headerButton1;
@property (nonatomic, retain) IBOutlet UIButton* headerButton2;

@property (nonatomic, retain) IBOutlet UILabel* savedMessage;

@property (nonatomic, retain) IBOutlet UILabel* nameLabel;
@property (nonatomic, retain) IBOutlet UILabel* birthdayLabel;
@property (nonatomic, retain) IBOutlet UILabel* zipCodeLabel;
@property (nonatomic, retain) IBOutlet UILabel* isPregnantLabel;
@property (nonatomic, retain) IBOutlet UILabel* dueDateLabel;
@property (nonatomic, retain) IBOutlet UILabel* wasDeliveredLabel;
@property (nonatomic, retain) IBOutlet UILabel* deliveredDateLabel;
@property (nonatomic, retain) IBOutlet UILabel* babyWeightLabel;
@property (nonatomic, retain) IBOutlet UILabel* babyLengthLabel;

@property (nonatomic, retain) IBOutlet UIView* aboutMeView;
@property (nonatomic, retain) IBOutlet UITextField* nameField;
@property (nonatomic, retain) IBOutlet UITextField* dobField;
@property (nonatomic, retain) IBOutlet UITextField* zipCodeField;
@property (nonatomic, retain) IBOutlet UIButton* profilePicture;
@property (nonatomic, retain) IBOutlet UIImageView* cameraImage;
@property (nonatomic, retain) IBOutlet UIButton* saveAboutMeButton;
@property (nonatomic, retain) IBOutlet UIButton* cancelAboutMeButton;

@property (nonatomic, retain) IBOutlet UIView* pregnancyView;
@property (nonatomic, retain) IBOutlet UIButton* savePregnantButton;
@property (nonatomic, retain) IBOutlet UIButton* cancelPregnantButton;
@property (nonatomic, retain) IBOutlet UISwitch* isPregnant;
@property (nonatomic, retain) IBOutlet UITextField* dueDateField;

@property (nonatomic, retain) IBOutlet UIView* deliveredView;
@property (nonatomic, retain) IBOutlet UIButton* saveDeliveryButton;
@property (nonatomic, retain) IBOutlet UIButton* cancelDeliveryButton;
@property (nonatomic, retain) IBOutlet UISwitch* wasDelivered;
@property (nonatomic, retain) IBOutlet UITextField* deliveryDateField;
@property (nonatomic, retain) IBOutlet UITextField* babyWeightField;
@property (nonatomic, retain) IBOutlet UITextField* babyLengthField;

-(IBAction)startSurvey;
- (IBAction)openSideSwipeView;

-(IBAction)getPhoto;
-(IBAction)saveAboutMeFields;
-(IBAction)cancelEditingAboutMeFields;

-(IBAction)savePregnantFields;
-(IBAction)cancelEditingPregnantFields;

-(IBAction)saveDeliveryFields;
-(IBAction)cancelEditingDeliveryFields;

@end
