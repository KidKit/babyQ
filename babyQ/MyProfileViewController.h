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

@property (nonatomic, retain) IBOutlet UILabel* aboutMeHeader;
@property (nonatomic, retain) IBOutlet UILabel* pregnancyHeader;
@property (nonatomic, retain) IBOutlet UILabel* deliveryHeader;


@property (nonatomic, retain) IBOutlet UIView* aboutMeView;
@property (nonatomic, retain) IBOutlet UITextField* nameField;
@property (nonatomic, retain) IBOutlet UITextField* zipCodeField;
@property (nonatomic, retain) IBOutlet UITextField* birthdayField;
@property (nonatomic, retain) IBOutlet UIButton* profilePicture;
@property (nonatomic, retain) IBOutlet UIImageView* cameraImage;
@property (nonatomic, retain) IBOutlet UIButton* saveAboutMeButton;
@property (nonatomic, retain) IBOutlet UIButton* cancelAboutMeButton;

@property (nonatomic, retain) IBOutlet UIView* pregnancyView;
@property (nonatomic, retain) IBOutlet UIButton* savePregnantButton;
@property (nonatomic, retain) IBOutlet UIButton* cancelPregnantButton;
@property (nonatomic, retain) IBOutlet UILabel* yesPregnant;
@property (nonatomic, retain) IBOutlet UILabel* noPregnant;
@property (nonatomic, retain) IBOutlet UIButton* yesPregnantButton;
@property (nonatomic, retain) IBOutlet UIButton* noPregnantButton;
@property (nonatomic, retain) IBOutlet UIDatePicker* dueDate;
@property (nonatomic, retain) IBOutlet UITextField* dueDateField;

@property (nonatomic, retain) IBOutlet UIView* deliveredView;
@property (nonatomic, retain) IBOutlet UIButton* saveDeliveryButton;
@property (nonatomic, retain) IBOutlet UIButton* cancelDeliveryButton;
@property (nonatomic, retain) IBOutlet UIDatePicker* birthday;
@property (nonatomic, retain) IBOutlet UILabel* babyLengthLabel;
@property (nonatomic, retain) IBOutlet UILabel* babyWeightLabel;
@property (nonatomic, retain) IBOutlet UITextField* babyPoundsField;
@property (nonatomic, retain) IBOutlet UITextField* babyOuncesField;
@property (nonatomic, retain) IBOutlet UITextField* babyInchesField;
@property (nonatomic, retain) IBOutlet UILabel* deliveredDateLabel;
@property (nonatomic, retain) IBOutlet UIDatePicker* deliveryDate;
@property (nonatomic, retain) IBOutlet UITextField* deliveryDateField;
@property (nonatomic, retain) IBOutlet UILabel* babyPoundsLabel;
@property (nonatomic, retain) IBOutlet UILabel* babyOuncesLabel;
@property (nonatomic, retain) IBOutlet UILabel* babyInchesLabel;
@property (nonatomic, retain) IBOutlet UILabel* birthTypeLabel;
@property (nonatomic, retain) IBOutlet UILabel* yesDeliveredLabel;
@property (nonatomic, retain) IBOutlet UILabel* noDeliveredLabel;
@property (nonatomic, retain) IBOutlet UIButton* yesDelivered;
@property (nonatomic, retain) IBOutlet UIButton* noDelivered;
@property (nonatomic, retain) IBOutlet UIButton* vaginalButton;
@property (nonatomic, retain) IBOutlet UIButton* cSectionButton;
@property (nonatomic, retain) IBOutlet UILabel* vaginalLabel;
@property (nonatomic, retain) IBOutlet UILabel* cSectionLabel;
@property (nonatomic, retain) IBOutlet UILabel* complicationsLabel;
@property (nonatomic, retain) IBOutlet UILabel* complication1Label;
@property (nonatomic, retain) IBOutlet UILabel* complication2Label;
@property (nonatomic, retain) IBOutlet UILabel* complication3Label;
@property (nonatomic, retain) IBOutlet UILabel* complication4Label;
@property (nonatomic, retain) IBOutlet UILabel* complication5Label;
@property (nonatomic, retain) IBOutlet UILabel* complication6Label;
@property (nonatomic, retain) IBOutlet UIButton* complication1Button;
@property (nonatomic, retain) IBOutlet UIButton* complication2Button;
@property (nonatomic, retain) IBOutlet UIButton* complication3Button;
@property (nonatomic, retain) IBOutlet UIButton* complication4Button;
@property (nonatomic, retain) IBOutlet UIButton* complication5Button;
@property (nonatomic, retain) IBOutlet UIButton* complication6Button;

-(IBAction)startSurvey;
- (IBAction)openSideSwipeView;

-(IBAction)getPhoto;
-(IBAction)saveAboutMeFields;
-(IBAction)cancelEditingAboutMeFields;

-(IBAction)savePregnantFields;
-(IBAction)cancelEditingPregnantFields;

-(IBAction)saveDeliveryFields;
-(IBAction)cancelEditingDeliveryFields;

-(IBAction)clickedDelivered:(UIButton*)sender;
-(IBAction)clickedBirthType:(UIButton*)sender;
-(IBAction)clickedComplication:(UIButton*)sender;
@end
