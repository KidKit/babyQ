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
@property (nonatomic, retain) IBOutlet UILabel* dailyTipDate;
@property (nonatomic, retain) IBOutlet UILabel* todosDueDate;
@property (nonatomic, retain) IBOutlet UILabel* totalScoreBig;
@property (nonatomic, retain) IBOutlet UILabel* totalScoreSmall;
@property (nonatomic, retain) IBOutlet UILabel* lifestyleScore;
@property (nonatomic, retain) IBOutlet UILabel* nutritionScore;
@property (nonatomic, retain) IBOutlet UILabel* exerciseScore;
@property (nonatomic, retain) IBOutlet UILabel* stressScore;
@property (nonatomic, retain) IBOutlet UILabel *bigTotalLabel;
@property (nonatomic, retain) IBOutlet UILabel *smallTotalLabel;
@property (nonatomic, retain) IBOutlet UILabel *lifestyleLabel;
@property (nonatomic, retain) IBOutlet UILabel *exerciseLabel;
@property (nonatomic, retain) IBOutlet UILabel *nutritionLabel;
@property (nonatomic, retain) IBOutlet UILabel *stressLabel;
@property (nonatomic, retain) IBOutlet UIImageView* scoreSlider;
@property (nonatomic, retain) IBOutlet UITextView* workBlurb;
@property (nonatomic, retain) IBOutlet UILabel* delta;
@property (nonatomic, retain) IBOutlet UITextView* deltaBlurb;
@property (nonatomic, retain) IBOutlet UIView* todosView;
@property (nonatomic, retain) IBOutlet UILabel *goodWorkLabel;
@property (nonatomic, retain) IBOutlet UILabel *youImprovedLabel;
@property (nonatomic, retain) IBOutlet UIButton *tipHistoryButton;
@property (nonatomic, retain) IBOutlet UILabel *scrollDownLabel;
@property (nonatomic, retain) IBOutlet UIButton* completedTodosButton;
@property (nonatomic, retain) IBOutlet UITextView* dailyTip;
@property (nonatomic, retain) NSDictionary* currentScoreData;
@property (nonatomic, retain) NSArray* todosArray;

@property (nonatomic, retain) IBOutlet UIView* dailyTipView;

-(IBAction)startSurvey;
-(IBAction) getCompletedTodos;
-(IBAction)getTipHistory;
- (IBAction)toggleTodosAndDaily:(id)sender;

@end
