//
//  CompletedTodosViewController.h
//  babyQ
//
//  Created by Chris Wood on 6/17/14.
//  Copyright (c) 2014 babyQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Constants.h"

@interface CompletedTodosViewController : UIViewController

@property (nonatomic, retain) IBOutlet UIScrollView* scrollView;
@property (nonatomic, retain) IBOutlet UIImageView* background;
@property (nonatomic, retain) NSArray* completedTodosArray;
@property (nonatomic, retain) NSMutableData* completedTodosData;

@end
