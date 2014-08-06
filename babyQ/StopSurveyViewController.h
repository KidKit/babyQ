//
//  StopSurveyViewController.h
//  babyQ
//
//  Created by Chris Wood on 8/5/14.
//  Copyright (c) 2014 babyQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SurveyViewController.h"
#import "HomePageNavigationController.h"

@class SurveyViewController;
@interface StopSurveyViewController : UIViewController

@property (nonatomic, retain) IBOutlet UIImageView* background;
@property (nonatomic, retain) IBOutlet UILabel* message;
@property (nonatomic, retain) IBOutlet UIButton* yesButton;
@property (nonatomic, retain) IBOutlet UIButton* noButton;
@property (nonatomic, retain) SurveyViewController* presentingSurvey;

-(IBAction)yesPressed;
-(IBAction)noPressed;

@end
