//
//  CurrentScoreViewController.h
//  babyQ
//
//  Created by Chris Wood on 6/11/14.
//  Copyright (c) 2014 babyQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SurveyViewController.h"
#import "Constants.h"
#import "AppDelegate.h"


@interface CurrentScoreViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic, retain) IBOutlet UIScrollView* scrollView;
@property (nonatomic, retain) IBOutlet UILabel* todaysDate;
@property (nonatomic, retain) IBOutlet UILabel* totalScoreBig;
@property (nonatomic, retain) IBOutlet UILabel* totalScoreSmall;
@property (nonatomic, retain) IBOutlet UILabel* lifestyleScore;
@property (nonatomic, retain) IBOutlet UILabel* nutritionScore;
@property (nonatomic, retain) IBOutlet UILabel* exerciseScore;
@property (nonatomic, retain) IBOutlet UILabel* stressScore;
@property (nonatomic, retain) IBOutlet UITextView* workBlurb;
@property (nonatomic, retain) IBOutlet UILabel* delta;
@property (nonatomic, retain) IBOutlet UITextView* deltaBlurb;
@property (nonatomic, retain) IBOutlet UIView* todosView;
@property (nonatomic, retain) IBOutlet UIView* dailyTipView;

-(IBAction)startSurvey;
-(IBAction) getCompletedTodos;
-(IBAction)getTipHistory;
- (IBAction)toggleTodosAndDaily:(id)sender;

@end
