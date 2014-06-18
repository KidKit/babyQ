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

@property (nonatomic, retain) IBOutlet UILabel* scoreLabel;
@property (nonatomic, retain) IBOutlet UIScrollView* scrollView;
@property (nonatomic, retain) IBOutlet UIView* todosView;
@property (nonatomic, retain) IBOutlet UIView* dailyTipView;

-(IBAction) getCompletedTodos;
- (IBAction)getTipHistory;
- (IBAction)toggleTodosAndDaily:(id)sender;
-(IBAction)startSurvey;

@end
