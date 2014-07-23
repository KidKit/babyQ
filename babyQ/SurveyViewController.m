//
//  SurveyViewController.m
//  babyQ
//
//  Created by Chris Wood on 6/12/14.
//  Copyright (c) 2014 babyQ. All rights reserved.
//

#import "SurveyViewController.h"

@interface SurveyViewController ()

@end

NSDictionary* survey_json = nil;
NSMutableDictionary* selected_answers = nil;
NSMutableDictionary* selected_extra_answers = nil;
BOOL extraQuestionsReached = NO;

@implementation SurveyViewController

@synthesize scrollView,surveyHeaderLabel,progressView,progressBubble,progressPercentage,questionType,question,selectAllLabel,answerOne,checkBoxOne,nextButton,previousButton,bottomDivider,question_number,question_type,survey_data,answer_ids;

NSURLConnection* getSurveyConnection;
NSURLConnection* submitSurveyConnection;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.scrollView setBackgroundColor:[UIColor whiteColor]];
    
    surveyHeaderLabel.font = [UIFont fontWithName:@"Bebas" size:18];
    questionType.font = [UIFont fontWithName:@"MyriadPro-Bold" size:12];
    
    CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 3.0f);
    progressView.transform = transform;
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.backItem.title = @"";
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:120.0/255.0f green:120.0/255.0f blue:120.0/255.0f alpha:1.0f];
    
    UIButton *backButtonInternal = [[UIButton alloc] initWithFrame:CGRectMake(0,0,24,24)];
    [backButtonInternal setBackgroundImage:[UIImage imageNamed:@"babyq_survey_x.png"] forState:UIControlStateNormal];
    [backButtonInternal addTarget:self action:@selector(cancelSurvey) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButtonInternal];
    
    [[self navigationItem] setLeftBarButtonItem:backBarButton];
    if (!extraQuestionsReached)
    {
        if (selected_answers == nil)
            selected_answers = [[NSMutableDictionary alloc] init];
        answer_ids = [[NSMutableArray alloc] init];
        questionType.text = [question_type uppercaseString];
        if ([question_number isEqualToString:@"1"])
            previousButton.hidden = YES;
        nextButton.enabled = NO;
        
        if (survey_json == nil)
        {   survey_data = [[NSMutableData alloc] init];
            NSString* api_token = [(AppDelegate *)[[UIApplication sharedApplication] delegate] api_token];
            NSString* user_email = [(AppDelegate *)[[UIApplication sharedApplication] delegate] user_email];
            Constants* constants = [[Constants alloc] init];
            NSString* getSurveyURL = [[constants.HOST stringByAppendingString:constants.VERSION] stringByAppendingString:constants.GET_SURVEY_PATH];
            NSString* postData = [[[@"ApiToken=" stringByAppendingString:api_token] stringByAppendingString:@"&Email="] stringByAppendingString:user_email];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:getSurveyURL]];
            [request setHTTPMethod:@"POST"];
            [request setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
            getSurveyConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            return;
        }
    
        float progress = ([question_number floatValue] - 1) / ([survey_json[@"ScoringQuestions"] count] + [survey_json[@"ExtraQuestions"] count]);
        progressView.progress = progress;
        [progressBubble setFrame:CGRectMake(progressBubble.frame.origin.x + (295-26)*progress, progressBubble.frame.origin.y, progressBubble.frame.size.width, progressBubble.frame.size.height)];
        progressPercentage.font = [UIFont fontWithName:@"MyriadPro-Regular" size:10];
        progressPercentage.text = [NSString stringWithFormat:@"%.0f%%", progress*100];
        [progressPercentage setFrame:CGRectMake(progressPercentage.frame.origin.x + (295-26)*progress, progressPercentage.frame.origin.y, progressPercentage.frame.size.width, progressPercentage.frame.size.height)];
        NSString* question_index = [[survey_json[@"ScoringQuestions"] allKeys] objectAtIndex:([question_number intValue]-1)];
        question.font = [UIFont fontWithName:@"MyriadPro-Regular" size:12];
        question.text = survey_json[@"ScoringQuestions"][question_index][@"Question"];
        question.textColor = [UIColor colorWithRed:120.0/255.0f green:120.0/255.0f blue:120.0/255.0f alpha:1.0f];
        answerOne.font = [UIFont fontWithName:@"MyriadPro-Regular" size:12];
        answerOne.text = survey_json[@"ScoringQuestions"][question_index][@"PossibleAnswers"][@"1"][@"Answer"];
        answerOne.textColor = [UIColor colorWithRed:120.0/255.0f green:120.0/255.0f blue:120.0/255.0f alpha:1.0f];
        checkBoxOne.tag = 0;
        [checkBoxOne addTarget:self action:@selector(clickedAnswer:) forControlEvents:UIControlEventTouchUpInside];

        [answer_ids addObject:survey_json[@"ScoringQuestions"][question_index][@"PossibleAnswers"][@"1"][@"PossibleAnswerId"]];
        NSUInteger numberOfAnswers = [survey_json[@"ScoringQuestions"][question_index][@"PossibleAnswers"] count];
        for (int i = 2; i <= [survey_json[@"ScoringQuestions"][question_index][@"PossibleAnswers"] count]; i++)
        {
            UITextView* nextAnswer = [[UITextView alloc] initWithFrame:CGRectMake(40, 324 + 65*(i-1), 189, 54)];
            nextAnswer.backgroundColor = [UIColor clearColor];
            nextAnswer.editable = NO;
            nextAnswer.userInteractionEnabled = NO;
            NSString* i_string = [NSString stringWithFormat:@"%i", i];
            nextAnswer.font = [UIFont fontWithName:@"MyriadPro-Regular" size:12];
            nextAnswer.text = survey_json[@"ScoringQuestions"][question_index][@"PossibleAnswers"][i_string][@"Answer"];
            nextAnswer.textColor = [UIColor colorWithRed:120.0/255.0f green:120.0/255.0f blue:120.0/255.0f alpha:1.0f];
            [self.scrollView addSubview:nextAnswer];
            
            UIButton* checkBox = [UIButton buttonWithType:UIButtonTypeCustom];
            checkBox.tag = i-1;
            [checkBox setFrame:CGRectMake(265, 328+65*(i-1), 32, 32)];
            [checkBox setImage:[UIImage imageNamed:@"babyq_circle.png"] forState:UIControlStateNormal];
            [checkBox addTarget:self action:@selector(clickedAnswer:) forControlEvents:UIControlEventTouchUpInside];
            [self.scrollView addSubview:checkBox];
            
            [answer_ids addObject:survey_json[@"ScoringQuestions"][question_index][@"PossibleAnswers"][i_string][@"PossibleAnswerId"]];
        }
        if (numberOfAnswers > 1)
        {
            [self.scrollView setContentSize:CGSizeMake(320, 500 + 65 * (numberOfAnswers-1) )];
            [self.bottomDivider setFrame:CGRectMake(bottomDivider.frame.origin.x, bottomDivider.frame.origin.y+65*(numberOfAnswers-1), bottomDivider.frame.size.width, bottomDivider.frame.size.height)];
            [self.nextButton setFrame:CGRectMake(nextButton.frame.origin.x, nextButton.frame.origin.y +65*(numberOfAnswers-1), nextButton.frame.size.width, nextButton.frame.size.height)];
            [self.previousButton setFrame:CGRectMake(previousButton.frame.origin.x, previousButton.frame.origin.y +65*(numberOfAnswers-1), previousButton.frame.size.width, previousButton.frame.size.height)];
        }
    }
    else
    {
        if (selected_extra_answers == nil)
            selected_extra_answers = [[NSMutableDictionary alloc] init];
        answer_ids = [[NSMutableArray alloc] init];
        questionType.text = [question_type uppercaseString];
        
        nextButton.enabled = NO;
        if ([question_number isEqualToString:@"1"])
            previousButton.hidden = YES;
        
        float progress = (([question_number floatValue] - 1) + [survey_json[@"ScoringQuestions"] count]) / ([survey_json[@"ScoringQuestions"] count] + [survey_json[@"ExtraQuestions"] count]);
        progressView.progress = progress;
        [progressBubble setFrame:CGRectMake(progressBubble.frame.origin.x + (295-26)*progress, progressBubble.frame.origin.y, progressBubble.frame.size.width, progressBubble.frame.size.height)];
        progressPercentage.font = [UIFont fontWithName:@"MyriadPro-Regular" size:10];
        progressPercentage.text = [NSString stringWithFormat:@"%.0f%%", progress*100];
        [progressPercentage setFrame:CGRectMake(progressPercentage.frame.origin.x + (295-26)*progress, progressPercentage.frame.origin.y, progressPercentage.frame.size.width, progressPercentage.frame.size.height)];
        NSString* question_key = [[survey_json[@"ExtraQuestions"] allKeys] objectAtIndex:([question_number intValue]-1)];
        question.font = [UIFont fontWithName:@"MyriadPro-Regular" size:12];
        question.text = survey_json[@"ExtraQuestions"][question_key][@"Question"];
        question.textColor = [UIColor colorWithRed:120.0/255.0f green:120.0/255.0f blue:120.0/255.0f alpha:1.0f];
        
        if ([question_type isEqualToString:@"Check All That Apply"])
        {
            selectAllLabel.font = [UIFont fontWithName:@"MyriadPro-Semibold" size:13];
            if (selected_extra_answers[question_key] == nil)
                selected_extra_answers[question_key] = [[NSMutableArray alloc] init];
            nextButton.enabled = YES;
        }
        
        answerOne.font = [UIFont fontWithName:@"MyriadPro-Regular" size:12];
        answerOne.text = survey_json[@"ExtraQuestions"][question_key][@"PossibleAnswers"][@"1"][@"Answer"];
        answerOne.textColor = [UIColor colorWithRed:120.0/255.0f green:120.0/255.0f blue:120.0/255.0f alpha:1.0f];
        checkBoxOne.tag = 0;
        [checkBoxOne addTarget:self action:@selector(clickedAnswer:) forControlEvents:UIControlEventTouchUpInside];
        
        [answer_ids addObject:survey_json[@"ExtraQuestions"][question_key][@"PossibleAnswers"][@"1"][@"PossibleAnswerId"]];
        NSUInteger numberOfAnswers = [survey_json[@"ExtraQuestions"][question_key][@"PossibleAnswers"] count];
        for (int i = 2; i <= [survey_json[@"ExtraQuestions"][question_key][@"PossibleAnswers"] count]; i++)
        {
            UITextView* nextAnswer;
            nextAnswer = [[UITextView alloc] initWithFrame:CGRectMake(40, 324 + 65*(i-1), 189, 54)];
            
            nextAnswer.backgroundColor = [UIColor clearColor];
            nextAnswer.editable = NO;
            nextAnswer.userInteractionEnabled = NO;
            NSString* i_string = [NSString stringWithFormat:@"%i", i];
            nextAnswer.font = [UIFont fontWithName:@"MyriadPro-Regular" size:12];
            nextAnswer.text = survey_json[@"ExtraQuestions"][question_key][@"PossibleAnswers"][i_string][@"Answer"];
            nextAnswer.textColor = [UIColor colorWithRed:120.0/255.0f green:120.0/255.0f blue:120.0/255.0f alpha:1.0f];
            [self.scrollView addSubview:nextAnswer];
            
            UIButton* checkBox = [UIButton buttonWithType:UIButtonTypeCustom];
            checkBox.tag = i-1;
            [checkBox setFrame:CGRectMake(265, 328+65*(i-1), 32, 32)];
            [checkBox setImage:[UIImage imageNamed:@"babyq_circle.png"] forState:UIControlStateNormal];
            [checkBox addTarget:self action:@selector(clickedAnswer:) forControlEvents:UIControlEventTouchUpInside];
            [self.scrollView addSubview:checkBox];
            
            [answer_ids addObject:survey_json[@"ExtraQuestions"][question_key][@"PossibleAnswers"][i_string][@"PossibleAnswerId"]];
        }
        if (numberOfAnswers > 1)
        {
            [self.scrollView setContentSize:CGSizeMake(320, 530 + 65 * (numberOfAnswers-1) )];
            [self.bottomDivider setFrame:CGRectMake(bottomDivider.frame.origin.x, bottomDivider.frame.origin.y+65*(numberOfAnswers-1), bottomDivider.frame.size.width, bottomDivider.frame.size.height)];
            [self.nextButton setFrame:CGRectMake(nextButton.frame.origin.x, nextButton.frame.origin.y +65*(numberOfAnswers-1), nextButton.frame.size.width, nextButton.frame.size.height)];
            [self.previousButton setFrame:CGRectMake(previousButton.frame.origin.x, previousButton.frame.origin.y +65*(numberOfAnswers-1), previousButton.frame.size.width, previousButton.frame.size.height)];
        }
    }
}

- (void) goHome
{
    UIStoryboard * homeScreens = [UIStoryboard storyboardWithName:@"HomePage" bundle:nil];
    SideSwipeTableViewController* sideSwipeTableView = [homeScreens instantiateViewControllerWithIdentifier:@"SideSwipeTableView"];
    
    CurrentScoreViewController* currentScoreView = [homeScreens instantiateViewControllerWithIdentifier:@"CurrentScoreView"];
    
    MMDrawerController * swipeController = [[MMDrawerController alloc]
                                            initWithCenterViewController:currentScoreView
                                            leftDrawerViewController:sideSwipeTableView
                                            rightDrawerViewController:nil];
    [swipeController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeBezelPanningCenterView];
    [swipeController setShowsShadow:NO];
    
    [self.navigationController pushViewController:swipeController animated:YES];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data
{
    if (connection == getSurveyConnection)
        [survey_data appendData:data];
    else
    {
        [self goHome];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (connection == getSurveyConnection)
    {
        NSString* json_response = [[NSString alloc] initWithData:survey_data encoding:NSUTF8StringEncoding];
        NSData* json_data = [json_response dataUsingEncoding:NSUTF8StringEncoding];
        
        survey_json = [NSJSONSerialization JSONObjectWithData: json_data
                                                      options: NSJSONReadingMutableContainers
                                                        error: nil];
        if (true /*[json_dictionary[@"VALID"] isEqualToString:@"Success"]*/)
        {
            int progress = ([question_number intValue] - 1) / [survey_json[@"ScoringQuestions"] count];
            progressView.progress = progress;
            [progressBubble setFrame:CGRectMake(progressBubble.frame.origin.x + (295-26)*progress, progressBubble.frame.origin.y, progressBubble.frame.size.width, progressBubble.frame.size.height)];
            NSString* question_index = [[survey_json[@"ScoringQuestions"] allKeys] objectAtIndex:([question_number intValue]-1)];
            question.text = survey_json[@"ScoringQuestions"][question_index][@"Question"];
            question.textColor = [UIColor colorWithRed:120.0/255.0f green:120.0/255.0f blue:120.0/255.0f alpha:1.0f];
            answerOne.text = survey_json[@"ScoringQuestions"][question_index][@"PossibleAnswers"][@"1"][@"Answer"];
            answerOne.textColor = [UIColor colorWithRed:120.0/255.0f green:120.0/255.0f blue:120.0/255.0f alpha:1.0f];
            checkBoxOne.tag = 0;
            [checkBoxOne addTarget:self action:@selector(clickedAnswer:) forControlEvents:UIControlEventTouchUpInside];
            
            [answer_ids addObject:survey_json[@"ScoringQuestions"][question_index][@"PossibleAnswers"][@"1"][@"PossibleAnswerId"]];
            NSUInteger numberOfAnswers = [survey_json[@"ScoringQuestions"][question_index][@"PossibleAnswers"] count];
            for (int i = 2; i <= [survey_json[@"ScoringQuestions"][question_index][@"PossibleAnswers"] count]; i++)
            {
                UITextView* nextAnswer = [[UITextView alloc] initWithFrame:CGRectMake(40, 324 + 65*(i-1), 189, 54)];
                nextAnswer.backgroundColor = [UIColor clearColor];
                nextAnswer.editable = NO;
                nextAnswer.userInteractionEnabled = NO;
                NSString* i_string = [NSString stringWithFormat:@"%i", i];
                nextAnswer.text = survey_json[@"ScoringQuestions"][question_index][@"PossibleAnswers"][i_string][@"Answer"];
                nextAnswer.textColor = [UIColor colorWithRed:120.0/255.0f green:120.0/255.0f blue:120.0/255.0f alpha:1.0f];
                [self.scrollView addSubview:nextAnswer];
                
                UIButton* checkBox = [UIButton buttonWithType:UIButtonTypeCustom];
                checkBox.tag = i-1;
                [checkBox setFrame:CGRectMake(265, 328+65*(i-1), 32, 32)];
                [checkBox setImage:[UIImage imageNamed:@"babyq_circle.png"] forState:UIControlStateNormal];
                [checkBox addTarget:self action:@selector(clickedAnswer:) forControlEvents:UIControlEventTouchUpInside];
                [self.scrollView addSubview:checkBox];
                
                [answer_ids addObject:survey_json[@"ScoringQuestions"][question_index][@"PossibleAnswers"][i_string][@"PossibleAnswerId"]];
            }
            if (numberOfAnswers > 1)
            {
                [self.scrollView setContentSize:CGSizeMake(320, 500 + 65 * (numberOfAnswers-1) )];
                [self.bottomDivider setFrame:CGRectMake(bottomDivider.frame.origin.x, bottomDivider.frame.origin.y+65*(numberOfAnswers-1), bottomDivider.frame.size.width, bottomDivider.frame.size.height)];
                [self.nextButton setFrame:CGRectMake(nextButton.frame.origin.x, nextButton.frame.origin.y +65*(numberOfAnswers-1), nextButton.frame.size.width, nextButton.frame.size.height)];
                [self.previousButton setFrame:CGRectMake(previousButton.frame.origin.x, previousButton.frame.origin.y +65*(numberOfAnswers-1), previousButton.frame.size.width, previousButton.frame.size.height)];
            }
        }
    }
}

- (void) viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.topItem.title = @"TAKE SURVEY";
}

- (void) clickedAnswer:(UIButton*)sender
{
    if (extraQuestionsReached)
    {
        NSString* question_key = [[survey_json[@"ExtraQuestions"] allKeys] objectAtIndex:([question_number intValue]-1)];
        if ([question_type isEqualToString:@"Multiple Choice"])
        {
            for (UIView *subview in self.scrollView.subviews) {
                if ([subview isKindOfClass:[UIButton class]])
                {
                    UIButton* button = (UIButton*) subview;
                    if (button.tag >= 0)
                        [button setImage:[UIImage imageNamed:@"babyq_circle.png"] forState:UIControlStateNormal];
                }
            }
        }
        if ([question_type isEqualToString:@"Check All That Apply"])
        {
            if ([selected_extra_answers[question_key] containsObject:answer_ids[sender.tag]])
            {
                [selected_extra_answers[question_key] removeObject:answer_ids[sender.tag]];
                [sender setImage:[UIImage imageNamed:@"babyq_circle.png"] forState:UIControlStateNormal];
            }
            else
            {
                [selected_extra_answers[question_key] addObject:answer_ids[sender.tag]];
                [sender setImage:[UIImage imageNamed:@"babyq_circle_orange.png"] forState:UIControlStateNormal];
            }
        }
        else
        {
            selected_extra_answers[question_key] = answer_ids[sender.tag];
            [sender setImage:[UIImage imageNamed:@"babyq_circle_orange.png"] forState:UIControlStateNormal];
        }
        nextButton.enabled = YES;
    }
    else
    {
        NSString* question_key = [[survey_json[@"ScoringQuestions"] allKeys] objectAtIndex:([question_number intValue]-1)];
        for (UIView *subview in self.scrollView.subviews) {
            if ([subview isKindOfClass:[UIButton class]])
            {
                UIButton* button = (UIButton*) subview;
                if (button.tag >= 0)
                    [button setImage:[UIImage imageNamed:@"babyq_circle.png"] forState:UIControlStateNormal];
            }
        }
        selected_answers[question_key] = answer_ids[sender.tag];
        [sender setImage:[UIImage imageNamed:@"babyq_circle_orange.png"] forState:UIControlStateNormal];
        nextButton.enabled = YES;
    }
}

- (IBAction)previousQuestion
{
    SurveyViewController* surveyController = [self.storyboard instantiateViewControllerWithIdentifier:@"SurveyQuestion"];
    NSInteger question_int = [question_number integerValue];
    surveyController.question_number = [NSString stringWithFormat:@"%li",question_int - 1];
    [self.navigationController pushViewController:surveyController animated:YES];
    self.navigationController.navigationBarHidden = YES;
}

- (IBAction)nextQuestion
{
    
    NSInteger question_int = [question_number integerValue];
    NSUInteger numberOfQuestions = [survey_json[@"ScoringQuestions"] count];
    
    if (extraQuestionsReached)
    {
        NSUInteger numberOfQuestions = [survey_json[@"ExtraQuestions"] count];
        if (question_int < numberOfQuestions)
        {
            NSString* question_index = [[survey_json[@"ExtraQuestions"] allKeys] objectAtIndex:([question_number intValue])];
            SurveyViewController* surveyController = [self.storyboard instantiateViewControllerWithIdentifier:@"SurveyQuestion"];
            NSString* type = survey_json[@"ExtraQuestions"][question_index][@"QuestionTypeDescription"];
            surveyController.question_number = [NSString stringWithFormat:@"%li",question_int + 1];
            surveyController.question_type = type;
            
            [self.navigationController pushViewController:surveyController animated:YES];
            self.navigationController.navigationBarHidden = YES;
        }
        else
        {
            NSString* title = @"Survey Complete";
            NSString* message = @"Thanks for taking the survey! We've calculated your new babyQ score, go check it out!";
            NSString* buttonTitle = @"VIEW BABYQ SCORE";
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:buttonTitle otherButtonTitles:nil];
            alert.tag = 0;
            [alert show];
        }
        
    } else if (question_int < numberOfQuestions)
    {
        SurveyViewController* surveyController = [self.storyboard instantiateViewControllerWithIdentifier:@"SurveyQuestion"];
        surveyController.question_number = [NSString stringWithFormat:@"%li",question_int + 1];
        surveyController.question_type = @"Multiple Choice";
        [self.navigationController pushViewController:surveyController animated:YES];
        self.navigationController.navigationBarHidden = YES;
       
    }
    else
    {
        if (!extraQuestionsReached && [survey_json[@"ExtraQuestions"] count] > 0)
        {
            extraQuestionsReached = YES;
            SurveyViewController* surveyController = [self.storyboard instantiateViewControllerWithIdentifier:@"SurveyQuestion"];
            NSString* type = survey_json[@"ExtraQuestions"][@"1"][@"QuestionTypeDescription"];
            surveyController.question_type = type;
            surveyController.question_number = @"1";
            [self.navigationController pushViewController:surveyController animated:YES];
            self.navigationController.navigationBarHidden = YES;
        }
        else
        {
            NSString* title = @"Survey Complete";
            NSString* message = @"Thanks for taking the survey! We've calculated your new babyQ score, go check it out!";
            NSString* buttonTitle = @"VIEW BABYQ SCORE";
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:buttonTitle otherButtonTitles:nil];
            alert.tag = 0;
            [alert show];
        }
    }
}

- (void) cancelSurvey
{
    NSString* message = @"Do you want to stop taking this survey? Your progress will be saved for later.";
    NSString* yesButtonTitle = @"YES";
    NSString* noButtonTitle = @"NO";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:noButtonTitle otherButtonTitles:yesButtonTitle, nil];
    alert.tag = 1;
    [alert dismissWithClickedButtonIndex:0 animated:YES];
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case 0:
        {
            NSMutableDictionary* submit_survey_json = [[NSMutableDictionary alloc] init];
            submit_survey_json[@"SurveyId"] = survey_json[@"SurveyId"];
            submit_survey_json[@"ScoringQuestions"] = [[NSMutableDictionary alloc] init];
            for (int i = 0; i < [[survey_json[@"ScoringQuestions"] allKeys] count]; i++)
            {
                NSString* question_number_string = [[survey_json[@"ScoringQuestions"] allKeys] objectAtIndex:i];
                submit_survey_json[@"ScoringQuestions"][question_number_string] = [[NSMutableDictionary alloc] init];
                submit_survey_json[@"ScoringQuestions"][question_number_string][@"QuestionId"] = survey_json[@"ScoringQuestions"][question_number_string][@"QuestionId"];
                submit_survey_json[@"ScoringQuestions"][question_number_string][@"PossibleAnswers"] = [[NSMutableDictionary alloc] init];
                submit_survey_json[@"ScoringQuestions"][question_number_string][@"PossibleAnswers"][@"1"] = [[NSMutableDictionary alloc] init];
                submit_survey_json[@"ScoringQuestions"][question_number_string][@"PossibleAnswers"][@"1"][@"PossibleAnswerId"] = selected_answers[question_number_string];
            }
            
            submit_survey_json[@"ExtraQuestions"] = [[NSMutableDictionary alloc] init];
            for (int i = 0; i < [[survey_json[@"ExtraQuestions"] allKeys] count]; i++)
            {
                NSString* question_number_string = [[survey_json[@"ExtraQuestions"] allKeys] objectAtIndex:i];
                submit_survey_json[@"ExtraQuestions"][question_number_string] = [[NSMutableDictionary alloc] init];
                submit_survey_json[@"ExtraQuestions"][question_number_string][@"QuestionId"] = survey_json[@"ExtraQuestions"][question_number_string][@"QuestionId"];
                submit_survey_json[@"ExtraQuestions"][question_number_string][@"PossibleAnswers"] = [[NSMutableDictionary alloc] init];
                
                if ([selected_extra_answers[question_number_string] isKindOfClass:[NSArray class]])
                {
                    for (int y = 0; y < [selected_extra_answers[question_number_string] count]; y++)
                    {
                        NSString* answer_key = [NSString stringWithFormat:@"%d", y+1];
                        submit_survey_json[@"ExtraQuestions"][question_number_string][@"PossibleAnswers"][answer_key] = [[NSMutableDictionary alloc] init];
                        submit_survey_json[@"ExtraQuestions"][question_number_string][@"PossibleAnswers"][answer_key][@"PossibleAnswerId"] = selected_extra_answers[question_number_string][y];
                    }
                }
                else
                {
                    submit_survey_json[@"ExtraQuestions"][question_number_string][@"PossibleAnswers"][@"1"] = [[NSMutableDictionary alloc] init];
                    submit_survey_json[@"ExtraQuestions"][question_number_string][@"PossibleAnswers"][@"1"][@"PossibleAnswerId"] = selected_extra_answers[question_number_string];
                }
            }
            NSData *jsonSurveyData = [NSJSONSerialization dataWithJSONObject:submit_survey_json
                                                               options:NSJSONWritingPrettyPrinted
                                                                 error:nil];
            
            NSString* submit_survey_string = [[NSString alloc] initWithData:jsonSurveyData encoding:NSUTF8StringEncoding];
            
            NSString* api_token = [(AppDelegate *)[[UIApplication sharedApplication] delegate] api_token];
            NSString* user_email = [(AppDelegate *)[[UIApplication sharedApplication] delegate] user_email];
            Constants* constants = [[Constants alloc] init];
            NSString* getSurveyURL = [[constants.HOST stringByAppendingString:constants.VERSION] stringByAppendingString:constants.SUBMIT_SURVEY_PATH];
            NSString* postData = [[[@"ApiToken=" stringByAppendingString:api_token] stringByAppendingString:@"&Email="] stringByAppendingString:user_email];
            postData = [[postData stringByAppendingString:@"&Survey="] stringByAppendingString:submit_survey_string];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:getSurveyURL]];
            [request setHTTPMethod:@"POST"];
            [request setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
            submitSurveyConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            
            survey_json = nil;
            selected_answers = nil;
            selected_extra_answers = nil;
            extraQuestionsReached = NO;
            break;
        }
        case 1:
        {
            if (buttonIndex == 1)
            {
                if (extraQuestionsReached)
                {
                    NSString* question_key = [[survey_json[@"ExtraQuestions"] allKeys] objectAtIndex:([question_number intValue]-1)];
                    [selected_extra_answers removeObjectForKey:question_key];
                }
                else
                {
                    NSString* question_key = [[survey_json[@"ScoringQuestions"] allKeys] objectAtIndex:([question_number intValue]-1)];
                    [selected_answers removeObjectForKey:question_key];
                }
                    
                [self goHome];
            }
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
