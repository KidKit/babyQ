//
//  GetScoreViewController.h
//  babyQ
//
//  Created by Chris Wood on 7/2/14.
//  Copyright (c) 2014 babyQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CurrentScoreViewController.h"
#import "SurveyViewController.h"
#import "HomePageNavigationController.h"

@interface GetScoreViewController : UIViewController

@property (nonatomic, retain) IBOutlet UITextView* updateBlurb;

- (IBAction)updateScore;

@end
