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

@synthesize scrollView,progressView,progressBubble,questionNumber,answerNumber,question,answerOne,checkBoxOne,nextButton,bottomDivider,question_number,survey_json,answer_ids,selected_answers;

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
    if (survey_json == nil)
    {
        
        NSString* SAMPLE_SURVEY_JSON = @"{ \
        \"SurveyId\":\"84410A2F-0241-F222-AF7D-7E17CAAF4600\",\
        \"ScoringQuestions\":{\
        \"1\":{\
        \"QuestionId\":\"391e85ea-f17f-11e3-949c-79c05a7f6da7\",\
        \"Question\":\"Each day I exercise on a regular basis for at least 30 minutes (walking, jogging, yoga, spin, weights, etc.)\r\n\",\
        \"QuestionOrdinal\":\"1\",\
        \"QuestionType\":\"1\",\
        \"QuestionTypeDescription\":\"Multiple Choice\",\
        \"PossibleAnswers\":{\
        \"1\":{\
        \"PossibleAnswerId\":\"de640a24-f185-11e3-949c-79c05a7f6da7\",\
        \"Answer\":\"rarely\r\n\",\
        \"Ordinal\":\"1\"\
        },\
        \"2\":{\
        \"PossibleAnswerId\":\"a15edd7e-f186-11e3-949c-79c05a7f6da7\",\
        \"Answer\":\"1 to 2 days per week\r\n\",\
        \"Ordinal\":\"2\"\
        },\
        \"3\":{\
        \"PossibleAnswerId\":\"a15ef188-f186-11e3-949c-79c05a7f6da7\",\
        \"Answer\":\"3 to 4 days per week\r\n\",\
        \"Ordinal\":\"3\"\
        },\
        \"4\":{\
        \"PossibleAnswerId\":\"a15f02b8-f186-11e3-949c-79c05a7f6da7\",\
        \"Answer\":\"5 to 6 days per week\r\n\",\
        \"Ordinal\":\"4\"\
        },\
        \"5\":{\
        \"PossibleAnswerId\":\"a15f13ac-f186-11e3-949c-79c05a7f6da7\",\
        \"Answer\":\"every day\r\n\",\
        \"Ordinal\":\"5\"\
        },\
        \"6\":{\
        \"PossibleAnswerId\":\"a15f24be-f186-11e3-949c-79c05a7f6da7\",\
        \"Answer\":\"doctor's restriction - no exercise\r\n\",\
        \"Ordinal\":\"6\"\
        }\
        }\
        },\
        \"2\":{\
        \"QuestionId\":\"686d1170-f181-11e3-949c-79c05a7f6da7\",\
        \"Question\":\"I have had a restful night's sleep of at least 7 hours\r\n\",\
        \"QuestionOrdinal\":\"2\",\
        \"QuestionType\":\"1\",\
        \"QuestionTypeDescription\":\"Multiple Choice\",\
        \"PossibleAnswers\":{\
        \"1\":{\
        \"PossibleAnswerId\":\"8a19bfca-f187-11e3-949c-79c05a7f6da7\",\
        \"Answer\":\"rarely\r\n\",\
        \"Ordinal\":\"1\"\
        },\
        \"2\":{\
        \"PossibleAnswerId\":\"8a19d47e-f187-11e3-949c-79c05a7f6da7\",\
        \"Answer\":\"1 to 2 nights per week\r\n\",\
        \"Ordinal\":\"2\"\
        },\
        \"3\":{\
        \"PossibleAnswerId\":\"8a19e5e0-f187-11e3-949c-79c05a7f6da7\",\
        \"Answer\":\"3 to 4 nights per week\r\n\",\
        \"Ordinal\":\"3\"\
        },\
        \"4\":{\
        \"PossibleAnswerId\":\"8a19f88c-f187-11e3-949c-79c05a7f6da7\",\
        \"Answer\":\"5 to 6 nights per week\r\n\",\
        \"Ordinal\":\"4\"\
        },\
        \"5\":{\
        \"PossibleAnswerId\":\"8a1a0a34-f187-11e3-949c-79c05a7f6da7\",\
        \"Answer\":\"every night\r\n\",\
        \"Ordinal\":\"5\"\
        }}}}}";
        
        SAMPLE_SURVEY_JSON = [SAMPLE_SURVEY_JSON stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
        SAMPLE_SURVEY_JSON = [SAMPLE_SURVEY_JSON stringByReplacingOccurrencesOfString:@"\r" withString:@"\\r"];
        
        NSData* surveyData = [SAMPLE_SURVEY_JSON dataUsingEncoding:NSUTF8StringEncoding];
        survey_json =
        [NSJSONSerialization JSONObjectWithData: surveyData
                                        options: NSJSONReadingMutableContainers
                                          error: nil];
        
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
