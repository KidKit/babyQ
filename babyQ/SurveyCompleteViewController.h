//
//  SurveyCompleteViewController.h
//  babyQ
//
//  Created by Chris Wood on 8/5/14.
//  Copyright (c) 2014 babyQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SurveyViewController.h"

@class SurveyViewController;
@interface SurveyCompleteViewController : UIViewController

@property (nonatomic, retain) IBOutlet UIImageView* background;
@property (nonatomic, retain) IBOutlet UILabel* surveyCompleteHeader;
@property (nonatomic, retain) IBOutlet UILabel* thankYouMessage;
@property (nonatomic, retain) IBOutlet UIButton* okButton;
@property (nonatomic, retain) SurveyViewController* presentingSurvey;

-(IBAction)okPressed;

@end
