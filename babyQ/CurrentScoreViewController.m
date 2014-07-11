//
//  CurrentScoreViewController.m
//  babyQ
//
//  Created by Chris Wood on 6/11/14.
//  Copyright (c) 2014 babyQ. All rights reserved.
//

#import "CurrentScoreViewController.h"

@interface CurrentScoreViewController ()

@end

@implementation CurrentScoreViewController

@synthesize scrollView,currentScoreData,todosView,dailyTipView,dailyTip,completedTodosButton,todosArray,todaysDate,scoreSlider,dailyTipDate,todosDueDate,goodWorkLabel,youImprovedLabel,tipHistoryButton,scrollDownLabel;

NSURLConnection* currentScoreConnection;
NSURLConnection* dailyTipConnection;
NSURLConnection* toDosConnection;
NSURLConnection* setTodoCompletedConnection;

CGRect scoreSliderFrame;

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.scrollView setContentSize:CGSizeMake(320, 1390)];
    [self.scrollView setBackgroundColor:[UIColor whiteColor]];
    dailyTipView.hidden = YES;
    
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE, MMM dd"];
    todaysDate.text = [dateFormatter stringFromDate:now];
    todaysDate.font = [UIFont fontWithName:@"Bebas" size:18];
    
    NSString* api_token = [(AppDelegate *)[[UIApplication sharedApplication] delegate] api_token];
    NSString* user_email = [(AppDelegate *)[[UIApplication sharedApplication] delegate] user_email];
    Constants* constants = [[Constants alloc] init];
    NSString* getCurrentScoreURL = [[constants.HOST stringByAppendingString:constants.VERSION] stringByAppendingString:constants.GET_CURRENT_SCORE_PATH];
    NSString* postData = [[[@"ApiToken=" stringByAppendingString:api_token] stringByAppendingString:@"&Email="] stringByAppendingString:user_email];
    NSMutableURLRequest *currentScoreRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:getCurrentScoreURL]];
    [currentScoreRequest setHTTPMethod:@"POST"];
    [currentScoreRequest setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    currentScoreConnection = [[NSURLConnection alloc] initWithRequest:currentScoreRequest delegate:self];
    
    NSString* dailyTipURL = [[constants.HOST stringByAppendingString:constants.VERSION] stringByAppendingString:constants.GET_DAILY_TIP_PATH];
    NSMutableURLRequest *dailyTipRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:dailyTipURL]];
    [dailyTipRequest setHTTPMethod:@"POST"];
    [dailyTipRequest setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    dailyTipConnection = [[NSURLConnection alloc] initWithRequest:dailyTipRequest delegate:self];
    
    NSString* toDosURL = [[constants.HOST stringByAppendingString:constants.VERSION] stringByAppendingString:constants.GET_CURRENT_TODOS_PATH];
    NSMutableURLRequest *toDosRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:toDosURL]];
    [toDosRequest setHTTPMethod:@"POST"];
    [toDosRequest setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    toDosConnection = [[NSURLConnection alloc] initWithRequest:toDosRequest delegate:self];
    
    self.totalScoreBig.font = [UIFont fontWithName:@"Bebas" size:61];
    self.totalScoreSmall.font = [UIFont fontWithName:@"Bebas" size:18];
    self.lifestyleScore.font = [UIFont fontWithName:@"Bebas" size:18];
    self.exerciseScore.font = [UIFont fontWithName:@"Bebas" size:18];
    self.nutritionScore.font = [UIFont fontWithName:@"Bebas" size:18];
    self.stressScore.font = [UIFont fontWithName:@"Bebas" size:18];
    self.deltaBlurb.font = [UIFont fontWithName:@"MyriadPro-Regular" size:14];
    self.delta.font = [UIFont fontWithName:@"Bebas" size:61];
    self.goodWorkLabel.font = [UIFont fontWithName:@"MyriadPro-Regular" size:14];
    self.scrollDownLabel.font = [UIFont fontWithName:@"MyriadPro-Regular" size:14];
    self.youImprovedLabel.font = [UIFont fontWithName:@"MyriadPro-Regular" size:12];
    self.workBlurb.font = [UIFont fontWithName:@"MyriadPro-Regular" size:14];
    self.bigTotalLabel.font = [UIFont fontWithName:@"MyriadPro-Regular" size:18];
    self.smallTotalLabel.font = [UIFont fontWithName:@"MyriadPro-Semibold" size:10];
    self.lifestyleLabel.font = [UIFont fontWithName:@"MyriadPro-Semibold" size:10];
    self.exerciseLabel.font = [UIFont fontWithName:@"MyriadPro-Semibold" size:10];
    self.nutritionLabel.font = [UIFont fontWithName:@"MyriadPro-Semibold" size:10];
    self.stressLabel.font = [UIFont fontWithName:@"MyriadPro-Semibold" size:10];
    self.tipHistoryButton.titleLabel.font = [UIFont fontWithName:@"MyriadPro-Regular" size:14];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanScoreSlider:)];
    [scoreSlider addGestureRecognizer:panGesture];
    scoreSliderFrame =  CGRectMake(30, 405, 24, 24);
}

-(void)handlePanScoreSlider:(UIPanGestureRecognizer *)sender
{
    CGPoint translate = [sender translationInView:scoreSlider.superview];
    
    CGRect newFrame = scoreSliderFrame;
    newFrame.origin.x += translate.x;
    if(sender.state == UIGestureRecognizerStateChanged)
    {
        if (newFrame.origin.x >= 26 && newFrame.origin.x <= 270)
            scoreSlider.frame = newFrame;
        if (newFrame.origin.x < 60)
        {
            self.deltaBlurb.text = currentScoreData[@"OverallMessage"];
            if (currentScoreData[@"OverallDelta"] >= 0)
                self.delta.text = [NSString stringWithFormat:@"+%@", currentScoreData[@"OverallDelta"] ];
            else
            {
                self.delta.text = [NSString stringWithFormat:@"-%@", currentScoreData[@"OverallDelta"] ];
                self.youImprovedLabel.text = @"Your score went down from last time...";
            }
            self.bigTotalLabel.text = @"TOTAL";
            self.totalScoreBig.text = currentScoreData[@"OverallScore"];
        }
        else if (newFrame.origin.x < 118)
        {
            self.deltaBlurb.text = currentScoreData[@"LifestyleMessage"];
            if (currentScoreData[@"LifestyleDelta"] >= 0)
                self.delta.text = [NSString stringWithFormat:@"+%@", currentScoreData[@"LifestyleDelta"]];
            else
            {
                self.delta.text = [NSString stringWithFormat:@"-%@", currentScoreData[@"LifestyleDelta"]];
                self.youImprovedLabel.text = @"Your score went down from last time...";
            }
            self.bigTotalLabel.text = @"LIFESTYLE";
            self.totalScoreBig.text = currentScoreData[@"LifestyleScore"];
        }
        else if (newFrame.origin.x < 178)
        {
            self.deltaBlurb.text = currentScoreData[@"ExerciseMessage"];
            if (currentScoreData[@"ExerciseDelta"] >= 0)
                self.delta.text = [NSString stringWithFormat:@"+%@", currentScoreData[@"ExerciseDelta"]];
            else
            {
                self.delta.text = [NSString stringWithFormat:@"-%@", currentScoreData[@"ExerciseDelta"]];
                self.youImprovedLabel.text = @"Your score went down from last time...";
            }
            self.bigTotalLabel.text = @"EXERCISE";
            self.totalScoreBig.text = currentScoreData[@"ExerciseScore"];
        }
        else if (newFrame.origin.x < 236)
        {
            self.deltaBlurb.text = currentScoreData[@"NutritionMessage"];
            
            if (currentScoreData[@"NutritionDelta"] >= 0)
                self.delta.text = [NSString stringWithFormat:@"+%@", currentScoreData[@"NutritionDelta"]];
            else
            {
                self.delta.text = [NSString stringWithFormat:@"-%@", currentScoreData[@"NutritionDelta"]];
                self.youImprovedLabel.text = @"Your score went down from last time...";
            }
            self.bigTotalLabel.text = @"NURTITION";
            self.totalScoreBig.text = currentScoreData[@"NutritionScore"];
        }
        else if (newFrame.origin.x < 276)
        {
            self.deltaBlurb.text = currentScoreData[@"StressMessage"];
            if (currentScoreData[@"StressDelta"] >= 0)
                self.delta.text = [NSString stringWithFormat:@"+%@", currentScoreData[@"StressDelta"]];
            else
            {
                self.delta.text = [NSString stringWithFormat:@"-%@", currentScoreData[@"StressDelta"]];
                self.youImprovedLabel.text = @"Your score went down from last time...";
            }
            self.bigTotalLabel.text = @"STRESS";
            self.totalScoreBig.text = currentScoreData[@"StressScore"];
        }
    }
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        if (newFrame.origin.x <= 26)
            scoreSliderFrame = CGRectMake(30, 405, 24, 24);
        else if (newFrame.origin.x >= 270)
            scoreSliderFrame =  CGRectMake(266, 405, 24, 24);
        else
            scoreSliderFrame = newFrame;
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data
{
    if (connection == currentScoreConnection)
    {
        NSLog(@"received data current score");
        NSString* json_response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSData* json_data = [json_response dataUsingEncoding:NSUTF8StringEncoding];
        currentScoreData = [NSJSONSerialization JSONObjectWithData: json_data
                                                                        options: NSJSONReadingMutableContainers
                                                                          error: nil];
        if ([json_response rangeOfString:@"ERROR"].location == NSNotFound)
        {
            self.totalScoreBig.text = currentScoreData[@"OverallScore"];
            self.totalScoreSmall.text = currentScoreData[@"OverallScore"];
            self.lifestyleScore.text = currentScoreData[@"LifestyleScore"];
            self.exerciseScore.text = currentScoreData[@"ExerciseScore"];
            self.nutritionScore.text = currentScoreData[@"StressScore"];
            self.stressScore.text = currentScoreData[@"StressScore"];
            self.deltaBlurb.text = currentScoreData[@"OverallMessage"];
            int delta = [currentScoreData[@"OverallDelta"] intValue];
            if (delta >= 0)
                self.delta.text = [NSString stringWithFormat:@"+%@", currentScoreData[@"OverallDelta"]];
            else
            {
                self.delta.text = [NSString stringWithFormat:@"-%d",delta];
                self.youImprovedLabel.text = @"Your score went down from last time...";
            }
        } else {
            UIStoryboard* getScoreStoryboard = [UIStoryboard storyboardWithName:@"GetScore" bundle:nil];
            UIViewController* getScorePopup = [getScoreStoryboard instantiateInitialViewController];
            getScorePopup.modalPresentationStyle = UIModalPresentationCurrentContext;
            getScorePopup.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
            
            self.navigationController.modalPresentationStyle = UIModalPresentationCurrentContext;
            self.navigationController.view.userInteractionEnabled = NO;
            [self.navigationController presentViewController:getScorePopup animated:YES completion:^(){
                //[getScorePopup.view setFrame:CGRectMake(35, 100, 250, 260)];
            }];
        }
    } else if (connection ==  dailyTipConnection)
    {
        NSLog(@"received data daily tip");
        NSString* json_response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSData* json_data = [json_response dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary* json_dictionary = [NSJSONSerialization JSONObjectWithData: json_data
                                                                        options: NSJSONReadingMutableContainers
                                                                          error: nil];
        dailyTip.text = json_dictionary[@"Body"];
        dailyTip.font = [UIFont fontWithName:@"MyriadPro-Semibold" size:14];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString* dateString = json_dictionary[@"ReceivedDate"];
        NSDate* date = [dateFormatter dateFromString:dateString];
        [dateFormatter setDateFormat:@"MM.dd.yyyy"];
        dailyTipDate.text = [dateFormatter stringFromDate:date];
    } else if (connection == toDosConnection)
    {
        NSString* json_response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if ([json_response rangeOfString:@"ERROR"].location == NSNotFound)
        {
            NSData* json_data = [json_response dataUsingEncoding:NSUTF8StringEncoding];
            
            todosArray = [NSJSONSerialization JSONObjectWithData: json_data
                                                         options: NSJSONReadingMutableContainers
                                                           error: nil];
            for (int i = 0; i < [todosArray count]; i++)
            {
                UITextView* nextTodo = [[UITextView alloc] initWithFrame:CGRectMake(37, 39 + 65*(i), 189, 54)];
                nextTodo.backgroundColor = [UIColor clearColor];
                nextTodo.editable = NO;
                nextTodo.userInteractionEnabled = NO;
                nextTodo.font = [UIFont fontWithName:@"MyriadPro-Regular" size:12];
                if (todosArray[i][@"Body"] != (id)[NSNull null])
                    nextTodo.text = todosArray[i][@"Body"];
                [self.todosView addSubview:nextTodo];
                
                UILabel* todoNumber = [[UILabel alloc] initWithFrame:CGRectMake(18, 48 + 65*(i), 18, 18)];
                todoNumber.text = [NSString stringWithFormat:@"%d.", i+1];
                todoNumber.font = [UIFont fontWithName:@"MyriadPro-Regular" size:12];
                [self.todosView addSubview:todoNumber];
                
                UIButton* checkBox = [UIButton buttonWithType:UIButtonTypeCustom];
                checkBox.tag = i;
                [checkBox setFrame:CGRectMake(247, 50+65*(i), 16, 16)];
                [checkBox setBackgroundImage:[UIImage imageNamed:@"babyq_circle.png"] forState:UIControlStateNormal];
                [checkBox addTarget:self action:@selector(markTodoCompleted:) forControlEvents:UIControlEventTouchUpInside];
                [self.todosView addSubview:checkBox];
                
            }
            NSUInteger numberOfTodos = [todosArray count];
            if (numberOfTodos > 4)
            {
                [self.scrollView setContentSize:CGSizeMake(320, 1500+(numberOfTodos-4))];
                [self.todosView setFrame:CGRectMake(todosView.frame.origin.x, todosView.frame.origin.y, todosView.frame.size.width, todosView.frame.size.height+65*(numberOfTodos-4))];
                [completedTodosButton setFrame:CGRectMake(completedTodosButton.frame.origin.x, completedTodosButton.frame.origin.y +65*(numberOfTodos-4), completedTodosButton.frame.size.width, completedTodosButton.frame.size.height)];
            }
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString* dateString = todosArray[0][@"DueDate"];
            NSDate* date = [dateFormatter dateFromString:dateString];
            [dateFormatter setDateFormat:@"MM.dd.yyyy"];
            todosDueDate.text = [NSString stringWithFormat:@"DUE %@", [dateFormatter stringFromDate:date]];
        } else {
            todosDueDate.hidden = YES;
            UILabel* todoLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 39, 240, 24)];
            todoLabel.textAlignment = NSTextAlignmentCenter;
            todoLabel.text = @"All To-Dos Completed.";
            todoLabel.font = [UIFont fontWithName:@"Bebas" size:17];
            [self.todosView addSubview:todoLabel];
        }
    } else if (connection == setTodoCompletedConnection)
    {
        NSString* json_response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSData* json_data = [json_response dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary* setCompletedResponse = [NSJSONSerialization JSONObjectWithData: json_data
                                                                             options: NSJSONReadingMutableContainers
                                                                               error: nil];
        if ([setCompletedResponse[@"VALID"] isEqualToString:@"Success"])
        {
            NSString* title = @"TO-DO COMPLETED!";
            NSString* message = @"Congrats! You've just taken another step closer to improving your babyQ. Keep it up!";
            NSString* buttonTitle = @"OKAY, I GOT IT!";
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:buttonTitle otherButtonTitles:nil];
            alert.tag = 0;
            [alert dismissWithClickedButtonIndex:0 animated:YES];
            [alert show];
        }
    }
}

- (void) markTodoCompleted:(UIButton*)sender
{
    NSString* api_token = [(AppDelegate *)[[UIApplication sharedApplication] delegate] api_token];
    NSString* user_email = [(AppDelegate *)[[UIApplication sharedApplication] delegate] user_email];
    Constants* constants = [[Constants alloc] init];
    NSString* todosURL = [[constants.HOST stringByAppendingString:constants.VERSION] stringByAppendingString:constants.SET_TODO_COMPLETED_PATH];
    NSString* postData = [[[@"ApiToken=" stringByAppendingString:api_token] stringByAppendingString:@"&Email="] stringByAppendingString:user_email];
    postData = [[postData stringByAppendingString:@"&ToDoId="] stringByAppendingString:todosArray[sender.tag][@"ToDoId"] ];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:todosURL]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    setTodoCompletedConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    for (UIView *subview in self.scrollView.subviews) {
        if ([subview isKindOfClass:[UIButton class]])
        {
            UIButton* button = (UIButton*) subview;
            if (button.tag >= 0)
                [button setBackgroundImage:[UIImage imageNamed:@"babyq_circle.png"] forState:UIControlStateNormal];
        }
    }
    [sender setBackgroundImage:[UIImage imageNamed:@"babyq_circle_orange.png"] forState:UIControlStateNormal];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"ERROR current");
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"finished loading current score");
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

-(IBAction) getCompletedTodos
{
    UIStoryboard* todosStoryboard = [UIStoryboard storyboardWithName:@"Todos" bundle:nil];
    UIViewController* completedTodos = [todosStoryboard instantiateViewControllerWithIdentifier:@"CompletedTodosView"];
    [self.navigationController pushViewController:completedTodos animated:YES];
    self.navigationController.navigationBarHidden = YES;
}

-(IBAction) getTipHistory
{
    UIStoryboard* todosStoryboard = [UIStoryboard storyboardWithName:@"Todos" bundle:nil];
    UIViewController* completedTodos = [todosStoryboard instantiateViewControllerWithIdentifier:@"TipHistoryView"];
    [self.navigationController pushViewController:completedTodos animated:YES];
    self.navigationController.navigationBarHidden = YES;
}

- (IBAction)toggleTodosAndDaily:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
    
    if (selectedSegment == 0) {
        //toggle the correct view to be visible
        [todosView setHidden:NO];
        [dailyTipView setHidden:YES];
    }
    else{
        //toggle the correct view to be visible
        [todosView setHidden:YES];
        [dailyTipView setHidden:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

@implementation UILabel (CustomFontLabel)

-(void)awakeFromNib{
    float size = [self.font pointSize];
    self.font = [UIFont fontWithName:@"Bebas" size:size];
}

@end

@implementation UITextView (CustomFontLabel)

-(void)awakeFromNib{
    float size = [self.font pointSize];
    self.font = [UIFont fontWithName:@"MyriadPro-Regular" size:size];
}

@end
