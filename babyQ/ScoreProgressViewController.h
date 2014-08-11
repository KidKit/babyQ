//
//  ScoreProgressViewController.h
//  babyQ
//
//  Created by Chris Wood on 6/16/14.
//  Copyright (c) 2014 babyQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScoreProgressGraphView.h"
#import "SurveyViewController.h"

@interface ScoreProgressViewController : UIViewController

@property (nonatomic, retain) IBOutlet UILabel* offlineMessage;

@property (nonatomic, retain) IBOutlet UILabel* scoreLabel;
@property (nonatomic, retain) IBOutlet UIScrollView* scrollView;
@property (nonatomic, retain) IBOutlet UILabel* headerLabel;
@property (nonatomic, retain) IBOutlet UILabel* statusBarWhiteBG;
@property (nonatomic, retain) IBOutlet UIButton* headerButton1;
@property (nonatomic, retain) IBOutlet UIButton* headerButton2;
@property (nonatomic, retain) IBOutlet UILabel* scoreDate;
@property (nonatomic, retain) IBOutlet UILabel* totalScoreBig;
@property (nonatomic, retain) IBOutlet UILabel* lifestyleScore;
@property (nonatomic, retain) IBOutlet UILabel* nutritionScore;
@property (nonatomic, retain) IBOutlet UILabel* exerciseScore;
@property (nonatomic, retain) IBOutlet UILabel* stressScore;

@property (nonatomic, retain) ScoreProgressGraphView* graphView;

@property (nonatomic, retain) IBOutlet UILabel *bigTotalLabel;
@property (nonatomic, retain) IBOutlet UILabel *lifestyleLabel;
@property (nonatomic, retain) IBOutlet UILabel *exerciseLabel;
@property (nonatomic, retain) IBOutlet UILabel *nutritionLabel;
@property (nonatomic, retain) IBOutlet UILabel *stressLabel;

@property (nonatomic, retain) IBOutlet UILabel *goodWorkLabel;

@property (nonatomic, retain) IBOutlet UILabel* dailyTipDate;
@property (nonatomic, retain) IBOutlet UILabel* todosDueDate;
@property (nonatomic, retain) IBOutlet UIView* todosView;
@property (nonatomic, retain) IBOutlet UIView* dailyTipView;
@property (nonatomic, retain) NSMutableData* scoreHistoryData;
@property (nonatomic, retain) NSArray* scoreHistoryArray;
@property (nonatomic, retain) IBOutlet UITextView* dailyTip;
@property (nonatomic, retain) IBOutlet UIButton *tipHistoryButton;
@property (nonatomic, retain) NSMutableData* todosData;
@property (nonatomic, retain) NSArray* todosArray;
@property (nonatomic, retain) IBOutlet UIButton* completedTodosButton;

- (IBAction)openSideSwipeView;
-(IBAction) getCompletedTodos;
- (IBAction)getTipHistory;
- (IBAction)toggleTodosAndDaily:(id)sender;
-(IBAction)startSurvey;

@end
