//
//  HowItWorksViewController.h
//  babyQ
//
//  Created by Chris Wood on 6/16/14.
//  Copyright (c) 2014 babyQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HowItWorksPageViewController : UIViewController <UIPageViewControllerDataSource,UIPageViewControllerDelegate>

@property (strong, nonatomic) UIPageViewController* pageViewController;
@property (strong, nonatomic) IBOutlet UIPageControl* pageControl;
@property (strong, nonatomic) NSArray* pageTitles;
@property (strong, nonatomic) NSArray* pageImages;

@end
