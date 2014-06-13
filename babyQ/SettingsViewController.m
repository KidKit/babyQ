//
//  SettingsViewController.m
//  babyQ
//
//  Created by Chris Wood on 6/13/14.
//  Copyright (c) 2014 babyQ. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

@synthesize settingsTableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void) viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont
                                                                           fontWithName:@"Bebas" size:14], NSFontAttributeName,
                                [UIColor blackColor], NSForegroundColorAttributeName, nil];
    [[UINavigationBar appearance] setTitleTextAttributes:attributes];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init]; //[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    switch (indexPath.row) {
        case 0:
        {
            cell.textLabel.text = @"Settings";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
        case 1:
        {
            cell.textLabel.text = @"About Us";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
        case 2:
        {
            cell.textLabel.text = @"Leave Feedback";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
        case 3:
        {
            cell.textLabel.text = @"Privacy Policy";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
        case 4:
        {
            cell.textLabel.text = @"Terms of Use";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
            
        default:
            break;
    }
    
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0: // Settings
        {
            UIViewController* settings = [self.storyboard instantiateViewControllerWithIdentifier:@"UserSettings"];
            self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"NEW TITLE" style:UIBarButtonItemStylePlain target:nil action:nil];
            [self.navigationController pushViewController:settings animated:YES];
            break;
        }
        case 1: // About Us
        {
            UIViewController* aboutUs = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutUs"];
            [self.navigationController pushViewController:aboutUs animated:YES];
            break;
        }
        case 2: // Leave Feedback
        {
            UIViewController* leaveFeedback = [self.storyboard instantiateViewControllerWithIdentifier:@"LeaveFeedback"];
            [self.navigationController pushViewController:leaveFeedback animated:YES];
            break;
        }
        case 3: // Privacy Policy
        {
            UIViewController* privacyPolicy = [self.storyboard instantiateViewControllerWithIdentifier:@"PrivacyPolicy"];
            [self.navigationController pushViewController:privacyPolicy animated:YES];
            break;
        }
        case 4: // Terms of Use
        {
            UIViewController* termsOfUse = [self.storyboard instantiateViewControllerWithIdentifier:@"TermsOfUse"];
            [self.navigationController pushViewController:termsOfUse animated:YES];
            break;
        }
    }
}
@end
