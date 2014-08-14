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

@synthesize settingsTableView,headerButton1,headerButton2;

- (void)viewDidLoad
{
    [super viewDidLoad];
    headerButton1.imageEdgeInsets = UIEdgeInsetsMake(12, 12, 12, 12);
    headerButton2.imageEdgeInsets = UIEdgeInsetsMake(12, 12, 12, 12);
}

- (void) viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
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
    cell.textLabel.font = [UIFont fontWithName:@"MyriadPro-Regular" size:13];
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
    [cell.textLabel setFont:[UIFont fontWithName:@"MyriadPro-Regular" size:16]];
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
    // Dispose of any resources that can be recreated.
}
@end
