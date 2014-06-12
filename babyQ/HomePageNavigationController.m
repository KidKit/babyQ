//
//  HomePageNavigationController.m
//  babyQ
//
//  Created by Chris Wood on 6/11/14.
//  Copyright (c) 2014 babyQ. All rights reserved.
//

#import "HomePageNavigationController.h"

@interface HomePageNavigationController ()

@end

@implementation HomePageNavigationController


- (void)viewDidLoad
{
    [super viewDidLoad];
	UIStoryboard * homeScreens = [UIStoryboard storyboardWithName:@"HomePage" bundle:nil];
    SideSwipeTableViewController* sideSwipeTableView = [homeScreens instantiateViewControllerWithIdentifier:@"SideSwipeTableView"];
    
    CurrentScoreViewController* currentScoreView = [homeScreens instantiateViewControllerWithIdentifier:@"CurrentScoreView"];
    
    MMDrawerController * swipeController = [[MMDrawerController alloc]
                                             initWithCenterViewController:currentScoreView
                                             leftDrawerViewController:sideSwipeTableView
                                             rightDrawerViewController:nil];
    [swipeController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModePanningCenterView];
    [swipeController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeBezelPanningCenterView];
    
    [self pushViewController:swipeController animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
