//
//  HowItWorksViewController.m
//  babyQ
//
//  Created by Chris Wood on 6/16/14.
//  Copyright (c) 2014 babyQ. All rights reserved.
//

#import "HowItWorksPageViewController.h"
#import "HowItWorksContentViewController.h"

@interface HowItWorksPageViewController ()

@end

@implementation HowItWorksPageViewController

@synthesize pageImages, pageTitles, pageControl;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    pageTitles = @[@"Over 200 Tips and Tricks", @"Discover Hidden Features", @"Bookmark Favorite Tip", @"Free Regular Update"];
    pageImages = @[@"babyq_cloud.png", @"babyq_cloud.png", @"babyq_cloud.png", @"babyq_cloud.png"];
    
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HowItWorksPageViewController"];
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    
    self.pageViewController.view.frame = CGRectMake(0, 71, self.view.frame.size.width, 517-71);
    
    HowItWorksContentViewController* startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    //pageControl.currentPage = 0;
    
}

- (HowItWorksContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.pageTitles count] == 0) || (index >= [self.pageTitles count])) {
        return nil;
    }
    
    HowItWorksContentViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Page"];
    pageContentViewController.imageFile = self.pageImages[index];
    pageContentViewController.titleText = self.pageTitles[index];
    pageContentViewController.pageIndex = index;
    
    return pageContentViewController;
}

- (void)pageViewController:(UIPageViewController *)pvc didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (!completed)
    {
        return;
    }
    pageControl.currentPage = ((HowItWorksContentViewController*) [previousViewControllers objectAtIndex:0]).pageIndex;
}


- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    
    NSUInteger index = ((HowItWorksContentViewController*) viewController).pageIndex;
    pageControl.currentPage = index;
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    
    NSUInteger index = ((HowItWorksContentViewController*) viewController).pageIndex;
    pageControl.currentPage = index;
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.pageTitles count]) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
}

- (IBAction)startSurvey
{
    UIStoryboard* surveyScreens = [UIStoryboard storyboardWithName:@"Survey" bundle:nil];
    SurveyViewController* surveyController = [surveyScreens instantiateInitialViewController];
    if (survey_json == nil)
        surveyController.question_number = @"1";
    else
        surveyController.question_number = [NSString stringWithFormat:@"%lu", [selected_answers count] + 1];
    [self.navigationController pushViewController:surveyController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
