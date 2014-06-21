//
//  TodosViewController.h
//  babyQ
//
//  Created by Chris Wood on 6/17/14.
//  Copyright (c) 2014 babyQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SurveyViewController.h"

@interface TodosViewController : UIViewController

@property (nonatomic, retain) IBOutlet UITextView* toDo1;
@property (nonatomic, retain) IBOutlet UITextView* toDo2;
@property (nonatomic, retain) IBOutlet UITextView* toDo3;
@property (nonatomic, retain) IBOutlet UITextView* toDo4;
@property (nonatomic, retain) NSArray* todosArray;

@property (nonatomic, retain) IBOutlet UIButton* completedTodosButton;

-(IBAction) getCompletedTodos;
-(IBAction)startSurvey;

@end
