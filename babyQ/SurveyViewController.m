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

@synthesize scrollView,progressView,progressBubble,questionNumber,answerNumber,question,answerOne,nextButton,bottomDivider,question_number,survey_json;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.scrollView setBackgroundColor:[UIColor whiteColor]];
    
    CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 3.0f);
    self.progressView.transform = transform;
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.backItem.title = @"";
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationController.navigationBar.topItem.title = @"Take Survey";
    
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
    
    question.text = survey_json[@"ScoringQuestions"][question_number][@"Question"];
    
    answerOne.text = survey_json[@"ScoringQuestions"][question_number][@"PossibleAnswers"][@"1"][@"Answer"];
    NSUInteger numberOfQuestions = [survey_json[@"ScoringQuestions"][question_number][@"PossibleAnswers"] count];
    for (int i = 2; i <= [survey_json[@"ScoringQuestions"][question_number][@"PossibleAnswers"] count]; i++)
    {
        UITextView* nextAnswer = [[UITextView alloc] initWithFrame:CGRectMake(45, 324 + 65*(i-1), 189, 54)];
        nextAnswer.backgroundColor = [UIColor clearColor];
        nextAnswer.editable = NO;
        nextAnswer.userInteractionEnabled = NO;
        nextAnswer.text = survey_json[@"ScoringQuestions"][question_number][@"PossibleAnswers"][[NSString stringWithFormat:@"%i", i]][@"Answer"];
        [self.scrollView addSubview:nextAnswer];
        
        UIButton* checkBox = [UIButton buttonWithType:UIButtonTypeCustom];
        [checkBox setFrame:CGRectMake(265, 332+65*(i-1), 16, 16)];
        [checkBox setBackgroundImage:[UIImage imageNamed:@"babyq_circle.png"] forState:UIControlStateNormal];
        [self.scrollView addSubview:checkBox];
    }
    if (numberOfQuestions > 1)
    {
        [self.scrollView setContentSize:CGSizeMake(320, 500 + 65 * (numberOfQuestions-1) )];
        [self.bottomDivider setFrame:CGRectMake(bottomDivider.frame.origin.x, bottomDivider.frame.origin.y+65*(numberOfQuestions-1), bottomDivider.frame.size.width, bottomDivider.frame.size.height)];
        [self.nextButton setFrame:CGRectMake(nextButton.frame.origin.x, nextButton.frame.origin.y +65*(numberOfQuestions-1), nextButton.frame.size.width, nextButton.frame.size.height)];
    }
}

- (void) viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.topItem.title = @"Take Survey";
}

- (IBAction)nextQuestion
{
    SurveyViewController* surveyController = [self.storyboard instantiateViewControllerWithIdentifier:@"MultipleChoice"];
    NSInteger question_int = [question_number integerValue];
    if (question_int < 21)
        surveyController.question_number = [NSString stringWithFormat:@"%li",question_int + 1];
    surveyController.survey_json = self.survey_json;
    [self.navigationController pushViewController:surveyController animated:YES];
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
