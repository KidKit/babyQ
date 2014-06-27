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

@property (nonatomic, retain) NSArray* todosArray;
@property (nonatomic, retain) NSMutableData* todosData;

@property (nonatomic, retain) IBOutlet UILabel* todosDueDate;

@property (nonatomic, retain) IBOutlet UIButton* completedTodosButton;

-(IBAction) getCompletedTodos;
-(IBAction)startSurvey;

@end
