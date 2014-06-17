//
//  SurveyViewController.h
//  babyQ
//
//  Created by Chris Wood on 6/12/14.
//  Copyright (c) 2014 babyQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SurveyViewController : UIViewController

@property (nonatomic, retain) IBOutlet UIScrollView* scrollView;
@property (nonatomic, retain) IBOutlet UIProgressView* progressView;
@property (nonatomic, retain) IBOutlet UIImageView* progressBubble;
@property (nonatomic, retain) IBOutlet UILabel* questionNumber;
@property (nonatomic, retain) IBOutlet UILabel* answerNumber;
@property (nonatomic, retain) IBOutlet UITextView* question;
@property (nonatomic, retain) IBOutlet UITextView* answerOne;
@property (nonatomic, retain) IBOutlet UITextView* answerTwo;
@property (nonatomic, retain) IBOutlet UITextView* answerThree;
@property (nonatomic, retain) IBOutlet UITextView* answerFour;


@end