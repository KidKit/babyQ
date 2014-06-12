//
//  SideSwipeTableViewController.m
//  babyQ
//
//  Created by Chris Wood on 6/11/14.
//  Copyright (c) 2014 babyQ. All rights reserved.
//

#import "SideSwipeTableViewController.h"

@interface SideSwipeTableViewController ()

@end

@implementation SideSwipeTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SideSwipeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SideSwipeCell"];
    switch (indexPath.row) {
        case 0:
            [cell.imageView setImage:[UIImage imageNamed:@"babyq_menu_currentscore_icon.png"]];
            [cell.textLabel setText:@"Current Score"];
            break;
        case 1:
            [cell.imageView setImage:[UIImage imageNamed:@"babyq_menu_score_progress_icon.png"]];
            [cell.textLabel setText:@"Score Progress"];
            break;
        case 2:
            [cell.imageView setImage:[UIImage imageNamed:@"babyq_menu_to-dos_icon.png"]];
            [cell.textLabel setText:@"To-Dos"];
            break;
        case 3:
            [cell.imageView setImage:[UIImage imageNamed:@"babyq_menu_how-to_icon.png"]];
            [cell.textLabel setText:@"How It Works"];
            break;
        case 4:
            [cell.imageView setImage:[UIImage imageNamed:@"babyq_menu_my_profile_icon.png"]];
            [cell.textLabel setText:@"My Profile"];
            break;
        case 5:
            [cell.imageView setImage:[UIImage imageNamed:@"babyq_menu_settigns_icon.png"]];
            [cell.textLabel setText:@"Settings & More"];
            break;
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0: // Current score
        {
            UIStoryboard * homeScreens = [UIStoryboard storyboardWithName:@"HomePage" bundle:nil];
            SideSwipeTableViewController* sideSwipeTableView = [homeScreens instantiateViewControllerWithIdentifier:@"SideSwipeTableView"];
            
            CurrentScoreViewController* currentScoreView = [homeScreens instantiateViewControllerWithIdentifier:@"CurrentScoreView"];
            
            MMDrawerController * swipeController = [[MMDrawerController alloc]
                                                    initWithCenterViewController:currentScoreView
                                                    leftDrawerViewController:sideSwipeTableView
                                                    rightDrawerViewController:nil];
            [swipeController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModePanningCenterView];
            [swipeController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeBezelPanningCenterView];
            
            [self.navigationController pushViewController:swipeController animated:YES];
            break;
        }
        case 1: // Score progress
            break;
        case 2: // To-Dos
            break;
        case 3: // How it works
            break;
        case 4: // My Profile
        {
            UIStoryboard * homeScreens = [UIStoryboard storyboardWithName:@"HomePage" bundle:nil];
            SideSwipeTableViewController* sideSwipeTableView = [homeScreens instantiateViewControllerWithIdentifier:@"SideSwipeTableView"];
            
            UIStoryboard * myProfileScreens = [UIStoryboard storyboardWithName:@"MyProfile" bundle:nil];
            UIViewController* myProfileViewController = [myProfileScreens instantiateInitialViewController];
            
            MMDrawerController * swipeController = [[MMDrawerController alloc]
                                                    initWithCenterViewController:myProfileViewController
                                                    leftDrawerViewController:sideSwipeTableView
                                                    rightDrawerViewController:nil];
            swipeController = [[MMDrawerController alloc]
                                                    initWithCenterViewController:myProfileViewController
                                                    leftDrawerViewController:sideSwipeTableView
                                                    rightDrawerViewController:nil];
            
            [swipeController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModePanningCenterView];
            [swipeController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeBezelPanningCenterView];
            
            [self.navigationController pushViewController:swipeController animated:YES];
            
            break;
        }
        case 5: // Settings & more
        {
            UIStoryboard * homeScreens = [UIStoryboard storyboardWithName:@"HomePage" bundle:nil];
            SideSwipeTableViewController* sideSwipeTableView = [homeScreens instantiateViewControllerWithIdentifier:@"SideSwipeTableView"];
            
            UIStoryboard * settingsScreens = [UIStoryboard storyboardWithName:@"Settings" bundle:nil];
            UIViewController* settingsViewController = [settingsScreens instantiateInitialViewController];
            
            MMDrawerController * swipeController = [[MMDrawerController alloc]
                                                    initWithCenterViewController:settingsViewController
                                                    leftDrawerViewController:sideSwipeTableView
                                                    rightDrawerViewController:nil];
            swipeController = [[MMDrawerController alloc]
                               initWithCenterViewController:settingsViewController
                               leftDrawerViewController:sideSwipeTableView
                               rightDrawerViewController:nil];
            
            [swipeController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModePanningCenterView];
            [swipeController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeBezelPanningCenterView];
            
            [self.navigationController pushViewController:swipeController animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
