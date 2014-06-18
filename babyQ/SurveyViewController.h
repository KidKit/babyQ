//
//  SurveyViewController.h
//  babyQ
//
//  Created by Chris Wood on 6/12/14.
//  Copyright (c) 2014 babyQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SideSwipeTableViewController.h"

@interface SurveyViewController : UIViewController <UIAlertViewDelegate>

@property (nonatomic, retain) IBOutlet UIScrollView* scrollView;
@property (nonatomic, retain) IBOutlet UIProgressView* progressView;
@property (nonatomic, retain) IBOutlet UIImageView* progressBubble;
@property (nonatomic, retain) IBOutlet UILabel* questionNumber;
@property (nonatomic, retain) IBOutlet UILabel* answerNumber;
@property (nonatomic, retain) IBOutlet UITextView* question;
@property (nonatomic, retain) IBOutlet UITextView* answerOne;
@property (nonatomic, retain) IBOutlet UIButton* checkBoxOne;
@property (nonatomic, retain) IBOutlet UIButton* nextButton;
@property (nonatomic, retain) IBOutlet UIImageView* bottomDivider;

@property (nonatomic,retain) NSDictionary* survey_json;
@property (nonatomic,retain) NSString* question_number;
@property (nonatomic, retain) NSMutableArray* answer_ids;
@property (nonatomic, retain) NSMutableDictionary* selected_answers;

- (IBAction)nextQuestion;

@end
