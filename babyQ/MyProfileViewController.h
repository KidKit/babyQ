//
//  MyProfileViewController.h
//  babyQ
//
//  Created by Chris Wood on 6/12/14.
//  Copyright (c) 2014 babyQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SurveyViewController.h"

@interface MyProfileViewController : UIViewController

@property (nonatomic, retain) IBOutlet UIScrollView* scrollView;

-(IBAction)startSurvey;

@end
