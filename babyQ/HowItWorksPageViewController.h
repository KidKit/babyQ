//
//  HowItWorksViewController.h
//  babyQ
//
//  Created by Chris Wood on 6/16/14.
//  Copyright (c) 2014 babyQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SurveyViewController.h"
#import "Reachability.h"

@interface HowItWorksPageViewController : UIViewController <UIPageViewControllerDataSource,UIPageViewControllerDelegate>

@property (strong, nonatomic) UIPageViewController* pageViewController;
@property (strong, nonatomic) IBOutlet UIPageControl* pageControl;
@property (nonatomic, retain) IBOutlet UIButton* headerButton1;
@property (nonatomic, retain) IBOutlet UIButton* headerButton2;
@property (strong, nonatomic) NSArray* pageTitles;
@property (strong, nonatomic) NSArray* pageImages;
@property (strong, nonatomic) NSArray* pageTexts;

-(IBAction)startSurvey;
- (IBAction)openSideSwipeView;

@end
