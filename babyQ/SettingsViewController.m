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
    [cell.textLabel setFont:[UIFont fontWithName:@"MyriadPro-Regular" size:15]];
    [cell.textLabel setTextColor:[UIColor darkGrayColor]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0: // Settings
        {
            UIViewController* settings = [self.storyboard instantiateViewControllerWithIdentifier:@"UserSettings"];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
