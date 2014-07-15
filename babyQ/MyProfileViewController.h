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

@property (nonatomic, retain) IBOutlet UITextField* nameField;
@property (nonatomic, retain) IBOutlet UITextField* dobField;
@property (nonatomic, retain) IBOutlet UITextField* zipCodeField;
@property (nonatomic, retain) IBOutlet UIButton* profilePicture;
@property (nonatomic, retain) IBOutlet UIImageView* cameraImage;
@property (nonatomic, retain) IBOutlet UIButton* editAboutMeButton;
@property (nonatomic, retain) IBOutlet UIButton* saveAboutMeButton;
@property (nonatomic, retain) IBOutlet UIButton* cancelAboutMeButton;

@property (nonatomic, retain) IBOutlet UIButton* editPregnantButton;
@property (nonatomic, retain) IBOutlet UIButton* savePregnantButton;
@property (nonatomic, retain) IBOutlet UIButton* cancelPregnantButton;
@property (nonatomic, retain) IBOutlet UISwitch* isPregnant;
@property (nonatomic, retain) IBOutlet UITextField* dueDateField;

@property (nonatomic, retain) IBOutlet UIButton* editDeliveryButton;
@property (nonatomic, retain) IBOutlet UIButton* saveDeliveryButton;
@property (nonatomic, retain) IBOutlet UIButton* cancelDeliveryButton;
@property (nonatomic, retain) IBOutlet UISwitch* wasDelivered;
@property (nonatomic, retain) IBOutlet UITextField* deliveryDateField;
@property (nonatomic, retain) IBOutlet UITextField* babyWeightField;
@property (nonatomic, retain) IBOutlet UITextField* babyLengthField;

-(IBAction)startSurvey;

-(IBAction)getPhoto;
-(IBAction)editAboutMeFields;
-(IBAction)saveAboutMeFields;
-(IBAction)cancelEditingAboutMeFields;

-(IBAction)editPregnantFields;
-(IBAction)savePregnantFields;
-(IBAction)cancelEditingPregnantFields;

-(IBAction)editDeliveryFields;
-(IBAction)saveDeliveryFields;
-(IBAction)cancelEditingDeliveryFields;

@end
