//
//  ScoreProgressViewController.m
//  babyQ
//
//  Created by Chris Wood on 6/16/14.
//  Copyright (c) 2014 babyQ. All rights reserved.
//

#import "ScoreProgressViewController.h"

@interface ScoreProgressViewController ()

@end

@implementation ScoreProgressViewController

@synthesize scrollView,scoreLabel,todosView,dailyTipView,scoreHistoryData,scoreHistoryArray,todosData,todosArray,completedTodosButton,dailyTip,headerLabel,statusBarWhiteBG,headerButton1,headerButton2,totalScoreBig,lifestyleScore,nutritionScore,exerciseScore,stressScore,scoreDate,dailyTipDate,todosDueDate;

NSURLConnection* getScoreHistoryConnection;
NSURLConnection* toDosConnection;
NSURLConnection* dailyTipConnection;
NSURLConnection* setTodoCompletedConnection;
UIButton* currentPresentedScore;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.scrollView setContentSize:CGSizeMake(320, 1200)];
    [self.scrollView setBackgroundColor:[UIColor whiteColor]];
    [scoreLabel setTransform:CGAffineTransformMakeRotation(-M_PI / 2)];
    
    scoreHistoryData = [[NSMutableData alloc] init];
    
    NSString* api_token = [(AppDelegate *)[[UIApplication sharedApplication] delegate] api_token];
    NSString* user_email = [(AppDelegate *)[[UIApplication sharedApplication] delegate] user_email];
    Constants* constants = [[Constants alloc] init];
    NSString* getCurrentScoreURL = [[constants.HOST stringByAppendingString:constants.VERSION] stringByAppendingString:constants.GET_SCORE_HISTORY_PATH];
    NSString* postData = [[[@"ApiToken=" stringByAppendingString:api_token] stringByAppendingString:@"&Email="] stringByAppendingString:user_email];
    NSMutableURLRequest *currentScoreRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:getCurrentScoreURL]];
    [currentScoreRequest setHTTPMethod:@"POST"];
    [currentScoreRequest setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    getScoreHistoryConnection = [[NSURLConnection alloc] initWithRequest:currentScoreRequest delegate:self];
    
    NSString* dailyTipURL = [[constants.HOST stringByAppendingString:constants.VERSION] stringByAppendingString:constants.GET_DAILY_TIP_PATH];
    NSMutableURLRequest *dailyTipRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:dailyTipURL]];
    [dailyTipRequest setHTTPMethod:@"POST"];
    [dailyTipRequest setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    dailyTipConnection = [[NSURLConnection alloc] initWithRequest:dailyTipRequest delegate:self];
    
    todosData = [[NSMutableData alloc] init];
    NSString* toDosURL = [[constants.HOST stringByAppendingString:constants.VERSION] stringByAppendingString:constants.GET_CURRENT_TODOS_PATH];
    NSMutableURLRequest *toDosRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:toDosURL]];
    [toDosRequest setHTTPMethod:@"POST"];
    [toDosRequest setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    toDosConnection = [[NSURLConnection alloc] initWithRequest:toDosRequest delegate:self];
    
    dailyTipView.hidden = YES;
    
    self.totalScoreBig.font = [UIFont fontWithName:@"Bebas" size:61];
    self.lifestyleScore.font = [UIFont fontWithName:@"Bebas" size:18];
    self.exerciseScore.font = [UIFont fontWithName:@"Bebas" size:18];
    self.nutritionScore.font = [UIFont fontWithName:@"Bebas" size:18];
    self.stressScore.font = [UIFont fontWithName:@"Bebas" size:18];
    self.goodWorkLabel.font = [UIFont fontWithName:@"MyriadPro-Regular" size:14];

    self.bigTotalLabel.font = [UIFont fontWithName:@"MyriadPro-Regular" size:18];
    self.lifestyleLabel.font = [UIFont fontWithName:@"MyriadPro-Semibold" size:10];
    self.exerciseLabel.font = [UIFont fontWithName:@"MyriadPro-Semibold" size:10];
    self.nutritionLabel.font = [UIFont fontWithName:@"MyriadPro-Semibold" size:10];
    self.stressLabel.font = [UIFont fontWithName:@"MyriadPro-Semibold" size:10];
    self.tipHistoryButton.titleLabel.font = [UIFont fontWithName:@"MyriadPro-Regular" size:14];
}

- (void) viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data
{
    if (connection == getScoreHistoryConnection)
    {
        [scoreHistoryData appendData:data];
    } else if (connection == dailyTipConnection)
    {
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
        [todosData appendData:data];
        
    } else if (connection == setTodoCompletedConnection)
    {
        NSString* json_response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSData* json_data = [json_response dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary* setCompletedResponse = [NSJSONSerialization JSONObjectWithData: json_data
                                                                             options: NSJSONReadingMutableContainers
                                                                               error: nil];
        if ([setCompletedResponse[@"VALID"] isEqualToString:@"Success"])
        {
            [self performSelector:@selector(refreshTodosView) withObject:nil afterDelay:1.0];
        }
    }
}

- (void) refreshTodosView
{
    for (UIView *subview in self.todosView.subviews) {
        if (subview.tag < 10)
        {
            [subview removeFromSuperview];
        }
    }
    todosData = [[NSMutableData alloc] init];
    NSString* api_token = [(AppDelegate *)[[UIApplication sharedApplication] delegate] api_token];
    NSString* user_email = [(AppDelegate *)[[UIApplication sharedApplication] delegate] user_email];
    Constants* constants = [[Constants alloc] init];
    NSString* toDosURL = [[constants.HOST stringByAppendingString:constants.VERSION] stringByAppendingString:constants.GET_CURRENT_TODOS_PATH];
    NSString* postData = [[[@"ApiToken=" stringByAppendingString:api_token] stringByAppendingString:@"&Email="] stringByAppendingString:user_email];
    NSMutableURLRequest *toDosRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:toDosURL]];
    [toDosRequest setHTTPMethod:@"POST"];
    [toDosRequest setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    toDosConnection = [[NSURLConnection alloc] initWithRequest:toDosRequest delegate:self];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (connection == getScoreHistoryConnection)
    {
        NSMutableArray* pastScores = [[NSMutableArray alloc] init];
        NSString* json_response = [[NSString alloc] initWithData:scoreHistoryData encoding:NSUTF8StringEncoding];
        NSData* json_data = [json_response dataUsingEncoding:NSUTF8StringEncoding];
        scoreHistoryArray = [NSJSONSerialization JSONObjectWithData: json_data
                                                              options: NSJSONReadingMutableContainers
                                                                error: nil];
        
        for (int i = 0; i < [scoreHistoryArray count]; i++)
        {
            [pastScores addObject:scoreHistoryArray[i][@"OverallScore"]];
        }
        
        ScoreProgressGraphView* graphView = [[ScoreProgressGraphView alloc] initWithFrame:CGRectMake(52, 84, 248, 184)];
        [graphView setContentSize:CGSizeMake(50*[pastScores count], 184)];
        graphView.scrollEnabled = YES;
        graphView.yValues = pastScores;
        [graphView calc_info];
        for (int i = 0; i < [graphView.circles count]; i++)
        {
            UIButton* pastScore = graphView.circles[i];
            [pastScore addTarget:self action:@selector(clickedPastScore:) forControlEvents:UIControlEventTouchUpInside];
            [graphView addSubview:pastScore];
        }
        [self clickedPastScore:graphView.circles[[graphView.circles count] -1]];
        graphView.contentOffset = CGPointMake(50*[pastScores count]-248, 0);
        [self.scrollView addSubview:graphView];
        [self.scrollView bringSubviewToFront:headerLabel];
        [self.scrollView bringSubviewToFront:headerButton1];
        [self.scrollView bringSubviewToFront:headerButton2];
        [self.scrollView bringSubviewToFront:statusBarWhiteBG];
        
    } else if (connection == toDosConnection)
    {
        NSString* json_response = [[NSString alloc] initWithData:todosData encoding:NSUTF8StringEncoding];
        if ([json_response rangeOfString:@"ERROR"].location == NSNotFound)
        {
            NSData* json_data = [json_response dataUsingEncoding:NSUTF8StringEncoding];
            
            todosArray = [NSJSONSerialization JSONObjectWithData: json_data
                                                         options: NSJSONReadingMutableContainers
                                                           error: nil];
            for (int i = 0; i < [todosArray count]; i++)
            {
                UITextView* nextTodo = [[UITextView alloc] initWithFrame:CGRectMake(37, 42 + 65*(i), 189, 54)];
                nextTodo.backgroundColor = [UIColor clearColor];
                nextTodo.editable = NO;
                nextTodo.userInteractionEnabled = NO;
                nextTodo.textColor = [UIColor colorWithRed:120.0/255.0f green:120.0/255.0f blue:120.0/255.0f alpha:1.0f];
                nextTodo.font = [UIFont fontWithName:@"MyriadPro-Regular" size:12];
                if (todosArray[i][@"Body"] != (id)[NSNull null])
                    nextTodo.text = todosArray[i][@"Body"];
                [self.todosView addSubview:nextTodo];
                
                UILabel* todoNumber = [[UILabel alloc] initWithFrame:CGRectMake(18, 48 + 65*(i), 18, 18)];
                todoNumber.text = @"\u2022";
                todoNumber.font = [UIFont fontWithName:@"MyriadPro-Regular" size:12];
                todoNumber.textColor = [UIColor colorWithRed:120.0/255.0f green:120.0/255.0f blue:120.0/255.0f alpha:1.0f];
                [self.todosView addSubview:todoNumber];
                
                UIButton* checkBox = [UIButton buttonWithType:UIButtonTypeCustom];
                checkBox.tag = i;
                [checkBox setFrame:CGRectMake(247, 46+65*(i), 32, 32)];
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
            todoLabel.text = @"All To-Do's Completed";
            todoLabel.textColor = [UIColor colorWithRed:120.0/255.0f green:120.0/255.0f blue:120.0/255.0f alpha:1.0f];
            todoLabel.font = [UIFont fontWithName:@"Bebas" size:17];
            [self.todosView addSubview:todoLabel];
        }
    }
}

- (IBAction)openSideSwipeView
{
    [(MMDrawerController* )self.navigationController.topViewController openDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateFloatingViewFrame];
}

- (void)updateFloatingViewFrame {
    CGPoint contentOffset = scrollView.contentOffset;
    
    // The floating view should be at its original position or at top of
    // the visible area, whichever is lower.
    CGFloat labelY = contentOffset.y + 20;
    CGFloat buttonY = contentOffset.y + 30;
    
    CGRect labelFrame = headerLabel.frame;
    CGRect button1Frame = headerButton1.frame;
    CGRect button2Frame = headerButton2.frame;
    CGRect statusBGFrame = statusBarWhiteBG.frame;
    if (labelY != labelFrame.origin.y) {
        labelFrame.origin.y = labelY;
        button1Frame.origin.y = buttonY;
        button2Frame.origin.y = buttonY;
        statusBGFrame.origin.y = contentOffset.y;
        statusBarWhiteBG.frame = statusBGFrame;
        headerLabel.frame = labelFrame;
        headerButton1.frame = button1Frame;
        headerButton2.frame = button2Frame;
    }
}

- (void) clickedPastScore:(UIButton*)sender
{
    totalScoreBig.text = scoreHistoryArray[sender.tag][@"OverallScore"];
    lifestyleScore.text = scoreHistoryArray[sender.tag][@"LifestyleScore"];
    exerciseScore.text = scoreHistoryArray[sender.tag][@"ExerciseScore"];
    nutritionScore.text = scoreHistoryArray[sender.tag][@"NutritionScore"];
    stressScore.text = scoreHistoryArray[sender.tag][@"StressScore"];
    
    UILabel* pastScore = [[UILabel alloc] initWithFrame:CGRectMake(6, 6, 20, 20)];
    pastScore.font = [UIFont fontWithName:@"Bebas" size:10];
    pastScore.text = scoreHistoryArray[sender.tag][@"OverallScore"];
    pastScore.textColor = [UIColor whiteColor];
    pastScore.textAlignment = NSTextAlignmentCenter;
    pastScore.tag = 99;
    [sender setFrame:CGRectMake(sender.frame.origin.x-8, sender.frame.origin.y-8, 32, 32)];
    [sender addSubview:pastScore];
    if (currentPresentedScore != nil)
    {
        for (UIView* view in currentPresentedScore.subviews) {
            if (view.tag == 99)
                [view removeFromSuperview];
        }
        [currentPresentedScore setFrame:CGRectMake(currentPresentedScore.frame.origin.x+8, currentPresentedScore.frame.origin.y+8, 16, 16)];
    }
    currentPresentedScore = sender;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* dateString = scoreHistoryArray[sender.tag][@"SurveyFinished"];
    NSDate* date = [dateFormatter dateFromString:dateString];
    [dateFormatter setDateFormat:@"MM.dd.yyyy"];
    scoreDate.font = [UIFont fontWithName:@"Bebas" size:18];
    scoreDate.text = [dateFormatter stringFromDate:date];
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
    
    [sender setBackgroundImage:[UIImage imageNamed:@"babyq_circle_orange.png"] forState:UIControlStateNormal];
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

-(IBAction) getTipHistory
{
    UIStoryboard* todosStoryboard = [UIStoryboard storyboardWithName:@"Todos" bundle:nil];
    UIViewController* completedTodos = [todosStoryboard instantiateViewControllerWithIdentifier:@"TipHistoryView"];
    [self.navigationController pushViewController:completedTodos animated:YES];
    self.navigationController.navigationBarHidden = YES;
}

-(IBAction) getCompletedTodos
{
    UIStoryboard* todosStoryboard = [UIStoryboard storyboardWithName:@"Todos" bundle:nil];
    UIViewController* completedTodos = [todosStoryboard instantiateViewControllerWithIdentifier:@"CompletedTodosView"];
    [self.navigationController pushViewController:completedTodos animated:YES];
    self.navigationController.navigationBarHidden = YES;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
