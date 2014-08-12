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

@synthesize scrollView,currentScoreData,headerLabel,statusBarWhiteBG,headerButton1,headerButton2,todosView,dailyTipView,dailyTip,completedTodosButton,todosData,todosArray,todaysDate,scoreSlider,scoreBar,dailyTipDate,todosDueDate,goodWorkLabel,youImprovedLabel,tipHistoryButton,scrollDownLabel,offlineMessage;

BOOL internet;
NSURLConnection* currentScoreConnection;
NSURLConnection* dailyTipConnection;
NSURLConnection* toDosConnection;
NSURLConnection* setTodoCompletedConnection;
int originalHeaderLabelY = 20;
int originalStatusBGY = 0;
int originalHeaderButtonY = 30;

CGRect scoreSliderFrame;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self testInternetConnection];
    offlineMessage.font = [UIFont fontWithName:@"MyriadPro-Semibold" size:15];
	[self.scrollView setContentSize:CGSizeMake(320, 1390)];
    [self.scrollView setBackgroundColor:[UIColor whiteColor]];
    dailyTipView.hidden = YES;
    
    todosDueDate.font = [UIFont fontWithName:@"MyriadPro-Semibold" size:15];
    
    headerButton1.imageEdgeInsets = UIEdgeInsetsMake(4, 4, 4, 4);
    headerButton2.imageEdgeInsets = UIEdgeInsetsMake(4, 4, 4, 4);
    
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE, MMM dd"];
    todaysDate.text = [dateFormatter stringFromDate:now];
    todaysDate.font = [UIFont fontWithName:@"Bebas" size:19];
    
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
    
    todosData = [[NSMutableData alloc] init];
    NSString* toDosURL = [[constants.HOST stringByAppendingString:constants.VERSION] stringByAppendingString:constants.GET_CURRENT_TODOS_PATH];
    NSMutableURLRequest *toDosRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:toDosURL]];
    [toDosRequest setHTTPMethod:@"POST"];
    [toDosRequest setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    toDosConnection = [[NSURLConnection alloc] initWithRequest:toDosRequest delegate:self];
    
    self.totalScoreBig.font = [UIFont fontWithName:@"Bebas" size:62];
    self.totalScoreSmall.font = [UIFont fontWithName:@"Bebas" size:19];
    self.lifestyleScore.font = [UIFont fontWithName:@"Bebas" size:19];
    self.exerciseScore.font = [UIFont fontWithName:@"Bebas" size:19];
    self.nutritionScore.font = [UIFont fontWithName:@"Bebas" size:19];
    self.stressScore.font = [UIFont fontWithName:@"Bebas" size:19];
    self.deltaBlurb.font = [UIFont fontWithName:@"MyriadPro-Regular" size:15];
    self.delta.font = [UIFont fontWithName:@"Bebas" size:62];
    self.goodWorkLabel.font = [UIFont fontWithName:@"MyriadPro-Regular" size:15];
    self.scrollDownLabel.font = [UIFont fontWithName:@"MyriadPro-Regular" size:15];
    self.youImprovedLabel.font = [UIFont fontWithName:@"MyriadPro-Regular" size:14];
    self.workBlurb.font = [UIFont fontWithName:@"MyriadPro-Regular" size:15];
    self.bigTotalLabel.font = [UIFont fontWithName:@"MyriadPro-Regular" size:19];
    self.smallTotalLabel.font = [UIFont fontWithName:@"MyriadPro-Semibold" size:12];
    self.lifestyleLabel.font = [UIFont fontWithName:@"MyriadPro-Semibold" size:12];
    self.exerciseLabel.font = [UIFont fontWithName:@"MyriadPro-Semibold" size:12];
    self.nutritionLabel.font = [UIFont fontWithName:@"MyriadPro-Semibold" size:12];
    self.stressLabel.font = [UIFont fontWithName:@"MyriadPro-Semibold" size:12];
    self.tipHistoryButton.titleLabel.font = [UIFont fontWithName:@"MyriadPro-Regular" size:15];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanScoreSlider:)];
    [scoreSlider addGestureRecognizer:panGesture];
    scoreSliderFrame =  CGRectMake(30, 405, 24, 24);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(tappedScoreBar:)];
    
    [scoreBar addGestureRecognizer:tap];
}

- (void) tappedScoreBar:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        CGPoint location = [sender locationInView:sender.view.superview];
        [self adjustSliderToPoint:CGRectMake(location.x, 405, 24, 24)];
    }
}

-(void)updateScores:(CGRect) newFrame
{
    if (newFrame.origin.x < 60)
    {
        self.deltaBlurb.text = currentScoreData[@"OverallMessage"];
        if ([currentScoreData[@"OverallDelta"] integerValue] >= 0)
        {
            self.delta.text = [NSString stringWithFormat:@"+%@", currentScoreData[@"OverallDelta"] ];
            self.youImprovedLabel.text = @"YOU IMPROVED FROM LAST TIME!";
        }
        else
        {
            self.delta.text = [NSString stringWithFormat:@"%@", currentScoreData[@"OverallDelta"] ];
            self.youImprovedLabel.text = @"Your score went down from last time...";
        }
        self.bigTotalLabel.text = @"TOTAL";
        self.totalScoreBig.text = currentScoreData[@"OverallScore"];
    }
    else if (newFrame.origin.x < 118)
    {
        self.deltaBlurb.text = currentScoreData[@"LifestyleMessage"];
        if ([currentScoreData[@"LifestyleDelta"] integerValue] >= 0)
        {
            self.delta.text = [NSString stringWithFormat:@"+%@", currentScoreData[@"LifestyleDelta"]];
            self.youImprovedLabel.text = @"YOU IMPROVED FROM LAST TIME!";
        }
        else
        {
            self.delta.text = [NSString stringWithFormat:@"%@", currentScoreData[@"LifestyleDelta"]];
            self.youImprovedLabel.text = @"Your score went down from last time...";
        }
        self.bigTotalLabel.text = @"LIFESTYLE";
        self.totalScoreBig.text = currentScoreData[@"LifestyleScore"];
    }
    else if (newFrame.origin.x < 178)
    {
        self.deltaBlurb.text = currentScoreData[@"ExerciseMessage"];
        if ([currentScoreData[@"ExerciseDelta"] integerValue] >= 0)
        {
            self.delta.text = [NSString stringWithFormat:@"+%@", currentScoreData[@"ExerciseDelta"]];
            self.youImprovedLabel.text = @"YOU IMPROVED FROM LAST TIME!";
        }
        else
        {
            self.delta.text = [NSString stringWithFormat:@"%@", currentScoreData[@"ExerciseDelta"]];
            self.youImprovedLabel.text = @"Your score went down from last time...";
        }
        self.bigTotalLabel.text = @"EXERCISE";
        self.totalScoreBig.text = currentScoreData[@"ExerciseScore"];
    }
    else if (newFrame.origin.x < 236)
    {
        self.deltaBlurb.text = currentScoreData[@"NutritionMessage"];
        
        if ([currentScoreData[@"NutritionDelta"] integerValue] >= 0)
        {
            self.delta.text = [NSString stringWithFormat:@"+%@", currentScoreData[@"NutritionDelta"]];
            self.youImprovedLabel.text = @"YOU IMPROVED FROM LAST TIME!";
        }
        else
        {
            self.delta.text = [NSString stringWithFormat:@"%@", currentScoreData[@"NutritionDelta"]];
            self.youImprovedLabel.text = @"Your score went down from last time...";
        }
        self.bigTotalLabel.text = @"NURTITION";
        self.totalScoreBig.text = currentScoreData[@"NutritionScore"];
    }
    else if (newFrame.origin.x < 300)
    {
        self.deltaBlurb.text = currentScoreData[@"StressMessage"];
        if ([currentScoreData[@"StressDelta"] integerValue] >= 0)
        {
            self.delta.text = [NSString stringWithFormat:@"+%@", currentScoreData[@"StressDelta"]];
            self.youImprovedLabel.text = @"YOU IMPROVED FROM LAST TIME!";
        }
        else
        {
            self.delta.text = [NSString stringWithFormat:@"%@", currentScoreData[@"StressDelta"]];
            self.youImprovedLabel.text = @"Your score went down from last time...";
        }
        self.bigTotalLabel.text = @"STRESS";
        self.totalScoreBig.text = currentScoreData[@"StressScore"];
    }
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
        [self updateScores:newFrame];
    }
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        [self adjustSliderToPoint:newFrame];
    }
}

- (void) adjustSliderToPoint: (CGRect) newFrame
{
    if (newFrame.origin.x <= 26)
        scoreSlider.frame = scoreSliderFrame = CGRectMake(30, 405, 24, 24);
    else if (newFrame.origin.x >= 270)
        scoreSlider.frame = scoreSliderFrame =  CGRectMake(264, 405, 24, 24);
    else
    {
        if (newFrame.origin.x < 60)
        {
            scoreSlider.frame = scoreSliderFrame = CGRectMake(30, 405, 24, 24);
        }
        else if (newFrame.origin.x < 118)
        {
            scoreSlider.frame = scoreSliderFrame = CGRectMake(87, 405, 24, 24);
        }
        else if (newFrame.origin.x < 178)
        {
            scoreSlider.frame = scoreSliderFrame = CGRectMake(144, 405, 24, 24);
        }
        else if (newFrame.origin.x < 236)
        {
            scoreSlider.frame = scoreSliderFrame = CGRectMake(205, 405, 24, 24);
        }
        else if (newFrame.origin.x < 276)
        {
            scoreSlider.frame = scoreSliderFrame = CGRectMake(264, 405, 24, 24);
        }
    }
    [self updateScores:newFrame];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data
{
    if (connection == currentScoreConnection)
    {
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
            self.nutritionScore.text = currentScoreData[@"NutritionScore"];
            self.stressScore.text = currentScoreData[@"StressScore"];
            self.deltaBlurb.text = currentScoreData[@"OverallMessage"];
            int delta = [currentScoreData[@"OverallDelta"] intValue];
            if (delta >= 0)
                self.delta.text = [NSString stringWithFormat:@"+%@", currentScoreData[@"OverallDelta"]];
            else
            {
                self.delta.text = [NSString stringWithFormat:@"%d",delta];
                self.youImprovedLabel.text = @"Your score went down from last time...";
            }
        } else {
            UIStoryboard* getScoreStoryboard = [UIStoryboard storyboardWithName:@"GetScore" bundle:nil];
            UIViewController* getScorePopup = [getScoreStoryboard instantiateInitialViewController];
            getScorePopup.modalPresentationStyle = UIModalPresentationCurrentContext;
            getScorePopup.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
            
            self.navigationController.modalPresentationStyle = UIModalPresentationCurrentContext;
            self.navigationController.view.userInteractionEnabled = NO;
            [self.navigationController presentViewController:getScorePopup animated:NO completion:^(){
                //[getScorePopup.view setFrame:CGRectMake(35, 100, 250, 260)];
            }];
        }
    } else if (connection ==  dailyTipConnection)
    {
        NSString* json_response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSData* json_data = [json_response dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary* json_dictionary = [NSJSONSerialization JSONObjectWithData: json_data
                                                                        options: NSJSONReadingMutableContainers
                                                                          error: nil];
        dailyTip.text = json_dictionary[@"Body"];
        dailyTip.font = [UIFont fontWithName:@"MyriadPro-Semibold" size:15];
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

- (void) markTodoCompleted:(UITapGestureRecognizer*)sender
{
    UIView* touchedView;
    if (![sender isKindOfClass:[UIButton class]])
        touchedView = sender.view;
    else
        touchedView = (UIView*)sender;
    for (UIView* view in [todosView subviews])
    {
        if ([view isKindOfClass:[UIButton class]] && view.tag == touchedView.tag)
            [(UIButton*)view setBackgroundImage:[UIImage imageNamed:@"babyq_circle_orange.png"] forState:UIControlStateNormal];
        
    }
    
    NSString* api_token = [(AppDelegate *)[[UIApplication sharedApplication] delegate] api_token];
    NSString* user_email = [(AppDelegate *)[[UIApplication sharedApplication] delegate] user_email];
    Constants* constants = [[Constants alloc] init];
    NSString* todosURL = [[constants.HOST stringByAppendingString:constants.VERSION] stringByAppendingString:constants.SET_TODO_COMPLETED_PATH];
    NSString* postData = [[[@"ApiToken=" stringByAppendingString:api_token] stringByAppendingString:@"&Email="] stringByAppendingString:user_email];
    postData = [[postData stringByAppendingString:@"&ToDoId="] stringByAppendingString:todosArray[touchedView.tag][@"ToDoId"] ];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:todosURL]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    setTodoCompletedConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (connection == toDosConnection)
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
                UITextView* nextTodo = [[UITextView alloc] initWithFrame:CGRectMake(32, 40 + 60*(i), 210, 52)];
                nextTodo.backgroundColor = [UIColor clearColor];
                nextTodo.editable = NO;
                nextTodo.userInteractionEnabled = YES;
                nextTodo.textColor = [UIColor colorWithRed:120.0/255.0f green:120.0/255.0f blue:120.0/255.0f alpha:1.0f];
                nextTodo.font = [UIFont fontWithName:@"MyriadPro-Regular" size:15];
                if (todosArray[i][@"Body"] != (id)[NSNull null])
                    nextTodo.text = todosArray[i][@"Body"];
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                               initWithTarget:self
                                               action:@selector(markTodoCompleted:)];
                
                [nextTodo addGestureRecognizer:tap];
                nextTodo.tag = i;
                [self.todosView addSubview:nextTodo];
                
                UILabel* todoNumber = [[UILabel alloc] initWithFrame:CGRectMake(18, 48 + 60*(i), 18, 18)];
                todoNumber.text = @"\u2022";
                todoNumber.textColor = [UIColor colorWithRed:120.0/255.0f green:120.0/255.0f blue:120.0/255.0f alpha:1.0f];
                todoNumber.font = [UIFont fontWithName:@"MyriadPro-Regular" size:15];
                todoNumber.tag = i;
                [self.todosView addSubview:todoNumber];
                
                UIButton* checkBox = [UIButton buttonWithType:UIButtonTypeCustom];
                checkBox.tag = i;
                [checkBox setFrame:CGRectMake(247, 42+60*(i), 32, 32)];
                [checkBox setBackgroundImage:[UIImage imageNamed:@"babyq_circle.png"] forState:UIControlStateNormal];
                [checkBox addTarget:self action:@selector(markTodoCompleted:) forControlEvents:UIControlEventTouchUpInside];
                [self.todosView addSubview:checkBox];
                
            }
            NSUInteger numberOfTodos = [todosArray count];
            if (numberOfTodos > 4)
            {
                [self.scrollView setContentSize:CGSizeMake(320, 1500+(numberOfTodos-4))];
                [self.todosView setFrame:CGRectMake(todosView.frame.origin.x, todosView.frame.origin.y, todosView.frame.size.width, todosView.frame.size.height+60*(numberOfTodos-4))];
                [completedTodosButton setFrame:CGRectMake(completedTodosButton.frame.origin.x, completedTodosButton.frame.origin.y +60*(numberOfTodos-4), completedTodosButton.frame.size.width, completedTodosButton.frame.size.height)];
            }
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString* dateString = todosArray[0][@"DueDate"];
            NSDate* date = [dateFormatter dateFromString:dateString];
            NSCalendar *gregorian = [[NSCalendar alloc]
                                     initWithCalendarIdentifier:NSGregorianCalendar];
            NSDateComponents *comps = [gregorian components: NSDayCalendarUnit
                                                   fromDate: [NSDate date]
                                                     toDate: date
                                                    options: 0];
            int days = (int) [comps day];
            todosDueDate.text = [NSString stringWithFormat:@"DUE %i days from now", days];
        } else {
            todosDueDate.hidden = YES;
            UILabel* todoLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 39, 240, 72)];
            todoLabel.numberOfLines = 3;
            todoLabel.textAlignment = NSTextAlignmentCenter;
            todoLabel.text = @"Congratulations! You've just completed your recommended list of to-do's";
            todoLabel.textColor = [UIColor colorWithRed:120.0/255.0f green:120.0/255.0f blue:120.0/255.0f alpha:1.0f];
            todoLabel.font = [UIFont fontWithName:@"MyriadPro-Bold" size:18];
            [self.todosView addSubview:todoLabel];
        }
    }
}

- (void) viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
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

- (void)testInternetConnection
{
    Reachability* internetReachableFoo = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    // Internet is reachable
    internetReachableFoo.reachableBlock = ^(Reachability*reach)
    {
        internet = YES;
        offlineMessage.hidden = YES;
        headerButton2.enabled = YES;
        completedTodosButton.enabled = YES;
        tipHistoryButton.enabled = YES;
    };
    
    // Internet is not reachable
    internetReachableFoo.unreachableBlock = ^(Reachability*reach)
    {
        internet = NO;
        offlineMessage.hidden = NO;
        headerButton2.enabled = NO;
        completedTodosButton.enabled = NO;
        tipHistoryButton.enabled = NO;
    };
    
    [internetReachableFoo startNotifier];
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
    self.font = [UIFont fontWithName:@"MyriadPro-Bold" size:size];
}

@end

@implementation UITextView (CustomFontLabel)

-(void)awakeFromNib{
    float size = [self.font pointSize];
    self.font = [UIFont fontWithName:@"MyriadPro-Regular" size:size];
}

@end
