//
//  SurveyViewController.h
//  babyQ
//
//  Created by Chris Wood on 6/12/14.
//  Copyright (c) 2014 babyQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SideSwipeTableViewController.h"
#import "StopSurveyViewController.h"
#import "SurveyCompleteViewController.h"

extern NSDictionary* survey_json;
extern NSMutableDictionary* selected_answers;

@interface SurveyViewController : UIViewController <UIAlertViewDelegate>

@property (nonatomic, retain) IBOutlet UIScrollView* scrollView;
@property (weak, nonatomic) IBOutlet UILabel *surveyHeaderLabel;
@property (nonatomic, retain) IBOutlet UIProgressView* progressView;
@property (nonatomic, retain) IBOutlet UIImageView* progressBubble;
@property (nonatomic, retain) IBOutlet UILabel* progressPercentage;
@property (nonatomic, retain) IBOutlet UILabel* questionType;
@property (nonatomic, retain) IBOutlet UITextView* question;
@property (nonatomic, retain) IBOutlet UITextView* answerOne;
@property (nonatomic, retain) IBOutlet UIButton* checkBoxOne;
@property (nonatomic, retain) IBOutlet UIView* bottomNavView;
@property (nonatomic, retain) IBOutlet UIButton* nextButton;
@property (nonatomic, retain) IBOutlet UIButton* previousButton;

@property (nonatomic, retain) NSMutableData* survey_data;
@property (nonatomic,retain) NSString* question_number;
@property (nonatomic,retain) NSString* question_type;
@property (nonatomic, retain) NSMutableArray* answer_ids;

- (IBAction)nextQuestion;
- (IBAction)previousQuestion;
-(void) stopSurvey;
-(void) submitSurvey;

@end
