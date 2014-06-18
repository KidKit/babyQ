//
//  CurrentScoreViewController.h
//  babyQ
//
//  Created by Chris Wood on 6/11/14.
//  Copyright (c) 2014 babyQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SurveyViewController.h"


@interface CurrentScoreViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic, retain) IBOutlet UIScrollView* scrollView;
@property (nonatomic, retain) IBOutlet UIView* todosView;
@property (nonatomic, retain) IBOutlet UIView* dailyTipView;

-(IBAction)startSurvey:(id)sender;
-(IBAction) getCompletedTodos;
-(IBAction)getTipHistory;
- (IBAction)toggleTodosAndDaily:(id)sender;

@end
