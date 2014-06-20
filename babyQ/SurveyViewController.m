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

@implementation SurveyViewController

@synthesize scrollView,progressView,progressBubble,questionNumber,answerNumber,question,answerOne,checkBoxOne,nextButton,bottomDivider,question_number,survey_data,survey_json,answer_ids,selected_answers;

NSURLConnection* getSurveyConnection;
NSURLConnection* submitSurveyConnection;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.scrollView setBackgroundColor:[UIColor whiteColor]];
    
    CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 3.0f);
    progressView.transform = transform;
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.backItem.title = @"";
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationController.navigationBar.topItem.title = @"Take Survey";
    
    if (selected_answers == nil)
        selected_answers = [[NSMutableDictionary alloc] init];
    answer_ids = [[NSMutableArray alloc] init];
    questionNumber.text = [NSString stringWithFormat:@"Q%@", question_number];
    answerNumber.text = [NSString stringWithFormat:@"A%@", question_number];
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
    
    float progress = ([question_number floatValue] - 1) / [survey_json[@"ScoringQuestions"] count];
    progressView.progress = progress;
    [progressBubble setFrame:CGRectMake(progressBubble.frame.origin.x + (295-26)*progress, progressBubble.frame.origin.y, progressBubble.frame.size.width, progressBubble.frame.size.height)];
    
    question.text = survey_json[@"ScoringQuestions"][question_number][@"Question"];
    
    answerOne.text = survey_json[@"ScoringQuestions"][question_number][@"PossibleAnswers"][@"1"][@"Answer"];
    checkBoxOne.tag = 0;
    [checkBoxOne addTarget:self action:@selector(clickedAnswer:) forControlEvents:UIControlEventTouchUpInside];

    [answer_ids addObject:survey_json[@"ScoringQuestions"][question_number][@"PossibleAnswers"][@"1"][@"PossibleAnswerId"]];
    NSUInteger numberOfAnswers = [survey_json[@"ScoringQuestions"][question_number][@"PossibleAnswers"] count];
    for (int i = 2; i <= [survey_json[@"ScoringQuestions"][question_number][@"PossibleAnswers"] count]; i++)
    {
        UITextView* nextAnswer = [[UITextView alloc] initWithFrame:CGRectMake(45, 324 + 65*(i-1), 189, 54)];
        nextAnswer.backgroundColor = [UIColor clearColor];
        nextAnswer.editable = NO;
        nextAnswer.userInteractionEnabled = NO;
        NSString* i_string = [NSString stringWithFormat:@"%i", i];
        nextAnswer.text = survey_json[@"ScoringQuestions"][question_number][@"PossibleAnswers"][i_string][@"Answer"];
        [self.scrollView addSubview:nextAnswer];
        
        UILabel* answerChoice = [[UILabel alloc] initWithFrame:CGRectMake(26, 328 + 65*(i-1), 18, 18)];
        answerChoice.text = [NSString stringWithFormat:@"%d.", i];
        answerChoice.font = [UIFont fontWithName:@"Bebas" size:12];
        [self.scrollView addSubview:answerChoice];
        
        UIButton* checkBox = [UIButton buttonWithType:UIButtonTypeCustom];
        checkBox.tag = i-1;
        [checkBox setFrame:CGRectMake(265, 332+65*(i-1), 16, 16)];
        [checkBox setBackgroundImage:[UIImage imageNamed:@"babyq_circle.png"] forState:UIControlStateNormal];
        [checkBox addTarget:self action:@selector(clickedAnswer:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:checkBox];
        
        [answer_ids addObject:survey_json[@"ScoringQuestions"][question_number][@"PossibleAnswers"][i_string][@"PossibleAnswerId"]];
    }
    if (numberOfAnswers > 1)
    {
        [self.scrollView setContentSize:CGSizeMake(320, 500 + 65 * (numberOfAnswers-1) )];
        [self.bottomDivider setFrame:CGRectMake(bottomDivider.frame.origin.x, bottomDivider.frame.origin.y+65*(numberOfAnswers-1), bottomDivider.frame.size.width, bottomDivider.frame.size.height)];
        [self.nextButton setFrame:CGRectMake(nextButton.frame.origin.x, nextButton.frame.origin.y +65*(numberOfAnswers-1), nextButton.frame.size.width, nextButton.frame.size.height)];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data
{
    NSLog(@"received data survey");
    if (connection == getSurveyConnection)
        [survey_data appendData:data];
    else
    {
        //NSLog(@"submit survey response: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
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
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"ERROR survey");
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (connection == getSurveyConnection)
    {
        NSLog(@"finished loading survey");
        NSString* json_response = [[NSString alloc] initWithData:survey_data encoding:NSUTF8StringEncoding];
        NSLog(@"json_response: %@", json_response);
        NSData* json_data = [json_response dataUsingEncoding:NSUTF8StringEncoding];
        
        survey_json = [NSJSONSerialization JSONObjectWithData: json_data
                                                      options: NSJSONReadingMutableContainers
                                                        error: nil];
        if (true /*[json_dictionary[@"VALID"] isEqualToString:@"Success"]*/)
        {
            int progress = ([question_number intValue] - 1) / [survey_json[@"ScoringQuestions"] count];
            progressView.progress = progress;
            [progressBubble setFrame:CGRectMake(progressBubble.frame.origin.x + (295-26)*progress, progressBubble.frame.origin.y, progressBubble.frame.size.width, progressBubble.frame.size.height)];
            
            question.text = survey_json[@"ScoringQuestions"][question_number][@"Question"];
            
            answerOne.text = survey_json[@"ScoringQuestions"][question_number][@"PossibleAnswers"][@"1"][@"Answer"];
            checkBoxOne.tag = 0;
            [checkBoxOne addTarget:self action:@selector(clickedAnswer:) forControlEvents:UIControlEventTouchUpInside];
            
            [answer_ids addObject:survey_json[@"ScoringQuestions"][question_number][@"PossibleAnswers"][@"1"][@"PossibleAnswerId"]];
            NSUInteger numberOfAnswers = [survey_json[@"ScoringQuestions"][question_number][@"PossibleAnswers"] count];
            for (int i = 2; i <= [survey_json[@"ScoringQuestions"][question_number][@"PossibleAnswers"] count]; i++)
            {
                UITextView* nextAnswer = [[UITextView alloc] initWithFrame:CGRectMake(45, 324 + 65*(i-1), 189, 54)];
                nextAnswer.backgroundColor = [UIColor clearColor];
                nextAnswer.editable = NO;
                nextAnswer.userInteractionEnabled = NO;
                NSString* i_string = [NSString stringWithFormat:@"%i", i];
                nextAnswer.text = survey_json[@"ScoringQuestions"][question_number][@"PossibleAnswers"][i_string][@"Answer"];
                [self.scrollView addSubview:nextAnswer];
                
                UILabel* answerChoice = [[UILabel alloc] initWithFrame:CGRectMake(26, 328 + 65*(i-1), 18, 18)];
                answerChoice.text = [NSString stringWithFormat:@"%d.", i];
                answerChoice.font = [UIFont fontWithName:@"Bebas" size:12];
                [self.scrollView addSubview:answerChoice];
                
                UIButton* checkBox = [UIButton buttonWithType:UIButtonTypeCustom];
                checkBox.tag = i-1;
                [checkBox setFrame:CGRectMake(265, 332+65*(i-1), 16, 16)];
                [checkBox setBackgroundImage:[UIImage imageNamed:@"babyq_circle.png"] forState:UIControlStateNormal];
                [checkBox addTarget:self action:@selector(clickedAnswer:) forControlEvents:UIControlEventTouchUpInside];
                [self.scrollView addSubview:checkBox];
                
                [answer_ids addObject:survey_json[@"ScoringQuestions"][question_number][@"PossibleAnswers"][i_string][@"PossibleAnswerId"]];
            }
            if (numberOfAnswers > 1)
            {
                [self.scrollView setContentSize:CGSizeMake(320, 500 + 65 * (numberOfAnswers-1) )];
                [self.bottomDivider setFrame:CGRectMake(bottomDivider.frame.origin.x, bottomDivider.frame.origin.y+65*(numberOfAnswers-1), bottomDivider.frame.size.width, bottomDivider.frame.size.height)];
                [self.nextButton setFrame:CGRectMake(nextButton.frame.origin.x, nextButton.frame.origin.y +65*(numberOfAnswers-1), nextButton.frame.size.width, nextButton.frame.size.height)];
            }
        }
    }
}

- (void) viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.topItem.title = @"Take Survey";
}

- (void) clickedAnswer:(UIButton*)sender
{
    for (UIView *subview in self.scrollView.subviews) {
        if ([subview isKindOfClass:[UIButton class]])
        {
            UIButton* button = (UIButton*) subview;
            if (button.tag >= 0)
                [button setBackgroundImage:[UIImage imageNamed:@"babyq_circle.png"] forState:UIControlStateNormal];
        }
    }
    [selected_answers setObject:answer_ids[sender.tag] forKey:question_number];
    [sender setBackgroundImage:[UIImage imageNamed:@"babyq_circle_orange.png"] forState:UIControlStateNormal];
}

- (IBAction)nextQuestion
{
    SurveyViewController* surveyController = [self.storyboard instantiateViewControllerWithIdentifier:@"MultipleChoice"];
    NSInteger question_int = [question_number integerValue];
    NSUInteger numberOfQuestions = [survey_json[@"ScoringQuestions"] count];
    if (question_int < numberOfQuestions)
    {
        surveyController.question_number = [NSString stringWithFormat:@"%li",question_int + 1];
        surveyController.selected_answers = self.selected_answers;
        surveyController.survey_json = self.survey_json;
        [self.navigationController pushViewController:surveyController animated:YES];
        self.navigationController.navigationBarHidden = YES;
    }
    else
    {
        NSString* title = @"Survey Complete";
        NSString* message = @"Thanks for taking the survey! We've calculated your new babyQ score, go check it out!";
        NSString* buttonTitle = @"VIEW BABYQ SCORE";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:buttonTitle otherButtonTitles:nil];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSMutableDictionary* submit_survey_json = [[NSMutableDictionary alloc] init];
    submit_survey_json[@"SurveyId"] = survey_json[@"SurveyId"];
    submit_survey_json[@"ScoringQuestions"] = [[NSMutableDictionary alloc] init];
    for (int i = 0; i < [[survey_json[@"ScoringQuestions"] allKeys] count]; i++)
    {
        NSString* question_number_string = [NSString stringWithFormat:@"%d", i + 1];
        submit_survey_json[@"ScoringQuestions"][question_number_string] = [[NSMutableDictionary alloc] init];
        submit_survey_json[@"ScoringQuestions"][question_number_string][@"QuestionId"] = survey_json[@"ScoringQuestions"][question_number_string][@"QuestionId"];
        submit_survey_json[@"ScoringQuestions"][question_number_string][@"PossibleAnswers"] = [[NSMutableDictionary alloc] init];
        submit_survey_json[@"ScoringQuestions"][question_number_string][@"PossibleAnswers"][@"1"] = [[NSMutableDictionary alloc] init];
        submit_survey_json[@"ScoringQuestions"][question_number_string][@"PossibleAnswers"][@"1"][@"PossibleAnswerId"] = selected_answers[question_number_string];
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
