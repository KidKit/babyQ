//
//  SettingsViewController.h
//  babyQ
//
//  Created by Chris Wood on 6/13/14.
//  Copyright (c) 2014 babyQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SurveyViewController.h"

@interface SettingsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) IBOutlet UITableView* settingsTableView;
@property (nonatomic, retain) IBOutlet UIButton* headerButton2;

- (IBAction)openSideSwipeView;
-(IBAction)startSurvey;

@end
