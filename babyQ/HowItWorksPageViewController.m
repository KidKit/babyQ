//
//  HowItWorksViewController.m
//  babyQ
//
//  Created by Chris Wood on 6/16/14.
//  Copyright (c) 2014 babyQ. All rights reserved.
//

#import "HowItWorksPageViewController.h"
#import "HowItWorksContentViewController.h"

#define slide1Title @"How prepared are you for a healthy pregnancy?"
#define slide2Title @"Get Scored"
#define slide3Title @"Track your progress"
#define slide4Title @"Get started today"

#define slide1Body @"BabyQ is a pregnancy coach to track, manage and monitor the progress of your pregnancy."
#define slide2Body  @"Know where your pregnancy health stands with the babyQ score."
#define slide3Body  @"Be able to track and monitor your progress with our recommended personalized to do list."
#define slide4Body  @"You and your baby deserve a healthy start. Let babyQ help unlock your potential to have a healthy pregnancy today."

@interface HowItWorksPageViewController ()

@end

@implementation HowItWorksPageViewController

@synthesize pageImages, pageTitles, pageTexts, pageControl,headerButton1,headerButton2;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    headerButton1.imageEdgeInsets = UIEdgeInsetsMake(4, 4, 4, 4);
    headerButton2.imageEdgeInsets = UIEdgeInsetsMake(4, 4, 4, 4);
    
    pageTitles = @[slide1Title, slide2Title, slide3Title, slide4Title];
    pageTexts = @[slide1Body,slide2Body,slide3Body,slide4Body];
    pageImages = @[@"babyq_cloud.png", @"babyq_cloud.png", @"babyq_cloud.png", @"babyq_cloud.png"];
    
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HowItWorksPageViewController"];
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    
    self.pageViewController.view.frame = CGRectMake(0, 71, self.view.frame.size.width, 568-70);
    
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
    pageContentViewController.pageText = self.pageTexts[index];
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

- (IBAction)openSideSwipeView
{
    [(MMDrawerController* )self.navigationController.topViewController openDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (IBAction)startSurvey
{
    UIStoryboard* surveyScreens = [UIStoryboard storyboardWithName:@"Survey" bundle:nil];
    SurveyViewController* surveyController = [surveyScreens instantiateInitialViewController];
    if (survey_json == nil)
    {
        surveyController.question_number = @"1";
        surveyController.question_type = @"Multiple Choice";
    }
    else
    {
        if (extraQuestionsReached)
        {
            NSString* question_number = [NSString stringWithFormat:@"%lu", [selected_extra_answers count]+1];
            NSString* question_key = [[survey_json[@"ExtraQuestions"] allKeys] objectAtIndex:([question_number intValue]-1)];
            surveyController = [surveyScreens instantiateViewControllerWithIdentifier:@"SurveyQuestion"];
            NSString* type = survey_json[@"ExtraQuestions"][question_key][@"QuestionTypeDescription"];
            surveyController.question_number = question_number;
            surveyController.question_type = type;
        }
        else
        {
            surveyController.question_number = [NSString stringWithFormat:@"%lu", [selected_answers count] + 1];
            surveyController.question_type = @"Multiple Choice";
        }
    }
    [self.navigationController pushViewController:surveyController animated:YES];
}

- (void)testInternetConnection
{
    Reachability* internetReachableFoo = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    // Internet is reachable
    internetReachableFoo.reachableBlock = ^(Reachability*reach)
    {
        headerButton2.enabled = YES;
    };
    
    // Internet is not reachable
    internetReachableFoo.unreachableBlock = ^(Reachability*reach)
    {
        headerButton2.enabled = NO;
    };
    
    [internetReachableFoo startNotifier];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
